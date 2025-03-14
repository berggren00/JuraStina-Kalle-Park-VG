*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Variables  ../Generic-Test-Cases/variables.py

*** Variables ***
${remove_last_item}    css=#cart-details > ul > li:last-child > button
${checkout_button}    id:checkout-button
${cart_item_remove_button}    css=#cart-details > ul > li > button
${cart_items_list}    css=#cart-details > ul > li

*** Keywords ***
They remove the last added item from the cart
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    10s
    Wait Until Element Is Visible    ${remove_last_item}    10s
    Click Element    ${remove_last_item}
    Sleep    2s

They should not be able to see the last added item in the cart
    Wait Until Element Is Visible    ${cart_section}    10s
    ${item_visible}=    Run Keyword And Return Status    Page Should Not Contain    ${remove_last_item}
    IF    ${item_visible}
        Log    Item was successfully removed from cart
    ELSE   
        Log    Item still visible in cart
        Fail    Last added item should not be in cart
    END


They have no items in the cart
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    timeout=10s
    Element Should Contain    ${cart_details}    Your cart is empty
    Sleep    2s
The checkout button should be disabled
    Element Should Be Disabled    ${checkout_button}

The checkout button should be enabled
    Element Should Be Enabled    ${checkout_button}
    Sleep    2s

They click the logout button
    Wait Until Page Contains Element    ${nav_menu_logout}    timeout=10s
    Click Element    ${nav_menu_logout}
    Handle Alert
    Wait Until Element Is Visible    ${nav_menu_login}    timeout=10s
    Click Element    ${nav_menu_login}


They clear the entire cart
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    timeout=10s
    ${items_count}=    Get Element Count    ${cart_items_list}
    FOR    ${index}    IN RANGE    ${items_count}
        Wait Until Element Is Visible    ${cart_item_remove_button}    timeout=10s
        Click Element    ${cart_item_remove_button}
        Sleep    1s
    END

They add multiple tickets to the cart
    They add a 'VIP' ticket to the cart
    They add a 'REGULAR' ticket to the cart
    They add a family package of VIP tickets to the cart
