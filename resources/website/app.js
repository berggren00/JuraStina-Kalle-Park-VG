// Global variables
let currentUser = null; // User object: { username, password, vip }

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
    const sections = document.querySelectorAll("main article section");
    sections.forEach(sec => sec.style.display = "none");
    document.getElementById(sectionId).style.display = "block";
}

/* ========= Navigation & User Handling ========= */
function updateNav() {
    if (currentUser) {
        document.getElementById("register-nav").style.display = "none";
        document.getElementById("login-nav").style.display = "none";
        document.getElementById("logout-nav").style.display = "block";
        document.getElementById("cart-nav").style.display = "block";
    } else {
        document.getElementById("register-nav").style.display = "block";
        document.getElementById("login-nav").style.display = "block";
        document.getElementById("logout-nav").style.display = "none";
        document.getElementById("cart-nav").style.display = "none";
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
document.getElementById("register-form").addEventListener("submit", function (e) {
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

    users.push({ username, password, vip: false });
    saveUsers(users);

    // Set VIP Status to local storage for future logins
    const storedUsers = getUsers();
    const storedUser = storedUsers.find(u => u.username === username);
    if (storedUser) {
        localStorage.setItem("users", JSON.stringify(storedUsers));
    }

    showMessage("register-message", "Registration successful! Redirecting to login...", true);
    document.getElementById("register-form").reset();

    // Redirect to login page after 2 seconds
    setTimeout(() => {
        showSection("login-section");
    }, 2000);
});

/* ========= Login ========= */
document.getElementById("login-form").addEventListener("submit", function (e) {
    e.preventDefault();
    const username = document.getElementById("login-username").value.trim();
    const password = document.getElementById("login-password").value;
    showMessage("login-message", "Verifying credentials...", true);
    setTimeout(() => {
        const users = getUsers();
        const user = users.find(u => u.username === username && u.password === password);
        if (user) {
            currentUser = user;
            // Retrieve VIP status from local storage
            const storedUsers = getUsers();
            const storedUser = storedUsers.find(u => u.username === username);
            if (storedUser) {
                currentUser.vip = storedUser.vip; // Assign VIP Status
            }
            showMessage("login-message", "Login successful!", true);
            updateNav();
            showSection("home-section");
        } else {
            showMessage("login-message", "Invalid username or password.", false);
        }
    }, 2000);
});

/* ========= Cart Functionality ========= */

// Function to get the cart from local storage
function getCart() {
    const cartJSON = localStorage.getItem("cart");
    return cartJSON ? JSON.parse(cartJSON) : [];
}

// Function to save the cart to local storage
function saveCart(cart) {
    localStorage.setItem("cart", JSON.stringify(cart));
}

// Function to add an item to the cart
function addToCart(item) {
    const cart = getCart();
    cart.push(item);
    saveCart(cart);
    updateCartDisplay();
    alert("Item added to cart!");
}

// Function to remove an item from the cart
function removeFromCart(index) {
    const cart = getCart();
    cart.splice(index, 1);
    saveCart(cart);
    updateCartDisplay();
}

// Function to calculate the total price of the cart
function calculateCartTotal() {
    const cart = getCart();
    let total = 0;
    for (const item of cart) {
        total += item.price;
    }
    return total;
}

// Function to update the cart display
function updateCartDisplay() {
    const cart = getCart();
    const cartDetails = document.getElementById("cart-details");
    cartDetails.innerHTML = "";

    if (cart.length === 0) {
        cartDetails.innerHTML = "<p>Your cart is empty.</p>";
        document.getElementById("cart-total").textContent = "Total: $0";
        document.getElementById("checkout-button").disabled = true;
        return;
    }

    let cartHtml = "<ul>";
    for (let i = 0; i < cart.length; i++) {
        const item = cart[i];
        cartHtml += `<li>
                       ${item.description} - $${item.price}
                       <button onclick="removeFromCart(${i})">Remove</button>
                     </li>`;
    }
    cartHtml += "</ul>";
    cartDetails.innerHTML = cartHtml;
    const total = calculateCartTotal();
    document.getElementById("cart-total").textContent = `Total: $${total}`;
    document.getElementById("checkout-button").disabled = false;

}

/* ========= Ticket Purchase ========= */
document.getElementById("ticket-form").addEventListener("submit", function (e) {
    e.preventDefault();
    clearMessages(); // ADD THIS LINE - clears messages BEFORE processing

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

                // Update in localStorage
                localStorage.setItem("users", JSON.stringify(users));
            }
        }
    }
    const totalPrice = pricePerTicket * quantity;
    const ticketItem = {
        description: `${quantity} ${ticketCategory} ${ticketType} Ticket(s)`,
        category: ticketCategory,
        quantity: quantity,
        price: totalPrice,
        itemType: "ticket"
    };
    addToCart(ticketItem);
    document.getElementById("ticket-form").reset();
});


