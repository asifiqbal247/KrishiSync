# KrishiSync — Plan

## Current status (2026-11-14)
- **Tier A: built and E2E-tested on emulator.** Parts 1–7 done, Part 8 mostly done.
- **Part 7 (tested):** Report Issue 203/204 → Moderator Reports M4/M5 (resolve with note → reporter notified); Safe Payment 82 (placeholder) between 78 and order; NID verification M6 (user with NID → moderator verifies → notified, verified badge); Admin A1 dashboard (count queries), A2 users search/filter, A3 suspend/activate + change role, A4 moderation hub, A5 market prices (feeds home price cards + listing ranges), A6 crop catalog (new crops appear in Sell Crop; on/off). Self-transport flow tested (farmer handed over → buyer received → rate → completed).
- **Part 8 (done):** profiles 68/138/193 with real data, 196 language sheet, D4 logout confirm, 215 skeletons, English plural-safe strings, Golaghor launcher icon (Android 12 launch screen uses it), release APK builds and runs (signed with debug key — fine for demo install).
- **Test accounts:** 01700000001 farmer (Abdul Rahman), …02 buyer (Farhan Ahmed), …03 transporter (Kamal Hossain), …04 moderator (Rafiq), …05 admin (Tonmoy Admin). OTP 123456.
- **Demo data (2026-11-15):** farmers Karim Mia (…06, Mymensingh: potato 2 t, onion 1.5 t), Salma Begum (…07, Dinajpur: rice 5 t), Rahim Uddin (…08, Bagerhat: eggplant 800 kg) + Abdul Rahman tomato — all approved. Market prices set for all 7 crops.
- **Tier B done (2026-11-15):** 29 Market Prices + 30 Price Trend (daily history in marketPrices/{crop}/history; admin can enter past days), 56/124 Payments, 58/125 Receipts, 178 Earnings tab. Login: +880 on the left, Terms & Privacy page. Tomato has 7 days of demo history.
- **2026-11-15 (later):** verification upload 69/139/195, ratings 70/140, tracking 108, farmer Market tab 28 + Search 17 (shared screens), buyer profile 27, cancel order D5 (stock back, 10% fare fee recorded), edit profile, searchable route list, **Buyer Demands** (96/98 post, buyer list, 99 accept → real orders through the normal truck/OTP/rating flow; farmer 31 list, 32 details with pooling progress, 33 commit). Phone testing pending.
- **Next step:** Asif tests on phone; then remaining Tier C (chat, contracts, live GPS, push alerts, PDF).

## Timeline — defence in 12 days (~2026-11-25)
Work is clustered into **Parts**. Each Part ends with a runnable app, a commit and a push.

| Part | Days | Content | Tier |
|---|---|---|---|
| 1 | 1–2 | Foundation: project, git, Firebase, rules, E2E test, theme, fonts, assets, l10n, shared widgets, router | — |
| 2 | 3 | Auth: splash, language, onboarding, login, OTP, role, profile + location + photo | A |
| 3 | 4–5 | Farmer listings (sell crop 1–3, photos, my listings, details) **+ Moderator listing approval (M1–M3)**, because listings stay `pending` until approved | A |
| 4 | 5–6 | Buyer: home, marketplace, search/filter, crop details, farmer profile | A |
| 5 | 6–7 | Offers & orders + notifications (farmer + buyer sides) | A |
| 6 | 8–9 | Transport: book, loads, freight offer, jobs, trip status, proof of delivery, delivery confirmation, ratings | A |
| 7 | 9–10 | Admin A1–A7, Moderator M4–M7, Payment UI + `PaymentService` placeholder | A |
| 8 | 10–11 | Map pin, home dashboards finished, bilingual + polish pass, seed data, release APK | A |
| — | 12 | Buffer, full demo rehearsal, fixes only | — |
| 9+ | after defence | Tier B, then Tier C, in the same Part style | B, C |

