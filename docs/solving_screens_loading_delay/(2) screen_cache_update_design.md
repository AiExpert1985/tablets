# Screen Cache Update on Transaction Changes

## Document Purpose
This document describes the design and implementation of real-time screen cache updates when transactions are added, edited, or deleted. It serves as a reference for the development team and AI assistants working on this codebase.

---

## Table of Contents
1. [Problem Statement](#problem-statement)
2. [Background Context](#background-context)
3. [Solution Approaches Considered](#solution-approaches-considered)
4. [Obstacles Encountered](#obstacles-encountered)
5. [Final Solution](#final-solution)
6. [Design Decisions](#design-decisions)
7. [Implementation Details](#implementation-details)
8. [Testing](#testing)
9. [Future Considerations](#future-considerations)

---

## Problem Statement

### The Issue
When a user adds, edits, or deletes a transaction, the screen data for affected entities (customers, products, salesmen) in Firebase was **not being updated**. This caused:
- Stale data displayed on customer/product/salesman screens
- Incorrect debt, quantity, and profit calculations
- Users had to wait for daily reconciliation (24+ hours) for data to sync

### Expected Behavior
After any transaction change, the affected entities' screen data should be immediately recalculated and saved to Firebase cache collections:
- `customer_screen_data`
- `product_screen_data`
- `salesman_screen_data`

### Scope
Only entities **affected by the transaction** should be updated, not all entities. For example:
- If a transaction involves Customer A and Products X, Y, Z → only those 4 entities should be updated
- If editing a transaction changes customer from A to B → both A and B should be updated

---

## Background Context

### Existing Architecture
The app uses a caching system to improve performance:

1. **DbCache**: Local mirror of Firebase raw data (customers, products, transactions, etc.)
2. **ScreenDataNotifier**: Holds calculated screen data for each feature
3. **Screen Cache Collections**: Firebase collections storing pre-calculated screen data for fast loading

### Existing Methods
Each screen controller has:
- `setFeatureScreenData(BuildContext context)`: Recalculates data for **ALL** entities
- `getItemScreenData(BuildContext context, Map<String, dynamic> rawData)`: Recalculates data for a **SINGLE** entity

### The Challenge
- `setFeatureScreenData` is too slow (recalculates everything)
- `getItemScreenData` requires `BuildContext` for translations
- After delete, navigation happens which invalidates the widget's `BuildContext`

---

## Solution Approaches Considered

### Approach 1: Read from Notifiers (Rejected)
**Idea**: After transaction change, call `setFeatureScreenData` for all screens, then read from notifiers.

**Why Rejected**: 
- Recalculates ALL entities (thousands), not just affected ones
- Defeats the purpose of minimal updates

### Approach 2: Use getItemScreenData with Context (Failed)
**Idea**: Call `getItemScreenData` for each affected entity inside async `onTransactionChanged`.

**Why Failed**:
- For delete transactions, navigation happens immediately after
- Navigation invalidates the widget's `BuildContext`
- Error: "Looking up a deactivated widget's ancestor is unsafe"

### Approach 3: Remove context.mounted Checks (Failed)
**Idea**: Remove safety checks and let the async code run.

**Why Failed**:
- Context was already invalid when async code ran
- Same error as Approach 2

### Approach 4: Pre-Calculate Sync, Save Async (Final Solution ✅)
**Idea**: 
1. Calculate synchronously while context is valid (before navigation)
2. Save to Firebase asynchronously (after navigation, no context needed)

**Why It Works**:
- Calculations complete before context becomes invalid
- Only affected entities are calculated
- Async save doesn't require context

---

## Obstacles Encountered

### Obstacle 1: Stale Notifier Data
**Problem**: `ScreenCacheUpdateService` was reading from notifiers that hadn't been refreshed.

**Root Cause**: Only `transactionScreenController.setFeatureScreenData()` was called, not the customer/product/salesman controllers.

**Solution**: Don't rely on notifiers; use `getItemScreenData` directly with raw data from `DbCache`.

### Obstacle 2: Context Deactivation
**Problem**: After delete transaction, the widget navigates to the previous transaction, which deactivates the original widget's context.

**Error Message**:
```
Looking up a deactivated widget's ancestor is unsafe.
At this point the state of the widget's element tree is no longer stable.
```

**Root Cause**: `getItemScreenData` uses `translateDbTextToScreenText(context, ...)` for translations, which requires a valid `BuildContext`.

**Solution**: Complete all context-dependent calculations **synchronously** before navigation, then run async save.

### Obstacle 3: Salesman getItemScreenData Not Implemented
**Problem**: `SalesmanScreenController.getItemScreenData()` was returning an empty map `{}`.

**Solution**: Implemented the method using existing static helper methods (`_getSalesmanScreenData`).

---

## Final Solution

### Architecture
```
Transaction Change (Add/Edit/Delete)
         │
         ▼
┌─────────────────────────────────────────┐
│  1. Update transactionDbCache           │
│  2. setFeatureScreenData (transaction)  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  PHASE 1: calculateAffectedEntities     │  ◄── SYNCHRONOUS
│  (while BuildContext is valid)          │      (before navigation)
│                                         │
│  • Extract affected dbRefs (using Sets) │
│  • productController.getItemScreenData  │
│  • customerController.getItemScreenData │
│  • salesmanController.getItemScreenData │
│  • Return PreCalculatedCacheData        │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  Navigation (for delete)                │  ◄── Context may become
│  or return (for add/edit)               │      invalid after this
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  PHASE 2: savePreCalculatedData         │  ◄── ASYNCHRONOUS
│  (no BuildContext needed)               │      (Future.delayed)
│                                         │
│  • Save to product_screen_data          │
│  • Save to customer_screen_data         │
│  • Save to salesman_screen_data         │
└─────────────────────────────────────────┘
```

### Key Classes

#### PreCalculatedCacheData
```dart
class PreCalculatedCacheData {
  final List<Map<String, dynamic>> customerData;
  final List<Map<String, dynamic>> productData;
  final List<Map<String, dynamic>> salesmanData;
}
```

#### ScreenCacheUpdateService Methods
- `calculateAffectedEntities(context, oldTx, newTx, operation)` → `PreCalculatedCacheData`
- `savePreCalculatedData(PreCalculatedCacheData data)` → `Future<void>`

---

## Design Decisions

### Decision 1: Use Sets for Affected Entity Collection
**Choice**: Use `Set<String>` to collect affected entity dbRefs.

**Rationale**:
- Automatically deduplicates entities
- If a transaction has 10 products but only 5 unique ones, we calculate 5 (not 10)
- For edit operations, if customer changes from A to B, both are in the set

### Decision 2: Order of Entity Updates
**Choice**: Update in order: Products → Customers → Salesmen

**Rationale**:
- Salesman screen data depends on customer debt calculations
- Customer data might depend on product data
- This order ensures dependencies are satisfied

### Decision 3: Synchronous Calculation, Async Save
**Choice**: Split into sync calculation and async save phases.

**Rationale**:
- Calculation needs BuildContext (for translations)
- Context is only valid before navigation
- Firebase save is slow and shouldn't block UI
- Save doesn't need context

### Decision 4: Keep Existing getItemScreenData Methods
**Choice**: Use existing per-item calculation methods without modification.

**Rationale**:
- These methods are already tested and working
- Avoid changing delicate calculation logic
- SalesmanScreenController just needed implementation of empty stub

### Decision 5: Don't Rely on Notifiers for Cache Update
**Choice**: Get raw data from DbCache and calculate directly.

**Rationale**:
- Notifiers may have stale data
- Would require calling setFeatureScreenData for all screens (defeats purpose)
- Direct calculation from DbCache is more reliable

---

## Implementation Details

### Files Modified

| File | Changes |
|------|---------|
| `screen_cache_update_service.dart` | Rewrote with two-phase approach |
| `transaction_form.dart` | Updated save/delete to use new approach |
| `salesman_screen_controller.dart` | Implemented `getItemScreenData` |

### Code Locations

- **Service**: `lib/src/common/providers/screen_cache_update_service.dart`
- **Transaction Form**: `lib/src/features/transactions/view/transaction_form.dart`
- **Salesman Controller**: `lib/src/features/salesmen/controllers/salesman_screen_controller.dart`

---

## Testing

### Manual Test Cases
1. **Add Transaction**: Create invoice → Verify customer debt updated in Firebase
2. **Edit Transaction**: Change customer A to B → Verify both A and B updated
3. **Delete Transaction**: Delete invoice → Verify customer debt reduced

### Verified Scenarios
- ✅ Add transaction - affected entities updated immediately
- ✅ Edit transaction - both old and new affected entities updated
- ✅ Delete transaction - affected entities updated (context issue resolved)
- ✅ Multiple products in transaction - each calculated once (Set deduplication)

---

## Future Considerations

### Potential Improvements
1. **Batch Firebase Writes**: Currently saves entities one by one; could use batch writes for better performance
2. **Error Recovery**: If save fails, could retry or queue for later
3. **Offline Support**: Consider what happens if Firebase is unreachable

### Related Systems
- **Daily Reconciliation**: Still runs every 24 hours as a safety net
- **Screen Cache Service**: Initial cache loading on app start

### AI Assistant Guidelines
When working on this system:
1. Always use `getItemScreenData` for per-entity calculations
2. Never call `setFeatureScreenData` for all screens just for cache updates
3. Remember that `BuildContext` becomes invalid after navigation
4. Sync calculation before navigation, async save after
5. Use the two-phase approach in `ScreenCacheUpdateService`

---

## Revision History
| Date | Author | Changes |
|------|--------|---------|
| 2025-12-06 | AI Assistant | Initial implementation |
