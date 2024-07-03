  METHOD eseal_get_attachment.
*---------------------------------------------------------------------*
* Triggering Method: ZDCL_ODATA_INTERFACE -> GENERATE_ESEAL_CERTIFICATE_DOC
* Purpose of this method is to get the orrect used and the correspondace attachment ID
* to seal the document.
*---------------------------------------------------------------------*

    DATA:
      lv_date                  TYPE  fkk_rt_cdate,
      lv_mkk                   TYPE but100-rltyp VALUE 'MKK',
      lv_contractacc_id        TYPE  fkkcorr_rt_vkont,
      lv_correspondencetype_id TYPE  fkk_rt_cotyp,
      lt_correspondences       TYPE  isut_umc_correspondence,
      lt_return                TYPE  bapiret2_t ##NEEDED,
      lv_rltyp                 TYPE but100-rltyp,
      ls_but000                TYPE but000 ##NEEDED,
      lv_dummy                 TYPE char1.

    DATA lv_cguid TYPE fmca_return_guid.
    DATA lt_dfkkdoc_con TYPE TABLE OF dfkkdoc_con.
    DATA ls_dfkkdoc_con TYPE dfkkdoc_con.
    DATA lt_dfkkcoh TYPE TABLE OF dfkkcoh.
    DATA ls_dfkkcoh TYPE dfkkcoh.

    DATA : lc_eseal TYPE char50       VALUE 'ESEAL',
           lc_delay TYPE char50       VALUE 'DELAY'.

    "Fetching the data from BUT100 by using rltyp data
    SELECT SINGLE rltyp INTO lv_rltyp
            FROM but100
           WHERE partner = iv_account_id
             AND rltyp   = lv_mkk ##WARN_OK.

    IF sy-subrc = 0 AND lv_rltyp = lv_mkk.
      "Fetching the data by corresponding fields of the table but000 by passing account_id, DUBP or ECTS
      SELECT SINGLE partner
                    bu_group
        INTO CORRESPONDING FIELDS OF ls_but000
        FROM but000
        WHERE partner = iv_account_id
        AND ( bu_group = 'DUBP' OR bu_group = 'ECTS' ).

      IF sy-subrc <> 0.
        CALL FUNCTION 'FICA_UMC_CORRESPONDNC_LIST_GET'  "Get all the correspondences
          EXPORTING
            iv_business_partner       = iv_account_id
            irt_date                  = lv_date
            irt_contractacc_id        = lv_contractacc_id
            irt_correspondencetype_id = lv_correspondencetype_id
          IMPORTING
            et_correspondences        = lt_correspondences.
      ELSE.
        lv_dummy = 'X'.
      ENDIF.
    ELSE.

      "Fetching the data from TVARVC by using name"
      SELECT * FROM tvarvc INTO TABLE @DATA(ls_tvarvc) WHERE name = 'ZESEAL_REL_TYP'. "#EC CI_SUBRC
      DATA lv_tvarvc TYPE tvarvc.
      LOOP AT ls_tvarvc INTO lv_tvarvc.
        "Fetching the data partner2 from but050 by passing  lv_tvarvc-low & account_id
        SELECT SINGLE partner2 FROM but050 INTO @DATA(lv_partner) WHERE reltyp = @lv_tvarvc-low AND partner1 = @iv_account_id ##WARN_OK. "#EC CI_SEL_NESTED
        IF sy-subrc = 0.
          CALL FUNCTION 'FICA_UMC_CORRESPONDNC_LIST_GET'   "Get all the correspondences
            EXPORTING
              iv_business_partner       = lv_partner
              irt_date                  = lv_date
              irt_contractacc_id        = lv_contractacc_id
              irt_correspondencetype_id = lv_correspondencetype_id
            IMPORTING
              et_correspondences        = lt_correspondences
              et_messages               = lt_return.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lv_partner IS INITIAL.
      lv_partner = iv_account_id.
    ENDIF.

    SELECT SINGLE value FROM zdc_config INTO @DATA(lv_waittime) WHERE prg_code = @lc_eseal AND param_code = @lc_delay.
    IF sy-subrc <> 0.
      lv_waittime = 3. "Default Loops
    ENDIF.

    IF lv_dummy NE 'X'.
      IF iv_cotyp = 'TAFC'.
        "Fetching the data case_guid from dfmca_return by passing the fbnum & partner
        SELECT SINGLE case_guid INTO lv_cguid FROM dfmca_return WHERE fbnum = iv_fbnum AND tax_preparer = lv_partner ##WARN_OK. "#EC CI_SUBRC
      ELSE.
        SELECT SINGLE case_guid INTO lv_cguid FROM dfmca_return WHERE fbnum = iv_fbnum AND taxpayer = lv_partner ##WARN_OK. "#EC CI_SUBRC
      ENDIF.

      "Using do to ensure the data and match the time of the row creation in the dfkkdoc_con table.

      DO lv_waittime TIMES.
        "Fetching the data from dfkkdoc_con by passing the cguid and cotyp
        SELECT apobj                                      "#EC CI_SUBRC
               apobk
               seqno
               doguid
               cotyp
               cokey
               ernam
               ertsp
          INTO CORRESPONDING FIELDS OF TABLE lt_dfkkdoc_con ##TOO_MANY_ITAB_FIELDS
          FROM dfkkdoc_con
          WHERE apobk = lv_cguid
            AND cotyp = iv_cotyp ##WARN_OK.
        IF sy-subrc EQ 0.
          EXIT.
        ELSE.
          WAIT UP TO 1 SECONDS.
        ENDIF.
      ENDDO.

    ELSE.
      "Fetching the data case_guid from dfmca_return by passing fbnum
      SELECT SINGLE case_guid INTO lv_cguid FROM dfmca_return WHERE fbnum = iv_fbnum ##WARN_OK. "#EC CI_SUBRC

      "Fetching the data by corresponding fields of the table dfkkcoh by passing cguid & cotyp
      SELECT cokey cotyp cdate ctime INTO CORRESPONDING FIELDS OF TABLE lt_dfkkcoh ##TOO_MANY_ITAB_FIELDS
        FROM dfkkcoh WHERE data1 = lv_cguid               "#EC CI_SUBRC
        AND cotyp = iv_cotyp ##WARN_OK.

      SORT lt_dfkkcoh BY cdate ctime DESCENDING.
      READ TABLE lt_dfkkcoh INTO ls_dfkkcoh INDEX 1.      "#EC CI_SUBRC

      "Fetching the data by corresponding fields of the table dfkkdoc_con by passing cokey & cotyp
      "Using do to ensure the data and match the time of the row creation in the dfkkdoc_con table.
      DO lv_waittime TIMES.
        SELECT apobj                                      "#EC CI_SUBRC
               apobk
               seqno
               doguid
               cotyp
               cokey
               ernam
               ertsp
          FROM dfkkdoc_con
          INTO CORRESPONDING FIELDS OF TABLE lt_dfkkdoc_con  ##TOO_MANY_ITAB_FIELDS
          WHERE cokey = ls_dfkkcoh-cokey
            AND cotyp = ls_dfkkcoh-cotyp ##WARN_OK.

        IF sy-subrc EQ 0.
          EXIT.
        ELSE.
          WAIT UP TO 1 SECONDS.
        ENDIF.
      ENDDO.

    ENDIF.

    DELETE lt_dfkkdoc_con WHERE doguid IS INITIAL.
    SORT lt_dfkkdoc_con BY ertsp DESCENDING.
    READ TABLE lt_dfkkdoc_con INTO ls_dfkkdoc_con INDEX 1.

    IF sy-subrc EQ 0.
      ev_data = ls_dfkkdoc_con-doguid.
      ev_cokey = ls_dfkkdoc_con-cokey.
    ENDIF.

    et_correspodance = lt_correspondences.
  ENDMETHOD.
