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
    Input Text    ${USERNAME_FIELD}    ${USERNAME}
    Input Text    ${PASSWORD_FIELD}    ${PASSWORD}