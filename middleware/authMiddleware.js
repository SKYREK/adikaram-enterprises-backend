import { verifyToken } from '../utils/tokenManager.js';

export const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];

    if (!token) {
        return res.status(403).send('A token is required for authentication.');
    }

    try {
        const decoded = verifyToken(token);
        req.user = decoded;
    } catch (error) {
        return res.status(401).send('Invalid Token');
    }
    next();
};
