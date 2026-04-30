#!/bin/bash

# Terminal Colors
C='\033[0;36m' # Cyan
G='\033[0;32m' # Green
Y='\033[1;33m' # Yellow
R='\033[0;31m' # Red
N='\033[0m'    # No Color

clear
echo -e "${C}"
while IFS= read -r line; do
    echo -e "$line"
    sleep 0.05
done << "EOF"
   ______               __  ___                                 
  / ____/_  ______ ___ /  |/  /___ _____  ____ _____  ___  _____
 / / __/ / / / __ `__ \/ /|_/ / __ `/ __ \/ __ `/ __ \/ _ \/ ___/
/ /_/ / /_/ / / / / / / /  / / /_/ / / / / /_/ / /_/ /  __/ /    
\____/\__, /_/ /_/ /_/_/  /_/\__,_/_/ /_/\__,_/\__, /\___/_/     
     /____/                                   /____/             
EOF
echo -e "${N}"
echo -e "${Y}==============================================================${N}"
echo -e "${G}             Automated Setup & Launch Wizard${N}"
echo -e "${Y}==============================================================${N}"
echo ""
echo "Please select how you want to run the application:"
echo ""
echo -e "${C}[1] Docker (Recommended)${N}"
echo "    - Easiest setup. No installations required."
echo ""
echo -e "${C}[2] Local Python Setup${N}"
echo "    - Requires Python and MySQL installed manually."
echo ""

read -p "Enter your choice (1 or 2): " choice

# Function to open browser cross-platform
open_browser() {
    if command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:5000
    elif command -v open &> /dev/null; then
        open http://localhost:5000
    else
        echo "Please open http://localhost:5000 in your browser."
    fi
}

if [ "$choice" = "1" ]; then
    echo ""
    echo "Starting Docker setup..."
    
    if docker info > /dev/null 2>&1; then
        DOCKER_CMD="docker compose"
    else
        echo "Docker requires sudo privileges."
        DOCKER_CMD="sudo docker compose"
    fi
    
    $DOCKER_CMD up -d --build
    
    echo "Waiting for database to initialize (this can take 15-20 seconds on first run)..."
    sleep 15
    
    echo "Opening application..."
    open_browser
    
    echo "Done! The app is running in the background."
    echo "To stop it later, run: $DOCKER_CMD down"
    exit 0
    
elif [ "$choice" = "2" ]; then
    echo ""
    echo "Starting Local Python setup..."
    
    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
        echo "Activating virtual environment and installing requirements..."
        source venv/bin/activate
        pip install -r requirements.txt
    else
        echo "Virtual environment already exists. Skipping creation and installation."
        source venv/bin/activate
    fi
    
    echo ""
    echo "==================================================="
    echo "DATABASE SETUP"
    echo "==================================================="
    read -p "Do you need to import the database schema (db.sql)? (y/n): " import_db
    
    read -s -p "Enter MySQL root password: " dbpass
    echo ""
    
    if [[ "$import_db" == "y" || "$import_db" == "Y" ]]; then
        echo "Importing db.sql..."
        mysql -u root -p"$dbpass" < db.sql
    fi
    
    echo ""
    echo "Opening application..."
    open_browser
    
    echo "Starting Flask server..."
    export DB_PASSWORD="$dbpass"
    python3 app.py
    
    exit 0
else
    echo "Invalid choice. Exiting."
    exit 1
fi
