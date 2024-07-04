*&---------------------------------------------------------------------*
*& Report ZTEST_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_PROGRAM.

* Declaration of internal tables
DATA: it_flights TYPE TABLE OF sflight,
      it_carrier TYPE TABLE OF scarr,
*      it_report TYPE TABLE OF zflight_report,
      wa_flight TYPE sflight,
      wa_carrier TYPE scarr.
*      wa_report TYPE zflight_report.

* Class definition for business logic
CLASS lcl_flight_manager DEFINITION.
  PUBLIC SECTION.
    METHODS: get_flight_data,
             update_flight_data.
ENDCLASS.

CLASS lcl_flight_manager IMPLEMENTATION.
  METHOD get_flight_data.
    " Fetch data with JOIN
    SELECT f~carrid, f~connid, f~fldate, c~carrname, c~currcode
      FROM sflight AS f
      JOIN scarr AS c ON f~carrid = c~carrid
      INTO TABLE @it_flights.
  ENDMETHOD.

  METHOD update_flight_data.
    " Example update statement
    UPDATE sflight SET price = price * 1.1 WHERE carrid = 'LH'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " Create instance of class
  DATA(o_flight_manager) = NEW lcl_flight_manager( ).

  " Get flight data
  o_flight_manager->get_flight_data( ).

  " Output flight data
  LOOP AT it_flights INTO wa_flight.
    WRITE: / wa_flight-carrid, wa_flight-connid, wa_flight-fldate.
  ENDLOOP.

  " Call update method
  o_flight_manager->update_flight_data( ).
