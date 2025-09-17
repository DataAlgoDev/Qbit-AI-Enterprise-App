Qbit - AI Powered enterprise App
----
An AI powered application to bridge the gaps between employees and the organization.

Current gaps and issues:
----
Employees are not fully aware of the organization's policies and benefits due to lack of a centralized platform and visibility about new updates.
We employees have to reach out to HR and management for such queries or complaints which can take up valuable time of HR or lead staffs.
Relying on third party applications have limitations like security issue, lack of centralization, customization etc.

Scope of project
----
Centralized application powered by AI which reduces the gap between organization and employees with additional features to improve work life.
The application is currently scoped to have 3 main categories.
1. Common feed with calender events - 
* For organizational level announcements (Improves visibility of announcements)
* AI powered newsletters tailored to technology pursued by the organization (Improves exposure to latest changes in domains)
* Automated reminders and celebrations based on data (Birthday, anniversary events etc.)
2. Ask me - 
* AI agent(s) trained with internal data using a RAG(Retrieval Augmented Generation) architecture with custom vector database and connected using langchains : This provides accurate answers based on internal data and can be trained to raise tickets to relevant team. Example, someone wants to know about the Health insurance benefits offered by the company, or leave policies the agent can answer these questions based onn trained data.
If someone want support regarding their email account is not working they can tell the agent and it will raise an incident to relevant party.
3. Personal section - 
One can set their interests or career aspirations and AI will suggest steps to achieve it. Example, If I select my interest as AI engineering it will find and suggest Free/paid online courses, webinars to attend.
This section can be used to link personal data like Annual Health checkup metrics to suggest healthy lifestyle options.

Technologies
----
1. Flutter for front end Application layer
2. Go Framework for backend/API layer
3. Python for AI layer
3. Mongodb / Postgres and vectordb for database layer
4. Claude sonnet/GPT5 for AI agent and langchain/langraph for AI systems if orchestration of multi agents required

Future scope
----
With scalable architecture and strong database, this app can even replace GreytHR
