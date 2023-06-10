const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const bodyParser = require("body-parser");

const userRouter = require("./routes/route");
const eventRouter = require("./routes/events");
const newsRouter = require("./routes/newsRoute");
const authRouter = require("./routes/authRoute");
const paymentRouter = require("./routes/paymentRoute");
const billRouter = require ("./routes/bill")

const app = express();

app.use(bodyParser.json());
app.use(cors());
app.use(morgan("dev"));

app.use("/users", userRouter);
app.use("/events", eventRouter);
app.use("/news", newsRouter);
app.use("/auth", authRouter);
app.use("/payment", paymentRouter);
app.use("/stat", billRouter);


app.listen(3000, () => {
  console.log("Server is running on http://localhost:3000");
});
