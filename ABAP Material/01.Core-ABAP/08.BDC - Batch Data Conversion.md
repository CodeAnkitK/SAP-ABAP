# Batch Data Communication (BDC) in SAP ABAP

Batch Data Communication, commonly called **BDC**, is a classic SAP ABAP technique used to automate data entry into SAP transactions. It is especially helpful when you need to upload large amounts of data into standard SAP screens without writing complex direct database logic.

BDC works by simulating the same steps a user would perform manually in a transaction. This makes it useful for legacy data migration, mass updates, and repetitive business processes.

## What Is BDC?

BDC is a method of recording and replaying user input in SAP transactions. The program creates a sequence of screen fields and values, then passes them to a transaction through a batch session or direct input process.

In simple words:

* You record how a transaction works.

* You store the screen flow and field values.

* You replay that data automatically.

This is why BDC is often used for uploading master data, legacy data, or historical records into SAP.

## Why BDC Is Used

BDC is useful when:

* No standard BAPI or API is available.

* The transaction logic already exists in SAP screens.

* You need to upload many records in one run.

* The business wants to use standard validation from the transaction itself.

* You want to automate manual screen entry.

It is a practical option in older SAP implementations and is still taught because it helps learners understand SAP screen processing.

## Main BDC Approaches

There are two common ways to use BDC.

## 1. Session Method

In the session method, data is stored in a batch input session and processed later using transaction **SM35**.

Features:

* Safer for large uploads.

* Processing can be scheduled later.

* Suitable for background processing.

* Good for debugging failed records in SM35.

## 2. Call Transaction Method

In the call transaction method, the target transaction is executed immediately from the ABAP program.

Features:

* Faster than session method.

* Processing happens instantly.

* Useful for smaller uploads or real-time processing.

* Error handling must be managed carefully in the program.

## How BDC Works

BDC usually follows these steps:

1. Read source data from file, Excel, or internal table.

2. Build BDC data for screen and field values.

3. Choose session method or call transaction method.

4. Run the transaction programmatically.

5. Capture success or error messages.

6. Store logs for review.

This process allows SAP to behave as if a user entered the values manually.

## Important Terms in BDC

## BDC Data

This is the internal structure containing:

* Program name

* Screen number

* Field name

* Field value

## BDCDATA

`BDCDATA` is the standard internal table used to store BDC screen data.

## Session

A session is a batch input job that can be processed later through SM35.

## Transaction Recording

A recording is created using transaction **SHDB** to capture the screen flow and field names of an existing transaction.

## BDC Recording Tool

The standard tool for recording transactions is **SHDB**.

With SHDB, you can:

* Record a transaction.

* Capture screen flow.

* See field names.

* Generate a sample ABAP program.

This is a very important step in real BDC development because field names and screen numbers must match exactly.

## Basic Syntax

A typical BDC program uses internal tables and helper routines like these:

```
abap
DATA: lt_bdcdata TYPE TABLE OF bdcdata,
      ls_bdcdata TYPE bdcdata.
```

Then values are appended to the BDC table.

Example:

```
abap
ls_bdcdata-program  = 'SAPLMGMM'.
ls_bdcdata-dynpro    = '0060'.
ls_bdcdata-dynbegin  = 'X'.
APPEND ls_bdcdata TO lt_bdcdata.
```

This says that a new screen begins for the given program and dynpro number.

## Common BDC Helper Routines

Many BDC programs use helper forms to make the code cleaner.

## Adding a screen

```
abap
FORM bdc_dynpro USING pv_program pv_dynpro.
  CLEAR ls_bdcdata.
  ls_bdcdata-program = pv_program.
  ls_bdcdata-dynpro = pv_dynpro.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.
ENDFORM.
```

## Adding a field

```
abap
FORM bdc_field USING pv_name pv_value.
  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = pv_name.
  ls_bdcdata-fval = pv_value.
  APPEND ls_bdcdata TO lt_bdcdata.
ENDFORM.
```

These routines help keep the program readable and reusable.

## BDC Example Concept

Suppose you want to create material master data using a transaction. The BDC recording would capture:

* Initial screen

* Material number field

* Basic data screen

* Sales view screen

* Save command

The ABAP program then reproduces those screen entries automatically for many records.

## BDC Modes

BDC can run in different display modes:

* `A` — displays all screens

* `E` — displays only screens with errors

* `N` — no screens displayed

* `P` — print or foreground processing in some contexts

For mass uploads, `N` is often used because it runs silently and faster.

## Error Handling in BDC

Error handling is one of the most important parts of BDC.

Common error handling methods:

* Check the return message table.

* Log failed records.

* Store error text in an internal table or file.

* Review batch session logs in SM35.

Since BDC is screen-based, errors may occur due to:

* Missing fields

* Invalid values

* Different screen sequence

* Changes in SAP transaction layout

## Advantages of BDC

BDC has several advantages:

* Easy to understand for beginners.

* Works with standard SAP transactions.

* Uses existing validations in SAP screens.

* Useful for data migration.

* Can handle complex transaction logic without direct table updates.

## Limitations of BDC

BDC also has limitations:

* It is screen-dependent.

* Changes in transaction screens can break the program.

* It is slower than direct input or APIs.

* Not suitable for modern UI scenarios.

* Error handling can become complicated.

Because of these limitations, newer SAP projects often prefer BAPIs, IDocs, or APIs when available.

## Good Practices for BDC

To write better BDC programs:

* Prefer transaction recordings from SHDB.

* Use session method for large volume uploads.

* Keep logs for every record.

* Validate input data before calling BDC.

* Avoid direct table updates unless absolutely necessary.

* Document the transaction version used for recording.

* Re-test if SAP screen changes occur.

## Interview-Friendly Definition

If someone asks what BDC is in SAP ABAP, you can say:

> BDC is a classic ABAP technique used to automate SAP transaction input by simulating manual screen entry. It is commonly used for data migration and mass processing when no better interface such as BAPI or IDoc is available.

That is a strong and practical answer for interviews.

## Small Sample Structure

A typical BDC program looks like this:

```
abap
DATA: lt_bdcdata TYPE TABLE OF bdcdata,
      ls_bdcdata TYPE bdcdata.

PERFORM bdc_dynpro USING 'SAPLMGMM' '0060'.
PERFORM bdc_field  USING 'RMMG1-MATNR' lv_matnr.
PERFORM bdc_field  USING 'BDC_OKCODE' '/00'.
```

This tells SAP which screen to open and what values to enter.

## Summary

BDC is one of the foundational techniques in classic SAP ABAP for automating transaction-driven data entry. It is useful for legacy migration, mass uploads, and understanding how SAP screens and transaction logic work.

Even though modern projects often prefer APIs and BAPIs, BDC remains an important topic because many existing SAP systems still rely on it.

