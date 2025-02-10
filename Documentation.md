# Documentation
## Table of Contents

---

---
## Case descriptions
We chose:
- Generic Test Cases (Tests that any user would need)
- Snåljåpen Snåla-Kalle
- Kim och Familjen

### Generic Test Cases
User need to be able to:
  - log in
  - log out
  - Create an account
  - Purchase a ticket
  - Purchase a tour (Only if they have a ticket)
  - Put items into cart

Register
- Duplicate name
- Success
- Empty name/pass

Login
- Unknown usernames
- Wrong pass
- Success

Logout

Tickets
- Purchase approved
- Not logged in

Book tour (Logged in/out)
- Select events
- Dates
  - Workdays
  - Weekends
  - Past dates

Cart
- Add Item
- Remove Item
- Checkout (Items should disappear after purchase)

### Snåljåpen Snåla-Kalle
Short summary of how the test should be (temp):
- Create user 1 ("Existing user")
  - Login
  - Purchase ticket
  - Purchase tour once
  - Purchase a second ticket
  - Purchase tour a second time and save the price-tag
  - Logout

- Create user 2 ("Company user")
  - Login
  - Purchase ticket
  - Purchase tour once and save the price-tag
  - Logout

- Compare both price-tags (They should match)

#### Gherkin

---

---
### Kim och Familjen
Short summary of how the test should be (temp):

- Create user
- Login
- Purchase ticket (2 adults, 2 children, all VIP)
- Book weekend pass for feeding and extreme (both being VIP safaris)