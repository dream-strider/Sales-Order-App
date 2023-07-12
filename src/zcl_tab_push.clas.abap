CLASS zcl_tab_push DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tab_push IMPLEMENTATION.
 METHOD if_oo_adt_classrun~main.
  "  DATA: wa_sal TYPE ztab_sheader .
 "   wa_sal-cust_id = 'c62'.
  "  wa_sal-sales_id = 's2'.
 "   wa_sal-descrip = 'test header'.
  "  wa_sal- = 'INR'.


DELETE from ztab_sheader.
"    INSERT ztab_sheader FROM @wa_sal.
    IF sy-subrc = 0.
      out->write( 'Record successfully inserted' ).
    ELSE.
      out->write( 'Unable to insert record' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
