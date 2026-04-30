"""
Gym Membership & Workout Tracking System
Flask Backend Application
"""

from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector
from mysql.connector import Error
import os

app = Flask(__name__)
app.secret_key = 'gym_manager_secret_key_2025'

# ============================================
# Database Connection
# ============================================

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'password'),
    'database': os.getenv('DB_NAME', 'gym_management')
}


def get_db():
    """Create and return a database connection."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Database connection error: {e}")
        return None


def query_db(sql, params=None, fetchone=False):
    """Execute a SELECT query and return results as list of dicts."""
    conn = get_db()
    if not conn:
        return [] if not fetchone else None
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql, params or ())
        result = cursor.fetchone() if fetchone else cursor.fetchall()
        return result
    except Error as e:
        print(f"Query error: {e}")
        return None if fetchone else []
    finally:
        conn.close()


def execute_db(sql, params=None):
    """Execute an INSERT/UPDATE/DELETE query."""
    conn = get_db()
    if not conn:
        return False
    try:
        cursor = conn.cursor()
        cursor.execute(sql, params or ())
        conn.commit()
        return True
    except Error as e:
        print(f"Execute error: {e}")
        conn.rollback()
        return False
    finally:
        conn.close()


# ============================================
# Home Route
# ============================================

@app.route('/')
def home():
    return redirect(url_for('members'))


# ============================================
# Members Routes
# ============================================

@app.route('/members')
def members():
    members_list = query_db(
        "SELECT * FROM members ORDER BY member_id DESC"
    )
    return render_template('members.html', members=members_list)


@app.route('/add-member', methods=['POST'])
def add_member():
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    phone = request.form.get('phone', '')
    dob = request.form.get('date_of_birth', None)
    gender = request.form['gender']
    membership_type = request.form['membership_type']

    # Handle empty date
    if not dob:
        dob = None

    success = execute_db(
        """INSERT INTO members 
           (first_name, last_name, email, phone, date_of_birth, gender, membership_type)
           VALUES (%s, %s, %s, %s, %s, %s, %s)""",
        (first_name, last_name, email, phone, dob, gender, membership_type)
    )

    if success:
        flash('Member added successfully!', 'success')
    else:
        flash('Error adding member. Email may already exist.', 'error')

    return redirect(url_for('members'))


# ============================================
# Trainers Routes
# ============================================

@app.route('/trainers')
def trainers():
    trainers_list = query_db(
        "SELECT * FROM trainers ORDER BY trainer_id DESC"
    )
    return render_template('trainers.html', trainers=trainers_list)


@app.route('/add-trainer', methods=['POST'])
def add_trainer():
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    phone = request.form.get('phone', '')
    specialization = request.form.get('specialization', '')

    success = execute_db(
        """INSERT INTO trainers 
           (first_name, last_name, email, phone, specialization)
           VALUES (%s, %s, %s, %s, %s)""",
        (first_name, last_name, email, phone, specialization)
    )

    if success:
        flash('Trainer added successfully!', 'success')
    else:
        flash('Error adding trainer. Email may already exist.', 'error')

    return redirect(url_for('trainers'))


# ============================================
# Trainer Assignment Routes
# ============================================

@app.route('/assign-trainer', methods=['GET', 'POST'])
def assign_trainer():
    if request.method == 'POST':
        member_id = request.form['member_id']
        trainer_id = request.form['trainer_id']

        success = execute_db(
            """INSERT INTO trainer_assignments (member_id, trainer_id)
               VALUES (%s, %s)""",
            (member_id, trainer_id)
        )

        if success:
            flash('Trainer assigned successfully!', 'success')
        else:
            flash('Error assigning trainer.', 'error')

        return redirect(url_for('assign_trainer'))

    # GET: load members, trainers, and current assignments
    members_list = query_db(
        "SELECT member_id, first_name, last_name FROM members WHERE status = 'Active' ORDER BY first_name"
    )
    trainers_list = query_db(
        "SELECT trainer_id, first_name, last_name, specialization FROM trainers WHERE status = 'Active' ORDER BY first_name"
    )
    assignments = query_db(
        """SELECT ta.assignment_id,
                  CONCAT(m.first_name, ' ', m.last_name) AS member_name,
                  CONCAT(t.first_name, ' ', t.last_name) AS trainer_name,
                  t.specialization,
                  ta.assigned_date,
                  ta.status
           FROM trainer_assignments ta
           JOIN members m ON ta.member_id = m.member_id
           JOIN trainers t ON ta.trainer_id = t.trainer_id
           ORDER BY ta.assignment_id DESC"""
    )

    return render_template('assign.html',
                           members=members_list,
                           trainers=trainers_list,
                           assignments=assignments)


# ============================================
# Attendance Routes
# ============================================

@app.route('/attendance', methods=['GET', 'POST'])
def attendance():
    if request.method == 'POST':
        member_id = request.form['member_id']

        success = execute_db(
            "INSERT INTO attendance (member_id) VALUES (%s)",
            (member_id,)
        )

        if success:
            flash('Attendance marked successfully!', 'success')
        else:
            flash('Error marking attendance.', 'error')

        return redirect(url_for('attendance'))

    # GET: load members and recent attendance
    members_list = query_db(
        "SELECT member_id, first_name, last_name FROM members WHERE status = 'Active' ORDER BY first_name"
    )
    records = query_db(
        """SELECT a.attendance_id, m.first_name, m.last_name,
                  a.check_in_date, a.check_in_time
           FROM attendance a
           JOIN members m ON a.member_id = m.member_id
           ORDER BY a.check_in_date DESC, a.check_in_time DESC
           LIMIT 50"""
    )

    return render_template('attendance.html',
                           members=members_list,
                           records=records)


# ============================================
# Progress Routes
# ============================================

@app.route('/progress', methods=['GET', 'POST'])
def progress():
    if request.method == 'POST':
        member_id = request.form['member_id']
        weight_kg = request.form['weight_kg']
        notes = request.form.get('notes', '')

        success = execute_db(
            """INSERT INTO progress_logs (member_id, weight_kg, notes)
               VALUES (%s, %s, %s)""",
            (member_id, weight_kg, notes)
        )

        if success:
            flash('Weight logged successfully!', 'success')
        else:
            flash('Error logging weight.', 'error')

        return redirect(url_for('progress'))

    # GET: load members and progress logs
    members_list = query_db(
        "SELECT member_id, first_name, last_name FROM members WHERE status = 'Active' ORDER BY first_name"
    )
    logs = query_db(
        """SELECT pl.log_id, m.first_name, m.last_name,
                  pl.log_date, pl.weight_kg, pl.notes
           FROM progress_logs pl
           JOIN members m ON pl.member_id = m.member_id
           ORDER BY pl.log_date DESC
           LIMIT 50"""
    )

    return render_template('progress.html',
                           members=members_list,
                           logs=logs)


# ============================================
# Payments Routes
# ============================================

@app.route('/payments', methods=['GET', 'POST'])
def payments():
    if request.method == 'POST':
        member_id = request.form['member_id']
        amount = request.form['amount']
        payment_method = request.form['payment_method']
        description = request.form.get('description', '')

        success = execute_db(
            """INSERT INTO payments (member_id, amount, payment_method, description)
               VALUES (%s, %s, %s, %s)""",
            (member_id, amount, payment_method, description)
        )

        if success:
            flash('Payment recorded successfully!', 'success')
        else:
            flash('Error recording payment.', 'error')

        return redirect(url_for('payments'))

    # GET: load members and payment history
    members_list = query_db(
        "SELECT member_id, first_name, last_name FROM members WHERE status = 'Active' ORDER BY first_name"
    )
    payments_list = query_db(
        """SELECT p.payment_id, m.first_name, m.last_name,
                  p.amount, p.payment_method, p.payment_date, p.description
           FROM payments p
           JOIN members m ON p.member_id = m.member_id
           ORDER BY p.payment_date DESC
           LIMIT 50"""
    )

    return render_template('payments.html',
                           members=members_list,
                           payments_list=payments_list)


# ============================================
# Analytics Routes
# ============================================

@app.route('/analytics')
def analytics():
    """Analytics landing page with summary stats."""
    stats = {
        'members': 0,
        'trainers': 0,
        'checkins': 0,
        'revenue': '0.00'
    }

    row = query_db("SELECT COUNT(*) AS cnt FROM members", fetchone=True)
    if row:
        stats['members'] = row['cnt']

    row = query_db("SELECT COUNT(*) AS cnt FROM trainers", fetchone=True)
    if row:
        stats['trainers'] = row['cnt']

    row = query_db("SELECT COUNT(*) AS cnt FROM attendance", fetchone=True)
    if row:
        stats['checkins'] = row['cnt']

    row = query_db("SELECT COALESCE(SUM(amount), 0) AS total FROM payments", fetchone=True)
    if row:
        stats['revenue'] = f"{row['total']:,.2f}"

    return render_template('analytics.html', section=None, stats=stats)


@app.route('/analytics/attendance')
def analytics_attendance():
    """Most consistent members by attendance count."""
    data = query_db(
        """SELECT m.first_name, m.last_name, m.membership_type,
                  COUNT(a.attendance_id) AS total_checkins,
                  MAX(a.check_in_date) AS last_checkin
           FROM members m
           JOIN attendance a ON m.member_id = a.member_id
           GROUP BY m.member_id, m.first_name, m.last_name, m.membership_type
           ORDER BY total_checkins DESC"""
    )
    return render_template('analytics.html', section='attendance', data=data)


@app.route('/analytics/progress')
def analytics_progress():
    """Weight change per member (first vs latest log)."""
    data = query_db(
        """SELECT m.first_name, m.last_name,
                  (SELECT pl1.weight_kg FROM progress_logs pl1
                   WHERE pl1.member_id = m.member_id
                   ORDER BY pl1.log_date ASC LIMIT 1) AS first_weight,
                  (SELECT pl2.weight_kg FROM progress_logs pl2
                   WHERE pl2.member_id = m.member_id
                   ORDER BY pl2.log_date DESC LIMIT 1) AS latest_weight,
                  COUNT(pl.log_id) AS log_count
           FROM members m
           JOIN progress_logs pl ON m.member_id = pl.member_id
           GROUP BY m.member_id, m.first_name, m.last_name
           HAVING log_count > 0
           ORDER BY log_count DESC"""
    )
    return render_template('analytics.html', section='progress', data=data)


@app.route('/analytics/trainers')
def analytics_trainers():
    """Trainer workload — active and total assignments."""
    data = query_db(
        """SELECT t.first_name, t.last_name, t.specialization,
                  SUM(CASE WHEN ta.status = 'Active' THEN 1 ELSE 0 END) AS active_members,
                  COUNT(ta.assignment_id) AS total_assignments
           FROM trainers t
           LEFT JOIN trainer_assignments ta ON t.trainer_id = ta.trainer_id
           GROUP BY t.trainer_id, t.first_name, t.last_name, t.specialization
           ORDER BY active_members DESC"""
    )
    return render_template('analytics.html', section='trainers', data=data)


# ============================================
# Run the App
# ============================================

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)
