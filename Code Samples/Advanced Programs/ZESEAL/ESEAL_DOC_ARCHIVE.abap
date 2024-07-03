  METHOD eseal_doc_archive.
*---------------------------------------------------------------------*
*This method is used to archive the eSigned PDF into CORHIST & FKDMS.
*---------------------------------------------------------------------*
*    CALL Action:
*    ZDCL_ODATA_INTERFACE -> GENERATE_ESEAL_CERTIFICATE_DOC
*---------------------------------------------------------------------*
* Variable Declarations
*---------------------------------------------------------------------*
    TYPES:BEGIN OF lty_guid_fbsta,
            fbsta        TYPE fmca_mc_statid,
            fbnum        TYPE dfmca_return-fbnum,
            case_guid    TYPE sysuuid_c,
            taxpayer     TYPE fmca_mc_bp,
            tax_preparer TYPE tax_preparer_ps,
          END OF lty_guid_fbsta.

    DATA:ls_accinf       TYPE scms_acinf,
         ls_fkkdoc       TYPE dfkkdoc,
         lt_content_bin  TYPE sdokcntbins,
         ls_tfk068       TYPE tfk068,
         lt_tfk068       TYPE TABLE OF tfk068,
         lt_accinf       TYPE TABLE OF scms_acinf,
         lt_tfk068c      TYPE TABLE OF tfk068c,
         lt_fkkdoc_con   TYPE fkkdoc_con_tab,
         ls_fkkdoc_con   TYPE dfkkdoc_con,
         ls_guid_fbsta   TYPE lty_guid_fbsta,
         lt_dfkkdoc      TYPE fkkdoc_tab,
         ls_tfk068c      TYPE tfk068c,
         ls_return       TYPE bapiret2,

         lv_error        TYPE xfeld,
         lv_apobk        TYPE apobk_kk,
         lv_formbundleid TYPE fmca_mc_formbundlenumber.

    DATA :lv_object    TYPE sapb-sapobjid,
          lv_archie_id TYPE toav0-archiv_id VALUE 'OT',
          lv_doc_id    TYPE toav0-arc_doc_id.

    DATA : ls_dfkkcoh   TYPE dfkkcoh,
           ls_fkkcoinfo TYPE fkkcoinfo.

    DATA: ls_ref_cx_root TYPE REF TO cx_root,
          lv_msg_txt     TYPE string.
    CLEAR : ls_ref_cx_root, lv_msg_txt.

*---------------------------------------------------------------------*
* Read the GUID of the Form Bundle ID
*---------------------------------------------------------------------*

    IF is_attachment-document_category NE 'TPPP'.
      CALL METHOD cl_fmca_mc_api_general=>convert_alpha_input
        EXPORTING
          iv_field = is_attachment-form_bundle_id
        IMPORTING
          rv_field = lv_formbundleid.
      SELECT SINGLE case_guid fbnum fbsta taxpayer tax_preparer FROM dfmca_return INTO CORRESPONDING FIELDS OF ls_guid_fbsta "#EC CI_SUBRC
                                        WHERE fbnum = lv_formbundleid ##WARN_OK. "#EC CI_SEL_NESTED or "#EC CI_SROFC_NESTED
      IF  ls_guid_fbsta-case_guid IS INITIAL.
        ls_return-type       = cl_fmca_mc_odata_constants=>gc_msg_type_e.
        ls_return-id         = cl_fmca_mc_odata_constants=>gc_msg_id1.
        ls_return-number     = '027'.
        ls_return-message_v1 = is_attachment-form_bundle_id.
        APPEND ls_return TO et_return.
        RETURN.
      ENDIF.
      IF iv_cotyp = 'TAFC'.
        ls_guid_fbsta-taxpayer = ls_guid_fbsta-tax_preparer.
      ENDIF.
    ELSE.
      ls_guid_fbsta-taxpayer = is_attachment-form_bundle_id.

      CALL METHOD cl_fmca_mc_api_general=>convert_alpha_input
        EXPORTING
          iv_field = ls_guid_fbsta-taxpayer
        IMPORTING
          rv_field = ls_guid_fbsta-taxpayer.

      SELECT SINGLE partner_guid "#EC CI_SEL_NESTED or "#EC CI_SROFC_NESTED  "#EC CI_SUBRC
                    FROM but000
                    INTO @DATA(lv_guid)
                    WHERE partner = @ls_guid_fbsta-taxpayer.

      ls_guid_fbsta-case_guid = lv_guid.
    ENDIF.

