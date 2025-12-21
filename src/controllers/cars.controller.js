const { AppError } = require("../errors/appError");
const { isNonEmptyString } = require("../utils/validators");
const carsRepo = require("../repositories/cars.repo");
const clientsRepo = require("../repositories/clients.repo");

async function createCar(req, res, next) {
  try {
    const { client_id, brand, model, plate_number, vin, year } = req.body;

    const cid = Number(client_id);
    if (!Number.isInteger(cid) || cid <= 0) {
      throw new AppError(400, "Validation error", { required: ["client_id"] });
    }
    if (!isNonEmptyString(brand) || !isNonEmptyString(model)) {
      throw new AppError(400, "Validation error", { required: ["brand", "model"] });
    }

    const client = await clientsRepo.getClientById(cid);
    if (!client) throw new AppError(404, "Client not found");

    const created = await carsRepo.createCar({
      client_id: cid,
      brand: brand.trim(),
      model: model.trim(),
      plate_number,
      vin,
      year: year === undefined ? null : Number(year)
    });

    return res.status(201).json(created);
  } catch (e) {
    return next(e);
  }
}

async function listCars(req, res, next) {
  try {
    const client_id = req.query.client_id ? Number(req.query.client_id) : null;
    const rows = await carsRepo.listCars(client_id && Number.isInteger(client_id) ? client_id : null);
    return res.json(rows);
  } catch (e) {
    return next(e);
  }
}

async function getCar(req, res, next) {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) throw new AppError(400, "Invalid id");

    const row = await carsRepo.getCarById(id);
    if (!row) throw new AppError(404, "Car not found");
    return res.json(row);
  } catch (e) {
    return next(e);
  }
}

module.exports = { createCar, listCars, getCar };