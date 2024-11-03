class Metrics::Metric < MetricRecord
  validates :measure, presence: true
  validates :unit, presence: true
  validates :interval, presence: true

  has_many :metric_subjects, class_name: Metrics::MetricSubject.name, dependent: :destroy
  has_many :metric_subject_data_points, through: :metric_subjects, source: :data_points, class_name: Metrics::MetricSubjectDataPoint.name

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

    # unique key on metric_subject interval_start
    Metrics::MetricSubjectDataPoint.find_or_create_by(
      metric_subject: metric_subject,
      interval_start: data[:data_point][:interval_start]
    ) do |data_point|
      data_point.value = data[:data_point][:value]
    end
  end
  
  def expired_data_points
    # interval is in seconds
    life_time = interval * 30

    # the start time before which data points are considered expired
    expired_before = Time.now - life_time

    metric_subject_data_points.where('interval_start < ?', expired_before)
  end
end