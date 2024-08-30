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

# Step 1: Clone the whisper.cpp repository
echo "Cloning whisper.cpp repository..."
git clone https://github.com/ggerganov/whisper.cpp.git ~/whisper.cpp

# Step 2: Navigate to the whisper.cpp directory
cd ~/whisper.cpp || { echo "Failed to navigate to the whisper.cpp directory"; exit 1; }

# Step 3: Install Homebrew if not already installed
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Running additional Homebrew commands..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed"
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
if is_apple_silicon; then
    echo "Building whisper.cpp with Core ML support..."
    make clean
    WHISPER_COREML=1 make -j
else
    echo "Building whisper.cpp..."
    make
fi

# Step 8: Install ffmpeg for file conversion
if ! command_exists ffmpeg; then
    echo "Installing ffmpeg..."
    brew install ffmpeg
else
    echo "ffmpeg is already installed"
fi

echo "Installation complete. You can now use whisper.cpp to transcribe your audio files."
