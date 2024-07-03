*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO9_EVENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo9_event.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    EVENTS: no_vendor_found.
    METHODS: get_vendor_details
      IMPORTING iv_lifnr TYPE lifnr
      EXPORTING es_lfa   TYPE lfa1.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD get_vendor_details.

    SELECT SINGLE * FROM lfa1
      INTO es_lfa
     WHERE lifnr = iv_lifnr.
    IF sy-subrc NE 0.
      RAISE EVENT no_vendor_found.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: event_handler FOR EVENT no_vendor_found OF lcl_main.
ENDCLASS.
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD event_handler.
    WRITE: 'NO VENDOR FOUND'.
  ENDMETHOD.
ENDCLASS.

PARAMETERS: p_lifnr TYPE lifnr.

START-OF-SELECTION.


  DATA(lo_main) = NEW lcl_main( ).
*-------------------------------------------------------------
*  DATA lo_event_handler TYPE REF TO lcl_event_handler.
*  CREATE OBJECT lo_event_handler.
  DATA(lo_event_handler) = NEW lcl_event_handler( ).
*-------------------------------------------------------------

  SET HANDLER lo_event_handler->event_handler FOR lo_main.

*-------------------------------------------------------------
*  DATA ls_lfa TYPE lfa1.

  lo_main->get_vendor_details(
    EXPORTING
      iv_lifnr = p_lifnr
    IMPORTING
      es_lfa = DATA(ls_lfa)
  ).

*  CALL METHOD lo_main->get_vendor_details
*    EXPORTING
*      iv_lifnr = p_lifnr
*    IMPORTING
*      es_lfa   = DATA(ls_lfa).
*-------------------------------------------------------------
