*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO8_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo8_test.

INTERFACE lcl_airplane.
  CONSTANTS: c_pos_1 TYPE i VALUE 30.
  METHODS: display_attributes,
    set_attributes
      IMPORTING
        iv_name      TYPE string
        iv_planetype TYPE saplane-planetype.

  CLASS-METHODS:
    display_n_o_airplanes,
    get_n_o_airplanes
      RETURNING VALUE(rv_count) TYPE i.
ENDINTERFACE.

CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
*    INTERFACES: lcl_airplane.

ENDCLASS.

CLASS lcl_test IMPLEMENTATION.



ENDCLASS.

CLASS lcl_test2 DEFINITION.
  PUBLIC SECTION.
*    INTERFACES: lcl_airplane.
ENDCLASS.

CLASS lcl_test2 IMPLEMENTATION.


ENDCLASS.
