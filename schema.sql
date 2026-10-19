create table if not exists notes(
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  title text not null default '',
  body text not null default '',
  notebook text not null default 'My Notebook',
  tags text[] not null default '{}',
  pinned boolean not null default false,
  drive_id text,
  drive_mtime timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table notes enable row level security;
create policy "own notes" on notes for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Storage bucket for pasted images and PDFs (public URLs, upload/delete only in your own folder)
insert into storage.buckets(id,name,public) values('files','files',true) on conflict do nothing;
create policy "upload own files" on storage.objects for insert to authenticated
  with check (bucket_id='files' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "delete own files" on storage.objects for delete to authenticated
  using (bucket_id='files' and (storage.foldername(name))[1]=auth.uid()::text);
