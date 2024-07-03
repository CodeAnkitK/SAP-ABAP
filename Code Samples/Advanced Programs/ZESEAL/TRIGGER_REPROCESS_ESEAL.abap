  METHOD trigger_reprocess_eseal.
*---------------------------------------------------------------------*
*This is for the report that checks all the error documents and reprocess the
* errors with the avialable data on ZDC_ESEAL_LOG Table.
*---------------------------------------------------------------------*
* Trigger Point :
*    ZDR39001_ESEAL_ERR_REN_BG Report
*---------------------------------------------------------------------*
* Declaration of the REQUEST structure.
*---------------------------------------------------------------------*

    TYPES: BEGIN OF ty_request,
             username                     TYPE zde_username,
             password                     TYPE zde_password,
             profile                      TYPE char200,
             requestid                    TYPE zdc_eseal_log-request_id,
             keyselectorname              TYPE char200,
             keyselectorusage             TYPE char200,
             signedidentifier             TYPE char200,
             validationmethod             TYPE char100,
             signatureposition            TYPE char200,
             paramsreason                 TYPE char50,
             appearancerectx0             TYPE zdc_eseal-rec_x0,
             appearancerectx1             TYPE zdc_eseal-rec_x1,
             appearancerecty0             TYPE zdc_eseal-rec_y0,
             appearancerecty1             TYPE zdc_eseal-rec_y1,
             backgroundimageencodetype    TYPE char50,
             backgroundimagedata          TYPE string,
             backgroundimagesizeheight    TYPE zdc_eseal-bg_s_h,
             backgroundimagesizewidth     TYPE zdc_eseal-bg_s_w,
             backgroundimagepositionx     TYPE zdc_eseal-bg_p_x,
             backgroundimagepositiony     TYPE zdc_eseal-bg_p_y,
             foregroundimageencodetype    TYPE char50,
             foregroundimagedata          TYPE string,
             foregroundimagesizeheight    TYPE zdc_eseal-image_s_h,
             foregroundimagesizewidth     TYPE zdc_eseal-image_s_w,
             foregroundimagepositionx     TYPE zdc_eseal-image_p_x,
             foregroundimagepositiony     TYPE zdc_eseal-image_p_y,
             foregroundpropertiescolor    TYPE zdc_eseal-font_color,
             foregroundpropertiesfontsize TYPE zdc_eseal-font_size,
             foregroundtextpositionx      TYPE zdc_eseal-font_p_x,
             foregroundtextpositiony      TYPE zdc_eseal-font_p_y,
             signatureinfoid              TYPE char4,
             signatureinfodate            TYPE char25,
             signatureinfotitle           TYPE char50,
             inputdocumentmimetype        TYPE char50,
             inputdocumentbase64          TYPE string,
           END OF ty_request.


*---------------------------------------------------------------------*
* Declaration of the RESPONSE structure.
*---------------------------------------------------------------------*

    DATA: BEGIN OF ty_response,
            request_id  TYPE zdc_eseal_log-request_id,
            resultmajor TYPE char200,
            base64data  TYPE string,
            error       TYPE char255,
          END OF ty_response.

    DATA: lo_rest_client TYPE REF TO cl_rest_http_client,
          lo_request     TYPE REF TO if_rest_entity,
          lo_response    TYPE REF TO if_rest_entity.


    DATA :ls_data        LIKE ty_response,
          lt_map_request TYPE /ui2/cl_json=>name_mappings.

    DATA: ls_mappings LIKE LINE OF lt_map_request.
    DATA ls_request TYPE ty_request .

    DATA: lv_timestamp    TYPE tzntstmps,
          lv_tdate        TYPE string,
          lv_url          TYPE string,
          lv_string1      TYPE string,
          lv_msg          TYPE bapi_msg,
          lv_username(30),
          lv_password(30).



    DATA  lo_client TYPE REF TO if_http_client. "HTTP Client Abstraction
    DATA  ls_eseal_log TYPE zdc_eseal_log.
    DATA  ls_eseal TYPE zdc_eseal.
    DATA  ls_dfkkcoh TYPE dfkkcoh.
    DATA  ls_dfkkdoc TYPE dfkkdoc.
    DATA  ls_dfkkdoc_con TYPE dfkkdoc_con.

    DATA: lt_dfkkcoh   TYPE STANDARD TABLE OF  dfkkcoh ##NEEDED.
    DATA:lv_cokey TYPE cokey_kk.


    DATA lv_message TYPE string ##NEEDED.
    DATA lv_flag_err TYPE char1 ##NEEDED.
    CLEAR lv_flag_err ##NEEDED.
    DATA: lv_insert                    TYPE boolean VALUE 'X' ##NEEDED.

