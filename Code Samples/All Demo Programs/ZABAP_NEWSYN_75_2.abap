*&---------------------------------------------------------------------*
*& Report ZABAP_NEWSYN_75_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_newsyn_75_2.


*&---------------------------------------------------------------------*
*& Corresponding fields - New Style
*&---------------------------------------------------------------------*
TYPES: BEGIN OF tty_sflight,
          carrid     TYPE  s_carr_id,
       END OF  tty_sflight,
       tt_sflight TYPE HASHED TABLE OF tty_sflight WITH UNIQUE KEY carrid.

TYPES: BEGIN OF tty_sflight2,
          carrid     TYPE  s_carr_id,
       END OF  tty_sflight2,
       tt_sflight2 TYPE STANDARD TABLE OF tty_sflight2.

TYPES: BEGIN OF ty_sflight,
         carrid     TYPE  s_carr_id,
         connid     TYPE  s_conn_id,
         fldate     TYPE  s_date,
         price      TYPE  s_price,
         currency   TYPE  s_currcode,
         planetype  TYPE  s_planetye,
         seatsmax   TYPE  s_seatsmax,
         seatsocc   TYPE  s_seatsocc,
         paymentsum TYPE  s_sum,
         seatsmax_b TYPE  s_smax_b,
         seatsocc_b TYPE  s_socc_b,
         seatsmax_f TYPE  s_smax_f,
         seatsocc_f TYPE  s_socc_f,
       END OF ty_sflight.

TYPES: BEGIN OF ty_sflight2,
         carrid      TYPE  s_carr_id,
         connid      TYPE  s_conn_id,
         amount      TYPE  s_price,
         currency    TYPE  s_currcode,
         plane_type  TYPE  s_planetye,
         seatsmax    TYPE  s_seatsmax,
         seatsocc    TYPE  s_seatsocc,
         payment_sum TYPE  s_sum,
         seatsmax_b  TYPE  s_smax_b,
         seatsocc_b  TYPE  s_socc_b,
         seatsmax_f  TYPE  s_smax_f,
         seatsocc_f  TYPE  s_socc_f,
         comment     TYPE  text50,
         currency_name TYPE text50,
       END OF ty_sflight2.


DATA: itab1 TYPE STANDARD TABLE OF ty_sflight,
      itab2 TYPE STANDARD TABLE OF ty_sflight2,
      itab3 TYPE STANDARD TABLE OF ty_sflight2,
      itab4 TYPE STANDARD TABLE OF ty_sflight2,
      itab5 TYPE STANDARD TABLE OF ty_sflight2.

DATA sflight_tab TYPE STANDARD TABLE OF sflight WITH NON-UNIQUE SORTED KEY carrid COMPONENTS carrid connid fldate.

SELECT carrid
       connid
       fldate
       price
       currency
       planetype
       seatsmax
       seatsocc
       paymentsum
       seatsmax_b
       seatsocc_b
       seatsmax_f
       seatsocc_f
 FROM sflight
  INTO TABLE itab1.

SELECT *
 FROM sflight
*  CLIENT SPECIFIED
  INTO TABLE sflight_tab.


itab2 = CORRESPONDING #( itab1 ).

itab3 = CORRESPONDING #( itab1 MAPPING amount = price
                                       plane_type = planetype
                                       payment_sum = paymentsum  ).

itab4 = CORRESPONDING #( itab1 MAPPING amount = price
                                       plane_type = planetype
                                       EXCEPT payment_sum  ).

itab5 = itab3.

LOOP AT itab5 ASSIGNING FIELD-SYMBOL(<fs1>).
  <fs1>-payment_sum = REDUCE i( INIT i TYPE s_sum FOR amount IN itab1 WHERE ( carrid = <fs1>-carrid AND
                                                                              connid = <fs1>-connid )
                                                                      NEXT i = i + amount-paymentsum ).
ENDLOOP.

*&---------------------------------------------------------------------*
*& Internal Table Filters - New Style
*&---------------------------------------------------------------------*
DATA(itab6) = FILTER #( sflight_tab USING KEY carrid WHERE carrid = CONV s_carr_id( 'AA' ) ).
DATA(itab7) = FILTER #( sflight_tab EXCEPT USING KEY carrid WHERE carrid = CONV s_carr_id( 'AA' ) ).


DATA: try_tab TYPE tty_sflight2.
DATA(gt_carrid) = VALUE tt_sflight( ( carrid = 'AA' )
                                    ( carrid = 'AZ' )
                                    ( carrid = 'JL' ) ).

DATA(itab8) = FILTER #( sflight_tab IN gt_carrid WHERE carrid = carrid  ).

*&---------------------------------------------------------------------*
*& IF Else - New Style
*&---------------------------------------------------------------------*
LOOP AT itab5 ASSIGNING FIELD-SYMBOL(<fs2>).
  <fs2>-payment_sum = REDUCE i( INIT i TYPE s_sum FOR amount IN itab1 WHERE ( carrid = <fs2>-carrid AND
                                                                              connid = <fs2>-connid )
                                                                      NEXT i = i + amount-paymentsum ).
  <fs2>-comment = COND #( WHEN <fs2>-seatsocc LT 0 THEN | Not Occupied |
                          ELSE | Occupied | ).

  <fs2>-currency_name = SWITCH #( <fs2>-currency
                                  WHEN 'USD' THEN 'US Doller'
                                  WHEN 'EUR' THEN 'Europian Doller'
                                  WHEN 'JPY' THEN 'Japneese Yen'
                                  WHEN 'AUD' THEN 'Australian Doller'
                                  WHEN 'SGD' THEN 'Singapore Doller'
                                  ELSE 'Other Currencies' ).


ENDLOOP.

cl_demo_output=>write( |Source Table| ).
cl_demo_output=>write( itab1 ).
cl_demo_output=>write( |Target Table| ).
cl_demo_output=>write( itab2 ).
cl_demo_output=>write( itab3 ).
cl_demo_output=>write( itab4 ).
cl_demo_output=>write( itab5 ).
cl_demo_output=>write( itab6 ).
cl_demo_output=>write( itab7 ).
cl_demo_output=>write( itab8 ).
cl_demo_output=>display( ).
