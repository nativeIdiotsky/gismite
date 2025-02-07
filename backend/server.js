



const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();


// Enhanced Proxy Middleware
const apiProxy = createProxyMiddleware({
  target: 'https://www.pagasa.dost.gov.ph',
  changeOrigin: true,
  secure: false, // Add this to handle HTTPS
  pathRewrite: {
    '^/api': '', // Removes the /api prefix
  },
  onProxyReq: (proxyReq, req, res) => {
    proxyReq.setHeader('User-Agent', 'My-Proxy-Server');
  },
  onError: (err, req, res) => {
    console.error('Proxy Error:', err);
    res.status(500).json({ error: 'Proxy server error.' });
  },
});

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

// Use the proxy for API routes
app.use('/api', apiProxy);

app.options('*', (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.sendStatus(200);
});
// Serve static files if you have a frontend
app.use(express.static('dist'));

// Start the server
const port = process.env.PORT || 2120;
app.listen(port, () => {
  console.log(`Proxy server listening on port ${port}`);
});

process.on('warning', (warning) => {
  if (warning.code === 'DEP0060') {
    return; // Ignore this specific warning
  }
  console.warn(warning.name, warning.message); // Show other warnings
});