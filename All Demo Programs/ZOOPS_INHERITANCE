*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO8_DS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo8_ds.

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
* CLASS lcl_passenger_plane IMPLEMENTATION
*------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.
  METHOD constructor.
    DATA: ls_planetype TYPE saplane.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    SELECT SINGLE * FROM saplane
    INTO ls_planetype
    WHERE planetype = iv_planetype.

    get_technical_attributes(
      EXPORTING
      iv_type = iv_planetype
      IMPORTING
      ev_weight = mv_weight
      ev_tankcap = mv_tankcap
      EXCEPTIONS
      wrong_planetype = 1
    ).

    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ELSE.
* mv_weight = ls_planetype-weight.
* mv_tankcap = ls_planetype-tankcap.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ENDIF.
  ENDMETHOD. "constructor

  METHOD display_attributes.
    WRITE:
        / icon_ws_plane AS ICON,
        / 'Name of Airplane'(001) , AT c_pos_1 mv_name,
        / 'Type of Airplane:'(002), AT c_pos_1 mv_planetype,
        / 'Weight:'(003), AT c_pos_1 mv_weight
        LEFT-JUSTIFIED,
        / 'Tank capacity:'(004), AT c_pos_1 mv_tankcap
        LEFT-JUSTIFIED.
  ENDMETHOD. "display_attributes

  METHOD set_attributes.
  ENDMETHOD. "set_attributes

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.
  ENDMETHOD.

  METHOD display_n_o_airplanes.
    SKIP.
    WRITE: / 'Number of airplanes:'(ca1),
    AT c_pos_1 gv_n_o_airplanes LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.

  METHOD get_technical_attributes.
    DATA: ls_planetype TYPE saplane.
    READ TABLE gt_planetypes INTO ls_planetype
    WITH TABLE KEY planetype = iv_type
    TRANSPORTING weight tankcap.
    IF sy-subrc = 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
*------------------------------------------------*
* CLASS lcl_passenger_plane IMPLEMENTATION
*------------------------------------------------*
CLASS lcl_passenger_plane IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
    EXPORTING
    iv_name = iv_name
    iv_planetype = iv_planetype
    EXCEPTIONS
    wrong_planetype = 1 ).
    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ENDIF.
    mv_seats = iv_seats.
  ENDMETHOD. "constructor

  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:
    / 'Max Seats:'(006), AT c_pos_1 mv_seats
    LEFT-JUSTIFIED.
    ULINE.
  ENDMETHOD. "display_attributes
ENDCLASS. "lcl_passenger_plane IMPLEMENTATION
*------------------------------------------------*
* CLASS lcl_cargo_plane IMPLEMENTATION
*------------------------------------------------*
CLASS lcl_cargo_plane IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
    EXPORTING
    iv_name = iv_name
    iv_planetype = iv_planetype
    EXCEPTIONS
    wrong_planetype = 1 ).
    IF sy-subrc <> 0.
      RAISE wrong_planetype.
    ENDIF.
    mv_cargo = iv_cargo.
  ENDMETHOD. "constructor

  METHOD display_attributes.
    super->display_attributes( ).
    WRITE:
    / 'Max Cargo:'(005), AT c_pos_1 mv_cargo
    LEFT-JUSTIFIED.
    ULINE.
  ENDMETHOD. "display_attributes
ENDCLASS. "lcl_cargo_plane IMPLEMENTATION

START-OF-SELECTION.
  BREAK-POINT.
  DATA:
    go_airplane  TYPE REF TO lcl_airplane,
    gt_airplanes TYPE TABLE OF REF TO lcl_airplane.

  DATA:
    go_cargo     TYPE REF TO lcl_cargo_plane,
    go_passenger TYPE REF TO lcl_passenger_plane.

  DATA:
     gv_count TYPE i.

  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.


  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->display_attributes( ).
  ENDLOOP.


  CREATE OBJECT go_passenger
    EXPORTING
      iv_name         = 'LH BERLIN'
      iv_planetype    = '747-400'
      iv_seats        = 345
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc = 0.
* do nothing for now
  ENDIF.

  CREATE OBJECT go_cargo
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
      iv_cargo        = 533
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc = 0.
* do nothing just now
  ENDIF.

  go_passenger->display_attributes( ).
  go_cargo->display_attributes( ).


  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  SKIP 2.
  WRITE: / 'Number of airplanes'(ca1), gv_count.
