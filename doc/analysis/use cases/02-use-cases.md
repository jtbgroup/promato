# Promato — Use Cases

## UC-01: Login
**Actor:** Any user  
**Precondition:** User has an account in DB  
**Flow:**
1. User navigates to /login
2. Enters username + password
3. System validates credentials
4. System creates session, redirects to dashboard
**Alternate:** Invalid credentials → error message, no session created

---

## UC-02: Manage Users (ADMIN)
**Actor:** ADMIN  
**Flow:**
1. Admin navigates to User Management
2. Can create / edit / deactivate users
3. Can assign system role (ADMIN, PROJECT_MANAGER, MEMBER, READER)

---

## UC-03: Create Project
**Actor:** ADMIN, PROJECT_MANAGER  
**Flow:**
1. User clicks "New Project"
2. Fills: name, code (unique), description, start date, planned end date, budget
3. System saves project, creator becomes PROJECT_MANAGER on it
4. User can invite other users and assign them project roles

---

## UC-04: Build PBS
**Actor:** PROJECT_MANAGER, MEMBER  
**Precondition:** Project exists  
**Flow:**
1. User opens project PBS view
2. Adds root node (level 0)
3. Adds child nodes recursively (unlimited depth)
4. Each node: code, title, description, node type, estimated effort, status, assignees
5. Can reorder nodes via drag-and-drop
6. Can toggle between tree view and flat list view

---

## UC-05: Log Time
**Actor:** MEMBER, PROJECT_MANAGER  
**Precondition:** PBS node exists and user is assigned to project  
**Flow:**
1. User opens Timesheet (weekly view or quick-log)
2. Selects PBS node, enters date, duration (hours), optional comment
3. System saves time entry linked to user and node
4. Totals are updated in PBS node and project dashboard

---

## UC-06: View Project Dashboard
**Actor:** All project members  
**Flow:**
1. User selects a project
2. Sees: PBS summary, total planned vs actual effort, timeline, last activity

---

## UC-07: Create User Journey
**Actor:** PROJECT_MANAGER  
**Precondition:** Project exists  
**Flow:**
1. User creates a new User Journey scenario with title and description
2. Adds steps: step number, actor, action, system response, expected result
3. Optionally links each step to a PBS node (for progress overlay)
4. Can enable "show progress" toggle to display % completion per step

---

## UC-08: Generate HLR
**Actor:** PROJECT_MANAGER  
**Precondition:** Project has PBS nodes and at least one User Journey  
**Flow:**
1. User triggers HLR generation
2. System compiles: project metadata, PBS tree as functional requirements, user journeys as scenarios
3. User can add/edit non-functional requirements in the web view
4. User can export to PDF

---

## UC-09: Change Password
**Actor:** Any authenticated user  
**Flow:**
1. User goes to profile settings
2. Enters current password + new password (confirmed)
3. System validates and updates hash
