*&---------------------------------------------------------------------*
*& Report ZAV_TEST_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_test_alv.

*---------------------------------------------------------------------*
* Classic ALV demo using REUSE_ALV_GRID_DISPLAY
* - Reads SFLIGHT if data exists
* - Falls back to internal demo data if table is empty
* - Demonstrates hotspot/double-click handling via &IC1
* - Demonstrates layout, sorting, and optional row highlighting
*---------------------------------------------------------------------*

TYPE-POOLS: slis.
TABLES: sflight.
*---------------------------------------------------------------------*
* Local output structure
* We define our own type so the report remains self-contained.
* FIELD catalog will TRY SFLIGHT first, then fallback to manual build.
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_flight,
         carrid     TYPE c LENGTH 3,
         connid     TYPE n LENGTH 4,
         fldate     TYPE d,
         price      LIKE sflight-price,
         currency   TYPE c LENGTH 3,
         planetype  TYPE c LENGTH 10,
         seatsmax   TYPE i,
         seatsocc   TYPE i,
         line_color TYPE c LENGTH 4, "ALV row color via INFO_FIELDNAME
       END OF ty_flight.

DATA: gt_flights  TYPE STANDARD TABLE OF ty_flight,
      gs_flight   TYPE ty_flight,
      gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.
*---------------------------------------------------------------------*
* Start of report
*---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data.
  BREAK-POINT.
  PERFORM prepare_fieldcat. "Step no 1. " Create Field Catlog
  PERFORM prepare_layout.   "Step no 2. " Create Layout
  PERFORM display_alv.      "Step no 3. " Display

*---------------------------------------------------------------------*
* Read data from SFLIGHT.
* If no rows are returned, fill local demo data.
*---------------------------------------------------------------------*
FORM get_data.
  SELECT carrid
         connid
         fldate
         price
         currency
         planetype
         seatsmax
         seatsocc
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flights
    UP TO 20 ROWS.
ENDFORM.
*---------------------------------------------------------------------*
* Build field catalog
* Try DDIC-based merge first with SFLIGHT. If that fails or produces
* nothing useful for our local table, fallback to manual field catalog.
*---------------------------------------------------------------------*
FORM prepare_fieldcat.
  DATA: lv_repid TYPE sy-repid.
  lv_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = lv_repid
      i_structure_name       = 'SFLIGHT'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0 OR gt_fieldcat IS INITIAL.
    PERFORM build_manual_fieldcat.
  ELSE.
    PERFORM tweak_fieldcat_from_merge.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
* Manual fallback field catalog
*---------------------------------------------------------------------*
FORM build_manual_fieldcat.
  CLEAR gt_fieldcat.

  PERFORM add_fieldcat USING 'CARRID'    'Carrier'       'X'.
  PERFORM add_fieldcat USING 'CONNID'    'Connection'    space.
  PERFORM add_fieldcat USING 'FLDATE'    'Flight Date'   space.
  PERFORM add_fieldcat USING 'PRICE'     'Price'         space.
  PERFORM add_fieldcat USING 'CURRENCY'  'Curr.'         space.
  PERFORM add_fieldcat USING 'PLANETYPE' 'Plane Type'    space.
  PERFORM add_fieldcat USING 'SEATSMAX'  'Seats Max'     space.
  PERFORM add_fieldcat USING 'SEATSOCC'  'Seats Occ.'    space.
ENDFORM.

FORM add_fieldcat USING p_field p_text p_hotspot.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname  = p_field.
  gs_fieldcat-seltext_l  = p_text.
  gs_fieldcat-seltext_m  = p_text.
  gs_fieldcat-seltext_s  = p_text.
  gs_fieldcat-hotspot    = p_hotspot.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

*---------------------------------------------------------------------*
* Tweak merged field catalog:
* - keep only columns we actually show
* - set better headers
* - make carrier a hotspot
*---------------------------------------------------------------------*
FORM tweak_fieldcat_from_merge.
  DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
        ls_fieldcat TYPE slis_fieldcat_alv.

  LOOP AT gt_fieldcat INTO ls_fieldcat.
    CASE ls_fieldcat-fieldname.
      WHEN 'CARRID' OR 'CONNID' OR 'FLDATE' OR 'PRICE'
        OR 'CURRENCY' OR 'PLANETYPE' OR 'SEATSMAX' OR 'SEATSOCC'.
        CASE ls_fieldcat-fieldname.
          WHEN 'CARRID'.
            ls_fieldcat-hotspot  = 'X'.
            ls_fieldcat-seltext_l = 'Carrier'.
          WHEN 'CONNID'.
            ls_fieldcat-seltext_l = 'Connection'.
          WHEN 'FLDATE'.
            ls_fieldcat-seltext_l = 'Flight Date'.
          WHEN 'PRICE'.
            ls_fieldcat-seltext_l = 'Price'.
          WHEN 'CURRENCY'.
            ls_fieldcat-seltext_l = 'Curr.'.
          WHEN 'PLANETYPE'.
            ls_fieldcat-seltext_l = 'Plane Type'.
          WHEN 'SEATSMAX'.
            ls_fieldcat-seltext_l = 'Seats Max'.
          WHEN 'SEATSOCC'.
            ls_fieldcat-seltext_l = 'Seats Occ.'.
        ENDCASE.
        APPEND ls_fieldcat TO lt_fieldcat.
    ENDCASE.
  ENDLOOP.

  gt_fieldcat = lt_fieldcat.

  IF gt_fieldcat IS INITIAL.
    PERFORM build_manual_fieldcat.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
* Layout settings
*---------------------------------------------------------------------*
FORM prepare_layout.
  CLEAR gs_layout.
  gs_layout-zebra             = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-info_fieldname    = 'LINE_COLOR'.
  gs_layout-window_titlebar   = 'Classic ALV Grid Demo'.
ENDFORM.

*---------------------------------------------------------------------*
* Display ALV
*---------------------------------------------------------------------*
FORM display_alv.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = gs_layout
      it_fieldcat             = gt_fieldcat
      i_save                  = 'A'
    TABLES
      t_outtab                = gt_flights
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Error while displaying ALV.' TYPE 'I'.
  ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
* User action handler
* &IC1 is raised for double-click and hotspot click
*---------------------------------------------------------------------*
FORM user_command USING    p_ucomm     LIKE sy-ucomm
                           ps_selfield TYPE slis_selfield.

  DATA: lv_line1 TYPE c LENGTH 100,
        lv_line2 TYPE c LENGTH 100.

  CASE p_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_flights INTO gs_flight INDEX ps_selfield-tabindex.
      IF sy-subrc = 0.
        CONCATENATE 'Carrier:' gs_flight-carrid
                    'Connection:' gs_flight-connid
               INTO lv_line1 SEPARATED BY space.
        CONCATENATE 'Date:' gs_flight-fldate
               INTO lv_line2 SEPARATED BY space.

        CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
          EXPORTING
            titel     = 'Selected Flight'
            textline1 = lv_line1
            textline2 = lv_line2.
      ENDIF.
  ENDCASE.

  ps_selfield-refresh = 'X'.

ENDFORM.