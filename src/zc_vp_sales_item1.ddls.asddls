@EndUserText.label: 'Sales Item'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'ItemNo' ]
define view entity ZC_VP_SALES_ITEM1 as projection on ZI_VP_SALES_ITEM1 as Item
{
    key ItemNo,
    SalesId,
    @Consumption.valueHelpDefinition: [{entity : { name: 'ZI_VP_SALES_PROD', element: 'PID' }}]
    Pid,
    Qty,
    qtyR,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    NetPrice,
    CurrencyCode,
   
    LastChangedAt,
    
    _Product.AvlQty as AvlQty,
    
    /* Associations */
    _Header: redirected to parent ZC_VP_SALES_HEADER1
}
