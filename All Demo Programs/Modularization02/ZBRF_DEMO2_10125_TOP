*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO6_10125_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO5_10125_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_output,
         status(0004),
         carrid       TYPE  s_carr_id,
         connid       TYPE  s_conn_id,
         fldate       TYPE  s_date,
         price        TYPE  s_price,
         currency     TYPE  s_currcode,
         planetype    TYPE  s_planetye,
       END OF ty_output.

TYPES: BEGIN OF ty_view,
         carrid    TYPE  s_carr_id,
         connid    TYPE  s_conn_id,
         fldate    TYPE  s_date,
         price     TYPE  s_price,
         currency  TYPE  s_currcode,
         planetype TYPE  s_planetye,
       END OF ty_view.

TYPES: BEGIN OF ty_join,
         carrid   TYPE  s_carr_id,
         connid   TYPE  s_conn_id,
         carrname TYPE  s_carrname,
       END OF ty_join.

DATA: gt_view   TYPE TABLE OF ty_view,
      gt_join   TYPE TABLE OF ty_join,
      gt_output TYPE TABLE OF ty_output.

DATA: it_raw TYPE truxs_t_text_data.
DATA: gv_col_pos TYPE i VALUE 0.

***************************************
********* ALV Grid Variables
***************************************
***************************************
********* Field Catalog Variable
***************************************
DATA: it_fieldcat TYPE slis_t_fieldcat_alv.
DATA: wa_fieldcat TYPE slis_fieldcat_alv.

***************************************
********* ALV Layout Grid
***************************************
DATA: gd_layout TYPE slis_layout_alv.
DATA: gt_list_top_of_page TYPE slis_t_listheader.

***************************************
********* ALV Layout Grid
***************************************
DATA: it_filter TYPE slis_t_filter_alv.
DATA: g_save TYPE c.
DATA: g_exit TYPE c.
DATA: g_variant LIKE disvariant.
DATA: gx_variant LIKE disvariant.
DATA: gv_repid TYPE sy-repid.
DATA: wa_exclude TYPE slis_extab.
DATA: it_exclude TYPE slis_t_extab.
