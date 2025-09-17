# 🐍 Qbit Python RAG Backend Setup

## 🎯 **What You Get**
- **FastAPI backend** with automatic API documentation
- **ChromaDB vector database** for document storage
- **OpenAI integration** for chat completions
- **Smart document ingestion** with PDF/DOCX support
- **Sentence transformers** for embeddings
- **Sample company documents** ready to use

## 🛠️ **Prerequisites**
1. **Python 3.8+** (check with `python3 --version`)
2. **OpenAI API Key** - Get from https://platform.openai.com/api-keys

## 🚀 **Quick Setup (3 Steps)**

### **Step 1: Run Setup**
```bash
cd /Users/anarayanan/dev/Qbit/rag-backend
python3 setup.py
```

This will:
- Create virtual environment
- Install all dependencies
- Create sample documents
- Initialize ChromaDB
- Create .env file template

### **Step 2: Add Your OpenAI API Key**
```bash
# Edit the .env file
nano .env

# Replace this line:
OPENAI_API_KEY=your-openai-api-key-here

# With your actual API key:
OPENAI_API_KEY=sk-your-actual-key-here
```

### **Step 3: Start the Backend**
```bash
python3 start.py
```

You should see:
```
✅ OpenAI API key found
🚀 Starting Qbit RAG Backend...
🌐 Server will be available at: http://localhost:8080
📖 API documentation at: http://localhost:8080/docs
```

## 🧪 **Test Your Setup**

### **1. Health Check**
```bash
curl http://localhost:8080/health
```

### **2. Test Chat API**
```bash
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What is the leave policy?"}'
```

### **3. Check Knowledge Base**
```bash
curl http://localhost:8080/api/knowledge
```

### **4. Interactive API Docs**
Open in browser: http://localhost:8080/docs

## 📱 **Update Flutter App**

Your Flutter app is already configured to use the Python backend! Just make sure to install the HTTP dependency:

```bash
cd /Users/anarayanan/dev/Qbit
flutter pub get
```

## 🎯 **Test in Flutter App**

1. **Start Python backend**: `python3 start.py`
2. **Run Flutter app**: `flutter run -d chrome`
3. **Go to "Ask Me" tab**
4. **Try these questions**:
   - "What is the leave policy?"
   - "Tell me about health insurance"
   - "How do I get IT support?"
   - "What is the remote work policy?"

## 📄 **Adding Your Own Documents**

### **Method 1: Replace Sample Documents**
```bash
# Put your files in sample_documents/
cp /path/to/your/hr-policy.pdf sample_documents/
cp /path/to/your/benefits.docx sample_documents/

# Re-ingest documents
python3 document_ingestion.py --docs-dir sample_documents --reset
```

### **Method 2: Add to Existing Knowledge Base**
```bash
# Add without resetting
python3 document_ingestion.py --docs-dir /path/to/new/documents
```

### **Supported File Types**
- ✅ `.txt` - Plain text files
- ✅ `.md` - Markdown files  
- ✅ `.pdf` - PDF documents (requires PyPDF2)
- ✅ `.docx` - Word documents (requires python-docx)

## 🏗️ **Architecture Overview**

```
Flutter App → HTTP → FastAPI → ChromaDB → OpenAI → Response
     ↓         ↓        ↓         ↓         ↓        ↓
User Question → JSON → Vector Search → Context → AI → Answer + Sources
```

## 🔧 **Advanced Configuration**

### **Environment Variables (.env file)**
```bash
# API Configuration
OPENAI_API_KEY=your-key-here
PORT=8080
HOST=0.0.0.0

# ChromaDB
CHROMA_COLLECTION_NAME=qbit_knowledge

# Logging
LOG_LEVEL=INFO
```

### **Customize Embedding Model**
Edit `main.py` and change:
```python
self.embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
# To:
self.embedding_model = SentenceTransformer('all-mpnet-base-v2')  # Better quality
```

### **Upgrade to GPT-4**
Edit `main.py` and change:
```python
model="gpt-3.5-turbo",
# To:
model="gpt-4",  # Better quality, higher cost
```

## 💰 **Cost Estimation**

### **Development/Testing**
- **ChromaDB**: Free (local)
- **Embeddings**: Free (sentence-transformers)
- **OpenAI API**: ~$5-15/month
- **Total**: ~$5-15/month

### **Production**
- **ChromaDB**: Free (local) or $20-50/month (cloud)
- **OpenAI API**: $20-100/month (depends on usage)
- **Total**: ~$20-150/month

## 🐛 **Troubleshooting**

### **"OPENAI_API_KEY not set"**
```bash
# Check if .env file exists
ls -la .env

# Edit and add your key
nano .env
```

### **"Module not found" errors**
```bash
# Activate virtual environment
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt
```

### **ChromaDB errors**
```bash
# Reset the database
python3 document_ingestion.py --create-samples --reset
```

### **Poor response quality**
1. Add more detailed documents
2. Upgrade to GPT-4 (edit main.py)
3. Use better embedding model (all-mpnet-base-v2)

## 🚀 **Python vs Go Backend Advantages**

### **✅ Python Advantages**
- **Better ML ecosystem** (sentence-transformers, ChromaDB)
- **Easier document processing** (PyPDF2, python-docx)
- **Rich AI libraries** (langchain, llama-index)
- **Faster development** for RAG systems
- **Better debugging** and experimentation

### **🔧 Go Advantages**
- **Better performance** for high-traffic APIs
- **Lower memory usage**
- **Easier deployment** (single binary)
- **Better for microservices**

**For RAG systems, Python is the better choice!** 🐍

## 📞 **Need Help?**

1. **Check logs** in the terminal where you ran `python3 start.py`
2. **Visit API docs** at http://localhost:8080/docs
3. **Test individual endpoints** using the interactive docs
4. **Check ChromaDB** with `/api/knowledge` endpoint

Your Python-powered RAG system is ready! 🎉
