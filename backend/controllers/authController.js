const prisma = require("../prisma/client");

const getUsers = async (req, res) => {
  try {
    const users = await prisma.user.findMany();
    res.status(200).json(users);
  } catch (error) {
    console.error("Error retrieving users:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const getOne = async (req, res) => {
  const uid = req.params.uid;
  try {
    const users = await prisma.user.findFirst({ where: { uid } });
    res.status(200).json(users);
  } catch (error) {
    console.error("Error retrieving users:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

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
        NFM: 0,
        NormalConsp: 0,
        address: "",
        isPro: false,
        Referrals: [],
        Bubbles: 0,
        Image: "",
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

const createProfile = async (req, res) => {
  const { uid } = req.params;
  const { address, NFM, profilePicURL } = req.body;
  const NormalConsp = NFM * 9;
  try {
    const user = await prisma.user.update({
      where: {
        uid: uid,
      },
      data: { address, NFM, Image: profilePicURL, NormalConsp },
    });

    res.status(200).json({ message: "User profile created", user });
  } catch (error) {
    console.error("Error creating profile:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

async function getAdminUser(req, res) {
  try {
    const adminUser = await prisma.user.findMany({
      where: {
        isAdmin: true
      }
    });

    res.status(200).json(adminUser);
  } catch (error) {
    console.error('Error retrieving admin user:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    await prisma.$disconnect();
  }
}

async function getProUser(req, res) {
  try {
    const proUser = await prisma.user.findMany({
      where: {
        isPro: true
      }
    });

    res.status(200).json(proUser);
  } catch (error) {
    console.error('Error retrieving Pro user:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    await prisma.$disconnect();
  }
}



module.exports = { signup, getUsers, createProfile,  getAdminUser , getProUser, getOne};
