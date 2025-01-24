const express = require("express");
const axios = require("axios");
const app = express();

app.get("/api/flood-data", async (req, res) => {
  try {
    const url = "http://localhost:3000/api/flood-data";
    const response = await axios.get(url);
    res.send(response.data);
  } catch (error) {
    res.status(500).send("Error fetching data");
  }
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
