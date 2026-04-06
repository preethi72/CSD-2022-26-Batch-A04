# 🤖 JARVIS – Intelligent Multilingual Voice Assistant

An AI-powered voice assistant capable of understanding and responding to user queries using speech recognition, natural language processing, and AI reasoning. The system supports both online and offline modes to ensure reliability and accessibility.

---

## 🚀 Features

- 🎙️ Speech-to-Text (Voice Input)
- 🔊 Text-to-Speech (Audio Output)
- 🌐 Multilingual Support
- 🤖 AI-Based Intelligent Responses
- 📡 Online + Offline Hybrid Processing
- 📱 User-Friendly Mobile Interface

---

## 🏗️ System Architecture

User → Mobile App (Flutter) → STT → NLP → AI Processing → TTS → Response

---

## 🛠️ Tech Stack

### Frontend
- Flutter

### Backend
- FastAPI (Python)

### AI & Processing
- Natural Language Processing (NLP)
- Speech Recognition
- AI APIs (Gemini / OpenAI)

---

## 📸 Screenshots

### 🏠 Home Screen
![Home](screenshots/home.jpg)

### 🌐 Online Mode
![Online](screenshots/online.jpg)

### 📴 Offline Mode
![Offline](screenshots/offline.jpg)

---

## ⚙️ Installation & Setup

### Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
