*** Settings ***
Library  SeleniumLibrary
Resource    generic-keywords.robot
Variables  variables.py
Test Setup  Open Browser  ${URL}  ${BROWSER}


*** Test Cases ***
User registers successfully
    Given User is on the register page
    When They enter a valid username and password
    And Click the register button
    Then They should be redirected to the login page
    Sleep    5s
    # And They should be able to login