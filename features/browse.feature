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
    Then "I might buy" tab should be highlighted
    Then I should see my empty feed
    And I visit profile of "Bob"
    Then "Browse" tab should be highlighted
    Then I should see "Bob" feeds
