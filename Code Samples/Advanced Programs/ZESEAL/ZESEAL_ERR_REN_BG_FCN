*&---------------------------------------------------------------------*
*& Include          ZESEAL_ERR_REN_BG_FCN
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form process_error_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

FORM process_error_log .
***************************************
* Processing the Error Log
***************************************
  FREE gt_log.

  IF s_date IS INITIAL.

    SELECT request_id
            cokey
            cotyp
            gpart
            vkont
            vtref
            add_gpart
            entry_date
            changed_date
            entry_time
            changed_time
            date_sent
            time_sent
            date_received
            time_received
            status
            status_desc
            error_desc
            cer_number
            version
            new_cotyp
            new_cokey
            seal_date
            seal_renew_date
            renewal_status
            base64_s
            base64_r
            signature
      INTO CORRESPONDING FIELDS OF TABLE gt_log
      FROM zdc_eseal_log
      WHERE gpart IN s_bp
        AND cokey IN s_cokey
        AND cotyp IN s_cotyp
        AND status = '04'
        AND entry_date LE sy-datum.

  ELSE.

    SELECT request_id
            cokey
            cotyp
            gpart
            vkont
            vtref
            add_gpart
            entry_date
            changed_date
            entry_time
            changed_time
            date_sent
            time_sent
            date_received
            time_received
            status
            status_desc
            error_desc
            cer_number
            version
            new_cotyp
            new_cokey
            seal_date
            seal_renew_date
            renewal_status
            base64_s
            base64_r
            signature
      INTO CORRESPONDING FIELDS OF TABLE gt_log
      FROM zdc_eseal_log
      WHERE gpart IN s_bp
        AND cokey IN s_cokey
        AND cotyp IN s_cotyp
        AND entry_date IN s_date
        AND status = '04'.
  ENDIF.

  IF sy-subrc EQ 0.
    UPDATE zdc_eseal_log SET status = '05' WHERE gpart IN s_bp
                                             AND cokey IN s_cokey
                                             AND cotyp IN s_cotyp
                                             AND entry_date LE sy-datum
                                             AND status = '04'.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      PERFORM call_processing_method USING 'ER'.
    ENDIF.
  ENDIF.

**** building ALV Layout
  PERFORM build_layout.
**** building Field Catalogue
  PERFORM build_fieldcat.
**** Displaying the List using FM
  PERFORM display_list.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_renew_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM process_renew_log.
***************************************
* Processing the Renew Log
***************************************
  DATA lv_date TYPE sy-datum.
  lv_date = sy-datum + 1.

  FREE gt_log.

  SELECT request_id
          cokey
          cotyp
          gpart
          vkont
          vtref
          add_gpart
          entry_date
          changed_date
          entry_time
          changed_time
          date_sent
          time_sent
          date_received
          time_received
          status
          status_desc
          error_desc
          cer_number
          version
          new_cotyp
          new_cokey
          seal_date
          seal_renew_date
          renewal_status
          base64_s
          base64_r
          signature
    INTO CORRESPONDING FIELDS OF TABLE gt_log
    FROM zdc_eseal_log
    WHERE seal_renew_date = lv_date.

  IF sy-subrc EQ 0.
    PERFORM call_processing_method USING 'RE'.
    UPDATE zdc_eseal_log SET renewal_status = 'X' WHERE seal_renew_date = lv_date.
    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form call_processing_method
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_processing_method  USING p_proc TYPE char2 .

**********************************************
* Calling the main method for reprocessing
**********************************************

  CONSTANTS: lc_es_class    TYPE seoclsname VALUE 'ZDCL_ODATA_INTERFACE',
             lc_es_method_1 TYPE seomtdname VALUE 'GENERATE_ESEAL_CERTIFICATE_DOC',
             lc_es_method_2 TYPE seomtdname VALUE 'TRIGGER_REPROCESS_ESEAL'.

  DATA lv_fbnum TYPE fbnum_ps.
  DATA ls_log TYPE zdc_eseal_log.
  DATA: lv_error TYPE char1.

  FREE gs_log.
  FREE gt_log_display.

  SELECT COUNT( * ) "#EC CI_SEL_NESTED or "#EC CI_SROFC_NESTED  "#EC CI_SUBRC
  FROM tmdir
  WHERE classname = lc_es_class
  AND   methodname IN ( lc_es_method_1, lc_es_method_2 ). "#EC CI_BYPASS

  IF sy-subrc = 0.
    LOOP AT gt_log INTO gs_log.

      lv_fbnum = gs_log-cokey.
      IF gs_log-base64_s IS INITIAL.
        CALL METHOD (lc_es_class)=>(lc_es_method_1)
          EXPORTING
            iv_fbnum    = lv_fbnum
            iv_cotyp    = gs_log-cotyp
            iv_taxpayer = gs_log-gpart
          IMPORTING
            ev_error    = lv_error.

      ELSE.
        MOVE-CORRESPONDING gs_log TO ls_log.
        CALL METHOD (lc_es_class)=>(lc_es_method_2)
          EXPORTING
            iv_fbnum      = lv_fbnum
            iv_cotyp      = gs_log-cotyp
            iv_taxpayer   = gs_log-gpart
            is_eseal_plog = ls_log
          IMPORTING
            ev_error      = lv_error.
      ENDIF.

      IF lv_error NE 'X'.
        CASE p_proc.
          WHEN 'ER'.
            PERFORM trigger_notification USING gs_log-gpart lv_fbnum.
          WHEN 'RE'.
        ENDCASE.
      ENDIF.

      FREE gs_log.
    ENDLOOP.
  ENDIF.

  SELECT request_id
          cokey
          cotyp
          gpart
          vkont
          vtref
          add_gpart
          entry_date
          changed_date
          entry_time
          changed_time
          date_sent
          time_sent
          date_received
          time_received
          status
          status_desc
          error_desc
          cer_number
          version
          new_cotyp
          new_cokey
          seal_date
          seal_renew_date
          renewal_status
          base64_s
          base64_r
          signature
    FROM zdc_eseal_log
    INTO TABLE gt_log_display
    FOR ALL ENTRIES IN gt_log
    WHERE cokey = gt_log-cokey
    AND cotyp = gt_log-cotyp
    AND gpart = gt_log-gpart.                             "#EC CI_SUBRC

  SORT gt_log BY cokey gpart entry_date entry_time DESCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form trigger_notification
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_LOG_GPART
*&---------------------------------------------------------------------*
FORM trigger_notification  USING p_partner TYPE zdc_eseal_log-gpart
                                 p_fbnum TYPE fbnum_ps.
  DATA:
    lv_process     TYPE zde_process,
    lv_commcontent TYPE ddobjname,
