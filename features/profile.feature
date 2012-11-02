Feature: As an user
  In order edit my details and view my profile activity
  I should be able to access my profile page

  @javascript @profile-page
  Scenario: Profile should show Mightbuy and Have items
    Given a confirmed user "Marla"
      And a confirmed user "Tyler" with a have topic
      And the user has another topic
    When I login as "Marla"
     And I visit profile page of "Tyler"
    Then I should see mightbuy items of "Tyler"
     And I should see have items of "Tyler"
    When I re-login as "Tyler"
     And I visit my profile page
    Then I should see my mightbuy items
     And I should see my have items