/* ========= Safari Booking ========= */
document.getElementById("safari-form").addEventListener("submit", function (e) {
    e.preventDefault();
    clearMessages(); // ADD THIS LINE - clears messages BEFORE processing

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

    if (!safariType) {
        showMessage("safari-message", "Please select a type for your safari booking.", false);
        return;
    }

    const selectedDate = new Date(safariDate);
    const day = selectedDate.getDay(); // 0 (Sun) to 6 (Sat)

    // Check VIP Status (Get from local storage)
    let storedUsers = getUsers();
    let storedUser = storedUsers.find(u => u.username === currentUser.username);
    let isVip = storedUser ? storedUser.vip : false;
    if (!isVip && (safariType === "Herbivore Tour with Feeding" || safariType === "T-Rex Rumble eXtreme Thrill Pack")) {
        showMessage("safari-message", "Only VIP users can book the selected safari option.", false);
        return;
    }

    const cart = getCart();
    const hasTicket = cart.some(item => item.itemType === "ticket");
    const hasVipTicket = cart.some(item => item.itemType === "ticket" && item.category === "VIP");
    if (!hasTicket) {
        showMessage("safari-message", "You must purchase a general admission ticket before booking a safari.", false);
        return;
    }

    if ((day === 0 || day === 6) && !hasVipTicket) {
        showMessage("safari-message", "VIP tickets required to book safaris on weekends.", false);
        return;
    }

    selectedDate.setHours(0, 0, 0, 0);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (selectedDate < today) {
        showMessage("safari-message", "You cannot book a safari for a date in the past.", false);
        return;
    }

    const safariPrice = safariPrices[safariType] || 0;

    const safariItem = {
        description: `${safariType} on ${safariDate}`,
        date: safariDate,
        type: safariType,
        price: safariPrice,
        itemType: "safari"
    };
    addToCart(safariItem);
    document.getElementById("safari-form").reset();
});

// Cart Checkout Logic
document.getElementById("checkout-button").addEventListener("click", function () {
    const cart = getCart();
    if (cart.length === 0) {
        alert("Your cart is empty.  Nothing to checkout.");
        return;
    }

    // Check if there's at least one admission ticket in the cart
    const hasAdmissionTicket = cart.some(item => item.itemType === "ticket");
    if (!hasAdmissionTicket) {
        alert("You must have at least one admission ticket in your cart to complete checkout. Safari experiences cannot be purchased without admission tickets.");
        return;
    }

    // Process the cart items (e.g., create a summary for the user)
    let summary = "Checkout Summary:\n";
    let totalPrice = 0;
    cart.forEach(item => {
        summary += `${item.description} - $${item.price}\n`;
        totalPrice += item.price;
    });
    summary += `Total: $${totalPrice}`;

    alert(summary);  // Replace with your actual checkout process
    localStorage.removeItem("cart");  // Clear cart after checkout
    updateCartDisplay();
    showSection("home-section");

});

document.getElementById("cart-nav").addEventListener("click", function () {
    updateCartDisplay();
    showSection("cart-section");
});

document.addEventListener("DOMContentLoaded", () => {
    updateNav();
    showSection("home-section");

    // *** NEW CODE TO POPULATE SAFARI TYPES ***
    const safariTypeSelect = document.getElementById("safari-type");
    for (const safariType in safariPrices) {
        if (safariPrices.hasOwnProperty(safariType)) { // Safest way to loop through objects
            const option = document.createElement("option");
            option.value = safariType; // Value is the *key* from safariPrices
            option.textContent = safariType; // Display text to the user
            safariTypeSelect.appendChild(option);
        }
    }
    // *** END NEW CODE ***

    document.querySelectorAll('nav a[data-section], .card-button').forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const sectionId = this.dataset.section;
            showSection(sectionId);
        });
    });


    document.getElementById('logout-link').addEventListener('click', function (event) {
        event.preventDefault();
        logout();
    });
});