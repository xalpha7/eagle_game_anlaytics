## 🚀 Tech Stack

### Frontend
- **Framework:** Flutter (Web)
- **State Management:** GetX (`get` & `GetxController`) for global reactive state management.
- **Communication:** Native WebSocket Client for low-latency, real-time bi-directional data flow.

### Backend
- **Framework:** FastAPI (Asynchronous Python Web Framework)
- **Real-Time Engine:** WebSockets for keeping connected clients synchronized.
- **Server Gateway:** Uvicorn to keep the server alive forever
- **Data Layer:** Pandas & PyArrow for high-speed loading and manipulation of `.nakama-0` (parquet) files.

---


# 1. Backend Setup

The backend handles real-time sessions and data streaming from parquet stores. A virtual environment named `gamevenv` is already prepared.

Follow these steps to activate the environment, install dependencies, and launch the server:

### Navigate to the backend directory

### 1. Activate the pre-configured virtual environment 
>source ./gamevenv/bin/activate

or Install the required Python packages

>pip install -r requirements.txt

### 3. Start the FastAPI server
>python server.py


# 2. Frontend Setup 

### Navigate to the frontend directory (lila_black_analytics)
### Install the flutter and its dependencies (Android SDK not required)
### run `flutter doctor` to verify chrome installation
### 
### 1. Enable web development support
>flutter config --enable-web

### 2. Fetch the required packages
>flutter pub get

### 3. Run the application in chrome
>flutter run -d chrome


# DEPLOYED URL

`https://eagle-game-anlaytics-crna.onrender.com/`

```
Note: the website can take upto 50 seconds loading (due to 50 seconds inactivity policy of render for backend webservice 

```