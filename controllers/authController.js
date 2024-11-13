import bcrypt from 'bcryptjs';
import { findUserByEmail } from '../models/userModel.js';
import { generateToken } from '../utils/tokenManager.js';

export const loginUser = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).send('Email and password are required.');
    }

    try {
        const user = await findUserByEmail(email);
        if (!user) {
            return res.status(401).send('User not found.');
        }
        // Generate hash
        
        

        const passwordIsValid = await bcrypt.compare(password, user.password_hash);
        if (!passwordIsValid) {
            return res.status(401).send('Authentication failed.');
        }
        



        const token = generateToken({ id: user.email, role: user.role_name });
        res.json({ auth: true, token });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).send('There was a problem logging in.');
    }
};
