# TapFood

A food ordering web application built as a Java Dynamic Web Project. Users can
browse restaurants, explore their menus, build a cart, check out and track their
past orders. Authentication uses BCrypt-hashed passwords, and all data is
persisted in MySQL through a DAO layer written with plain JDBC.

---

## Features

Every feature listed here is implemented in this repository.

**Accounts**
- User registration with client-side and server-side validation
- Login by either username or email
- Passwords hashed with BCrypt — plaintext passwords are never stored
- Forgot password / reset password flow
- Session-based login state, with logout

**Ordering**
- Restaurant listing with cuisine type, rating and delivery time
- Per-restaurant menu pages
- Add items to a session cart
- Update item quantities and remove items from the cart
- Checkout with delivery address and payment mode selection
- Order placement, writing an order plus its line items
- Order confirmation page
- Order history for the logged-in user

**Profile**
- User profile page
- Address book: add, edit and delete multiple saved delivery addresses

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Web API | Jakarta Servlet 6.0 |
| Views | JSP with shared `.jspf` fragments |
| Server | Apache Tomcat 10.1.x |
| Database | MySQL |
| DB access | JDBC via MySQL Connector/J 9.2.0 |
| Password hashing | jBCrypt 0.4 |
| Build | Maven (WAR packaging), Maven Wrapper included |
| Frontend | HTML, CSS, vanilla JavaScript |

> **Note on Jakarta vs javax:** Tomcat 10 and later use the `jakarta.*`
> namespace rather than `javax.*`. This project targets Jakarta Servlet 6.0, so
> it requires **Tomcat 10.1.x or newer** and will not run on Tomcat 9.

---

## Project Structure

```
tapfood/
├── pom.xml                        Maven build, dependencies, WAR packaging
├── mvnw, mvnw.cmd, .mvn/          Maven Wrapper — build without installing Maven
├── database/
│   └── schema.sql                 MySQL table definitions
├── .env.example                   Template for the required environment variables
└── src/main/
    ├── java/
    │   ├── com/food/servlet/      Controllers — one servlet per responsibility
    │   │   ├── RegisterServlet        /Registration
    │   │   ├── LoginServlet           /Login
    │   │   ├── ResetPasswordServlet   /ResetPassword
    │   │   ├── RestaurantServlet      /restaurant
    │   │   ├── MenuServlet            /menu
    │   │   ├── CartServlet            /cart
    │   │   ├── OrderServlet           /placeOrder
    │   │   └── AddressServlet         /address
    │   └── com/tap/
    │       ├── model/             POJOs: User, Restaurant, Menu, Cart,
    │       │                      CartItem, Order, OrderItem, UserAddress
    │       ├── DAO/               Data-access interfaces
    │       ├── DAOImpl/           JDBC implementations of those interfaces
    │       └── utility/
    │           └── DBConnection   Central connection factory, reads config
    │                              from environment variables
    └── webapp/
        ├── *.jsp, register.html   Views
        ├── css/style.css          Styling
        ├── images/                Restaurant and food imagery
        └── WEB-INF/
            ├── web.xml            Deployment descriptor
            └── jspf/              Shared header, footer and asset includes
```

**Architecture.** Requests hit a servlet, which validates input and delegates to
a DAO interface. The DAO implementation runs the JDBC query and maps rows onto
model objects, and the servlet then forwards to a JSP for rendering.

Every query that accepts user input goes through a `PreparedStatement` with bound
placeholders, so no user-supplied value is ever concatenated into SQL. The only
plain `Statement` uses are the parameterless `getAll*()` methods, whose SQL is a
fixed string.

Separating `DAO` from `DAOImpl` keeps the persistence mechanism swappable
without touching controller code.

---

## How to Run Locally

### Prerequisites

- JDK 21 or newer
- MySQL 8.x running locally
- Apache Tomcat 10.1.x
- Maven is **not** required — the included wrapper downloads it automatically

### 1. Clone

```bash
git clone https://github.com/DeepakMahendiran/tapfood.git
cd tapfood
```

### 2. Create the database

See [Database Setup](#database-setup) below.

### 3. Set the environment variables

See [Environment Variables](#environment-variables) below. The application will
fail to connect if these are not set.

### 4. Build the WAR

On macOS or Linux:

```bash
./mvnw clean package
```

On Windows:

```bash
mvnw.cmd clean package
```

This produces `target/tapfood.war`.

### 5. Deploy to Tomcat

Copy the WAR into your Tomcat installation and start the server:

```bash
cp target/tapfood.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

Then open <http://localhost:8080/tapfood/>.

### Running from Eclipse instead

The project also imports directly into Eclipse:

1. **File → Import → Existing Maven Projects**, select the cloned folder.
2. Right-click the project → **Properties → Targeted Runtimes** → tick your
   Apache Tomcat 10.1 runtime.
3. Add the three environment variables under **Run → Run Configurations →**
   your Tomcat server **→ Environment**.
4. Right-click the project → **Run As → Run on Server**.

---

## Database Setup

The application expects a MySQL database named `Tapfood` containing six tables:
`user`, `restaurant`, `menu`, `user_address`, `orderTable` and `orderItem`.

Create them with the bundled schema file:

```bash
mysql -u your_username -p < database/schema.sql
```

You will be prompted for your MySQL password — it is never stored in this
repository.

The schema creates the database if it does not already exist, so this single
command is enough for a fresh setup.

Once the tables exist, add at least one restaurant and a few menu items so the
listing pages have something to show. Restaurant and menu `imagePath` values
should match filenames present in `src/main/webapp/images/`.

---

## Environment Variables

Database configuration is read from environment variables at runtime, so no
credentials are committed to source control. `DBConnection.java` reads:

| Variable | Purpose | Example |
|---|---|---|
| `DB_URL` | JDBC connection string | `jdbc:mysql://localhost:3306/Tapfood` |
| `DB_USERNAME` | MySQL user | `your_username` |
| `DB_PASSWORD` | Password for that user | `your_password` |

A template lives in [`.env.example`](.env.example).

These must be visible to the **Tomcat process**, not just your terminal.

**Eclipse** — Run → Run Configurations → select your Tomcat server →
**Environment** tab → **New** for each variable.

**Standalone Tomcat on Windows** — create `%CATALINA_HOME%\bin\setenv.bat`:

```bat
set DB_URL=jdbc:mysql://localhost:3306/Tapfood
set DB_USERNAME=your_username
set DB_PASSWORD=your_password
```

**Standalone Tomcat on macOS or Linux** — create `$CATALINA_HOME/bin/setenv.sh`:

```bash
export DB_URL=jdbc:mysql://localhost:3306/Tapfood
export DB_USERNAME=your_username
export DB_PASSWORD=your_password
```

Make it executable with `chmod +x setenv.sh`. Tomcat picks this file up
automatically on startup.

---

## Screenshots

<!-- Add screenshots here. Suggested: save images under docs/screenshots/ and
     reference them as shown below. -->

| Home / Restaurants | Menu |
|---|---|
| _coming soon_ | _coming soon_ |

| Cart | Checkout |
|---|---|
| _coming soon_ | _coming soon_ |

| Order History | Profile |
|---|---|
| _coming soon_ | _coming soon_ |

---

## Live Demo

_Deployment in progress — the live URL will be added here._

---

## Repository

<https://github.com/DeepakMahendiran/tapfood>

---

## Author

**Deepak Mahendiran** — [@DeepakMahendiran](https://github.com/DeepakMahendiran)
