# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadMerchantsFileJob, type: :job do
  it { expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1) }

  context 'when there is a file to process' do
    before do
      allow(Dir).to receive(:glob).and_return(['file.csv'])
      allow(CSV).to receive(:read) { content }
      allow(File).to receive(:rename)
    end

    let(:data) do
      <<~DATA
        id;reference;email;live_on;disbursement_frequency;minimum_monthly_fee
        86312006-4d7e-45c4-9c28-788f4aa68a62;padberg_group;info@padberg-group.com;2023-02-01;DAILY;0.0
      DATA
    end

    let(:content) { CSV.parse(data, headers: true, col_sep: ';') }

    it 'insert a new merchant' do
      expect { described_class.new.perform }.to change(Merchant, :count).by(1)
    end

    it 'makes the CSV file as .processed' do
      expect(File).to receive(:rename).with('file.csv', 'file.csv.processed')

      described_class.new.perform
    end

    context 'when merchant is created' do
      before { described_class.new.perform }

      it { expect(Merchant.first.disbursement_frequency).to eq('DAILY') }

      it { expect(Merchant.first.live_on).to eq(Date.parse('2023-02-01')) }

      it { expect(Merchant.first.minimum_monthly_fee).to eq(0.to_money) }
    end
  end

  context 'when there is not file to process' do
    before do
      allow(Dir).to receive(:glob).and_return([])
      described_class.new.perform
    end

    it { expect(CSV).not_to receive(:read) }

    it { expect(File).not_to receive(:rename) }
  end
end
