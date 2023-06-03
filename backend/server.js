const express = require("express");
const cors = require("cors");
const morgan = require("morgan");

const userRouter = require("./routes/route");
const newsRouter = require("./routes/newsRoute");

const app = express();

app.use(express.json());
app.use(cors());
app.use(morgan("dev"));

app.use("/users", userRouter);
app.listen(3000, () => {
  console.log("Server is running on http://localhost:3000");
});
