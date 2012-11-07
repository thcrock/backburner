$:.unshift "lib"
require 'backburner'

class User
  include Backburner::Performable

  # Called with the job args before a job is placed on the queue.
  # !! If the hook returns `false`, the job will not be placed on the queue.
  def self.before_enqueue_foo(*args)
    puts "[before_enqueue] Just about to enqueue #{self} with #{args.inspect}"
  end

  # Called with the job args after a job is placed on the queue.
  # !! Any exception raised propagates up to the code which queued the job.
  def self.after_enqueue_foo(*args)
    puts "[after_enqueue] Finished enqueuing #{self} with #{args.inspect}"
  end

  # Called with the job args before a job is removed from the queue.
  # If the hook returns `false`, the job will not be removed from the queue.
  def self.before_dequeue_foo(*args)
    puts "[before_dequeue] Just about to dequeue #{self} with #{args.inspect}"
  end

  # Called with the job args after a job was removed from the queue.
  # Any exception raised propagates up to the code which dequeued the job.
  def self.after_dequeue_foo(*args)
    puts "[after_dequeue] Finished dequeuing #{self} with #{args.inspect}"
  end

  # Called with the job args before perform. If it raises
  #  `Backburner::Job::DontPerform`, the job is aborted. Other exceptions
  #  are treated like regular job exceptions.
  def self.before_perform_foo(*args)
    puts "[before_perform] Just about to perform #{self} with #{args.inspect}"
  end

  # Called with the job args after it performs. Uncaught
  #   exceptions will be treated like regular job exceptions.
  def self.after_perform_foo(*args)
    puts "[after_perform] Just finished performing #{self} with #{args.inspect}"
  end

  # Called with the exception and job args if any exception occurs
  #  while performing the job (or hooks).
  def self.on_failure_foo(ex, *args)
    puts "[on_failure] Failure #{ex.inspect} occurred for job #{self} with #{args.inspect}"
  end

  def self.foo
    puts "This is the job running!!"
  end
end

# Configure Backburner
Backburner.configure do |config|
  config.beanstalk_url = "beanstalk://127.0.0.1"
  config.tube_namespace = "demo.production"
  config.on_error = lambda { |e| puts "HEY!!! #{e.class}" }
end

# Enqueue tasks
User.async.foo

# Run work
# Backburner.default_queues << "user"
Backburner.work