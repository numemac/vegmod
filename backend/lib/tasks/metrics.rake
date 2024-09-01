def metrics_task(model, time)
  return unless model.metricable?
  model.active_week.each { |r| r.compute_metrics(time).each { |d| Metrics::Metric.create_from_data(d) } }
end

namespace :metrics do

  task hour: :environment do
    [ 
      Reddit::Subreddit,
      Reddit::Submission 
    ].each { |m| metrics_task(m, 1.hour) }
  end

  task day: :environment do
    [
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, 1.day) }
  end

  task week: :environment do
    [
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, 1.week) }
  end

  task month: :environment do
    [
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, 1.month) }
  end

  task year: :environment do
    [
      Reddit::Subreddit,
      Reddit::SubredditRedditor
    ].each { |m| metrics_task(m, 1.year) }
  end

end