# Wishmap

Wishmap is a wishlist that looks like a map instead of a list. Every item you want to buy is a bubble, and bubbles are pulled toward the categories they belong to, much like the graph view in Obsidian. Zoom out and you see colored clusters. Click a bubble and a product card opens with the photo, price, and a link to the shop.

## Who it is for

Wishmap is for people who keep a long, messy list of things to buy and want to see how the items relate to each other. It works best if you:

- shop on Shopee or TikTok Shop and want your links and prices in one place;
- compare options before buying, such as three sunscreens when you only need one;
- think in groups, like a skincare routine or a desk setup, rather than in a flat checklist;
- use both a laptop and an iPhone and want the list to stay in sync.

It is built for personal use: one person, one private wishlist. It is not a store, it does not track prices automatically, and it does not share lists between users.

## What it does

- Categories can contain subcategories, for example Skincare › Sunscreen and Skincare › Facial Wash.
- Each item stores a shop link, a price, and the date the price was last checked. Prices older than 30 days are marked as stale.
- Items can be linked as alternatives (pick one) or complements (used together). Once one alternative is marked as bought, the others fade out and drop from the estimated total.
- Zoom changes what you see: colored regions and bubbles from far away, then names, prices, and photos at medium range, and relation tags up close.
- Each category tints the area around its items, so groups read as regions on a map. Subcategories that share their parent's color get a lighter or darker shade of it.
- Categories can use one of eight preset colors or any color you pick.
- Search with ⌘K or `/`, switch between the map and a plain list grouped by category, and use the legend (or the stale-price chip) to highlight only stale, bought, alternative, or complementary items.
- Keyboard: `+` and `-` zoom, `0` fits the map, `L` opens the legend, `Esc` clears the selection or highlight.

## Running your own copy

Wishmap is a single `index.html` with no build step, so it runs on GitHub Pages. Without any setup it stores data in your browser. To sync between devices, connect it to a Supabase project by running `schema.sql` and filling in `CONFIG` at the top of the script in `index.html`.
