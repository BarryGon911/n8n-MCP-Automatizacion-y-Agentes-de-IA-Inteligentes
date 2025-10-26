import express, { Request, Response } from 'express';
import { WebSocketServer } from 'ws';
import dotenv from 'dotenv';
import { MCPHandler } from './handler';
import { AgentOrchestrator } from '../agents/orchestrator';

dotenv.config();

const app = express();
const port = process.env.MCP_SERVER_PORT || 3000;

app.use(express.json());

// Initialize MCP Handler and Agent Orchestrator
const mcpHandler = new MCPHandler();
const agentOrchestrator = new AgentOrchestrator();

// Health check endpoint
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// MCP Protocol endpoints
app.post('/mcp/initialize', async (req: Request, res: Response) => {
  try {
    const { clientInfo, capabilities } = req.body;
    const response = await mcpHandler.initialize(clientInfo, capabilities);
    res.json(response);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

app.post('/mcp/tools/list', async (req: Request, res: Response) => {
  try {
    const tools = await mcpHandler.listTools();
    res.json({ tools });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

app.post('/mcp/tools/execute', async (req: Request, res: Response) => {
  try {
    const { name, parameters } = req.body;
    const result = await mcpHandler.executeTool(name, parameters);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

app.post('/mcp/resources/list', async (req: Request, res: Response) => {
  try {
    const resources = await mcpHandler.listResources();
    res.json({ resources });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

app.post('/mcp/resources/read', async (req: Request, res: Response) => {
  try {
    const { uri } = req.body;
    const content = await mcpHandler.readResource(uri);
    res.json(content);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

// Agent endpoints
app.post('/agents/execute', async (req: Request, res: Response) => {
  try {
    const { agentType, task, context } = req.body;
    const result = await agentOrchestrator.executeAgent(agentType, task, context);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

// Start HTTP server
const server = app.listen(port, () => {
  console.log(`MCP Server running on port ${port}`);
});

// WebSocket server for real-time communication
const wss = new WebSocketServer({ server });

wss.on('connection', (ws) => {
  console.log('New WebSocket connection established');

  ws.on('message', async (message) => {
    try {
      const data = JSON.parse(message.toString());
      const { method, params } = data;

      let response;
      switch (method) {
        case 'tools/list':
          response = await mcpHandler.listTools();
          break;
        case 'tools/execute':
          response = await mcpHandler.executeTool(params.name, params.parameters);
          break;
        case 'resources/list':
          response = await mcpHandler.listResources();
          break;
        case 'resources/read':
          response = await mcpHandler.readResource(params.uri);
          break;
        default:
          response = { error: 'Unknown method' };
      }

      ws.send(JSON.stringify({ id: data.id, result: response }));
    } catch (error) {
      ws.send(JSON.stringify({ error: (error as Error).message }));
    }
  });

  ws.on('close', () => {
    console.log('WebSocket connection closed');
  });
});

export default app;
