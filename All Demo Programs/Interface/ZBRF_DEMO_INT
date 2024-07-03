*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO8_INT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo8_int.
TYPE-POOLS icon.

INCLUDE ZBRF_DEMO8_INT_DEF.
INCLUDE ZBRF_DEMO8_INT_IMP.

DATA:
  go_agency    TYPE REF TO lcl_travel_agency,
  go_carrier   TYPE REF TO lcl_carrier,
  go_airplane  TYPE REF TO lcl_airplane,
  go_cargo     TYPE REF TO lcl_cargo_plane,
  go_passenger TYPE REF TO lcl_passenger_plane,
  gv_count     TYPE i.

START-OF-SELECTION.
*******************
***** create travel_agency
  CREATE OBJECT go_agency
    EXPORTING
      iv_name = 'Travel&Smile Travel'.
***** Create Carrier
  CREATE OBJECT go_carrier
    EXPORTING
      iv_name = 'Smile&Fly Travel'.
***** Insert carrier into business partner list of
***** travel agency

  go_agency->add_partner( go_carrier ).

***** Passenger Plane
  CREATE OBJECT go_passenger
    EXPORTING
      iv_name         = 'LH BERLIN'
      iv_planetype    = '747-400'
      iv_seats        = 345
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    go_carrier->add_airplane( go_passenger ).
  ENDIF.

***** cargo Plane
  CREATE OBJECT go_cargo
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
      iv_cargo        = 533
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    go_carrier->add_airplane( go_cargo ).
  ENDIF.
***** show attributes of all partners of
***** travel agency
  go_agency->display_attributes( ).
