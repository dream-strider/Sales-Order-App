CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

*  DATA: wa_pid TYPE  ztab_pid_02.

*    METHODS valCurrencyCode FOR VALIDATE ON SAVE
*      IMPORTING keys FOR Item~valCurrencyCode.
    METHODS valPid FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~valPid.
    METHODS calPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~calPrice.
    METHODS valQty FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~valQty.
    METHODS calQty FOR DETERMINE ON SAVE
      IMPORTING keys FOR Item~calQty.
    METHODS QtyChange FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~QtyChange.
    METHODS QtyCngDel FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~QtyCngDel.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

*  METHOD valCurrencyCode.
*
*   "reading data from cds
*  READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
*  ENTITY Item FIELDS (  ItemNo )
*  WITH CORRESPONDING #( keys )
*  RESULT DATA(lt_currencykey).
*
*  LOOP AT lt_currencykey INTO DATA(ls_curr).
*
*  SELECT FROM I_Currency FIELDS Currency WHERE Currency = @ls_curr-CurrencyCode
*  INTO TABLE @DATA(lt_curr).
*
*  "validating the currency and giving error msgs
*  IF lt_curr is INITIAL.
*  " Creating the error msg in case validation fails
*  DATA(lv_message) =  me->new_message(
*                     id       = 'ZCM_CUS_02'
*                     number   = 001
*                     severity = ms-error
*                     v1       = ls_curr-CurrencyCode
*
*                   ).
*  " To Display Error Pop up msg
*  DATA ls_record LIKE LINE OF reported-item.
*  ls_record-%msg = lv_message.
*  APPEND ls_record TO reported-item.
*
*  DATA ls_fail LIKE LINE OF failed-item.
*  APPEND ls_fail TO failed-item.
*
*  ENDIF.
*
*  ENDLOOP.
*
*  ENDMETHOD.

  METHOD valPid.

    "reading data from cds
    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item FIELDS (  ItemNo )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_pid).

    LOOP AT lt_pid INTO DATA(ls_pid).

      SELECT FROM zi_vp_sales_prod FIELDS pid WHERE pid = @ls_pid-Pid
      INTO TABLE @DATA(lt_prod).

      "validating the currency and giving error msgs
      IF lt_prod IS INITIAL.
        " Creating the error msg in case validation fails
        DATA(lv_message) =  me->new_message(
                           id       = 'ZCM_CUS_02'
                           number   = 008
                           severity = ms-error
                           v1       = ls_pid-Pid

                         ).
        " To Display Error Pop up msg
        DATA ls_record LIKE LINE OF reported-item.
        ls_record-%msg = lv_message.
        APPEND ls_record TO reported-item.

        DATA ls_fail LIKE LINE OF failed-item.
        APPEND ls_fail TO failed-item.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD calPrice.

    DATA lt_price TYPE TABLE FOR READ RESULT zi_vp_sales_item1.

    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item FIELDS ( ItemNo Pid Qty )
    WITH CORRESPONDING #( keys ) RESULT lt_price.

    LOOP AT lt_price INTO DATA(ls_price).

      " Checking if PID is not passed, if so then using the previous PID, if passed then storing it in PID table(after deleting previous PID)        ---NOT NEEDED AS NOW PASSED THE FIELDS IN THE ABOVE READ STATEMENT MANUALLY

