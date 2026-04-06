*&---------------------------------------------------------------------*
*& Report ZAV_MODULARIZATION_CONT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_modularization_cont.

"Reuable Objects

"Define - Macros
"Subroutine - Local
"Include - Program
"Function Module - Global
"Classes & Methods - OOPS

*RICEFW
" R - Report - Text Element
" I - Interfaces X
" C - Coversion
" E - Enhancement
" F - Fucntion Module X
" W - Workflow

"Important T-CODES
" SE37 - Function Module
" SE80 - Object Repository

DATA lv_maktg TYPE makt-maktg.

PARAMETERS: p_matnr TYPE makt-matnr.

CALL FUNCTION 'ZAV_MODULE_FM'
  EXPORTING
    im_matnr = p_matnr
  IMPORTING
    ex_maktx = lv_maktg.


WRITE: TEXT-000.
WRITE: / lv_maktg.