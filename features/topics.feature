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
    Then "I MightBuy" tab should be highlighted
    And I should see "You added"
    When I visit one of other topics
    Then "Browse" tab should be highlighted

  @javascript @buying-topic
  Scenario: Buying an Item
    Given a confirmed user "Bob" with a topic
    And I login as "Bob"
    And I visit the topic path
    And I buy the topic
    Then I should see the topic in have
    And I should not see the topic in mightbuy

  @javascript @have-topic-crud
  Scenario: I should add an item to I have list automatically
    Given a confirmed user "Tyler"
    And I login as "Tyler"
    And I click "I Have"
    And I click "Add an item"
    And I create a have topic by filling the form
    Then I should not see the topic in mightbuy
    Then I should see the topic in have
    And I visit my have topic
    Then I should be able to edit topic review to "just go for it!"
    And I should able to destroy the topic

  @javascript @recommend-have-topic
  Scenario: I should add an item to I have list automatically
    Given a confirmed user "Tyler" with a have topic
    And I login as "Tyler"
    And I visit my have topic
    Then I should not see any topic recommendation
    Then I should be able to recommend the topic
    Then I should be able to not recommend the topic

  @javascript @visiting-have-topics
  Scenario: Should be able to access topics which are mightbuy, ihave etc
    Given a confirmed user "Tyler" with a topic
    Given a confirmed user "Bob" with a have topic
    And I visit a have topic
    And I login as "Tyler"
    And I visit a have topic
    And "Browse" tab should be highlighted

  @javascript @vote-from-list-view
  Scenario: User should be able to vote from list view itself
    Given a confirmed user "Tyler" with a topic
    And I login as "Tyler"
    And I vote "Yes!" from list view
    Then I should see my vote as "Yes!" from list view
    And I vote "No!" from list view
    Then I should see my vote as "No!" from list view

  @javascript @recommend-from-list-view
  Scenario: User should be able to recommend from list view itself
    Given a confirmed user "Tyler" with a have topic
    And I login as "Tyler"
    And I click "I Have"
    And I recommend the topic from list view
    Then I should see my recommendation as "Yes!" from list view
    And I dont recommend the topic from list view
    Then I should see my recommendation as "No!" from list view
