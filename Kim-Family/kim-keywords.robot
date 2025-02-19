*** Settings ***
Library  SeleniumLibrary
Resource    ../Generic-Test-Cases/generic-keywords.robot
Variables  ../Generic-Test-Cases/variables.py

*** Keywords ***
They add two 'VIP' adult tickets to the cart
    [Tags]    Andreas
    [Documentation]    Assures that the user is able to purchase two VIP adult tickets.
    Click Element    ${nav_menu_ticket}
    Wait Until Element Is Visible    ${ticket_category_dropdown}    10s
    Select From List By Index    ${ticket_category_dropdown}    1
    Input Text    ${ticket_quantity}    2
    Click Element    ${add_ticket_to_cart_button}
    Handle Alert

Two 'VIP' child tickets to the cart
    [Tags]    Andreas
    [Documentation]    Assures that the user is able to purchase two VIP child tickets.
    Click Element    ${nav_menu_ticket}
    Wait Until Element Is Visible    ${ticket_category_dropdown}    10s
    Select From List By Index    ${ticket_category_dropdown}    1
    Select From List By Index    ${ticket_type_dropdown}    1
    Input Text    ${ticket_quantity}    2
    Click Element    ${add_ticket_to_cart_button}
    Handle Alert

They add a family package of VIP tickets to the cart    # 2 adults, 2 children
    [Tags]    Given
    [Documentation]    Assures that the user has added four VIP tickets to the cart.
    They add two 'VIP' adult tickets to the cart
    Two 'VIP' child tickets to the cart

They add a VIP tour booked for next ${chosen_day} to the cart
    [Documentation]    Books a single VIP safari tour for the specified day
    Click Element    ${nav_menu_safari}
    Wait Until Element Is Visible    ${safari_section}    10s
    Select From List By Index    ${safari_type_dropdown}    1 
    Selecting ${chosen_day} from dropdown calendar
    Click Element    ${add_safari_to_cart_button}
    Handle Alert   


They book four VIP safari tours on the weekend
    [Documentation]    Books four VIP safari tours for the next Sunday
    FOR    ${index}    IN RANGE    4
        They add a VIP tour booked for next Sunday to the cart   
    END
    They should be able to see the tour in the cart 
