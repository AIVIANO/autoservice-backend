const { Router } = require("express");
const c = require("../controllers/clients.controller");

const router = Router();

router.post("/clients", c.createClient);
router.get("/clients", c.listClients);
router.get("/clients/:id", c.getClient);

module.exports = router;