*---------------------------------------------------------------------*
* allow attachements creation for all statuses
* If document type is not known: check if there is a unique customizing entry for attachment
*---------------------------------------------------------------------*
    ls_fkkdoc-dotyp = is_attachment-document_category.
    ls_fkkdoc-zz_identifier1 = is_attachment-zz_identifier1.
    ls_fkkdoc-zz_identifier2 = is_attachment-zz_identifier2.

    IF ls_fkkdoc-dotyp IS INITIAL.
      SELECT * FROM tfk068 INTO TABLE lt_tfk068 WHERE dosrc = '3'. "#EC CI_SUBRC
      DESCRIBE TABLE lt_tfk068 LINES sy-tfill.
      IF sy-tfill > 1.
        ls_return-type = cl_fmca_mc_odata_constants=>gc_msg_type_e.
        ls_return-id =  cl_fmca_mc_odata_constants=>gc_msg_id2.
        ls_return-number = '075'.
        APPEND ls_return TO et_return.
        RETURN.
      ELSE.
        READ TABLE lt_tfk068 INDEX 1 INTO ls_tfk068.      "#EC CI_SUBRC
        ls_fkkdoc-dotyp = ls_tfk068-dotyp.
      ENDIF.
    ENDIF.

*---------------------------------------------------------------------*
* Get document technical type and mime type
*-----------------------------------------------------------------
    ls_fkkdoc-mandt = sy-mandt.
    ls_fkkdoc-txtdo = is_attachment-file_name.
    DATA: lv_len TYPE i.

    CALL FUNCTION 'GUID_CREATE' "##FM_OLDED
      IMPORTING
        ev_guid_32 = ls_fkkdoc-doguid.

    ls_fkkdoc-doc_typ = iv_doc_typ.
    lv_len = strlen( ls_fkkdoc-txtdo ).
    IF lv_len GE 100.
      CONCATENATE ls_fkkdoc-txtdo+0(95) '.'  ls_fkkdoc-doc_typ INTO ls_fkkdoc-txtdo.
    ENDIF.

    IF   ls_fkkdoc-doc_typ IS INITIAL.
      ls_return-type = cl_fmca_mc_odata_constants=>gc_msg_type_e.
      ls_return-id =  cl_fmca_mc_odata_constants=>gc_msg_id2.
      ls_return-number = '078'.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* Get the mime type for the attachment
*-----------------------------------------------------------------

    CALL METHOD cl_fmca_trm_utility=>get_mimetype
      EXPORTING
        iv_doc_type  = ls_fkkdoc-doc_typ
      RECEIVING
        rv_mime_type = ls_accinf-mimetype.

    IF ls_accinf-mimetype IS INITIAL.
      ls_return-type = cl_fmca_mc_odata_constants=>gc_msg_type_e.
      ls_return-id =  cl_fmca_mc_odata_constants=>gc_msg_id2.
      ls_return-message_v1 = ls_fkkdoc-doc_typ.
      ls_return-number = '079'.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* check the technical permitted documents for document type
*-----------------------------------------------------------------
    SELECT SINGLE * FROM tfk068e INTO @DATA(ls_dotyp) WHERE dotyp   = @is_attachment-document_category
                                                      AND   doc_typ = @ls_fkkdoc-doc_typ ##NEEDED.
    IF sy-subrc <> 0.
      CLEAR  ls_return.
      ls_return-id           = 'ZDM_UTILITY'.
      ls_return-type         = cl_fmca_mc_odata_constants=>gc_msg_type_e.
      ls_return-number       = '015'.
      ls_return-message_v1   = ls_fkkdoc-doc_typ.
      APPEND ls_return TO et_return.
      CLEAR ls_return.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* Get input binary data and size
