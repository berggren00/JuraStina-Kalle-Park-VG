*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Resource    ../Kim-Family/kim-keywords.robot
Resource    VG-keywords.robot
Resource    ../Snåla-Kalle-Scenario/snåla-kalle-keywords.robot
Variables  ../Snåla-Kalle-Scenario/snåla-kalle-variables.py
Variables  ../Generic-Test-Cases/variables.py
Variables    ../Kim-Family/kim-variables.py
Test Setup  Open Browser  ${URL}  ${BROWSER}    options=add_experimental_option("prefs", {"intl.accept_languages": "en-GB"})
Test Teardown    Close Browser

*** Test Cases ***
User removes last item added from the cart
    [Tags]    Andreas
    [Documentation]    Assures that the user is able to remove the last added item from the cart.
    Given The User Is Logged In
    And They add a family package of VIP tickets to the cart
    When They remove the last added item from the cart
    Then They should not be able to see the last added item in the cart

Checkout button should be disabled when cart is empty
    [Tags]    Andreas
    [Documentation]    Assures that the checkout button is disabled when the cart is empty.
    Given The User Is Logged In
    And They have no items in the cart
    Then The checkout button should be disabled
    When They add a family package of VIP tickets to the cart
    Then The checkout button should be enabled

Items should maintain in cart after logging out and back in
    [Tags]    Andreas
    [Documentation]    Assures that the items in the cart are maintained after logging out and back in.
    Given The User Is Logged In
    And They add a 'VIP' ticket to the cart
    When They click the logout button
    And They log in with 'VALID' credentials
    Sleep    2s
    Then They should be able to see the ticket in the cart

User can clear entire cart
    [Tags]    Andreas
    [Documentation]    Verifies that user can remove all items from cart one by one.
    Given The User Is Logged In
    And They add multiple tickets to the cart
    When They clear the entire cart
    Then The cart should be empty
    And The checkout button should be disabled
    