## Spark plan limits (billing card error OR_BACR2_59, so no Blaze for now)
- **Phone OTP:** Spark sends **no real SMS**. We use **Firebase test phone numbers** (fixed number + fixed code, no SMS sent). This works on Spark. For the defence, demo accounts use test numbers. Real SMS needs Blaze later; the code does not change.
- **Firebase Storage:** not available on Spark. Image upload goes through an `ImageStorageService` interface so the backend can be swapped later. Implementation: **pending Asif's choice** (Cloudinary free tier recommended).
- **Firestore:** works on Spark (1 GiB stored, 50k reads / 20k writes / 20k deletes per day). Enough for the demo.
- **Cloud Functions:** not available on Spark. Not used.

---

## Scope problem (important)
The Figma has **263 screen frames**. Many are variants of the same screen (e.g. "Order Details (Rice)", "Receipt (Tomato)"), so we build **one screen + real data** for each group. Even so, there are ~90 unique screens. That is too much to build *and* test well in a few days.

So the work is split into tiers. **Tier A = the full end-to-end demo chain.** Tier B and C are added only if time allows. Every tier keeps the app fully working.

### Tier A — Must demo (core chain, ~40 screens)
Farmer lists crop → Buyer finds it and orders → Buyer books transport → Transporter accepts, picks up, delivers → both rate → Admin/Moderator manage.

**Shared / Auth**
| # | Screen | Figma |
|---|---|---|
| 01 | Splash | `292:280` |
| 02 | Language Selection | `292:290` |
| 03–05 | Onboarding 1–3 | `292:2570`, `299:12376`, `299:12393` |
| 06 | Sign Up / Login (phone) | `292:309` |
| 07 | OTP Verification | `292:323` |
| 14 | Role Selection | `292:347` |
| 08 | Profile Setup (+ photo upload) | `292:371` |
| 09–12 | Location: Division → District → Upazila → Union/Village + Map Pin | `292:3355`, `292:3374`, `292:3386`, `292:3405` |
| 196 | Language Bottom Sheet | `292:1993` |
| 209–211 | Success (Farmer / Buyer / Transporter) | `292:385`, `292:4095`, `292:4099` |
| 41, 212, 214, 215 | Empty, Error, No Internet, Loading skeleton | `292:409`, `292:389`, `292:420`, `292:2622` |
| D4 | Confirm Logout | `292:3626` |

**Farmer**
| # | Screen | Figma |
|---|---|---|
| 15 | Farmer Home | `292:2169` |
| 18–20 | Sell Crop Step 1–3 (crop, grade, qty, photo → price, date, pickup → review) | `292:2030`, `292:2108`, `292:535` |
| 21 | Success – Listing | `292:4322` |
| 22 | My Listings | `292:519` |
| 23 | Crop (listing) Details | `292:448` |
| 24, 25, D1, 26 | Buyer Offers, Negotiate, Reject dialog, Offer Accepted | `292:472`, `292:487`, `292:3612`, `292:4326` |
| 40, 42 | Orders, Order Details | `292:683`, `292:696` |
| 16 | Notifications | `292:958` |
| 68 | Profile | `292:867` |

**Buyer**
| # | Screen | Figma |
|---|---|---|
| 71 | Buyer Home | `292:2325` |
| 74, 73 | Marketplace, Search (+ filter) | `292:1006`, `292:2599` |
| 75, 76 | Crop Details, Farmer Profile | `292:2483`, `292:1026` |
| 77 | Make Offer / Negotiate | `292:1041` |
| 78 | Place Order | `292:1058` |
| 115, 116, 117 | Transport, Book Transporter, Assigned Transporter | `292:1463`, `292:1478`, `292:1490` |
| 82 | Safe Payment (**UI + placeholder only**) | `292:1526` |
| 105, 106 | Orders, Order Details | `292:1259`, `292:1271` |
| 110, 111 | Delivery Confirmation, Rate & Review | `292:1296`, `292:1322` |
| 72, 138 | Notifications, Profile | `292:1649`, `292:1618` |

**Transporter**
| # | Screen | Figma |
|---|---|---|
| 141 | Transporter Home | `292:2446` |
| 143, 144, 145 | Available Loads, Load Details, Freight Offer | `292:1673`, `292:1687`, `292:3321` |
| 152, 153 | My Jobs, Pickup Schedule | `292:1715`, `292:1729` |
| 159 | Trip Status (picked up → in transit → delivered) | `292:1793` |
| 167, 168 | Proof of Delivery (photo upload), Trip Complete | `292:1808`, `292:2687` |
| 169 | Rate & Review | `292:1820` |
| 142, 193, 194 | Notifications, Profile, Vehicle & Capacity | `292:1971`, `292:1919`, `292:1935` |

