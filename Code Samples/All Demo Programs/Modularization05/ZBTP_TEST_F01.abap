*&---------------------------------------------------------------------*
*& Include          ZBTP_TEST_F01
*&---------------------------------------------------------------------*

FORM fetch_logic.
*********************************************************************
* Select * without Condition
* Not Reecommended: DO NOT USE IN PRODUCTION PROGRAM
*********************************************************************

*select *
*  from sflight
*  into table gt_sflight.


*********************************************************************
* Select * with Condition
*********************************************************************

*select *
*  from sflight
*  into table gt_sflight
*  where carrid = 'AZ'.

*select
*    carrid
*    connid
*    fldate
*    price
*    currency
*    planetype
*    seatsmax
*  from sflight
*  into table gt_sflight
*  where carrid = 'AZ'.



*********************************************************************
* Select fields with Condition & Dynamic variable declaration
*********************************************************************

*select
*    carrid,
*    connid,
*    fldate,
*    price,
*    currency,
*    planetype,
*    seatsmax
*  from sflight
*  into table @data(gt_sflight)
*  where carrid = 'AZ'.

*if sy-subrc = 0.
*  free gw_sflight.
*  loop at gt_sflight into gw_sflight.
*
*
*    free gw_sflight.
*  endloop.
*endif.

*********************************************************************
* Select fields with Condition / Open Query
*********************************************************************

*select
*    carrid,
*    connid,
*    fldate,
*    price,
*    currency,
*    planetype,
*    seatsmax
*  from sflight
*  into table @gt_sflight
*  where carrid = 'AZ'.
*
*if sy-subrc = 0.
*  free gw_sflight.
*  loop at gt_sflight into gw_sflight.
*
*
*    free gw_sflight.
*  endloop.
*endif.

*********************************************************************
* Loop with conditions
*********************************************************************
*if sy-subrc = 0.
*  free gw_sflight.
*  loop at gt_sflight into gw_sflight where carrid = 'AZ'.
*
*
*    free gw_sflight.
*  endloop.
*
*endif.

*  FREE gw_sflight.
*  LOOP AT gt_sflight INTO gw_sflight WHERE CARRID = 'AZ'.
*
*
*      FREE gw_sflight.
*  ENDLOOP.


*********************************************************************
* Read statement with conditions
*********************************************************************
*  READ TABLE gt_sflight INTO gw_sflight WITH KEY CARRID = 'AAA'.
*  READ TABLE gt_sflight INTO gw_sflight INDEX 7.
*
*  IF SY-SUBRC = 0.
*
*  ENDIF.

*********************************************************************
* Join Condition
*********************************************************************

*data lt_fldata_join type standard table of ty_flight_data.
*data lw_fldata_join type ty_flight_data.

*select
*         c~carrname,
*         f~connid,
*         f~fldate,
*         p~cityfrom,
*         p~cityto
*from scarr as c
*  inner join spfli as p on c~carrid = p~carrid
*  inner join sflight as f on p~carrid = f~carrid
*                    and p~connid = f~connid
*  into table @DATA(lt_fldata_join)
*  where c~carrid = 'LH'.

*select
*         c~carrname,
*         f~connid,
*         f~fldate,
*         p~cityfrom,
*         p~cityto
*from scarr as c
*  inner join spfli as p on c~carrid = p~carrid
*  inner join sflight as f on p~carrid = f~carrid
*                    and p~connid = f~connid
*  into table @lt_fldata_join
*  where c~carrid = 'LH'.

*********************************************************************
* FOR ALL ENTRIES IN
*********************************************************************

** HEADER: Airline
*SELECT carrid,
*       carrname,
*       currcode,
*       url
*FROM scarr
*INTO TABLE @DATA(lt_scarr)
*    WHERE carrid = 'LH'.
*
** ITEMS: Flight
*SELECT carrid,
*       connid,
*       fldate,
*       price,
*       currency,
*       planetype,
*       seatsmax
*  FROM sflight
*  INTO TABLE @DATA(lt_sflight)
*    FOR ALL ENTRIES IN @lt_scarr
*    WHERE carrid = @lt_scarr-carrid.


* HEADER: Airline
*SELECT carrid,
*       carrname,
*       currcode,
*       url
*FROM scarr
*INTO TABLE @DATA(gt_scarr)
*    WHERE carrid = 'LH'.

  DELETE FROM zsflight_10125 .

  SELECT carrid,
         carrname,
         currcode,
         url
  FROM scarr
  INTO TABLE @DATA(lt_scarr)
      WHERE carrid IN @s_carrid.

  IF sy-subrc = 0.

* ITEMS: Flight
    SELECT carrid,
           connid,
           fldate,
           price,
           currency,
           planetype,
           seatsmax
      FROM sflight
      INTO CORRESPONDING FIELDS OF TABLE @gt_sflight
        FOR ALL ENTRIES IN @lt_scarr
        WHERE carrid = @lt_scarr-carrid.

    DATA: lw_scarr LIKE LINE OF lt_scarr.

    BREAK-POINT.

    FREE: lw_scarr, gw_sflight.
    REFRESH: gt_scarr.
    SORT gt_sflight BY carrid planetype.
    LOOP AT lt_scarr INTO lw_scarr.
      LOOP AT gt_sflight INTO gw_sflight WHERE carrid = lw_scarr-carrid.

        MOVE-CORRESPONDING lw_scarr TO gw_scarr.
        gw_scarr-price = gw_scarr-price + gw_sflight-price.
        gw_scarr-planetype = gw_sflight-planetype.
      ENDLOOP.

      APPEND gw_scarr TO gt_scarr.
      FREE: lw_scarr, gw_sflight.
    ENDLOOP.

    INSERT zsflight_10125 FROM TABLE  gt_sflight  .
    MODIFY zscarr_10125 FROM TABLE  gt_scarr .
  ENDIF.
ENDFORM.
