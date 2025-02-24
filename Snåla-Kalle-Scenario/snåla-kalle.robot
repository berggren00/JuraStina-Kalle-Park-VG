*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Resource    snåla-kalle-keywords.robot
Test Setup  Open Browser  ${URL}  ${BROWSER}    options=add_experimental_option("prefs", {"intl.accept_languages": "en-GB"})
Test Teardown    Close Browser

*** Test Cases ***

# so from my limited searching, its most conventional to have embedded arguments out in test-cases
# but go to arguments the second we work internally --TT
Snåla-Kalle cross checks pricing of a tour on a new vs an old account
    [Tags]    Daniel    Tan_refactor
    [Documentation]    Assures that there is no "first-time-visitor-discount", despite the rumours
    Given 'Snåla-Kalle' has an existing account and a new account 'Ståla-Nalle' is created and logged in
    When User checks the price on both accounts of a 'Regular' ticket and a tour
    Then The price of both purchases should match each other

# Create og account
    # register > login
    # do a purchase to to simulate previous visit
    # log out
# create second "new" user
    #login
    
# buy ticket + tour and then record the price
    # logout

# login into first user
    # replicate purchase

# compare price diff