# Preguntas Frecuentes (FAQ)

## Preguntas Generales

### ¿Qué es este proyecto?

Esta es una plataforma de automatización completa construida sobre n8n que integra modelos de IA, plataformas de mensajería (Telegram, WhatsApp), RAG (Retrieval-Augmented Generation), web scraping, y agentes autónomos. Está diseñada para ayudarte a construir workflows de automatización inteligentes sin necesidad de programar extensivamente.

### ¿Necesito conocimientos de programación?

No, la mayoría de workflows pueden configurarse a través de la interfaz visual de n8n. Sin embargo, un entendimiento básico de JSON y SQL puede ser útil para personalización.

### ¿Es gratuito?

La plataforma en sí es gratuita y de código abierto. Sin embargo, algunos servicios integrados (OpenAI, ElevenLabs, etc.) requieren suscripciones de API de pago.

### ¿Puedo usar esto en producción?

Sí, pero asegúrate de:

- Usar autenticación fuerte
- Implementar HTTPS
- Seguir mejores prácticas de seguridad
- Tener respaldos apropiados
- Monitorear el uso de recursos

## Instalación y Configuración

### ¿Cuáles son los requisitos del sistema?

- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM mínimo (8GB recomendados)
- 10GB de espacio libre en disco
- Linux, macOS, o Windows con WSL2

### ¿Por qué los servicios Docker no inician?

Causas comunes:

- Conflictos de puertos (5678, 5432, 11434)
- Recursos insuficientes
- Docker no está ejecutándose
- Volúmenes corruptos

Solución: Revisa los logs con `docker-compose logs` y asegúrate de que los puertos estén disponibles.

### ¿Cómo cambio el puerto predeterminado?

Edita `docker-compose.yml` y cambia el mapeo de puertos:

```yaml
ports:
  - "8080:5678"  # Change 5678 to your preferred port

```

### ¿Puedo ejecutar esto sin Docker?

Sí, pero es más complejo. Necesitarás:

- Instalar PostgreSQL con extensión pgvector
- Instalar n8n manualmente
- Instalar y configurar Ollama
- Configurar manualmente todos los servicios

## Modelos de IA

### ¿Qué modelo de IA debería usar?

Depende de tus necesidades:

- **OpenAI GPT-4**: Más preciso, costoso
- **GPT-3.5-turbo**: Rápido, costo-efectivo
- **Gemini**: Buen balance, ecosistema Google
- **Ollama (Llama2)**: Gratuito, privado, ejecuta localmente

### ¿Cómo uso modelos locales de Ollama?

1. Descarga el modelo:

```bash
docker exec -it $(docker-compose ps -q ollama) ollama pull llama2

```

2. Actualiza los workflows para usar HTTP Request a `http://ollama:11434/api/generate`

### ¿Puedo usar múltiples modelos de IA juntos?

¡Sí! Puedes:

- Usar diferentes modelos para diferentes workflows
- Implementar mecanismos de respaldo
- Comparar salidas de múltiples modelos
- Enrutar basado en complejidad de tarea

### ¿Cuánto cuestan las llamadas a API?

Los costos varían por proveedor:

- **OpenAI**: ~$0.002-0.06 por 1K tokens
- **Gemini**: Nivel gratuito disponible, luego ~$0.00025-0.0005 por 1K caracteres
- **ElevenLabs**: ~$0.30 por 1K caracteres
- **Ollama**: Gratuito (auto-hospedado)

## Bots de Mensajería

### ¿Cómo creo un bot de Telegram?

