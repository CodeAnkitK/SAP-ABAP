*&---------------------------------------------------------------------*
*& Report ZAV_TEST_CASTING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_TEST_CASTING.

CLASS lcl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor,
      move.
ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'Vehicle constructor'.
  ENDMETHOD.

  METHOD move.
    WRITE: / 'Vehicle is moving'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_car DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS:
      constructor,
      drive.
ENDCLASS.

CLASS lcl_car IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    WRITE: / 'Car constructor'.
  ENDMETHOD.

  METHOD drive.
    WRITE: / 'Car is driving'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: lo_vehicle TYPE REF TO lcl_vehicle, "Super Class
        lo_car     TYPE REF TO lcl_car.     "Sub Class

  lo_car = NEW lcl_car( ).

BREAK-POINT.

  " Upcasting
  lo_vehicle = lo_car.
  lo_vehicle->move( ).

  " Downcasting
  lo_car ?= lo_vehicle.
  lo_car->drive( ).