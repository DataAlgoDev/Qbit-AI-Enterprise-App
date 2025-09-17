#!/usr/bin/env python3
"""
Qbit RAG Backend - Ollama Powered
Simple HTTP server with real AI using Ollama Llama 3.1
"""

import json
import uuid
import requests
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

# Knowledge base - same as before
KNOWLEDGE_BASE = {
    "leave_policy": {
        "content": "Annual Leave: 25 days per year for full-time employees. Sick Leave: 10 days per year (separate from annual leave). Maternity/Paternity Leave: 16 weeks of paid time off. Request Process: Must be submitted at least 2 weeks in advance through HR portal. Carryover: Up to 5 days of unused annual leave can be carried to next year.",
        "source": "HR_Policy_2024.pdf",
        "category": "leave"
    },
    "health_benefits": {
        "content": "Medical Coverage: 100% premium covered by company. Dental Coverage: 80% covered by company (employee pays 20%). Vision Coverage: 70% covered by company (employee pays 30%). Annual Checkups: Fully covered with no copay. Prescription Drugs: 90% coverage. Family Coverage: Available with $200/month employee contribution.",
        "source": "Benefits_Guide_2024.pdf",
        "category": "health"
    },
    "it_support": {
        "content": "Email Support: it-support@company.com. Phone Support: Extension 8592996481 for urgent issues. Self-Service Portal: portal.company.com for password resets. Ticket System: Submit non-urgent issues through IT portal. Software Installation: Requires manager approval. VPN Access: Available for remote work with two-factor authentication.",
        "source": "IT_Support_Guide.pdf",
        "category": "it"
    },
    "remote_work": {
        "content": "Frequency: Up to 3 days per week with manager approval. Equipment: Company provides laptop, monitor, and ergonomic chair. Core Hours: 10 AM to 3 PM local time for all team members. In-Person Requirements: Weekly team meetings on Wednesdays. Home Office Reimbursement: Up to $500 annually for setup costs.",
        "source": "Remote_Work_Policy.pdf",
        "category": "remote"
    },
    "performance_review": {
        "content": "Annual Reviews: Conducted in January with all employees. Mid-Year Check-ins: July meetings for feedback and goal adjustments. Rating Scale: 5-point scale from Exceeds Expectations to Unsatisfactory. Components: Goal setting, competency assessment, career development planning. Promotion Decisions: Based on performance, potential, and business needs.",
        "source": "Performance_Management.pdf",
        "category": "performance"
    },
    "compensation": {
        "content": "Base Salary: Competitive rates benchmarked against industry standards. Annual Reviews: Salary reviews in March with potential increases. Performance Bonuses: Up to 20% of base salary awarded quarterly. Stock Options: Granted to all full-time employees (4-year vesting). 401k Match: 6% company match. Professional Development: $2000 annual budget per employee.",
        "source": "Compensation_Guide.pdf",
        "category": "compensation"
    },
    "active_tickets": {
        "content": "Active IT Tickets: Ticket #IT-2024-1247 - 'Outlook Email Sync Issues' | Status: In Progress | Priority: Medium | Submitted: Sept 15, 2024 | Description: Email sync problems with Outlook mobile app, not receiving new emails automatically. IT team is investigating server configuration. Expected Resolution: Sept 18, 2024 | Assigned to: Hemant D (HR) | Last Update: Sept 16 - Applied initial server patch, monitoring results.",
        "source": "IT_Ticket_System",
        "category": "tickets"
    }
}

