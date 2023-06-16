const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const prisma = require("./prisma/client");

const userRouter = require("./routes/route");
const eventRouter = require("./routes/events");
const newsRouter = require("./routes/newsRoute");
const authRouter = require("./routes/authRoute");
const paymentRouter = require("./routes/paymentRoute");
const rewardRouter = require("./routes/rewardRoute");
const billRouter = require ("./routes/bill")
const profileRouter = require("./routes/profileRoute");
const leaderboardRouter = require ("./routes/leaderboardRoute");

const app = express();

app.use(bodyParser.json());
app.use(cors());
app.use(morgan("dev"));

app.use("/users", userRouter);
app.use("/events", eventRouter);
app.use("/news", newsRouter);
app.use("/auth", authRouter);
app.use("/payment", paymentRouter);
app.use("/rewards", rewardRouter);
app.use("/stat", billRouter);
app.use("/leaderboard", leaderboardRouter)
app.use("/profile", profileRouter);

app.put("/:uid", async (req, res) => {
  const uid = req.params.uid;
  try {
    await prisma.user.update({ where: { uid }, data: { isPro: true } });
    res.json(await prisma.user.findFirst({ where: { uid } }));
  } catch (error) {
    res.json(error);
  }
});

app.listen(3000, () => {
  console.log("Server is running on http://localhost:3000");
});
