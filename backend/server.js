const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const prisma = require("./prisma/client");

const userRouter = require("./routes/route");

const app = express();

app.use(express.json());
app.use(cors());
app.use(morgan("dev"));

app.use("/users", userRouter);

app.get("/add", async (req, res) => {
  await prisma.user.create({ data: { name: "test" } });
  res.send("User added");
});

app.get("/users", async (req, res) => {
  const users = await prisma.user.findMany();
  res.json(users);
});

app.listen(3000, () => {
  console.log("Server is running on http://localhost:3000");
});
