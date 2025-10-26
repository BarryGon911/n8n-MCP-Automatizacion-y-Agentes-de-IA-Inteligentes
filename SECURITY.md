# Security Policy

## Supported Versions

Currently, we support the latest version of this project. Security updates will be applied to the main branch.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability, please follow these steps:

### Do NOT
- Open a public issue
- Disclose the vulnerability publicly
- Exploit the vulnerability

### Do
1. **Email the maintainers** directly with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

2. **Wait for acknowledgment**
   - We will respond within 48 hours
   - We will work on a fix promptly
   - We will keep you updated on progress

3. **Coordinated disclosure**
   - We will coordinate with you on disclosure timeline
   - We will credit you in the security advisory (if desired)

## Security Best Practices

### For Users

1. **Environment Variables**
   - Never commit `.env` file
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
   - Run containers as non-root

5. **API Security**
   - Validate webhook signatures
   - Implement rate limiting
   - Use HTTPS for webhooks
   - Validate all inputs

### For Contributors

1. **Code Review**
   - Review for security issues
   - Check for hardcoded secrets
   - Validate input handling
   - Check dependency versions

2. **Dependencies**
   - Keep dependencies updated
   - Review dependency security
   - Use official sources only
   - Check for known vulnerabilities

3. **Secrets Management**
   - Never commit secrets
   - Use environment variables
   - Implement secret rotation
   - Use secret management tools

## Known Security Considerations

### API Keys
- Store in environment variables only
- Never expose in logs or error messages
- Implement key rotation
- Monitor for unauthorized usage

### Webhooks
- Implement signature verification
- Use HTTPS endpoints
- Validate payload structure
- Implement rate limiting

### Database
- Use strong passwords
- Restrict network access
- Implement regular backups
- Enable audit logging

### Docker
- Regular security updates
- Minimal base images
- Non-root users
- Resource limits

## Security Updates

We will:
- Monitor dependencies for vulnerabilities
- Apply security patches promptly
- Notify users of critical issues
- Provide upgrade instructions

## Compliance

This project handles:
- User conversations (potential PII)
- API credentials (sensitive data)
- Scraped content (copyright considerations)

Users are responsible for:
- Compliance with data protection laws (GDPR, CCPA, etc.)
- Proper handling of user data
- Obtaining necessary consents
- Implementing data retention policies

## Audit Logging

Consider implementing:
- Workflow execution logs
- API access logs
- Database query logs
- Authentication attempts
- Configuration changes

## Incident Response

In case of a security incident:

1. **Identify** the scope and impact
2. **Contain** the issue immediately
3. **Investigate** root cause
4. **Remediate** the vulnerability
5. **Communicate** with affected users
6. **Review** and improve processes

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [n8n Security Guide](https://docs.n8n.io/hosting/security/)
- [PostgreSQL Security](https://www.postgresql.org/docs/current/security.html)

## Contact

For security concerns, contact the maintainers through GitHub.

---

**Security is a shared responsibility. Thank you for helping keep this project secure!**
