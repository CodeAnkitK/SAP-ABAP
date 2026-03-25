*&---------------------------------------------------------------------*
*& Report ZAV_FIELD_SYMBOL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_FIELD_SYMBOL.

" Passing by Value
" Passing by Reference

*DATA: lv_num TYPE i. "Address Reserve

BREAK-POINT.

DATA: lt_data TYPE TABLE OF i, " Tanle
      lv_val TYPE i. "Workarea

FIELD-SYMBOLS: <fs_value> TYPE i.

"Old Technique
*REFRESH: lt_data.
*CLEAR: lv_val.
"New Technique
FREE: lt_data, lv_val.

lv_val = 100.

DO 5 TIMES.
  lv_val = lv_val + 10.
  APPEND lv_val TO lt_data.
ENDDO.

LOOP AT lt_data INTO lv_val.
*  WRITE: / lv_val.
ENDLOOP.

BREAK-POINT.

LOOP AT lt_data INTO lv_val.
  lv_val = lv_val + 10.
ENDLOOP.

LOOP AT lt_data ASSIGNING <fs_value>.
   <fs_value>  =  <fs_value> + 10.
*   WRITE: <fs_value>.
ENDLOOP.

   FREE: lt_data, lv_val.

BREAK-POINT.