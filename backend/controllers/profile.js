
const prisma = require("../prisma/client");


const updateUser = async (req, res) => {
    const { name, surname , address, Image } = req.body;
    const { userId } = req.params;
    try {
      // Update the user with the provided data
      const updatedUser = await prisma.user.update({
        where: {
          uid: userId,
        },
        data: {
          name: name,
          surname: surname,
          address: address,
          Image: Image,
        },
      });
  
      console.log("User updated:", updatedUser);
  
      res.status(200).json({ message: "User updated successfully" });
    } catch (error) {
      console.error("Error updating user:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  const getUserLikedItems = async (req, res) => {
    const { userId } = req.params;
    try {
      // Find the user by userId and include the liked events and news
      const user = await prisma.user.findUnique({
        where: { uid: userId },
        include: {
          LikedEvents: true,
          LikedNews: true,
        },
      });
  
      if (!user) {
        // User not found
        return res.status(404).json({ message: "User not found" });
      }
  
      // Extract the liked events and news from the user object
      const likedEvents = user.LikedEvents;
      const likedNews = user.LikedNews;
  
      res.status(200).json({ likedEvents, likedNews });
    } catch (error) {
      console.error("Error retrieving user liked items:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  module.exports = { updateUser , getUserLikedItems };