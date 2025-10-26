# Contribuir a n8n Automatización y Agentes de IA

¡Gracias por tu interés en contribuir! Este documento proporciona pautas para contribuir a este proyecto.

## Cómo Contribuir

### Reportar Errores

Si encuentras un error, por favor crea un issue con:

- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado
- Comportamiento actual
- Capturas de pantalla si aplica
- Detalles del entorno (SO, versión de Docker, etc.)

### Sugerir Funciones

¡Las solicitudes de funciones son bienvenidas! Por favor incluye:

- Descripción clara de la función
- Caso de uso y beneficios
- Posible enfoque de implementación
- Ejemplos relevantes

### Contribuir Código

1. **Haz fork del repositorio**

```bash
git fork https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git

```

2. **Crea una rama de funcionalidad**

```bash
git checkout -b feature/nombre-de-tu-funcion

```

3. **Realiza tus cambios**

   - Sigue el estilo de código existente
   - Agrega documentación
   - Prueba tus cambios

4. **Haz commit de tus cambios**

```bash
git commit -m "Agregar función: descripción"

```

5. **Push a tu fork**

```bash
git push origin feature/nombre-de-tu-funcion

```

6. **Crea un Pull Request**

   - Describe tus cambios
   - Referencia cualquier issue relacionado
   - Incluye capturas de pantalla si hay cambios en la UI

### Contribuir Workflows

Para contribuir un nuevo workflow:

1. Crea y prueba el workflow en n8n
2. Exporta como JSON
3. Agrégalo al directorio `workflows/`
4. Documenta el workflow en `workflows/README.md`
5. Incluye:

   - Descripción
   - Credenciales requeridas
   - Casos de uso
   - Pasos de configuración

6. Envía un pull request

### Documentación

Mejoras en la documentación siempre son bienvenidas:

- Corregir errores tipográficos o explicaciones poco claras
- Agregar ejemplos
- Traducir a otros idiomas
- Mejorar guías de instalación
- Agregar consejos de solución de problemas

## Pautas de Desarrollo

### Estilo de Código

- Usa nombres descriptivos para workflows y nodos
- Agrega comentarios para lógica compleja
- Sigue las mejores prácticas de n8n
- Mantén los workflows modulares y reutilizables

### Estándares de Workflow

- Prueba exhaustivamente antes de enviar
- Incluye manejo de errores
- Documenta todas las credenciales necesarias
- Proporciona datos de ejemplo
- Agrega notas de ejecución

### Mensajes de Commit

Usa mensajes de commit claros y descriptivos:

- `feat: agregar nuevo workflow para X`
- `fix: resolver problema con Y`
- `docs: actualizar guía de instalación`
- `refactor: mejorar workflow Z`

### Pruebas

Antes de enviar:

- Prueba todos los workflows
- Verifica que las credenciales funcionen
- Verifica el manejo de errores
- Prueba casos extremos
- Asegura compatibilidad hacia atrás

## Estructura del Proyecto

```ini
.
├── docker-compose.yml       # Servicios Docker
├── .env.example            # Plantilla de entorno
├── database/               # Scripts de base de datos
├── workflows/              # Workflows de n8n
├── credentials/            # Plantillas de credenciales
├── scripts/                # Scripts de utilidad
└── docs/                   # Documentación

```

## Obtener Ayuda

- Consulta la documentación existente
- Busca en issues cerrados
- Pregunta en discusiones
- Únete a la comunidad de n8n

## Código de Conducta

- Sé respetuoso e inclusivo
- Da la bienvenida a los nuevos
- Acepta críticas constructivas
- Enfócate en lo mejor para el proyecto

## Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la Licencia MIT.

## Reconocimiento

Los contribuidores serán reconocidos en el README del proyecto.

¡Gracias por contribuir! 🙏
