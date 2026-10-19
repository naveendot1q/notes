# Notes: Evernote-style Markdown notes (Supabase + Vercel PWA)

Static app, no build step.

## Setup
1. Supabase: create a project, open **SQL Editor**, run `schema.sql`.
2. **Authentication → Providers → Email**: turn **Confirm email** off, so a plain User ID works (it is stored as `id@notes.app`).
3. Put your Project URL and anon key at the top of the `<script>` in `index.html` (`SUPABASE_URL`, `SUPABASE_KEY`).
4. Deploy: push this folder to GitHub, import it in Vercel (Framework: Other, no build command), or run `npx vercel --prod`.
5. Phone: open the Vercel URL, then Add to Home Screen.

## Google Drive sync (desktop and phone)
Already ran an older `schema.sql`? Run once: `alter table notes add column if not exists drive_id text, add column if not exists drive_mtime timestamptz;`
1. Google Cloud Console: create a project and enable **Google Drive API**.
2. **OAuth consent screen**: External, leave it in *Testing*, add your own Google account under *Test users*.
3. **Credentials → Create credentials → OAuth client ID → Web application**. Add your Vercel URL (and `http://localhost:3000` for local tests) under *Authorized JavaScript origins*. Paste the Client ID into `GOOGLE_CLIENT_ID` in `index.html`.
4. In the app tap **📁 Drive folder…** and paste the link to your Obsidian vault folder (saved to your account, so the phone picks it up too). Then tap **⇄ Sync Google Drive**. Google shows an "unverified app" warning the first time: Advanced → Continue.

Sync walks the whole folder tree. Each Drive folder is a Notebook (path like `CCNA_Study_Guide/images`), each `.md` file is a note, the newest edit wins, and new files become notes. Changing a note's **Folder path** moves its file in Drive. Folders starting with `.` (`.obsidian`, `.trash`) are skipped. Deleting a file in Drive does not delete the note (the next sync uploads it again). Images referenced by relative path inside your vault are not displayed yet. Tags stay in the app only.

## Notes
- Pasted or dropped images and attached PDFs go to the Supabase `files` bucket and are linked by URL in the Markdown.
- Bucket URLs are public but unguessable. Make the bucket private if you need stricter privacy (the links would then need signed URLs).

## Layout and focus mode
Drag the thin divider between panes to resize. The ◧ and ▤ buttons hide the sidebar and notes list. ⛶ (or Alt+Z) is focus mode: only the editor, full screen, Esc to leave. Ctrl+\ toggles the sidebar.

## Autosave
Every keystroke is kept as a local draft and saved to Supabase about 0.35 s after you pause (at most every 3 s while typing). The status at the top right of the editor shows Saving… / Saved ✓ / ⚠ with the error. Unsaved drafts are restored and retried on the next load. If Drive and the app both changed a note, the app version is kept as a "(conflict copy)" note.
