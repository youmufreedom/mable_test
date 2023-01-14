require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'Associations' do
    it { should have_many(:payer_transactions).class_name('Transaction') }
    it { should have_many(:payee_transactions).class_name('Transaction') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:account_number) }
    it { should validate_length_of(:account_number).is_equal_to 16 }
    it { should validate_numericality_of(:account_number).only_integer }

    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to 0 }
  end
end
