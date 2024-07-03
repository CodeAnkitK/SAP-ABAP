*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO1_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_DEMO1_10125.

*&---------------------------------------------------------------------*
*&  Defining a global structure
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gs_sflight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,  "flight date
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_sflight.


*&---------------------------------------------------------------------*
*&  Defining a global variables
*&---------------------------------------------------------------------*
DATA: gt_itab TYPE TABLE OF gs_sflight, "internal table
      gw_wtab TYPE gs_sflight. "Work Area

*&---------------------------------------------------------------------*
*&  Screen Program
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_carrid TYPE sflight-carrid.
SELECTION-SCREEN: END OF BLOCK b1.


INITIALIZATION.

START-OF-SELECTION.
BREAK-POINT.
  PERFORM get_flight_data USING p_carrid.

END-OF-SELECTION.
  PERFORM output_list.

*&---------------------------------------------------------------------*
*&  Fetching the records
*&---------------------------------------------------------------------*
FORM get_flight_data USING lv_carrid TYPE sflight-carrid.

  SELECT
    carrid
    connid
    fldate
    price
    currency
    planetype
  INTO TABLE gt_itab
    FROM sflight
    WHERE carrid = lv_carrid.

  IF SY-SUBRC <> 0.   "Not Equal to
    MESSAGE TEXT-000 TYPE 'E' .
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&  Fetching the records
*&---------------------------------------------------------------------*
FORM output_list.

  LOOP AT gt_itab INTO gw_wtab.
    WRITE: / gw_wtab-carrid, gw_wtab-connid, gw_wtab-fldate, gw_wtab-price, gw_wtab-currency, gw_wtab-planetype.
  ENDLOOP.

ENDFORM.
