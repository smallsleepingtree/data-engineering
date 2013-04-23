Given /^I am an authorized user$/ do
  # We don't need the concept of authorization or even authentication with the
  # first story - it only becomes explicit when we assert for its absence.
end

When /^I sign in$/ do
  # Authentication is implicit for now - all "users" of the site are
  # authenticated.
end
