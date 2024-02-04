# frozen_string_literal: true

require 'csv'

class LoadOrdersFileJob

  include Sidekiq::Job

  def perform
    files.each do |file|
      File.open(file).lazy.drop(1).each_slice(BATCH_SIZE) do |orders|
        # ProcessOrdersJob.perform_async(orders)
      end

      mark_as_processed!(file)
    end
  end

  private

  BATCH_SIZE = 100
  PROCESSED_POST_FIX = '.processed'

  def root
    ENV['ORDER_FILE_DIRECTORY'] || Rails.root.join('tmp/orders/*')
  end

  def files
    Dir.glob(root).reject { |f| File.directory?(f) }.select { |f| File.extname(f).eql?('.csv') }
  end

  def mark_as_processed!(file)
    File.rename(file, file + PROCESSED_POST_FIX)
  end

end
