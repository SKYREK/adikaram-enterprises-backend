import { verifyToken } from '../utils/tokenManager.js';

export const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];
    
    try {
        if (token) {            
            const decoded = verifyToken(token);
            req.user = decoded;
        }
    } catch (error) {
        return res.status(401).json({ error: 'Unauthorized' , description : "You are trying with expired or invalid login. Please try login again." });
    }
    next();
};
