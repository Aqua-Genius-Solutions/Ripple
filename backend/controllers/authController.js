const prisma = require("../prisma/client");

const signup = async (req, res) => {
  const { name, surname, email, uid } = req.body;
  console.log(req.body);
  try {
    // Check if the user already exists
    const existingUser = await prisma.user.findFirst({
      where: {
        email: email,
      },
    });

    if (existingUser) {
      return res.status(409).json({ message: "User already exists" });
    }

    // Create the new user
    const newUser = await prisma.user.create({
      data: {
        uid: uid,
        name: name,
        surname: surname,
        email: email,
        address: "123 Main St",
        isPro: false,
        Referrals: [],
        Bubbles: 0,
        Image: "",
        Reference: 1,
        isAdmin: false,
        bills: { connect: [] },
        creditCards: { connect: [] },
        LikedEvents: { connect: [] },
        LikedNews: { connect: [] },
      },
    });

    console.log("New user created:", newUser);

    res.status(201).json({ message: "User created successfully" });
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const getUsers = async (req, res) => {
  try {
    const users = await prisma.user.findMany();
    res.status(200).json(users);
  } catch (error) {
    console.error("Error retrieving users:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const createProfile = async (req, res) => {
  const { uid } = req.params;
  const { address, nfm } = req.body;
  try {
    const user = await prisma.user.update({
      where: {
        uid: uid,
      },
      data: { address, NFM: nfm },
    });
  } catch (error) {
    console.error("Error creating profile:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

module.exports = { signup, getUsers, createProfile };
