# KrishiSync — Design Reference

Source: Figma file `GZWFB1RPHbq8eGxzz96X8j` ("Ui (Agriculture)").
All values below come from Figma variables / styles (page **DS – Foundations**, node `20:3`).
Code must use these only through `lib/core/theme/`.

## Figma pages
| Page | ID | Use |
|---|---|---|
| Wireframe Kit | `0:1` | Old — ignore |
| Mid-Fidelity | `11:2` | Old — ignore |
| **High-Fidelity** | `292:26` | **Source of truth for screens** (263 frames) |
| HF – Components | `292:27` | Shared widgets (buttons, inputs, nav bars…) |
| HF – Assets | `292:28` | Images, icon tiles, glyphs, splash art |
| DS – Foundations | `19:110` | Colors, type, spacing, radius, shadows |
| DS – Icons | `19:111` | Icon set |
| DS – Components | `19:112` | Base components |

Frame size: **360 × 800** (Android). The "9:41" status bar in Figma is mock chrome — use the real Android status bar.

## Colors

> Note: the swatch *labels* on the Foundations page (e.g. green/800 `#1F5522`) differ from the *variable values* the screens actually use (green/800 = `#2E7D32`). Screens are bound to the variables, so **the variable values below are the truth.** Figma writes alpha as `#RRGGBBAA`; Flutter uses `Color(0xAARRGGBB)`.

### Semantic (use these in code)
| Token | Figma value | Flutter |
|---|---|---|
| bg/page | `#FFFFFF` | `0xFFFFFFFF` |
| bg/surface | `#E8F5E9` | `0xFFE8F5E9` |
| bg/subtle | `#E8F5E9` | `0xFFE8F5E9` |
| bg/muted | `#1F1F1F12` | `0x121F1F1F` |
| bg/brand | `#2E7D32` | `0xFF2E7D32` |
| bg/brand-hover | `#2E7D32E5` | `0xE52E7D32` |
| bg/brand-pressed | `#2E7D32CC` | `0xCC2E7D32` |
| bg/disabled | `#1F1F1F1F` | `0x1F1F1F1F` |
| bg/accent | `#F2C94C` | `0xFFF2C94C` |
| bg/success-subtle | `#E8F5E9` | `0xFFE8F5E9` |
| bg/warning-subtle | `#F2C94C33` | `0x33F2C94C` |
| bg/error-subtle | `#C94C4C1F` | `0x1FC94C4C` |
| bg/info-subtle | `#78926226` | `0x26789262` |
| bg/error | `#C94C4C` | `0xFFC94C4C` |
| bg/overlay | `#1F1F1F` | `0xFF1F1F1F` (used with opacity) |
| text/primary | `#1F1F1F` | `0xFF1F1F1F` |
| text/secondary | `#1F1F1FA6` | `0xA61F1F1F` |
| text/disabled | `#1F1F1F59` | `0x591F1F1F` |
| text/on-brand | `#FFFFFF` | `0xFFFFFFFF` |
| text/brand | `#2E7D32` | `0xFF2E7D32` |
| text/success | `#2E7D32` | `0xFF2E7D32` |
| text/warning | `#1F1F1F` | `0xFF1F1F1F` |
| text/error | `#C94C4C` | `0xFFC94C4C` |
| text/info | `#1F1F1F` | `0xFF1F1F1F` |
| border/default | `#1F1F1F1F` | `0x1F1F1F1F` |
| border/strong | `#1F1F1F59` | `0x591F1F1F` |
| border/brand | `#2E7D32` | `0xFF2E7D32` |
| border/error | `#C94C4C` | `0xFFC94C4C` |
| icon/primary | `#1F1F1F` | `0xFF1F1F1F` |
| icon/secondary | `#789262` | `0xFF789262` |
| icon/brand | `#2E7D32` | `0xFF2E7D32` |
| icon/on-brand | `#FFFFFF` | `0xFFFFFFFF` |
| icon/warning | `#F2C94C` | `0xFFF2C94C` |
| icon/error | `#C94C4C` | `0xFFC94C4C` |

