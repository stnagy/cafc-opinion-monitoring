web: bundle exec puma
worker: bundle exec sidekiq -e production -C /app/config/sidekiq.yml
clock: bundle exec clockwork /app/clock.rb
