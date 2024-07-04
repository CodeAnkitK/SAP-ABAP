*&---------------------------------------------------------------------*
*& Include          ZBTP_TEST_OUTPUT
*&---------------------------------------------------------------------*

FORM output.

  LOOP AT gt_sflight INTO DATA(gw_sflight).

    WRITE: / ,
             gw_sflight-carrid,
             gw_sflight-connid,
             gw_sflight-currency,
             gw_sflight-fldate,
             gw_sflight-planetype,
             gw_sflight-price,
             gw_sflight-seatsmax .

  ENDLOOP.

*  BREAK-POINT.

ENDFORM.
