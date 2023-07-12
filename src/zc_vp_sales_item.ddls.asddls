@EndUserText.label: 'Sales Item'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'ItemNo' ]
define view entity ZC_VP_SALES_ITEM as projection on ZI_VP_SALES_ITEM as Item
{
    key ItemNo,
    SalesId,
    Pid,
    Qty,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    NetPrice,
    CurrencyCode,
   
    LastChangedAt,
    
    /* Associations */
    _Header: redirected to parent ZC_VP_SALES_HEADER
}