*---------------------------------------------------------------------*
* Constants
*---------------------------------------------------------------------*
    CONSTANTS:
      lc_api_path                  TYPE zde_path     VALUE '/api/prc/ects-eseal/v1/',
      lc_resource_name             TYPE zde_resource VALUE 'eseal',
      lc_profile                   TYPE char200      VALUE 'urn:safelayer:tws:dss:1.0:profiles:pades:1.0:sign',
      lc_keyselecorusage           TYPE char200      VALUE 'nonRepudiation',
      lc_signedidentifier          TYPE char200      VALUE 'urn:safelayer:tws:dss:1.0:property:pdfattributes',
*      lc_signatureposition         TYPE char200      VALUE 'LAST',
      lc_signatureinfodate         TYPE char200      VALUE 'timezone.local',
      lc_signatureinfoid           TYPE char200      VALUE 'Date',
      lc_keyselectorname           TYPE char200      VALUE 'CN=Staging-Federal eSeal, O=Federal Entity, L=Abu Dhabi, C=AE',
      lc_validationmethod          TYPE char100      VALUE 'PPKMS',
      lc_paramsreason              TYPE char50       VALUE 'Author',
      lc_backgroundimageencodetype TYPE char50       VALUE 'base64',
      lc_forgroundimageencodetype  TYPE char50       VALUE 'base64',
      lc_signatureinfotitle        TYPE char50       VALUE '.', "Random Value " changed by SA
      lc_inputdocumentmimetype     TYPE char50       VALUE 'application/pdf',
      lc_mimetype                  TYPE char50       VALUE 'application/pdf',
      lc_pdf_ex                    TYPE char50       VALUE '.pdf',
      lc_req                       TYPE char7        VALUE 'REQUEST',
      lc_x                         TYPE char1        VALUE 'X',
      lc_eseal                     TYPE char50       VALUE 'ESEAL'.



*---------------------------------------------------------------------*
*Date TimeStamp
*---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERT_INTO_TIMESTAMP'
      EXPORTING
        i_datlo     = sy-datum
        i_timlo     = sy-timlo
        i_tzone     = sy-zonlo
      IMPORTING
        e_timestamp = lv_timestamp.

    lv_tdate = lv_timestamp.

*---------------------------------------------------------------------*
* Step 1: Fetch API from API Table

* CHECK POINT 1:  Check the correct api link if feching.
*                 It may fail due to incorrect username
*                 password maintained in the config table
*---------------------------------------------------------------------*
    NEW zdcl_odata_interface( )->fetch_api_url(
       EXPORTING
         iv_api_path = lc_api_path
         iv_resource_name = lc_resource_name
       IMPORTING
         ev_url = lv_url
         et_mappings = DATA(lt_fields)
         ev_username = lv_username
         ev_password = lv_password
 ) .
    "Creation of New IF_HTTP_Client Object
    cl_http_client=>create_by_url(
    EXPORTING
      url                = lv_url
    IMPORTING
      client             = lo_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      ).

    IF sy-subrc NE 0.
      lv_message = TEXT-001.
      RETURN.
    ELSE.
      LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<lfs_fields>).
        IF <lfs_fields>-type = lc_req.
          ls_mappings-abap = <lfs_fields>-name_abap.
          ls_mappings-json = <lfs_fields>-name_json.
          INSERT ls_mappings INTO TABLE lt_map_request.
          CLEAR  ls_mappings.
        ENDIF.
      ENDLOOP.
    ENDIF.

