*&---------------------------------------------------------------------*
*&  Include           ZSOD_SUB_ROUTINES
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_FIRST_DAY_OF_MONTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_first_day_of_month.
  DATA : date TYPE sy-datum.
  date = sy-datum.
  date+6(2) = '01'.
  gv_first_day = date.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DEFAULT TRANSACTION LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        textERNAM
*  <--  p2        text
*----------------------------------------------------------------------*
FORM default_transaction_list.
DATA: sel_tcode LIKE TABLE OF s_tcode.
DATA: sw_tcode LIKE LINE OF s_tcode.
CLEAR: sw_tcode.

SELECT sign opti low high
  FROM tvarvc
  INTO sw_tcode
  WHERE name = 'ZSODREPTCODES' "The variable name given in STVARV
    AND type = 'S'
    AND low IN s_tcode.
  APPEND sw_tcode TO  sel_tcode.
  CLEAR: sw_tcode.
ENDSELECT.

IF sel_tcode[] IS NOT INITIAL.
SELECT tablename tcode
  FROM ztsodstr
  INTO TABLE gt_tcodes
  WHERE tcode IN sel_tcode.
ELSE.
  MESSAGE 'Please maintain the variable ZSODREPTCODES in the table TVARVC, Tcode(STVARV)' TYPE 'I'.
  EXIT.
ENDIF.

DELETE ADJACENT DUPLICATES FROM gt_tcodes COMPARING ALL FIELDS.
PERFORM get_tcodes_to_table_map.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FINAL_TABLE_STRUCTURE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_final_table_structure.
IF gt_fields[] IS NOT INITIAL.
  gtf_fields[] = gt_fields[].
  SORT gtf_fields BY tabfield.
  DELETE ADJACENT DUPLICATES FROM gtf_fields COMPARING tabfield.
  SORT gtf_fields BY sqnc.

** Create structure of dynamic internal table
  ls_component-name = 'ROLE_NAME'.
  ls_component-type ?= cl_abap_datadescr=>describe_by_name( 'AGR_NAME' ).
  APPEND ls_component TO gt_component.
  CLEAR: gw_fields, ls_component.

  ls_component-name = 'USER_NAME'.
  ls_component-type ?= cl_abap_datadescr=>describe_by_name( 'ZUSER_FIELD' ).
  APPEND ls_component TO gt_component.
  CLEAR: gw_fields, ls_component.

  ls_component-name = 'TCODE'.
  ls_component-type ?= cl_abap_datadescr=>describe_by_name( 'AGXREPORT' ).
  APPEND ls_component TO gt_component.
  CLEAR: gw_fields, ls_component.
  CLEAR: gw_fields,ls_component.
  LOOP AT gtf_fields INTO  gw_fields.
    CLEAR: wfies_tab.
    PERFORM get_field_details USING gw_fields-table gw_fields-tabfield.
    READ TABLE dfies_tab INTO wfies_tab INDEX 1.
    ls_component-name = wfies_tab-fieldname.
    ls_component-type ?= cl_abap_datadescr=>describe_by_name( wfies_tab-rollname ).
    APPEND ls_component TO gt_component.
    CLEAR: gw_fields, ls_component.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM gt_component COMPARING name.
  gr_struct_typ  ?= cl_abap_structdescr=>create( p_components = gt_component ).
  gr_dyntable_typ = cl_abap_tabledescr=>create( p_line_type = gr_struct_typ ).
ELSE.
  MESSAGE 'Please maintain the field configuration for the given T-Code(s).' TYPE 'I'.
  EXIT.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_USER_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_user_details.
 IF gt_tcodes[] IS NOT INITIAL.
  PERFORM get_role_details.
  PERFORM get_final_table.
