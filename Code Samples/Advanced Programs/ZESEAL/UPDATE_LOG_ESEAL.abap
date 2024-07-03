  METHOD update_log_eseal.
*---------------------------------------------------------------------*
* Triggering Method: ZDCL_ODATA_INTERFACE -> GENERATE_ESEAL_CERTIFICATE_DOC
* Purpose of this method is to set the correct message for the log table.
*---------------------------------------------------------------------*
*    CALL Action:
*    ZDCL_ODATA_INTERFACE -> GENERATE_ESEAL_CERTIFICATE_DOC
*---------------------------------------------------------------------*
* Step 9: Analysing the final status of the program to update the status in the log table
*---------------------------------------------------------------------*
    IF iv_is_error = 'X'.
      is_eseal_log-status = '04'.
      CASE iv_error_code.
        WHEN 01.
          CONCATENATE 'Error: ' TEXT-049 INTO is_eseal_log-error_desc.
        WHEN 02.
          CONCATENATE 'Error: ' TEXT-050 INTO is_eseal_log-error_desc.
        WHEN 03.
          CONCATENATE 'Error: ' TEXT-051 INTO is_eseal_log-error_desc.
        WHEN 04.
          CONCATENATE 'Error: ' TEXT-052 INTO is_eseal_log-error_desc.
        WHEN 05.
          CONCATENATE 'Error: ' TEXT-053 INTO is_eseal_log-error_desc.
        WHEN 06.
          CONCATENATE 'Error: ' TEXT-054 INTO is_eseal_log-error_desc.
        WHEN 07.
          CONCATENATE 'Error: ' TEXT-055 INTO is_eseal_log-error_desc.
        WHEN 08.
          CONCATENATE 'Error: ' iv_desc     INTO is_eseal_log-error_desc.
        WHEN 09.
          CONCATENATE 'Error: ' TEXT-057 INTO is_eseal_log-error_desc.
        WHEN 10.
          CONCATENATE 'Error: ' TEXT-058 INTO is_eseal_log-error_desc.
        WHEN 11.
          CONCATENATE 'Error: ' TEXT-059 INTO is_eseal_log-error_desc.
        WHEN 12.
          CONCATENATE 'Error: ' TEXT-060 INTO is_eseal_log-error_desc.
      ENDCASE.
    ELSE.
      is_eseal_log-status = '03'.
      CONCATENATE 'Completed: ' iv_desc INTO is_eseal_log-error_desc.
    ENDIF.
*---------------------------------------------------------------------*
* Step 11: Modifying the log table with Status.
*---------------------------------------------------------------------*
    MODIFY zdc_eseal_log FROM is_eseal_log. "#EC CI_IMUD_NESTED "#EC CI_SUBRC
  ENDMETHOD.                                             "#EC CI_VALPAR