*---------------------------------------------------------------------*
* Step 2: Query to fetch the eSeal background and foreground position detials.

* CHECK POINT 2:  Check the correct position is maintained in the table.
*                 It may fail due to signed position such as -1 written as 1-
*                 The PDF will fail to load if the postition of the seal
*                 fell out of the paper area.
*---------------------------------------------------------------------*
    SELECT SINGLE digikey
                  org_cotyp
                  date_from
                  date_to
                  new_cotyp
                  description
                  sign_p
                  image_s_h
                  image_s_w
                  image_p_x
                  image_p_y
                  bg_s_h
                  bg_s_w
                  bg_p_x
                  bg_p_y
                  rec_x0
                  rec_x1
                  rec_y0
                  rec_y1
                  font_color
                  font_size
                  font_p_x
                  font_p_y
      INTO CORRESPONDING FIELDS OF ls_eseal FROM zdc_eseal WHERE org_cotyp = iv_cotyp
                                                            AND date_from LE sy-datum
                                                            AND date_to GE sy-datum ##WARN_OK.

    ls_eseal_log-cokey = iv_fbnum.
    ls_eseal_log-cotyp = iv_cotyp.
    ls_eseal_log-gpart = iv_taxpayer.
    ls_eseal_log-entry_date = sy-datum.
    ls_eseal_log-changed_date = sy-datum.
    ls_eseal_log-entry_time = sy-uzeit.
    ls_eseal_log-changed_time = sy-uzeit.
    ls_eseal_log-date_sent = sy-datum.
    ls_eseal_log-time_sent = sy-uzeit.
    ls_eseal_log-date_received = sy-datum.
    ls_eseal_log-time_received = sy-uzeit.
***************************************************
    ls_eseal_log-program_nm = sy-cprog.
    ls_eseal_log-usrnm      = sy-uname.

    IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if no record Maintained in zdc_eseal Table
*---------------------------------------------------------------------*
      CALL METHOD update_log_eseal
        EXPORTING
          is_eseal_log  = ls_eseal_log
          iv_error_code = '01'
          iv_is_error   = lc_x.
      lv_flag_err = lc_x.
    ELSE.
*---------------------------------------------------------------------*
* Step 3: FM to Fetch the details of the certificate attachment.
***** Open & Close Document
*---------------------------------------------------------------------*

      lv_cokey = is_eseal_plog-new_cokey.

      CLEAR ls_dfkkcoh.
      SELECT SINGLE * FROM dfkkcoh INTO CORRESPONDING FIELDS OF ls_dfkkcoh WHERE cokey = lv_cokey ##WARN_OK. "#EC CI_ALL_FIELDS_NEEDED
      IF sy-subrc EQ 0.
        APPEND ls_dfkkcoh TO lt_dfkkcoh.
        ls_eseal_log-request_id = is_eseal_plog-request_id.
        ls_eseal_log-cer_number = ls_dfkkcoh-zzcertificate_number.
        ls_eseal_log-version = ls_dfkkcoh-zzversion_num.
        ls_eseal_log-vkont = ls_dfkkcoh-vkont.
        ls_eseal_log-vtref = ls_dfkkcoh-vtref.
        ls_eseal_log-add_gpart = ls_dfkkcoh-add_gpart.
        ls_eseal_log-seal_date = sy-datum.
*        ls_eseal_log-seal_renew_date = sy-datum.
      ELSE.
*---------------------------------------------------------------------*
* Handle Error if no record in dfkkcoh.
*---------------------------------------------------------------------*
        CALL METHOD update_log_eseal
          EXPORTING
            is_eseal_log  = ls_eseal_log
            iv_error_code = '05'
            iv_is_error   = lc_x.
        lv_flag_err = lc_x.
      ENDIF.

      IF lv_flag_err <> lc_x.
