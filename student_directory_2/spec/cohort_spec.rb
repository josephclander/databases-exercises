require 'cohort'

describe Cohort do
  it 'constructs' do
    cohort = Cohort.new
    expect(cohort.students).to eq []
  end
end
