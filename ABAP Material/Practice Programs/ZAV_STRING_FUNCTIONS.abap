*&---------------------------------------------------------------------*
*& Report ZAV_STRING_FUNCTIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_STRING_FUNCTIONS.

DATA: lv_text TYPE string VALUE 'HELLO WORLD'.
DATA: lv_order TYPE string VALUE '0000000003'.
DATA: lv_string TYPE string.

"Manipulate text data
"Modify Position
SHIFT lv_text RIGHT BY 4 PLACES.
WRITE lv_text.

SHIFT lv_order LEFT DELETING LEADING '0'.
WRITE / lv_order.

"Replace
REPLACE 'WORLD' IN lv_text WITH 'SAP'.
WRITE / lv_text.

"Overlay / Masking
*OVERLAY lv_order WITH 'ABCD'.
*WRITE / lv_text.
CONSTANTS initial_time TYPE t VALUE IS INITIAL.
DATA: time TYPE t,
      text TYPE c LENGTH 4.

text = '12'.
time = text.
OVERLAY time WITH initial_time.
WRITE / time.

"Translate
TRANSLATE lv_text TO LOWER CASE.
WRITE / lv_text.

"STRLEN
DATA lv_len TYPE i.
lv_len = STRLEN( lv_text ).
WRITE / lv_len.

"Condense
CONDENSE lv_text.
WRITE / lv_text.

"Concatanate
CONCATENATE lv_text lv_order INTO lv_string SEPARATED BY '-'.
WRITE /  lv_string.

CONCATENATE lv_text lv_order INTO lv_string SEPARATED BY space.
WRITE /  lv_string.

"Split
DATA lv_var1 TYPE string.
DATA lv_var2 TYPE string.
DATA lv_var3 TYPE string.

SPLIT lv_string AT space INTO lv_var1 lv_var2 lv_var3.
WRITE: / lv_var1,
       / lv_var2,
       / lv_var3.