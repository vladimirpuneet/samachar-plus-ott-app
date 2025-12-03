# Samachar Plus OTT – Database Schema (v1.1)

This schema separates staff and public users, normalizes Indian locations (state → district → subdistrict), models categories and follows, and cleanly splits field reports from published content. [web:1][web:22]

> **Last Updated**: 2025-12-02 13:14:43 IST

## Identity and profiles

- auth.users: Supabase identity for everyone (staff and public). [web:1]
- internal_users (1:1 with auth.users): admin, editor, or reporter; reporters/editors use email `{phone}@samacharplusott.com` with password; admins may use normal emails. [web:1]
- public_users (1:1 with auth.users): phone + OTP users with preferences JSONB and basic location fields. [web:58]

Key columns (internal_users): role, reporter_tier, editor_level, district_id, state_id, circuit_id, onboarding_status, is_active, plus Aadhaar and emergency contacts. [web:22]

Key columns (public_users): phone, name, state, district, preferences JSONB (receive_* toggles, language), is_blocked. [web:22]

## Locations

- states → districts → locations (subdistricts), with optional circuits grouped under states for internal use. [web:74]
- Reporters are assigned exactly one district; circuits are for bureau chiefs and admin dashboards, not for reporter onboarding UI. [web:22]

## Categories and assignments

- categories: admin-managed taxonomy (id, slug, name, description, is_active, sort_order). [web:22]
- user_category_follows: public user follows for feeds/notifications. [web:88]
- editor_category_assignments: which categories a publisher-level editor can manage; senior editors may be allowed all in RLS. [web:5]

## Reporting and publishing

- reports: field submissions with status submitted → review → published → rejected, tied to reporter and location. [web:22]
- content: published items (news/article/story/post/bulletin) possibly derived from a report (source_report_id), with district/location FKs and category mapping in content_categories. [web:22]
- bulletin_items: allows a bulletin to include multiple already-published content items. [web:22]

## Media

- media_assets: belongs to exactly one of report or content (exclusive), supports images, video, thumbnails, and attachments. [web:22]

## Security (RLS)

- Enable RLS on all user- and content-facing tables. [web:5]
- Reporters insert and edit only their own reports; editors can publish based on editor_level and category assignments; admins have broad access. [web:5]
- Index columns used in policies (role, editor_level, status, category_id, district_id) to keep checks fast. [web:92]

## Importing locations (from LGD JSON)

- Load states (unique by state_code), then districts (unique per state), then locations (subdistricts), trimming local names and treating “NA/00000” census codes as nulls. [web:22]
- Attach circuits later by mapping districts to circuit_id. [web:74]

