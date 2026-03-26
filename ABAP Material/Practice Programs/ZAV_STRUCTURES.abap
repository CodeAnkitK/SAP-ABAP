*&---------------------------------------------------------------------*
*& Report ZAV_STRUCTURES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_STRUCTURES.

"Structure: Group of replated fields like a record
"Reports, interface, data processing

TYPES: BEGIN OF ty_adr,
         city TYPE string,
         pincode TYPE i,
       END OF ty_adr.

TYPES: BEGIN OF ty_empl,
         id TYPE i,
         firstname TYPE string,
         lastname TYPE string,
         age TYPE i.
*         address TYPE ty_adr,
INCLUDE TYPE ty_adr.
TYPES: END OF ty_empl.


TYPES: BEGIN OF ty_empl_new,
         id TYPE i,
         firstname TYPE string,
         lastname TYPE string,
         age TYPE i.
TYPES: END OF ty_empl_new.

DATA: ls_empl TYPE ty_empl.
DATA: ls_empl_new TYPE ty_empl_new.

ls_empl-id = 1.
ls_empl-firstname = 'Ankit'.
ls_empl-lastname = 'Kumar'.
ls_empl-age = '40'.


*Nested Structure.
*ls_empl-address-city = 'Pune'.
*ls_empl-address-pincode = '411011'.

*Include structure.
ls_empl-city = 'Pune'.
ls_empl-pincode = '411011'.

*cl_demo_output=>display( ls_empl ).


"Move - Type cast
DATA: lv_a TYPE i VALUE 100,
      lv_b(10) TYPE c.

*MOVE lv_a TO lv_b. "Old Syntax
lv_b = lv_a.        "New Syntax

*WRITE: lv_b.

"Move-Corresponding.
MOVE-CORRESPONDING ls_empl TO ls_empl_new.
cl_demo_output=>display( ls_empl_new ).