RSpec::Matchers.define :include_module do |module_to_include|
  match do |subject|
    subject.include? module_to_include
  end
end
