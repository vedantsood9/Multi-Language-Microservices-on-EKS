const express = require('express');
const app = express();

app.get('/products', (req, res) => {
    res.json({ products: ["Book", "pen", "Marker"] });
});

app.listen(5001, () => {
    console.log("Product service is running on port 5001");
});

