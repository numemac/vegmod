module Metricable
  extend ActiveSupport::Concern

  INTERVAL_MEASURES = [
    {
      column:   :created_at,
      term:     :created,
      measure:  :new
    },
    {
      column:   :updated_at,
      term:     :updated,
      measure:  :active
    }
  ]

  INTERVAL_UNITS = [:minute, :hour, :day, :week, :month, :year]

  def self.intervals
    INTERVAL_MEASURES.product(INTERVAL_UNITS).map do |measure, unit|
      {
        scope_name: "#{measure[:term]}_prior_#{unit}",
        measure_column: measure[:column],
        measure: measure[:measure],
        duration: 1.send(unit).to_i,
        interval_start: 1.send(unit).ago.send("beginning_of_#{unit}"),
      }
    end
  end

  included do

    has_many :metric_subjects, class_name: Metrics::MetricSubject.name, as: :subject, dependent: :destroy
    has_many :metrics, through: :metric_subjects, class_name: Metrics::Metric.name, dependent: :destroy

    scope :active_week, -> { where(updated_at: 1.week.ago..Time.current) }

    Metricable::intervals.each do |measure_unit|
      interval_scope measure_unit[:scope_name], -> {
        where(measure_unit[:measure_column] => measure_unit[:interval_start]..(measure_unit[:interval_start] + measure_unit[:duration]))
      }
    end

    def self.metricable?
      true
    end

    def metricable?
      self.class.metricable?
    end

    def default_metric
      metrics.first
    end

    # time_range_scope : symbol,
    # count_associations(:created_prior_week)
    def compute_metrics(interval_duration = 1.week)
      intervals = Metricable::intervals.select { |i| i[:duration] == interval_duration }
      raise ArgumentError, "Invalid interval duration" unless intervals.any?

      items = []

      associations = self.class.reflect_on_all_associations(:has_many).map(&:name).flatten

      intervals.each do |interval|
        associations.each do |association|
          items << metric_for_association(interval, association)
        end
      end

      items.compact
    end

    def metric_for_association(interval, association)
      association_records = self.send(association)

      unless association_records.respond_to?(interval[:scope_name])
        return nil
      end

      {
        metric: {
          measure: interval[:measure],
          unit: association,
          interval: interval[:duration],
        },
        subject: self,
        data_point: {
          interval_start: interval[:interval_start],
          value: association_records.send(interval[:scope_name]).count
        }
      }
    end

  end
end