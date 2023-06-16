const prisma = require("../prisma/client");

const getUsers = async (req, res) => {
  const email = req.query.email;
  const users = await prisma.user.findMany({
    where: { email },
    include: {
      LikedEvents: true,
      LikedNews: true,
      bills: true,
      creditCards: true,
    },
  });
  res.json(users);
};

// Function to handle liking an event by a user
async function likeEvent(req, res) {
  try {
    const { eventId, userId } = req.body;

    // Find the user and the event by their respective IDs
    const user = await User.findOne({ uid: userId });
    const event = await Events.findOne({ id: eventId });

    // Check if the user and event exist
    if (!user || !event) {
      return res.status(404).json({ message: "User or event not found" });
    }

    // Check if the user has already liked the event
    const isLiked = user.LikedEvents.some(
      (likedEvent) => likedEvent.id === eventId
    );
    if (isLiked) {
      return res
        .status(400)
        .json({ message: "User has already liked the event" });
    }

    // Add the event to the user's liked events
    user.LikedEvents.push(event);

    // Save the user
    await user.save();

    return res.status(200).json({ message: "Event liked successfully" });
  } catch (error) {
    console.error("Error liking event:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
}

// Function to handle user participation in an event
async function participateInEvent(req, res) {
  try {
    const { eventId, userId } = req.body;

    // Find the user and the event by their respective IDs
    const user = await User.findOne({ uid: userId });
    const event = await Events.findOne({ id: eventId });

    // Check if the user and event exist
    if (!user || !event) {
      return res.status(404).json({ message: "User or event not found" });
    }

    // Check if the user has already participated in the event
    const isParticipated = user.ParticipatedEvents.some(
      (participatedEvent) => participatedEvent.id === eventId
    );
    if (isParticipated) {
      return res
        .status(400)
        .json({ message: "User has already participated in the event" });
    }

    // Add the user to the event's participants
    event.Participants.push(user);

    // Save the event
    await event.save();

    return res
      .status(200)
      .json({ message: "User participated in the event successfully" });
  } catch (error) {
    console.error("Error participating in event:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
}
module.exports = { getUsers, likeEvent, participateInEvent };
