*** Settings ***
Library  SeleniumLibrary
Library    ../resources/global_files/weekday_helper.py
Variables  variables.py

*** Keywords ***

### Registration ###
The user is not logged in, and is on the homepage
    # Confirms by checking if the logout button is present
    # https://forum.robotframework.org/t/differences-between-if-elseif-and-run-keyword-if/5746/4
    # Seems like "run keyword if" is old compared to "if/else". -TT
    [Tags]    Given
    ${is_logged_in}=    Run Keyword And Return Status    Element Should Be Visible   ${nav_menu_logout}
    Run Keyword If    ${is_logged_in}    Click Element    ${nav_menu_logout}
    Run Keyword If    ${is_logged_in}    Handle Alert
    Wait Until Page Contains Element    ${nav_menu_login}    timeout=10s

They attempt to register with valid credentials
    [Tags]    When
    Click Element    ${nav_menu_register}
    Input Text    ${USERNAME_FIELD}    ${valid_username}
    Input Text    ${PASSWORD_FIELD}    ${valid_password}
    Click Element    ${SUBMIT_REGISTER}

They should be redirected to the login page
    [Tags]    Then
    Wait Until Element Is Visible    ${login_section}    10s

### Login ###
The user has a registered account
    [Tags]    Given
    They Attempt To Register With Valid Credentials

They log in with '${credential_type}' credentials
    [Tags]    When
    # Using embedded variables that allows the input to be changed from "valid" to "invalid"
    # https://forum.robotframework.org/t/differences-between-if-elseif-and-run-keyword-if/5746/4
    # Seems like "run keyword if" is old compared to "if/else". -TT
    # Can hardcode the functions of input here if we wanted, but I think this looks cleaner. -TT
    Wait Until Element Is Visible    ${login_section}    10s

    IF  "${credential_type.lower()}" == "valid"
        They Enter Valid Login Credentials
    ELSE IF  "${credential_type.lower()}" == "invalid"
        They Enter Invalid Login Credentials
    ELSE
        Fail    Invalid credential type: ${credential_type}
    END

They should be logged in and be redirected to the homepage
    [Tags]    Then
    Wait Until Element Is Visible    ${home_section}    10s
    Wait Until Element Is Visible    ${nav_menu_logout}    10s

They should see an error message indicating login failure
    [Tags]    Then
    Wait Until Element Contains    ${login_message}    Invalid username or password.

### Logout ###
The User Is Logged In
    [Tags]    Given
    The User Has A Registered Account
    They Log In With 'valid' Credentials
    They should be logged in and be redirected to the homepage

They Log Out
    [Tags]    When
    Wait Until Element Is Visible    ${home_section}    10s
    Wait Until Page Contains Element    ${nav_menu_logout}    timeout=10s
    Click Element    ${nav_menu_logout}
    Handle Alert

They should be redirected to the homepage and see the login button
    [Tags]    Then
    Wait Until Element Is Visible    ${home_section}    10s
    Wait Until Element Is Visible    ${nav_menu_login}    10s

### Ticket ###
They add a '${ticket_type}' ticket to the cart
    [Tags]    When    Given
    Click Element    ${nav_menu_ticket}
    Wait Until Element Is Visible    ${ticket_category_dropdown}    10s

    # unsure if this works but this will make it all lowercase from my understanding
    # as shown in valid/invalid, you can skip setting variables and just use `.lower()` right away
    # instead of creating multiple steps. But i think its good to showcase both for learning purposes. -TT
    ${ticket_type_lower}    Set Variable    ${ticket_type.lower()}
    
    IF  "${ticket_type_lower}" == "regular"
        Select From List By Index    ${ticket_category_dropdown}    0
    ELSE IF  "${ticket_type_lower}" == "vip"
        Select From List By Index    ${ticket_category_dropdown}    1
    ELSE
        Fail    Invalid ticket type: ${ticket_type}
    END

    ${selected}=    Get Selected List Value    ${ticket_category_dropdown}
    ${selected_lower}    Set Variable   ${selected.lower()}
    Should Contain    ${selected_lower}    ${ticket_type_lower}
    Click Element    ${add_ticket_to_cart_button}

    ${message} =    Handle Alert
    Should Contain    ${message}    ${item_added_to_cart_message_text}

They should be able to see the ticket in the cart
    [Tags]    Then
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    10s
    ${listed_items}    Get Text    ${cart_details}
    Should Not Contain    ${listed_items}    Your cart is empty
    Should Contain    ${listed_items}    Ticket    #Currently hardcoded to test, not sure if its needed as variable.-TT

