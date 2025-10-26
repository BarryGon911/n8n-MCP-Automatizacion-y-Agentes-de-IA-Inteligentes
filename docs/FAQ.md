# Preguntas Frecuentes (FAQ)

## Preguntas Generales

### Que es este proyecto?

Esta es una plataforma de automatizacion completa construida sobre n8n que integra modelos de IA, plataformas de mensajeria (Telegram, WhatsApp), RAG (Retrieval-Augmented Generation), web scraping, y agentes autonomos. Esta disenada para ayudarte a construir workflows de automatizacion inteligentes sin necesidad de programar extensivamente.

### Necesito conocimientos de programacion?

No, la mayoria de workflows pueden configurarse a traves de la interfaz visual de n8n. Sin embargo, un entendimiento basico de JSON y SQL puede ser util para personalizacion.

### Es gratuito?

La plataforma en si es gratuita y de codigo abierto. Sin embargo, algunos servicios integrados (OpenAI, ElevenLabs, etc.) requieren suscripciones de API de pago.

### Puedo usar esto en produccion?

Si, pero asegurate de:

- Usar autenticacion fuerte
- Implementar HTTPS
- Seguir mejores practicas de seguridad
- Tener respaldos apropiados
- Monitorear el uso de recursos

## Instalacion y Configuracion

### Cuales son los requisitos del sistema?

- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM minimo (8GB recomendados)
- 10GB de espacio libre en disco
- Linux, macOS, o Windows con WSL2

### Por que los servicios Docker no inician?

Causas comunes:

- Conflictos de puertos (5678, 5432, 11434)
- Recursos insuficientes
- Docker no esta ejecutandose
- Volumenes corruptos

Solucion: Revisa los logs con `docker-compose logs` y asegurate de que los puertos esten disponibles.

### Como cambio el puerto predeterminado?

Edita `docker-compose.yml` y cambia el mapeo de puertos:

```yaml
ports:
  - "8080:5678"  # Change 5678 to your preferred port

```

### Puedo ejecutar esto sin Docker?

Si, pero es mas complejo. Necesitaras:

- Instalar PostgreSQL con extension pgvector
- Instalar n8n manualmente
- Instalar y configurar Ollama
- Configurar manualmente todos los servicios

## Modelos de IA

### Que modelo de IA deberia usar?

Depende de tus necesidades:

- **OpenAI GPT-4**: Mas preciso, costoso
- **GPT-3.5-turbo**: Rapido, costo-efectivo
- **Gemini**: Buen balance, ecosistema Google
- **Ollama (Llama2)**: Gratuito, privado, ejecuta localmente

### Como uso modelos locales de Ollama?

1. Descarga el modelo:

```bash
docker exec -it $(docker-compose ps -q ollama) ollama pull llama2

```

2. Actualiza los workflows para usar HTTP Request a `http://ollama:11434/api/generate`

### Puedo usar multiples modelos de IA juntos?

Si! Puedes:

- Usar diferentes modelos para diferentes workflows
- Implementar mecanismos de respaldo
- Comparar salidas de multiples modelos
- Enrutar basado en complejidad de tarea

### Cuanto cuestan las llamadas a API?

Los costos varian por proveedor:

- **OpenAI**: ~$0.002-0.06 por 1K tokens
- **Gemini**: Nivel gratuito disponible, luego ~$0.00025-0.0005 por 1K caracteres
- **ElevenLabs**: ~$0.30 por 1K caracteres
- **Ollama**: Gratuito (auto-hospedado)

## Bots de Mensajeria

### Como creo un bot de Telegram?

