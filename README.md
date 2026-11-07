# Wishmap

Wishlist belanja dalam bentuk peta graf yang bergerak. Gelembung saat dilihat dari jauh, kartu produk saat diklik.

## File

- `index.html` — seluruh app (D3-force, tanpa build step). Siap untuk GitHub Pages.
- `schema.sql` — tabel `nodes` dan `relations`, validasi, dan RLS untuk Supabase.

## Menyambungkan ke Supabase

1. Buat proyek Supabase baru (terpisah dari Strata).
2. Buka **SQL Editor**, tempel isi `schema.sql`, jalankan.
3. **Authentication → URL Configuration**: isi *Site URL* dan *Redirect URLs* dengan alamat GitHub Pages kamu (misalnya `https://<username>.github.io/wishmap/`).
4. **Project Settings → API**: salin *Project URL* dan *anon public key*, lalu isi di `index.html`:

   ```js
   const CONFIG = {
     SUPABASE_URL: 'https://xxxx.supabase.co',
     SUPABASE_ANON_KEY: 'eyJ...',
   };
   ```

   Anon key memang dirancang untuk publik; datamu tetap terlindungi oleh RLS.
5. Push ke GitHub, aktifkan Pages dari branch `main`.

Kalau `CONFIG` dibiarkan kosong, app berjalan dalam mode contoh dengan data di browser saja.

## Model data

| Tabel | Isi |
|---|---|
| `nodes` | `kind` = `produk` / `kategori` / `tujuan` |
| `relations` | `anggota` (produk → kategori/tujuan), `alternatif` dan `pelengkap` (produk ↔ produk, disimpan sekali per pasangan) |

Perkiraan total di header menghitung tiap grup alternatif sekali, dengan harga termurahnya. Grup yang salah satu anggotanya sudah dibeli tidak dihitung lagi.

## Cara pakai singkat

- **Jauh**: gelembung saja. **Sedang**: nama. **Dekat**: harga, foto, tanda "atau" dan "+".
- Seret simpul di laptop untuk melihatnya membal. Di iPhone, ketuk untuk membuka kartu.
- Lingkaran putus-putus oranye = harga belum dicek lebih dari 30 hari. Tombol "harga perlu dicek" melompat ke barang-barang itu satu per satu.
