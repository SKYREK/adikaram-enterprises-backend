import { query } from '../config/database.js';

export const findUserByEmail = async (email) => {
    const sql = 'SELECT * FROM user WHERE email = ?';
    const users = await query(sql, [email]);
    console.log(users);
    return users[0];
};
