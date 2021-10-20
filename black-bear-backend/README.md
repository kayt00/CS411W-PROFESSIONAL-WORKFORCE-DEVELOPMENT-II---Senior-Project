# Black Bear Home Guardian - Web Portal

### **Required Installations**
* [Node](https://nodejs.org/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)

### **Steps to run locally in development mode**
1. Start the database
    * `docker-compose up -d`
    * Wait 15-20 seconds
1. Start the backend server
    * `npm install`
    * `npm run migrate`
    * `npm start`
1. Navigate to `localhost:8000/api-docs` for Swagger documentation

### **Steps to clear and rebuild the database**
1. Stop server with `^C`, if necessary
1. `npm run clear-db`
1. `npm run migrate`

### **Alternative steps to clear and rebuild the database**
1. Stop server with `^C`, if necessary
1. Open terminal
1. Navigate to project root
1. `chmod +x resetDB.sh` ((Only needed once))
1. `./resetDB.sh`

### **Steps to configure email functionality**
When a new Black Bear user is added by an admin, and email with credentials shall be sent to the new user.
To enable this functionality:
1. Open .env file in project root
1. Change entry labeled MJ_SEND_INDICATOR to "true"

To disable this functionality
1. Open .env file in project root
1. Change entry labeled MJ_SEND_INDICATOR to "false"