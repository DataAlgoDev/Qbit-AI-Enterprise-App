# Qbit AI Architecture - RAG Implementation

## 🎯 **Current Goal: Simple RAG System**

For the chatbot in "Ask Me" section, we'll implement a straightforward RAG (Retrieval Augmented Generation) system.

## 🏗️ **Simplified Architecture**

```
Flutter App → Go Backend API → Vector DB → LLM → Response
     ↓              ↓              ↓         ↓        ↓
User Question → Process Query → Find Docs → Generate → Answer
```

## 🔧 **Technology Stack**

### **Frontend**
- Flutter (existing app)
- HTTP client for API calls
- Real-time chat interface

### **Backend (Go)**
- **Framework**: Gin or Echo
- **Vector DB Client**: Pinecone Go SDK
- **LLM Client**: OpenAI or Anthropic SDK
- **Caching**: Redis (optional)

### **Data Storage**
- **Vector Database**: Pinecone (managed, simple)
- **Document Storage**: Company policies, HR docs, benefits
- **Embeddings**: OpenAI text-embedding-3-small

### **AI/LLM**
- **Primary**: Claude Sonnet 3.5 or GPT-4
- **Fallback**: GPT-3.5-turbo (cost optimization)

## 📊 **Data Flow**

### **1. Data Ingestion (One-time setup)**
```
HR Documents → Text Extraction → Chunking → Embeddings → Vector DB
```

### **2. Query Processing (Real-time)**
```
User Question → Embedding → Vector Search → Retrieved Context → LLM → Response
```

## 🎯 **Why RAG Only (No MCP)?**

### **RAG is Perfect For:**
- ✅ Static company documents (HR policies, benefits)
- ✅ Knowledge base queries
- ✅ Document-based Q&A
- ✅ Simple implementation
- ✅ Predictable costs

### **MCP Would Be Needed For:**
- ❌ Live database queries (employee records)
- ❌ Real-time system integrations
- ❌ Dynamic data sources
- ❌ Complex multi-system workflows

**For your use case (HR policies, benefits, company rules), RAG is ideal!**

## 🚀 **Implementation Plan**

### **Phase 1: Basic RAG Setup**
1. Set up Pinecone vector database
2. Create Go backend with basic endpoints
3. Implement document ingestion pipeline
4. Connect Flutter app to real API

### **Phase 2: Enhanced Features**
1. Add conversation memory
2. Improve response quality
3. Add response caching
4. User feedback system

## 🔧 **API Design**

### **Endpoints**
```go
POST /api/chat
{
  "message": "What is the leave policy?",
  "conversation_id": "uuid"
}

Response:
{
  "response": "Our leave policy includes...",
  "sources": ["HR_Policy_2024.pdf", "Benefits_Guide.pdf"],
  "conversation_id": "uuid"
}
```

## 💰 **Cost Estimation**
- **Pinecone**: ~$70/month (1M vectors)
- **Claude API**: ~$15/1M tokens
- **Embeddings**: ~$0.10/1M tokens
- **Total**: ~$100-200/month for moderate usage

## 🎯 **Next Steps**
1. Set up Pinecone account
2. Create Go backend project
3. Implement basic RAG endpoints
4. Update Flutter app to use real API
5. Prepare company documents for ingestion
