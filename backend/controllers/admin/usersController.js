const prisma = require("../../prisma/client");

async function getUsers(req, res) {
  try {
    const users = await prisma.user.findMany({
      include: { LikedEvents: true, News: true, Bill: true, CreditCard: true },
    });

    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: "error finding users", error });
  }
}

async function setAdminStatus(req, res) {
  try {
    const { id } = req.params;
    const { isAdmin } = req.body;

    const updatedUser = await prisma.user.update({
      where: { uid: id },
      data: { isAdmin },
    });

    res.json(updatedUser);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error updating user admin status", error });
  }
}

async function setProStatus(req, res) {
  try {
    const { id } = req.params;
    const { isPro } = req.body;

    const updatedUser = await prisma.user.update({
      where: { uid: id },
      data: { isPro },
    });

    res.json(updatedUser);
  } catch (error) {
    res.status(500).json({ message: "Error updating user pro status", error });
  }
}

async function manageProRequest(req, res) {
  const id = req.params.id;
  const state = req.body.state;
  try {
    if (state) {
      const updatedRequest = await prisma.request.update({
        where: { id },
        data: { status: "approved" },
      });
      await prisma.user.update({
        where: { uid: updatedRequest.userId },
        data: { isPro: true },
      });
    } else {
      await prisma.request.update({
        where: { id },
        data: { status: "rejected" },
      });
    }
    res.status(200).send("Request updated successfully");
  } catch (error) {
    res.status(500).json({ message: "", error });
  }
}

module.exports = {
  setAdminStatus,
  setProStatus,
  getUsers,
};
