class Metrics::MetricSubjectDataPointBlueprint < Blueprinter::Base
  identifier :id

  fields :interval_start, :value
end