**Admin & Moderator (new, same theme)** — see list below.

### Tier B — Strong extras (if time allows)
- Market Prices + Price Trend (29, 30, 24-EN) — data entered by Admin.
- Shipment Tracking / Tracking with map (46, 108, 155 Route Map).
- Pickup – Loading & Digital Weighing (162), Truck Coming (45), Loaded & Paid (48).
- Payments list, Invoice/Receipt (56, 58, 124, 125, 178 Earnings) — from order data; payment status is placeholder.
- Payment Methods UI (197–201) — UI only.
- NID / Business Verification upload (69, 139, 195) → reviewed by Moderator.
- Report Issue (202–204) → feeds Moderator reports queue.
- Ratings & Reviews lists (70, 140).

### Tier C — Later / version 2 (not planned now)
Buyer demands & offers compare (31–33, 96–99), contracts (38–39, 121–123, D2, D3), procurement / pooling / multi-farmer matching / purchase order (100–104), buyer's inspector (88–95), return loads & shared truck (161, 174–177), chat / voice / video call (65–67, 135–137, 189–192, 216–220, V2), export (36–37), production planning & opportunity feed (34–35), surplus rescue (55), traceability (109), transaction history / statement / share (62–64, 129–131, 186–188), weight difference & refund flows (51, 52, 132–134), partial/cancel variants, help/FAQ/support chat (205–208), voice search (V1).

---

## Admin & Moderator screens (proposal — NOT in Figma)
Same theme: same colors, Hind Siliguri, App Bar, List Item, Stat Card, Chip, Button, Modal, Toast components. Admin and moderator accounts log in with phone OTP like everyone else, but their role is set **only by an Admin** (never self-selected).

**Moderator** (bottom nav: Home · Listings · Reports · Verify · Profile)
| ID | Screen | Purpose |
|---|---|---|
| M1 | Moderator Home | Stat cards: pending listings, open reports, pending verifications |
| M2 | Listings Queue | List of listings (filter: pending / active / hidden) |
| M3 | Listing Review | Photos + details → Approve / Hide (with reason) |
| M4 | Reports Queue | Open reports list (filter by status) |
| M5 | Report Detail | Reason, target, photos → Resolve / Dismiss / Hide listing / Escalate to Admin |
| M6 | Verification Queue + Review | NID / business docs → Verify / Reject |
| M7 | Profile | Language, logout |

**Admin** (everything Moderator has, plus:) (bottom nav: Home · Users · Moderation · Prices · Profile)
| ID | Screen | Purpose |
|---|---|---|
| A1 | Admin Dashboard | Totals: users by role, active listings, orders by status, open reports |
| A2 | Users | Search by name/phone, filter by role/status |
| A3 | User Detail | Profile, stats → Suspend / Activate, change role (make Moderator/Admin) |
| A4 | Moderation | Opens M2–M6 screens |
| A5 | Market Prices Manager | Set daily price per crop (feeds Market Prices screen) |
| A6 | Crop Catalog | Add/edit crops (name bn/en, category, image) |
| A7 | Profile | Language, logout |

---

## Firestore data model (DRAFT — confirm before coding)
No Cloud Functions in the plan. Counters/ratings use client transactions; security rules validate every write.

