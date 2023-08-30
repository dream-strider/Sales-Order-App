@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VP_SALES_ITEM1 as select from ztab_sitem as Item

association to parent ZI_VP_SALES_HEADER1 as _Header on $projection.SalesId = _Header.SalesID
association  to ZI_VP_SALES_PROD as _Product on $projection.Pid = _Product.PID
{
    key item_no as ItemNo,
    sales_id as SalesId,
    pid as Pid,
    qty as Qty,
    qty as qtyR,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    net_price as NetPrice,
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.user.localInstanceLastChangedBy: true
    changed_by as ChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    
    // Associations
    
    _Header,
    _Product
    
}
