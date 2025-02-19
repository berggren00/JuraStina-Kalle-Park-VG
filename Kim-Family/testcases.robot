*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Variables  ../Generic-Test-Cases/variables.py
Test Setup  Open Browser  ${URL}  ${BROWSER}
Test Teardown    Close Browser


*** Test Cases ***
Create User
    [Documentation]  User should be able to create an account
    [Tags]  Andreas
    Given The user is not logged in, and is on the homepage
    When They attempt to register with valid credentials
    Then They should be redirected to the login page

User logins successfully
    [Documentation]  User should be able to login
    [Tags]  Andreas
    Given The user has a registered account
    When They log in with 'VALID' credentials
    Then They should be logged in and be redirected to the homepage

User purchases tickets (2 adults, 2 children)
    [Documentation]  User should be able to purchase tickets
    [Tags]  Andreas
    Given The User Is Logged In
    When They add two 'VIP' adult tickets to the cart
    And Two 'VIP' child tickets to the cart
    Then They should be able to see the ticket in the cart    # Check validity for multiple tickets

User books safari tour
    [Documentation]  User should be able to book a safari tour
    [Tags]  Andreas
    Given The User Is Logged In
    And They have added four 'VIP' tickets to the cart    # 2 adults, 2 childrem
    When They book a VIP safari tour on the weekend
    And Proceed with the purchase at checkout
    Then They should be able to see a checkout summary with their purchased items
    And The cart should be empty    # Maybe not necessary, but good to check