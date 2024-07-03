*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO8_INT_DEF
*&---------------------------------------------------------------------*

*&-------------------------------------------------*
*& Include BC401_INT_S2_AGENCY
*&-------------------------------------------------*
INTERFACE lif_partner.
  METHODS:
    display_partner.
ENDINTERFACE. "lif_partner
*--------------------------------------------------------*
* CLASS lcl_airplane DEFINITION *
*--------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    CONSTANTS: c_pos_1 TYPE i VALUE 30.
*------------------------------------------------*
* CONSTRUCTOR
*------------------------------------------------*
    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
        EXCEPTIONS
          wrong_planetype,

*------------------------------------------------*
* Display Attribute
*------------------------------------------------*
      display_attributes,

*------------------------------------------------*
* Set Attribute
*------------------------------------------------*
      set_attributes
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype.

    CLASS-METHODS:
      class_constructor,
      display_n_o_airplanes,
      get_n_o_airplanes
        RETURNING VALUE(rv_count) TYPE i.

  PRIVATE SECTION.

    TYPES:
     ty_planetypes TYPE STANDARD TABLE OF saplane
     WITH NON-UNIQUE KEY planetype.

    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype,
      mv_weight    TYPE saplane-weight,
      mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE ty_planetypes.

    CLASS-METHODS:
      get_technical_attributes
        IMPORTING
          iv_type    TYPE saplane-planetype
        EXPORTING
          ev_weight  TYPE saplane-weight
          ev_tankcap TYPE saplane-tankcap
        EXCEPTIONS
          wrong_planetype.

ENDCLASS. "lcl_airplane DEFINITION
*------------------------------------------------*
* CLASS lcl_passenger_plane DEFINITION
*------------------------------------------------*
CLASS lcl_passenger_plane
 DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_seats     TYPE s_seatsmax
        EXCEPTIONS
          wrong_planetype,

      display_attributes REDEFINITION.

  PRIVATE SECTION.
    DATA:
    mv_seats TYPE s_seatsmax.
ENDCLASS. "lcl_passenger_plane DEFINITION
*------------------------------------------------*
* CLASS lcl_cargo_plane DEFINITION
*------------------------------------------------*
CLASS lcl_cargo_plane DEFINITION
      INHERITING FROM lcl_airplane.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_cargo     TYPE s_plan_car
        EXCEPTIONS
          wrong_planetype,
      display_attributes REDEFINITION.

  PRIVATE SECTION.
    DATA: mv_cargo TYPE s_plan_car.


ENDCLASS. "lcl_cargo_plane DEFINITION
*------------------------------------------------*
* CLASS lcl_carrier DEFINITION
*------------------------------------------------*
CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      lif_partner.
    METHODS:
      constructor IMPORTING iv_name TYPE string,
      display_attributes,
      add_airplane IMPORTING io_plane TYPE
                               REF TO lcl_airplane.
  PRIVATE SECTION.
    DATA:
      mv_name      TYPE string,
      mt_airplanes TYPE TABLE OF REF TO lcl_airplane.
    METHODS:
      display_airplanes.
ENDCLASS. "lcl_carrier DEFINITION
*--------------------------------------------------*
* CLASS lcl_travel_agency DEFINITION
*--------------------------------------------------*
CLASS lcl_travel_agency DEFINITION.

  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_name TYPE string,
      add_partner IMPORTING io_partner
                              TYPE REF TO lif_partner,
      display_agency_partners,
      display_attributes.

  PRIVATE SECTION.
    DATA:
      mv_name     TYPE string,
      mt_partners TYPE TABLE OF REF TO lif_partner.
ENDCLASS. "lcl_travel_agency DEFINITION
