# Shared module register (49 definitions)
Source: `contracts/modules.json`. Actual UI reuses generic form and list engines. None are marked fully verified. `fee_balances` is a read-only view.

| Domain | Arabic label | DB object | Authorized write roles |
|---|---|---|---|
| Students | الفروع | `branches` | super_admin, admin |
| Academics | الفصول والأقسام | `classes` | super_admin, admin |
| Students | تفاصيل الطالب | `students` | super_admin, admin, receptionist |
| Reception | استعلام عن القبول | `admissions` | super_admin, admin, receptionist |
| HR | دليل الموظفين | `staff` | super_admin, admin |
| LMS | الدورات | `courses` | super_admin, admin, content_editor |
| LMS | الدروس | `lessons` | super_admin, admin, content_editor |
| Academics | تسجيل الطلاب بالفصول | `enrollments` | super_admin, admin, receptionist |
| Academics | حضور الطلاب | `attendance` | super_admin, admin |
| Finance | الرسوم المستحقة | `invoices` | super_admin, admin, accountant |
| Finance | تحصيل الرسوم | `payments` | super_admin, admin, accountant |
| Reception | قائمة الغرض | `visit_purposes` | super_admin, admin, receptionist |
| Reception | كتاب الزوار | `visitors` | super_admin, admin, receptionist |
| Reception | سجل المكالمات الهاتفية | `phone_calls` | super_admin, admin, receptionist |
| Reception | البريد الوارد والصادر | `postal_records` | super_admin, admin, receptionist |
| Reception | الشكاوى | `complaints` | super_admin, admin, receptionist |
| Students | فئات الطلاب | `student_categories` | super_admin, admin |
| Students | بيت الطالب | `student_houses` | super_admin, admin |
| Students | تعطيل السبب | `disable_reasons` | super_admin, admin |
| Academics | السنوات الدراسية | `academic_years` | super_admin, admin |
| Academics | المواد | `subjects` | super_admin, admin |
| Academics | تعيين المواد والمعلمين | `teaching_assignments` | super_admin, admin |
| Academics | الجدول الأسبوعي | `timetable_entries` | super_admin, admin |
| Academics | خطة الدرس | `lesson_plans` | super_admin, admin |
| Exams | مجموعة الامتحانات | `exam_groups` | super_admin, admin |
| Exams | الامتحانات | `exams` | super_admin, admin |
| Exams | جدول الامتحان | `exam_schedules` | super_admin, admin |
| Finance | نوع الرسوم | `fee_types` | super_admin, admin, accountant |
| Finance | مجموعة الرسوم | `fee_groups` | super_admin, admin, accountant |
| Finance | وصف الدخل | `income_categories` | super_admin, admin, accountant |
| Finance | أوصاف المصروف | `expense_categories` | super_admin, admin, accountant |
| Finance | البنوك | `banks` | super_admin, admin, accountant |
| Finance | مسودات الدخل | `income_drafts` | super_admin, admin, accountant |
| Finance | مسودات المصروف | `expense_drafts` | super_admin, admin, accountant |
| HR | حضور الموظفين | `staff_attendance` | super_admin, admin |
| HR | الإجازات | `leave_requests` | super_admin, admin |
| HR | مسودات الرواتب | `salary_drafts` | super_admin, admin |
| HR | تقييم المعلمين | `teacher_evaluations` | super_admin, admin |
| LMS | الواجبات | `homework` | super_admin, admin |
| LMS | الحصص المباشرة | `live_sessions` | super_admin, admin |
| Library | قائمة الكتب | `books` | super_admin, admin, librarian |
| Transport | المركبات | `vehicles` | super_admin, admin |
| Transport | الخطوط | `transport_routes` | super_admin, admin |
| Transport | نقاط الالتقاط | `pickup_points` | super_admin, admin |
| Operations | الغرف | `dorm_rooms` | super_admin, admin |
| Operations | الأصناف | `inventory_items` | super_admin, admin |
| Communication | لوحة الإعلانات | `announcements` | super_admin, admin |
| Communication | التقويم والمهام | `calendar_events` | super_admin, admin |
| Finance | الرسوم المتوازنة | `fee_balances` | Read only |
