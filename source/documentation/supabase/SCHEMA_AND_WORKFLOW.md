# Samachar Plus OTT – Database Schema and Admin Workflow (2025-11-27)


> **Last Updated**: 2025-12-02 13:14:43 IST
---

---

## 1. Database Schema (v1)

### **Authentication**
- `auth.users`: Managed by Supabase. All users (internal and public).

### **Internal Users**
- `public.internal_users`
  - `id` (UUID, PK — references `auth.users.id`)
  - `full_name` (text)
  - `role` (`'admin'|'editor'|'reporter'`)
  - `email` (text, unique)
  - `phone` (text, unique)
  - `is_active` (boolean)
  - `onboarding_status` (`'applied'|'approved'|'rejected'`)
  - `reporter_tier` (nullable unless `role='reporter'`)
  - `editor_level` (nullable unless `role='editor'`)
  - `district_id` (FK, nullable)
  - `state_id` (FK, nullable)
  - `circuit_id` (FK, nullable)
  - `employee_code`, `aadhaar_number`, `blood_group`, `emergency_contact_*` (optional/hr fields)
  - `created_at`, `updated_at`

### **Public Users**
- `public.public_users`
  - `id` (UUID, PK — references `auth.users.id`)
  - `phone` (text, unique)
  - `name` (text)
  - `state` (text)
  - `district` (text)
  - `preferences` (jsonb: notification toggles, language)

### **Locations**
- `public.states`
  - `id` (UUID, PK), `state_code` (int, unique), `state_name_english` (text), `is_active` (boolean)
- `public.circuits` *(optional, for admin/bureau scoping)*
  - `id`, `state_id` (FK), `name`, `is_active`
- `public.districts`
  - `id`, `state_id` (FK), `circuit_id` (FK, nullable), `district_code`, `district_name_english`, `is_active`
- `public.locations` *(subdistricts)*
  - `id`, `state_id` (FK), `district_id` (FK), `subdistrict_code`, `subdistrict_name_english`, `is_active`

### **Categories & Assignment**
- `public.categories`
  - `id`, `slug`, `name`, `description`, `is_active`, `sort_order`
- `public.content_categories`
  - `content_id` (FK), `category_id` (FK)
- `public.editor_category_assignments`
  - `internal_user_id` (FK), `category_id` (FK)
- `public.user_category_follows`
  - `public_user_id` (FK), `category_id` (FK)

### **Reporting & Content**
- `public.reports`
  - `id`, `title`, `description`, `reporter_id` (FK), `state_id`, `district_id`, `location_id`, `status`, timestamps
- `public.content`
  - `id`, `type`, `title`, `description`, `status`, `source_report_id` (FK), `author_editor_id` (FK), `district_id`, `location_id`, timestamps
- `public.bulletin_items`
  - `bulletin_id` (FK), `content_id` (FK), `position` (int)

### **Media & Onboarding**
- `public.media_assets`
  - `id`, `report_id` (FK), `content_id` (FK), `type`, `url`,...
- `public.reporter_applications`
  - All join-us fields, status, approver, links to `internal_users`

---

## 2. Data Relationships

- All FKs are UUID; use UI dropdowns or autocomplete for assignment (district to user, category to editor, etc.)
- Locations: `states` → `districts` → `locations` (subdistricts)
- Editors: assigned to categories (`editor_category_assignments`)
- Content: assigned to 1+ categories via `content_categories`
- Reporters: always linked to a specific district

---

## 3. Admin App Functional Workflow

### **User Management**
- Add, edit, activate/deactivate all staff (admins, editors, reporters)
- View onboarding pipeline (reporter_applications), approve/reject, auto-create accounts

### **Location Reference**
- Read-only (mostly), but searchable for lookups
- Used as sources for all dropdowns

### **Categories**
- CRUD for categories
- Assign editors (publishers) to categories

### **Assignment/Scoping**
- Assign reporter to district
- Assign publisher/senior editor to category
- Bureau chief assigns to circuit or oversees reporting district-wide

### **Reporting Workflow**
- View, approve/reject reporter onboarding applications
- Monitor reporter activity and create/close/edit reports
- Assign/unassign editors to submitted reports

### **Content Management**
- See all reports, review, approve, convert to published content
- Manage publishing status, assign to bulletins, attach media
- Only allow editors to publish if assignment allows (category/district RLS enforced)

### **Bulletin Management**
- Create bulletins (groups of published news/content)
- Drag-and-drop/assign content to bulletins

### **Media**
- Upload and review images, video, attachments for reports and content

---

## 4. RLS & Permission Logic (implemented in both backend and admin UI)

| Role      | Content/Report workflow capabilities                | Assignment scope                   |
|-----------|----------------------------------------------------|------------------------------------|
| Admin     | All actions, all tables                            | Full access                        |
| Editor    | Review, approve, publish, but only in allowed scope| Categories, districts assigned     |
| Reporter  | Submit/edit/view own reports only                  | Assigned district only             |
| Public    | Read published content, set category follows       | Follows/prefs/phone login only     |

---

## 5. Implementation Tips (for Kilocode/codegen)

- Table structure matches exactly; safe to generate CRUD forms/tables, ID lookups as UUID
- Operations should always respect FKs (categories, locations)
- React query/view permissions based on role (use internal_users.role and internal_users.editor_level)
- Keep all data/permissions logic in sync between UI and Supabase RLS

---

## 6. Future Extensions

- Add circuits/support for bureau chief only if needed for admin analytics
- Comments, analytics, SMS/email logs can be separate modules with simple UUID FKs to users/content
- Notifications and realtime (Supabase event system) later as feature needs grow

---

*Place this file at repo root. Update whenever you add new tables, roles, or relationships.*
