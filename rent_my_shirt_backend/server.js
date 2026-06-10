const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { router: authRoutes } = require('./routes/auth');
const userRoutes = require('./routes/users');
const shirtRoutes = require('./routes/shirts');
const orderRoutes = require('./routes/orders');

const app = express();
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/shirts', shirtRoutes);
app.use('/api/v1/orders', orderRoutes);
app.use('/api/v1/cart', orderRoutes); // Handled in orders router for simplicity

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