*-----------------------------------------------------------------
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = is_attachment-media_resource
      IMPORTING
        output_length = ls_accinf-comp_size
      TABLES
        binary_tab    = lt_content_bin.

*---------------------------------------------------------------------*
*  Upload data into DMS
*-----------------------------------------------------------------
    ls_accinf-binary_flg ='X'.
    ls_accinf-comp_id = 'data'.
    ls_accinf-first_line = 1.                               "n1886558
    ls_accinf-last_line  = lines( lt_content_bin ).         "n1886558
    APPEND ls_accinf  TO lt_accinf.
    ls_fkkdoc-tabid = '002'.  "Correspondance
    ls_fkkdoc-xnimg = 'X'.
    ls_fkkdoc-inpch = '240'.  "E-Filing
    ls_fkkdoc-gpart = ls_guid_fbsta-taxpayer.


    ls_fkkcoinfo-coidt = sy-datum.
    ls_fkkcoinfo-laufd = sy-datum.
    ls_fkkcoinfo-laufi = sy-uzeit.
    ls_fkkcoinfo-cocyr = sy-datum(4).
    ls_fkkcoinfo-coper = ' '.
    ls_fkkcoinfo-coexc = ' '.

    DATA lt_dfkkcoh TYPE STANDARD TABLE OF dfkkcoh.
    SELECT SINGLE * FROM dfkkcoh INTO CORRESPONDING FIELDS OF ls_dfkkcoh "#EC CI_SUBRC
      WHERE cotyp = is_attachment-document_category
        AND gpart = ls_guid_fbsta-taxpayer ##WARN_OK.

    SELECT SINGLE addrnumber , adr_kind FROM but021_fs INTO @DATA(ls_adr) WHERE partner = @ls_dfkkcoh-gpart ##WARN_OK. "#EC CI_SUBRC

    ls_dfkkcoh-aadrnr = ls_adr-addrnumber.
    ls_dfkkcoh-agpart_adr_kind = ls_adr-adr_kind.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_dfkkcoh-vtref
      IMPORTING
        output = ls_dfkkcoh-vtref.


    SELECT SINGLE * FROM dpsob_bp_acc  INTO @DATA(ls_dpsob) WHERE partner = @ls_dfkkcoh-gpart AND psobkey = @ls_dfkkcoh-vtref ##WARN_OK. "#EC CI_ALL_FIELDS_NEEDED
    ls_dfkkcoh-vkont = ls_dpsob-partneracc.

    ls_dfkkcoh-flg_originalcms = 'X'.

*---------------------------------------------------------------------*
* When the PDF is sucessfully sealed we are updating a field DATA4 in dfkkcoh woth S.
*---------------------------------------------------------------------*
    ls_dfkkcoh-data4 = 'S'.

*---------------------------------------------------------------------*
* Create a connection record in DFKKCOH
*-----------------------------------------------------------------
    IF sy-subrc = 0.
      APPEND ls_dfkkcoh TO lt_dfkkcoh.
      TRY.
          CALL FUNCTION 'FKK_WRITE_CORR'   "#EC CI_SUBRC
            EXPORTING
              i_fkkcoinfo          = ls_fkkcoinfo
              i_avoid_language_det = abap_true
            TABLES
              t_dfkkcoh            = lt_dfkkcoh
            CHANGING
              c_dfkkcoh            = ls_dfkkcoh
            EXCEPTIONS
              error_message        = 1
              OTHERS               = 2.

        CATCH cx_root INTO ls_ref_cx_root.
          lv_msg_txt = ls_ref_cx_root->get_text( ).
          MESSAGE s208(00) WITH lv_msg_txt.
      ENDTRY.
    ENDIF.

*---------------------------------------------------------------------*
* Create a table for insert
*-----------------------------------------------------------------
    CONCATENATE ls_fkkdoc-dotyp is_dfkkcoh-cokey INTO ls_fkkdoc-tabkey.

