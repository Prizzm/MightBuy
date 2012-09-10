Feature: As a user
  In order to see all topics
  As a User
  I want see all topics

  Scenario: As a user I should see all topics people are sharing
    Given I am logged in a user
    When I visit topic page
    Then I should see all topics people are sharing

  @javascript @login-to-comment
  Scenario: Login to Comment on Topics
    Given a confirmed user "Tyler"
    Given a confirmed user "Bob" with a topic
    When I visit the topic path to comment
    And I vote "Yes!" commenting "Go for it"
    Then I should be asked to login
    And I login as "Tyler"
    Then I should be on the topic path to comment
    And I should see vote "Buy it!" with "Go for it"
    And I visit the topic path to comment
    And I vote "NO!" commenting "Please Avoid"
    Then I should see vote "Don't buy it!" with "Please Avoid" immediately