*---------------------------------------------------------------------*
* Step 3: Creating Request structure of the program .
*---------------------------------------------------------------------*
        ls_request-username = lv_username.
        ls_request-password = lv_password.
        ls_request-keyselectorname = lc_keyselectorname.
        ls_request-profile = lc_profile.
        ls_request-requestid = ls_dfkkcoh-cokey.
        ls_request-keyselectorusage = lc_keyselecorusage.
        ls_request-signatureinfoid = lc_signatureinfoid.
        ls_request-signedidentifier = lc_signedidentifier.
        ls_request-validationmethod = lc_validationmethod.
        ls_request-paramsreason     = lc_paramsreason.
        ls_request-backgroundimageencodetype = lc_backgroundimageencodetype.
        ls_request-foregroundimageencodetype = lc_forgroundimageencodetype.
        ls_request-signatureposition = ls_eseal-sign_p.
        CONDENSE ls_request-signatureposition.
        ls_request-signatureinfodate = lc_signatureinfodate.

        ls_request-signatureinfotitle    = lc_signatureinfotitle.
        ls_request-inputdocumentmimetype = lc_inputdocumentmimetype.

        ls_request-appearancerectx0  = ls_eseal-rec_x0.
        ls_request-appearancerectx1  = ls_eseal-rec_x1.
        ls_request-appearancerecty0  = ls_eseal-rec_y0.
        ls_request-appearancerecty1  = ls_eseal-rec_y1.

        ls_request-backgroundimagesizeheight = ls_eseal-bg_s_h.
        ls_request-backgroundimagesizewidth = ls_eseal-bg_s_w.
        ls_request-backgroundimagepositionx = ls_eseal-bg_p_x.
        ls_request-backgroundimagepositiony = ls_eseal-bg_p_y.

        ls_request-foregroundimagesizeheight = ls_eseal-image_s_h.
        ls_request-foregroundimagesizewidth = ls_eseal-image_s_w.
        ls_request-foregroundimagepositionx = ls_eseal-image_p_x.
        ls_request-foregroundimagepositiony = ls_eseal-image_p_y.

        ls_request-foregroundpropertiescolor = ls_eseal-font_color.
        ls_request-foregroundpropertiesfontsize = ls_eseal-font_size.

        ls_request-foregroundtextpositionx = ls_eseal-font_p_x.
        ls_request-foregroundtextpositiony = ls_eseal-font_p_y.


        DATA lt_text TYPE STANDARD TABLE OF  tline.
        DATA ls_text LIKE LINE OF lt_text.
*---------------------------------------------------------------------*
* Step 4: Reading the Foreground image from SO10
*---------------------------------------------------------------------*
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'ST'
            language                = 'E'
            name                    = 'FOREGROUND_IMAGE'
            object                  = 'TEXT'
          TABLES
            lines                   = lt_text
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if no Foreground Image Maintained
*---------------------------------------------------------------------*
          CALL METHOD update_log_eseal
            EXPORTING
              is_eseal_log  = ls_eseal_log
              iv_error_code = '06'
              iv_is_error   = 'X'.
          lv_flag_err = 'X'.
        ENDIF.

        CLEAR ls_text.
        CLEAR ls_request-foregroundimagedata.
        LOOP AT lt_text INTO ls_text.
          CONCATENATE ls_request-foregroundimagedata ls_text-tdline INTO ls_request-foregroundimagedata.
          CLEAR ls_text.
        ENDLOOP.
        CONDENSE ls_request-foregroundimagedata.

