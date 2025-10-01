# Qbit - AI Powered Enterprise App

A full-stack AI-powered application that bridges the gaps between employees and the organization. Built with Flutter frontend and Python backend using **Ollama Llama 3.1** for intelligent document-based conversations.


**Components:**
- 🎯 **Frontend**: Flutter mobile/web app
- 🐍 **Backend**: Python HTTP server with intelligent keyword search
- 🗃️ **Knowledge Base**: Hardcoded company documents (no external database needed)
- 🤖 **AI**: Ollama Llama 3.1 8B model (runs locally, completely free)
- 💰 **Cost**: $0 - No API fees, no cloud services, completely self-hosted
- 📄 **Documents**: Pre-loaded company policies, benefits, IT support info

## Features

### 1. Common Feed
- **Calendar Events**: View upcoming meetings and company events
- **Announcements**: Stay updated with organizational announcements
- **AI Newsletter**: Technology-focused content tailored to your interests
- **Celebrations**: Birthday and work anniversary notifications

### 2. Ask Me (RAG-Powered AI Assistant)
- **Real-time AI Chat**: Interactive interface powered by OpenAI GPT
- **Document-Based Answers**: Retrieves context from company documents using vector search
- **Smart Responses**: Provides accurate answers with source citations
- **Knowledge Areas**: 
  - 📋 Leave policies and procedures
  - 🏥 Health insurance and benefits information  
  - 💻 IT support and technical requests
  - 📖 Company policies and handbook
  - 💰 Payroll and salary information
  - 🏠 Remote work policies
- **Auto-ticket Creation**: Can escalate complex queries to appropriate teams
- **Source References**: Shows which documents informed each answer

### 3. Personal Section
- **Profile Management**: View your profile information
- **Interests Selection**: Choose your professional interests
- **Career Goals**: Track your professional development goals with progress indicators
- **AI Recommendations**: Get personalized course and training suggestions
- **Health & Wellness**: Annual checkup reminders and health tips

## Getting Started

### Prerequisites
**Frontend (Flutter):**
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

