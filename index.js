import express from 'express';
import { testConnection } from './config/database.js';
import cors from 'cors';
import bodyParser from 'body-parser';
import authRoutes from './routes/authRoutes.js';
import { authenticateToken } from './middleware/authMiddleware.js';

const app = express();

testConnection();

app.use(cors());

app.use(bodyParser.json());

app.use(authenticateToken)

app.use('/api/auth', authRoutes);

app.listen(3000, () => {
    console.log('Server is running on port 3000');
    });
export default app;
