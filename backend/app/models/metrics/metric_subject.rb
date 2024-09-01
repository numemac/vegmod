class Metrics::MetricSubject < MetricRecord
  belongs_to :metric, class_name: Metrics::Metric.name, optional: false
  belongs_to :subject, polymorphic: true, optional: false

  has_many :data_points, class_name: Metrics::MetricSubjectDataPoint.name, dependent: :destroy
end