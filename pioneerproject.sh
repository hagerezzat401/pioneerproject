#!/bin/bash 

# Pioneers syndrome
echo "              --+******+--"
echo "           :**==::::::::==**-"
echo "          *#=..............=#*"
echo "         **..................**"
echo "        *#...:::::::::::::::.:#*"
echo "        *:..***...............%*"
echo "        *..*****.....Pioneer..%*"
echo "        *...***...............%*"
echo "        *:....................#*"
echo "        *:....................**"
echo "        *:....................**"
echo "        *:....................**"
echo "       -#.....................*%-"
echo "       #+...:-.....::.....-:..-%#:"
echo "      :%+::+%%*-::=%%=::-*%%+::*%:"
echo "     ;:=*+*+--=*++*--*++*=--+*+*=::"

# greating message
echo "============================================"
echo "        ✨ Welcome to Pioneer ✨"
echo "    Craft your day, One task at a time!     "
echo "============================================"

#  file to save data
schedule_file="schedule.txt"
> "$schedule_file"
# initial arrays
activities=()
durations=()
priorities=()
needs_break=()
break_durations=()

#making exit method
check_exit(){
if [[ $1 == "exit" ]];then 
echo "Goodbye! "
exit 0
fi
}

# reading activities and duration
collect_data() {
read -p "Enter an activity: " activity
check_exit "$activity"
while true; do
read -p "Enter the duration of the activity in minutes: " duration
check_exit "$duration"
# making sure the duration i correct
if [[ $duration =~ ^[0-9]+$ ]]; then
break
else echo "please enter a valid duration ; [num 0-9]."
fi
done
# adding the activity and its duration to the arrays
activities+=("$activity")
durations+=("$duration")
}

# reading more activities
while true; do
read -p "Do you want to add an activity? (yes/no) " answer
check_exit "$answer"
if [[ $answer == "yes" || $answer == "Yes" ]]; then
collect_data
elif [[ $answer == "no" || $answer == "NO" ]]; then
break
else echo "please enter (yes) if you want to add an activity ,(no) if you don't or (exit) if you want to quit."
fi
done
if [[ ${#activities[@]} -eq 0 ]]; then
echo "No activities were added! Exiting Piooner..."
exit 1
fi

# prioritize the activities
echo "Enter the priority of each activity [1 means highest priority] "
for ((i=0; i<${#activities[@]}; i++)); do
echo "Activity: ${activities[$i]} - duration: ${durations[$i]} minutes"
while true; do
read  -p " set priority: (from 1 to ${#activities[@]})" priority
check_exit "$priority"
if [[ $priority =~ ^[0-9]+$ ]] && ((priority >=1 && priority <= ${#activities[@]})); then
# make sure that the priority is just for this activity
if [[ "${priorities[@]}" =~ "$priority" ]]; then
echo "Error: the priority has already been assigned to another activity. Plz choose a differnt priority."
else
priorities+=("$priority")
break
fi
else 
echo "please enter a valid number for priority ( from 1 to ${#activities[@]})."
fi
done
done

# putting activities in order to its priority
for ((i=0; i<${#activities[@]}; i++)); do
for (( j=i+1; j<${#activities[@]}; j++)); do
if (( ${priorities[$i]} > ${priorities[$j]} )); then
# switching activities
temp_activity=${activities[$i]}
activities[$i]=${activities[$j]}
activities[$j]=$temp_activity

#switching durations
temp_duration=${durations[$i]}
durations[$i]=${durations[$j]}
durations[$j]=$temp_duration

#switching priorities
temp_priority=${priorities[$i]}
priorities[$i]=${priorities[$j]}
priorities[$j]=$temp_priority
fi
done
done

# Asking for breaks
echo "Let's add breaks [optional]"
for (( i=0; i<${#activities[@]}; i++ )); do
while true; do
read -p "Do you want a break after \"${activities[$i]}\"? (yes/no)" want_break
check_exit "$want_break"
if [[ $want_break == "yes" || $want_break == "Yes" ]]; then
needs_break+=("yes")
while true; do
read -p "Enter break duration in minutes: " break_duration
check_exit "$break_duration"
if [[ $break_duration =~ ^[0-9]+$ ]]; then
break_durations+=("$break_duration")
break
else
echo " please enter a valid break duration [numbers 0-9]."
fi
done
break
elif  [[ $want_break == "no" || $want_break == "No" ]]; then
needs_break+=("no")
break_durations+=("0")
break
else echo "please enter (yes) if you want to add a break ,(no) if you don't or (exit) if you want to quit."
fi
done
done

# method to convert HH:MM to total minutes
time_to_minutes(){
local time=$1
local hour=${time%%:*}
local minute=${time##*:}
echo $((10#$hour * 60 + 10#$minute))
}

#function to convert minutes to HH:MM
minutes_to_time(){
local total_minutes=$1
local hour=$((total_minutes / 60))
local minute=$((total_minutes % 60))
printf "%02d:%02d" $hour $minute
}

#get start of the day from the user
while true; do
read -p "Enter your day start time (HH:MM): " start_time
check_exit "$start_time"
if [[ $start_time =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$  ]]; then
break
else 
echo "please enter a valid time format like 07:30 "
fi
done
current_time=$(time_to_minutes "$start_time")

# finally the final product
echo "Your personalized schedule by Pioneer: " >> "$schedule_file"
echo "=======================================" >> "$schedule_file"
for (( i=0; i<${#activities[@]}; i++ )); do
start_formatted=$(minutes_to_time $current_time)
end_time=$((current_time + durations[$i]))
end_formatted=$(minutes_to_time $end_time)
echo "$start_formatted - $end_formatted | Activity: ${activities[$i]}" >> "$schedule_file"
current_time=$end_time
if [[ ${needs_break[$i]} == "yes" || ${needs_break[$i]} == "Yes" ]]; then
break_end=$(( current_time + break_durations[$i]))
break_start_formatted=$(minutes_to_time $current_time)
break_end_formatted=$(minutes_to_time $break_end)
echo "Break: $break_start_formatted - $break_end_formatted (${break_durations[$i]} min)" >> "$schedule_file"
current_time=$break_end
fi
echo "==============================================================" >> "$schedule_file"
done
# Setting reminders 
read -p "Do you want to set reminders for each activity? (yes/no)" set_reminders
if [[ $set_reminders == "Yes" ||  $set_reminders == "yes" ]]; then
for (( i=0; i<${#activities[@]}; i++ )); do
start_formatted=$(minutes_to_time $current_time)
hour=${start_formatted%%:*}
minute=${start_formatted##*:}
msg="Time for: ${activities[$i]}"
cron_cmd="DISPLAY=0 notify-send '$msg'"
(crontab -l 2>/dev/null; echo "$minute $hour * * * $cron_cmd") | crontab -
current_time=$((current_time + durations[$i]))
if [[ ${needs_break[$i]} == "yes" ]]; then
break_msg="Time for a break (${break_durations[$i]} mins )!"
break_start_formatted=$(minutes_to_time $current_time)
break_hour=${break_start_formatted%%:*}
break_minute=${break_start_formatted##*:}
break_cmd="DISPLAY=0 notify-send '$break_msg'"
(crontab -l 2>/dev/null; echo "$break_minute $break_hour * * * $break_cmd") | crontab -
current_time=$((current_time + break_durations[$i]))
fi
done
echo "Reminders have been scheduled!"
fi
echo "Your Schedule has been saved in $schedule_file"
cat "$schedule_file"
