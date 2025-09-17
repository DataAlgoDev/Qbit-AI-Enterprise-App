# 🚀 Qbit RAG Pipeline Setup Guide

## 📋 **What You'll Get**
- Complete RAG (Retrieval Augmented Generation) system
- Go backend with OpenAI integration
- Sample company documents (HR policies, benefits, IT support)
- Updated Flutter app with real AI chat
- Document ingestion pipeline

## 🛠️ **Prerequisites**
1. **OpenAI API Key** - Get from https://platform.openai.com/api-keys
2. **Go installed** - Download from https://golang.org/dl/
3. **Python 3** - Usually pre-installed on macOS

## 🚀 **Step-by-Step Setup**

### **Step 1: Set Up RAG Backend**
```bash
cd /Users/anarayanan/dev/Qbit/rag-backend

# Run setup script
./setup.sh
```

### **Step 2: Set OpenAI API Key**
```bash
# Replace 'your-api-key-here' with your actual OpenAI API key
export OPENAI_API_KEY='your-api-key-here'

# To make it permanent, add to your shell profile:
echo 'export OPENAI_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

### **Step 3: Start RAG Backend**
```bash
cd /Users/anarayanan/dev/Qbit/rag-backend
./run.sh
```

You should see:
```
✅ OpenAI API key found
🌐 Starting server on http://localhost:8080
📖 API Documentation:
  - Health check: GET /health
  - Chat: POST /api/chat
  - Knowledge base info: GET /api/knowledge
```

### **Step 4: Update Flutter Dependencies**
```bash
cd /Users/anarayanan/dev/Qbit
flutter pub get
```

### **Step 5: Test the Setup**

#### **Test Backend Health**
```bash
curl http://localhost:8080/health
```

#### **Test Chat API**
```bash
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What is the leave policy?"}'
```

#### **Test Knowledge Base**
```bash
curl http://localhost:8080/api/knowledge
```

### **Step 6: Run Flutter App**
```bash
cd /Users/anarayanan/dev/Qbit
flutter run -d chrome
# or
flutter run -d "iPhone 16 Qbit"
```

## 🎯 **Testing Your RAG System**

### **Try These Questions in the App:**
1. **"What is the leave policy?"**
2. **"Tell me about health insurance benefits"**
3. **"How do I get IT support?"**
4. **"What is the work from home policy?"**
5. **"How does performance review work?"**

### **Expected Response Format:**
```json
{
  "response": "Based on our company policy: Annual leave is 25 days per year...",
  "sources": ["HR_Policy_2024.pdf", "Benefits_Guide_2024.pdf"],
  "conversation_id": "conv_1234567890"
}
```

## 📄 **Adding Your Own Documents**

### **Method 1: Replace Sample Documents**
1. Put your `.txt` files in `rag-backend/sample_documents/`
2. Run: `python3 ingest_documents.py --docs-dir sample_documents`
3. Restart the backend: `./run.sh`

### **Method 2: Add New Documents**
```bash
cd /Users/anarayanan/dev/Qbit/rag-backend

# Create documents from your files
python3 ingest_documents.py --docs-dir /path/to/your/documents --output new_knowledge.json

# The backend will automatically load documents on startup
```

### **Supported Document Types:**
- `.txt` files (plain text)
- HR policies, employee handbooks
- Benefits guides, IT support docs
- Any company documentation

## 🔧 **Architecture Overview**

```
Flutter App → HTTP Request → Go Backend → Vector Search → OpenAI → Response
     ↓              ↓              ↓              ↓         ↓        ↓
User Question → JSON Payload → Find Relevant → Build Context → Generate → Answer + Sources
```

## 💰 **Cost Estimation**
- **Development/Testing**: ~$5-15/month
- **Light Production**: ~$20-50/month  
- **Heavy Usage**: ~$100-200/month

Costs depend on:
- Number of queries per month
- Length of documents
- Response complexity

## 🐛 **Troubleshooting**

### **Backend Won't Start**
```bash
# Check if OpenAI API key is set
echo $OPENAI_API_KEY

# Check if port 8080 is free
lsof -i :8080

# Check Go installation
go version
```

### **Flutter App Can't Connect**
1. Make sure backend is running on `http://localhost:8080`
2. Check if CORS is enabled (it should be)
3. Try the health endpoint: `curl http://localhost:8080/health`

### **No Responses from AI**
1. Verify OpenAI API key is valid
2. Check backend logs for errors
3. Test with simple question: "What is the leave policy?"

### **Poor Response Quality**
1. Add more detailed documents
2. Improve document chunking
3. Consider upgrading to GPT-4 (edit `main.go`)

## 🚀 **Next Steps**

### **Phase 1 Complete ✅**
- [x] Basic RAG pipeline
- [x] Sample company documents
- [x] Flutter integration
- [x] Real AI responses

### **Phase 2 (Future)**
- [ ] Better vector database (Pinecone/Qdrant)
- [ ] Conversation memory
- [ ] User authentication
- [ ] Response caching
- [ ] Analytics and feedback

### **Phase 3 (Advanced)**
- [ ] Multi-agent workflows
- [ ] Live system integrations
- [ ] Automated ticket creation
- [ ] Advanced document processing

## 📞 **Support**

If you run into issues:
1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Test each component individually
4. Check backend logs for detailed error messages

Your RAG-powered Qbit app is ready! 🎉
