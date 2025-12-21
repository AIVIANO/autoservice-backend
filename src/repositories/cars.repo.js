const { pool } = require("../db/pool");

async function createCar({ client_id, brand, model, plate_number, vin, year }) {
  const res = await pool.query(
    `INSERT INTO cars (client_id, brand, model, plate_number, vin, year)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING id, client_id, brand, model, plate_number, vin, year, created_at`,
    [client_id, brand, model, plate_number || null, vin || null, year || null]
  );
  return res.rows[0];
}

async function getCarById(id) {
  const res = await pool.query(
    `SELECT id, client_id, brand, model, plate_number, vin, year, created_at
     FROM cars
     WHERE id = $1 AND is_archived = FALSE`,
    [id]
  );
  return res.rows[0] || null;
}

async function listCars(client_id = null) {
  if (client_id) {
    const res = await pool.query(
      `SELECT id, client_id, brand, model, plate_number, vin, year, created_at
       FROM cars
       WHERE is_archived = FALSE AND client_id = $1
       ORDER BY id DESC`,
      [client_id]
    );
    return res.rows;
  }
  const res = await pool.query(
    `SELECT id, client_id, brand, model, plate_number, vin, year, created_at
     FROM cars
     WHERE is_archived = FALSE
     ORDER BY id DESC`
  );
  return res.rows;
}

module.exports = { createCar, getCarById, listCars };