ELSE.
  MESSAGE 'Please maintain the field configuration for the given T-Code(s).' TYPE 'I'.
  EXIT.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FINAL_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_final_table.
  DATA: wtcode LIKE gw_tcodes.
  CREATE DATA:
  gt_dyn_table TYPE HANDLE gr_dyntable_typ.
  ASSIGN gt_dyn_table->* TO <gfs_dyn_table>.

  CREATE DATA:
  gw_dyn_line LIKE LINE OF <gfs_dyn_table>. "gr_struct_typ.
  ASSIGN gw_dyn_line->* TO <gfs_line>.

   IF gt_user_roles[] IS NOT INITIAL
      AND gt_tcodes[] IS NOT INITIAL
      AND gt_fields[] IS NOT INITIAL
      AND gt_tables[] IS NOT INITIAL.

     CLEAR: gw_tables, gw_fields.
     LOOP AT gt_tables INTO gw_tables.
        DATA sline TYPE fieldname .
        DATA line TYPE fieldname OCCURS 0.

        DATA table TYPE string.
        REFRESH: line.
        LOOP AT gt_fields INTO gw_fields WHERE table = gw_tables-table.
          sline = gw_fields-tabfield.
          APPEND sline TO line.
          CLEAR: gw_fields, sline.
        ENDLOOP.
        DELETE ADJACENT DUPLICATES FROM line COMPARING ALL FIELDS.
        CONDENSE gw_tables-table.
        CREATE DATA itab TYPE STANDARD TABLE OF (gw_tables-table).
        ASSIGN itab->* TO <fs_header>.

        IF gt_udfields[] IS NOT INITIAL.
         CLEAR: gw_udfields, gw_user_roles.
         LOOP AT gt_user_roles INTO gw_user_roles.
           READ TABLE gt_udfields INTO gw_udfields WITH KEY table = gw_tables-table.

           PERFORM build_where USING gw_tables-table gw_udfields-userfield
                                     'EQ' gw_user_roles-bname space.
           READ TABLE where_clause INTO user_cond INDEX 1.

           PERFORM build_where USING gw_tables-table gw_udfields-date_field
                  'BT' s_dater-low s_dater-high.
           READ TABLE where_clause INTO date_cond INDEX 1.

           IF line IS NOT INITIAL
              AND gw_udfields-table IS NOT INITIAL
              AND user_cond IS NOT INITIAL
              AND date_cond IS NOT INITIAL.

             CLEAR wfies_tab.
             PERFORM get_field_details USING gw_udfields-table 'TCODE'.
             READ TABLE dfies_tab INTO wfies_tab INDEX 1.

             IF wfies_tab IS INITIAL.
               REFRESH: <fs_header>.
               SELECT (line)
                 FROM (gw_udfields-table)
                 APPENDING CORRESPONDING FIELDS OF TABLE <fs_header>
*                 UP TO 3 ROWS. "To be user For Testing Purpose only.
                 WHERE (user_cond)
                   AND (date_cond).
             ELSE.
               REFRESH: <fs_header>.
               SELECT (line)
                 FROM (gw_udfields-table)
                 APPENDING CORRESPONDING FIELDS OF TABLE <fs_header>
*                 UP TO 3 ROWS. "To be user For Testing Purpose only.
                 WHERE (user_cond)
                   AND (date_cond)
                   AND tcode = gw_udfields-tcode.
             ENDIF.
             DELETE ADJACENT DUPLICATES FROM <fs_header> COMPARING ALL FIELDS.
           ELSE.
             MESSAGE 'Critical configuration missing in ZSODSTR' TYPE 'I'.
             EXIT.
           ENDIF.

             UNASSIGN: <fs1>.
             LOOP AT <fs_header> ASSIGNING <fs1>.
               CLEAR <gfs_line>.
               CLEAR wtcode.
               READ TABLE gt_tcodes INTO wtcode WITH KEY name = gw_tables-table.
               MOVE-CORRESPONDING <fs1> TO <gfs_line>.
               ASSIGN COMPONENT 'ROLE_NAME' OF STRUCTURE <gfs_line> TO <role_name>.
               <role_name> = gw_user_roles-agr_name.
               ASSIGN COMPONENT 'USER_NAME' OF STRUCTURE <gfs_line> TO <user_name>.
               <user_name> = gw_user_roles-bname.
               ASSIGN COMPONENT 'TCODE' OF STRUCTURE <gfs_line> TO <tcode>.
               <tcode> = wtcode-tcode.
               APPEND <gfs_line> TO <gfs_dyn_table>.
               CLEAR wtcode.
             ENDLOOP.
             CLEAR: gw_udfields, gw_user_roles.
         ENDLOOP.
        ELSE.
          MESSAGE 'Critical configuration missing in ZSODSTR' TYPE 'I'.
          EXIT.
        ENDIF.

       CLEAR: gw_tables.
     ENDLOOP.
     DELETE ADJACENT DUPLICATES FROM <gfs_dyn_table> COMPARING ALL FIELDS.
   ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ROLE_DETAILS
