*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO6_DS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo6_ds MESSAGE-ID bc402..

TYPE-POOLS: abap.

DATA:
  gt_cust TYPE ty_customers,
  gt_conn TYPE ty_connections.
DATA:
  gt_parmbind TYPE abap_parmbind_tab,
  gs_parmbind TYPE abap_parmbind.

DATA:
 gv_tabname TYPE string.

FIELD-SYMBOLS:
 <fs_table> TYPE ANY TABLE.

SELECTION-SCREEN COMMENT 1(80) TEXT-sel.

PARAMETERS:
  pa_xconn TYPE xfeld RADIOBUTTON GROUP tab DEFAULT 'X',
  pa_xcust TYPE xfeld RADIOBUTTON GROUP tab.

PARAMETERS:
 pa_nol TYPE i DEFAULT '100'.

START-OF-SELECTION.

BREAK-POINT.

* specific part
*------------------------------------------*
  CASE 'X'.
    WHEN pa_xconn.
      gv_tabname = 'SPFLI'.
      ASSIGN gt_conn TO <fs_table>.

      GET REFERENCE OF gt_conn INTO gs_parmbind-value.
      INSERT gs_parmbind INTO TABLE gt_parmbind.
    WHEN pa_xcust.
      gv_tabname = 'SCUSTOM'.

      ASSIGN gt_cust TO <fs_table>.

      GET REFERENCE OF gt_cust INTO gs_parmbind-value.
      INSERT gs_parmbind INTO TABLE gt_parmbind.
  ENDCASE.

* dynamic part
*---------------------------------------------*
  TRY.
      SELECT * FROM (gv_tabname) INTO TABLE <fs_table>
      UP TO pa_nol ROWS.
    CATCH cx_sy_dynamic_osql_error.
      MESSAGE e061.
  ENDTRY.
