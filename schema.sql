-- Wishmap · skema Supabase v1
-- Jalankan sekali di Supabase → SQL Editor (proyek baru, terpisah dari Strata).
--
-- Model: graf berlabel.
--   nodes     : simpul. kind = 'produk' | 'kategori' | 'tujuan'
--   relations : sisi bertipe.
--     'anggota'    produk  → kategori/tujuan   (berarah)
--     'alternatif' produk ↔ produk             (simetris: pilih salah satu)
--     'pelengkap'  produk ↔ produk             (simetris: dipakai bersama)
--     'induk'      kategori → kategori         (subkategori → induknya; pohon)

create extension if not exists pgcrypto;

-- ───────────────────────── nodes ─────────────────────────
create table if not exists public.nodes (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null default auth.uid() references auth.users(id) on delete cascade,
  kind              text not null check (kind in ('produk', 'kategori', 'tujuan')),
  nama              text not null check (length(trim(nama)) > 0),

  -- khusus produk
  link              text,
  harga             bigint check (harga is null or harga >= 0),
  harga_dicek_pada  date,
  toko              text check (toko is null or toko in ('shopee', 'tiktok', 'lainnya')),
  foto_url          text,
  catatan           text,
  status            text not null default 'ingin' check (status in ('ingin', 'dibeli', 'batal')),

  -- khusus kategori/tujuan
  warna             text,   -- nama preset atau hex bebas #RRGGBB (lihat constraint nodes_warna_check)
  amplop            text,   -- colokan v2: nama amplop di sheet budget
  emoji             text,   -- kategori/tujuan: null = ditebak dari nama, '' = tanpa emoji

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),

  -- kolom harga/link hanya bermakna untuk produk, amplop hanya untuk kategori
  constraint produk_only check (kind = 'produk' or (link is null and harga is null and toko is null)),
  constraint amplop_only check (amplop is null or kind = 'kategori')
);

create index if not exists nodes_user_idx on public.nodes (user_id);

-- Emoji kategori/tujuan (ditambahkan setelah v1; aman dijalankan ulang)
alter table public.nodes add column if not exists emoji text;
alter table public.nodes drop constraint if exists nodes_emoji_check;
alter table public.nodes add constraint nodes_emoji_check check (emoji is null or char_length(emoji) <= 16);

-- Warna: 8 preset yang ikut tema terang/gelap, atau hex bebas #RRGGBB.
-- drop + add supaya aman dijalankan ulang di database yang sudah ada.
alter table public.nodes drop constraint if exists nodes_warna_check;
alter table public.nodes add constraint nodes_warna_check check (
  warna is null
  or warna in ('pink','orange','yellow','green','teal','blue','indigo','purple')
  or warna ~ '^#[0-9A-Fa-f]{6}$'
);

-- updated_at otomatis + harga_dicek_pada ikut maju saat harga berubah
create or replace function public.nodes_touch() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  if new.kind = 'produk' and new.harga is not null then
    if tg_op = 'INSERT' and new.harga_dicek_pada is null then
      new.harga_dicek_pada := current_date;
    elsif tg_op = 'UPDATE' and new.harga is distinct from old.harga then
      new.harga_dicek_pada := current_date;
    end if;
  end if;
  return new;
end $$;

drop trigger if exists nodes_touch on public.nodes;
create trigger nodes_touch before insert or update on public.nodes
for each row execute function public.nodes_touch();

-- ─────────────────────── relations ───────────────────────
create table if not exists public.relations (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  from_id     uuid not null references public.nodes(id) on delete cascade,
  to_id       uuid not null references public.nodes(id) on delete cascade,
  type        text not null,
  created_at  timestamptz not null default now(),
  constraint no_self_loop check (from_id <> to_id)
);

create index if not exists relations_user_idx on public.relations (user_id);

alter table public.relations drop constraint if exists relations_type_check;
alter table public.relations add constraint relations_type_check
  check (type in ('anggota', 'alternatif', 'pelengkap', 'induk'));

-- Pohon: setiap kategori paling banyak punya satu induk
create unique index if not exists relations_one_parent
  on public.relations (from_id) where type = 'induk';

-- Relasi simetris disimpan sekali saja: {A,B} = {B,A}
create unique index if not exists relations_unique_pair
  on public.relations (least(from_id, to_id), greatest(from_id, to_id), type);

-- Validasi jenis simpul di kedua ujung sisi
create or replace function public.relations_check() returns trigger
language plpgsql as $$
declare
  k_from text;
  k_to   text;
begin
  select kind into k_from from public.nodes where id = new.from_id;
  select kind into k_to   from public.nodes where id = new.to_id;

  if new.type = 'anggota' then
    if k_from <> 'produk' or k_to not in ('kategori', 'tujuan') then
      raise exception 'anggota harus produk → kategori/tujuan (dapat % → %)', k_from, k_to;
    end if;
  elsif new.type = 'induk' then
    if k_from <> 'kategori' or k_to <> 'kategori' then
      raise exception 'induk hanya boleh kategori → kategori (dapat % → %)', k_from, k_to;
    end if;
    -- Tolak siklus: telusuri leluhur dari calon induk; kalau ketemu dirinya sendiri, tolak
    if exists (
      with recursive leluhur(id, langkah) as (
        select new.to_id, 0
        union all
        select r.to_id, l.langkah + 1
        from public.relations r join leluhur l on r.from_id = l.id
        where r.type = 'induk' and l.langkah < 64
      )
      select 1 from leluhur where id = new.from_id
    ) then
      raise exception 'kategori tidak boleh menjadi induk dari leluhurnya sendiri';
    end if;
  else
    if k_from <> 'produk' or k_to <> 'produk' then
      raise exception '% hanya boleh antar produk (dapat % ↔ %)', new.type, k_from, k_to;
    end if;
  end if;
  return new;
end $$;

drop trigger if exists relations_check on public.relations;
create trigger relations_check before insert or update on public.relations
for each row execute function public.relations_check();

-- ─────────────────── Row Level Security ───────────────────
alter table public.nodes     enable row level security;
alter table public.relations enable row level security;

drop policy if exists "nodes: milik sendiri" on public.nodes;
create policy "nodes: milik sendiri" on public.nodes
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "relations: milik sendiri" on public.relations;
create policy "relations: milik sendiri" on public.relations
  for all to authenticated
  using (user_id = auth.uid())
  with check (
    user_id = auth.uid()
    and exists (select 1 from public.nodes n where n.id = from_id and n.user_id = auth.uid())
    and exists (select 1 from public.nodes n where n.id = to_id   and n.user_id = auth.uid())
  );

-- ───────────────────── Izin Data API ─────────────────────
-- Proyek Supabase baru tidak selalu memberi izin tabel ke role "authenticated".
-- RLS di atas tetap membatasi setiap akun ke barisnya sendiri.
grant usage on schema public to authenticated;
grant select, insert, update, delete on public.nodes, public.relations to authenticated;
