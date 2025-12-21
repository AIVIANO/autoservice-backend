const { Router } = require("express");
const c = require("../controllers/cars.controller");

const router = Router();

router.post("/cars", c.createCar);
router.get("/cars", c.listCars);
router.get("/cars/:id", c.getCar);

module.exports = router;