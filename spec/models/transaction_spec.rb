require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'Associations' do
    it { should belong_to(:payer).class_name('Account') }
    it { should belong_to(:payee).class_name('Account') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:payer) }
    it { should validate_presence_of(:payee) }
    it { should validate_presence_of(:amount) }

    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to 0 }
  end
end