*---------------------------------------------------------------------*
* Step 5: Reading the Background image from SO10
*---------------------------------------------------------------------*
        CLEAR lt_text.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'ST'
            language                = 'E'
            name                    = 'BACKGROUND_IMAGE'
            object                  = 'TEXT'
          TABLES
            lines                   = lt_text
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if no Background Image Maintained
*---------------------------------------------------------------------*
          CALL METHOD update_log_eseal
            EXPORTING
              is_eseal_log  = ls_eseal_log
              iv_error_code = '07'
              iv_is_error   = 'X'.
          lv_flag_err = 'X'.
        ENDIF.

        CLEAR ls_text.
        CLEAR ls_request-backgroundimagedata.
        LOOP AT lt_text INTO ls_text.
          CONCATENATE ls_request-backgroundimagedata ls_text-tdline INTO ls_request-backgroundimagedata.
          CLEAR ls_text.
        ENDLOOP.
        CONDENSE ls_request-backgroundimagedata.

*---------------------------------------------------------------------*
* Step 6: Convert the binary data to a Base64 string
*---------------------------------------------------------------------*
        DATA lv_pdf_name TYPE  thead-tdname.
        lv_pdf_name  = is_eseal_plog-base64_s.

        CLEAR lt_text.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'ST'
            language                = 'E'
            name                    = lv_pdf_name "is_eseal_plog-base64_s
            object                  = 'TEXT'
          TABLES
            lines                   = lt_text
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if no Background Image Maintained
*---------------------------------------------------------------------*
          CALL METHOD update_log_eseal
            EXPORTING
              is_eseal_log  = ls_eseal_log
              iv_error_code = '04'
              iv_is_error   = lc_x.
          lv_flag_err = lc_x.
        ENDIF.

        CLEAR ls_text.
        CLEAR ls_request-inputdocumentbase64.
        LOOP AT lt_text INTO ls_text.
          CONCATENATE ls_request-inputdocumentbase64 ls_text-tdline INTO ls_request-inputdocumentbase64.
          CLEAR ls_text.
        ENDLOOP.
        CONDENSE ls_request-inputdocumentbase64.

*--------------------------------------------------------------------*
* Creating SO10 Object for request PDF
*---------------------------------------------------------------------

        DATA: lt_lines_s  TYPE TABLE OF tline,
              ls_header_s TYPE thead.

        CLEAR lt_lines_s.
        ls_header_s-tdobject  = 'TEXT'.
        ls_header_s-tdid        = 'ST'.
        ls_header_s-tdspras     = 'EN'.
        CONCATENATE 'S' iv_fbnum iv_cotyp lv_tdate INTO ls_header_s-tdname SEPARATED BY '_'.

        CALL FUNCTION 'IDMX_DI_SPLIT_TEXT'    "#EC CI_SUBRC
          EXPORTING
            iv_character_chain = ls_request-inputdocumentbase64
            iv_length          = 132
          IMPORTING
            et_string_table    = lt_lines_s
          EXCEPTIONS
            error              = 1
            OTHERS             = 2.

        CALL FUNCTION 'SAVE_TEXT'
          EXPORTING
            client = sy-mandt
            header = ls_header_s
            insert = lv_insert
*           SAVEMODE_DIRECT         = ' '
*           OWNER_SPECIFIED         = ' '
*           LOCAL_CAT               = ' '
*           KEEP_LAST_CHANGED       = ' '
*               IMPORTING
*           FUNCTION                =
*           NEWHEADER               =
          TABLES
            lines  = lt_lines_s
*               EXCEPTIONS
*           ID     = 1
*           LANGUAGE                = 2
*           NAME   = 3
*           OBJECT = 4
*           OTHERS = 5
          .
        IF sy-subrc EQ 0.
          ls_eseal_log-base64_s = ls_header_s-tdname.
        ENDIF.

      ENDIF. " No Execution if error

    ENDIF.

*---------------------------------------------------------------------*
* Step 7: Sending request to API

