# Qbit - AI Powered Enterprise App

A full-stack AI-powered application that bridges the gaps between employees and the organization. Built with Flutter frontend and Python RAG (Retrieval Augmented Generation) backend for intelligent document-based conversations.

## Architecture

```
Flutter App → HTTP API → Python FastAPI → ChromaDB → OpenAI → AI Responses
     ↓           ↓           ↓            ↓         ↓         ↓
User Interface → REST → RAG Backend → Vector DB → LLM → Smart Answers + Sources
```

**Components:**
- 🎯 **Frontend**: Flutter mobile/web app
- 🐍 **Backend**: Python FastAPI with RAG architecture  
- 🗃️ **Database**: ChromaDB vector database for document embeddings
- 🤖 **AI**: OpenAI GPT integration with document context
- 📄 **Documents**: PDF/DOCX ingestion for company knowledge

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

**Backend (Python RAG):**
- Python 3.8+
- OpenAI API Key (from https://platform.openai.com/api-keys)

### Installation

#### 🚀 **Quick Start (Recommended)**

1. **Set up the RAG Backend**:
   ```bash
   cd rag-backend
   python3 setup.py  # Creates venv, installs deps, creates sample docs
   ```

2. **Add your OpenAI API Key**:
   ```bash
   nano rag-backend/.env
   # Replace: OPENAI_API_KEY=your-openai-api-key-here
   # With: OPENAI_API_KEY=sk-your-actual-key-here
   ```

3. **Start the Backend**:
   ```bash
   cd rag-backend
   python3 start.py  # Runs on http://localhost:8080
   ```

4. **Run the Flutter App**:
   ```bash
   flutter pub get
   flutter run -d chrome  # For web, or use -d <device> for mobile
   ```

#### 🔧 **Manual Setup**

**Backend Setup:**
```bash
cd rag-backend
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
python3 document_ingestion.py --create-samples
python3 main.py
```

**Frontend Setup:**
```bash
flutter pub get
flutter run
```

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
├── 🐍 Python RAG Backend
│   ├── rag-backend/
│   │   ├── main.py                   # FastAPI server with RAG logic
│   │   ├── document_ingestion.py     # PDF/DOCX processing & ChromaDB storage
│   │   ├── setup.py                  # Automated setup script
│   │   ├── start.py                  # Server startup script
│   │   ├── requirements.txt          # Python dependencies
│   │   ├── .env                      # Environment variables (OpenAI API key)
│   │   ├── chroma_db/                # Vector database storage
│   │   └── sample_documents/         # Sample company documents (PDF/DOCX)
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
- 🤖 **RAG Backend**: Python FastAPI server with OpenAI integration
- 🗃️ **Vector Database**: ChromaDB for document embeddings and retrieval
- 📄 **Document Processing**: PDF/DOCX ingestion with automated setup
- 💬 **Real AI Chat**: Ask Me interface with document-based responses
- 🎯 **API Integration**: HTTP communication between Flutter and Python backend
- 📚 **Knowledge Base**: Pre-loaded with sample company documents
- 🔍 **Vector Search**: Semantic search with source citations
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
- **Framework**: Python FastAPI
- **AI Integration**: OpenAI GPT-3.5/GPT-4 API
- **Vector Database**: ChromaDB for embeddings storage
- **Embeddings**: Sentence Transformers (all-MiniLM-L6-v2)
- **Document Processing**: PyPDF2 (PDF), python-docx (Word)
- **API**: RESTful endpoints with automatic documentation
- **Environment**: Virtual environment with pip dependencies

### Architecture
- **Pattern**: RAG (Retrieval Augmented Generation)
- **Communication**: HTTP REST API between Flutter and Python
- **Deployment**: Local development setup (production-ready)

## Testing the App

### 🚀 Complete Testing Flow

1. **Start Backend**: `cd rag-backend && python3 start.py`
2. **Run Flutter App**: `flutter run -d chrome`
3. **Test Features**:

#### Common Feed Tab
- Scroll through announcements, events, newsletters, celebrations
- All content displays with modern Material Design 3 styling

#### Ask Me Tab (RAG-Powered AI)
Try these sample questions:
- "What is the leave policy?"  
- "Tell me about health insurance benefits"
- "How do I get IT support for my laptop?"
- "What is the remote work policy?"
- "Who should I contact for payroll questions?"

**Expected Results**: Real AI responses with document source citations

#### Personal Section Tab  
- Select your professional interests
- View career goals with progress tracking
- Browse AI-recommended courses and training

## API Endpoints

The Python FastAPI backend provides these endpoints:

### Core Endpoints
- **GET** `/health` - Backend health check
- **POST** `/api/chat` - Send messages to RAG AI assistant
- **GET** `/api/knowledge` - List documents in knowledge base
- **GET** `/docs` - Interactive API documentation

### Sample API Usage
```bash
# Test backend health
curl http://localhost:8080/health

# Send chat message  
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What is the leave policy?"}'

# Check knowledge base
curl http://localhost:8080/api/knowledge
```

### API Response Format
```json
{
  "message": "Based on our company policy...",
  "sources": [
    {
      "document": "hr-policy.pdf",
      "page": 3,
      "relevance": 0.92
    }
  ],
  "status": "success"
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

**🎉 Ready to use!** Your Qbit AI-powered enterprise app is now fully functional with both Flutter frontend and Python RAG backend.
