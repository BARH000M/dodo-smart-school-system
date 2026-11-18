# Continue from V0.2 (not from a new scaffold)
1. Run setup, capture real exit codes; resolve dependency/SDK problems. Commit generated native wrappers plus package-lock.json and pubspec.lock after inspection.
2. In the disposable new DODO backend, review and apply all four migrations by CLI. Run catalog_checks.sql and rls_isolation.sql with owner authority only. Verify failed cross-school/parent writes and payment replay.
3. Provision two test schools, two admins and scoped test student/parent accounts. Test every existing module on both clients. Record actual evidence in the 147-row matrix.
4. Finish Job 1: secure staff identity and branch/class constraints; online admission conversion, attendance QR, marks/CBSE, journal posting, payroll, role admin and audit.
5. Finish Job 2: real LMS learner delivery and assignments, submissions, assessments, course progress, storage/media, returns/loans, inventory transactions, transport/hostel assignments, certificates, messages and public CMS.
6. Finish Job 3: settings, reports, permissions, backup/recovery, accessible layouts, cross-client tests, deployment and signed release. Maintain exact inventory names and honest states.
