# 🏋️ Gym Membership & Workout Tracking System

A complete gym management web application built with **Python Flask**, **MySQL**, and **HTML/CSS**.

---

## 📋 Features

- **Member Management** — Add and view gym members
- **Trainer Management** — Add and view trainers
- **Trainer Assignment** — Assign trainers to members
- **Attendance Tracking** — Mark daily check-ins
- **Progress Logging** — Track member weight over time
- **Payment Recording** — Record membership payments
- **Analytics Dashboard** — Attendance consistency, weight progress, trainer workload

---

## 🛠️ Tech Stack

| Layer    | Technology          |
|----------|---------------------|
| Backend  | Python 3 + Flask    |
| Database | MySQL               |
| Frontend | HTML + Vanilla CSS  |

---

## 🚀 Setup Instructions (Easiest Method)

We have included automated setup scripts that make running the application as easy as double-clicking a file!

**For Windows Users:**
Double click on `run.bat` or run it in your terminal:
```cmd
run.bat
```

**For Linux / macOS Users:**
Run the shell script in your terminal:
```bash
chmod +x run.sh
./run.sh
```

The script will ask you if you want to run the app using **Docker** (Recommended) or through a **Local Python Setup**. It will automatically handle everything (creating environments, installing requirements, setting up the database, and opening your browser).

---

## 🛠️ Setup Instructions (Manual Methods)

If you prefer to configure everything manually, choose one of the options below.

### Option 1: Running with Docker (Manual)

1. **Prerequisites**: [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed.
2. **Clone the repository**:
   ```bash
   git clone https://github.com/TheOnlySG/GymManager
   cd GymManager
   ```
3. **Run Docker Compose**:
   ```bash
   docker compose up -d --build
   ```
4. **Access the application**: Head to **http://localhost:5000**. (The database is automatically created and populated).

### Option 2: Local Python Setup (Manual)

1. **Prerequisites**: **Python 3.8+** and **MySQL 8.0+** installed.
2. **Install Python dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
3. **Set up the database**:
   ```bash
   mysql -u root -p < db.sql
   ```
4. **Configure database password**:
   Export your MySQL password as an environment variable before running the app:
   ```bash
   export DB_PASSWORD="your_password"
   ```
5. **Run the server**:
   ```bash
   python app.py
   ```

---

## 🎬 Demo Flow (5–7 minutes)

Follow these steps to demonstrate all features:

| Step | Action | URL |
|------|--------|-----|
| 1 | View all members (pre-loaded sample data) | `/members` |
| 2 | Add a new member via form | `/members` |
| 3 | View all trainers | `/trainers` |
| 4 | Add a new trainer | `/trainers` |
| 5 | Assign a trainer to a member | `/assign-trainer` |
| 6 | Mark attendance for a member | `/attendance` |
| 7 | Log a weight entry | `/progress` |
| 8 | Record a payment | `/payments` |
| 9 | View attendance analytics | `/analytics/attendance` |
| 10 | View weight progress analytics | `/analytics/progress` |
| 11 | View trainer workload analytics | `/analytics/trainers` |

---

## 📁 Project Structure

```text
GymManager/
├── app.py              # Flask application (all routes)
├── db.sql              # Database schema + sample data
├── requirements.txt    # Python dependencies
├── Dockerfile          # Docker image configuration for web app
├── docker-compose.yml  # Docker Compose orchestration
├── run.bat             # Windows automated setup wizard
├── run.sh              # Linux/Mac automated setup wizard
├── README.md           # This file
├── static/
│   └── style.css       # Stylesheet
└── templates/
    ├── base.html       # Base layout with navbar
    ├── members.html    # Members page
    ├── trainers.html   # Trainers page
    ├── assign.html     # Trainer assignment page
    ├── attendance.html # Attendance page
    ├── progress.html   # Progress tracking page
    ├── payments.html   # Payments page
    └── analytics.html  # Analytics dashboard
```

---

## 📊 Database Tables

| Table | Description |
|-------|-------------|
| `members` | Gym members with membership info |
| `trainers` | Trainer profiles and specializations |
| `trainer_assignments` | Member-trainer assignments |
| `attendance` | Daily check-in records |
| `progress_logs` | Weight tracking entries |
| `payments` | Payment transactions |

---

## ⚠️ Notes

- The default setup scripts and Docker configuration expect standard MySQL setups.
- Sample data is automatically injected during setup, including 10 members and 3 trainers.
- The app currently runs in debug mode for development purposes. Disable debug mode before using in a production environment.
