*&---------------------------------------------------------------------*
*& Report ZBTP_TEST07_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBTP_TEST07_10125.

CLASS cl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: display_type.
ENDCLASS.

CLASS cl_car DEFINITION INHERITING FROM cl_vehicle.
  PUBLIC SECTION.
    METHODS: display_type REDEFINITION.
ENDCLASS.

CLASS cl_vehicle IMPLEMENTATION.
  METHOD display_type.
    WRITE: / 'This is a vehicle'.
  ENDMETHOD.
ENDCLASS.

CLASS cl_car IMPLEMENTATION.
  METHOD display_type.
    WRITE: / 'This is a car'.
  ENDMETHOD.
ENDCLASS.


DATA: car      TYPE REF TO cl_car,
      vehicle  TYPE REF TO cl_vehicle,
      vehicle2 TYPE REF TO cl_vehicle.


START-OF-SELECTION.

  BREAK-POINT.

  "Sub class is treated as a super class
  CREATE OBJECT: car, vehicle.
  vehicle = car. " Upcasting  " Outputs: This is a vehical
  vehicle->display_type( ). " Outputs: This is a car

  "Super class is treated as a sub class
  CREATE OBJECT vehicle2 TYPE cl_car.
  TRY.
      car ?= vehicle2. " Explicit downcasting
      car->display_type( ). " Outputs: This is a car
    CATCH cx_sy_move_cast_error.
      WRITE: / 'Cast error'.
  ENDTRY.
