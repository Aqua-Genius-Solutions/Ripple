const prisma = require("../prisma/client");

const getEvents = async (req, res) => {
  const events = await prisma.events.findMany({
    include: { LikedBy: true, participants: true },
  });
  res.json(events);
  console.log(events);
};

async function likeEvent(req, res) {
  const eventId = parseInt(req.params.eventId);
  const userId = req.params.userId;
  console.log(eventId, userId);

  try {
    // Retrieve the user object based on the userId
    const user = await prisma.user.findUnique({
      where: { uid: userId },
    });

    const updatedEvent = await prisma.events.update({
      where: { id: eventId },
      data: { LikedBy: { connect: { uid: userId } } },
    });
    console.log(updatedEvent);

    const event = await prisma.events.findFirst({
      where: { id: eventId },
      include: { LikedBy: true },
    });
    console.log(event.LikedBy);
    const numLikes = event.LikedBy.length;

    // user.LikedEvents.push(eventId);

    // Update the user in the database
    await prisma.user.update({
      where: { uid: userId },
      data: { LikedEvents: user.LikedEvents },
    });

    res.json({ message: "Event liked successfully", numLikes });
  } catch (error) {
    console.error("An error occurred:", error);
    res.status(500).json({ error: "An error occurred while liking the event" });
  }
}
async function participateInEvent(req, res) {
  const eventId = parseInt(req.params.eventId);
  const userId = parseInt(req.params.userId);
  console.log(eventId, userId);
  try {
    const user = await prisma.user.findFirst({
      where: { uid: userId.toString() },
    });

    const updatedEventPar = await prisma.events.update({
      where: { id: eventId },
      data: { participants: { push: userId } },
    });
    console.log(updatedEventPar);

    const event = await prisma.events.findUnique({
      where: { id: eventId },
    });
    console.log(event.participants);
    const numParticipants = event.participants.length;

    await prisma.user.update({
      where: { uid: userId.toString() },
      data: { participatedEvents: user.participatedEvents },
    });

    res.json({
      message: "Participated in event successfully",
      numParticipants,
    });
  } catch (error) {
    console.error("An error occurred:", error);
    res
      .status(500)
      .json({ error: "An error occurred while participating in the event" });
  }
}

module.exports = { likeEvent, participateInEvent, getEvents };