*&----------------------------------------  -----------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM get_role_details.
  SELECT agr_name uname
    FROM agr_users
    INTO TABLE gt_user_roles
    WHERE from_dat LE sy-datum
      AND to_dat GE sy-datum
      AND agr_name IN s_roles
      AND uname IN s_bname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TCODES_TO_TABLE_MAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_tcodes_to_table_map.
  IF gt_tcodes[] IS NOT INITIAL.
    REFRESH: gt_fields, gt_tables, gt_udfields.
    CLEAR: gw_tcodes, gw_fields, gw_tables, gw_udfields.
    LOOP AT gt_tcodes INTO gw_tcodes.
      SELECT squence tablename tablefield tcode
             description display_text
        FROM ztsodstr
        APPENDING TABLE gt_fields
        WHERE tablename = gw_tcodes-name.

        SELECT tcode tablename user_field tab_dt_field
          FROM ztsodstr
          APPENDING TABLE gt_udfields
          WHERE tablename = gw_tcodes-name.

        gw_tables-table = gw_tcodes-name.
        APPEND gw_tables TO gt_tables.
        CLEAR: gw_tcodes, gw_tables, gw_fields, gw_udfields.
    ENDLOOP.

    IF sy-subrc = 0.
      SORT gt_tables BY table.
      SORT gt_fields BY sqnc.
      SORT gt_udfields BY table.
      DELETE ADJACENT DUPLICATES FROM gt_tables COMPARING ALL FIELDS.
      DELETE ADJACENT DUPLICATES FROM gt_udfields COMPARING ALL FIELDS.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_WHERE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_where USING VALUE(table)
                       VALUE(field)
                       VALUE(op)
                       VALUE(value_low)
                       VALUE(value_high).

  REFRESH: condtab, where_clause.

  CLEAR: wcondtab, table.
  wcondtab-field = field.
  wcondtab-opera = op.
  wcondtab-low = value_low.
  wcondtab-high = value_high.
  APPEND wcondtab TO condtab.
  CLEAR: wcondtab.

CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
  EXPORTING
    dbtable               = table
  TABLES
    condtab               = condtab
    where_clause          = where_clause
 EXCEPTIONS
   empty_condtab         = 1
   no_db_field           = 2
   unknown_db            = 3
   wrong_condition       = 4
   OTHERS                = 5
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FIELD_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_field_details USING VALUE(tablename)
                             VALUE(fieldname).

REFRESH: dfies_tab.

CALL FUNCTION 'DDIF_FIELDINFO_GET'
  EXPORTING
     tabname              = tablename
     fieldname            = fieldname
     langu                = sy-langu
*     LFIELDNAME           = ' '
*     ALL_TYPES            = ' '
*     GROUP_NAMES          = ' '
*     UCLEN                =
*     DO_NOT_WRITE         = ' '
*   IMPORTING
*     X030L_WA             =
*     DDOBJTYPE            =
*     DFIES_WA             =
*     LINES_DESCR          =
   TABLES
     dfies_tab            = dfies_tab
*     FIXED_VALUES         =
   EXCEPTIONS
     not_found            = 1
     internal_error       = 2
     OTHERS               = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CLEAR: tablename, fieldname.
ENDFORM.
