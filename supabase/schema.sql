-- Fresh Supabase project setup. Review separately before using with existing data.
begin;
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  location text,
  avatar_url text
);
create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  vendor_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  description text,
  price numeric not null check (price >= 0),
  image_url text,
  category text,
  is_available boolean default true,
  is_popular boolean default false
);
create index menu_items_vendor_id_idx on public.menu_items(vendor_id);
alter table public.profiles enable row level security;
alter table public.menu_items enable row level security;
create policy "Own profile" on public.profiles for all to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));
create policy "Own menu" on public.menu_items for all to authenticated
  using (vendor_id = (select auth.uid())) with check (vendor_id = (select auth.uid()));
grant select, insert, update, delete on public.profiles, public.menu_items to authenticated;
create function public.create_vendor_profile() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles(id, full_name, location)
  values (new.id, new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'location');
  return new;
end;
$$;
create trigger on_vendor_signup after insert on auth.users
  for each row execute function public.create_vendor_profile();
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('food-images', 'food-images', true, 5242880, array['image/jpeg']);
create policy "Vendor image uploads" on storage.objects for insert to authenticated
  with check (bucket_id = 'food-images' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "Vendor image delete" on storage.objects for delete to authenticated
  using (bucket_id = 'food-images' and (storage.foldername(name))[1] = (select auth.uid())::text);
alter publication supabase_realtime add table public.menu_items;
commit;