### Primitives (variable values)
- **green**: 50 `#E8F5E9` · 100 `#2E7D3226` · 200 `#2E7D324D` · 500 `#2E7D32` · 600 `#2E7D32E5` · 700 `#2E7D32CC` · 800–950 `#2E7D32`
- **sage**: 50 `#78926226` · 100 `#78926240` · 200 `#78926266` · 500–950 `#789262`
- **yellow**: 50 `#F2C94C33` · 100 `#F2C94C66` · 500 `#F2C94C` · 700 `#F2C94CCC` · 900 `#1F1F1F`
- **red**: 50 `#C94C4C1F` · 100 `#C94C4C38` · 500/700/900 `#C94C4C`
- **gray**: white `#FFFFFF` · 50 `#1F1F1F0A` · 100 `#1F1F1F12` · 200 `#1F1F1F1F` · 300 `#1F1F1F59` · 500 `#1F1F1FA6` · 700 `#1F1F1FCC` · 900 `#1F1F1F`

## Typography
Font: **Hind Siliguri** (Google Fonts, OFL license) — weights 400, 500, 600, 700. Bundle TTFs in `assets/fonts/`.
Fallback: **Noto Sans Bengali** (Figma uses it for the digit "১"). Set as `fontFamilyFallback`.
Letter spacing 0 for all. Flutter line height: `height = lineHeight / size`.

| Style | Weight | Size / Line height |
|---|---|---|
| Display/28 Bold | 700 | 28 / 38 |
| Heading/H1 24 | 700 | 24 / 34 |
| Heading/Bold 22 | 700 | 22 / 30 |
| Heading/Bold 20 | 700 | 20 / 28 |
| Heading/H2 20 | 600 | 20 / 28 |
| Heading/H3 18 | 600 | 18 / 26 |
| Body/Large 16 | 400 | 16 / 24 |
| Label/Button 16 | 600 | 16 / 21 |
| Label/Medium 15 | 600 | 15 / 21 |
| Body/Medium 14 | 400 | 14 / 21 |
| Body/Medium Emphasis 14 | 500 | 14 / 21 |
| Body/Medium Strong 14 | 600 | 14 / 21 |
| Body/Small 13 | 400 | 13 / 20 |
| Body/Small Emphasis 13 | 500 | 13 / 20 |
| Body/Small Strong 13 | 600 | 13 / 20 |
| Caption/12 | 400 | 12 / 17 |
| Label/Small 11 | 500 | 11 / 14 |
| Number/Large 28 | 700 | 28 / 36 |
| Number/Medium 18 | 600 | 18 / 24 |
| Number/Small 14 | 500 | 14 / 20 |

Numbers in Bangla mode use Bangla digits (e.g. `৳ ৩৮/কেজি`). Format with a locale helper, never hard-code.

## Spacing
`2xs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 20 · 2xl 24 · 3xl 32 · 4xl 40`
Screen side padding: 16 (content width 328 on a 360 frame).

## Corner radius
`sm 4 · md 8 · lg 12 · xl 16 · 2xl 20 · full 999`

## Shadows
| Token | Color | Offset (x, y) | Blur | Spread |
|---|---|---|---|---|
| Shadow/Small | `#00000014` (8%) | 0, 1 | 3 | 0 |
| Shadow/Medium | `#0000001A` (10%) | 0, 4 | 12 | 0 |
| Shadow/Large | `#00000024` (14%) | 0, 8 | 24 | 0 |

## Components (page HF – Components `292:27`)
| Component | Node | Size |
|---|---|---|
| App Bar | `292:32` | 360×56 |
| Home Header | `292:37` | 360×76 |
| Button set (Primary, Secondary, Outline, Text, Destructive, Warning, Icon, FAB, Toggle, Pill; Default/Pressed/Disabled; L 48 / M 40 / S 32) | `315:170` | — |
| Button/Primary, Button/Secondary | `292:50`, `292:52` | 328×48 |
| Input | `292:54` | 328×77 |
| Search Bar | `292:59` | 328×48 |
| List Item / List Item Status | `292:66` / `319:26` | 328×74 |
| Action Tile | `292:74` | 156×133 |
| Stat Card | `292:77` | 156×76 |
| Chip | `292:80` | 49×44 |
| Section Header | `292:82` | 328×28 |
| Timeline Item | `292:85` | 328×44 |
| Image Placeholder | `292:90` | 328×160 |
| Modal | `292:92` | 312×248 |
| Language Toggle | `292:97` | — |
| Banner Slider (Farmer / Farmer EN / Buyer) | `292:108` / `292:145` / `292:182` | 328×160 |
| Category Item | `292:219` | 64×90 |
| Bottom Nav – Farmer (Sell FAB) | `292:225` | 360×72 |
| Bottom Nav – Buyer (Demand FAB) | `292:246` | 360×72 |
| Bottom Nav – Transporter (Load FAB) | `292:263` | 360×72 |
| Toast | `292:242` | 328×47 |
| Tip Cards (BN / EN) | `345:6251` / `345:6458` | 288×168 |

