require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'is valid with a name' do
    project = Project.new(name: 'Test Project')
    expect(project).to be_valid
  end

  it 'is invalid without a name' do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
end