*CHECK POINT 5: The request will fail here amd produce error incase the
*               the usename password or the api is fetched wrong.
*               check the response to confirm
*---------------------------------------------------------------------*

    IF lv_flag_err <> 'X'.

      lo_client->propertytype_logon_popup = lo_client->co_disabled.
      CALL METHOD /ui2/cl_json=>serialize
        EXPORTING
          data        = ls_request
          pretty_name = 'L'         " Pretty Print property names
        RECEIVING
          r_json      = lv_string1.

      lo_client->request->set_method( 'POST' ).
      CREATE OBJECT lo_rest_client EXPORTING io_http_client = lo_client.
      IF lv_msg IS INITIAL.
        lo_request = lo_rest_client->if_rest_client~create_request_entity( ).
        lo_request->set_content_type( iv_media_type = if_rest_media_type=>gc_appl_json ).
        lo_request->set_string_data( lv_string1 ).
        TRY.
            lo_rest_client->if_rest_resource~post( lo_request ).
          CATCH cx_rest_client_exception INTO DATA(lo_exc).
            lv_message = lo_exc->get_text( ).
        ENDTRY.
      ENDIF.

*---------------------------------------------------------------------*
*CHECK POINT 6: IF ov_pdf is initnal the program will fail
*---------------------------------------------------------------------*
      lo_response = lo_rest_client->if_rest_client~get_response_entity( ).
      DATA(lv_response) = lo_response->get_string_data( ).

*---------------------------------------------------------------------*
*CHECK POINT 7: As per the requirement, IF EPASS will return the seal document
* the error field in the structure is empty else error will have the failed status
* check the pdf filed if the BASE64 field has correct PDF.
*---------------------------------------------------------------------*
      CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
          json         = lv_response   "lv_string "text                " JSON string
          pretty_name  = /ui2/cl_json=>pretty_mode-camel_case               " Pretty Print property names
          assoc_arrays = abap_true                " Deserialize associative array as tables with unique keys
        CHANGING
          data         = ls_data.


    ENDIF." No execution on error


    IF ls_data IS INITIAL.
*---------------------------------------------------------------------*
* Handle Error if API Hit is Missed,
*---------------------------------------------------------------------*
      CALL METHOD update_log_eseal
        EXPORTING
          is_eseal_log  = ls_eseal_log
          iv_error_code = '08'
          iv_is_error   = lc_x
          iv_desc       = TEXT-061.
      lv_flag_err = lc_x.
    ELSE.
      IF ls_data-error IS NOT INITIAL.
*---------------------------------------------------------------------*
* Handle Error if Error Returned from API
*---------------------------------------------------------------------*
        CALL METHOD update_log_eseal
          EXPORTING
            is_eseal_log  = ls_eseal_log
            iv_error_code = '08'
            iv_is_error   = lc_x
            iv_desc       = ls_data-error.
        lv_flag_err = lc_x.
      ELSE.
*---------------------------------------------------------------------*
* Step 7: Creating the Log Structure based on the request & response.
*---------------------------------------------------------------------*
        ls_eseal_log-error_desc = ls_data-error.

*---------------------------------------------------------------------*
* Creating SO10 Object for response PDF
*---------------------------------------------------------------------*


        DATA: lt_lines_r  TYPE TABLE OF tline,
              ls_header_r TYPE thead.

        CLEAR lt_lines_r.
        ls_header_r-tdobject  = 'TEXT'.
        ls_header_r-tdid        = 'ST'.
        ls_header_r-tdspras     = 'EN'.
        CONCATENATE 'R' iv_fbnum iv_cotyp lv_tdate INTO ls_header_r-tdname SEPARATED BY '_'.

        CALL FUNCTION 'IDMX_DI_SPLIT_TEXT'   "#EC CI_SUBRC
          EXPORTING
            iv_character_chain = ls_data-base64data
            iv_length          = 132
          IMPORTING
            et_string_table    = lt_lines_r
          EXCEPTIONS
            error              = 1
            OTHERS             = 2.

        CALL FUNCTION 'SAVE_TEXT'   "#EC CI_SUBRC
          EXPORTING
            client = sy-mandt
            header = ls_header_r
            insert = lv_insert