`HF/Switch/*` frames on the High-Fidelity page are interaction states (selected chips, uploads, tabs). Use them as state references.

## Assets (page HF – Assets `292:28`)
- **Images** (200×200): farmer-field, buyer-warehouse, truck-road, tomato, potato, onion, rice, eggplant, chili, mango, farmer-m, farmer-f, buyer-p, driver, map, scale, port, handshake. Splash: `img/splash` `315:5469`, `img/splash-three-users` `351:8`, `img/splash-illustration-three-users` `352:8`.
- **Icon tiles** (64×64, `tile/*`): wallet, orders, truck, bell, chat, leaf, shield, verified, star, phone, location, camera, globe, speaker, info, calendar, market, profile, home, upload, download, send, mic, filter, map, trend-up, search, alert, warn, check, close, attach, video, image, doc.
- **Nav icons**: `nav-on/*`, `nav-off/*` for home, market, orders, wallet, profile, truck.
- **Glyphs**: leaf, orders, market, wallet, truck, trend-up, bell, chat, camera, search, profile, home, location, shield, star, phone, plus, map, package, list, `dot/check`.
- Export icons as **SVG** (flutter_svg), photos as **PNG/WebP**.
- Crop photos in Figma are sample art. Real listings use photos uploaded by farmers (Firebase Storage). The crop category row uses the bundled crop images.

## Screen → Figma frame mapping (High-Fidelity page)
Roles come from the numbering and the Figma section headings (কৃষক / ক্রেতা / ট্রান্সপোর্টার / সবার জন্য). MVP vs later scope is in `PLAN.md`.

### Shared — Onboarding & Auth (01–14) (14 frames)

| Frame | Node ID | Size |
|---|---|---|
| 01 Splash | `292:280` | 360x800 |
| 02 Language Selection | `292:290` | 360x800 |
| 03 Onboarding 1 | `292:2570` | 360x800 |
| 04 Onboarding 2 | `299:12376` | 360x800 |
| 05 Onboarding 3 | `299:12393` | 360x800 |
| 06 Sign Up / Login | `292:309` | 360x800 |
| 07 OTP Verification | `292:323` | 360x800 |
| 08 Profile Setup | `292:371` | 360x800 |
| 09 Location – Division | `292:3355` | 360x800 |
| 10 Location – District | `292:3374` | 360x800 |
| 11 Location – Upazila | `292:3386` | 360x800 |
| 12 Location – Union, Village & Map Pin | `292:3405` | 360x823 |
| 13 Permissions | `292:2587` | 360x800 |
| 14 Role Selection | `292:347` | 360x800 |

### Farmer (15–70) (62 frames)

