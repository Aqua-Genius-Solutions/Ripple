
const prisma = require("../prisma/client");


const updateUser = async (req, res) => {
    const { name, surname, email , address, Image } = req.body;
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
          email: email,
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

  module.exports = { updateUser };