# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ProcessOrdersJob, type: :job do
  it { expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1) }

  context 'when there are orders to process' do
    before { create(:merchant, reference: 'padberg_group') }

    let(:orders) do
      ['e653f3e14bc4;padberg_group;102.29;2023-02-01', 'e653f3e14bc5;padberg_group;1.00;2023-02-02']
    end

    it { expect { described_class.new.perform(orders) }.to change(Order, :count).by(2) }
  end

  context 'when there is not order to process' do
    it { expect { described_class.new.perform([]) }.not_to change(Order, :count) }
  end
end
