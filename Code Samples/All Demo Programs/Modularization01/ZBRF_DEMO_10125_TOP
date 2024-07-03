*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO5_10125_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_record,
         carrid    TYPE  s_carr_id,
         connid    TYPE  s_conn_id,
         fldate    TYPE  s_date,
         price     TYPE  s_price,
         currency  TYPE  s_currcode,
         planetype TYPE  s_planetye,
       END OF ty_record.

DATA: t_upload TYPE STANDARD TABLE OF ty_record.
DATA: w_upload TYPE ty_record.
DATA: it_raw TYPE truxs_t_text_data.
DATA gv_col_pos TYPE i VALUE 0.

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
