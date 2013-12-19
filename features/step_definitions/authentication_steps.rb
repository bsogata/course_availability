#
# Step definitions for the signin process.
#
# Author: Branden Ogata
#

Given (/^a user visits the signin page$/) do
  visit signin_path
end

When (/^he or she submits invalid signin information$/) do
  click_button "Sign in"
end

Then (/^he or she should see an error message$/) do
  expect(page).to have_selector('div.alert.alert-error')
end

Given (/^the user has an account$/) do
  @user = User.create(name: "Paul E. Gone", email: "pgone@hawaii.edu",
                      password: "password", password_confirmation: "password")
end

When (/^the user submits valid signin information$/) do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"
end

Then (/^he or she should see his or her profile page$/) do
  expect(page).to have_title(@user.name)
end

Then (/^he or she should see a signout link$/) do
  expect(page).to have_link('Sign out', href: signout_path)
end