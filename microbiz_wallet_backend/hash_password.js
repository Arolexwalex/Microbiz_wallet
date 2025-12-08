const bcrypt = require('bcryptjs');

const plainPassword = 'password123';
const saltRounds = 10; // This should match the salt rounds used in your registration logic

bcrypt.hash(plainPassword, saltRounds, (err, hash) => {
  if (err) {
    console.error('Error hashing password:', err);
    return;
  }
  console.log('Plain Password:', plainPassword);
  console.log('\n✅ Hashed Password generated successfully.');
  console.log('\n--- RUN THIS SQL COMMAND TO FIX THE DEMO USER ---');
  console.log(`UPDATE users SET password = '${hash}' WHERE username = 'demo_user';`);
});
