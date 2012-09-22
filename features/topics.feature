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
    Then I should be asked to login via lightbox
    And I login as "Tyler" via lightbox
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
    Then I should be asked to login via lightbox
    And I login as "Tyler" via lightbox
    Then I should be on the topic path
    And I should see my comment as "Go for it"
    And I visit the topic path
    And I comment "Please Avoid"
    Then I should see my comment as "Please Avoid"

  @javascript
  Scenario: Deleting a topics
    Given I am logged in a user
    When I visit profile page
    Then I should be able to delete a topic

  @javascript @visiting-topic
  Scenario: Visiting particular topic
    Given I am logged in a user
    And I have bunch of topics
    And system has topics added by other users as well
    When I visit one of my topics
    Then "I might buy" tab should be highlighted
    And I should see "You added"
    When I visit one of other topics
    Then "Browse" tab should be highlighted

  @javascript @create-have-topic
  Scenario: I should add an item to I have list automatically
    Given a confirmed user "Tyler"
    And I login as "Tyler"
    And I click "I Have"
    And I click "Add an item"
    And I create a topic by filling the form
    Then I should not see the topic in mightbuy
    Then I should see the topic in have

  @javascript @update-have-topic
  Scenario: I should add an item to I have list automatically
    Given a confirmed user "Tyler" with a topic
    And I login as "Tyler"
    Then I should not see the topic in have
    Then I should see the topic in mightbuy
    And I visit the topic path
    And I mark the topic as i have
    Then I should not see the topic in mightbuy
    Then I should see the topic in have
    And I visit the topic path
    And I mark the topic as i dont have
    Then I should not see the topic in have
    Then I should see the topic in mightbuy
