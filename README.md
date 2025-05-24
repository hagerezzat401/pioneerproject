# 👻 Pioneer Project

Hello there!  
**Pioneer** is a simple Bash script project designed to help you organize your day in the way that suits you best.

## 📌 Project Idea

Pioneer helps you plan your day interactively by:

1. Asking you to input the activities you want to include in your day.
2. Requesting the duration (in minutes) for each activity.
3. Asking for the priority of each activity (to sort them by importance).
4. Giving you the option to add breaks between tasks.
5. Letting you choose the starting time of your day.
6. Then it generates a well-organized schedule based on the information you provided, and:
   - Displays the schedule on the terminal.
   - Saves it to a file called `schedule.txt`.
   - Sends automatic **notifications** using `cron` at the start of each activity or break!

## 💡 Features

- Fully interactive experience with the user.
- Error messages for invalid inputs (e.g., entering letters instead of numbers).
- Activities sorted by priority.
- Schedule is both saved and displayed.
- Automatic reminders using `cron`.
- Exit At any step, if you type: exit
The program will safely stop and exit immediately.
This gives you full control to leave whenever you want — no pressure!

## 🛠 Requirements

Before running Pioneer, make sure you have:

- A Linux-based system or compatible terminal.
- `bash` installed.
- `cron` running on your system.

## 🛠️ Installation & Usage

### 1. Clone the Repository
```bash
git clone https://github.com/hagerezzat401/pioneerproject.git
cd pioneerproject

2. Make the Script Executable
chmod +x pioneerproject.sh

3. Run the Script
./pioneerproject.sh

