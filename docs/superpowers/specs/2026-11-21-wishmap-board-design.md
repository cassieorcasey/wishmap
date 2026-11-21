# Wishmap: papan kartu adaptif (desain)

Status: disetujui 2026-11-21, dibangun mengikuti "Konsep & Spesifikasi Desain Wishmap" (Meja Kurasi Saku): kartu struk & swatch, bilah catat cepat mengambang dengan parsing satu baris, pill tempel clipboard, panel detail samping di desktop, token Cherry Vibes dan perbaikan kontras ::selection.

Penyimpangan dari spesifikasi: masonry memakai posisi absolut lewat JS kecil, bukan CSS column-count, supaya urutan baca dan urutan Tab tetap kiri-ke-kanan dan kartu tidak melompat antar kolom. Tetap tanpa pustaka.

## Tujuan
Mengganti peta mind map (D3) dengan papan kartu masonry yang ringan, karena mind map terasa tidak cocok untuk daftar belanja. Fokus: mencatat cepat, memindai cepat, menandai dibeli cepat.

## Bukan tujuan
- Tidak ada perubahan skema atau migrasi data. `nodes`, `relations`, `wishmap:v1`, Supabase, dan `amplop_batas` tetap.
- Tidak ada peta, tampilan Daftar, seret-ke-kategori, atau mode Hubungkan.
- Palet Cherry Vibes (terang/gelap) dan logo tiga gelembung tetap.

## Keputusan (dari wawancara)
| Topik | Keputusan |
|---|---|
| Hierarki | Baris pill kedua: pilih kategori induk, muncul pill subkategori. Kartu menampilkan seluruh cabang. Tujuan di kelompok pill terpisah. |
| Relasi | Diatur dari detail kartu: bagian Alternatif dan Pelengkap dengan "+ Tambah" dan pemilih berpencarian. Tanpa mode pilih dua kartu. |
| Fitur dari audit | Dibawa: batas amplop (ringkasan saat kategori dipilih) dan simulasi pilihan sementara. Tidak dibawa: seret ke kategori, tabel Bandingkan. |
| Urutan | Belum dibeli dulu menurut tanggal tambah, yang dibeli turun ke bawah dengan jeda singkat. Pilihan urut: Terbaru, Termurah, Harga basi dulu. |
| Mode Daftar | Dihapus. Papan kartu saja. |
| Interaksi | Efek centang Dibeli (pantul, percikan, total berhitung, Urungkan) dan edit harga/catatan di tempat. Sorot relasi dan animasi pindah kartu tidak dibawa. |

## Pilihan saya (bisa dikoreksi)
- Papan memakai grid kolom yang dibagi lewat JS (bukan `column-count`), supaya kartu tidak melompat antar kolom. Kolom: 2 (<600px), 3 (600-960px), 4-5 (>960px), lebar maks 1280px.
- Simulasi butuh cara memilih alternatif, jadi bagian Alternatif di detail kartu tetap menampilkan harga, toko, selisih, dan lingkaran "pilih sementara". Ini bukan tabel Bandingkan penuh.
- Pindah kategori lewat dropdown di form Edit barang, bukan seret.
- Kartu tanpa foto memakai varian tipografi padat dengan aksen warna kategori. Kartu dengan foto yang gagal dimuat beralih ke varian itu.
- Pill relasi (`⇄ 2 alternatif`) di kartu membuka detail dan menggulir ke bagian relasi, bukan menyorot di papan.
- Hapus D3, `#map`, simulasi gaya, zoombar, legenda, menu radial, hull, fold, dan kode tarik. Pertahankan `derive()`, `estimate()`, `LocalStore`, `makeSupabaseStore()`, dan dialog produk/grup/cari/hapus/masuk.

## Pendekatan yang dipertimbangkan
1. Tulis ulang bagian tampilan di `index.html`, pakai ulang lapisan data dan dialog (dipilih): risiko terendah karena logika data sudah teruji.
2. Mulai file baru dari nol: bersih, tapi menggandakan pekerjaan dialog dan penyimpanan.
3. Pertahankan peta sebagai mode kedua: bertentangan dengan alasan perombakan ini.

## Pengujian
Ulangi uji headless: tambah/edit/hapus barang, centang Dibeli + Urungkan, filter status dan kategori (termasuk subkategori), amplop, simulasi, tampilan HP dan mode gelap tanpa gulir horizontal, dan data lama dari `wishmap:v1` terbuka tanpa kehilangan isi.
