*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Report ZRDS_INTERACTIVE_REPORT
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*&
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
REPORT zbrf_intrep_10125.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Structure Declarations
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
TYPES : BEGIN OF ty_sflight,
          carrid    TYPE s_carr_id,
          connid    TYPE s_conn_id,
          fldate    TYPE s_date,
          price     TYPE s_price,
          planetype TYPE s_planetye,
          seatsmax  TYPE s_seatsmax,
          seatsocc  TYPE s_seatsocc,
        END OF ty_sflight.

TYPES: BEGIN OF ty_spfli,
         carrid    TYPE s_carr_id,
         connid    TYPE s_conn_id,
         countryfr TYPE land1,
         cityfrom  TYPE s_from_cit,
         airpfrom  TYPE s_fromairp,
         countryto TYPE land1,
         cityto    TYPE s_to_city,
         airpto    TYPE s_toairp,
       END OF ty_spfli.


*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Declarations
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
DATA: it_sflight TYPE TABLE OF ty_sflight,
      it_spfli   TYPE TABLE OF ty_spfli,
      wa_sflight TYPE ty_sflight,
      wa_spfli   TYPE ty_spfli.
DATA: lv_carrid TYPE ty_sflight-carrid.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Select Options
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
SELECT-OPTIONS : s_carrid FOR lv_carrid.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Start of Selection
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
START-OF-SELECTION.

  SELECT carrid
  connid
  fldate
  price
  planetype
  seatsmax
  seatsocc
  FROM sflight
  INTO TABLE it_sflight
  WHERE carrid IN s_carrid.
  LOOP AT it_sflight INTO wa_sflight.
    AT FIRST.
      WRITE: / 'carrid' , 10 'connid', 20 'fldate', 50 'price', 60 'planetype', 75 'seatsmax', 85 'seatsocc'.
    ENDAT.
    WRITE: / wa_sflight-carrid,10 wa_sflight-connid, 20 wa_sflight-fldate, 35 wa_sflight-price, 60 wa_sflight-planetype, 75 wa_sflight-seatsmax,
    85 wa_sflight-seatsocc.
    "to enable hand like icon
    FORMAT HOTSPOT ON.
    " to enable interactive report
    hide: wa_sflight-carrid, wa_sflight-connid.
    endloop.


*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& AT Line Selection
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
AT LINE-SELECTION.
  IF sy-lsind = 1.

    SELECT carrid
    connid
    countryfr
    cityfrom
    airpfrom
    countryto
    cityto
    airpto
    FROM spfli
    INTO TABLE it_spfli
    WHERE carrid = wa_sflight-carrid AND connid = wa_sflight-connid.
      LOOP AT it_spfli INTO wa_spfli.
        AT FIRST.
          WRITE: /5 'carrid' , 15 'connid', 25 'countryfrm', 40 'cityfrom', 55 'airpfrom', 70 'countryto', 85 'cityto', 100 'airpto '.
        ENDAT.
        WRITE: /5 wa_spfli-carrid, 15 wa_spfli-connid , 25 wa_spfli-countryfr, 40 wa_spfli-cityfrom, 55 wa_spfli-airpfrom, 70 wa_spfli-countryto,85 wa_spfli-cityto, 100 wa_spfli-airpto.
      ENDLOOP.

    ENDIF.
