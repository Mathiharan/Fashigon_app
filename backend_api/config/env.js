require('dotenv').config();

function requireEnv(name) {
    const value = process.env[name];
    if (value === undefined || value === '') {
        console.error(`FATAL: Missing required environment variable: ${name}`);
        console.error('Copy backend_api/.env.example to backend_api/.env and fill in values.');
        process.exit(1);
    }
    return value;
}

module.exports = {
    port: parseInt(process.env.PORT || '3000', 10),
    mongodbUri: requireEnv('MONGODB_URI'),
    jwtSecret: requireEnv('JWT_SECRET'),
};
