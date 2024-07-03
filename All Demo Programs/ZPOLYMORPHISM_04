*&---------------------------------------------------------------------*
*& Report ZBTP_TEST08_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBTP_TEST08_10125.

INTERFACE if_vehicle.
  METHODS: drive,
           display_type.
ENDINTERFACE.

CLASS cl_car DEFINITION.
  PUBLIC SECTION.
    INTERFACES: if_vehicle.
    METHODS: constructor.
    DATA: vehicle_type TYPE string VALUE 'Car'.
ENDCLASS.

CLASS cl_car IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'Car object created.'.
  ENDMETHOD.

  METHOD if_vehicle~drive.
    WRITE: / 'The car is driving.'.
  ENDMETHOD.

  METHOD if_vehicle~display_type.
    WRITE: / 'Vehicle Type:', vehicle_type.
  ENDMETHOD.
ENDCLASS.

CLASS cl_truck DEFINITION.
  PUBLIC SECTION.
    INTERFACES: if_vehicle.
    METHODS: constructor.
    DATA: vehicle_type TYPE string VALUE 'Truck'.
ENDCLASS.

CLASS cl_truck IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'Truck object created.'.
  ENDMETHOD.

  METHOD if_vehicle~drive.
    WRITE: / 'The truck is driving.'.
  ENDMETHOD.

  METHOD if_vehicle~display_type.
    WRITE: / 'Vehicle Type:', vehicle_type.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_vehicle TYPE REF TO if_vehicle,
        lo_car     TYPE REF TO cl_car,
        lo_truck   TYPE REF TO cl_truck.

  CREATE OBJECT: lo_car,
                 lo_truck.

  WRITE: / 'Using Car:'.
  " Demonstrating Upcasting
  lo_vehicle = lo_car.
  lo_vehicle->drive( ).
  lo_vehicle->display_type( ).

  WRITE: / 'Using Truck:'.
  lo_vehicle = lo_truck.
  lo_vehicle->drive( ).
  lo_vehicle->display_type( ).

  " Demonstrating Downcasting
  IF lo_vehicle IS INSTANCE OF cl_car.
    " Downcast to cl_car and call a specific method if necessary
    lo_car ?= lo_vehicle.
    WRITE: / 'Downcast to Car successful.'.
  ELSEIF lo_vehicle IS INSTANCE OF cl_truck.
    " Downcast to cl_truck
    lo_truck ?= lo_vehicle.
    WRITE: / 'Downcast to Truck successful.'.
  ENDIF.
