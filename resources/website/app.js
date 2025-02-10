// Global variables
let currentUser = null; // User object: { username, password, vip }
let pendingTicketPurchase = null; // For ticket checkout
let pendingSafariBooking = null;    // For safari checkout

// Pricing definitions
const ticketBasePrices = {
  "Adult": 50,
  "Child": 30,
  "Senior": 40
};
const safariPrices = {
  "Herbivore Tour": 120,
  "T-Rex Rumble": 150,
  "Herbivore Tour with Feeding": 180,
  "T-Rex Rumble eXtreme Thrill Pack": 220
};

/* ========= Message Helpers ========= */
function showMessage(elementId, message, isSuccess) {
  const el = document.getElementById(elementId);
  el.textContent = message;
  if (isSuccess) {
    el.classList.remove("error");
    el.classList.add("success");
  } else {
    el.classList.remove("success");
    el.classList.add("error");
  }
}
function clearMessages() {
  document.querySelectorAll(".message").forEach(el => {
    el.textContent = "";
    el.classList.remove("error", "success");
  });
}

/* ========= Section Navigation ========= */
function showSection(sectionId) {
  clearMessages();
  const sections = document.querySelectorAll("main article section"); // Corrected selector
  sections.forEach(sec => sec.style.display = "none");
  document.getElementById(sectionId).style.display = "block";
}

/* ========= Navigation & User Handling ========= */
function updateNav() {
  if (currentUser) {
    document.getElementById("register-nav").style.display = "none";
    document.getElementById("login-nav").style.display = "none";
    document.getElementById("logout-nav").style.display = "block";
  } else {
    document.getElementById("register-nav").style.display = "block";
    document.getElementById("login-nav").style.display = "block";
    document.getElementById("logout-nav").style.display = "none";
  }
}
function logout() {
  currentUser = null;
  alert("You have been logged out.");
  updateNav();
  showSection("home-section");
}

/* ========= User Storage ========= */
function getUsers() {
  const usersJSON = localStorage.getItem("users");
  return usersJSON ? JSON.parse(usersJSON) : [];
}
function saveUsers(users) {
  localStorage.setItem("users", JSON.stringify(users));
}

/* ========= Registration ========= */
document.getElementById("register-form").addEventListener("submit", function(e) {
  e.preventDefault();
  const username = document.getElementById("reg-username").value.trim();
  const password = document.getElementById("reg-password").value;

  if (!username || !password) {
    showMessage("register-message", "Please enter both a username and password.", false);
    return;
  }

  if (password.length < 8) {
    showMessage("register-message", "Password must be at least 8 characters long.", false);
    return;
  }

  const users = getUsers();
  if (users.some(u => u.username === username)) {
    showMessage("register-message", "Username already exists. Please choose another.", false);
    return;
  }

  users.push({ username, password, vip: false }); // In reality, hash the password here!
  saveUsers(users);
  showMessage("register-message", "Registration successful! Redirecting to login...", true);
  document.getElementById("register-form").reset();

  // Redirect to login page after 2 seconds
  setTimeout(() => {
    showSection("login-section");
  }, 2000);
});

/* ========= Login ========= */
document.getElementById("login-form").addEventListener("submit", function(e) {
  e.preventDefault();
  const username = document.getElementById("login-username").value.trim();
  const password = document.getElementById("login-password").value;
  showMessage("login-message", "Verifying credentials...", true);
  setTimeout(() => {
    const users = getUsers();
    const user = users.find(u => u.username === username && u.password === password);
    if (user) {
      currentUser = user;
      showMessage("login-message", "Login successful!", true);
      updateNav();
      showSection("home-section");
    } else {
      showMessage("login-message", "Invalid username or password.", false);
    }
  }, 2000);
});

/* ========= Ticket Purchase ========= */
document.getElementById("ticket-form").addEventListener("submit", function(e) {
  e.preventDefault();
  if (!currentUser) {
    alert("You must be logged in to purchase tickets.");
    showSection("login-section");
    return;
  }
  const ticketType = document.getElementById("ticket-type").value;
  const ticketCategory = document.getElementById("ticket-category").value;
  const quantity = parseInt(document.getElementById("ticket-quantity").value, 10);
  let pricePerTicket = ticketBasePrices[ticketType];
  if (ticketCategory === "VIP") {
    pricePerTicket *= 2;
    // Upgrade user to VIP if needed.
    if (!currentUser.vip) {
      currentUser.vip = true;
      const users = getUsers();
      const idx = users.findIndex(u => u.username === currentUser.username);
      if (idx !== -1) {
        users[idx].vip = true;
        saveUsers(users);
      }
    }
  }
  const totalPrice = pricePerTicket * quantity;
  pendingTicketPurchase = {
    type: ticketType,
    category: ticketCategory,
    quantity,
    price: totalPrice
  };
  document.getElementById("ticket-checkout-details").innerHTML = `
    <p><strong>Ticket Type:</strong> ${ticketType}</p>
    <p><strong>Ticket Category:</strong> ${ticketCategory}</p>
    <p><strong>Quantity:</strong> ${quantity}</p>
    <p><strong>Total Price:</strong> $${totalPrice}</p>
  `;
  showSection("ticket-checkout-section");
});

