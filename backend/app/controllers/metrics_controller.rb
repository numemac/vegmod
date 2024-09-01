class MetricsController < ApplicationController
  
  def index
    subject_class = params[:subject_class]
    subject_id = params[:subject_id]
    measure = params[:measure]
    interval = params[:interval]
    unit = params[:unit]

    unless subject_class && subject_id && measure && interval && unit
      render json: { error: "Missing required parameters" }, status: :bad_request
      return
    end

    # validate subject_class is a string
    unless subject_class.is_a?(String) && subject_class.length > 0
      render json: { error: "Subject class must be a string" }, status: :bad_request
      return
    end

    # valiate subject_id is an integer
    unless subject_id.to_i.to_s == subject_id && subject_id.to_i > 0
      render json: { error: "Subject ID must be a positive integer" }, status: :bad_request
      return
    end

    # validate measure is a string
    unless measure.is_a?(String) && measure.length > 0
      render json: { error: "Measure must be a string" }, status: :bad_request
      return
    end

    # validate interval is an integer
    unless interval.to_i.to_s == interval && interval.to_i > 0
      render json: { error: "Interval must be a positive integer" }, status: :bad_request
      return
    end

    # validate unit is a string
    unless unit.is_a?(String) && unit.length > 0
      render json: { error: "Unit must be a string" }, status: :bad_request
      return
    end
    
    subject = subject_class.constantize.find(subject_id)
    if subject.nil?
      render json: { error: "Subject not found" }, status: :not_found
      return
    end

    unless subject.metricable?
      render json: { error: "Subject is not metricable" }, status: :bad_request
      return
    end

    metric = Metrics::Metric.find_by(
      measure: measure,
      unit: unit,
      interval: interval
    )

    unless metric
      render json: { error: "Metric not found" }, status: :not_found
      return
    end

    metric_subject = Metrics::MetricSubject.find_by(
      metric: metric,
      subject: subject
    )

    unless metric_subject
      render json: { error: "Metric subject not found" }, status: :not_found
      return
    end

    render json: metric_subject.data_points
  end
end