1. Envia mensaje a [@BotFather](https://t.me/botfather)
2. Envia `/newbot`
3. Sigue las indicaciones para nombrar tu bot
4. Copia el token proporcionado
5. Agrega el token al archivo `.env`

### Por que mi bot de Telegram no responde?

Verifica:

- El workflow esta activado en n8n
- Las credenciales de Telegram son correctas
- El token del bot es valido
- n8n es accesible (sin bloqueo de firewall)
- Revisa los logs de ejecucion de n8n

### Como configuro WhatsApp Business API?

Dos opciones:

**Opcion 1: Meta Business API** (Recomendado para produccion)

1. Crear Cuenta de Negocio Meta
2. Crear app WhatsApp Business
3. Configurar webhook
4. Obtener access token

**Opcion 2: Twilio** (Mas facil para pruebas)

1. Crear cuenta Twilio
2. Habilitar sandbox de WhatsApp
3. Configurar credenciales

### Puedo usar el mismo workflow para multiples bots?

Si, puedes:

- Duplicar el workflow
- Usar diferentes credenciales
- Modificar segun sea necesario para cada bot

## RAG (Retrieval-Augmented Generation)

### Que es RAG?

RAG combina recuperacion de documentos con generacion de IA. Busca en tu base de conocimiento informacion relevante y usa ese contexto para generar respuestas precisas e informadas.

### Como agrego documentos a la base de datos RAG?

Varios metodos:

1. **Web scraping**: Usa el workflow de scraping
2. **Insercion manual**: Usa sentencias SQL INSERT
3. **API**: Crea un workflow con HTTP webhook
4. **Importacion CSV**: Crea un workflow de importacion

### Que es pgvector?

pgvector es una extension de PostgreSQL que habilita la busqueda de similitud vectorial, esencial para RAG. Permite encontrar documentos similares basandose en significado semantico, no solo palabras clave.

### Que tan preciso es RAG?

La precision depende de:

- Calidad de tu base de conocimiento
- Relevancia de documentos recuperados
- Calidad del modelo de IA
- Efectividad del modelo de embeddings

Tipicamente 70-90% preciso con buenos datos.

## Web Scraping

### Es legal el web scraping?

Depende:

- Revisa los Terminos de Servicio del sitio web
- Revisa robots.txt
- Respeta los limites de tasa
- No extraigas datos personales sin permiso
- Considera las implicaciones de copyright

### Como agrego sitios web para scrapear?

Inserta URLs en la base de datos:

```sql
INSERT INTO scraped_data (url, is_processed)
VALUES ('https://example.com', false);

```

### Por que falla el scraping?

Problemas comunes:

- Sitio web bloqueando solicitudes automatizadas
- URL invalida
- Contenido renderizado con JavaScript (necesita navegador)
- Limitacion de tasa
- Autenticacion requerida

### Con que frecuencia debo scrapear?

Depende de:

- Frecuencia de actualizacion de contenido
- Limites de tasa del sitio web
- Tu capacidad de almacenamiento
- Consideraciones de costo de API

Tipico: Cada 6-24 horas

## Base de Datos

### Como accedo a la base de datos?

```bash
docker-compose exec postgres psql -U n8n -d n8n

```

O usa una herramienta GUI como pgAdmin con:

- Host: localhost
- Port: 5432
- Database: n8n
- User: n8n
- Password: (del archivo .env)

### Como respaldo la base de datos?

Usa el script de respaldo:

```bash
./scripts/backup.sh

```

O manualmente:

```bash
docker-compose exec -T postgres pg_dump -U n8n n8n > backup.sql

```

### Puedo usar un servidor PostgreSQL externo?

Si, actualiza `docker-compose.yml`:

```yaml
environment:
  - DB_POSTGRESDB_HOST=your-postgres-host
  - DB_POSTGRESDB_PORT=5432
  # ... other settings

```

Elimina el servicio postgres de docker-compose.yml.

### Como limpio datos antiguos?

Ejecuta consultas de mantenimiento:

```sql
DELETE FROM conversations WHERE created_at < NOW() - INTERVAL '6 months';
DELETE FROM workflows_log WHERE executed_at < NOW() - INTERVAL '3 months';
VACUUM ANALYZE;

```

## Rendimiento

### n8n esta funcionando lento

Soluciones:

- Aumenta la asignacion de memoria de Docker
- Optimiza workflows (reduce polling)
- Usa webhooks en lugar de polling
- Implementa cache
- Actualiza el hardware

### La base de datos se esta volviendo grande

Soluciones:

- Implementa politicas de retencion de datos
- Archiva datos antiguos
- Elimina logs innecesarios
- Ejecuta VACUUM en la base de datos regularmente

### Las llamadas API son muy lentas

Soluciones:

- Usa modelos de IA mas rapidos
- Reduce los limites de tokens
- Cambia a Ollama local
- Implementa cache de respuestas
- Usa procesamiento por lotes

## Seguridad

### Como aseguro mi instalacion?

1. Cambia las credenciales predeterminadas
2. Usa HTTPS (con reverse proxy)
3. Implementa reglas de firewall
4. Usa contrasenas fuertes
5. Rota las claves API
6. Manten las imagenes Docker actualizadas
7. Implementa limitacion de tasa

### Mis claves API estan seguras?

Si, si tu:

- Usas variables de entorno
- Nunca haces commit de .env a git
- Restringes permisos de archivos
- Usas herramientas de gestion de secretos
- Monitoreas acceso no autorizado

### Deberia exponer n8n a internet?

Para webhooks (Telegram, WhatsApp), si, pero:

- Usa HTTPS
- Implementa autenticacion
- Usa un reverse proxy (nginx)
- Implementa limitacion de tasa
- Monitorea logs de acceso

## Solucion de Problemas

### Los workflows no se ejecutan

Verifica:

- El workflow esta activado
- Las credenciales estan configuradas
- El trigger esta configurado correctamente
- No hay errores en el log de ejecucion
- Los servicios estan ejecutandose

### El webhook no recibe datos

Verifica:

- URL del webhook correcta
- El workflow esta activo
- El firewall permite solicitudes entrantes
- El servicio externo esta configurado correctamente
- Prueba con curl o Postman

### Errores de memoria insuficiente

Soluciones:

- Aumenta el limite de memoria de Docker
- Reduce ejecuciones concurrentes
- Procesa datos en lotes
- Limpia datos antiguos
- Actualiza recursos del sistema

### El contenedor se reinicia constantemente

Verifica:

- `docker-compose logs [service]`
- Restricciones de recursos
- Errores de configuracion
- Conflictos de puertos
- Permisos de volumenes

## Uso Avanzado

### Puedo crear workflows personalizados?

Absolutamente! Usa el editor visual de workflows de n8n para:

- Combinar nodos existentes
- Agregar nodos de codigo personalizados
- Integrar nuevos servicios
- Construir automatizaciones complejas

### Como integro otros servicios?

n8n soporta mas de 300 integraciones:

- Usa nodos integrados
- HTTP Request para APIs
- Webhooks para eventos
- Nodos de base de datos para datos
- Codigo personalizado para logica

### Puedo programar workflows?

- Nodo Schedule Trigger
- Expresiones cron
- Triggers de intervalo
- Triggers de webhook

### Como monitoreo workflows?

Metodos:

- Logs de ejecucion de n8n
- Tabla workflow_logs de la base de datos
- Notificaciones de error (email, Slack)
- Herramientas de monitoreo externas
- Dashboards personalizados

## Soporte

### Donde puedo obtener ayuda?

- Revisa la documentacion en `docs/`
- Revisa los archivos README de workflows
- Busca en GitHub issues
- Visita la [comunidad n8n](https://community.n8n.io/)
- Crea un GitHub issue

### Como reporto bugs?

Crea un GitHub issue con:

- Descripcion clara
- Pasos para reproducir
- Comportamiento esperado vs actual
- Detalles del entorno
- Logs y capturas de pantalla

### Puedo solicitar caracteristicas?

Si! Crea un GitHub issue con:

- Descripcion de la caracteristica
- Caso de uso
- Implementacion potencial
- Ejemplos

### Hay soporte comercial disponible?

Este es un proyecto comunitario. Para soporte comercial:

- Contrata expertos de n8n
- Contacta a los mantenedores del proyecto
- Considera n8n Cloud (oficial)

---

**No encontraste tu pregunta? Crea un issue en GitHub!**
