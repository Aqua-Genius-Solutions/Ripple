const prisma = require("../../prisma/client");

async function getEvents(req, res) {
  try {
    const events = await prisma.events.findMany({
      include: { LikedBy: true, participants: true },
    });
    res.json(events);
  } catch (error) {
    res.status(500).json({ message: "Error fetching events", error });
  }
}

async function createEvent(req, res) {
  try {
    const newEvent = req.body;
    const createdEvent = await prisma.events.create({ data: newEvent });
    res.json(createdEvent);
  } catch (error) {
    res.status(500).json({ message: "Error creating event", error });
  }
}

async function updateEvent(req, res) {
  try {
    const { id } = req.params;
    const updates = req.body;
    const updatedEvent = await prisma.events.update({
      where: { id: Number(id) },
      data: updates,
    });
    res.json(updatedEvent);
  } catch (error) {
    res.status(500).json({ message: "Error updating event", error });
  }
}

async function deleteEvent(req, res) {
  try {
    const { id } = req.params;
    const deletedEvent = await prisma.events.delete({
      where: { id: Number(id) },
    });
    res.json(deletedEvent);
  } catch (error) {
    res.status(500).json({ message: "Error deleting event", error });
  }
}

module.exports = {
  getEvents,
  createEvent,
  updateEvent,
  deleteEvent,
};
