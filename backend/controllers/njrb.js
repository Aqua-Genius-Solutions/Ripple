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
        include: { participatns: true },
        // include: { LikedBy: { select: { uid: true } } },
      });

      const userParticipatedEvent = event.participants.find(
        (participatedByUser) => participatedByUser.uid === userId
      );
      if (userLikedEvent) {
  
      const updatedEventPar = await prisma.events.update({
        where: { id: eventId },
        data: { participants: { connect: { uid: userId.toString() } } },
      });
      console.log(updatedEventPar);
      const numParticipants = event.participants ? event.participants.length - 1 :0; 
      res.json({ message: "Event dis-participated successfully", numParticipants });
    } else {
        const updatedEventPar = await prisma.events.update({
            where: { id: eventId },
            data: { participants: { connect: { uid: userId.toString() } } },
          });
      
      const numParticipants =  event.participants ? event.participants.length - 1 :1; 
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