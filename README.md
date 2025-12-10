# [🚀 n8n + MCP - Automatizacion y Agentes de IA Inteligentes](https://www.udemy.com/course/n8n-mcp-agentes/)

**WhatsApp · Telegram · Bots de Voz · Ollama · Gemini · OpenAI · Google Cloud · ElevenLabs · RAG · PostgreSQL · Web Scraping**

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

## ✨ Que aprenderas?

- Disenar y automatizar **flujos de trabajo completos** en **n8n** integrando **Google Sheets, Gmail, APIs externas y bases de datos**.
- Construir **agentes de IA con MCP**, conectados a **herramientas personalizadas** y servicios como **Google Calendar**, correo y **modelos**.
- Implementar **casos practicos avanzados**: **chatbots**, **scraping**, **bots de Telegram/WhatsApp** y **agentes de voz** con datos en tiempo real.
- Crear y administrar **sistemas RAG** para consultar **bases de conocimiento** usando **PostgreSQL** y **Google Drive**.

> Enfoque 100% practico y orientado a productos.

---

## 🧩 Casos de uso (reales y vendibles)

| Caso | Descripcion | Stack recomendado |
|---|---|---|
| Chatbot FAQ empresarial | Responde politicas, soporte y ventas | n8n + RAG (PostgreSQL/Drive) + OpenAI/Ollama |
| Bot de WhatsApp | Atencion 24/7 y seguimiento de leads | n8n + WhatsApp API + RAG |
| Bot de Telegram | Notificaciones operativas y comandos | n8n + Telegram Bot API |
| Agente de voz | Recepcionista/IVR con contexto | ElevenLabs/Retell + n8n + RAG |
| Web Scraping | Recoleccion de precios/noticias | n8n + HTTP/Code + Parse + DB |
| Automatizacion ofimatica | Reportes/recordatorios desde Gmail/Sheets | n8n + Google APIs |

---

## 🛠️ Integraciones clave del proyecto

- **Modelos**: **Ollama**, **OpenAI**, **Gemini**
- **Mensajeria**: **WhatsApp**, **Telegram**
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

1. **Requisitos**

- Node.js LTS, Docker (opcional), cuenta(s) de las APIs necesarias.

2. **n8n**

- Auto-hospedaje (Docker) o npx: `npx n8n`

3. **Variables de entorno**

- Agrega tus claves: `OPENAI_API_KEY`, `TELEGRAM_BOT_TOKEN`, `ELEVENLABS_API_KEY`, etc.

4. **Flujos base**

- Importa plantillas de: **Telegram Bot**, **WhatsApp webhook**, **RAG index/query**, **Gmail/Sheets automations**.

5. **Prueba**

- Ejecuta nodos por seccion, verifica logs y tokens de rate limit.

> Tip: empieza por un **flujo minimo** (canal → IA → respuesta) y luego anade **RAG** y **MCP**.

---

## 📂 Estructura sugerida

```ini
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

## ✅ Buenas practicas

- **Desacopla** conectores (mensajeria/voz) de la **logica IA**.
- **Versiona** tus flujos (export JSON) y documenta triggers/webhooks.
- **RAG**: controla tamano de chunk, embeddings y politicas de refresco.
- **MCP**: define herramientas idempotentes, con validacion de input/output.

---

## 📚 Referencias

- Aun por definir

---

<div align="center">

**© Erick S. Ruiz — 2025** · MIT

</div>
