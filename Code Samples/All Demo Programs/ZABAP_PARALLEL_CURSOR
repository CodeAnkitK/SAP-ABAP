*&---------------------------------------------------------------------*
*& Report ZABAP_PARALLEL_CURSOR
*&---------------------------------------------------------------------*
*&
*&Key Points in Parallel Cursors:
*
*&Sorting: Both tables must be sorted by the field you are comparing (CUSTOMER_ID in this case).
*
*&Efficiency: This technique avoids the need for nested loops, which can be inefficient with large datasets.
*
*&Advancing Cursors: Cursors (LV_INDEX_CUST and LV_INDEX_ORD) are advanced based on the comparison to
*&    minimize unnecessary checks.
*
*Loop Logic: The loop continues as long as there are entries in both tables.
*   The IF condition checks for a match on customer_id. If a match is found,
*   it processes the current entries. If the current customer ID is less than the
*   order's customer ID, the loop advances the customer index to look for a match.
*   If the customer ID is greater, it advances the order index to find the next possible match.
*&---------------------------------------------------------------------*
REPORT zabap_parallel_cursor.

TYPES: BEGIN OF ty_customer,
         customer_id TYPE i,
         name        TYPE string,
       END OF ty_customer,
       BEGIN OF ty_order,
         customer_id TYPE i,
         order_id    TYPE i,
       END OF ty_order.

DATA: it_customers TYPE TABLE OF ty_customer,
      it_orders    TYPE TABLE OF ty_order.

DATA: lv_index_cust TYPE i,
      lv_index_ord  TYPE i.

*&---------------------------------------------------------------------*
* Fill tables with data
*&---------------------------------------------------------------------*

it_customers = VALUE #(
  ( customer_id = 1 name = 'Alice' )
  ( customer_id = 2 name = 'Bob' )
).

it_orders = VALUE #(
  ( customer_id = 1 order_id = 100 )
  ( customer_id = 1 order_id = 101 )
  ( customer_id = 2 order_id = 102 )
).

*&---------------------------------------------------------------------*
* Initialize indexes
*&---------------------------------------------------------------------*
lv_index_cust = 1.
lv_index_ord = 1.

*&---------------------------------------------------------------------*
* Process tables in parallel
*&---------------------------------------------------------------------*
WHILE lv_index_cust <= lines( it_customers ) AND lv_index_ord <= lines( it_orders ).
  IF it_customers[ lv_index_cust ]-customer_id = it_orders[ lv_index_ord ]-customer_id.
*&---------------------------------------------------------------------*
* Output customer and order as they match
*&---------------------------------------------------------------------*
    WRITE: / it_customers[ lv_index_cust ]-name, it_orders[ lv_index_ord ]-order_id.
    lv_index_ord = lv_index_ord + 1.

  ELSEIF it_customers[ lv_index_cust ]-customer_id < it_orders[ lv_index_ord ]-customer_id.
*&---------------------------------------------------------------------*
* Move to the next customer if current customer ID is less than order's customer ID
*&---------------------------------------------------------------------*
    lv_index_cust = lv_index_cust + 1.

  ELSE.
*&---------------------------------------------------------------------*
* Skip to next order if no current matching customer
*&---------------------------------------------------------------------*
    lv_index_ord = lv_index_ord + 1.

  ENDIF.
ENDWHILE.
