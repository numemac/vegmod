def metrics_task(model, interval)
  return unless model.metricable?
  model.active_week.each { |r| r.compute_metrics(interval).each { |d| Metrics::Metric.create_from_data(d) } }
end

def score_task(interval)
  interval_start = Time.now

  Reddit::Subreddit.all.each { |r| record_score_metric(r, interval, interval_start) }

  if interval <= 1.day
    Reddit::Submission.created_week.each { |s| record_score_metric(s, interval, interval_start) }
    Reddit::Comment.created_week.each { |c| record_score_metric(c, interval, interval_start) }
  end
end

def record_score_metric(subject, interval, interval_start)
  total_metric = Metrics::Metric.find_or_create_by!(
    measure: "cumulative",
    unit: "score",
    interval: interval,
  )

  total_metric_subject = Metrics::MetricSubject.find_or_create_by!(
    metric: total_metric,
    subject: subject
  )

  previous_total_data_point = Metrics::MetricSubjectDataPoint.where(
    metric_subject: total_metric_subject
  ).last

  total_data_point = Metrics::MetricSubjectDataPoint.find_or_create_by!(
    metric_subject: total_metric_subject,
    interval_start: interval_start,
    value: subject.score,
  )
  
  return if previous_total_data_point.nil?

  seconds_since_last = interval_start - previous_total_data_point.interval_start

  # ensure interval is within +- 10% of expected interval
  # this is to prevent jumps when metrics have been missed
  return unless (interval - seconds_since_last).abs < interval * 0.1

  delta_metric = Metrics::Metric.find_or_create_by!(
    measure: "delta",
    unit: "score",
    interval: interval,
  )

  delta_metric_subject = Metrics::MetricSubject.find_or_create_by!(
    metric: delta_metric,
    subject: subject
  )

  delta_data_point = Metrics::MetricSubjectDataPoint.find_or_create_by!(
    metric_subject: delta_metric_subject,
    interval_start: interval_start,
    value: total_data_point.value - previous_total_data_point.value,
  )
end

namespace :metrics do

  task test: :environment do
    interval = 0.seconds
    score_task(interval)
  end

  task hour: :environment do
    interval = 1.hour

    [ 
      Reddit::Subreddit,
      Reddit::Submission 
    ].each { |m| metrics_task(m, interval) }

    score_task(interval)
  end

  task day: :environment do
    interval = 1.day
  
    [
      Reddit::Redditor,
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, interval) }

    score_task(interval)
  end

  task week: :environment do
    interval = 1.week

    [
      Reddit::Redditor,
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, interval) }

    score_task(interval)
  end

  task month: :environment do
    interval = 1.month

    [
      Reddit::Redditor,
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, interval) }

    score_task(interval)
  end

  task year: :environment do
    interval = 1.year

    [
      Reddit::Redditor,
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, interval) }

    score_task(interval)
  end

  # Removes old data points that probably aren't needed to analyze metrics
  # Do this to save space, reduce query times, and minimize data transfer.
  task clean: :environment do
    Metrics::Metric.all.each do |metric|
      expired_data_points = metric.expired_data_points
      expired_data_points.delete_all
    end
  end

end