*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO_10125_OUT
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Reading all the records from the internal table into workarea
*& and printing it in output.
*&---------------------------------------------------------------------*


FORM output_list.

  LOOP AT gt_itab INTO gw_wtab.
    WRITE: / gw_wtab-carrid, gw_wtab-connid, gw_wtab-fldate, gw_wtab-price, gw_wtab-currency, gw_wtab-planetype.
  ENDLOOP.

ENDFORM.
