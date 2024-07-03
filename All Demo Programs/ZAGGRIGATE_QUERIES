*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO2_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo2_10125.


*&---------------------------------------------------------------------*
*& Getting the sum of seats using group by
*&---------------------------------------------------------------------*
SELECT carrid, connid, SUM( seatsocc ) AS sumseat
    FROM sflight
    INTO TABLE @DATA(gt_sflight)
    GROUP BY carrid, connid.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& HAVING Addition
*&---------------------------------------------------------------------*
SELECT carrid, connid, SUM( seatsocc ) AS sumseat
    FROM sflight
    INTO TABLE @DATA(gt_sflight1)
    WHERE fldate > '20090101'
    GROUP BY carrid, connid
    HAVING SUM( seatsocc ) < 500 .

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Order By
*&---------------------------------------------------------------------*

SELECT carrid, connid, fldate
    FROM sflight
    INTO TABLE @DATA(gt_sflight2)
    GROUP BY carrid, connid, fldate
    ORDER BY PRIMARY KEY.


BREAK-POINT.
