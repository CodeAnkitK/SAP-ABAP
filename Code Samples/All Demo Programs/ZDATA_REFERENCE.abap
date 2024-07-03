*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO13_DATA_REF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_DEMO13_DATA_REF.

DATA: lo_data TYPE REF TO data,   " Generic reference to any data type
      lv_value TYPE i VALUE 10.

FIELD-SYMBOLS: <fs_data> TYPE any.

" Create a data reference for a variable of type i
CREATE DATA lo_data TYPE i.
ASSIGN lo_data->* TO <fs_data>.
<fs_data> = lv_value.

" Output the value of the dynamically assigned variable
WRITE: / 'The value is:', <fs_data>.

" Demonstrating with a different data type
DATA lv_text TYPE string VALUE 'Hello, ABAP!'.
CREATE DATA lo_data TYPE string.
ASSIGN lo_data->* TO <fs_data>.
<fs_data> = lv_text.

" Output the new string value
WRITE: / 'The string is:', <fs_data>.
