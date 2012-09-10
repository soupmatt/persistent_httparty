RSpec::Matchers.define :include_module do |module_to_include|
  match do |subject|
    subject.include? module_to_include
  end
end

RSpec::Matchers.define :define_instance_variable do |instance_variable|
  match do |subject|
    subject.instance_variable_defined? instance_variable
  end
end
