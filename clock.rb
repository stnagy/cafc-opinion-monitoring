require 'rubygems'
require 'clockwork'
require 'sidekiq'
require './config/boot'
require './config/environment'
# Sidekiq configuration

# The following is REQUIRED to make REDIS and SIDEKIQ work on Heroku:
# (1) Set the REDIS_PROVIDER environment variable to your redis address.
# (2) Set the REDIS_URL environment variable to your redis address.                                        

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{ENV['DATA_REDIS_HOST']}:6379" }
  config.redis = { :size => 1 }
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

# control scheduled jobs like a boss

module Clockwork
  
  every 1.day "Update CAFC Opinions", :at => ['10:45', '10:50', '10:55', '11:00', '11:01', '11:02', '11:03', '11:04', '11:05', '11:10', '11:15'], :tz => "Eastern Time (US & Canada)" do
  	CafcOpinionWorker.perform_async
  end 
  
  every.1.hour "Update CAFC Opinions" do 
		CafcOpinionWorker.perform_aync
	end

  # clean out old (stuck) redis jobs
  # clean up before long running jobs, but leave a bit of time for long running jobs to complete
  # clean up periodically during work day
  every 1.day, 'Clean Up Redis', :at => ['02:45', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00', '22:00', '0:00'], :tz => "UTC" do
    # find all worker entries in redis
    redis_workers = $redis.keys("*worker*:workers")
    redis_workers.each do |worker|
      # fina all jobs in the worker and iterate over jobs
      worker_jobs = $redis.hkeys(worker)
      worker_jobs.each do |job|
        # format the job data into a hash for ruby manipulation
        job_data_hash = eval($redis.hget(worker, job).gsub(":", "=>"))
        
        # if any job is older than two hours, kill it
        if ( job_data_hash["payload"]["class"] == "SolrIprDeWorker")
          next # don't interrupt these

        elsif ( job_data_hash["payload"]["class"] == "SolrIprWorker")
          next # don't interrupt these

        elsif (job_data_hash["payload"]["class"] == "IprUpdateWorker") && ( Time.now - Time.at(job_data_hash["payload"]["created_at"].to_i) > 36000 )
          $redis.hdel(worker, job)
          
            # if IprDocketWorker is older than 10 minutes, kill it (should timeout anyway)
        elsif (( job_data_hash["payload"]["class"] == "IprDocketWorker" ) && ( Time.now - Time.at(job_data_hash["payload"]["created_at"].to_i) > 1 ))
          $redis.hdel(worker, job)
          
        elsif (( job_data_hash["payload"]["class"] == "PdfTextWorker") && (Time.now - Time.at(job_data_hash["payload"]["created_at"].to_i) > 3600))
          $redis.hdel(worker, job)
          
        elsif ( Time.now - Time.at(job_data_hash["payload"]["created_at"].to_i) > 7200 ) 
          $redis.hdel(worker, job)

        end
      end
    end
  end

  # clean up sidekiq every night after most users are logged off. 
  # clean up sidekiq before the very long running night jobs begin. 
  every 1.day, "Cleanup Sidekiq", :at => ['02:45', '08:45', '14:45', '20:45'], :tz => 'UTC' do 

    timeout = 14400 # 4 hours
    
    heroku = PlatformAPI.connect_oauth(ENV['PLATFORM_TOKEN'])
    
    puts "Cleaning up processes running longer than #{timeout} seconds"

    # array to hold the workers that go longer than timeout time (in seconds)
    overdue_workers = []

    workers = Sidekiq::Workers.new
    workers.each do |process_id, thread_id, work|
      # work is a hash of format:
      # {"queue"=>"low", "payload"=>{"retry"=>true, "queue"=>"low", "unique"=>true, "class"=>"IprDocketWorker", "args"=>[5276], "jid"=>"1 "unique_hash"=>"sidekiq_unique:97982209a3ab383c95a311835627432b"}, "run_at"=>1440589969}
      
      if Time.now - Time.at(work["payload"]["created_at"]) > timeout # in seconds
        unless work["payload"]["class"] == "IprUpdateWorker"
          overdue_workers << { process: process_id, thread: thread_id, work: work }
        else
          if Time.now - Time.at(work["payload"]["created_at"]) > 7200 # two hour minimum b/c long running process
            overdue_workers << { process: process_id, thread: thread_id, work: work }
          end
        end
      end
    end

    # compare worker processes to overdue workers
    # stop worker processes having overdue workers
    # workers will automatically restart
    ps = Sidekiq::ProcessSet.new
    ps.each do |process|

      # process is a Sidekiq::Process object with accessors:
      # hostname, started_at, pid, tag, concurrency, queues, labels, busy, beat
      overdue_workers.each do |worker|
        if worker[:process].match(process['hostname'])
          process.stop!
        end
      end
    end

    # reset dynos to make sure correct number of workers are going
    # if the name of the application changes, this will no longer work
    heroku.dyno.list('rfipr').each { |d| heroku.dyno.restart('rfipr', d['id']) if d["type"] == "worker" }

  end

end