*IF ls_price-Pid IS INITIAL.
*
*SELECT FROM ztab_pid_02 FIELDS pid INTO ( @wa_pid-pid ).
*ENDSELECT.
*
*ls_price-Pid = wa_pid-pid.
*
*ELSE.
*
*wa_pid-pid = ls_price-Pid.
*
*DELETE FROM ztab_pid_02.
*INSERT ztab_pid_02 FROM @wa_pid.
*
*ENDIF.





      SELECT SINGLE FROM zi_vp_sales_prod FIELDS Price ,Curr
      WHERE pid = @ls_price-Pid
      INTO ( @ls_price-NetPrice , @ls_price-CurrencyCode ).
      IF sy-subrc EQ 0.

        ls_price-NetPrice = ls_price-NetPrice * ls_price-Qty.
        MODIFY lt_price FROM ls_price.


      ENDIF.



    ENDLOOP.

    DATA lt_update TYPE TABLE FOR UPDATE zi_vp_sales_item1.
    lt_update = CORRESPONDING #( lt_price ).

    MODIFY ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item UPDATE FIELDS ( NetPrice  CurrencyCode )
    WITH lt_update REPORTED DATA(lt_report).

    reported-sales_header = CORRESPONDING #( lt_report-item ).



  ENDMETHOD.

  METHOD valQty.

    "reading data from cds
    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item FIELDS (  ItemNo )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_qty).

    LOOP AT lt_qty INTO DATA(ls_qty).

      SELECT FROM zi_vp_sales_prod FIELDS AvlQty WHERE pid = @ls_qty-Pid
      INTO  @DATA(ls_prod).
      ENDSELECT.

      "validating the qty with available qty and giving error msgs

      IF ls_prod < ls_qty-Qty.
        " Creating the error msg in case validation fails
        DATA(lv_message) =  me->new_message(
                           id       = 'ZCM_CUS_02'
                           number   = 010
                           severity = ms-error
                           v1       = ls_prod
                           v2       = ls_qty-Qty
                         ).
        " To Display Error Pop up msg
        DATA ls_record LIKE LINE OF reported-item.
        ls_record-%msg = lv_message.
        APPEND ls_record TO reported-item.

        DATA ls_fail LIKE LINE OF failed-item.
        APPEND ls_fail TO failed-item.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD calQty.

    DATA: lt_qty  TYPE TABLE FOR READ RESULT zi_vp_sales_item1, lt_prod TYPE TABLE FOR READ RESULT zi_vp_sales_prod, wa_qty TYPE ztab_valchange.

    " Loading Item Data to local table

    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item FIELDS ( ItemNo Pid Qty )
    WITH CORRESPONDING #( keys ) RESULT lt_qty.



    "Looping data to work area to perform calculations

    LOOP AT lt_qty INTO DATA(ls_qty).


      "Loading product data whose pid matches into local table lt_prod
      READ ENTITIES OF zi_vp_sales_prod
      ENTITY zproduct ALL  FIELDS
      WITH VALUE #( ( pid = ls_qty-Pid ) ) RESULT lt_prod.


      "Storing available qty into a local variable
      SELECT SINGLE FROM zi_vp_sales_prod FIELDS AvlQty
      WHERE pid = @ls_qty-Pid
      INTO @DATA(lv_qty).
      IF sy-subrc EQ 0.

        lv_qty = lv_qty - ls_qty-Qty.
        wa_qty-pid = ls_qty-Pid.   "Inserting qty with respective PID and Item Number into work area of value change table
        wa_qty-qty = ls_qty-Qty.
        wa_qty-itemno = ls_qty-ItemNo.
        DELETE FROM ztab_valchange WHERE pid = @ls_qty-Pid AND itemno = @ls_qty-ItemNo.
        INSERT ztab_valchange FROM @wa_qty.   " Inserting the qty into value change table to use in future during edit option


      ENDIF.



    ENDLOOP.

    " loading the new available qty from local variable
    LOOP AT lt_prod INTO DATA(ls_prod).
      ls_prod-AvlQty = lv_qty.
      MODIFY lt_prod FROM ls_prod.
    ENDLOOP.

    DATA lt_update TYPE TABLE FOR UPDATE zi_vp_sales_prod.
    lt_update = CORRESPONDING #( lt_prod ).

    MODIFY ENTITIES OF zi_vp_sales_prod
    ENTITY zproduct UPDATE FIELDS ( AvlQty Price Curr )
    WITH lt_update REPORTED DATA(lt_report).

    reported-sales_header = CORRESPONDING #( lt_report-zproduct ).


  ENDMETHOD.

  METHOD QtyChange.

  DATA: lt_qty  TYPE TABLE FOR READ RESULT zi_vp_sales_item1, lt_prod TYPE TABLE FOR READ RESULT zi_vp_sales_prod, wa_qty TYPE ztab_valchange.

    " Loading Item Data to local table

    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY Item FIELDS ( ItemNo Pid Qty )
    WITH CORRESPONDING #( keys ) RESULT lt_qty.



    "Looping data to work area to perform calculations

    LOOP AT lt_qty INTO DATA(ls_qty).


      "Loading product data whose pid matches into local table lt_prod
      READ ENTITIES OF zi_vp_sales_prod
      ENTITY zproduct ALL  FIELDS
      WITH VALUE #( ( pid = ls_qty-Pid ) ) RESULT lt_prod.


      "Storing available qty into a local variable
      SELECT SINGLE FROM zi_vp_sales_prod FIELDS AvlQty
      WHERE pid = @ls_qty-Pid
      INTO @DATA(lv_qty).
      IF sy-subrc EQ 0.

        SELECT SINGLE FROM ztab_valchange FIELDS qty
        WHERE pid = @ls_qty-Pid AND itemno = @ls_qty-ItemNo
        INTO @DATA(lv_orgQty).

        IF lv_orgqty gt ls_qty-Qty.

        lv_qty = lv_qty + (   lv_orgqty - ls_qty-Qty ).

        ELSE.

        lv_qty = lv_qty - ( ls_qty-Qty - lv_orgqty ) .


        ENDIF.


      "  lv_qty = lv_qty - ls_qty-Qty.
        wa_qty-pid = ls_qty-Pid.   "Inserting qty with respective PID and Item Number into work area of value change table
        wa_qty-qty = ls_qty-Qty.
        wa_qty-itemno = ls_qty-ItemNo.
        DELETE FROM ztab_valchange WHERE pid = @ls_qty-Pid AND itemno = @ls_qty-ItemNo.
        INSERT ztab_valchange FROM @wa_qty.   " Inserting the qty into value change table to use in future during edit option


      ENDIF.



    ENDLOOP.

    " loading the new available qty from local variable
    LOOP AT lt_prod INTO DATA(ls_prod).
      ls_prod-AvlQty = lv_qty.
      MODIFY lt_prod FROM ls_prod.
    ENDLOOP.

    DATA lt_update TYPE TABLE FOR UPDATE zi_vp_sales_prod.
    lt_update = CORRESPONDING #( lt_prod ).

    MODIFY ENTITIES OF zi_vp_sales_prod
    ENTITY zproduct UPDATE FIELDS ( AvlQty Price Curr )
    WITH lt_update REPORTED DATA(lt_report).

    reported-sales_header = CORRESPONDING #( lt_report-zproduct ).



  ENDMETHOD.

  METHOD QtyCngDel.

  DATA:  lt_prod TYPE TABLE FOR READ RESULT zi_vp_sales_prod.


