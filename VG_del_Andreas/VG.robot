*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Resource    ../Kim-Family/kim-keywords.robot
Resource    VG-keywords.robot
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