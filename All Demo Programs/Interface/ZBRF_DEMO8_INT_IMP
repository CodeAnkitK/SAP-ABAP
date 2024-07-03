*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO8_INT_IMP
*&---------------------------------------------------------------------*
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
*------------------------------------------------*
* CLASS lcl_carrier IMPLEMENTATION
*------------------------------------------------*
*---------------------------------------------------*
* CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------*
CLASS lcl_carrier IMPLEMENTATION.
  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD. "constructor
  METHOD display_attributes.
    SKIP 2.
    WRITE: icon_flight AS ICON,
    mv_name.
    ULINE.
    ULINE.
    me->display_airplanes( ).
  ENDMETHOD. "display_attributes
  METHOD add_airplane.
    APPEND io_plane TO mt_airplanes.
  ENDMETHOD. "add_airplane
  METHOD display_airplanes.
    DATA: lo_plane TYPE REF TO lcl_airplane.
    LOOP AT mt_airplanes INTO lo_plane.
      lo_plane->display_attributes( ).
    ENDLOOP.
  ENDMETHOD. "display_airplanes
  METHOD lif_partner~display_partner.
    me->display_attributes( ).
  ENDMETHOD. "lif_partner~display_partner
ENDCLASS. "lcl_carrier IMPLEMENTATION
*---------------------------------------------------*
* CLASS lcl_travel_agency IMPLEMENTATION
*---------------------------------------------------*
CLASS lcl_travel_agency IMPLEMENTATION.
  METHOD display_attributes.
    WRITE: / icon_private_files AS ICON,
    'Travel Agency:'(007), mv_name.
    ULINE.
    display_agency_partners( ).
  ENDMETHOD. "display_attributes
  METHOD display_agency_partners.
    DATA:
    lo_partner TYPE REF TO lif_partner.
    WRITE 'Here are the partners of the travel agency:'(008).
    ULINE.
    LOOP AT mt_partners INTO lo_partner.
      lo_partner->display_partner( ).
    ENDLOOP.
  ENDMETHOD. "display_agency_partners
  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD. "constructor
  METHOD add_partner.
    APPEND io_partner TO mt_partners.
  ENDMETHOD. "add_partner
ENDCLASS. "lcl_travel_agency IMPLEMENTATION
