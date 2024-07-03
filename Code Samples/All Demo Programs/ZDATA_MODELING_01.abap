*&---------------------------------------------------------------------*
*& Report ZBTP_TEST03_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbtp_test03_10125.

*&---------------------------------------------------------------------*
*& Selecting the Data from the View
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*
SELECT *
  FROM vbrk
  INTO TABLE @DATA(lt_view)  "HANA DB Syntax
  WHERE vbeln = '0090000000'.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Selecting the Data from two tables
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*
SELECT *
  FROM sflight
  INTO TABLE @DATA(lt_sflight).  "HANA DB Syntax
**  WHERE CARRID = 'AA'.

SELECT
  carrid,                   "
  carrname,
  currcode,
  url
  FROM scarr
  INTO TABLE @DATA(lt_scarr)   "HANA DB Syntax: Escape sequence
  FOR ALL ENTRIES IN @lt_sflight    "HANA DB Syntax
  WHERE carrid = @lt_sflight-carrid.  "HANA DB Syntax

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Selecting a single field in a structure
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*

SELECT SINGLE
    carrid,
    carrname,
    currcode,
    url
  FROM scarr
  INTO @DATA(ls_scarr)
  WHERE carrid = 'FJ'.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& USING Join Conditions
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*

SELECT f~carrid,
       f~connid,
       c~carrname,
       s~cityfrom,
       s~cityto
  FROM sflight AS f
  LEFT OUTER JOIN scarr AS c ON f~carrid = c~carrid  "SCARR does not contain all CARRIDs so left outer
                                                     "works irrespective of the conditions
  INNER JOIN spfli AS s ON f~carrid = s~carrid
                       AND f~connid = s~connid       "SPFLI contain all CARRIDs so Inner Join
                                                     "works w.r.t the conditions
  INTO TABLE @DATA(it_output).

BREAK-POINT.


*&---------------------------------------------------------------------*
*& Value # Internal Tables - ARRAY
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*

TYPES: BEGIN OF t_struct,
         col1 TYPE i,
         col2 TYPE i,
       END OF t_struct,

       t_itab TYPE TABLE OF t_struct WITH EMPTY KEY. "It is usually and Array

DATA itab TYPE t_itab.

itab = VALUE #( ( col1 = 1 col2 = 2 )
                ( col1 = 3 col2 = 4 ) ).

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Value # Internal Tables = Entries
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Select * is being used only for the demo purpose.
*& Please DO NOT USE in Live projects as they will reflect in
*& Program Optimization
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gs_sflight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_sflight.

DATA: gt_itab TYPE TABLE OF gs_sflight.

gt_itab = VALUE #(
                  ( carrid = 'AA'  connid = '0017'  currency  = 'USD' planetype = '747-400' )
                  ( carrid = 'AS'  connid = '55'    currency  = 'EURO' planetype = '737-800' )
                 ).


BREAK-POINT.

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

SELECT carrid, connid, fldate
    FROM sflight
    INTO TABLE @DATA(gt_sflight3)
    ORDER BY carrid, connid.

SELECT carrid, connid, fldate
    FROM sflight
    INTO TABLE @DATA(gt_sflight4)
    ORDER BY carrid, connid DESCENDING.

SELECT carrid, connid, fldate
    FROM sflight
    INTO TABLE @DATA(gt_sflight5)
    ORDER BY carrid ASCENDING, connid DESCENDING.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Order By
*&---------------------------------------------------------------------*

SELECT DISTINCT carrid, connid
  FROM sflight
  INTO TABLE @DATA(gt_sflight6)
  WHERE seatsocc > 200.

BREAK-POINT.

*&---------------------------------------------------------------------*
*& Aggregate Expression
*&---------------------------------------------------------------------*

SELECT COUNT(*) AS c_seatsocc,
       COUNT( DISTINCT connid ) AS connid_count,
       MIN( seatsocc ) AS min_seatsocc,
       MAX( seatsocc ) AS max_seatsocc,
       SUM( DISTINCT seatsocc ) AS sum_seatsocc
  FROM sflight
  INTO @DATA(gs_fightdoc).

BREAK-POINT.
