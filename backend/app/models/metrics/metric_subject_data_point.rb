class Metrics::MetricSubjectDataPoint < MetricRecord
  validates :interval_start, presence: true
  validates :value, presence: true

  belongs_to :metric_subject, class_name: Metrics::MetricSubject.name, optional: false
end