
import os

current_directory = os.getcwd().replace('\\', '/')
browser = "chrome"
url = f"file:///{current_directory}/resources/website/jurap.html"
# TODO: Create regions
register_button = "id:register-nav"
username_field = "id:reg-username"
password_field = "id:reg-password"
username = "test123"
password = "test12345"
submit_register = "css:#register-form button[type='submit']"
login_button = "id:login-nav"
submit_login = "css:#login-form > button[type='submit']"
logout_button = "id:logout-nav"
login_username_field = "id:login-username"
login_password_field = "id:login-password"