// Ticket Checkout Confirmation & Cancellation
document.getElementById("confirm-ticket").addEventListener("click", function() {
  if (!pendingTicketPurchase) {
    showMessage("ticket-checkout-message", "No pending purchase to confirm.", false);
    return;
  }
  alert(`Ticket purchase confirmed: ${pendingTicketPurchase.quantity} ${pendingTicketPurchase.category} ${pendingTicketPurchase.type} ticket(s) for $${pendingTicketPurchase.price}.`);
  pendingTicketPurchase = null;
  document.getElementById("ticket-form").reset();
  showSection("home-section");
});
document.getElementById("cancel-ticket").addEventListener("click", function() {
  pendingTicketPurchase = null;
  showSection("tickets-section");
});

// Dynamic ticket price update
function updateTicketPrice() {
  const ticketType = document.getElementById("ticket-type").value;
  const ticketCategory = document.getElementById("ticket-category").value;
  const quantity = parseInt(document.getElementById("ticket-quantity").value, 10) || 0;
  let pricePerTicket = ticketBasePrices[ticketType];
  if (ticketCategory === "VIP") {
    pricePerTicket *= 2;
  }
  const totalPrice = pricePerTicket * quantity;
  document.getElementById("ticket-price-display").textContent = `Current Price: $${totalPrice}`;
}
document.getElementById("ticket-type").addEventListener("change", updateTicketPrice);
document.getElementById("ticket-category").addEventListener("change", updateTicketPrice);
document.getElementById("ticket-quantity").addEventListener("input", updateTicketPrice);
updateTicketPrice();

/* ========= Safari Booking ========= */
function updateSafariOptions() {
  const safariSelect = document.getElementById("safari-type");
  safariSelect.innerHTML = "";
  const options = [
    { value: "Herbivore Tour", text: "Herbivore Tour" },
    { value: "T-Rex Rumble", text: "T-Rex Rumble" },
  ];
  if (currentUser && currentUser.vip) {
    options.push({ value: "Herbivore Tour with Feeding", text: "Herbivore Tour with Feeding" });
    options.push({ value: "T-Rex Rumble eXtreme Thrill Pack", text: "T-Rex Rumble eXtreme Thrill Pack" });
  }
  options.forEach(opt => {
    const option = document.createElement("option");
    option.value = opt.value;
    option.textContent = opt.text;
    safariSelect.appendChild(option);
  });
}
// Update safari options whenever the Safari nav is clicked.
document.getElementById("safari-nav").addEventListener("click", function() {
  if (currentUser) {
    updateSafariOptions();
  }
});
document.getElementById("safari-form").addEventListener("submit", function(e) {
  e.preventDefault();
  if (!currentUser) {
    alert("You must be logged in to book a safari.");
    showSection("login-section");
    return;
  }
  const safariDate = document.getElementById("safari-date").value;
  const safariType = document.getElementById("safari-type").value;
  if (!safariDate) {
    showMessage("safari-message", "Please select a date for your safari booking.", false);
    return;
  }
  const selectedDate = new Date(safariDate);
  selectedDate.setHours(0, 0, 0, 0);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (selectedDate < today) {
    showMessage("safari-message", "You cannot book a safari for a date in the past.", false);
    return;
  }
  const day = selectedDate.getDay();
  if (!currentUser.vip && (day === 0 || day === 6)) {
    showMessage("safari-message", "Only VIP users can book safaris on weekends.", false);
    return;
  }
  if (!currentUser.vip && (safariType === "Herbivore Tour with Feeding" || safariType === "T-Rex Rumble eXtreme Thrill Pack")) {
    showMessage("safari-message", "Only VIP users can book the selected safari option.", false);
    return;
  }
  const safariPrice = safariPrices[safariType] || 0;
  pendingSafariBooking = {
    date: safariDate,
    type: safariType,
    price: safariPrice
  };
  document.getElementById("safari-checkout-details").innerHTML = `
    <p><strong>Safari Date:</strong> ${safariDate}</p>
    <p><strong>Safari Type:</strong> ${safariType}</p>
    <p><strong>Price:</strong> $${safariPrice}</p>
  `;
  showSection("safari-checkout-section");
});
document.getElementById("confirm-safari").addEventListener("click", function() {
  if (!pendingSafariBooking) {
    showMessage("safari-checkout-message", "No pending booking to confirm.", false);
    return;
  }
  alert(`Booking confirmed: ${pendingSafariBooking.type} on ${pendingSafariBooking.date} for $${pendingSafariBooking.price}`);
  pendingSafariBooking = null;
  document.getElementById("safari-form").reset();
  showSection("home-section");
});
document.getElementById("cancel-safari").addEventListener("click", function() {
  pendingSafariBooking = null;
  showSection("safari-section");
});

document.addEventListener("DOMContentLoaded", () => {
  // Initial setup
  updateNav();
  showSection("home-section");

  // Event listeners for navigation links
  document.querySelectorAll('nav a[data-section], .card-button').forEach(link => {
    link.addEventListener('click', function(event) {
      event.preventDefault();  // Prevent default link behavior
      const sectionId = this.dataset.section;
      showSection(sectionId);
    });
  });

  // Logout event listener
  document.getElementById('logout-link').addEventListener('click', function(event) {
    event.preventDefault();
    logout();
  });
});