| Frame | Node ID | Size |
|---|---|---|
| 15 Farmer Home | `292:2169` | 360x1983 |
| 16 Notifications | `292:958` | 360x1655 |
| 17 Farmer Search | `292:4103` | 360x800 |
| 18 Sell Crop – Step 1 | `292:2030` | 360x800 |
| 19 Sell Crop – Step 2 | `292:2108` | 360x800 |
| 20 Sell Crop – Step 3 Review | `292:535` | 360x800 |
| 21 Success – Listing | `292:4322` | 360x800 |
| 22 My Listings | `292:519` | 360x800 |
| 23 Crop Details | `292:448` | 360x800 |
| 24 Buyer Offers | `292:472` | 360x800 |
| 25 Negotiate | `292:487` | 360x800 |
| 26 Success – Offer Accepted | `292:4326` | 360x800 |
| 27 Farmer – Buyer Business Profile | `292:3105` | 360x800 |
| 28 Marketplace | `292:429` | 360x800 |
| 29 Market Prices | `292:901` | 360x800 |
| 30 Price Trend | `292:925` | 360x800 |
| 31 Buyer Demands | `292:573` | 360x800 |
| 32 Demand Details | `292:586` | 360x800 |
| 33 Commit Supply (Sheet) | `292:622` | 360x800 |
| 34 Farmer – Market Opportunity Feed | `292:3065` | 360x800 |
| 35 Farmer – Production Planning | `292:3081` | 360x800 |
| 36 Global Buyers | `292:981` | 360x800 |
| 37 Export Guide & Documents | `292:991` | 360x800 |
| 38 Contracts | `292:637` | 360x800 |
| 39 Contract Details | `292:650` | 360x800 |
| 40 Orders | `292:683` | 360x800 |
| 41 Empty State | `292:409` | 360x800 |
| 42 Order Details | `292:696` | 360x800 |
| 42-P Order Details (Potato, PO-0918) | `500:6169` | 360x800 |
| 43 Order Details (Potato, In Transit) | `292:4148` | 360x800 |
| 44 Order Details (Rice, Completed) | `292:4173` | 360x800 |
| 45 Truck Coming (Booked by Buyer) | `292:721` | 360x800 |
| 45-P Truck Coming (PO-0918) | `500:6084` | 360x800 |
| 45-S Buyer's Own Vehicle Coming | `508:6640` | 360x800 |
| 46 Shipment Tracking | `292:2644` | 360x800 |
| 47 Shipment Tracking (After Load) | `292:4198` | 360x800 |
| 48 Farmer – Loaded & Paid | `292:3039` | 360x800 |
| 48-P Loaded & Paid (PO-0918) | `500:6115` | 360x800 |
| 49 Farmer – Partial Load Paid | `292:3858` | 360x800 |
| 50 Farmer – Load Cancelled | `292:3884` | 360x800 |
| 51 Farmer – Weight Less | `292:5044` | 360x800 |
| 52 Farmer – Weight More | `292:5070` | 360x800 |
| 52-A Weight More Approved | `500:6196` | 360x800 |
| 53 Delivery Confirmation | `292:752` | 360x800 |
| 54 Rate & Review | `292:774` | 360x800 |
| 55 Farmer – Surplus Rescue | `292:3128` | 360x800 |
| 56 Payments | `292:798` | 360x800 |
| 57 Payments (Tomato Paid) | `292:4330` | 360x800 |
| 58 Invoice / Receipt | `292:810` | 360x800 |
| 59 Receipt (Tomato) | `292:4219` | 360x800 |
| 59-P Receipt (PO-0918) | `500:6142` | 360x800 |
| 60 Receipt (Rice) | `292:4246` | 360x800 |
| 61 Receipt (Eggplant) | `292:4273` | 360x800 |
| 62 Farmer – Transaction History | `292:2717` | 360x952 |
| 63 Farmer – Statement / Export | `292:2737` | 360x800 |
| 64 Farmer – Share Track Record | `292:2766` | 360x806 |
| 65 Messages | `292:837` | 360x800 |
| 66 Chat / Voice Call | `292:845` | 360x800 |
| 67 Chat (Driver) | `292:4300` | 360x800 |
| 68 Profile | `292:867` | 360x1048 |
| 69 Verification (NID) | `292:884` | 360x800 |
| 70 Farmer – Ratings & Reviews | `292:3681` | 360x800 |

### Buyer (71–140) (66 frames)

