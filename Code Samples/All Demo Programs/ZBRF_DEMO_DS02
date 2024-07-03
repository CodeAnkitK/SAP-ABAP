*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO7_DS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo7_ds.

DATA: gt_dir TYPE TABLE OF zgr_phone125.
DATA: gt_dir_1 TYPE TABLE OF zgr_phone125.
DATA: gw_dir_1 TYPE zgr_phone125.
DATA: gw_dstr TYPE zgr_phone_num_125.

gt_dir = VALUE #(
                  ( name = 'Name1' address = 'Delhi' phone = VALUE #(
                                                                      ( phonetype = 'p'  phonenumber = '87839479234' )
                                                                      ( phonetype = '0'  phonenumber = '87839479234' )
                                                                     )
                  )


                  ( name = 'Name2' address = 'Mumbai' phone = VALUE #(
                                                                      ( phonetype = 'p'  phonenumber = '87253523423' )
                                                                      ( phonetype = '0'  phonenumber = '87839479234' )
                                                                     )
                  )


                  ( name = 'Name3' address = 'Bangalore' phone = VALUE #(
                                                                      ( phonetype = 'p'  phonenumber = '87253523423' )
                                                                      ( phonetype = '0'  phonenumber = '87839479234' )
                                                                     )
                  )

                  ( name = 'Name4' address = 'Pune' phone = VALUE #(
                                                                      ( phonetype = 'p'  phonenumber = '87253523423' )
                                                                      ( phonetype = '0'  phonenumber = '87839479234' )
                                                                     )
                  )
                ).

FREE: gw_dir_1, gw_dstr.
REFRESH: gt_dir_1.
*------------------------------------------------------------------
  gw_dir_1-name = 'Name1'.
  gw_dir_1-address = 'Delhi'.

  gw_dstr-phonetype = 'p'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  gw_dstr-phonetype = 'o'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  APPEND gw_dir_1 TO gt_dir_1.
  FREE: gw_dir_1, gw_dstr.
*------------------------------------------------------------------
  gw_dir_1-name = 'Name2'.
  gw_dir_1-address = 'Mumbai'.

  gw_dstr-phonetype = 'p'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  gw_dstr-phonetype = 'o'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  APPEND gw_dir_1 TO gt_dir_1.
  FREE: gw_dir_1, gw_dstr.

*------------------------------------------------------------------
  gw_dir_1-name = 'Name3'.
  gw_dir_1-address = 'Bangalore'.

  gw_dstr-phonetype = 'p'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  gw_dstr-phonetype = 'o'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  APPEND gw_dir_1 TO gt_dir_1.
  FREE: gw_dir_1, gw_dstr.

*------------------------------------------------------------------
  gw_dir_1-name = 'Name4'.
  gw_dir_1-address = 'Pune'.

  gw_dstr-phonetype = 'p'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  gw_dstr-phonetype = 'o'.
  gw_dstr-phonenumber = '23423423'.
  APPEND gw_dstr TO gw_dir_1-phone.

  APPEND gw_dir_1 TO gt_dir_1.
  FREE: gw_dir_1, gw_dstr.


BREAK-POINT.
