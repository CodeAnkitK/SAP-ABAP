*&---------------------------------------------------------------------*
*& Include ZBRP_TEST_INCLUDE_10125
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-000.

SELECT-OPTIONS: s_carrid FOR sflight-carrid OBLIGATORY.
PARAMETERS: p_curr TYPE sflight-currency .

SELECTION-SCREEN: END OF BLOCK b1.
