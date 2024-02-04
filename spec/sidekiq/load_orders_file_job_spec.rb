# frozen_string_literal: true

require 'rails_helper'
RSpec.describe LoadOrdersFileJob, type: :job do
  it { expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1) }

  context 'when there is a file to process' do
    before do
      allow(Dir).to receive(:glob).and_return(['file.csv'])
      allow(File).to receive(:open).and_return(content)
    end

    let(:data) do
      <<~DATA
        id;merchant_reference;amount;created_at
        e653f3e14bc4;padberg_group;102.29;2023-02-01
        20b674c93ea6;padberg_group;433.21;2023-02-01
      DATA
    end

    let(:content) { data.split('\n').lazy }

    it 'makes the CSV file as .processed' do
      expect(File).to receive(:rename).with('file.csv', 'file.csv.processed')

      described_class.new.perform
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
