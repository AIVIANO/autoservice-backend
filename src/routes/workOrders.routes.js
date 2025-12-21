const { Router } = require("express");
const c = require("../controllers/workOrders.controller");

const router = Router();

router.post("/work-orders", c.createWorkOrder);
router.get("/work-orders/:id", c.getWorkOrder);
router.get("/work-orders/:id/full", c.getWorkOrderFull);
router.patch("/work-orders/:id/status", c.patchWorkOrderStatus);

router.post("/work-orders/:id/work-items", c.addWorkItem);
router.post("/work-orders/:id/material-items", c.addMaterialItem);
router.post("/work-orders/:id/payments", c.addPayment);

module.exports = router;