const express = require('express');
const { createOrder, getAllOrders, assignDriver } = require('../controllers/orderController');

const router = express.Router();

router.post('/', createOrder);
router.get('/', getAllOrders);
router.put('/:id/assign', assignDriver);

module.exports = router;
