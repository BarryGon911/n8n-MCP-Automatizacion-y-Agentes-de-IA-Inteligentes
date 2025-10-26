# Política de Seguridad

## Versiones Soportadas

Actualmente, soportamos la última versión de este proyecto. Las actualizaciones de seguridad se aplicarán a la rama principal.

| Versión | Soportada          |
| ------- | ------------------ |
| Última  | :white_check_mark: |
| < 1.0   | :x:                |

## Reportar una Vulnerabilidad

Si descubres una vulnerabilidad de seguridad, por favor sigue estos pasos:

### NO

- Abras un issue público
- Divulgues la vulnerabilidad públicamente
- Explotes la vulnerabilidad

### SÍ

1. **Envía un email a los mantenedores** directamente con:

   - Descripción de la vulnerabilidad
   - Pasos para reproducirla
   - Impacto potencial
   - Solución sugerida (si tienes alguna)

2. **Espera reconocimiento**

   - Responderemos dentro de 48 horas
   - Trabajaremos en una corrección de inmediato
   - Te mantendremos actualizado sobre el progreso

3. **Divulgación coordinada**

   - Coordinaremos contigo la línea de tiempo de divulgación
   - Te acreditaremos en el aviso de seguridad (si lo deseas)

## Mejores Prácticas de Seguridad

### Para Usuarios

1. **Variables de Entorno**

   - Nunca hagas commit del archivo `.env`
   - Usa contraseñas fuertes
   - Rota las claves API regularmente
   - Restringe los permisos de las claves API

2. **Seguridad de Red**

   - Usa HTTPS en producción
   - Implementa reglas de firewall
   - Restringe el acceso a la base de datos
   - Usa VPN para acceso remoto

3. **Control de Acceso**

   - Cambia las credenciales por defecto
   - Usa autenticación fuerte
   - Implementa limitación de tasa
   - Monitorea los registros de acceso

4. **Seguridad en Docker**

   - Mantén las imágenes actualizadas
   - Usa etiquetas de versión específicas
   - Escanea imágenes en busca de vulnerabilidades
   - Ejecuta contenedores como no-root

5. **Seguridad de API**

   - Valida las firmas de webhooks
   - Implementa limitación de tasa
   - Usa HTTPS para webhooks
   - Valida todas las entradas

### Para Contribuidores

1. **Revisión de Código**

   - Revisa en busca de problemas de seguridad

## Security Best Practices

### For Users

1. **Environment Variables**

   - Nunca hagas commit del archivo `.env`
   - Use strong passwords
   - Rotate API keys regularly
   - Restrict API key permissions

2. **Network Security**

   - Use HTTPS in production
   - Implement firewall rules
   - Restrict database access
   - Use VPN for remote access

3. **Access Control**

   - Change default credentials
   - Use strong authentication
   - Implement rate limiting
   - Monitor access logs

4. **Docker Security**

   - Keep images updated
   - Use specific version tags
   - Scan images for vulnerabilities
   - Ejecuta contenedores como no-root

5. **API Security**

   - Validate webhook signatures
   - Implement rate limiting
   - Use HTTPS for webhooks
   - Validate all inputs

### For Contributors

1. **Revisión de Código**

   - Revisa en busca de problemas de seguridad
   - Verifica secretos codificados
   - Valida el manejo de entradas
   - Verifica versiones de dependencias

2. **Dependencias**

   - Mantén las dependencias actualizadas
   - Revisa la seguridad de dependencias
   - Usa solo fuentes oficiales
   - Verifica vulnerabilidades conocidas

3. **Gestión de Secretos**

   - Nunca hagas commit de secretos
   - Usa variables de entorno
   - Implementa rotación de secretos
   - Usa herramientas de gestión de secretos

## Consideraciones de Seguridad Conocidas

### Claves API

- Almacenar solo en variables de entorno
- Nunca exponerlas en logs o mensajes de error
- Implementar rotación de claves
- Monitorear uso no autorizado

### Webhooks

- Implementar verificación de firma
- Usar endpoints HTTPS
- Validar estructura del payload
- Implementar limitación de tasa

### Base de Datos

- Usar contraseñas fuertes
- Restringir acceso de red
- Implementar respaldos regulares
- Habilitar registro de auditoría

### Docker

- Actualizaciones de seguridad regulares
- Imágenes base mínimas
- Usuarios no-root
- Límites de recursos

## Actualizaciones de Seguridad

Nosotros:

- Monitoreamos dependencias en busca de vulnerabilidades
- Aplicamos parches de seguridad de inmediato
- Notificamos a los usuarios sobre problemas críticos
- Proporcionamos instrucciones de actualización

## Cumplimiento

Este proyecto maneja:

- Conversaciones de usuarios (potencial PII - Información Personal Identificable)
- Credenciales API (datos sensibles)
- Contenido scrapeado (consideraciones de derechos de autor)

Los usuarios son responsables de:

- Cumplimiento con leyes de protección de datos (GDPR, CCPA, etc.)
- Manejo apropiado de datos de usuarios
- Obtención de consentimientos necesarios

## Consideraciones de Seguridad Conocidas

### Claves API

- Almacenar solo en variables de entorno
- Nunca exponer en logs o mensajes de error
- Implementar rotación de claves
- Monitorear uso no autorizado

### Webhooks

- Implementar verificación de firma
- Usar endpoints HTTPS
- Validar estructura de payload
- Implementar limitación de tasa

### Base de Datos

- Usar contraseñas fuertes
- Restringir acceso de red
- Implementar respaldos regulares
- Habilitar registro de auditoría

### Docker

- Actualizaciones de seguridad regulares
- Imágenes base mínimas
- Usuarios no root
- Límites de recursos

## Actualizaciones de Seguridad

Nosotros:

- Monitoreamos dependencias para vulnerabilidades
- Aplicamos parches de seguridad prontamente
- Notificamos a los usuarios sobre problemas críticos
- Proporcionamos instrucciones de actualización

## Cumplimiento

Este proyecto maneja:

- Conversaciones de usuarios (potencial PII)
- Credenciales API (datos sensibles)
- Contenido scrapeado (consideraciones de copyright)

Los usuarios son responsables de:

- Cumplimiento con leyes de protección de datos (GDPR, CCPA, etc.)
- Manejo apropiado de datos de usuario
- Obtención de consentimientos necesarios
- Implementación de políticas de retención de datos

## Registro de Auditoría

Considera implementar:

- Logs de ejecución de workflows
- Logs de acceso API
- Logs de consultas de base de datos
- Intentos de autenticación
- Cambios de configuración

## Respuesta a Incidentes

En caso de un incidente de seguridad:

1. **Identificar** el alcance e impacto
2. **Contener** el problema inmediatamente
3. **Investigar** la causa raíz
4. **Remediar** la vulnerabilidad
5. **Comunicar** con usuarios afectados
6. **Revisar** y mejorar procesos

## Recursos

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Mejores Prácticas de Seguridad Docker](https://docs.docker.com/engine/security/)
- [Guía de Seguridad n8n](https://docs.n8n.io/hosting/security/)
- [Seguridad PostgreSQL](https://www.postgresql.org/docs/current/security.html)

## Contacto

Para preocupaciones de seguridad, contacta a los mantenedores a través de GitHub.

---

**La seguridad es una responsabilidad compartida. ¡Gracias por ayudar a mantener este proyecto seguro!**
