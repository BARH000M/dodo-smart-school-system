# Role scope

| Role | Current access | Remaining gate |
|---|---|---|
| super_admin/admin | School-wide registers | Delegation, branch restrictions, audits |
| receptionist | Reception and selected student registers | Atomic admission, privacy |
| accountant | Fees, finance drafts, student lookup | Double-entry posting, reversals |
| librarian | Books and announcements | Copies and loan transactions |
| content_editor | Courses/lessons and announcements | Media, review, publishing |
| student/parent | Operator-linked read-only student, fee, attendance, homework; announcements | Term-scoped links, assessments, submissions |
| teacher | Published announcements only | Verified staff identity, class-scoped teaching |

Detailed read/write roles are in contracts/modules.json and SQL policies. Multi-role users receive union of authorized policies. UI filtering is not authorization.
