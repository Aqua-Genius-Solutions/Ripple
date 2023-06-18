const prisma = require("../prisma/client");

async function authorize(req, res, next) {
  const userId = req.body.userId;
  const user = await prisma.user.findUnique({
    where: {
      uid: userId,
    },
  });

  if (user && user.isAdmin) {
    next();
  } else {
    res.status(403).json({ error: "Not authorized" });
  }
}

module.exports = authorize;
