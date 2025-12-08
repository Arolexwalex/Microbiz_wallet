const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const token = req.headers['x-access-token'];
  console.log('<<< [Auth Middleware] Verifying token:', token ? token.substring(0, 30) + '...' : 'No token');

  if (!token) {
    return res.status(403).json({ message: 'No token provided.' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      console.log('<<< [Auth Middleware] Token verification failed:', err.message);
      return res.status(401).json({ message: 'Failed to authenticate token.' });
    }
    req.userId = decoded.id;
    next();
  });
};

module.exports = verifyToken;