*           SAVEMODE_DIRECT         = ' '
*           OWNER_SPECIFIED         = ' '
*           LOCAL_CAT               = ' '
*           KEEP_LAST_CHANGED       = ' '
*               IMPORTING
*           FUNCTION                =
*           NEWHEADER               =
          TABLES
            lines  = lt_lines_r
*               EXCEPTIONS
*           ID     = 1
*           LANGUAGE                = 2
*           NAME   = 3
*           OBJECT = 4
*           OTHERS = 5
          .
        IF sy-subrc EQ 0.
          ls_eseal_log-base64_r =  ls_header_r-tdname.
        ENDIF.

*---------------------------------------------------------------------*
* Step 8: "Decode the Base64 PDF to Xstring file.
*          We are converting BASE64 file to Xstring for our archiving purpose
*---------------------------------------------------------------------*
        DATA: lv_sealed_pdf TYPE xstring.
        CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
          EXPORTING
            input  = ls_data-base64data
*           UNESCAPE       = 'X'
          IMPORTING
            output = lv_sealed_pdf
          EXCEPTIONS
            failed = 1
            OTHERS = 2.

        IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if seal pdf conversion fails.
*---------------------------------------------------------------------*
          CALL METHOD update_log_eseal
            EXPORTING
              is_eseal_log  = ls_eseal_log
              iv_error_code = '09'
              iv_is_error   = lc_x.
          lv_flag_err = lc_x.
        ENDIF.


        SELECT SINGLE new_cotyp INTO ls_eseal_log-new_cotyp FROM zdc_eseal WHERE org_cotyp = iv_cotyp AND date_to GE sy-datum ##WARN_OK.
        IF sy-subrc EQ 0.
          DATA: lv_conf_value TYPE zdc_config-value.
          SELECT SINGLE value INTO lv_conf_value FROM zdc_config WHERE prg_code = lc_eseal
                                                                  AND param_code = 'VALIDITY_PER'
                                                                  AND begda LE sy-datum
                                                                  AND endda GE sy-datum
                                                                  AND counter = '001' ##WARN_OK.
          IF sy-subrc = 0.
            DATA lv_duration  TYPE  psen_duration.
            lv_duration-duryy = lv_conf_value.

            CALL FUNCTION 'HR_99S_DATE_ADD_SUB_DURATION'
              EXPORTING
                im_date     = sy-datum
                im_operator = '+'
                im_duration = lv_duration
              IMPORTING
                ex_date     = ls_eseal_log-seal_renew_date.

          ENDIF.

          DATA lv_rndate TYPE zdc_eseal_log-seal_renew_date.
          SELECT SINGLE seal_renew_date INTO lv_rndate FROM zdc_eseal_log WHERE request_id = ls_eseal_log-request_id
                                                                       AND cokey = ls_eseal_log-cokey
                                                                       AND cotyp = ls_eseal_log-cotyp
                                                                       AND gpart = ls_eseal_log-cotyp ##WARN_OK.
          IF sy-subrc = 0 AND lv_rndate = sy-datum.
            ls_eseal_log-renewal_status = lc_x.
          ENDIF.
        ENDIF.

        ls_eseal_log-new_cokey = lv_cokey.
        ls_eseal_log-signature = ''.

        SELECT SINGLE * FROM dfkkdoc_con INTO CORRESPONDING FIELDS OF ls_dfkkdoc_con WHERE cokey = ls_dfkkcoh-cokey ##WARN_OK. "#EC CI_ALL_FIELDS_NEEDED
        IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error if connecting document not found.
*---------------------------------------------------------------------*
          CALL METHOD update_log_eseal
            EXPORTING
              is_eseal_log  = ls_eseal_log
              iv_error_code = '10'
              iv_is_error   = lc_x.
          lv_flag_err = lc_x.
        ELSE.
          SELECT SINGLE * FROM dfkkdoc INTO CORRESPONDING FIELDS OF ls_dfkkdoc WHERE doguid = ls_dfkkdoc_con-doguid. "#EC CI_ALL_FIELDS_NEEDED
          IF sy-subrc <> 0.
