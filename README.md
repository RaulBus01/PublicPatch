# PublicPatch
### API Endpoints

This document describes the available controllers and their endpoints.

---

### UserController

Manages user-related actions such as creating, updating, deleting, and retrieving user data.

| Endpoint            | HTTP Method | Description                   |
|---------------------|-------------|-------------------------------|
| `/user/create`      | POST        | Creates a new user profile    |
| `/user/update`      | PUT         | Updates an existing user profile |
| `/user/delete`      | DELETE      | Deletes an existing user profile |
| `/user/get`         | GET         | Retrieves user profile data   |

---

### ReportController

Handles report management, including creating, updating, deleting, and retrieving reports for users and admins.

| Endpoint               | HTTP Method | Description                                    |
|------------------------|-------------|------------------------------------------------|
| `/report/create`       | POST        | Creates a new report                           |
| `/report/update`       | PUT         | Updates an existing report                     |
| `/report/delete`       | DELETE      | Deletes an existing report                     |
| `/report/getUserReports` | GET       | Retrieves all reports for a specific user      |
| `/report/getAllReports` | GET        | Retrieves all reports for all users (admin)    |
| `/report/getReport`    | GET         | Retrieves a specific report by ID              |
| `/report/getReportRange` | GET       | Retrieves reports within a specific range      |

---

### SettingsController

Manages user settings, such as display language and push notification preferences.

| Endpoint                     | HTTP Method | Description                                         |
|------------------------------|-------------|-----------------------------------------------------|
| `/settings/readDisplayLanguage` | GET       | Reads the current display language setting          |
| `/settings/changeDisplayLanguage` | PUT     | Changes the display language setting                |
| `/settings/readPushNotification` | GET      | Reads the push notification preference              |
| `/settings/changePushNotification` | PUT    | Updates the push notification preference            |

---

### ConfigController

Allows creation, updating, deletion, and reading of configurable categories in the app.

| Endpoint                  | HTTP Method | Description                    |
|---------------------------|-------------|--------------------------------|
| `/config/createCategory`  | POST        | Creates a new category         |
| `/config/updateCategory`  | PUT         | Updates an existing category   |
| `/config/deleteCategory`  | DELETE      | Deletes an existing category   |
| `/config/readCategory`    | GET         | Retrieves all categories       |
