*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO_10125_FUN
*&---------------------------------------------------------------------*
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

*&---------------------------------------------------------------------*
*&  Fetching the records
*&---------------------------------------------------------------------*
  "Putting a sy-subrc check for checking if the record exit.
*sy-subrc : check for record and error:  0 is sucessful | 4 is unsuccessful.

*  IF SY-SUBRC NE 0.  "Not Equal to
*  IF SY-SUBRC EQ 0.  "Equal to

  IF sy-subrc <> 0.   "Not Equal to
    MESSAGE TEXT-000 TYPE 'E' .
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .
*&---------------------------------------------------------------------*
*& Local internal table and work area decalration
*&---------------------------------------------------------------------*
  DATA: lt_itab TYPE TABLE OF sflight,
        lw_wtab TYPE sflight.

*&---------------------------------------------------------------------*
*& Delete the records from the table everytime we are saving the record
*&---------------------------------------------------------------------*
  DELETE FROM zdt_gbfl_10125.
*&---------------------------------------------------------------------*
*& Move the Data from global table to the local table
*&---------------------------------------------------------------------*
  FREE: gw_wtab, lw_wtab.
  LOOP AT gt_itab INTO gw_wtab.
*&---------------------------------------------------------------------*
*& Adding Mandt field from the system value
*&---------------------------------------------------------------------*
    lw_wtab = sy-mandt.
*&---------------------------------------------------------------------*
*& Moving the work area from global table to the local table.
*&---------------------------------------------------------------------*
    MOVE-CORRESPONDING gw_wtab to lw_wtab.
    APPEND lw_wtab to lt_itab.
    FREE: gw_wtab, lw_wtab.
  ENDLOOP.
*&---------------------------------------------------------------------*
*& Saving the Data into the database
*&---------------------------------------------------------------------*
  MODIFY zdt_gbfl_10125 FROM TABLE lt_itab.

ENDFORM.
