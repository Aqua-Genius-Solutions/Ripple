const prisma = require("../prisma/client");

const getEvents = async (req, res) => {
  const events = await prisma.events.findMany();
  res.json(events);
  console.log(events);
};

module.exports = { getEvents };
