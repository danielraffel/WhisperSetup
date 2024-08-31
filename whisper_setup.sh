#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if the system is running on Apple Silicon
is_apple_silicon() {
    if [[ "$(uname -m)" == "arm64" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to update Homebrew and its packages
update_homebrew() {
    echo "Updating Homebrew..."
    brew update
    echo "Upgrading Homebrew packages..."
    brew upgrade
}

# Step 1: Clone the whisper.cpp repository
echo "Cloning whisper.cpp repository..."
git clone https://github.com/ggerganov/whisper.cpp.git ~/whisper.cpp

# Step 2: Navigate to the whisper.cpp directory
cd ~/whisper.cpp || { echo "Failed to navigate to the whisper.cpp directory"; exit 1; }

# Step 3: Install or update Homebrew
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Running additional Homebrew commands..."
    if is_apple_silicon; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed"
    update_homebrew
fi

# Step 4: Download the large English model
echo "Downloading the large English model..."
bash ./models/download-ggml-model.sh base.en

# Step 5: Generate the Core ML model if running on Apple Silicon
if is_apple_silicon; then
    echo "Apple Silicon detected. Generating Core ML model..."
    bash ./models/generate-coreml-model.sh base.en
fi

# Step 6: Install necessary dependencies for Core ML if running on Apple Silicon
if is_apple_silicon; then
    echo "Apple Silicon detected. Installing dependencies for Core ML support..."
    pip install ane_transformers openai-whisper coremltools
fi

# Step 7: Build whisper.cpp
echo "Cleaning previous build..."
make clean

if is_apple_silicon; then
    echo "Building whisper.cpp with Core ML support..."
    WHISPER_COREML=1 make -j
else
    echo "Building whisper.cpp on Intel Mac..."
    WHISPER_NO_METAL=true make -j
fi

# Step 8: Install ffmpeg for file conversion
if ! command_exists ffmpeg; then
    echo "Installing ffmpeg..."
    brew install ffmpeg
else
    echo "ffmpeg is already installed"
fi

echo "Installation complete. You can now use whisper.cpp to transcribe your audio files."
