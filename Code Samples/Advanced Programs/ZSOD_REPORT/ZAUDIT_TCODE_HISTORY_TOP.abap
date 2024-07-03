*&---------------------------------------------------------------------*
*&  Include           ZAUDIT_TCODE_HISTORY_TOP
*&---------------------------------------------------------------------*

TABLES: usr01, cdhdr, bapiagr, agr_users, dfies,
        tvarvc, ztsodstr, agr_tcodes, hrcond.

TYPE-POOLS: slis.

** Structure to hold all the roles that belongs the users.
TYPES: BEGIN OF ty_user_roles,
          agr_name TYPE agr_users-agr_name,
          bname TYPE usr01-bname,
       END OF ty_user_roles.

"Global Tables - ty_roles
DATA: gt_user_roles TYPE STANDARD TABLE OF ty_user_roles.
"Global WorkArea - ty_roles
DATA: gw_user_roles TYPE ty_user_roles.

** Structure to hold the values of the table name associated
** to the t-code.
TYPES: BEGIN OF ty_tcodes,
          name TYPE ztsodstr-tablename,
          tcode TYPE ztsodstr-tcode,
       END OF ty_tcodes.

"Global Tables - ty_tcodes
DATA: gt_tcodes TYPE STANDARD TABLE OF ty_tcodes.
"Global WorkArea - ty_tcodes
DATA: gw_tcodes TYPE ty_tcodes.

** Structure to hold the values of the table associated
** to the t-code header table.
TYPES: BEGIN OF ty_tables,
          table TYPE ztsodstr-tablename,
       END OF ty_tables.

"Global Tables Fields - ty_tables
DATA: gt_tables TYPE STANDARD TABLE OF ty_tables.
"Global WorkArea - ty_tables
DATA: gw_tables TYPE ty_tables.

** Structure to hold the values of the table field associated
** to the t-code header table.
TYPES: BEGIN OF ty_fields,
        sqnc TYPE ztsodstr-squence,
        table TYPE ztsodstr-tablename,
        tabfield TYPE ztsodstr-tablefield,
        tcode TYPE ztsodstr-tcode,
        desc TYPE ztsodstr-description,
        display_text TYPE  ztsodstr-display_text,
       END OF ty_fields.

"Global Tables Fields - ty_fields
DATA: gt_fields TYPE STANDARD TABLE OF ty_fields.
"Global WorkArea - ty_fields
DATA: gw_fields TYPE ty_fields.

** Structure to hold the values of the table user date field associated
** to the header table.
TYPES: BEGIN OF ty_udfield,
        tcode TYPE ztsodstr-tcode,
        table TYPE ztsodstr-tablename,
        userfield TYPE ztsodstr-user_field,
        date_field TYPE ztsodstr-tab_dt_field,
       END OF ty_udfield.

"Global Tables Fields - ty_fields
DATA: gt_udfields TYPE STANDARD TABLE OF ty_udfield.
"Global WorkArea - ty_fields
DATA: gw_udfields TYPE ty_udfield.

"Global Variables
DATA: gv_first_day TYPE sy-datum.
DATA: itab TYPE REF TO data.
DATA: gtf_fields LIKE gt_fields.
DATA: user_cond TYPE string.
DATA: date_cond TYPE string.
DATA: user_field TYPE string.
DATA: date_field TYPE string.
DATA: table TYPE dfies-tabname.
DATA: where_clause TYPE STANDARD TABLE OF string.
DATA: condtab TYPE STANDARD TABLE OF hrcond.
DATA: ttvarvc TYPE STANDARD TABLE OF tvarvc.
DATA: wtvarvc TYPE tvarvc.
DATA: wcondtab TYPE hrcond.
DATA: wwhere_clause TYPE  string.

FIELD-SYMBOLS: <fs_header> TYPE STANDARD TABLE.
"Dynamic Final Table Declaration
DATA :  gt_dyn_table TYPE REF TO data,
        gw_dyn_line  TYPE REF TO data,
        gw_dyn_line1 TYPE REF TO data.

*Final ALV Table workareas
DATA: tablename TYPE ddobjname,
      fieldname TYPE dfies-fieldname,
      dfies_tab TYPE STANDARD TABLE OF dfies,
      wfies_tab TYPE dfies.

*Dynamic Final Table Declaratoins.
DATA :   gr_struct_typ   TYPE REF TO  cl_abap_datadescr,
         gr_dyntable_typ TYPE REF TO  cl_abap_tabledescr,
         ls_component    TYPE cl_abap_structdescr=>component,
         gt_component    TYPE         cl_abap_structdescr=>component_table.

* Field Symbold Final ALV Table Declaration
FIELD-SYMBOLS: <gfs_dyn_table> TYPE STANDARD TABLE,
               <fs1>.
FIELD-SYMBOLS: <gfs_line> TYPE any.
FIELD-SYMBOLS: <role_name> TYPE any,
               <user_name> TYPE any,
               <tcode> TYPE any.

***************************************
*********  ALV Grid Variables
***************************************
DATA: wa_fieldcat  TYPE slis_fieldcat_alv.
DATA: gd_layout    TYPE slis_layout_alv.
DATA: gt_list_top_of_page TYPE slis_t_listheader.
DATA: it_fieldcat  TYPE slis_t_fieldcat_alv.
DATA: it_filter    TYPE  slis_t_filter_alv.
DATA: g_save TYPE c.
DATA: g_exit TYPE c.
DATA: g_variant LIKE disvariant.
DATA: gx_variant LIKE disvariant.
DATA: gv_repid TYPE  sy-repid.
DATA: wa_exclude TYPE slis_extab.
DATA: it_exclude TYPE slis_t_extab.
DATA: col_pos TYPE i.

***************************************
*********  EXCEL Upload Variables
***************************************
DATA: it_datatab type standard table of ztsodstr,
      wa_datatab type ztsodstr.

DATA: it_raw TYPE truxs_t_text_data.