1. Envía mensaje a [@BotFather](https://t.me/botfather)
2. Envía `/newbot`
3. Sigue las indicaciones para nombrar tu bot
4. Copia el token proporcionado
5. Agrega el token al archivo `.env`

### ¿Por qué mi bot de Telegram no responde?

Verifica:

- El workflow está activado en n8n
- Las credenciales de Telegram son correctas
- El token del bot es válido
- n8n es accesible (sin bloqueo de firewall)
- Revisa los logs de ejecución de n8n

### ¿Cómo configuro WhatsApp Business API?

Dos opciones:

**Opción 1: Meta Business API** (Recomendado para producción)

1. Crear Cuenta de Negocio Meta
2. Crear app WhatsApp Business
3. Configurar webhook
4. Obtener access token

**Opción 2: Twilio** (Más fácil para pruebas)

1. Crear cuenta Twilio
2. Habilitar sandbox de WhatsApp
3. Configurar credenciales

### ¿Puedo usar el mismo workflow para múltiples bots?

Sí, puedes:

- Duplicar el workflow
- Usar diferentes credenciales
- Modificar según sea necesario para cada bot

## RAG (Retrieval-Augmented Generation)

### ¿Qué es RAG?

RAG combina recuperación de documentos con generación de IA. Busca en tu base de conocimiento información relevante y usa ese contexto para generar respuestas precisas e informadas.

### ¿Cómo agrego documentos a la base de datos RAG?

Varios métodos:

1. **Web scraping**: Usa el workflow de scraping
2. **Inserción manual**: Usa sentencias SQL INSERT
3. **API**: Crea un workflow con HTTP webhook
4. **Importación CSV**: Crea un workflow de importación

### ¿Qué es pgvector?

pgvector es una extensión de PostgreSQL que habilita la búsqueda de similitud vectorial, esencial para RAG. Permite encontrar documentos similares basándose en significado semántico, no solo palabras clave.

### ¿Qué tan preciso es RAG?

La precisión depende de:

- Calidad de tu base de conocimiento
- Relevancia de documentos recuperados
- Calidad del modelo de IA
- Efectividad del modelo de embeddings

Típicamente 70-90% preciso con buenos datos.

## Web Scraping

### ¿Es legal el web scraping?

Depende:

- Revisa los Términos de Servicio del sitio web
- Revisa robots.txt
- Respeta los límites de tasa
- No extraigas datos personales sin permiso
- Considera las implicaciones de copyright

### ¿Cómo agrego sitios web para scrapear?

Inserta URLs en la base de datos:

```sql
INSERT INTO scraped_data (url, is_processed)
VALUES ('https://example.com', false);

```

### ¿Por qué falla el scraping?

Problemas comunes:

- Sitio web bloqueando solicitudes automatizadas
- URL inválida
- Contenido renderizado con JavaScript (necesita navegador)
- Limitación de tasa
- Autenticación requerida

### ¿Con qué frecuencia debo scrapear?

Depende de:

- Frecuencia de actualización de contenido
- Límites de tasa del sitio web
- Tu capacidad de almacenamiento
- Consideraciones de costo de API

Típico: Cada 6-24 horas

## Base de Datos

### ¿Cómo accedo a la base de datos?

```bash
docker-compose exec postgres psql -U n8n -d n8n

```

O usa una herramienta GUI como pgAdmin con:

- Host: localhost
- Port: 5432
- Database: n8n
- User: n8n
- Password: (del archivo .env)

### ¿Cómo respaldo la base de datos?

Usa el script de respaldo:

```bash
./scripts/backup.sh

```

O manualmente:

```bash
docker-compose exec -T postgres pg_dump -U n8n n8n > backup.sql

```

### ¿Puedo usar un servidor PostgreSQL externo?

Sí, actualiza `docker-compose.yml`:

```yaml
environment:
  - DB_POSTGRESDB_HOST=your-postgres-host
  - DB_POSTGRESDB_PORT=5432
  # ... other settings

```

Elimina el servicio postgres de docker-compose.yml.

### ¿Cómo limpio datos antiguos?

Ejecuta consultas de mantenimiento:

```sql
DELETE FROM conversations WHERE created_at < NOW() - INTERVAL '6 months';
DELETE FROM workflows_log WHERE executed_at < NOW() - INTERVAL '3 months';
VACUUM ANALYZE;

```

## Rendimiento

### n8n está funcionando lento

Soluciones:

- Aumenta la asignación de memoria de Docker
- Optimiza workflows (reduce polling)
- Usa webhooks en lugar de polling
- Implementa caché
- Actualiza el hardware

### La base de datos se está volviendo grande

Soluciones:

- Implementa políticas de retención de datos
- Archiva datos antiguos
- Elimina logs innecesarios
- Ejecuta VACUUM en la base de datos regularmente

### Las llamadas API son muy lentas

Soluciones:

- Usa modelos de IA más rápidos
- Reduce los límites de tokens
- Cambia a Ollama local
- Implementa caché de respuestas
- Usa procesamiento por lotes

## Seguridad

### ¿Cómo aseguro mi instalación?

1. Cambia las credenciales predeterminadas
2. Usa HTTPS (con reverse proxy)
3. Implementa reglas de firewall
4. Usa contraseñas fuertes
5. Rota las claves API
6. Mantén las imágenes Docker actualizadas
7. Implementa limitación de tasa

### ¿Mis claves API están seguras?

Sí, si tú:

- Usas variables de entorno
- Nunca haces commit de .env a git
- Restringes permisos de archivos
- Usas herramientas de gestión de secretos
- Monitoreas acceso no autorizado

### ¿Debería exponer n8n a internet?

Para webhooks (Telegram, WhatsApp), sí, pero:

- Usa HTTPS
- Implementa autenticación
- Usa un reverse proxy (nginx)
- Implementa limitación de tasa
- Monitorea logs de acceso

## Solución de Problemas

### Los workflows no se ejecutan

Verifica:

- El workflow está activado
- Las credenciales están configuradas
- El trigger está configurado correctamente
- No hay errores en el log de ejecución
- Los servicios están ejecutándose

### El webhook no recibe datos

Verifica:

- URL del webhook correcta
- El workflow está activo
- El firewall permite solicitudes entrantes
- El servicio externo está configurado correctamente
- Prueba con curl o Postman

### Errores de memoria insuficiente

Soluciones:

- Aumenta el límite de memoria de Docker
- Reduce ejecuciones concurrentes
- Procesa datos en lotes
- Limpia datos antiguos
- Actualiza recursos del sistema

### El contenedor se reinicia constantemente

Verifica:

- `docker-compose logs [service]`
- Restricciones de recursos
- Errores de configuración
- Conflictos de puertos
- Permisos de volúmenes

## Uso Avanzado

### ¿Puedo crear workflows personalizados?

¡Absolutamente! Usa el editor visual de workflows de n8n para:

- Combinar nodos existentes
- Agregar nodos de código personalizados
- Integrar nuevos servicios
- Construir automatizaciones complejas

### ¿Cómo integro otros servicios?

n8n soporta más de 300 integraciones:

- Usa nodos integrados
- HTTP Request para APIs
- Webhooks para eventos
- Nodos de base de datos para datos
- Código personalizado para lógica

### ¿Puedo programar workflows?

- Nodo Schedule Trigger
- Expresiones cron
- Triggers de intervalo
- Triggers de webhook

### ¿Cómo monitoreo workflows?

Métodos:

- Logs de ejecución de n8n
- Tabla workflow_logs de la base de datos
- Notificaciones de error (email, Slack)
- Herramientas de monitoreo externas
- Dashboards personalizados

## Soporte

### ¿Dónde puedo obtener ayuda?

- Revisa la documentación en `docs/`
- Revisa los archivos README de workflows
- Busca en GitHub issues
- Visita la [comunidad n8n](https://community.n8n.io/)
- Crea un GitHub issue

### ¿Cómo reporto bugs?

Crea un GitHub issue con:

- Descripción clara
- Pasos para reproducir
- Comportamiento esperado vs actual
- Detalles del entorno
- Logs y capturas de pantalla

### ¿Puedo solicitar características?

¡Sí! Crea un GitHub issue con:

- Descripción de la característica
- Caso de uso
- Implementación potencial
- Ejemplos

### ¿Hay soporte comercial disponible?

Este es un proyecto comunitario. Para soporte comercial:

- Contrata expertos de n8n
- Contacta a los mantenedores del proyecto
- Considera n8n Cloud (oficial)

---

**¿No encontraste tu pregunta? ¡Crea un issue en GitHub!**