| Frame | Node ID | Size |
|---|---|---|
| 71 Buyer Home | `292:2325` | 360x2419 |
| 72 Notifications | `292:1649` | 360x1176 |
| 73 Search | `292:2599` | 360x800 |
| 74 Marketplace | `292:1006` | 360x800 |
| 75 Crop Details | `292:2483` | 360x1715 |
| 76 Farmer Profile | `292:1026` | 360x800 |
| 77 Make Offer / Negotiate | `292:1041` | 360x800 |
| 78 Place Order | `292:1058` | 360x800 |
| 78-S Place Order (নিজে পরিবহন) | `508:6376` | 360x800 |
| 79 Buyer – Compare Freight Offers | `292:3337` | 360x800 |
| 80 Buyer – Transporter Profile | `292:3187` | 360x800 |
| 81 Buyer – Pickup Inspection Choice | `292:2988` | 360x800 |
| 82 Safe Payment | `292:1526` | 360x800 |
| 83 Compare Freight (Tomato) | `292:4342` | 360x800 |
| 84 Inspection Choice (No Inspector) | `292:4360` | 360x800 |
| 85 Safe Payment (Tomato) | `292:4385` | 360x800 |
| 85-S Safe Payment (নিজে পরিবহন) | `508:6408` | 360x800 |
| 86 Success – PO Paid | `292:4420` | 360x800 |
| 87 Success – Tomato Paid | `292:4424` | 360x800 |
| 96 Post Demand – Step 1 | `292:1090` | 360x800 |
| 97 Buyer – Quality Standard | `292:3143` | 360x800 |
| 98 Post Demand – Step 2 | `292:1110` | 360x800 |
| 99 Demand Offers / Compare | `292:1140` | 360x800 |
| 100 Procurement Dashboard | `292:1163` | 360x800 |
| 101 Buyer – Procurement Analytics | `292:3210` | 360x800 |
| 102 Multi-Farmer Matching | `292:1196` | 360x800 |
| 103 Digital Pooling | `292:1207` | 360x800 |
| 104 Purchase Order | `292:1230` | 360x800 |
| 105 Orders | `292:1259` | 360x800 |
| 106 Order Details | `292:1271` | 360x806 |
| 107 Order Details (No Inspector) | `292:4026` | 360x806 |
| 107-L Buyer – Confirm Load (নিজের গাড়ি) | `508:6470` | 360x800 |
| 107-S Order Details (নিজে পরিবহন) | `508:6443` | 360x806 |
| 108 Tracking | `292:2665` | 360x800 |
| 109 Buyer – Traceability Record | `292:3170` | 360x800 |
| 110 Delivery Confirmation | `292:1296` | 360x800 |
| 111 Rate & Review | `292:1322` | 360x800 |
| 112 Order Details (Onion, Completed) | `292:4428` | 360x806 |
| 113 Tracking (Tomato) | `292:4453` | 360x800 |
| 114 Delivery (Tomato) | `292:4475` | 360x800 |
| 115 Transport | `292:1463` | 360x800 |
| 116 Book Transporter | `292:1478` | 360x800 |
| 117 Assigned Transporter | `292:1490` | 360x800 |
| 118 Assigned Transporter (Tomato) | `292:4501` | 360x800 |
| 119 Suppliers | `292:1358` | 360x800 |
| 120 Supplier Profile | `292:1374` | 360x800 |
| 121 Contracts | `292:1402` | 360x800 |
| 122 Create Contract | `292:1417` | 360x800 |
| 123 Contract Status | `292:1438` | 360x800 |
| 124 Payments | `292:1513` | 360x800 |
| 125 Invoice / Receipt | `292:1561` | 360x800 |
| 126 Invoice (Tomato) | `292:4525` | 360x800 |
| 127 Invoice (Truck Fare) | `292:4552` | 360x800 |
| 128 Invoice (Onion) | `292:4579` | 360x800 |
| 129 Buyer – Transaction History | `292:2806` | 360x956 |
| 130 Buyer – Statement / Export | `292:2826` | 360x800 |
| 131 Buyer – Share Track Record | `292:2855` | 360x806 |
| 132 Buyer – Refund Status | `292:3759` | 360x800 |
| 133 Buyer – Weight Difference (Less) | `292:3788` | 360x800 |
| 134 Buyer – Extra Weight Approval | `292:3819` | 360x800 |
| 135 Messages | `292:1588` | 360x800 |
| 136 Chat / Voice Call | `292:1596` | 360x800 |
| 137 Chat (Driver) | `292:4606` | 360x800 |
| 138 Profile | `292:1618` | 360x1048 |
| 139 Business Verification | `292:1635` | 360x800 |
| 140 Buyer – Ratings & Reviews | `292:3700` | 360x800 |

### Buyer's Inspector (88–95) (13 frames)

| Frame | Node ID | Size |
|---|---|---|
| 88 Buyer's Inspector – Assigned Pickups | `292:3428` | 360x800 |
| 88-0 Inspector – Invitation (from Buyer) | `500:6366` | 360x800 |
| 89 Buyer's Inspector – Quality Check | `292:3449` | 360x800 |
| 90 Buyer's Inspector – Partial Load | `292:3910` | 360x800 |
| 91 Buyer's Inspector – Cancel Load | `292:3933` | 360x800 |
| 92 Buyer – Inspection Report | `292:3488` | 360x800 |
| 92-S Inspector – Report Sent (Approved) | `500:6398` | 360x800 |
| 93 Buyer – Inspection Report (Partial) | `292:3962` | 360x800 |
| 93-S Inspector – Report Sent (Partial) | `500:6432` | 360x800 |
| 94 Buyer – Inspection Report (Cancelled) | `292:3994` | 360x800 |
| 94-S Inspector – Report Sent (Cancelled) | `500:6466` | 360x800 |
| 95 Buyer – Load Record (No Inspector) | `292:5096` | 360x800 |
| 95-S Load Record (নিজের গাড়ি) | `508:6491` | 360x800 |