SELECT *  FROM ztab_valchange    INTO  TABLE @data(lt_val).
SELECT * FROM ztab_sitem  INTO TABLE @DATA(lt_item).



LOOP AT lt_val INTO DATA(ls_val).
LOOP AT lt_item INTO DATA(ls_item).
IF ls_val-itemno eq ls_item-item_no.
EXIT.
ENDIF.

ENDLOOP.
IF ls_val-itemno eq ls_item-item_no.
CONTINUE.

ENDIF.

 READ ENTITIES OF zi_vp_sales_prod
      ENTITY zproduct ALL  FIELDS
      WITH VALUE #( ( pid = ls_val-pid ) ) RESULT lt_prod.


      LOOP AT lt_prod INTO DATA(ls_prod).
      ls_prod-AvlQty = ls_prod-AvlQty + ls_val-qty.
      MODIFY lt_prod FROM ls_prod.
    ENDLOOP.

    DATA lt_update TYPE TABLE FOR UPDATE zi_vp_sales_prod.
    lt_update = CORRESPONDING #( lt_prod ).

    MODIFY ENTITIES OF zi_vp_sales_prod
    ENTITY zproduct UPDATE FIELDS ( AvlQty Price Curr )
    WITH lt_update REPORTED DATA(lt_report).

    reported-sales_header = CORRESPONDING #( lt_report-zproduct ).

    DELETE FROM ztab_valchange WHERE itemno = @ls_val-itemno.



ENDLOOP.



  ENDMETHOD.

ENDCLASS.

CLASS lhc_sales_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR sales_header
        RESULT result,
      valEmpid FOR VALIDATE ON SAVE
        IMPORTING keys FOR sales_header~valEmpid.
ENDCLASS.

CLASS lhc_sales_header IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD valEmpid.

    "reading data from cds
    READ ENTITIES OF zi_vp_sales_header1 IN LOCAL MODE
    ENTITY sales_header FIELDS (  SalesID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_EmpId).

    LOOP AT lt_EmpId INTO DATA(ls_EmpId).

      SELECT FROM zi_vp_sales_emp FIELDS EmpID WHERE EmpID = @ls_EmpId-EmpID
      INTO TABLE @DATA(lt_Emp).

      "validating the currency and giving error msgs
      IF lt_Emp IS INITIAL.
        " Creating the error msg in case validation fails
        DATA(lv_message) =  me->new_message(
                           id       = 'ZCM_CUS_02'
                           number   = 009
                           severity = ms-error
                           v1       = ls_EmpId-EmpID

                         ).
        " To Display Error Pop up msg
        DATA ls_record LIKE LINE OF reported-item.
        ls_record-%msg = lv_message.
        APPEND ls_record TO reported-item.

        DATA ls_fail LIKE LINE OF failed-item.
        APPEND ls_fail TO failed-item.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