```
users/{uid}
  role: farmer | buyer | transporter | moderator | admin
  name, phone, photoUrl, language: bn | en
  location: { division, district, upazila, union, village, geo: GeoPoint? }
  nidNumber?, verification: none | pending | verified | rejected, verificationDocs[]
  status: active | suspended
  ratingAvg, ratingCount
  buyer:       { businessName? }
  transporter: { vehicleType, plateNo, capacityKg }
  createdAt, updatedAt

crops/{cropKey}            // catalog, admin-managed
  nameBn, nameEn, category: vegetable | fruit | grain | ..., imageAsset, active

listings/{id}
  farmerId, farmerName, farmerPhotoUrl, farmerDistrict   // denormalized for lists
  cropKey, cropNameBn, cropNameEn, category
  grade: A | B | C, quantityKg, availableKg, pricePerKg (BDT)
  availableFrom (Timestamp), pickup: { text, district, upazila, geo: GeoPoint }
  photos: [storage URLs] (max 3)
  status: pending | active | sold | hidden | expired
  createdAt, updatedAt

offers/{id}
  listingId, farmerId, buyerId, buyerName
  pricePerKg, quantityKg, note
  status: pending | countered | accepted | rejected | withdrawn
  lastBy: farmer | buyer, history: [{by, pricePerKg, quantityKg, at}]
  createdAt, updatedAt

orders/{id}
  orderNo: "KS-1048" (from counters/orders in a transaction)
  listingId, offerId?, farmerId, buyerId, transporterId?
  crop snapshot { cropKey, nameBn, nameEn, grade, photoUrl }
  quantityKg, pricePerKg, totalBDT
  transportMode: platform | self
  pickup {..}, dropoff { text, district, geo }
  status: placed | confirmed | transport_booked | picked_up | in_transit | delivered | completed | cancelled
  paymentStatus: unpaid | paid_placeholder
  timeline: [{status, at, by}]
  createdAt, updatedAt

deliveries/{id}                 // one per order that needs a truck ("loads")
  orderId, orderNo, buyerId, farmerId, transporterId?
  pickup, dropoff, weightKg, cropNameBn, cropNameEn
  status: open | assigned | picked_up | in_transit | delivered | cancelled
  fareBDT?, proofPhotoUrl?, loadedWeightKg?
  createdAt, updatedAt
deliveries/{id}/freightOffers/{transporterId}
  transporterName, vehicleType, fareBDT, etaText, status: pending | accepted | rejected

reviews/{id}       orderId, fromUid, toUid, toRole, stars(1–5), tags[], comment, createdAt
reports/{id}       reporterId, targetType: listing | user | order, targetId, reason, details, photos[],
                   status: open | in_review | resolved | dismissed, handledBy, action, createdAt
notifications/{uid}/items/{id}   type, params{}, link, read, createdAt  (text built from ARB keys)
marketPrices/{cropKey}           todayPrice, prevPrice, unit: kg, history: [{date, price}], updatedBy
payments/{id}      orderId, payerId, amount, method: placeholder, status: placeholder_paid, createdAt
counters/orders    next: int
```

**Storage paths:** `users/{uid}/profile.jpg`, `listings/{listingId}/{n}.jpg`, `deliveries/{id}/proof.jpg`, `verifications/{uid}/{file}`, `reports/{id}/{n}.jpg`. Images compressed before upload (≤ ~300 KB).

**Composite indexes (initial):**
- listings: `status + createdAt desc`, `status + cropKey + createdAt desc`, `status + category + createdAt desc`, `farmerId + createdAt desc`
- offers: `farmerId + createdAt desc`, `buyerId + createdAt desc`, `listingId + createdAt desc`
- orders: `buyerId + createdAt desc`, `farmerId + createdAt desc`, `transporterId + status`
- deliveries: `status + createdAt desc`, `transporterId + status`
- reports: `status + createdAt desc`

**Search:** Firestore has no full-text search. Plan: filter by crop/category/district/price on the server, then simple text match on the client. Good enough for the demo.

**Rules summary:** a user can only edit their own profile and cannot change their own `role` (except the one-time choice farmer/buyer/transporter at signup) or `status`. Farmers create/edit only their own listings. Buyers create offers/orders as themselves. Transporters update only deliveries assigned to them. Moderators can change listing/report/verification status. Admins can do everything. Suspended users are blocked from writes.

**Seed data:** a debug-only "Seed sample data" button (visible only to Admin in debug builds) writes crops, market prices and sample listings into real Firestore. No service-account key needed. Plus a doc listing test phone numbers per role.

---

## Packages (to confirm in Phase 1 — each with a reason)
| Package | Why |
|---|---|
| firebase_core, firebase_auth, cloud_firestore, firebase_storage | Backend |
| flutter_riverpod | State management (required) |
| go_router | Navigation + role redirects (required) |
| flutter_localizations, intl | Bangla/English, number/date format |
| shared_preferences | Remember chosen language before login |
| image_picker | Take/choose crop & profile photos |
| flutter_image_compress | Shrink photos before upload (saves Storage + data) |
| cached_network_image | Fast image lists with caching |
| flutter_svg | Figma SVG icons |
| connectivity_plus | Show "No Internet" screen (214) |
| flutter_map + latlong2 *(if OSM chosen)* | Map pin for pickup |
| geolocator | "Use my location" on map pin |
| url_launcher | Call farmer/driver, open Google Maps for navigation |

