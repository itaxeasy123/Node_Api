# ITaxEasy API Backend Setup

This repository contains the backend API for the ITaxEasy platform built with Node.js and TypeScript.

## Prerequisites

- Git
- Node.js (see version requirements below)
- npm/yarn/pnpm

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/itax-easy/node-api.git
cd node-api
```

### 2. Special Node.js Version Requirements

This project requires specific Node.js version handling during installation:

1. **First, switch to Node.js 16.x** (required for initial dependency installation):
   ```bash
   # Using nvm (Node Version Manager)
   nvm install 16
   nvm use 16
   
   # Or install Node.js 16.x directly from nodejs.org
   ```

2. **Install dependencies using Node.js 16.x**:
   ```bash
   npm install
   ```

3. **Install Sharp library with optional dependencies**:
   ```bash
   npm install --include=optional sharp
   ```
   > **Important**: The Sharp library requires this specific installation command to ensure all necessary platform-specific dependencies are properly installed.

4. **After installation, switch back to your preferred Node.js version**:
   ```bash
   # Using nvm
   nvm use 18    # or your preferred version
   ```

### 3. Environment Setup

Create a `.env` file in the root directory and add the necessary environment variables:

```
PORT=8080
MONGO_URI=your_mongodb_connection_string
# Add other required environment variables
```

### 4. Running the Application

#### Development Mode

```bash
npm run dev
```

#### Production Mode

```bash
npm run build
npm start
```

## Todos
- [ ] Multiple Document Upload
- [ ] Mailing List
- [ ] Phone/Mobile Numbers List

## Download and Run
```bash
# Clone the repository
git clone https://github.com/itax-easy/node-api.git

# Change directory
cd node-api

# Install dependencies with Node.js 16
nvm use 16
npm install
npm install --include=optional sharp

# Run the application
npm run start
```

## Current Working APIs
All sandbox APIs before GSTR2 are currently functioning.

## Troubleshooting Common Issues

### Sharp Library Issues

If you encounter errors related to the Sharp library:

1. Ensure you've installed it with the optional dependencies:
   ```bash
   npm install --include=optional sharp
   ```

2. If issues persist, try platform-specific installation:
   ```bash
   npm install --os=linux --cpu=x64 sharp
   ```

3. Make sure system dependencies are installed:
   ```bash
   # On Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install -y build-essential libvips-dev
   ```

### Memory Issues

If the application crashes with "Killed" message:

1. Increase Node.js memory limit:
   ```bash
   export NODE_OPTIONS="--max-old-space-size=8192"
   ```

2. Check system resources and consider upgrading your server if needed.

## API Documentation

API documentation is available at `/api-docs` when running the server locally.

## Deployment

This project is hosted on Hostinger at [api.itaxeasy.com](https://api.itaxeasy.com).

## License

[Include your license information here]


## By Ankita Chauhan

SuperAdmin & Admin Authentication and Dashboard Fix – Technical Summary

This document summarizes all frontend and backend changes implemented to add Admin and SuperAdmin roles and to stabilize authentication, authorization, sidebar rendering, and dashboard data access across the application.

1. Root Problems Identified

The following issues were identified during analysis:

userType was undefined in frontend state after login

JWT payload key mismatch (Usertype vs userType)

Repeated 401 responses causing auto-logout loops

Multiple cookie names used for authentication tokens

Admin & SuperAdmin dashboard APIs failing with 401 / 403 errors

Sidebar rendering was not role-aware

2. Role System Enhancement (New)
Newly Implemented Roles

Admin

SuperAdmin

These roles were explicitly introduced and enforced across:

Database (Prisma enum alignment)

JWT payload

Backend middleware

Frontend role-based rendering

3. Files Updated (Complete List)
Frontend

src/hooks/useAuth.js

src/app/dashboard/layout.jsx

src/app/dashboard/superadmin/page.jsx

src/lib/userbackAxios.js

Backend

src/services/token.service.ts

src/middleware/verifyToken.ts

src/middleware/Admin.middleware.ts

src/middleware/Superadmin.middleware.ts

src/controllers/UserController.ts

4. Key Fixes Implemented
Authentication & Token Handling

JWT is now the single source of truth for userType

Authentication cookie standardized to authToken

Token decoding always injects userType into currentUser

Axios interceptor safely handles 401 responses without logout loops

Role-Based Rendering

Sidebar and dashboard render dynamically based on decoded userType

Admin and SuperAdmin views are fully isolated and protected

5. Backend Authentication & Authorization Fixes
UserController Enhancements

User login response now includes role (userType)

JWT payload structure aligned with Prisma UserType enum

Role assignment validated at login time

Middleware Improvements

verifyToken middleware:

Supports legacy tokens safely

Normalizes userType extraction

Admin.middleware:

Allows access only if userType === 'admin'

Superadmin.middleware:

Allows access only if userType === 'superadmin'

Blocks Admin and normal users from SuperAdmin APIs

6. Security & Stability Improvements

Eliminated token mismatch and role desync issues

Prevented unnecessary auto-logout caused by expired/invalid API calls

Clean separation of concerns between:

Authentication

Authorization

Role-based access control

7. Final Outcome

✅ Admin and SuperAdmin roles fully implemented

✅ SuperAdmin login is stable (no auto-logout)

✅ Admin & SuperAdmin dashboard APIs work correctly

✅ Sidebar renders correctly for all roles

✅ Secure, clean, and maintainable authentication flow

✅ Frontend and backend are fully role-synchronized

