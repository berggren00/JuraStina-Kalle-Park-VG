*** Settings ***
Library  SeleniumLibrary
Resource    generic-keywords.robot
Variables  variables.py
Test Setup  Open Browser  ${URL}  ${BROWSER}

*** Test Cases ***
User registers successfully
#Add proper tags + documentation
    [Tags]    Andreas_Refactor_Tan
    Given User is on the register page
    When They enter a valid username and password
    And Click the register button
    Then They should be redirected to the login page
    Sleep    3s

User logs in successfully
    [Tags]    Andreas_Refactor_Tan
    Given The user has an account
    When They enter valid login credentials
    And Click the login button
    Then They should be able to login
    Sleep    3s

User logs out successfully
    [Tags]    Andreas_Refactor_Tan
    Given The user has an account
    When The user is logged in
    Then They should be able to logout
    Sleep    3s