const express = require('express');
const client = require('prom-client');

const app = express();
const port = process.env.PORT || 3000;

client.collectDefaultMetrics({ prefix: 'devops_lab_' });
const httpRequests = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status']
});

app.use((req, res, next) => {
  res.on('finish', () =>
    httpRequests.inc({ method: req.method, route: req.path, status: res.statusCode })
  );
  next();
});

app.get('/', (req, res) =>
  res.send('<h1>DevOps Lab - Muneeb</h1><p>Hello from Node.js running in Docker / K8s!</p>')
);
app.get('/health', (req, res) => res.json({ status: 'ok', uptime: process.uptime() }));
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(port, '0.0.0.0', () => console.log('App running on port ' + port));
// dev branch experiment
