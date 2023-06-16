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
    const user = await prisma.user.findUnique({
      where: { uid: userId },
    });

    const event = await prisma.events.findFirst({
      where: { id: eventId },
      include: { LikedBy: true },
      // include: { LikedBy: { select: { uid: true } } },
    });

    console.log(event);

    const userLikedEvent = event.LikedBy.find(
      (likedByUser) => likedByUser.uid === userId
    );

    if (userLikedEvent) {
      const updatedEvent = await prisma.events.update({
        where: { id: eventId },
        data: { LikedBy: { disconnect: { uid: userId } } },
      });
      console.log(updatedEvent);
      const numLikes = event.LikedBy ? event.LikedBy.length - 1 : 0;
      res.json({ message: "Event disliked successfully", numLikes });
    } else {
      const updatedEvent = await prisma.events.update({
        where: { id: eventId },
        data: { LikedBy: { connect: { uid: userId } } },
      });
      console.log(updatedEvent);
      const numLikes = event.LikedBy ? event.LikedBy.length + 1 : 1;
      res.json({ message: "Event liked successfully", numLikes });
    }
  } catch (error) {
    console.error("An error occurred:", error);
    res
      .status(500)
      .json({ error: "An error occurred while liking/disliking the event" });
  }
}

async function participateInEvent(req, res) {
  const eventId = parseInt(req.params.eventId);
  const userId = req.params.userId;
  console.log(eventId, userId);
  try {
    const user = await prisma.user.findUnique({
      where: { uid: userId.toString() },
    });

    const event = await prisma.events.findFirst({
      where: { id: eventId },
      include: { participants: true },
    });

    const userParticipatedEvent = event.participants.find(
      (participatedByUser) => participatedByUser.uid === userId
    );

    if (userParticipatedEvent) {
      const updatedEventPar = await prisma.events.update({
        where: { id: eventId },
        data: { participants: { disconnect: { uid: userId.toString() } } },
      });
      console.log(updatedEventPar);
      const numParticipants = event.participants ? event.participants.length - 1 : 0;
      res.json({ message: "Event dis-participated successfully", numParticipants });
    } else {
      const updatedEventPar = await prisma.events.update({
        where: { id: eventId },
        data: { participants: { connect: { uid: userId.toString() } } },
      });
      console.log(updatedEventPar);
      const numParticipants = event.participants ? event.participants.length + 1 : 1;
      res.json({
        message: "Participated in event successfully",
        numParticipants,
      });
    }
  } catch (error) {
    console.error("An error occurred:", error);
    res
      .status(500)
      .json({ error: "An error occurred while participating in the event" });
  }
}


module.exports = { likeEvent, participateInEvent, getEvents };
