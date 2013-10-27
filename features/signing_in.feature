Feature: Signing in
  Scenario: Unsuccessful signin
    Given a user visits the signin page
    When he or she submits invalid signin information
    Then he or she should see an error message

  Scenario: Successful signin
    Given a user visits the signin page
      And the user has an account
    When the user submits valid signin information
    Then he or she should see his or her profile page
      And he or she should see a signout link