*---------------------------------------------------------------------*
* Handle Error No record in DFKKDOC.
*---------------------------------------------------------------------*
            CALL METHOD update_log_eseal
              EXPORTING
                is_eseal_log  = ls_eseal_log
                iv_error_code = '11'
                iv_is_error   = lc_x.
            lv_flag_err = lc_x.
          ELSE.

            DATA: ls_attachment TYPE  fmcas_mc_attachment.
            DATA: ls_ev_attachmentid TYPE  fmca_mc_attachmentid.
            DATA: lt_et_return  TYPE  bapiret2_t ##NEEDED.

            ls_attachment-form_bundle_id = iv_fbnum.
            ls_attachment-mime_type = lc_mimetype.

*---------------------------------------------------------------------*
* EXTENSION HANDLING FILENAME WITH .PDF
* IF the COTYP entry is NOT maintained in zdc_tfk070at
* the portal will not add the extension ".pdf" to the file.
* so this step ADDs .pdf to the files.
*---------------------------------------------------------------------*
            SELECT SINGLE * INTO @DATA(lt_tfk070at) FROM zdc_tfk070at WHERE cotyp = @iv_cotyp AND spras = 'E' ##NEEDED. "#EC CI_ALL_FIELDS_NEEDED
            IF sy-subrc <> 0.
              CONCATENATE ls_dfkkdoc-txtdo lc_pdf_ex INTO ls_attachment-file_name.
              CONDENSE ls_attachment-file_name.
            ELSE.
              ls_attachment-file_name = ls_dfkkdoc-txtdo.
            ENDIF.
*---------------------------------------------------------------------*
            ls_attachment-description = ls_dfkkdoc-txtdo.
            ls_attachment-media_resource  = lv_sealed_pdf.
            ls_attachment-document_category = ls_dfkkdoc-dotyp.

*---------------------------------------------------------------------*
* Step 9: Calling independent method to Archive the DATA in CORHIST & FPDMS T-codes

*CHECK POINT 7: DEBUG this method to ensure the archiving is proper and there is
* no failure in archiving. Else the PDF will NOT be visible in the portal.
*---------------------------------------------------------------------*
            CALL METHOD eseal_doc_archive
              EXPORTING
                is_attachment   = ls_attachment
                is_dfkkcoh      = ls_dfkkcoh
                iv_cotyp        = iv_cotyp
                iv_doc_typ      = ls_dfkkdoc-doc_typ
              IMPORTING
                ev_attachmentid = ls_ev_attachmentid
                et_return       = lt_et_return.

            IF ls_ev_attachmentid IS INITIAL.
*---------------------------------------------------------------------*
* Handle Error if seal pdf conversion fails.
*---------------------------------------------------------------------*
              CALL METHOD update_log_eseal
                EXPORTING
                  is_eseal_log  = ls_eseal_log
                  iv_error_code = '12'
                  iv_is_error   = lc_x.
              lv_flag_err = lc_x.

            ENDIF. "Checking on Archiving
          ENDIF. "Checking DOC
        ENDIF. "Checking DOC Connection
      ENDIF. "Checking on USE Pass Error
    ENDIF. "Cheking missed API.

*---------------------------------------------------------------------*
* IF ERROR FLAG IS INITIAL UPDATE SUCCESS.
*---------------------------------------------------------------------*
    IF lv_flag_err <> lc_x.
      CALL METHOD update_log_eseal
        EXPORTING
          is_eseal_log  = ls_eseal_log
          iv_error_code = ''
          iv_is_error   = ''
          iv_desc       = TEXT-062.

*---------------------------------------------------------------------*
* When the PDF is sucessfully sealed we are updating a field DATA4 in dfkkcoh woth S.
*---------------------------------------------------------------------*
    ENDIF.
  ENDMETHOD.                                             "#EC CI_VALPAR
