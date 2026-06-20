const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve the static files from the Flutter web build directory
app.use(express.static(path.join(__dirname, 'build/web')));

// Catch-all route for SPA using Regex
app.get(/.*/, (req, res) => {
    res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});
