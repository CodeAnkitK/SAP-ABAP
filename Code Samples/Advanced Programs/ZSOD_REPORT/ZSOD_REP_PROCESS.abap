*&---------------------------------------------------------------------*
*&  Include           ZSOD_REP_PROCESS
*&---------------------------------------------------------------------*

INITIALIZATION.
PERFORM get_first_day_of_month.
s_dater-high = sy-datum.
s_dater-low = gv_first_day.
APPEND s_dater.

START-OF-SELECTION.

    " Get the default list of tcodes from the table ZTSODSTR
    " with validated records TVARVC table named paramenter ZSODREPTCODES.
    PERFORM default_transaction_list.
    " Create the structure of the structure of the final table.
    PERFORM create_final_table_structure.
    " Get the user details and append them to the final table.
    PERFORM get_user_details.


END-OF-SELECTION.

    " Display the final table.
    PERFORM display_alv.