---

## Phases & checklist

### Phase 0 — Planning
- [x] Inspect Figma (pages, frames, tokens, components, assets)
- [x] CLAUDE.md, DESIGN.md, PLAN.md
- [x] Asif answers questions
- [x] Asif approves plan, scope tier, data model, admin/mod screen list

### Phase 1 — Foundation
- [x] 1.1 `flutter create` (com.asif.krishisync), git init, remote, first commit — **push pending (403)**
- [~] 1.2 Firebase: `flutterfire configure` ✅ — Asif: create Firestore DB, enable Phone, add test numbers, SHA keys
- [~] 1.3 Rules + indexes files written ✅ — deploy after DB exists (`firebase deploy --only firestore`)
- [ ] 1.4 End-to-end test: test-phone login → users doc → profile photo to Cloudinary
- [x] 1.5 Theme, fonts, assets (icons, images, nav icons, BD locations)
- [x] 1.6 Localization scaffold (bn default, en), language switch provider
- [~] 1.7 Shared widgets — done: app bar, buttons (primary/text), input, select, option card, upload box, dots, list item, pill, search bar. Todo: outline button, stat card, action tile, section header, modal, toast, bottom navs, state screens (with Part 3)
- [x] 1.8 go_router with role redirects

### Part 3 design already pulled (ready to build)
15 Farmer Home (+ nav icons on/off, glyph icons, tip/banner art), 18–20 Sell Crop, 21 Success modal, 22 My Listings, 23 Crop Details, HF/List Item / Status (badge).

### Phase 2 — Vertical slices (Tier A)
- [x] 2.1 Auth: splash, language, onboarding, login, OTP, role, profile + location + photo
- [x] 2.2 Farmer: home, sell crop 1–3 with photo upload, my listings, listing details
- [x] 2.3 Buyer: home, marketplace, search/filter, crop details, farmer profile
- [ ] 2.4 Offers & orders: make offer, negotiate, accept/reject, place order, orders lists/details, notifications
- [ ] 2.5 Transport: book transporter, loads, freight offer, assigned, jobs, trip status, proof of delivery, delivery confirmation, ratings
- [ ] 2.6 Payment UI + `PaymentService` placeholder
- [ ] 2.7 Admin & Moderator screens + rules
- [ ] 2.8 Map pickup pin
- [ ] 2.9 Bilingual + polish pass, all states, seed data
- [ ] 2.10 Release APK (signing key kept out of git)

### Phase 3 — Tier B items (if time)

---

