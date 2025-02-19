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

---

---
### Kim och Familjen

This case is about a family of 4, 2 adults and 2 children. They plan to make a trip to 
the park during a weekend to allow the children to take a **closer** look at the dinosaurs. This means that
the family needs VIP tickets to both book a "`Herbivore Tour with Feeding`", and book a date during the `weekend`.
The test related to this case need to first pass the generic tests, then test ticket types and VIP related functions. 

#### User-story
`As a:` Family of 4

`We want:` To purchase 4 VIP tickets

`So that:` To visit the park during a weekend

`and:` Watch the dinosaurs up close.

#### Short summary of what we need to test based on user-story:

- Create user
- Login
- Purchase ticket
  - Being able to purchase both ticket types: adult and children
  - Being able to buy a VIP ticket
- Book tours
  - Book weekend pass for feeding and extreme tour (VIP)

#### Example test case:

- Create user 1
  - Purchase tickets
    - 2 Adult tickets
    - 2 Children tickets
  - Book tours
    - Book VIP tours (Feeding Dino's)
    - Book the tour during weekend
- Complete full purchase