*---------------------------------------------------------------------*
* Upload the PDF
*-----------------------------------------------------------------
    CALL FUNCTION 'FKKDMS_UPLOAD_TABLE'
      EXPORTING
        iv_doctyp     = ls_fkkdoc-doc_typ
      IMPORTING
        ev_error      = lv_error
      TABLES
        access_info   = lt_accinf
        content_bin   = lt_content_bin
      CHANGING
        cs_fkkdoc     = ls_fkkdoc
      EXCEPTIONS
        error_message = 1.
    IF sy-subrc <> 0.

      CALL FUNCTION 'BALW_BAPIRETURN_GET2'                 "#EC NO_INCOMP
        EXPORTING
          type   = sy-msgty
          cl     = sy-msgid
          number = sy-msgno
          par1   = sy-msgv1
          par2   = sy-msgv2
          par3   = sy-msgv3
          par4   = sy-msgv4
        IMPORTING
          return = ls_return.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

    IF lv_error EQ 'X'.
      CALL FUNCTION 'BALW_BAPIRETURN_GET2'                 "#EC NO_INCOMP
        EXPORTING
          type   = sy-msgty
          cl     = sy-msgid
          number = sy-msgno
          par1   = sy-msgv1
          par2   = sy-msgv2
          par3   = sy-msgv3
          par4   = sy-msgv4
        IMPORTING
          return = ls_return.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* Read customization and link to application object
*-----------------------------------------------------------------

    CALL FUNCTION 'FKKDMS_READ_CUSTOMIZING'
      IMPORTING
        et_tfk068c = lt_tfk068c
      EXCEPTIONS
        OTHERS     = 3.
    IF sy-subrc <> 0.
      ls_return-type       = syst-msgty.
      ls_return-id         = syst-msgid.
      ls_return-number     = syst-msgno.
      ls_return-message_v1 = syst-msgv1.
      ls_return-message_v2 = syst-msgv2.
      ls_return-message_v3 = syst-msgv3.
      ls_return-message_v4 = syst-msgv4.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

    READ TABLE lt_tfk068c INTO ls_tfk068c WITH KEY apobj = cl_fmca_mc_odata_constants=>gc_apobj.
    IF sy-subrc = 0.

*---------------------------------------------------------------------*
* Insert a connection in persistence layer
* CHECK POINT: The sequence of FM in important!!!!
*-----------------------------------------------------------------

      CLEAR lt_dfkkdoc.
      APPEND ls_fkkdoc  TO lt_dfkkdoc.
      lv_apobk = ls_guid_fbsta-case_guid .

      IF is_dfkkcoh-cokey IS NOT INITIAL.
        lv_doc_id = ls_fkkdoc-doguid.
        CONCATENATE ls_fkkdoc-dotyp is_dfkkcoh-cokey INTO lv_object.
      ENDIF.

*---------------------------------------------------------------------*
* CHECK POINT: error_connectiontable if the DATA is missing or wrong
*-----------------------------------------------------------------
      CALL FUNCTION 'ARCHIV_CONNECTION_INSERT'   "#EC CI_SUBRC
        EXPORTING
          archiv_id             = lv_archie_id
          arc_doc_id            = lv_doc_id
          ar_object             = 'FICA_PDF'
          object_id             = lv_object
          sap_object            = 'BUS4401'
        EXCEPTIONS
          error_connectiontable = 1
          OTHERS                = 2.

      CALL FUNCTION 'FKKDMS_CONNECTION_INSERT'
        EXPORTING
          iv_apobj       = ls_tfk068c-apobj
          iv_apobk       = lv_apobk
          it_dfkkdoc     = lt_dfkkdoc
          it_dfkkcoh     = lt_dfkkcoh[]          "added to pass Cokey to DFKKDOC_CON
          iv_update_task = ' '
        IMPORTING
          et_fkkdoc_con  = lt_fkkdoc_con.
    ENDIF.
    READ TABLE lt_fkkdoc_con INTO ls_fkkdoc_con INDEX 1.
    IF sy-subrc EQ 0.
      ev_attachmentid = ls_fkkdoc_con-doguid.
    ENDIF.


    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.
