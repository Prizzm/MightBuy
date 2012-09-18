Feature: As a user
  In order to see all topics
  As a User
  I want see all topics

  Scenario: As a user I should see all topics people are sharing
    Given I am logged in a user
    When I visit topic page
    Then I should see all topics people are sharing

  @javascript @login-to-vote
  Scenario: Login to Comment on Topics
    Given a confirmed user "Tyler"
    Given a confirmed user "Bob" with a topic
    When I visit the topic path
    And I vote "Yes!"
    Then I should be asked to login
    And I login as "Tyler"
    Then I should be on the topic path
    And I should see my vote as "Yes!"
    And I visit the topic path
    And I vote "NO!"
    Then I should see my vote as "No!"

  @javascript @login-to-comment
  Scenario: Login to Comment on Topics
    Given a confirmed user "Tyler"
    Given a confirmed user "Bob" with a topic
    When I visit the topic path
    And I comment "Go for it"
    Then I should be asked to login
    And I login as "Tyler"
    Then I should be on the topic path
    And I should see "Go for it"
    And I visit the topic path
    And I comment "Please Avoid"
    Then I should see "Please Avoid"

  @javascript
  Scenario: Deleting a topics
    Given I am logged in a user
    When I visit profile page
    Then I should be able to delete a topic

  @javascript
  Scenario: Visiting particular topic
    Given I am logged in a user
    And I have bunch of topics
    And system has topics added by other users as well
    When I visit one of my topics
    Then "I might buy" tab should be highlighted
    And I should see "You added"
    When I visit one of other topics
    Then "Everybody" tab should be highlighted

    

