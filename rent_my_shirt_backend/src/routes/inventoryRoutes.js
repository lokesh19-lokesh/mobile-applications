const express = require('express');
const { getAllShirts, addShirt, updateShirtStatus } = require('../controllers/inventoryController');

const router = express.Router();

router.get('/', getAllShirts);
router.post('/', addShirt);
router.put('/:id/status', updateShirtStatus);

module.exports = router;
