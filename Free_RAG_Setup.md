# Free RAG Pipeline Setup for Qbit

## 🎯 **Completely Free Development Stack**

### **Architecture**
```
Flutter App → Go Backend → Chroma DB → Ollama/OpenAI
                              ↓           ↓
                         Local Vector   Local/Cloud LLM
```

## 🔧 **Technology Stack**

### **Vector Database: Chroma (Free)**
- **Cost**: $0 (runs locally)
- **Setup**: Docker or Python package
- **Pros**: Simple, fast, perfect for development
- **Cons**: Local only (not distributed)

### **LLM Options:**

#### **Option A: Ollama (Completely Free)**
- **Cost**: $0 (runs locally)
- **Models**: Llama 3.1, Mistral, CodeLlama
- **Pros**: No API costs, privacy, offline
- **Cons**: Requires good hardware (8GB+ RAM)

#### **Option B: OpenAI API (Pay-per-use)**
- **Cost**: ~$0.50-2.00 per 1M tokens
- **Models**: GPT-3.5-turbo, GPT-4
- **Pros**: High quality, no hardware requirements
- **Cons**: Small cost per query (~$0.001-0.01)

### **Embeddings:**

#### **Free Option: sentence-transformers**
```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')  # Free
```

#### **Paid Option: OpenAI Embeddings**
```go
// ~$0.10 per 1M tokens
openai.CreateEmbedding("text-embedding-3-small", text)
```

## 💰 **Cost Breakdown**

### **Completely Free Setup:**
- Vector DB: $0 (Chroma local)
- LLM: $0 (Ollama local)
- Embeddings: $0 (sentence-transformers)
- **Total: $0/month**

### **Hybrid Setup (Recommended):**
- Vector DB: $0 (Chroma local)
- LLM: ~$5-20/month (OpenAI API for testing)
- Embeddings: ~$1-5/month (OpenAI)
- **Total: ~$6-25/month for development**

## 🚀 **Quick Setup Commands**

### **1. Start Chroma Vector DB**
```bash
# Option A: Docker
docker run -p 8000:8000 chromadb/chroma

# Option B: Python
pip install chromadb
python -c "import chromadb; chromadb.HttpClient(host='localhost', port=8000)"
```

### **2. Start Ollama (Free LLM)**
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Download a model
ollama pull llama3.1:8b

# Start API server
ollama serve
```

### **3. Go Backend Dependencies**
```bash
go mod init qbit-backend
go get github.com/gin-gonic/gin
go get github.com/chroma-core/chroma-go  # Chroma client
go get github.com/sashabaranov/go-openai  # If using OpenAI
```

## 🎯 **Development vs Production**

### **Development (Free/Cheap)**
- Chroma local vector DB
- Ollama or cheap OpenAI API
- Perfect for testing and learning

### **Production (Paid)**
- Pinecone or managed Qdrant
- Claude/GPT-4 for quality
- Redis caching, monitoring

## 📊 **Expected Usage Costs**

### **For 1000 queries/month:**
- **Free setup**: $0
- **Hybrid setup**: ~$2-5
- **Full cloud setup**: ~$50-100

### **For 10,000 queries/month:**
- **Free setup**: $0
- **Hybrid setup**: ~$10-30
- **Full cloud setup**: ~$200-500

## 🎯 **Recommendation**

**Start with Hybrid Setup:**
1. **Chroma** for vector storage (free)
2. **OpenAI API** for LLM (cheap, high quality)
3. **OpenAI embeddings** (cheap, reliable)
4. **Upgrade later** to Pinecone when scaling

This gives you production-quality results for ~$10-20/month during development!
