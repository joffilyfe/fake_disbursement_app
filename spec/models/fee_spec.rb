# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fee do
  it { is_expected.to belong_to(:owner) }
end
