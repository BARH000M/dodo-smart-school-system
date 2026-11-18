# DODO agent entrypoint
Read `docs/requirements/MASTER_BUILD_PROMPT.md`, `docs/requirements/ROADMAP.md` and `docs/reports/FEATURE_COMPLETION_MATRIX.csv`.
Canonical React source: `web/src`; shared TypeScript: `src`; Flutter: `mobile/lib`; SQL: `supabase/migrations`.
Root on Windows: `E:\dodo-smart-school-system`. Separate from every SAI project. Never add credentials or change remote data without approval. Work on main locally, verify and commit logical changes.
Run `npm test` after contract changes, then web build and Flutter analyze/test as available. Use `npm run sync:contracts` after editing the shared JSON. Do not mark untested features complete.
