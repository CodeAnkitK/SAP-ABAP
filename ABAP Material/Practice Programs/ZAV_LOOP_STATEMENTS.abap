*&---------------------------------------------------------------------*
*& Report ZAV_LOOP_STATEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_LOOP_STATEMENTS.
" <  LT
" >  GT
" <=  LE
" >=  GE
" ==  EQ

"Internal Table & Workarea

*DATA: var1 TYPE i.
*DATA: var2(10) TYPE c.

*BREAK-POINT.

DATA: it_vbak TYPE STANDARD TABLE OF vbak, "Internal Table
      wa_vbak TYPE vbak. "Work Area

SELECT *
  FROM VBAK
  INTO TABLE it_vbak
  UP TO 10 ROWS.


*  LOOP AT it_vbak INTO wa_vbak.
*
*    WRITE: / wa_vbak-vbeln,  wa_vbak-erdat.
*
*  ENDLOOP.

DATA num TYPE i VALUE 0.
DATA limit TYPE i VALUE 10.

DO 10 TIMES.
  num = num + 1.
*  WRITE: / num.
ENDDO.


DATA lv_counter TYPE i VALUE 1.
CONSTANTS: lc_limit TYPE i VALUE 5.

WHILE lv_counter LE lc_limit.
  WRITE: / 'Current Value is: ', lv_counter.
  lv_counter = lv_counter + 1.
ENDWHILE.