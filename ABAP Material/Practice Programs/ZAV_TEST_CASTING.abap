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

  " Upcasting = generalize. 
  " Upcast for generic processing, polymorphism, and cleaner code.
  " Upcasting: use a superclass reference to handle any subclass object when you only need common behavior.
  lo_vehicle = lo_car.
  lo_vehicle->move( ).

  " Downcasting = specialize.
  " Downcast only when you really need child-specific functionality.
  " Downcasting: use it when you have a superclass reference but need subclass-specific methods.
  lo_car ?= lo_vehicle.
  lo_car->drive( ).