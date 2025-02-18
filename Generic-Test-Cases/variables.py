import datetime
import os

# region OS related variables
current_directory = os.getcwd().replace('\\', '/')
browser = "chrome"
url = f"file:///{current_directory}/resources/website/jurap.html"
# endregion

# region Home Variables
home_section = '//*[@id="home-section"]'
# endregion

# region Credentials variables
valid_username = "test123"
valid_password = "test12345"

invalid_username = "123test"
invalid_password = "12345test"
# endregion

# region Register variables
username_field = "id:reg-username"
password_field = "id:reg-password"

submit_register = "css:#register-form button[type='submit']"
# endregion

# region Login variables
login_section = '//*[@id="login-section"]'

login_username_field = "id:login-username"
login_password_field = "id:login-password"

submit_login = "css:#login-form > button[type='submit']"
login_message = "id:login-message"
# endregion

# region Menu bar/navigation bar variables
nav_menu_register = "id:register-nav"
nav_menu_login = "id:login-nav"
nav_menu_logout = "id:logout-nav"
nav_menu_ticket = "id:tickets-nav"
nav_menu_safari = "id:safari-nav"
nav_menu_cart = "id:cart-nav"

# endregion

# region Ticket variables
add_ticket_to_cart_button = "css:#ticket-form > button[type='submit']"
# endregion

# region Safari variables
safari_section = '//*[@id="safari-section"]'

ticket_category_dropdown = "id:ticket-category"
safari_type_dropdown = "id:safari-type"
safari_date_input_field = "xpath://input[@id='safari-date']"

add_safari_to_cart_button = "css:#safari-form > button[type='submit']"
# endregion

# region Cart variables
cart_section = '//*[@id="cart-section"]'
cart_details = "id:cart-details"

item_added_to_cart_message_text = "Item added to cart!"

next_monday_date_TEST = "02-28-2025" ## I DON'T GET THIS ONE, WHY IS AMERICAN INPUT FUNCTIONING HERE??? -TT
# endregion

# region Checkout variables
checkout_button = '//*[@id="checkout-button"]'
# endregion
