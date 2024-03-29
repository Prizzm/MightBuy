Feature: As a user
  In order to see items which other people have uploaded
  As an User,
  I should be able to browse items and add them to my list

  @javascript @browse-feeds
  Scenario: Browsing feeds of other users
    Given a confirmed user "Tyler"
    Given a confirmed user "Bob" with a topic
    And I login as "Tyler"
    And I visit my profile
    Then "I MightBuy" tab should be highlighted
    Then I should see my empty feed
    And I visit profile of "Bob"
    Then "Browse" tab should be highlighted
    Then I should see "Bob" feeds

  @javascript @add-to-list
  Scenario: Adding an item to i mightbuy or i have while browsing
    Given a confirmed user "Tyler"
    Given a confirmed user "Bob" with a topic
    Given a confirmed user "Marla" with a topic
    And I visit a topic page
    Then I should not see "Add to list"
    And I login as "Tyler"
    And I browse for a topic
    Then I should be able to add the topic to might buy list
    And I browse for a topic
    Then I should be able to add the topic to have list

  @javascript @add-to-list-from-browse
  Scenario: Adding an item to i mightbuy or i have while browsing
    Given a confirmed user "Tyler"
    Given a confirmed user "Marla" with a topic
    And I login as "Tyler"
    And I click "Browse"
    Then I should be able to add the topic from browse view

  @javascript @deleted-user
  Scenario: Topics populated by a deleted user should be browsable
    Given a confirmed user "Bob" with a topic
    Given a confirmed user "Tyler"
    And I login as "Bob"
    And I delete my profile
    And I login as "Tyler"
    And I browse for a topic
    Then I should see "Macbook"

  @javascript @vote-from-browse-view
  Scenario: User should be able to vote from browse view itself
    Given a confirmed user "Bob" with a topic
    Given a confirmed user "Tyler"
    And I login as "Tyler"
    And I click "Browse"
    And I vote "Yes!" from browse view
    Then I should see my vote as "Yes!" from browse view
    And I vote "No!" from browse view
    Then I should see my vote as "No!" from browse view


  @javascript @user-items-on-browse
  Scenario: User should be able to see his own mightbuy/have items on browse
    Given a confirmed user "Tyler" with a have topic
      And the user has another topic
    When I login as "Tyler"
     And I click "Browse"
    Then I should see "Macbook"
     And I should see "Apple thunderbolt display"
