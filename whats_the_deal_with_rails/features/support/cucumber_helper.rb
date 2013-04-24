FactoryGirl.find_definitions

def path_to_fixture(path)
  File.join(Rails.root, 'spec', 'fixtures', *(path.split('/')))
end