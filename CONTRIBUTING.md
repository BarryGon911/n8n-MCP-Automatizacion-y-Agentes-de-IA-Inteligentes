# Contributing to n8n Automation & AI Agents

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Environment details (OS, Docker version, etc.)

### Suggesting Features

Feature requests are welcome! Please include:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach
- Any relevant examples

### Contributing Code

1. **Fork the repository**
   ```bash
   git fork https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add documentation
   - Test your changes

4. **Commit your changes**
   ```bash
   git commit -m "Add feature: description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Describe your changes
   - Reference any related issues
   - Include screenshots if UI changes

### Contributing Workflows

To contribute a new workflow:

1. Create and test the workflow in n8n
2. Export as JSON
3. Add to `workflows/` directory
4. Document the workflow in `workflows/README.md`
5. Include:
   - Description
   - Required credentials
   - Use cases
   - Configuration steps
6. Submit a pull request

### Documentation

Documentation improvements are always welcome:
- Fix typos or unclear explanations
- Add examples
- Translate to other languages
- Improve installation guides
- Add troubleshooting tips

## Development Guidelines

### Code Style

- Use descriptive names for workflows and nodes
- Add comments for complex logic
- Follow n8n best practices
- Keep workflows modular and reusable

### Workflow Standards

- Test thoroughly before submitting
- Include error handling
- Document all credentials needed
- Provide example data
- Add execution notes

### Commit Messages

Use clear, descriptive commit messages:
- `feat: add new workflow for X`
- `fix: resolve issue with Y`
- `docs: update installation guide`
- `refactor: improve workflow Z`

### Testing

Before submitting:
- Test all workflows
- Verify credentials work
- Check error handling
- Test edge cases
- Ensure backward compatibility

## Project Structure

```
.
├── docker-compose.yml       # Docker services
├── .env.example            # Environment template
├── database/               # Database scripts
├── workflows/              # n8n workflows
├── credentials/            # Credential templates
├── scripts/                # Utility scripts
└── docs/                   # Documentation
```

## Getting Help

- Check existing documentation
- Search closed issues
- Ask in discussions
- Join n8n community

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the project

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in the project README.

Thank you for contributing! 🙏
