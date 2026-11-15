# Portfolio 3: Transactions & Concurrency Control
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Lagos State Primary Health Care Board (LSPHCB) Electronic Medical Records System  
**Target RDBMS:** PostgreSQL 16+

---

## 1. Overview & Healthcare Context

In a mission-critical Electronic Medical Records (EMR) system coordinating healthcare across Lagos State, transactions cannot afford to fail silently or corrupt data. 

For instance:
- If a clinician refers a critical patient from Alimosho PHC to Ikeja Model PHC, inserting the referral, updating the patient's status, and dispatching an ambulance must occur **atomically**. If the server crashes midway, an encounter cannot be marked "Referred" without an actual referral record!
- If two triage officers try to book the last remaining ultrasound slot at 9:00 AM, the database must prevent race conditions and overbooking.
- If two pharmacists are dispensing medications from shared clinic inventory simultaneously, row updates must not result in unhandled **deadlocks**.

---

## 2. Task 1: Atomic Multi-Step Patient Referral & Rollback

### The Business Requirement
Simulate an atomic 3-step referral pipeline:
1. Insert the referral details into `referral`.
2. Update the patient's `encounter` status to `'Referred'`.
3. Log the ambulance/transport status into `facility_transfer_audit`.
4. If any constraint fails, issue an immediate `ROLLBACK` so that no orphaned state is saved.

### Implementation Details (`Muraina_Kehinde_Portfolio_3_Atomic_Referral.sql`)
We used PostgreSQL's data-modifying Common Table Expressions (CTEs) within a transaction block:
```sql
BEGIN;

WITH new_referral AS (
    INSERT INTO referral (
        encounter_id, referring_facility_id, receiving_facility_id, 
        referral_reason, urgency_level
    )
    VALUES (
        1, 1, 3, 
        'Severe pyrexia unresponsive to oral antibiotics; transfer for inpatient observation', 
        'Urgent'
    )
    RETURNING referral_id
),
updated_encounter AS (
    UPDATE encounter
    SET status = 'Referred'
    WHERE encounter_id = 1
    RETURNING encounter_id
)
INSERT INTO facility_transfer_audit (referral_id, transfer_status, notes)
SELECT 
    referral_id, 
    'Ambulance Dispatched', 
    'LSPHCB Ambulance LAS-04 dispatched with nurse escort'
FROM new_referral;

COMMIT;
```

### Rollback on Constraint Violation
To verify that atomicity prevents corrupt or incomplete writes, we simulated an invalid referral where an operator attempted to refer Encounter 4 from Facility 4 back to Facility 4:
```
UPDATE 1
psql:01_atomic_referral_transaction.sql:107: ERROR: new row for relation "referral" violates check constraint "chk_referral_facilities"
ROLLBACK
```
When `ROLLBACK` was triggered:
- The initial `UPDATE encounter SET status = 'Referred'` was completely undone.
- Verification showed Encounter 4 stayed safely in its original status (`Completed`).

---

## 3. Task 2: Isolation Levels & Preventing Race Conditions

### The Scenario: Specialist Appointment Quota
At Ikeja Model Primary Healthcare Centre, the Obstetric Ultrasound clinic has a strict daily quota of **5 appointments**. 

If 4 appointments are currently booked, there is only **1 slot remaining**. Two clinicians (Clinician A and Clinician B) simultaneously check slot availability for two expectant mothers.

### Live Test Comparison (`Muraina_Kehinde_Portfolio_3_Test_Isolation.sh`)

#### Under Default `READ COMMITTED`:
1. Clinician A queries available slots in Session 1:
   ```sql
   SELECT COUNT(*) AS booked_slots, (5 - COUNT(*)) AS available_slots FROM appointment_slot ...;
   ```
   *Result:* `booked_slots = 4`, `available_slots = 1`.
2. Clinician B in Session 2 books the 5th slot and issues `COMMIT;`.
3. Clinician A (still inside their original transaction) queries again:
   *Result:* `booked_slots = 5`, `available_slots = 0`.
4. **Vulnerability (Phantom Read):** The data changed beneath Clinician A's feet within the same transaction. If Clinician A's code had decided *"Slot available, let's proceed"*, an overbooking error would occur.

#### Under `REPEATABLE READ`:
1. Clinician A begins transaction with `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;`.
2. First Read: `booked_slots = 4`, `available_slots = 1`.
3. Clinician B concurrently books slot 5 and commits.
4. Second Read by Clinician A:
   *Result:* `booked_slots = 4`, `available_slots = 1` (**Snapshot Isolation Preserved!**).
5. Clinician A sees a consistent point-in-time snapshot taken when the transaction started. Furthermore, if Clinician A tries to insert slot 5, PostgreSQL will throw a serialization error (`ERROR: could not serialize access`), allowing the application layer to gracefully tell the clinician: *"Slot was just taken by another doctor, please pick another date."*

---

## 4. Task 3: Row Locks, Deadlocks & Resolution

### How Deadlocks Occur in Hospital Inventory
When two healthcare staff dispense medication combinations from shared inventory:
- **Transaction A (Prescription 1):** Dispensing Ciprofloxacin (Item 1) and ACT Antimalarial (Item 2).
- **Transaction B (Prescription 2):** Dispensing ACT Antimalarial (Item 2) and Ciprofloxacin (Item 1).

If Transaction A locks Item 1 using `FOR UPDATE`, and Transaction B locks Item 2 using `FOR UPDATE`, both sessions subsequently wait for each other's locked row. Neither can proceed.

### Live PostgreSQL Deadlock Output (`Muraina_Kehinde_Portfolio_3_Test_Deadlock.sh`):
```
ERROR:  deadlock detected
DETAIL:  Process 8916 waits for ShareLock on transaction 957; blocked by process 8919.
Process 8919 waits for ShareLock on transaction 956; blocked by process 8916.
HINT:  See server log for query details.
CONTEXT:  while locking tuple (0,2) in relation "facility_inventory"
```
PostgreSQL's internal lock manager automatically recognized the cycle in the lock wait-for graph and aborted Process 8916 to break the deadlock.

### Engineering Resolution: Consistent Lock Ordering
To eliminate deadlocks forever, we enforced **Deterministic Ascending Lock Ordering**:
Whenever a transaction needs to lock multiple rows, it must always sort by primary key:
```sql
SELECT inventory_id, stock_quantity 
FROM facility_inventory 
WHERE inventory_id IN (1, 2) 
ORDER BY inventory_id ASC 
FOR UPDATE;
```
When both sessions lock `inventory_id` in ascending order (`1` before `2`):
- Session 1 locks Item 1.
- Session 2 tries to lock Item 1 and waits in a linear queue.
- Session 1 locks Item 2, updates both, and commits.
- Session 2 unblocks, acquires both locks safely, and commits.
- **Deadlock risk: 0%. Total inventory integrity preserved.**

---

## 5. How to Run the Tests
```bash
# Make runnable and execute entire transaction suite
chmod +x portfolio-3-transactions-concurrency/Muraina_Kehinde_Portfolio_3_Runner.sh
./portfolio-3-transactions-concurrency/Muraina_Kehinde_Portfolio_3_Runner.sh
```
