*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO_10125
*&---------------------------------------------------------------------*
*&  ty_ types
*&  gt_ global table
*&  gw_ global work area
*&  gv_ global value
*&  gc_ global constant
*&  gs_ global structure
*&  lt_ local table
*&  lw_ local work area
*&  lv_ local value
*&  lc_ local constant
*&  ls_ local structure
*&---------------------------------------------------------------------*
*&  sy-uname : Username
*&  sy-uzeit : System Current Time
*&  sy-datum : System Current Date
*&  sy-subrc : Error Status in execution of program / Error Handling
*&---------------------------------------------------------------------*
REPORT zbrf_demo_10125.

*BREAK-POINT.
* DATA: lv_date TYPE sy-datum.
*  lv_date = sy-datum.

  INCLUDE zbrf_demo_10125_scr.
  INCLUDE zbrf_demo_10125_top.
  INCLUDE zbrf_demo_10125_fun.
  INCLUDE zbrf_demo_10125_out.

INITIALIZATION.
* p_carrid = 'AA'.

START-OF-SELECTION.
PERFORM get_flight_data USING p_carrid.

END-OF-SELECTION.
BREAK-POINT.
  PERFORM save_data.
  PERFORM output_list.