*      lv_trig_corr   TYPE zde_yn,
    lt_keys        TYPE /aif/sutil_property_t,
    ls_keys        TYPE /aif/sutil_property,
    lt_adhoc_var   TYPE /aif/sutil_property_t ##NEEDED,
    ls_adhoc_var   TYPE /aif/sutil_property ##NEEDED,
    ls_nform       TYPE  zdnform,
    lt_sost        TYPE soodk ##NEEDED,
    lt_message     TYPE bal_t_msg ##NEEDED.

  "Trigger Corresspondence
  DATA(lr_ref) = NEW zdcl_corr_framework( ).
  lv_process = 'ESL2'.

  CLEAR: ls_nform, lt_keys.
  ls_nform-process     = lv_process.
  ls_nform-sub_process = 'ESL2'.
  ls_nform-program_id  = '01'.
  ls_nform-spras       = sy-langu.
*    lv_commcontent       = im_component.

  DATA lv_cotyp TYPE cotyp_kk.
  lv_cotyp = 'ESL2'.

  CLEAR: ls_keys, lt_keys.
  ls_keys-name = 'FBNUM'.
  ls_keys-value = p_fbnum.
  APPEND ls_keys TO lt_keys.

  CLEAR ls_keys.
  ls_keys-name = 'SPRAS'.

  SELECT SINGLE zz_lang_pref INTO @DATA(lv_lang) FROM but000 WHERE partner = @p_partner.
  IF sy-subrc EQ 0.
    ls_keys-value = lv_lang.
  ELSE.
    ls_keys-value = sy-langu.
  ENDIF.
  APPEND ls_keys TO lt_keys.

  "Get_NonForm_Communication Method called for Sending Test Email/SMS.
  CALL METHOD lr_ref->zdif_corr_framework~md_get_nonform_comm
    EXPORTING
      is_nform          = ls_nform                   " Communication Configuration for Non Form Based Processes
      iv_taxpayer       = p_partner                  " Business Partner Number
      iv_commcontent    = lv_commcontent             " Name of ABAP Dictionary Object
      iv_fbnum          = p_fbnum
      iv_cotyp_corr_log = lv_cotyp                   " Correspondence Type
      it_keys           = lt_keys
    IMPORTING
      et_sost           = lt_sost                    " SAPoffice: Definition of an Object (Key Part)
      et_message        = lt_message.                " Application Log: Table with Messages

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_error_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_log .

  IF p_status IS INITIAL.

    SELECT request_id
        cokey
        cotyp
        gpart
        vkont
        vtref
        add_gpart
        entry_date
        changed_date
        entry_time
        changed_time
        date_sent
        time_sent
        date_received
        time_received
        status
        status_desc
        error_desc
        cer_number
        version
        new_cotyp
        new_cokey
        seal_date
        seal_renew_date
        renewal_status
        base64_s
        base64_r
        signature
  INTO CORRESPONDING FIELDS OF TABLE gt_log_display
  FROM zdc_eseal_log
  WHERE gpart IN s_bp
    AND cokey IN s_cokey
    AND cotyp IN s_cotyp
    AND entry_date IN s_date.                             "#EC CI_SUBRC

  ELSE.

    SELECT request_id
            cokey
            cotyp
            gpart
            vkont
            vtref
            add_gpart
            entry_date
            changed_date
            entry_time
            changed_time
            date_sent
            time_sent
            date_received
            time_received
            status
            status_desc
            error_desc
            cer_number
            version
            new_cotyp
            new_cokey
            seal_date
            seal_renew_date
            renewal_status
            base64_s
            base64_r
            signature
      INTO CORRESPONDING FIELDS OF TABLE gt_log_display
      FROM zdc_eseal_log
      WHERE gpart IN s_bp
        AND cokey IN s_cokey
        AND cotyp IN s_cotyp
        AND entry_date IN s_date
        AND status = p_status.                            "#EC CI_SUBRC

  ENDIF.

**** building ALV Layout
  PERFORM build_layout.
**** building Field Catalogue
  PERFORM build_fieldcat.
**** Displaying the List using FM
  PERFORM display_list.
ENDFORM.