### Tour ###
They add a tour booked for next ${chosen_day} by navigating the calendar dropdown using the keyboard to the cart  #working name -DK
    [Tags]    When
    Click Element    ${nav_menu_safari}
    Wait Until Element Is Visible    ${safari_section}    10s
    Selecting ${chosen_day} from dropdown calendar
    Click Element    ${add_safari_to_cart_button}
    Handle Alert

Selecting ${chosen_day} from dropdown calendar
    [Tags]    Under_review    Daniel    Tan_refactor
    Set Test Variable    ${selected_day}    ${chosen_day}    #Sets a "file wide" variable so it can be accessed later on.

    ${input_count}    get_weekday_delta_offset    ${chosen_day}    #importing library of our file allows calls to funcs. -TT
    # DESPERATION KICKING IN - DK
    # Tried several methods while waiting for food, and what I found as I gave up was something about to go eat was
    # "import keyword" and assigning keywords to the python functions -DK
    Press Keys    ${safari_date_input_field}    SPACE
    Navigate ${input_count} steps to the right in the calendar
    Press Keys    None    Enter
    
Navigate ${amount_of_steps} steps to the right in the calendar
    [Tags]    Under_review    Daniel    Tan_refactor
    [Documentation]    Input solution for the dynamic calendar ui in javascript.
    FOR    ${key_press}    IN RANGE    ${amount_of_steps}
        Press Keys    None    ARROW_RIGHT    #i got trolled by documentation. i assumed none was literally no text -TT
        #Sleep    0.1s    #Use this if you want to see the actual movement during calendar selection. -TT
    END

They should be able to see the tour in the cart
    [Tags]    Then
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    10s
    #${locale}    Execute Javascript    return navigator.language
    #Log To Console    Browser locale is: ${locale}
    ${listed_items}    Get Text    ${cart_details}
    ${expected_date} =    get_upcoming_target_weekday_date    ${selected_day}

    Should Not Contain    ${listed_items}    Your cart is empty
    Should Contain    ${listed_items}    ${expected_date}

### Checkout ###
Proceed with the purchase at checkout
    [Tags]    When
    #Known Issue: Buying a ticket and then choosing a tour is not working. (blame Max) --TT
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    10s
    Click Button    ${checkout_button}

They should be able to see a checkout summary with their purchased items
    [Tags]    Then
    ${message} =    Handle Alert    #We handle + save the string attached in the alert here.
    Should Contain    ${message}    Checkout Summary:

The cart should be empty
    [Tags]    And
    Click Element    ${nav_menu_cart}
    Wait Until Element Is Visible    ${cart_section}    timeout=10s
    Element Should Contain    ${cart_details}    Your cart is empty


### Internal ###
They enter invalid login credentials
    [Tags]    Internal
    Input Text    ${LOGIN_USERNAME_FIELD}    ${INVALID_USERNAME}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${INVALID_PASSWORD}
    Click Element    ${submit_login}

They enter valid login credentials
    [Tags]    Internal
    Input Text    ${LOGIN_USERNAME_FIELD}    ${valid_username}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${valid_password}
    Click Element    ${submit_login}


### Old-Code that's not in use but good for teaching/learning purposes ###
#They add a viable tour with a chosen date to the cart
#    [Tags]    When    Tan
#    [Documentation]    Old solution for date input. no longer in use due to input bug within the website.
#    Click Element    ${nav_menu_safari}
#    Wait Until Element Is Visible    ${safari_section}    10s
#    Click Element    ${safari_date_input_field}
#    #old-tod-o: FIGURE OUT WHY AMERICAN DATE INPUT WORKS DESPITE OUR WEBSITE BEING DD-MM-YYYY. I hate this -TT
#    ## I initially thought it was because we used 'en-us' locale. BUT the issue still persists with 'en-GB'.
#    ## Conclusion: The website is trolling us. Legit decide and dont use all 3 variants man 🙃
#    ##    Input from RobotFramework> MM-DD-YYYY
#    ##    Input from Manual test > DD-MM-YYYY
#    ##    Output in cart > YYYY-MM-DD            --TT
#    Input Text    ${safari_date_input_field}    ${next_monday_date}
#    Select From List By Index    ${safari_type_dropdown}    1
#    Click Element    ${add_safari_to_cart_button}
#    Handle Alert
