  METHOD trigger_event_for_eseal.
*---------------------------------------------------------------------*
*    External Dependencies                                            *                          *
*---------------------------------------------------------------------*
* Trigger point : ZDCL_UTILITY -> CREATE_LETTER
* ZDCL_RU_WF -> BI_EVENT_HANDLER_STATIC~ON_EVENT
*---------------------------------------------------------------------

    DATA: lv_objkey     TYPE c,
          lo_container1 TYPE REF TO if_swf_cnt_container.

    TRY.
        CALL METHOD cl_swf_cnt_factory=>create_event_container
          EXPORTING
            im_objcateg = 'CL'
            im_objtype  = 'ZDCL_RU_WF'
            im_event    = 'ESEAL'
          RECEIVING
            re_instance = lo_container1.
      CATCH cx_swf_utl_obj_create_failed.
    ENDTRY.

*-fill container (customer fields as well as standard fields)
    TRY.
        lo_container1->element_set( name = 'COTYP' value = iv_cotyp ).
        lo_container1->element_set( name = 'FBNUM' value = iv_fbnum ).
        lo_container1->element_set( name = 'GPART_KK' value = iv_taxpayer ).

      CATCH cx_swf_cnt_cont_access_denied ##NO_HANDLER.
      CATCH cx_swf_cnt_elem_not_found ##NO_HANDLER.
      CATCH cx_swf_cnt_elem_access_denied ##NO_HANDLER.
      CATCH cx_swf_cnt_elem_type_conflict ##NO_HANDLER.
      CATCH cx_swf_cnt_unit_type_conflict ##NO_HANDLER.
      CATCH cx_swf_cnt_elem_def_invalid ##NO_HANDLER.
      CATCH cx_swf_cnt_invalid_qname ##NO_HANDLER.
      CATCH cx_swf_cnt_container ##NO_HANDLER.
    ENDTRY.

    TRY.
        CALL METHOD cl_swf_evt_event=>raise
          EXPORTING
            im_objcateg        = 'CL'
            im_objtype         = 'ZDCL_RU_WF'
            im_event           = 'ESEAL'
            im_objkey          = lv_objkey
            im_event_container = lo_container1.
      CATCH cx_swf_evt_exception.
    ENDTRY.

  ENDMETHOD.
