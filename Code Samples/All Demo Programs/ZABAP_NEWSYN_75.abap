*&---------------------------------------------------------------------*
*& Report ZABAP_NEWSYN_75
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_newsyn_75.

FIELD-SYMBOLS: <fs_final> TYPE ANY TABLE.

*&---------------------------------------------------------------------*
*& Inline Declarations
*&---------------------------------------------------------------------*
SELECT flight~carrid,
       flight~connid,
       flight~fldate,
       flight~price,
       flight~currency,
       flight~planetype,
       flight~seatsmax,
       flight~seatsocc,
       flight~paymentsum,
       carrier~carrname,
       carrier~currcode,
       carrier~url
  FROM sflight AS flight
  LEFT JOIN scarr AS carrier ON flight~carrid = carrier~carrid
  INTO TABLE @DATA(flight_details).

*&---------------------------------------------------------------------*
*& Sort of an Inner Join
*&---------------------------------------------------------------------*
SELECT *
  FROM spfli
  FOR ALL ENTRIES IN @flight_details
  WHERE carrid = @flight_details-carrid
    AND connid = @flight_details-connid
  INTO TABLE @DATA(flight_schedule).

*&---------------------------------------------------------------------*
*& LOOP and READ Statement
*&---------------------------------------------------------------------*
LOOP AT flight_details INTO DATA(ls_flidet).
  TRY.
      "Read table with index 1.
      DATA(ls_flidet1) = flight_details[ 1 ].

      "Read table with index 1 and only a field.
      DATA(lv_carrid) = flight_details[ 1 ]-carrid.

      "Read table with work area.
      READ TABLE flight_details INTO DATA(ls_flidet2) INDEX 1.

      "Read table to check if value exist or not.
      DATA(ls_flidet3) = VALUE #( flight_details[ 1 ] OPTIONAL ).

      "Read table with condition.
      DATA(ls_flight_details) = flight_details[ connid = ls_flidet-connid ].

*&---------------------------------------------------------------------*
*& Concatanate
*&---------------------------------------------------------------------*
      " With Space
      DATA(lv_rootid) = | { ls_flight_details-carrid } { ls_flight_details-connid } |.

      " Without Space
      DATA(lv_rootid2) = | Key | && ls_flight_details-carrid && ls_flight_details-connid && | created |.
      DATA(lv_rootid3) = | Key | && ls_flight_details-carrid && ls_flight_details-connid.
      DATA(lv_rootid4) = |Key| && ls_flight_details-carrid && ls_flight_details-connid.

    CATCH cx_root.
  ENDTRY.
ENDLOOP.

*&---------------------------------------------------------------------*
*& Alpha conversion
*&---------------------------------------------------------------------*
DATA(lv_matnr) = '0000000001'.

"Old Style
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING
*    input  = lv_matnr
*  IMPORTING
*    output = lv_matnr.

"New Style
DATA(lv_matnr1) = | { lv_matnr ALPHA = OUT } |.

"Old Style
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING
*    input  = lv_matnr
*  IMPORTING
*    output = lv_matnr.

"New Style
DATA(lv_matnr2) = | { lv_matnr ALPHA = IN } |.

*&---------------------------------------------------------------------*
*& Field Type Convertion
*&---------------------------------------------------------------------*

"Example 1
DATA num TYPE i VALUE 10.
DATA(num1) = CONV matnr( num ).
num1 = | { num1 ALPHA = IN } |.

"Example 2
DATA(p_amount) = '1000'.
DATA gv_amount_words(250).

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = CONV maxbt( p_amount )
  IMPORTING
    amt_in_words       = gv_amount_words
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.

*&---------------------------------------------------------------------*
*& Concept of Reduce operator
*&---------------------------------------------------------------------*

SELECT carrid, connid, fldate, bookid, customid, custtype, smoker,
       luggweight, wunit, invoice, cast( 0 as dec ) as amount,

       CASE custtype
       	WHEN 'P' THEN 'PRIVATE'
       	WHEN 'B' THEN 'BUSINESS'
        ELSE 'RESERVED'
       END AS status,

       CASE invoice
       	WHEN 'X' THEN 'PAID'
        ELSE 'UNPAID'
       END AS payment_status

       FROM sbook
       INTO TABLE @DATA(gt_sbook).

SELECT carrid,
       connid,
       fldate,
       price,
       currency,
       planetype,
       seatsmax,
       seatsocc,
       paymentsum
 FROM sflight
 FOR ALL ENTRIES IN @gt_sbook
  WHERE carrid = @gt_sbook-carrid
    AND connid = @gt_sbook-connid
 INTO TABLE @DATA(gt_sflight).

LOOP AT gt_sbook ASSIGNING FIELD-SYMBOL(<gs_book>).
  <gs_book>-amount = REDUCE i( INIT I TYPE DMBTR     " Initialise a local variable
                                FOR wa_sflight IN gt_sflight " create a work area for second table
                              WHERE ( carrid = <gs_book>-carrid  "Condition for the second table
                                AND   connid = <gs_book>-connid )
                               NEXT i = i + wa_sflight-paymentsum ).  " operation Sum on Amount field.
ENDLOOP.

BREAK-POINT.
*&---------------------------------------------------------------------*
*& Direct table assignment to field symbol.
*&---------------------------------------------------------------------*
ASSIGN TABLE FIELD flight_details TO <fs_final>.

*&---------------------------------------------------------------------*
*& New Syntax for Describe Table
*&---------------------------------------------------------------------*
DESCRIBE TABLE <fs_final> LINES DATA(line_num).
DATA(line_num1) = lines( <fs_final> ).

*&---------------------------------------------------------------------*
*& READY to USE ALV for Internal table Structure.
*&---------------------------------------------------------------------*
*cl_demo_output=>display( flight_details ).
cl_demo_output=>display( gt_sbook ).
