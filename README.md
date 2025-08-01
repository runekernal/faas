# 🤖 Feelings-as-a-Service (FaaS)

**FaaS** is a light-hearted Flutter app that imagines what your everyday objects might say — if they had feelings.

📷 Take a photo or upload an image, and the app will:
- Use **Google ML Kit** to detect objects in the image (e.g., bottle, bag, pen)
- Identify the most probable object
- Generate a short, witty message either:
  - **Apologizing to** the object
  - Or a **complaint from** the object

All in one tap — fun, fast, and a little bit useless (on purpose — it was built for a “useless hackathon”)!

---

## 🧠 Tech Stack

| Component         | Technology Used                           |
|------------------|--------------------------------------------|
| Object Detection | [Google ML Kit](https://developers.google.com/ml-kit/vision/object-detection/flutter) |
| Text Generation  | Custom API powered by an LLM (e.g., Groq API, Ollama, etc.) |
| Frontend         | Flutter (Dart)                             |

---

## 🚀 Features

- Detects common objects in images using on-device ML (no cloud required)
- Sends detected object names to an AI API
- Receives short, humorous messages: either an apology or a complaint
- Cross-platform Flutter UI (currently Android tested)
- Optional text-to-speech support

---

## 🔧 Getting Started

### Prerequisites

- Flutter SDK (version 3.10+ recommended)
- Android Studio or VS Code with Flutter plugin
- Android device or emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/faas.git
   cd faas
