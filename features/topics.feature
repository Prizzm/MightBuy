Feature: As a user
  In order to see all topics
  As a User
  I want see all topics


  Scenario: As a user I should see all topics people are sharing
    Given I am logged in a user
    When I visit topic page
    Then I should see all topics people are sharing
    