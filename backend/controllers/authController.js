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
    const users = await prisma.user.findFirst({
      where: { uid },
      include: {
        LikedEvents: true,
        News: true,
        Bill: true,
        CreditCard: true,
      },
    });
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
        Bubbles: 10,
        Image: "",
        isAdmin: false,
        Bill: { connect: [] },
        CreditCard: { connect: [] },
        LikedEvents: { connect: [] },
        News: { connect: [] },
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
        isAdmin: true,
      },
    });

    res.status(200).json(adminUser);
  } catch (error) {
    console.error("Error retrieving admin user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  } finally {
    await prisma.$disconnect();
  }
}

async function getProUser(req, res) {
  try {
    const proUser = await prisma.user.findMany({
      where: {
        isPro: true,
      },
    });

    res.status(200).json(proUser);
  } catch (error) {
    console.error("Error retrieving Pro user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  } finally {
    await prisma.$disconnect();
  }
}

async function getImage(req, res) {
  const uid = req.params.uid;

  try {
    const user = await prisma.user.findUnique({
      where: { uid },
      select: { Image: true },
    });

    if (user) {
      res.json({ image: user.Image });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
}

async function createNewRequest(req, res) {
  const uid = req.params.uid;
  const desc = req.body.desc;
  try {
    await prisma.request.create({
      userId: uid,
      status: "pending",
      desc,
    });
  } catch (error) {
    res.status(500).json({ message: "error creating request", error });
  }
}

async function getLeaderboard(req, res) {
  try {
    const users = await prisma.user.findMany({
      orderBy: [
        {
          Bubbles: "desc",
        },
      ],
      select: {
        name: true,
        surname: true,
        Bubbles: true,
        Image: true,
      },
    });

    res.status(200).json({
      status: "success",
      data: users,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "An error occurred while fetching the leaderboard data.",
    });
  }
}

async function getRequests(req, res) {
  try {
    const requests = await prisma.request.findMany();

    res.status(200).json(requests);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "An error occurred while fetching the requests.",
    });
  }
}

module.exports = {
  signup,
  getUsers,
  createProfile,
  getAdminUser,
  getProUser,
  getOne,
  getImage,
  createNewRequest,
  getLeaderboard,
  getRequests,
};
