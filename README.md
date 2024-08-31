# WhisperSetup

WhisperSetup is a script for setting up and compiling [whisper.cpp](https://github.com/ggerganov/whisper.cpp) on macOS, specifically streamlined for high-performance speech-to-text transcription. It is optimized for Apple Silicon but also works effectively on Intel Macs. This script automates the installation of dependencies, manages Homebrew setup, downloads the necessary models, and builds the project with Core ML support on Apple Silicon. Additionally, it ensures that `ffmpeg` is installed for file conversion, making the setup process seamless and efficient.

**Tip:** If your audio files are not in WAV format, you can easily [convert them using `ffmpeg`](#converting-mp3-to-wav-and-transcribing).

## Features

- **Automatic Setup:** Clone and navigate to the whisper.cpp repository automatically.
- **Model Download:** Download the large English model (`base.en`) for transcription.
- **Apple Silicon Optimization:** Detects Apple Silicon and sets up Core ML to leverage the Neural Engine for faster processing.
- **Dependency Management:** Installs necessary tools and libraries, including Homebrew and `ffmpeg`.
- **Cross-Platform Compatibility:** Configures the build process for both Apple Silicon and Intel-based Macs.

## Requirements

- macOS (Intel or Apple Silicon)
- Python 3.10+
- Homebrew (will be installed if not already present)
- `ffmpeg` (for audio conversion)
- `pip` for Python package installation

## Installation

1. **Clone the Repository:**

   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/danielraffel/WhisperSetup.git
   cd WhisperSetup
   ```

2. **Run the Setup Script:**

   Execute the setup script to install and configure `whisper.cpp`:

   ```bash
   ./whisper_setup.sh
   ```

   The script will:
   - Clone the `whisper.cpp` repository.
   - Install Homebrew (if not already installed).
   - Download the large English model (`base.en`).
   - Generate a Core ML model if running on Apple Silicon.
   - Install necessary dependencies for Core ML support.
   - Build the `whisper.cpp` project with or without Core ML support based on your system architecture.
   - Install `ffmpeg` for converting audio files to WAV format.

## Usage

Once installed, `whisper.cpp` can be used to transcribe any supported audio file by providing the model and the audio file as inputs:

```bash
./main -m ~/whisper.cpp/models/ggml-base.en.bin -f /path/to/your/audio.wav
```

For more detailed usage instructions and additional options, refer to the official [whisper.cpp repository](https://github.com/ggerganov/whisper.cpp).

## Transcribing Audio Files

### Preparing Audio Files for Transcription

**Note:** Ensure your audio files are in WAV format, as `whisper.cpp` currently only supports 16-bit WAV files.

### Converting MP3 to WAV and Transcribing

If your audio file is in a different format, such as MP3, you can convert it to the required 16-bit WAV format using `ffmpeg`. Here's how you can do it all in one command:

```bash
MP3_FILE="/path/to/audio/input.mp3"; WAV_FILE="/path/to/audio/output.wav"; ffmpeg -i "$MP3_FILE" -ar 16000 "$WAV_FILE" && ./main -m ~/whisper.cpp/models/ggml-base.en.bin -f "$WAV_FILE"
```

**Explanation:**

- `MP3_FILE`: Path to your input MP3 file.
- `WAV_FILE`: Path where the converted WAV file will be saved.
- `ffmpeg`: Converts the MP3 file to WAV format with the correct sample rate (16,000 Hz).
- `./main`: Runs the transcription on the converted WAV file using the specified model.

### Optional: Automatically Delete the WAV File After Transcription

If you want to automatically delete the WAV file after the transcription is complete, you can add the following command:

```bash
MP3_FILE="/path/to/audio/input.mp3"; WAV_FILE="/path/to/audio/output.wav"; ffmpeg -i "$MP3_FILE" -ar 16000 "$WAV_FILE" && ./main -m ~/whisper.cpp/models/ggml-base.en.bin -f "$WAV_FILE" && rm "$WAV_FILE"
```

- The `rm "$WAV_FILE"` command deletes the WAV file after the transcription is done.

This setup allows you to transcribe audio files quickly and efficiently, even if they are not initially in the required WAV format.

## Credits
This script was written by ChatGPT and is based on content I copy/pasted (!!) from a tutorial on installing Whisper on macOS by Egor Menyaylo, which can be found in the Medium article [here](https://medium.com/gimz/how-to-install-whisper-on-mac-openais-speech-to-text-recognition-system-1f6709db6010). I've made a few tweaks.
