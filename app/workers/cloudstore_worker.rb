class CloudstoreWorker
  include Sidekiq::Worker
  do perform

  end
end