### Transporter (141–195) (63 frames)

| Frame | Node ID | Size |
|---|---|---|
| 141 Transporter Home | `292:2446` | 360x1434 |
| 142 Notifications | `292:1971` | 360x1071 |
| 143 Available Loads | `292:1673` | 360x800 |
| 144 Load Details | `292:1687` | 360x800 |
| 145 Transporter – Freight Offer | `292:3321` | 360x800 |
| 146 Load (Tomato) | `292:4628` | 360x800 |
| 147 Load (Rice) | `292:4655` | 360x800 |
| 148 Return Load (Fertilizer) | `292:4682` | 360x800 |
| 149 Return Load (Seed) | `292:4709` | 360x800 |
| 150 Shared Load (Onion) | `292:4736` | 360x800 |
| 151 Shared Load (Lentil) | `292:4763` | 360x800 |
| 152 My Jobs | `292:1715` | 360x800 |
| 153 Pickup Schedule | `292:1729` | 360x800 |
| 154 Pickup Schedule (Tomato Job) | `292:4790` | 360x800 |
| 155 Route Map | `292:1747` | 360x800 |
| 156 Navigation | `292:1778` | 360x800 |
| 157 Navigation (Stop 2) | `292:4806` | 360x800 |
| 157-3 Navigation (Stop 3) | `502:6262` | 360x800 |
| 158 Navigation (Return Load) | `292:4821` | 360x800 |
| 158-1 Return Pickup (Fertilizer) | `502:6361` | 360x800 |
| 158-2 Return Navigation (Delivery) | `502:6382` | 360x800 |
| 159 Trip Status | `292:1793` | 360x800 |
| 160 Trip Status (Pickups Done) | `292:4836` | 360x800 |
| 161 Transporter – Shared Truck Capacity | `292:3257` | 360x800 |
| 162 Pickup – Loading & Digital Weighing | `292:3014` | 360x800 |
| 162-2 Pickup – Stop 2 (Karim) | `502:6237` | 360x800 |
| 162-3 Pickup – Stop 3 (Salma) | `502:6277` | 360x800 |
| 163 Pickup (No Inspector) | `292:4851` | 360x800 |
| 164 Pickup (Partial Load) | `292:5125` | 360x800 |
| 165 Pickup (Waiting for Buyer) | `292:5149` | 360x800 |
| 166 Transporter – Load Cancelled at Pickup | `292:4051` | 360x800 |
| 166-B Order Cancelled by Buyer (KS-1048) | `502:6518` | 360x800 |
| 167 Proof of Delivery | `292:1808` | 360x800 |
| 168 Trip Complete + Return Load | `292:2687` | 360x800 |
| 169 Rate & Review | `292:1820` | 360x800 |
| 170 Navigation (KS-1048) | `292:5175` | 360x800 |
| 171 Trip Status (KS-1048) | `292:5190` | 360x800 |
| 172 Proof of Delivery (KS-1048) | `292:5202` | 360x800 |
| 172-R Return Proof of Delivery | `502:6397` | 360x800 |
| 173 Trip Complete (KS-1048) | `292:5214` | 360x800 |
| 173-R Return Trip Complete | `502:6409` | 360x800 |
| 174 Return Loads | `292:1844` | 360x800 |
| 175 Set Return Route (Sheet) | `292:2701` | 360x800 |
| 176 Transporter – No Return Load Found | `292:3276` | 360x800 |
| 177 Transporter – Return Load Confirmed | `292:3296` | 360x800 |
| 178 Earnings | `292:1855` | 360x800 |
| 179 Earnings (Fare Paid) | `292:4872` | 360x800 |
| 180 Payment Secured | `292:1874` | 360x800 |
| 181 Fare Receipt (PO-0918) | `292:4892` | 360x800 |
| 182 Fare Receipt (Tomato) | `292:4919` | 360x800 |
| 183 Fare Receipt (Return) | `292:4946` | 360x800 |
| 184 Fare Receipt (Rice) | `292:4973` | 360x800 |
| 185 Fare Receipt (KS-1048) | `292:5228` | 360x800 |
| 186 Transporter – Transaction History | `292:2895` | 360x915 |
| 187 Transporter – Statement / Export | `292:2915` | 360x800 |
| 188 Transporter – Share Track Record | `292:2944` | 360x806 |
| 189 Messages | `292:1889` | 360x800 |
| 190 Chat / Voice Call | `292:1897` | 360x800 |
| 191 Chat (Buyer) | `292:5000` | 360x800 |
| 192 Chat (Farmer Karim) | `292:5022` | 360x800 |
| 193 Profile | `292:1919` | 360x961 |
| 194 Vehicle & Capacity | `292:1935` | 360x800 |
| 195 Verification & Ratings | `292:1949` | 360x800 |

