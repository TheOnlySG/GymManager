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

## 🚀 Setup Instructions

### 1. Prerequisites

- **Python 3.8+** installed
- **MySQL 8.0+** installed and running

### 2. Clone / Navigate to the project

```bash
cd c:\Spandan
```

### 3. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 4. Set up the database

Open a MySQL client and run:

```sql
source db.sql;
```

Or from terminal:

```bash
mysql -u root -p < db.sql
```

This creates the `gym_management` database, all tables, and inserts sample data.

### 5. Configure database password

Open `app.py` and set your MySQL root password in the `DB_CONFIG` dictionary:

```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'YOUR_PASSWORD_HERE',   # ← change this
    'database': 'gym_management'
}
```

### 6. Run the server

```bash
python app.py
```

The app will start at: **http://127.0.0.1:5000**

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

```
c:\Spandan\
├── app.py              # Flask application (all routes)
├── db.sql              # Database schema + sample data
├── requirements.txt    # Python dependencies
├── README.md           # This file
├── PRD.md              # Product Requirements Document
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

- Default MySQL user is `root` with empty password — update in `app.py`
- Sample data includes 10 members, 3 trainers, and related records
- The app runs in debug mode for development; disable for production
