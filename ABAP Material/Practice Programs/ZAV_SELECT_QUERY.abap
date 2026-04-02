*&---------------------------------------------------------------------*
*& Report ZAV_INTERNAL_TABLES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_internal_tables.

*TABLES: VBAK.
*DATA: wa_emp TYPE ZTESTDEMO01. "Work Area
*Internal Tables: Stores processing data in Memory,
*              - Reduces load in Database / Avoid Access to Frequent DATABASE ACCESS.

*TYPES of INTERNAL TABLES
" Standard - Flexible
" Sorted   - Auto Sorting
" Hashed   - Fast Sraching

"Select Options & Ranges
*SELECT-OPTIONS: so_id FOR ztestdemo01-employee_code.

**
*TYPES carrid_range TYPE RANGE OF spfli-carrid.
*
*FINAL(carrid_range) = VALUE carrid_range(
*  ( sign = 'I' option = 'BT' low = 'AA' high = 'LH') ).
*
*SELECT *
*       FROM spfli
*       WHERE carrid IN @carrid_range
*       INTO TABLE @FINAL(spfli_tab).


*BREAK-POINT.

DATA: it_emp TYPE STANDARD TABLE OF ztestdemo01. "Work Area
DATA: wa_emp TYPE ztestdemo01. "Work Area

wa_emp-employee_code = '1'.
wa_emp-firstname = 'Rohit'.
wa_emp-lastname = 'Singh'.
wa_emp-gender = 'M'.

APPEND wa_emp TO it_emp.
clear wa_emp.

wa_emp-employee_code = '2'.
wa_emp-firstname = 'Abhishek'.
wa_emp-lastname = 'Singh'.
wa_emp-gender = 'M'.

APPEND wa_emp TO it_emp.
clear wa_emp.

MODIFY ztestdemo01 FROM TABLE it_emp.

"UPDATE
*wa_emp-firstname = 'ABHISHEK'.
*UPDATE ztestdemo01 SET firstname = wa_emp-firstname
*                 WHERE employee_code = '2'.

"INSERT
*INSERT ztestdemo01 FROM TABLE it_emp.


BREAK-POINT.

*cl_demo_output=>display( it_emp ).

*DATA lv_lines TYPE i.
*DESCRIBE TABLE it_emp LINES lv_lines.
*WRITE: lv_lines.

*DATA: it_vbak TYPE STANDARD TABLE OF vbak,
*      wa_vbak TYPE vbak.