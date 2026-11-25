# Wishmap

Wishmap is a pocket curation desk for the things you want to buy. Every item is a card on a masonry board. Items with a photo show as gallery cards; items without one become compact receipt-style cards with a stripe in their category color, so no space is wasted on empty image boxes. The estimated total at the top is always honest: alternatives count once, at the cheapest price.

## Who it is for

Wishmap is for people who keep a long, messy list of things to buy and want it light enough to update every day. It works best if you:

- shop on Shopee or TikTok Shop and want your links and prices in one place;
- compare options before buying, such as three sunscreens when you only need one;
- think in groups, like a skincare routine or a desk setup, rather than one flat checklist;
- use both a laptop and an iPhone and want the list to stay in sync.

It is built for personal use: one person, one private wishlist. It is not a store, it does not track prices automatically, and it does not share lists between users.

## What it does

- **Quick capture.** Paste a Shopee or TikTok link, or type one line such as `Azarine Sunscreen 65rb #skincare`. Wishmap splits it into name, price (`65rb`, `1,2jt`, `Rp65.000`, `150000`) and category before you press Enter, and shows the result as you type. On a phone the bar floats at the bottom within thumb reach; on a laptop it sits in the header. With no hashtag, a new item goes into the category you are looking at. When the browser has already allowed clipboard access, a "Paste the link from Shopee?" pill appears so one tap adds it.
- **Hero summary.** A large heading ("Semua barang" or the chosen category) with the estimated total, the budget limit as a thin used + planned bar, and quiet text actions. One thin header row holds the logo, Search, **+ Tambah** (full form) and the menu.
- **Filter pills.** One quiet row for All, each category and each goal, with counts, and a small + for a new category. The Sort control also offers "only stale prices". Picking a category shows its subcategories in a second row. Subcategories always take a shade of their main category's colour; only main categories and goals have a colour picker.
- **Cards.** Plain white cards with a flat `Category · Shop` line, title, price in tabular numbers, a small amber dot when the price is more than 30 days old, and a check button to mark it bought. Bought items move to a **Sudah dibeli** drawer at the bottom and the total counts down. Alternatives of a bought item fade and leave the total.
- **Detail.** Tap a card for a bottom sheet on the phone (drag down to close) or a side panel on a laptop: full photo, price you can edit in place, "price still the same", status, open in shop, note, and the Alternatives and Complements of that item. Add or remove relations with a searchable picker. Alternatives are listed side by side with the price gap, and you can pick one "for now" to see the total change without saving anything.
- **Cooling-off period.** Every new item rests for 72 hours before it feels ready to buy. A small ring on the card fills as the time passes (`Endap · 46j`) and turns into a check when the item is ready (`Siap diputus`). Change the period per item in the detail or the form: no cooling-off, 24 hours, 3 days or 7 days.
- **Hold to buy.** The buy button on a card asks for a 1.5 second press (Space or Enter on a keyboard). A short tap only shows the hint. If the item is still cooling off, or its price takes a large share of what is left in the category budget, a short reflection sheet appears first: the budget bar with this item, the other items in the same budget that would no longer fit, and three one-tap answers (needed, supports a goal, or wait 3 more days).
- **Need tier and usefulness score.** Each item is `Wajib`, `Penunjang` or `Keinginan` (type `!wajib` in quick capture). Wishmap scores usefulness from the tier, the number of goals it serves, complements already bought, a finished cooling-off period and Adu guna wins, and sorts by it with **Paling berguna**.
- **Adu guna.** Compare two active items side by side and pick the one that is more useful right now. The winner moves up in Paling berguna; the other can wait 3 more days or become an alternative.
- **Swipe on a phone.** Drag a card right to open the reflection sheet, or left to delete it. Both show a colored action behind the card and need a drag past a threshold, so a slip does nothing; both offer **Urungkan** (undo). It works with touch and pen. Mouse users keep the check button and the detail view.
- **Sort** by newest, cheapest, or stale prices first. Search with ⌘K or `/`, press `N` to jump to quick capture, `B` to mark the open item bought, `Esc` to close.
- Every quick change shows an **Urungkan** (undo) button.
- A soft romantic look: a still, diffused gradient of rose, petal pink, lavender and sky blue behind everything, milky-white translucent cards and chips on top of it, plum-tinted ink text, Apple blue only for primary actions, four concentric corner radii, light theme only, system font, 44 px touch targets, and reduced motion and reduced transparency respected (cards turn solid white).

## Running your own copy

Wishmap is a single `index.html` with no build step and no libraries to load, so it runs on GitHub Pages. Without any setup it stores data in your browser. To sync between devices, connect it to a Supabase project by running `schema.sql` and filling in `CONFIG` at the top of the script in `index.html`.

If you already ran an older `schema.sql`, run the latest one again: it adds the optional `amplop_batas` column (budget limit) and the curation columns `kebutuhan`, `endap_hingga` and `guna_menang` without touching your data. Until you do, everything else keeps working: saving a budget limit asks you to update the schema, and need tiers, cooling-off changes and Adu guna wins are not stored.
