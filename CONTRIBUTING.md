# Contributing to n8n-MCP-Automation

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect differing viewpoints and experiences

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Node version, etc.)
   - Screenshots if applicable

### Suggesting Enhancements

1. Check if the enhancement has been suggested
2. Create a new issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes following our coding standards

4. Write or update tests as needed

5. Update documentation

6. Commit with clear messages:
   ```bash
   git commit -m "Add: Brief description of changes"
   ```

7. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

8. Create a Pull Request with:
   - Clear title and description
   - Link to related issues
   - Screenshots/videos for UI changes
   - Test results

## Development Setup

1. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```

2. Install dependencies:
```bash
npm install
```

3. Setup environment:
```bash
cp .env.example .env
# Edit .env with your settings
```

4. Start development environment:
```bash
docker-compose up -d
npm run build
npm run mcp-server
```

## Coding Standards

### TypeScript

- Use TypeScript for all new code
- Enable strict mode
- Properly type all functions and variables
- Avoid `any` type when possible

### Code Style

- Use 2 spaces for indentation
- Use semicolons
- Use single quotes for strings
- Maximum line length: 100 characters
- Use meaningful variable names

### Example:
```typescript
// Good
async function sendMessage(recipient: string, message: string): Promise<boolean> {
  try {
    const result = await whatsappService.send(recipient, message);
    return result.success;
  } catch (error) {
    console.error('Failed to send message:', error);
    return false;
  }
}

// Bad
async function send(r: any, m: any) {
  let res = await whatsappService.send(r, m)
  return res.success
}
```

### Naming Conventions

- **Files**: kebab-case (e.g., `whatsapp-service.ts`)
- **Classes**: PascalCase (e.g., `WhatsAppService`)
- **Functions**: camelCase (e.g., `sendMessage`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_RETRIES`)
- **Interfaces**: PascalCase with 'I' prefix optional (e.g., `AgentConfig`)

## Testing

### Running Tests

```bash
npm test
```

### Writing Tests

```typescript
import { WhatsAppService } from './whatsapp-service';

describe('WhatsAppService', () => {
  let service: WhatsAppService;

  beforeEach(() => {
    service = new WhatsAppService();
  });

  it('should send message successfully', async () => {
    const result = await service.sendMessage('+1234567890', 'Hello');
    expect(result.success).toBe(true);
  });

  it('should handle errors gracefully', async () => {
    const result = await service.sendMessage('invalid', 'Hello');
    expect(result.success).toBe(false);
  });
});
```

## Documentation

- Update README.md for major features
- Add JSDoc comments for public APIs
- Update API.md for API changes
- Add examples to EXAMPLES.md

### JSDoc Example:
```typescript
/**
 * Sends a WhatsApp message to a recipient
 * @param recipient - Phone number or group ID
 * @param message - Message text to send
 * @returns Promise with send result
 * @throws Error if client is not initialized
 */
async sendMessage(recipient: string, message: string): Promise<SendResult> {
  // Implementation
}
```

## Commit Message Guidelines

Use conventional commits format:

```
type(scope): subject

body

footer
```

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples:
```
feat(agents): add Gemini agent support

Implements Google Gemini integration for AI agents.
Includes chat and generation capabilities.

Closes #123
```

```
fix(whatsapp): resolve connection timeout issue

Increases timeout and adds retry logic for WhatsApp client
initialization.
```

## Review Process

1. Code review by at least one maintainer
2. All tests must pass
3. Documentation must be updated
4. No merge conflicts
5. Follows coding standards

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

- Open an issue for questions
- Join our community discussions
- Check existing documentation

Thank you for contributing! 🎉
