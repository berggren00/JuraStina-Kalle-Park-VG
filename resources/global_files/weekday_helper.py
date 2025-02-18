#https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#toc-entry-314
#Creating a whole new py file to act as a helper file for specific calculations
#Think of it as "utility" files in java -TT
import datetime


def get_weekday_delta_offset(day_of_week):
    ### Accepts a string of a weekday and returns the amount of days(delta) until we that weekday: 1-7
    # create a list, to then filter through and look for a match
    # this will most likely look more clean compared to a match-case

    weekdays = {
        "monday": 0,
        "tuesday": 1,
        "wednesday": 2,
        "thursday": 3,
        "friday": 4,
        "saturday": 5,
        "sunday": 6
    }

    day_index = weekdays.get(day_of_week.lower())
    if day_index is None:
        # Intellisense magic. But it's essentially an error handler -TT
        raise   ValueError(f"Invalid day of the week: {day_of_week}")

    current_date = datetime.date.today()
    delta = (day_index - current_date.weekday()) % 7

    #This ensures if you are on the current weekday -
    #you are looking for current weekday then it will jump exactly 1 week ahead -TT
    if delta <= 0:
        delta += 7

    return delta

def get_upcoming_target_weekday_date(target_weekday):
    #https://www.geeksforgeeks.org/python-program-to-get-the-nth-weekday-after-a-given-date/
    #0-6 for the days of the week, 0=monday -> 6=sunday
    delta = get_weekday_delta_offset(target_weekday)
    current_date = datetime.date.today()

    date_of_next_weekday = current_date + datetime.timedelta(delta)
    return date_of_next_weekday.strftime("%Y-%m-%d")

# region old-functions
# def get_amount_of_days_until_index_of_day(index_of_day):
#     current_date = datetime.date.today()
#     return (index_of_day - current_date.weekday()) % 7
#
# def get_days_left_until_day(day_of_week):
#     lower_case_day = day_of_week.lower()
#     match lower_case_day:
#         case "monday":
#             return get_amount_of_days_until_index_of_day(0)
#         case "tuesday":
#             return get_amount_of_days_until_index_of_day(1)
#         case "wednesday":
#             return get_amount_of_days_until_index_of_day(2)
#         case "thursday":
#             return get_amount_of_days_until_index_of_day(3)
#         case "friday":
#             return get_amount_of_days_until_index_of_day(4)
#         case "saturday":
#             return get_amount_of_days_until_index_of_day(5)
#         case "sunday":
#             return get_amount_of_days_until_index_of_day(6)
#
#
# def get_next_upcoming_weekday(target_weekday, date_format="YYYY-MM-DD"):
#     #https://www.geeksforgeeks.org/python-program-to-get-the-nth-weekday-after-a-given-date/
#     #0-6 for the days of the week, 0=monday -> 6=sunday
#     current_date = datetime.date.today()
#
#     days_delta = (target_weekday - current_date.weekday()) % 7
#     if days_delta <= 0:
#         days_delta += 7
#
#     date_of_next_weekday = current_date + datetime.timedelta(days_delta)
#     # reasoning behind MM-DD-YY is due to the websites interpretation of input. it being en-us
#     # reformating the date from YY-MM-DD --> to MM-DD-YY
#     # https://docs.python.org/3.13/library/datetime.html#format-codes
#     if date_format == "MM-DD-YYYY":
#         return date_of_next_weekday.strftime("%m-%d-%Y")
#     elif date_format == "YYYY-MM-DD":
#         return date_of_next_weekday.strftime("%Y-%m-%d")
#     else:
#         raise ValueError("Invalid date_format. Use 'DD-MM-YYYY' or 'YYYY-MM-DD'.")
# endregion