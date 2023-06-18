const prisma = require("../../prisma/client");

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

module.exports = {
  setAdminStatus,
  setProStatus,
};
