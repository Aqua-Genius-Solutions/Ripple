const prisma = require("../prisma/client");

const getEvents = async (req, res) => {
  const events = await prisma.events.findMany({
    orderBy:{
      date :'asc'
      },
      take:3
  });
  res.json(events);
};

module.exports = { getEvents };
