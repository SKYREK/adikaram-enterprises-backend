import express from 'express';
import { testConnection } from './config/database.js';

import bodyParser from 'body-parser';
import authRoutes from './routes/authRoutes.js';

const app = express();

testConnection();

app.use(bodyParser.json());
app.use('/api/auth', authRoutes);

app.listen(3000, () => {
    console.log('Server is running on port 3000');
    });
export default app;
