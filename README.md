<!-- Banner centrado -->
<div align="center">

# 🚀 n8n + MCP — Automatización y Agentes de IA Inteligentes

**WhatsApp · Telegram · Bots de Voz · Ollama · Gemini · OpenAI · Google Cloud · ElevenLabs · RAG · PostgreSQL · Web Scraping** （3†README.md）

---

<!-- Badges -->
<img src="https://img.shields.io/badge/n8n-Automation-00B2FF?logo=n8n&style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/MCP-Model%20Context%20Protocol-6C63FF?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/RAG-Retrieval%20Augmented%20Generation-FF7A59?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/DB-PostgreSQL-336791?logo=postgresql&style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Models-Ollama%20|%20OpenAI%20|%20Gemini-22CC88?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Messaging-WhatsApp%20|%20Telegram-25D366?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Voice-ElevenLabs-8A2BE2?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/License-MIT-black?style=for-the-badge&labelColor=0D1117" />

</div>

---

## ✨ ¿Qué aprenderás? （3†README.md）
- Diseñar y automatizar **flujos de trabajo completos** en **n8n** integrando **Google Sheets, Gmail, APIs externas y bases de datos**.  
- Construir **agentes de IA con MCP**, conectados a **herramientas personalizadas** y servicios como **Google Calendar**, correo y **modelos**.  
- Implementar **casos prácticos avanzados**: **chatbots**, **scraping**, **bots de Telegram/WhatsApp** y **agentes de voz** con datos en tiempo real.  
- Crear y administrar **sistemas RAG** para consultar **bases de conocimiento** usando **PostgreSQL** y **Google Drive**.  

> Enfoque 100% práctico y orientado a producto. （3†README.md）

---

## 🧩 Casos de uso (reales y vendibles) （3†README.md）
| Caso | Descripción | Stack recomendado |
|---|---|---|
| Chatbot FAQ empresarial | Responde políticas, soporte y ventas | n8n + RAG (PostgreSQL/Drive) + OpenAI/Ollama |
| Bot de WhatsApp | Atención 24/7 y seguimiento de leads | n8n + WhatsApp API + RAG |
| Bot de Telegram | Notificaciones operativas y comandos | n8n + Telegram Bot API |
| Agente de voz | Recepcionista/IVR con contexto | ElevenLabs/Retell + n8n + RAG |
| Web Scraping | Recolección de precios/noticias | n8n + HTTP/Code + Parse + DB |
| Automatización ofimática | Reportes/recordatorios desde Gmail/Sheets | n8n + Google APIs |

---

## 🛠️ Integraciones clave del proyecto （3†README.md）
- **Modelos**: **Ollama**, **OpenAI**, **Gemini**  
- **Mensajería**: **WhatsApp**, **Telegram**  
- **Voz**: **ElevenLabs**  
- **Cloud & Datos**: **Google Cloud**, **PostgreSQL**, **Google Drive**  
- **Patrones IA**: **RAG**, **Agentes con MCP**  

---

## 🌇️ Arquitectura de alto nivel
```text
Usuarios ──> Canales (WhatsApp/Telegram/Voz)
                │
                ▼
             n8n Orchestrator  ──┬── Conectores (Google, HTTP, DB)
                │                 ├── MCP Tools (acciones externas)
                ▼                 └── Scrapers / Cron Jobs
          Capa de IA (Ollama/OpenAI/Gemini)
                │
                ▼
           RAG: Index + Store (PostgreSQL/Drive)
```

---

## ⚡ Quickstart (modo local)
1) **Requisitos**
- Node.js LTS, Docker (opcional), cuenta(s) de APIs necesarias.  
2) **n8n**
- Self-host (Docker) o npx: `npx n8n`  
3) **Variables de entorno**
- Agrega tus claves: `OPENAI_API_KEY`, `TELEGRAM_BOT_TOKEN`, `ELEVENLABS_API_KEY`, etc.  
4) **Flujos base**
- Importa plantillas de: **Telegram Bot**, **WhatsApp webhook**, **RAG index/query**, **Gmail/Sheets automations**.  
5) **Prueba**
- Ejecuta nodos por sección, verifica logs y tokens de rate limit.

> Tip: empieza por un **flujo mínimo** (canal → IA → respuesta) y luego añade **RAG** y **MCP**.

---

## 📂 Estructura sugerida
```
/flows
  ├─ messaging/
  ├─ voice/
  ├─ rag/
  └─ ops/
 /docs
  ├─ HOWTOs.md
  └─ env.example.md
```

---

## ✅ Buenas prácticas
- **Desacopla** conectores (mensajería/voz) de la **lógica IA**.  
- **Versiona** tus flujos (export JSON) y documenta triggers/webhooks.  
- **RAG**: controla tamaño de chunk, embeddings y políticas de refresco.  
- **MCP**: define herramientas idempotentes, con validación de input/output.

---

## 📚 Referencias
- Contenido base de objetivos y alcance tomado del **README técnico** proporcionado por el autor. （3†README.md）  
- Inspiración visual/estética derivada del **README muestra** (badges/estilo). （8†README-muestra.md）

---

<div align="center">
  
**© Erick S. Ruiz — 2025** · MIT

</div>
