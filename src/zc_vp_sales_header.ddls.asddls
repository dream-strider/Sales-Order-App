@EndUserText.label: 'Sales Header'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'SalesId' ]
define root view entity zc_vp_sales_header
provider contract transactional_query
 as projection on ZI_VP_SALES_HEADER
{
    key SalesId,
    CustId,
    EmpId,
    Descrip,
    LastChangedAt,
    
    /* Associations */
    _Item: redirected to composition child ZC_VP_SALES_ITEM
}
