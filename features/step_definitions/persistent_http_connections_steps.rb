Given /^I have an http end point "(.*?)"$/ do |uri|
  @web_request = WebRequest.new
  @web_request.uri = uri
end

Given /^I perform a "(.*?)" against that end point$/ do |verb|
  @web_request.verb = verb
end

Given /^The end point returns "(.*?)"$/ do |content_type, body|
  @web_request.content_type = content_type
  @web_request.response_body = body
end

When /^I visit that end point with HTTParty$/ do
  @web_request.mock
  @response = @web_request.perform
end

Then /^the parsed_response contains$/ do |table|
  @response.parsed_response.should == table.rows_hash
end
