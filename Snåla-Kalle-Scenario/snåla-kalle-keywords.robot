*** Settings ***
Library  SeleniumLibrary
Library    Collections
Resource    ../Generic-Test-Cases/generic-keywords.robot
Variables    snåla-kalle-variables.py


*** Keywords ***


## Scenario Specific ##

'${EXISTING_ACCOUNT}' has an existing account and a new account '${NEW_ACCOUNT}' is created and logged in
    [Tags]    Given
    [Documentation]    Entrypoint. Setting test variables such as usernames for said test.
    Set Test Variable    ${EXISTING_ACCOUNT}   ${EXISTING_ACCOUNT}
    Set Test Variable    ${NEW_ACCOUNT}    ${NEW_ACCOUNT}
    
    Create an account with a previous purchase    ${EXISTING_ACCOUNT}
    User creates a new account and is logged in    ${NEW_ACCOUNT}

User checks the price on both accounts of a '${TICKET_TYPE}' ticket and a tour
    [Tags]    When
    [Documentation]    Simulates identical purchases between 2 accounts.
    User checks the price of a ticket and a tour    ${TICKET_TYPE}
    User changes account to ${EXISTING_ACCOUNT}
    User checks the price of a ticket and a tour    ${TICKET_TYPE}

The price of both purchases should match each other
    [Tags]    Then
    [Documentation]    Assures that two remembered values are the same    ### Currently comparing whole checkout strings, not cost -DK
    Should Be Equal As Strings    ${prices}[0]    ${prices}[1]
    
## Dependencies for Snåla-Kalle ##
Create an account with a previous purchase
    [Tags]    Internal
    [Arguments]    ${USERNAME}
    [Documentation]    Creates a new account and simulates a purchase.
    # Not sure if we should have an argument for password from all this way out. -TT
    The user has a registered account with username ${USERNAME}
    Simulate a previous purchase on account    ${USERNAME}

User creates a new account and is logged in
    [Tags]    Internal    
    [Arguments]    ${USERNAME}
    The user has a registered account with username ${USERNAME}
    Attempt to login and confirm that it succeeded    ${USERNAME}

User checks the price of a ticket and a tour
    [Tags]    Internal
    [Arguments]    ${TICKET_TYPE}    #Tour type can be added here as well -TT
    They add a '${TICKET_TYPE}' ticket to the cart
    They add a tour booked for next wednesday by navigating the calendar dropdown using the keyboard to the cart
    They check the price of the items listed in the cart

User changes account to ${USERNAME}
    [Tags]    Internal
    The user is not logged in, and is on the homepage
    Navigate To The Login Page
    Attempt To Login With These Credentials    ${USERNAME}
    They should be logged in and be redirected to the homepage

Simulate a previous purchase on account
    [Tags]    Internal
    [Arguments]    ${USERNAME}
    [Documentation]    Will log in and go through a full purchase to simulate a "visit". Then logs out.
    Attempt to login and confirm that it succeeded    ${USERNAME}
    They add a 'REGULAR' ticket to the cart
    They add a tour booked for next monday by navigating the calendar dropdown using the keyboard to the cart
    Proceed with the purchase at checkout
    Handle Alert
    The cart should be empty
    The user is not logged in, and is on the homepage

Navigate to the login page
    [Tags]    Internal
    Wait Until Element Is Visible    ${nav_menu_login}    10s
    Click Element    ${nav_menu_login}
    Wait Until Element Is Visible    ${login_username_field}    10s

Attempt to login and confirm that it succeeded
    [Tags]    Internal
    [Arguments]    ${USERNAME}
    Attempt to login with these credentials    ${USERNAME}
    They should be logged in and be redirected to the homepage

## Borrowed & refactored ##

# not sure if we should have this an an argument/rework it entirely -TT
The user has a registered account with username ${USERNAME}
    [Tags]    Internal
    Attempt to register with these credentials     ${USERNAME}
    They should be redirected to the login page

Attempt to register with these credentials
    [Tags]    Internal
    [Arguments]    ${USERNAME}    ${PASSWORD}=${snålakalle_password}
    Click Element    ${nav_menu_register}
    Input Text    ${USERNAME_FIELD}    ${USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${PASSWORD}
    Click Element    ${SUBMIT_REGISTER}

Attempt to login with these credentials
    [Tags]    Internal
    [Arguments]    ${USERNAME}    ${PASSWORD}=${snålakalle_password}
    Input Text    ${LOGIN_USERNAME_FIELD}    ${USERNAME}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${PASSWORD}
    Click Element    ${submit_login}

They check the price of the items listed in the cart
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${checkout_button}    10s
    Click Element    ${checkout_button}
    ${total_price}    Handle Alert
    Append To List    ${prices}    ${total_price}
