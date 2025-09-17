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
        elif parsed_path.path == '/api/newsletters':
            self.handle_newsletters()
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
        """Serve simple API documentation."""
        html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Qbit RAG Backend API</title>
        </head>
        <body>
            <h1>Qbit RAG Backend API</h1>
            
            <h2>Available Endpoints:</h2>
            
            <p><strong>GET</strong> /health - Health check and system status</p>
            <p><strong>POST</strong> /api/chat - Chat with AI assistant</p>
            <p><strong>GET</strong> /api/knowledge - Get knowledge base information</p>
            <p><strong>POST</strong> /api/newsletters - Generate AI-powered newsletters</p>
            
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
    
    def handle_newsletters(self):
        """Generate AI-powered newsletters."""
        try:
            # Read request body
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            request_data = json.loads(post_data.decode('utf-8'))
            
            count = request_data.get('count', 2)  # Default to 2 newsletters
            
            # Generate newsletters using Ollama
            newsletters = self.generate_newsletters(count)
            
            response = {
                "newsletters": newsletters,
                "generated_at": "2025-09-17T18:57:00Z",
                "ai_model": "Llama 3.1 8B (Ollama)"
            }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
            
        except Exception as e:
            print(f"Error in newsletter handler: {e}")
            # Return fallback newsletters
            fallback_newsletters = [
                {
                    "title": "AI & Machine Learning Updates",
                    "description": "Stay updated with the latest trends in artificial intelligence and machine learning technologies.",
                    "category": "AI & Technology"
                },
                {
                    "title": "Software Engineering Best Practices",
                    "description": "Explore modern software development methodologies and engineering practices.",
                    "category": "Software Engineering"
                }
            ]
            
            error_response = {
                "newsletters": fallback_newsletters,
                "generated_at": "2025-09-17T18:57:00Z",
                "error": "AI generation failed, using fallback content"
            }
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(error_response).encode())
    
    def generate_newsletters(self, count=2):
        """Generate newsletters using Ollama - Always AI/Software + Electronics/DFT."""
        # Always generate these two specific types
        topics = [
            {
                "topic": "Latest AI and Software Engineering trends and breakthroughs",
                "category": "AI & Software Engineering"
            },
            {
                "topic": "Electronics hardware development and Design for Testability (DFT) methodologies",
                "category": "Electronics & DFT"
            }
        ]
        
        newsletters = []
        
        for topic_data in topics:
            topic = topic_data["topic"]
            category = topic_data["category"]
            
            # Create prompt for newsletter generation
            prompt = f"""Create a newsletter entry about: {topic}

STRICT FORMAT - respond with EXACTLY this format:
Title: [write your engaging title here - max 8 words]
Description: [write your description here - max 120 characters]

Requirements:
- Make title engaging and specific to recent trends
- Keep description under 120 characters
- Focus on practical applications and latest developments

Topic: {topic}"""

            try:
                # Call Ollama API
                ollama_response = requests.post(
                    "http://localhost:11434/api/generate",
                    json={
                        "model": "llama3.1:8b",
                        "prompt": prompt,
                        "stream": False
                    },
                    timeout=15
                )
                
                if ollama_response.status_code == 200:
                    result = ollama_response.json()
                    ai_content = result.get('response', '')
                    print(f"🤖 AI Response for {category}: {ai_content}")
                    
                    # Parse AI response
                    newsletter = self.parse_newsletter_response(ai_content, category)
                    print(f"📝 Parsed Newsletter: {newsletter}")
                    newsletters.append(newsletter)
                else:
                    print(f"❌ Ollama API error: {ollama_response.status_code}")
                    # Fallback if Ollama fails
                    newsletters.append(self.create_fallback_newsletter(category))
                    
            except Exception as e:
                print(f"Error generating newsletter: {e}")
                newsletters.append(self.create_fallback_newsletter(category))
        
        return newsletters
    
    def parse_newsletter_response(self, ai_content, category):
        """Parse AI response into newsletter format."""
        lines = ai_content.strip().split('\n')
        
        title = "Tech Update"
        description = "Latest technology updates."
        
        for line in lines:
            line = line.strip()
            # Handle various title formats
            if any(prefix in line.lower() for prefix in ['title:', '**title:**', 'title']):
                # Extract title - remove markdown, quotes, and prefixes
                title_text = line
                title_text = title_text.replace('**Title:**', '').replace('Title:', '')
                title_text = title_text.replace('**title:**', '').replace('title:', '')
                title_text = title_text.replace('"', '').replace("'", '').strip()
                if title_text and len(title_text) > 3:  # Valid title
                    title = title_text
            
            # Handle various description formats  
            elif any(prefix in line.lower() for prefix in ['description:', '**description:**', 'description']):
                # Extract description - remove markdown, quotes, and prefixes
                desc_text = line
                desc_text = desc_text.replace('**Description:**', '').replace('Description:', '')
                desc_text = desc_text.replace('**description:**', '').replace('description:', '')
                desc_text = desc_text.replace('"', '').replace("'", '').strip()
                if desc_text and len(desc_text) > 10:  # Valid description
                    description = desc_text
        
        # Fallback: if we didn't find proper title/description, try to extract from content
        if title == "Tech Update" or description == "Latest technology updates.":
            content = ai_content.lower()
            if 'ai' in content or 'software' in content:
                title = "AI & Software Engineering News"
                description = "Latest AI and software development innovations and trends."
            elif 'electronics' in content or 'dft' in content or 'hardware' in content:
                title = "Electronics & DFT Updates"
                description = "Hardware design and Design for Testability advancements."
        
        return {
            "title": title,
            "description": description,
            "category": category
        }
    
    def create_fallback_newsletter(self, category):
        """Create fallback newsletter if AI fails."""
        fallback_map = {
            "AI & Software Engineering": {
                "title": "AI & Software Engineering Update",
                "description": "Latest developments in AI and modern software practices.",
                "category": "AI & Software Engineering"
            },
            "Electronics & DFT": {
                "title": "Electronics & DFT Innovations",
                "description": "Hardware design trends and Design for Testability advances.",
                "category": "Electronics & DFT"
            }
        }
        
        return fallback_map.get(category, {
            "title": "Technology Update",
            "description": "Latest technology trends and innovations.",
            "category": "Technology"
        })

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