class OllamaRAGHandler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        """Handle CORS preflight requests."""
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def do_GET(self):
        """Handle GET requests."""
        parsed_path = urlparse(self.path)
        
        if parsed_path.path == '/health':
            self.handle_health()
        elif parsed_path.path == '/api/knowledge':
            self.handle_knowledge()
        else:
            self.handle_home()
    
    def do_POST(self):
        """Handle POST requests."""
        parsed_path = urlparse(self.path)
        
        if parsed_path.path == '/api/chat':
            self.handle_chat()
        else:
            self.send_error(404, "Not Found")
    
    def handle_health(self):
        """Health check endpoint."""
        response = {
            "status": "healthy",
            "ai_backend": "Ollama Llama 3.1",
            "cost": "$0 (completely free)",
            "timestamp": "2025-09-17T18:57:00Z"
        }
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(response).encode())
    
    def handle_knowledge(self):
        """Return available knowledge base."""
        knowledge = {
            "total_documents": len(KNOWLEDGE_BASE),
            "categories": list(set(doc["category"] for doc in KNOWLEDGE_BASE.values())),
            "sources": list(set(doc["source"] for doc in KNOWLEDGE_BASE.values()))
        }
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(knowledge).encode())
    
    def handle_home(self):
        """Serve API documentation."""
        html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Qbit RAG Backend - Ollama Powered</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
                .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                h1 { color: #2196F3; }
                .endpoint { background: #f8f9fa; padding: 10px; margin: 10px 0; border-radius: 5px; font-family: monospace; }
                .method { color: #28a745; font-weight: bold; }
                .path { color: #007bff; }
                .status { background: #d4edda; color: #155724; padding: 5px 10px; border-radius: 3px; display: inline-block; margin: 5px 0; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🤖 Qbit RAG Backend - Ollama Powered</h1>
                
                <div class="status">✅ Status: Running with Real AI</div>
                <div class="status">🧠 AI: Llama 3.1 8B via Ollama</div>
                <div class="status">💰 Cost: $0 (Completely Free)</div>
                
                <h2>🔗 Available Endpoints:</h2>
                
                <div class="endpoint">
                    <span class="method">GET</span> <span class="path">/health</span><br>
                    Health check and system status
                </div>
                
                <div class="endpoint">
                    <span class="method">POST</span> <span class="path">/api/chat</span><br>
                    Chat with AI assistant (powered by Llama 3.1)
                </div>
                
                <div class="endpoint">
                    <span class="method">GET</span> <span class="path">/api/knowledge</span><br>
                    Get knowledge base information
                </div>
                
                <h2>🎯 Test with Real AI:</h2>
                <ul>
                    <li>What is my total annual leave number?</li>
                    <li>Can I work from home 5 days a week?</li>
                    <li>How much does the company pay for health insurance?</li>
                    <li>What's the process for getting IT support?</li>
                    <li>Do I have any active tickets?</li>
                    <li>What's the status of my IT ticket?</li>
                </ul>
                
                <h2>🔧 Test with curl:</h2>
                <pre>curl -X POST http://localhost:8080/api/chat \\
  -H "Content-Type: application/json" \\
  -d '{"message": "What is my total annual leave number?"}'</pre>
            </div>
        </body>
        </html>
        """
        
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(html.encode())
    
    def handle_chat(self):
        """Handle chat requests with Ollama AI."""
        try:
            # Read request body
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            request_data = json.loads(post_data.decode('utf-8'))
            
            user_message = request_data.get('message', '')
            
            # Search for relevant documents
            relevant_docs = self.search_documents(user_message)
            
            # Generate AI response using Ollama
            ai_response = self.generate_ollama_response(user_message, relevant_docs)
            
            # Prepare response
            response = {
                "response": ai_response,
                "sources": [doc['source'] for doc in relevant_docs],
                "conversation_id": str(uuid.uuid4()),
                "ai_model": "Llama 3.1 8B (Ollama)"
            }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
            
        except Exception as e:
            print(f"Error in chat handler: {e}")
            error_response = {
                "response": "I'm sorry, I encountered an error processing your request. Please try again.",
                "sources": [],
                "conversation_id": str(uuid.uuid4()),
                "error": str(e)
            }
            
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(error_response).encode())
    
    def search_documents(self, query):
        """Smart keyword-based document search."""
        query_lower = query.lower()
        results = []
        
        # Enhanced keyword mapping
        keyword_mapping = {
            "work from home": ["remote", "home office", "wfh"],
            "remote work": ["remote", "home office", "wfh"],
            "wfh": ["remote", "home office"],
            "leave": ["annual", "vacation", "pto", "time off"],
            "vacation": ["leave", "annual", "pto"],
            "health": ["medical", "dental", "vision", "insurance"],
            "insurance": ["health", "medical", "benefits"],
            "it support": ["technical", "computer", "password"],
            "performance": ["review", "evaluation", "rating"],
            "salary": ["compensation", "pay", "bonus"],
            "compensation": ["salary", "pay", "bonus", "benefits"],
            "ticket": ["tickets", "active", "it ticket", "support ticket", "issue"],
            "tickets": ["ticket", "active", "it ticket", "support ticket", "issues"],
            "my tickets": ["active tickets", "open tickets", "pending tickets"]
        }
        
        # Expand query with synonyms
        expanded_terms = query_lower.split()
        for term in query_lower.split():
            for key, synonyms in keyword_mapping.items():
                if term in key or key in query_lower:
                    expanded_terms.extend(synonyms)
        
        for doc_id, doc in KNOWLEDGE_BASE.items():
            content_lower = doc['content'].lower()
            category_lower = doc['category'].lower()
            
            # Check for matches in content, category, or expanded terms
            score = 0
            for term in expanded_terms:
                if term in content_lower:
                    score += 2
                if term in category_lower:
                    score += 3
                if term in doc_id:
                    score += 1
            
            if score > 0:
                results.append({
                    "id": doc_id,
                    "content": doc['content'],
                    "source": doc['source'],
                    "category": doc['category'],
                    "score": score
                })
        
        # Sort by relevance score
        results.sort(key=lambda x: x['score'], reverse=True)
        return results[:3]  # Return top 3 results
    
    def generate_ollama_response(self, query, docs):
        """Generate response using Ollama Llama 3.1."""
        try:
            # Prepare context from relevant documents
            context = ""
            if docs:
                context = "\n\nRelevant company information:\n"
                for doc in docs:
                    context += f"- {doc['content']}\n"
            
            # Create prompt for Llama 3.1
            prompt = f"""You are a helpful AI assistant for Qbit company employees. Answer questions concisely and directly.

User Question: {query}
{context}

Instructions:
- Give direct, specific answers
- Keep responses under 2-3 sentences when possible
- Lead with the key information (numbers, dates, etc.)
- Be friendly but brief

Response:"""
            
            # Call Ollama API
            ollama_response = requests.post(
                "http://localhost:11434/api/generate",
                json={
                    "model": "llama3.1:8b",
                    "prompt": prompt,
                    "stream": False
                },
                timeout=30
            )
            
            if ollama_response.status_code == 200:
                result = ollama_response.json()
                return result.get('response', 'I apologize, but I received an empty response from the AI model.')
            else:
                print(f"Ollama API error: {ollama_response.status_code}")
                return self.fallback_response(query, docs)
                
        except Exception as e:
            print(f"Error calling Ollama: {e}")
            return self.fallback_response(query, docs)
    
    def fallback_response(self, query, docs):
        """Fallback response if Ollama fails."""
        if docs:
            return f"Based on our company information: {docs[0]['content']}\n\nIs there anything specific you'd like to know more about?"
        else:
            return "I'm here to help with questions about company policies, benefits, leave, IT support, performance reviews, and compensation. What would you like to know?"

def start_server(port=8080):
    """Start the HTTP server."""
    server_address = ('', port)
    httpd = HTTPServer(server_address, OllamaRAGHandler)
    
    print(f"🚀 Starting Qbit RAG Backend (Ollama Powered) on port {port}")
    print(f"🧠 AI Model: Llama 3.1 8B")
    print(f"💰 Cost: $0 (Completely Free)")
    print(f"🌐 Open: http://localhost:{port}")
    print(f"📚 API Docs: http://localhost:{port}")
    print(f"🔧 Test: curl -X POST http://localhost:{port}/api/chat -H 'Content-Type: application/json' -d '{{\"message\": \"Do I have any active tickets?\"}}'")        
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        httpd.server_close()

if __name__ == "__main__":
    start_server()
