Feature: As an user
  In order edit my details and view my profile activity
  I should be able to access my profile page

  @javascript @profile-page
  Scenario: Profile should show Mightbuy and Have items
    Given a confirmed user "Marla"
    Given a confirmed user "Tyler" with a have topic
    Given the user has another topic
    And I login as "Marla"
    When I visit profile page of "Tyler"
    Then I should see mightbuy items of "Tyler"
    Then I should see have items of "Tyler"
    And I re-login as "Tyler"
    When I visit my profile page
    Then I should see my mightbuy items
    Then I should see my have items
