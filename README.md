# Notes: Evernote-style Markdown notes (Supabase + Vercel PWA)

Static app, no build step.

## Setup
1. Supabase: create a project, open **SQL Editor**, run `schema.sql`.
2. **Authentication → Providers → Email**: turn **Confirm email** off, so a plain User ID works (it is stored as `id@notes.app`).
3. Put your Project URL and anon key at the top of the `<script>` in `index.html` (`SUPABASE_URL`, `SUPABASE_KEY`).
4. Deploy: push this folder to GitHub, import it in Vercel (Framework: Other, no build command), or run `npx vercel --prod`.
5. Phone: open the Vercel URL, then Add to Home Screen.

## Obsidian / Google Drive sync
Install Google Drive for desktop and make your vault folder available offline. In the app (desktop Chrome/Edge) click **⇄ Sync Obsidian folder** and pick that folder.
Notes map to `Title.md` files in that folder (top level only). The newer side wins, and new `.md` files are imported as notes.

## Notes
- Pasted or dropped images and attached PDFs go to the Supabase `files` bucket and are linked by URL in the Markdown.
- Bucket URLs are public but unguessable. Make the bucket private if you need stricter privacy (the links would then need signed URLs).
