# frozen_string_literal: true

require 'csv'

class LoadMerchantsFileJob

  include Sidekiq::Job

  def perform
    files.each do |file|
      ActiveRecord::Base.transaction do
        CSV.read(file, headers: true, col_sep: ';').each { |row| merchant(row).save }
        mark_as_processed!(file)
      end
    end
  end

  private

  PROCESSED_POST_FIX = '.processed'

  def root
    ENV['MERCHANT_FILE_DIRECTORY'] || Rails.root.join('tmp/merchants/*')
  end

  def files
    Dir.glob(root).reject { |f| File.directory?(f) }.select { |f| File.extname(f).eql?('.csv') }
  end

  def merchant(data)
    Merchant.new(
      uuid: data['id'],
      reference: data['reference'],
      email: data['email'],
      live_on: data['live_on'],
      disbursement_frequency: data['disbursement_frequency'],
      minimum_monthly_fee: Money.from_amount(data['minimum_monthly_fee'].to_d)
    )
  end

  def mark_as_processed!(file)
    File.rename(file, file + PROCESSED_POST_FIX)
  end

end