**Backend (Python + Ollama):**
- Python 3.8+
- Ollama installed (https://ollama.ai) with Llama 3.1 model
- No API keys needed! 🎉

### Installation

#### 🚀 **Super Simple Setup**

1. **Install Ollama and Download Model**:
   ```bash
   # Install Ollama from https://ollama.ai
   ollama pull llama3.1:8b  # Download the 8B model (~4.7GB)
   ```

2. **Set up Python Backend**:
   ```bash
   cd rag-backend
   pip install requests  # Only dependency needed!
   python3 ollama_rag.py  # Start backend on http://localhost:8080
   ```

3. **Run Flutter App**:
   ```bash
   flutter pub get
   flutter run -d chrome  # For web, or use -d <device> for mobile
   ```

#### 💡 **Highlights** 
- No complex setup scripts
- No API keys to manage  
- No vector databases to configure
- Everything runs locally and free

### Project Structure
```
Qbit/
├── 📱 Flutter Frontend
│   ├── lib/
│   │   ├── main.dart                 # App entry point
│   │   ├── screens/
│   │   │   ├── home_screen.dart      # Main screen with bottom navigation
│   │   │   ├── common_feed_screen.dart   # Common feed with announcements
│   │   │   ├── ask_me_screen.dart    # AI chat interface (connects to RAG)
│   │   │   └── personal_screen.dart  # Personal goals and interests
│   │   └── services/
│   │       └── api_service.dart      # HTTP client for backend communication
│   └── pubspec.yaml                  # Flutter dependencies
│
├── 🐍 Python Backend (Ollama-Powered)
│   ├── rag-backend/
│   │   ├── ollama_rag.py             # Simple HTTP server with Ollama integration
│   │   └── requirements.txt          # Minimal dependencies (just requests)
│
├── 📸 screenshots/                   # App screenshots
└── 📋 Documentation
    ├── README.md                     # This file
    ├── PYTHON_RAG_SETUP.md          # Detailed backend setup
    └── idea.md                       # Original project concept
```

## Current Implementation Status

✅ **Completed**:
- 📱 **Flutter Frontend**: Modern Material Design 3 UI with bottom navigation
- 🤖 **Ollama Integration**: Python HTTP server with Llama 3.1 8B model
- 🗃️ **Smart Knowledge Base**: Hardcoded company documents with intelligent search
- 🔍 **Keyword Search**: Enhanced search with synonym expansion and relevance scoring  
- 💬 **Real AI Chat**: Ask Me interface with Ollama-powered responses
- 🎯 **API Integration**: Simple HTTP REST API between Flutter and Python
- 📚 **Pre-loaded Content**: Company policies, benefits, IT support, leave policies
- 💰 **Zero Cost**: Completely free with no external API dependencies
- 📖 **Common Feed**: Announcements, events, newsletters, celebrations
- 👤 **Personal Section**: Interests, goals, and AI recommendations

🔄 **Next Steps** (for future development):
- 👤 User authentication and profiles
- 🔔 Real-time notifications and push alerts
- 📅 Calendar integration (Google/Outlook)
- 📊 Health metrics tracking and wellness suggestions
- 🎯 Advanced goal management with progress tracking
- 🎫 Automated ticket creation for IT/HR requests
- 📈 Analytics dashboard for usage insights
- 🔒 Enhanced security and role-based access

## Technologies Used

### Frontend Stack
- **Framework**: Flutter (Dart)
- **UI**: Material Design 3
- **Icons**: Material Design Icons Flutter  
- **State Management**: StatefulWidget
- **HTTP Client**: Dart HTTP package for API communication

### Backend Stack  
- **Server**: Python HTTP server (built-in `http.server`)
- **AI Integration**: Ollama Llama 3.1 8B (local, no API costs)
- **Knowledge Base**: Hardcoded dictionary with company documents  
- **Search**: Smart keyword matching with synonym expansion
- **Document Storage**: Pre-loaded company policies, benefits, IT info
- **API**: Simple REST endpoints with CORS support
- **Dependencies**: Only `requests` library needed (minimal setup)

### Architecture
- **Pattern**: Simple RAG with keyword search (no vector embeddings needed)
- **Communication**: HTTP REST API between Flutter and Python
- **Deployment**: Completely local (no cloud dependencies)
- **Cost**: $0 - No external APIs, databases, or services

## Testing the App

### 🚀 Complete Testing Flow

1. **Start Ollama**: `ollama serve` (in separate terminal)
2. **Start Backend**: `cd rag-backend && python3 ollama_rag.py` 
3. **Run Flutter App**: `flutter run -d chrome`
4. **Test Features**:

#### Common Feed Tab
- Scroll through announcements, events, newsletters, celebrations
- All content displays with modern Material Design 3 styling

#### Ask Me Tab (Ollama-Powered AI)
Try these sample questions:
- "What is my total annual leave number?"  
- "Can I work from home 5 days a week?"
- "How much does the company pay for health insurance?"
- "What's the process for getting IT support?"
- "Do I have any active tickets?"

**Expected Results**: Real Llama 3.1 AI responses with company document sources

#### Personal Section Tab  
- Select your professional interests
- View career goals with progress tracking
- Browse AI-recommended courses and training

## API Endpoints

The Python HTTP server provides these simple endpoints:

### Core Endpoints
- **GET** `/health` - Backend health check and Ollama status
- **POST** `/api/chat` - Send messages to Ollama AI assistant  
- **GET** `/api/knowledge` - List hardcoded knowledge base info
- **GET** `/` - Simple API documentation page

### Sample API Usage
```bash
# Test backend health  
curl http://localhost:8080/health

# Send chat message to Ollama
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Do I have any active tickets?"}'

# Check knowledge base
curl http://localhost:8080/api/knowledge
```

### API Response Format
```json
{
  "response": "Based on our records, you have one active IT ticket: Ticket #IT-2024-1247 for Outlook Email Sync Issues. It's currently in progress with expected resolution on Sept 18, 2024.",
  "sources": ["IT_Ticket_System"],
  "conversation_id": "uuid-here",
  "ai_model": "Llama 3.1 8B (Ollama)"
}
```

## Future Enhancements

### 🎯 Immediate Roadmap
- 📅 **Calendar Integration**: Google/Outlook sync for events
- 👤 **User Authentication**: Login system with role-based access  
- 🔔 **Push Notifications**: Real-time alerts for announcements
- 📱 **Mobile Optimization**: Native iOS/Android builds

### 🚀 Advanced Features  
- 🎫 **Smart Ticketing**: Auto-route requests to appropriate teams
- 📊 **Analytics Dashboard**: Usage insights and conversation analytics
- 🌐 **Multi-tenant Support**: Multiple organizations on one platform
- 🔒 **Enterprise Security**: SSO, audit logs, data encryption
- 📡 **Offline Support**: Cache critical information locally
- 🤖 **Multi-Agent AI**: Specialized agents for different departments
- 📈 **Custom Training**: Upload company-specific documents easily

### 🏢 Enterprise Integration
- 🔄 **HR Systems**: Integrate with existing HRMS platforms
- 💻 **IT Service Management**: ServiceNow, Jira Service Desk integration  
- 📋 **Document Management**: SharePoint, Confluence connectors
- 📞 **Communication Tools**: Slack, Teams bot integration

## Screenshots

Here are some screenshots showcasing the app's interface and features:

| Screenshot 1 | Screenshot 2 |
|:---:|:---:|
| ![Screenshot 1](screenshots/1.png) | ![Screenshot 2](screenshots/2.png) |

| Screenshot 3 | Screenshot 4 |
|:---:|:---:|
| ![Screenshot 3](screenshots/3.png) | ![Screenshot 4](screenshots/4.png) |

## Contributing

Qbit is now a complete full-stack AI application with both frontend and backend components fully functional. Contributions are welcome in several areas:

### 🎯 **Frontend Development (Flutter)**
- UI/UX improvements and animations
- Mobile-specific optimizations
- New feature screens and components
- State management improvements (Provider/Bloc)

### 🐍 **Backend Development (Python)**  
- RAG system enhancements and performance optimization
- New document processing formats (Excel, PowerPoint, etc.)
- Advanced AI features (multi-agent systems, memory)
- API endpoint expansions and optimizations

### 📚 **Documentation & Testing**
- API documentation improvements
- Unit tests for both frontend and backend
- Integration tests for RAG system
- Performance benchmarking

### 🚀 **DevOps & Deployment**
- Docker containerization for easy deployment  
- CI/CD pipeline setup
- Production deployment guides
- Monitoring and logging improvements

The application demonstrates a production-ready RAG architecture and can serve as a foundation for enterprise AI applications.

---

## 🎉 **Why This Architecture Rocks**

✅ **Completely Free**: $0 costs - no API fees, no cloud services  
✅ **Privacy First**: Everything runs locally, company data never leaves your network  
✅ **Simple Setup**: Just 3 commands to get running (install Ollama, start backend, run Flutter)  
✅ **Real AI**: Powered by Llama 3.1 8B - same quality as expensive cloud APIs  
✅ **No Complexity**: No vector databases, no embeddings, no complex dependencies  
✅ **Production Ready**: Simple HTTP server that can handle real workloads  

**🎉 Ready to use!** Your Qbit AI-powered enterprise app is now fully functional with Flutter frontend and Ollama-powered Python backend.
