require 'cohort_repository'

# file: spec/cohort_repository_spec.rb

def reset_cohorts_table
  seed_sql = File.read('spec/seeds_cohorts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'student_directory_2' })
  connection.exec(seed_sql)
end

describe CohortRepository do
  before(:each) do
    reset_cohorts_table
  end

  # (your tests will go here).
  it '#all' do
    repo = CohortRepository.new

    cohorts = repo.all

    expect(cohorts.length).to eq 2

    expect(cohorts[0].id).to eq '1'
    expect(cohorts[0].cohort_name).to eq 'ruby'
    expect(cohorts[0].start_date).to eq '2022-10-01'

    expect(cohorts[1].id).to eq '2'
    expect(cohorts[1].cohort_name).to eq 'javascript'
    expect(cohorts[1].start_date).to eq '2022-09-01'
  end

  it '#find' do
    repo = CohortRepository.new
    cohort = repo.find(1)

    expect(cohort.id).to eq '1'
    expect(cohort.cohort_name).to eq 'ruby'
    expect(cohort.start_date).to eq '2022-10-01'
  end

  it '#create' do
    repo = CohortRepository.new

    cohort = Cohort.new
    cohort.cohort_name = 'C++'
    cohort.start_date = '2022-01-01'

    repo.create(cohort)

    # we have two cohorts to start
    # so it will be the 3rd
    new_cohort = repo.find(3)

    expect(new_cohort.cohort_name).to eq 'C++'
    expect(new_cohort.start_date).to eq '2022-01-01'
  end

  it '#delete' do
    repo = CohortRepository.new
    repo.delete(1)

    new_list = repo.all
    expect(new_list.length).to eq 1
    expect(new_list.first.id).to eq '2'
  end

  it '#update' do
    repo = CohortRepository.new
    cohort = repo.find(1)

    cohort.cohort_name = 'new name'
    cohort.start_date =  '2023-12-01'

    repo.update(cohort)

    repo.find(1)

    expect(cohort.cohort_name).to eq 'new name'
    expect(cohort.start_date).to eq '2023-12-01'
  end

  it '#find_with_students' do
    repo = CohortRepository.new
    cohort = repo.find_with_students(1)
    expect(cohort.cohort_name).to eq 'ruby'
    expect(cohort.students.length).to eq 2
    expect(cohort.students.first.student_name).to eq 'Joe'
  end
end
