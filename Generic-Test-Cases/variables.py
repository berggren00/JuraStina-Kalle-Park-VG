import os

# region OS related variables
current_directory = os.getcwd().replace('\\', '/')
browser = "chrome"
url = f"file:///{current_directory}/resources/website/jurap.html"
# endregion

# region Credentials related variables
username = "test123"
password = "test12345"
invalid_username = "123test"
invalid_password = "12345test"

username_field = "id:reg-username"
password_field = "id:reg-password"
login_username_field = "id:login-username"
login_password_field = "id:login-password"

submit_register = "css:#register-form button[type='submit']"
submit_login = "css:#login-form > button[type='submit']"

login_message = "id:login-message"
# endregion

# region Menu-bar variables
register_button = "id:register-nav"
login_button = "id:login-nav"
logout_button = "id:logout-nav"

# endregion

