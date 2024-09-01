class Metrics::Metric < MetricRecord
  validates :measure, presence: true
  validates :unit, presence: true
  validates :interval, presence: true

  has_many :metric_subjects, class_name: Metrics::MetricSubject.name, dependent: :destroy

  def self.create_from_data(data)
    metric = find_or_create_by(
      measure: data[:metric][:measure], 
      unit: data[:metric][:unit], 
      interval: data[:metric][:interval]
    )

    metric_subject = Metrics::MetricSubject.find_or_create_by(
      metric: metric,
      subject: data[:subject]
    )

    Metrics::MetricSubjectDataPoint.create!(
      metric_subject: metric_subject,
      interval_start: data[:data_point][:interval_start],
      value: data[:data_point][:value]
    )
  end
end