#!/bin/bash

echo 'Welcome to...'
echo " ________  ___    ___                        "
echo "|\   __  \|\  \  /  /|                       "
echo "\ \  \|\  \ \  \/  / /                       "
echo " \ \   ____\ \    / /                        "
echo "  \ \  \___|\/  /  /                         "
echo "   \ \__\ __/  / /                           "
echo "    \|__||\___/ /                            "
echo "         \|___|/                              "
echo "                                             "
echo "                                             "
echo " ________  ________  ________  ________      "
echo "|\   ___ \|\   ___ \|\   __  \|\   ____\     "
echo "\ \  \_|\ \ \  \_|\ \ \  \|\  \ \  \___|_    "
echo " \ \  \ \\ \ \  \ \\ \ \  \\\  \ \_____  \   "
echo "  \ \  \_\\ \ \  \_\\ \ \  \\\  \|____|\  \  "
echo "   \ \_______\ \_______\ \_______\____\_\  \ "
echo "    \|_______|\|_______|\|_______|\_________\\"
echo "                                 \|_________|"
echo "python ddos"

# Ensure tmux is installed
if ! command -v tmux &>/dev/null; then
    echo "tmux not found. Installing..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update && sudo apt install -y tmux
                ;;
            fedora)
                sudo dnf install -y tmux
                ;;
            centos|rhel)
                sudo yum install -y tmux
                ;;
            arch)
                sudo pacman -Sy --noconfirm tmux
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    elif [ "$(uname)" == "Darwin" ]; then
        # macOS
        if command -v brew &>/dev/null; then
            brew install tmux
        else
            echo "Homebrew is not installed. Install Homebrew first: https://brew.sh/"
            exit 1
        fi
    else
        echo "Unsupported operating system."
        exit 1
    fi
fi

# Verify tmux installation
if ! command -v tmux &>/dev/null; then
    echo "Failed to install tmux. Please install it manually."
    exit 1
fi

SESSION="attack_session"

# Kill existing tmux session if it exists
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Existing tmux session found. Killing it..."
    tmux kill-session -t $SESSION
fi

# Start a new tmux session (detached)
tmux new-session -d -s $SESSION -n "main"

# Split into 4 panes
tmux split-window -h -t $SESSION:0
tmux split-window -v -t $SESSION:0.0
tmux split-window -v -t $SESSION:0.1

# Run `ddos.py` in three panes
tmux send-keys -t $SESSION:0.0 "python3 ddos.py" C-m
tmux send-keys -t $SESSION:0.1 "python3 ddos.py" C-m
tmux send-keys -t $SESSION:0.2 "python3 ddos.py" C-m

# Run `htop` in the fourth pane
tmux send-keys -t $SESSION:0.3 "htop" C-m

# Attach to the session
tmux attach-session -t $SESSION