## Decisions log
| Date | Decision |
|---|---|
| 2026-11-13 | Figma variable values are the color truth (swatch labels differ). |
| 2026-11-13 | Real SMS OTP **and** Firebase Storage need the Blaze plan (checked Nov 2026). Use Firebase test phone numbers during development. |
| 2026-11-13 | Plan approved. Tier A is must-have; full project continues after defence in Parts. |
| 2026-11-13 | Staying on **Spark** (billing card error). Test phone numbers for OTP; images via swappable `ImageStorageService`. |
| 2026-11-13 | Package name `com.asif.krishisync`. |
| 2026-11-13 | Map: flutter_map + OpenStreetMap for pickup pin; navigation opens the Google Maps app. |
| 2026-11-13 | New listings start `pending`; a Moderator approves → `active`. Moderator listing review moved into Part 3. |
| 2026-11-13 | Admin/Moderator screens M1–M7 and A1–A7 approved. Admin types daily market prices. |
| 2026-11-13 | Data model approved with no changes. |
| 2026-11-13 | Bundle a free Bangladesh location JSON (source + license to be reported when added). |
| 2026-11-13 | Testing on Android Studio emulator. |
| 2026-11-13 | `google-services.json` and `firebase_options.dart` are git-ignored, never committed. |
| 2026-11-13 | Package list approved. |
| 2026-11-14 | App name is **Golaghor** (splash, app title, Android launcher label). Package id stays `com.asif.krishisync`. Uses Figma logo HF/Logo/Golaghor. |
| 2026-11-14 | Screen 21 text changed (approval flow): bn "মডারেটর অনুমোদনের পর ক্রেতারা আপনার ফসল দেখতে ও অফার দিতে পারবেন।", en "Buyers can see your crop and make offers after a moderator approves it." |
| 2026-11-14 | My Listings (22): pending listings shown under "চলমান" with an "অনুমোদনের অপেক্ষায়" badge, using Figma HF/List Item / Status (319:26). |
| 2026-11-14 | Mic icons stay visible and tappable; tap shows the Figma HF/Toast with "শীঘ্রই আসছে" / "Coming soon" (ARB key `comingSoon`). Real voice search = Tier C (needs a speech package, ask first). |
| 2026-11-14 | Back on Login (reached by redirect, no history) returns to onboarding. Default app-bar back uses go_router `canPop/pop`. |
| 2026-11-14 | My Listings tabs: চলমান = pending + active, বিক্রিত = sold, খসড়া = rejected by moderator (status `hidden`, shows the moderator note). |
| 2026-11-14 | Sell Crop: 1 photo per listing (Figma has one upload box); crop chips from bundled catalog + "অন্যান্য" with typed name. |
| 2026-11-14 | Gradle memory lowered (3G heap / 1G metaspace), Kotlin in-process, incremental off — PC has 16 GB and runs the emulator. Don't run two Gradle builds at once. |
| 2026-11-14 | Order numbers `KS-1048`, `KS-1049`… from `counters/orders` (+1 per order in a transaction). Platform fee 1%. Platform transport fare estimate = ৳1500 + ৳20/km, rounded to ৳100 (until Part 6 real bids). |
| 2026-11-14 | Buyer can lower a listing's `availableKg` only while ordering (rules); listing becomes `sold` at 0. Offers valid 24 h. |
| 2026-11-14 | Orders empty state (41) for buyers: Figma only has the farmer version, so buyer text is "বাজার থেকে পছন্দের ফসল অর্ডার করুন।" + "বাজার দেখুন" (opens Market tab). Same layout. |
| 2026-11-14 | Transport booking = bids: a platform-truck order opens a delivery ("load"). Transporters accept at the suggested fare or send their own fare (145). Buyer sees bids on 116 and books one → 117. |
| 2026-11-14 | One order = one pickup + one delivery (no pooling). "Return load" sections show real open loads that start in the driver's drop district; hidden when none. Pill "একাধিক পিকআপ" kept (Figma) but shows empty state (pooling = Tier C). |
| 2026-11-14 | Delivery confirmation: buyer sees a 4-digit OTP (stored in `deliveries/{id}/private/otp`, readable only by the buyer). Driver enters it (+ optional photo) on 167; Firestore rules compare the code. Then buyer rates farmer + driver (111), driver rates buyer (169). |
| 2026-11-14 | Self-transport orders: farmer taps "handed over" (pickedUp), buyer taps "received" (delivered) → buyer rates farmer → completed. |
| 2026-11-14 | Reports: user reasons from Figma 203/204 (driver behaviour, late delivery, app problem, other); moderator can resolve/dismiss with a note or escalate to admin. |
| 2026-11-14 | Admin A6: crops collection overrides bundled catalog (on/off) and adds new crops; Sell Crop shows Figma chips + admin-added crops. |
| 2026-11-14 | Profile rows for Tier B/C features (contracts, payment methods, help, share track record, edit profile) are visible as in Figma and show "শীঘ্রই আসছে". |
| 2026-11-15 | Market prices are national wholesale prices (admin enters one per crop), so the district pills on 29 are left out. Price alert button shows "শীঘ্রই আসছে" (needs push notifications). PDF download on receipts = Tier C. |
| 2026-11-15 | Buyer demands: every farmer supplies at the buyer's target price; buyer accepts commitments → one platform-truck order per farmer (placeholder payment). Quality-standard screen 97 and future-harvest commitments are Tier C. Buyer home "সংগ্রহ ড্যাশবোর্ড" opens the buyer's demand list. |
