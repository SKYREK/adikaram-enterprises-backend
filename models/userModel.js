import { query } from "../config/database.js";

export const findUserByEmail = async (email) => {
  const sql = "SELECT * FROM user WHERE email = ?";
  const users = await query(sql, [email]);
  return users[0];
};

export const getPrivilegesList = async (email) => {
  const sql = `SELECT rp.permission
    FROM user u
    JOIN role_permissions rp ON u.role_name = rp.role_name
    WHERE u.email = ?;
    `;
  const privileges = await query(sql, [email]);
  const privilegesList = privileges.map((privilege) => privilege.permission);
  return privilegesList;
};