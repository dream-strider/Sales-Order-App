@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_VP_SALES_EMP'
@ObjectModel.semanticKey: [ 'EmpID' ]
define root view entity ZC_VP_SALES_EMP
  provider contract transactional_query
  as projection on ZI_VP_SALES_EMP
{
  key EmpID,
  Name,
  Dob,
  Des,
  LastChangedAt
  
}
