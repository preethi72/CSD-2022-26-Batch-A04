# main.py
import os
import time
import speech_recognition as sr
import pyttsx3
import datetime
import platform
import string
import webbrowser
import requests
import geocoder
import json
from typing import Optional, List, Dict, Any
import difflib
import urllib.parse
import numpy as np
import pyaudio
import io
import base64
from pydub import AudioSegment
import google.generativeai as genai
from deep_translator import GoogleTranslator
import pyjokes

import openmeteo_requests
import pandas as pd
import requests_cache
from retry_requests import retry

from fastapi import FastAPI, UploadFile, File, Form, HTTPException, BackgroundTasks, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse, StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

# Set up the Gemini API
genai.configure(api_key="AIzaSyCxCJoOU1A5JPDAwtmpt5nr-Q97jTqLNzg")
model = genai.GenerativeModel('gemini-1.5-flash')

# Initialize text-to-speech engine
engine = pyttsx3.init()

# Create FastAPI application
app = FastAPI(
    title="Spark Voice Assistant API",
    description="REST API for Spark Voice Assistant",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve static files (for web interface if added later)
try:
    app.mount("/static", StaticFiles(directory="static"), name="static")
except:
    print("No static folder found. Static file serving disabled.")

# Pydantic models for request/response data
class Command(BaseModel):
    text: str

class AssistantConfig(BaseModel):
    name: str

class LanguageRequest(BaseModel):
    text: str

class SearchRequest(BaseModel):
    search_terms: str

class WeatherRequest(BaseModel):
    location: Optional[str] = None

class YoutubeRequest(BaseModel):
    song_name: str

class LanguageResponse(BaseModel):
    detected_language: str

class AssistantResponse(BaseModel):
    text: str
    audio_base64: Optional[str] = None

class SearchResult(BaseModel):
    name: str
    path: str
    type: str
    
class AudioData(BaseModel):
    audio_base64: str

class SparkAssistant:
    def __init__(self, name="Spark"):
        self.name = name
        self.recognizer = sr.Recognizer()
        self.search_locations = self.get_search_locations()
        self.file_cache = {}  
        self.cache_timeout = 300  
        self.last_cache_time = 0
        self.language = "en"
        
        # Setup weather API client
        cache_session = requests_cache.CachedSession('.cache', expire_after=3600)
        retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
        self.openmeteo = openmeteo_requests.Client(session=retry_session)
        
        # Initialize translator
        self.translator = GoogleTranslator(source='auto', target='ta')
        
        print(f"Voice Assistant '{self.name}' initialized.")
    
    def set_name(self, new_name):
        """Update assistant name"""
        self.name = new_name
        print(f"Assistant name updated to: {self.name}")
        return {"status": "success", "name": self.name}
    
    def detect_language(self, text):
        """Detect if input is Tamil or English"""
        try:
            # Use deep_translator for language detection
            detector = GoogleTranslator(source='auto', target='en')
            detected = detector.detect(text)
            if detected == 'ta':
                return 'ta'
            else:
                return 'en'
        except:
            return 'en'
    
    def translate_to_tamil(self, text):
        """Translate text to Tamil"""
        try:
            translated = self.translator.translate(text)
            return translated
        except:
            return text
    
    def text_to_speech(self, text):
        """Convert text to speech and return as base64"""
        if self.language == 'ta':
            text = self.translate_to_tamil(text)
            voices = engine.getProperty('voices')
            for voice in voices:
                if 'tamil' in voice.name.lower():
                    engine.setProperty('voice', voice.id)
                    break
        else:
            voices = engine.getProperty('voices')
            for voice in voices:
                if 'english' in voice.name.lower():
                    engine.setProperty('voice', voice.id)
                    break
        
        # Save speech to a temporary file
        temp_file = "temp_speech.mp3"
        engine.save_to_file(text, temp_file)
        engine.runAndWait()
        
        # Read the file and convert to base64
        with open(temp_file, "rb") as audio_file:
            audio_data = audio_file.read()
            audio_base64 = base64.b64encode(audio_data).decode('utf-8')
        
        # Clean up the temporary file
        if os.path.exists(temp_file):
            os.remove(temp_file)
            
        return audio_base64
    
    def speech_to_text(self, audio_data):
        """Convert speech to text"""
        try:
            # Convert base64 to audio file
            audio_bytes = base64.b64decode(audio_data)
            
            # Save to a temporary file
            temp_file = "temp_audio.wav"
            with open(temp_file, "wb") as file:
                file.write(audio_bytes)
            
            # Use speech recognition
            with sr.AudioFile(temp_file) as source:
                audio = self.recognizer.record(source)
                text = self.recognizer.recognize_google(audio)
            
            # Clean up
            if os.path.exists(temp_file):
                os.remove(temp_file)
                
            # Detect language
            self.language = self.detect_language(text)
                
            return {"text": text, "language": self.language}
        except sr.UnknownValueError:
            return {"text": "", "error": "Could not understand audio"}
        except sr.RequestError:
            return {"text": "", "error": "Speech service unavailable"}
        except Exception as e:
            return {"text": "", "error": str(e)}
    
    def get_search_locations(self):
        """Get common search locations based on OS"""
        locations = []
        system = platform.system()
        
        if system == 'Windows':
            try:
                from ctypes import windll
                drives = []
                bitmask = windll.kernel32.GetLogicalDrives()
                for letter in string.ascii_uppercase:
                    if bitmask & 1:
                        drives.append(f"{letter}:/")
                    bitmask >>= 1
            except:
                drives = ["C:/"]
            
            user_path = os.path.expanduser("~")
            locations.extend([
                os.path.join(user_path, "Desktop"),
                os.path.join(user_path, "Documents"),
                os.path.join(user_path, "Downloads"),
                os.path.join(user_path, "Pictures"),
                os.path.join(user_path, "Videos"),
                os.path.join(user_path, "Music"),
            ])
            locations.extend(drives)
        else:
            home = os.path.expanduser("~")
            locations.extend([
                os.path.join(home, "Desktop"),
                os.path.join(home, "Documents"),
                os.path.join(home, "Downloads"),
                os.path.join(home, "Pictures"),
                os.path.join(home, "Videos"),
                os.path.join(home, "Music"),
                home,
                "/"
            ])
        
        return [loc for loc in locations if os.path.exists(loc)]
    
    def should_skip_directory(self, directory):
        """Determine if a directory should be skipped during search"""
        skip_patterns = [
            'Windows', 'Program Files', 'Program Files (x86)', 'ProgramData',
            'System Volume Information', '$Recycle.Bin', 'AppData', 'node_modules',
            '.git', '.svn', 'venv', '__pycache__', '.idea', '.vscode'
        ]
        
        dir_name = os.path.basename(directory)
        return any(pattern.lower() in dir_name.lower() for pattern in skip_patterns)
    
    def build_file_cache(self):
        """Build a cache of files and folders for faster searching"""
        self.file_cache = {}
        total_items = 0
        
        for location in self.search_locations:
            if not os.path.exists(location):
                continue
                
            try:
                for root, dirs, files in os.walk(location):
                    if self.should_skip_directory(root):
                        dirs[:] = []
                        continue
                    
                    for dir_name in dirs:
                        if not self.should_skip_directory(dir_name):
                            full_path = os.path.join(root, dir_name)
                            self.file_cache[dir_name.lower()] = (dir_name, full_path, 'folder')
                            total_items += 1
                    
                    for file_name in files:
                        full_path = os.path.join(root, file_name)
                        self.file_cache[file_name.lower()] = (file_name, full_path, 'file')
                        total_items += 1
                    
                    # Update every 1000 items (just for logging)
                    if total_items % 1000 == 0:
                        print(f"Indexed {total_items} items...")
                        
            except PermissionError:
                continue
        
        self.last_cache_time = time.time()
        print(f"File cache built with {total_items} items")
        return {"status": "success", "indexed_items": total_items}
    
    def find_file(self, search_terms):
        """Search for files/folders and return the best match"""
        current_time = time.time()
        if not self.file_cache or (current_time - self.last_cache_time > self.cache_timeout):
            self.build_file_cache()
        
        if not self.file_cache:
            return {"status": "error", "message": "No files indexed"}
        
        search_terms_lower = search_terms.lower()
        
        exact_matches = []
        for key, (name, path, item_type) in self.file_cache.items():
            if search_terms_lower in key:
                exact_matches.append((name, path, item_type))
        
        if exact_matches:
            best_match = min(exact_matches, key=lambda x: len(x[0]))
            name, path, item_type = best_match
        else:
            cache_keys = list(self.file_cache.keys())
            matches = difflib.get_close_matches(search_terms_lower, cache_keys, n=3, cutoff=0.3)
            
            if not matches:
                return {"status": "error", "message": f"No files matching '{search_terms}' found"}
            
            best_match = None
            for match in matches:
                candidate = self.file_cache[match]
                if best_match is None:
                    best_match = candidate
                else:
                    if any(user_dir in candidate[1] for user_dir in ["Desktop", "Documents", "Downloads"]):
                        best_match = candidate
                        break
            
            name, path, item_type = best_match
        
        return {
            "status": "success", 
            "result": {
                "name": name,
                "path": path,
                "type": item_type
            }
        }
    
    def get_youtube_link(self, song_name):
        """Generate a YouTube search URL for a song"""
        try:
            query = urllib.parse.quote(song_name)
            url = f"https://www.youtube.com/results?search_query={query}"
            return {"status": "success", "url": url}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def get_joke(self):
        """Get a random joke"""
        try:
            joke = pyjokes.get_joke(language='en', category='neutral')
            return {"status": "success", "joke": joke}
        except:
            try:
                response = requests.get("https://v2.jokeapi.dev/joke/Any?safe-mode&type=single")
                if response.status_code == 200:
                    joke_data = response.json()
                    return {"status": "success", "joke": joke_data.get('joke', "I couldn't fetch a joke right now.")}
            except:
                return {"status": "success", "joke": "Why don't scientists trust atoms? Because they make up everything!"}
    
    def get_current_location(self):
        """Get current location coordinates"""
        try:
            g = geocoder.ip('me')
            return g.latlng
        except:
            return [40.7128, -74.0060]  # Default to NYC coordinates
    
    def get_weather(self, location=None):
        """Get weather information"""
        try:
            if location:
                # Try multiple geocoding services for better results
                try:
                    # Try OpenStreetMap first
                    g = geocoder.osm(location)
                    if g.ok:
                        lat, lon = g.latlng
                    else:
                        # Try using ArcGIS as a backup
                        g = geocoder.arcgis(location)
                        if g.ok:
                            lat, lon = g.latlng
                        else:
                            # Try Bing as another backup
                            g = geocoder.bing(location, key='')  # No key - will use limited free tier
                            if g.ok:
                                lat, lon = g.latlng
                            else:
                                # Add manual coordinates for common locations
                                location_lower = location.lower()
                                if "jammu" in location_lower:
                                    lat, lon = 32.7266, 74.8570  # Jammu coordinates
                                    print(f"Using default coordinates for Jammu: {lat}, {lon}")
                                elif "gandhi nagar" in location_lower and "jammu" in location_lower:
                                    # Gandhi Nagar, Jammu approximate coordinates
                                    lat, lon = 32.7185, 74.8580
                                    print(f"Using default coordinates for Gandhi Nagar, Jammu: {lat}, {lon}")
                                elif "delhi" in location_lower:
                                    lat, lon = 28.6139, 77.2090
                                    print(f"Using default coordinates for Delhi: {lat}, {lon}")
                                elif "mumbai" in location_lower:
                                    lat, lon = 19.0760, 72.8777
                                    print(f"Using default coordinates for Mumbai: {lat}, {lon}")
                                elif "bangalore" in location_lower or "bengaluru" in location_lower:
                                    lat, lon = 12.9716, 77.5946
                                    print(f"Using default coordinates for Bangalore: {lat}, {lon}")
                                elif "chennai" in location_lower:
                                    lat, lon = 13.0827, 80.2707
                                    print(f"Using default coordinates for Chennai: {lat}, {lon}")
                                elif "hyderabad" in location_lower:
                                    lat, lon = 17.3850, 78.4867
                                    print(f"Using default coordinates for Hyderabad: {lat}, {lon}")
                                elif "kolkata" in location_lower:
                                    lat, lon = 22.5726, 88.3639
                                    print(f"Using default coordinates for Kolkata: {lat}, {lon}")
                                else:
                                    return {"status": "error", "message": f"Couldn't find location: {location}. Try specifying a major city."}
                except Exception as loc_error:
                    print(f"Geocoding error: {str(loc_error)}")
                    # Use defaults for common Indian cities
                    location_lower = location.lower()
                    if "jammu" in location_lower:
                        lat, lon = 32.7266, 74.8570  # Jammu coordinates
                        print(f"Using default coordinates for Jammu: {lat}, {lon}")
                    elif "gandhi nagar" in location_lower and "jammu" in location_lower:
                        # Gandhi Nagar, Jammu approximate coordinates
                        lat, lon = 32.7185, 74.8580
                        print(f"Using default coordinates for Gandhi Nagar, Jammu: {lat}, {lon}")
                    elif "delhi" in location_lower:
                        lat, lon = 28.6139, 77.2090
                        print(f"Using default coordinates for Delhi: {lat}, {lon}")
                    elif "mumbai" in location_lower:
                        lat, lon = 19.0760, 72.8777
                        print(f"Using default coordinates for Mumbai: {lat}, {lon}")
                    elif "bangalore" in location_lower or "bengaluru" in location_lower:
                        lat, lon = 12.9716, 77.5946
                        print(f"Using default coordinates for Bangalore: {lat}, {lon}")
                    elif "chennai" in location_lower:
                        lat, lon = 13.0827, 80.2707
                        print(f"Using default coordinates for Chennai: {lat}, {lon}")
                    elif "hyderabad" in location_lower:
                        lat, lon = 17.3850, 78.4867
                        print(f"Using default coordinates for Hyderabad: {lat}, {lon}")
                    elif "kolkata" in location_lower:
                        lat, lon = 22.5726, 88.3639
                        print(f"Using default coordinates for Kolkata: {lat}, {lon}")
                    else:
                        return {"status": "error", "message": f"Location service error for: {location}. Try specifying a major city."}
            else:
                lat, lon = self.get_current_location()
            
            # Log the coordinates we're using
            print(f"Getting weather for coordinates: {lat}, {lon}")
            
            url = "https://api.open-meteo.com/v1/forecast"
            params = {
                "latitude": lat,
                "longitude": lon,
                "current": ["temperature_2m", "relative_humidity_2m", "weather_code", "wind_speed_10m"],
                "timezone": "auto"
            }
            
            response = self.openmeteo.weather_api(url, params=params)[0]
            
            current = response.Current()
            temp = current.Variables(0).Value()
            humidity = current.Variables(1).Value()
            wind_speed = current.Variables(3).Value()
            
            # Get weather code and interpret it
            weather_code = current.Variables(2).Value()
            weather_description = self.interpret_weather_code(weather_code)
            
            # Try to get a nice location name, default to the provided one
            location_name = location if location else "current location"
            
            return {
                "status": "success",
                "weather": {
                    "location": location_name,
                    "temperature": f"{temp:.1f}°C",
                    "humidity": f"{humidity:.0f}%",
                    "wind_speed": f"{wind_speed:.1f} km/h",
                    "description": weather_description,
                    "coordinates": {"lat": lat, "lon": lon}
                }
            }
        except Exception as e:
            import traceback
            print(f"Weather API error: {e}")
            print(traceback.format_exc())
            return {"status": "error", "message": str(e)}
    
    def interpret_weather_code(self, code):
        """Convert WMO weather code to human-readable description"""
        # WMO Weather interpretation codes (WW)
        weather_codes = {
            0: "Clear sky",
            1: "Mainly clear",
            2: "Partly cloudy",
            3: "Overcast",
            45: "Fog",
            48: "Depositing rime fog",
            51: "Light drizzle",
            53: "Moderate drizzle",
            55: "Dense drizzle",
            56: "Light freezing drizzle",
            57: "Dense freezing drizzle",
            61: "Slight rain",
            63: "Moderate rain",
            65: "Heavy rain",
            66: "Light freezing rain",
            67: "Heavy freezing rain",
            71: "Slight snow fall",
            73: "Moderate snow fall",
            75: "Heavy snow fall",
            77: "Snow grains",
            80: "Slight rain showers",
            81: "Moderate rain showers",
            82: "Violent rain showers",
            85: "Slight snow showers",
            86: "Heavy snow showers",
            95: "Thunderstorm",
            96: "Thunderstorm with slight hail",
            99: "Thunderstorm with heavy hail"
        }
        
        return weather_codes.get(code, "Unknown weather condition")
    
    def get_current_time(self):
        """Get current time information"""
        now = datetime.datetime.now()
        time_string = now.strftime("%I:%M %p")
        day_string = now.strftime("%A")
        date_string = now.strftime("%B %d, %Y")
        
        return {
            "status": "success",
            "time": {
                "time": time_string,
                "day": day_string,
                "date": date_string,
                "full": f"Today is {day_string}, {date_string}. The current time is {time_string}."
            }
        }
    
    def ask_gemini(self, query):
        """Ask Gemini AI for information"""
        try:
            context_prompt = (
                f"You are {self.name}, a voice assistant. The user has asked the following: '{query}'. "
                "Provide a concise, helpful response suitable for voice output. Keep your response "
                "under 4 sentences unless absolutely necessary for complex topics."
            )
            
            response = model.generate_content(context_prompt)
            return {"status": "success", "response": response.text}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def extract_command_type(self, command):
        """Determine the type of command"""
        command_type = "general"
        
        if any(word in command for word in ["open", "find", "search", "file", "folder"]):
            command_type = "file_search"
        elif any(word in command for word in ["play", "song", "music", "youtube"]):
            command_type = "youtube"
        elif any(word in command for word in ["weather", "temperature", "forecast"]):
            command_type = "weather"
        elif "time" in command or "date" in command or "day" in command:
            command_type = "time"
        elif "joke" in command:
            command_type = "joke"
            
        return command_type
    
    def extract_query_content(self, command, command_type):
        """Extract content based on command type"""
        if command_type == "file_search":
            search_terms = command
            for word in ["open", "find", "search", "show", "file", "folder", "the", "for"]:
                search_terms = search_terms.replace(word, "")
            return search_terms.strip()
            
        elif command_type == "youtube":
            song_terms = command
            for word in ["play", "song", "music", "youtube", "on", "the"]:
                song_terms = song_terms.replace(word, "")
            return song_terms.strip()
            
        elif command_type == "weather":
            if "in" in command:
                location = command.split("in")[-1].strip()
                for word in ["weather", "temperature", "forecast", "the"]:
                    location = location.replace(word, "")
                return location.strip()
            return None
        
        return command
    
    def process_command(self, command):
        """Process commands to appropriate endpoints"""
        if not command:
            return {"status": "error", "message": "Empty command"}
        
        command = command.lower()
        
        if self.name.lower() in command:
            # Extract the actual command without the assistant name
            command = command.replace(self.name.lower(), "").strip()
        
        if not command:
            return {"status": "success", "message": "Yes, I'm listening. What can I do for you?"}
        
        command_type = self.extract_command_type(command)
        query_content = self.extract_query_content(command, command_type)
        
        if command_type == "file_search":
            result = self.find_file(query_content)
            if result["status"] == "success":
                return {
                    "status": "success", 
                    "type": "file_search",
                    "message": f"I found {result['result']['name']}, which is a {result['result']['type']}.",
                    "result": result["result"]
                }
            else:
                return result
            
        elif command_type == "youtube":
            result = self.get_youtube_link(query_content)
            if result["status"] == "success":
                return {
                    "status": "success",
                    "type": "youtube",
                    "message": f"Here's a link to play {query_content} on YouTube",
                    "url": result["url"]
                }
            else:
                return result
            
        elif command_type == "weather":
            result = self.get_weather(query_content)
            if result["status"] == "success":
                weather = result["weather"]
                message = f"The weather in {weather['location']}: Temperature is {weather['temperature']}, humidity is {weather['humidity']}, and wind speed is {weather['wind_speed']}."
                return {
                    "status": "success",
                    "type": "weather",
                    "message": message,
                    "weather": weather
                }
            else:
                return result
            
        elif command_type == "time":
            result = self.get_current_time()
            if result["status"] == "success":
                return {
                    "status": "success",
                    "type": "time",
                    "message": result["time"]["full"],
                    "time": result["time"]
                }
            else:
                return result
        
        elif command_type == "joke":
            result = self.get_joke()
            if result["status"] == "success":
                return {
                    "status": "success",
                    "type": "joke",
                    "message": result["joke"]
                }
            else:
                return result
        
        else:
            result = self.ask_gemini(command)
            if result["status"] == "success":
                return {
                    "status": "success",
                    "type": "general",
                    "message": result["response"]
                }
            else:
                return result

# Initialize the assistant
assistant = SparkAssistant()

# Background task to build file cache when starting up
@app.on_event("startup")
async def startup_event():
    # Build file cache in background
    background_tasks = BackgroundTasks()
    background_tasks.add_task(assistant.build_file_cache)

# Define API endpoints
@app.get("/")
async def root():
    return {"message": f"Spark Voice Assistant API - {assistant.name}"}

@app.post("/assistant/name", response_model=dict)
async def update_name(config: AssistantConfig):
    return assistant.set_name(config.name)

@app.post("/assistant/detect-language", response_model=dict)
async def detect_language(request: LanguageRequest):
    lang = assistant.detect_language(request.text)
    return {"detected_language": lang}

@app.post("/assistant/text-to-speech", response_model=dict)
async def text_to_speech(request: Command):
    audio_base64 = assistant.text_to_speech(request.text)
    return {"text": request.text, "audio_base64": audio_base64}

@app.post("/assistant/speech-to-text", response_model=dict)
async def speech_to_text(request: AudioData):
    return assistant.speech_to_text(request.audio_base64)

@app.post("/assistant/command", response_model=dict)
async def process_command(command: Command):
    result = assistant.process_command(command.text)
    
    # Add audio if requested
    if "message" in result and result.get("status") == "success":
        audio_base64 = assistant.text_to_speech(result["message"])
        result["audio_base64"] = audio_base64
        
    return result

@app.post("/assistant/file-search", response_model=dict)
async def search_files(request: SearchRequest):
    return assistant.find_file(request.search_terms)

@app.post("/assistant/weather", response_model=dict)
async def get_weather(request: WeatherRequest):
    return assistant.get_weather(request.location)

@app.get("/assistant/time", response_model=dict)
async def get_time():
    return assistant.get_current_time()

@app.get("/assistant/joke", response_model=dict)
async def get_joke():
    return assistant.get_joke()

@app.post("/assistant/youtube", response_model=dict)
async def get_youtube_link(request: YoutubeRequest):
    return assistant.get_youtube_link(request.song_name)

@app.post("/assistant/ask", response_model=dict)
async def ask_gemini(request: Command):
    return assistant.ask_gemini(request.text)

@app.get("/assistant/cache-status", response_model=dict)
async def get_cache_status():
    return {
        "cached_items": len(assistant.file_cache),
        "last_update": assistant.last_cache_time,
        "search_locations": assistant.search_locations
    }

@app.post("/assistant/rebuild-cache", response_model=dict)
async def rebuild_cache(background_tasks: BackgroundTasks):
    background_tasks.add_task(assistant.build_file_cache)
    return {"status": "success", "message": "Cache rebuild started in background"}

# WebSocket for real-time communication
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_json()
            
            if "command" in data:
                result = assistant.process_command(data["command"])
                
                # Add audio if it's a text response
                if "message" in result and result.get("status") == "success":
                    audio_base64 = assistant.text_to_speech(result["message"])
                    result["audio_base64"] = audio_base64
                
                await websocket.send_json(result)
            
            elif "audio_base64" in data:
                # Process speech to text
                result = assistant.speech_to_text(data["audio_base64"])
                
                if result.get("text"):
                    # Process the recognized command
                    command_result = assistant.process_command(result["text"])
                    
                    # Add audio response
                    if "message" in command_result and command_result.get("status") == "success":
                        audio_base64 = assistant.text_to_speech(command_result["message"])
                        command_result["audio_base64"] = audio_base64
                    
                    await websocket.send_json({
                        "recognized_text": result["text"],
                        "command_result": command_result
                    })
                else:
                    await websocket.send_json({"error": result.get("error", "Could not process audio")})
            
            else:
                await websocket.send_json({"error": "Invalid message format"})
                
    except WebSocketDisconnect:
        print("Client disconnected")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)