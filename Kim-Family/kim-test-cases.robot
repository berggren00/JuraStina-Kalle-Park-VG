*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Resource    kim-keywords.robot
Variables  ../Generic-Test-Cases/variables.py
Variables  kim-variables.py
Test Setup  Open Browser  ${URL}  ${BROWSER}
Test Teardown    Close Browser


*** Test Cases ***
Create User
    [Documentation]  User should be able to create an account
    [Tags]  Andreas
    Given The user is not logged in, and is on the homepage
    When They attempt to register with valid credentials
    Then They should be redirected to the login page

Kim logins successfully
    [Documentation]  User should be able to login
    [Tags]  Andreas
    Given The user has a registered account
    When They log in with 'VALID' credentials
    Then They should be logged in and be redirected to the homepage

Kim purchases tickets (2 adults, 2 children)
    [Documentation]  User should be able to purchase tickets
    [Tags]  Andreas
    Given The User Is Logged In
    When They add a family package of VIP tickets to the cart    # 2 adults, 2 children
    Then They should be able to see the ticket in the cart
    And Proceed with the purchase at checkout
    And They should be able to see a checkout summary with their purchased items
    And The cart should be empty    # Maybe not necessary, but good to check
    # Check validity for multiple tickets

Kim books four VIP safari tours
    [Documentation]  User should be able to book a safari tour
    [Tags]  Andreas
    Given The User Is Logged In
    And They add a family package of VIP tickets to the cart    # 2 adults, 2 childrem
    When They book four VIP safari tours on the weekend
    And Proceed with the purchase at checkout
    Sleep    5s
    Then They should be able to see a checkout summary with their purchased items
    And The cart should be empty    # Maybe not necessary here either, but good to check