### Shared — Common (196–220) (27 frames)

| Frame | Node ID | Size |
|---|---|---|
| 196 Language Bottom Sheet | `292:1993` | 360x800 |
| 196-F1 Language Sheet (Farmer · বাংলা) | `459:6094` | 360x800 |
| 196-F2 Language Sheet (Farmer · English) | `459:6113` | 360x800 |
| 197 Payment Methods | `292:3520` | 360x800 |
| 198 Add Payment Method | `292:3531` | 360x800 |
| 199 Add Mobile Wallet | `292:3562` | 360x800 |
| 200 Verify Wallet (OTP + Name) | `292:3573` | 360x800 |
| 201 Add Bank Account | `292:3601` | 360x800 |
| 202 Report Issue / Dispute | `292:2136` | 360x831.4000244140625 |
| 203 Report Issue (No Inspector) | `292:4077` | 360x800 |
| 204 Report Issue (General) | `371:6017` | 360x800 |
| 205 Help & Support | `292:2156` | 360x800 |
| 206 Help – FAQ Answer | `292:3642` | 360x800 |
| 207 Document Viewer | `292:3662` | 360x800 |
| 208 Support Chat | `292:4126` | 360x800 |
| 209 Success – Farmer | `292:385` | 360x800 |
| 210 Success – Buyer | `292:4095` | 360x800 |
| 211 Success – Transporter | `292:4099` | 360x800 |
| 212 Error Screen | `292:389` | 360x800 |
| 213 Confirmation Dialog | `292:399` | 360x800 |
| 214 No Internet | `292:420` | 360x800 |
| 215 Loading (Skeleton) | `292:2622` | 360x800 |
| 216 Chat – Attach File (Sheet) | `412:6115` | 360x800 |
| 217 Video Call (buyer) | `412:6142` | 360x800 |
| 218 Video Call (driver) | `412:6167` | 360x800 |
| 219 Video Call (abdul) | `412:6192` | 360x800 |
| 220 Video Call (karim) | `412:6217` | 360x800 |

### English samples (3 frames)

| Frame | Node ID | Size |
|---|---|---|
| 13-EN Farmer Home (English) | `292:2247` | 360x1963 |
| 15-EN Sell Crop – Step 1 (English) | `292:2069` | 360x800 |
| 24-EN Market Prices (English) | `292:2012` | 360x800 |

### Dialogs, Toasts, Voice (D/T/V) (15 frames)

| Frame | Node ID | Size |
|---|---|---|
| D1 Confirm – Reject Offer | `292:3612` | 312x243 |
| D2 Confirm – Reject Contract | `292:3635` | 312x243 |
| D3 Confirm – Cancel Contract | `292:3619` | 312x243 |
| D4 Confirm – Logout | `292:3626` | 312x243 |
| D5 Confirm – Cancel Order | `292:3851` | 312x285 |
| D6 Confirm – Cancel Load | `292:3955` | 312x243 |
| T1 Toast – Price Alert Set | `292:2715` | 360x84 |
| T2 Toast – Added to Favourites | `292:3633` | 360x84 |
| T3 Toast – Link Copied | `292:2984` | 360x84 |
| T4 Toast – Statement Downloaded | `292:2986` | 360x84 |
| T5 Toast – Report Sent | `371:6035` | 360x84 |
| T6 Toast – File Sent | `412:6134` | 360x84 |
| T7 Toast – Message Sent | `527:9272` | 360x84 |
| V1 Voice Search (শুনছি) | `527:9277` | 360x800 |
| V2 Voice Message (রেকর্ড হচ্ছে) | `527:9301` | 360x800 |
