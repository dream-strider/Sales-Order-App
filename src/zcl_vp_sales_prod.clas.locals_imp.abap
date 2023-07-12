CLASS LHC_ZPRODUCT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR zproduct
        RESULT result,
      valCurrencyCode FOR VALIDATE ON SAVE
            IMPORTING keys FOR zproduct~valCurrencyCode,
      valPrice FOR VALIDATE ON SAVE
            IMPORTING keys FOR zproduct~valPrice.
ENDCLASS.

CLASS LHC_ZPRODUCT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD valCurrencyCode.

  "reading data from cds
  READ ENTITIES OF zi_vp_sales_prod IN LOCAL MODE
  ENTITY zproduct FIELDS ( pid )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_currencykey).

  LOOP AT lt_currencykey INTO DATA(ls_curr).

  SELECT FROM I_Currency FIELDS Currency WHERE Currency = @ls_curr-Curr
  INTO TABLE @DATA(lt_curr).

  "validating the currency and giving error msgs
  IF lt_curr is INITIAL.
  " Creating the error msg in case validation fails
  DATA(lv_message) =  me->new_message(
                     id       = 'ZCM_CUS_02'
                     number   = 001
                     severity = ms-error
                     v1       = ls_curr-Curr

                   ).
  " To Display Error Pop up msg
  DATA ls_record LIKE LINE OF reported-zproduct.
  ls_record-%msg = lv_message.
  APPEND ls_record TO reported-zproduct.

  DATA ls_fail LIKE LINE OF failed-zproduct.
  APPEND ls_fail TO failed-zproduct.

  ENDIF.

  ENDLOOP.


  ENDMETHOD.

  METHOD valPrice.

   "reading data from cds
  READ ENTITIES OF zi_vp_sales_prod IN LOCAL MODE
  ENTITY zproduct FIELDS ( pid )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_price).

  LOOP AT lt_price INTO DATA(ls_price).

  IF ls_price-Price IS INITIAL OR ls_price-Price lt 1 .

   " Creating the error msg in case validation fails
  DATA(lv_message) =  me->new_message(
                     id       = 'ZCM_CUS_02'
                     number   = 005
                     severity = ms-error
                     v1       = ls_price-Price

                   ).
   " To Display Error Pop up msg
  DATA ls_record LIKE LINE OF reported-zproduct.
  ls_record-%msg = lv_message.
  APPEND ls_record TO reported-zproduct.

  DATA ls_fail LIKE LINE OF failed-zproduct.
  APPEND ls_fail TO failed-zproduct.


  ENDIF.
  ENDLOOP.

  ENDMETHOD.

ENDCLASS.
