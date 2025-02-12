*** Settings ***
Library  SeleniumLibrary
Variables  variables.py

*** Keywords ***

User is on the register page
    Wait Until Page Contains Element    ${REGISTER_BUTTON}    timeout=10s
    Click Element    ${REGISTER_BUTTON}

They enter a valid username and password
    Input Text    ${USERNAME_FIELD}    ${USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${PASSWORD}

Click the register button
    Click Element    ${SUBMIT_REGISTER}

They should be redirected to the login page
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=10s
    
User is on the login page
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=10s
    Click Element    ${LOGIN_BUTTON}

They enter valid login credentials
    Sleep    2s
    Input Text    ${LOGIN_USERNAME_FIELD}    ${USERNAME}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${PASSWORD}

Click the login button
    Click Element    ${SUBMIT_LOGIN}

They should be able to login
    # Confirms by checking if the logout button is present
    Wait Until Page Contains Element    ${LOGOUT_BUTTON}    timeout=10s

They should be able to logout
    Wait Until Page Contains Element    ${LOGOUT_BUTTON}    timeout=10s
    Sleep    2s
    Click Element    ${LOGOUT_BUTTON}

The user has an account
    User is on the register page
    They enter a valid username and password
    Click the register button

The user is logged in
    User is on the login page
    They enter valid login credentials
    Click the login button

They enter invalid login credentials
    Sleep    2s
    Input Text    ${LOGIN_USERNAME_FIELD}    ${INVALID_USERNAME}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${INVALID_PASSWORD}

They should not be able to login
    # Confirms by checking if the login button is present
    Wait Until Page Contains Element    ${LOGIN_MESSAGE}    timeout=10s