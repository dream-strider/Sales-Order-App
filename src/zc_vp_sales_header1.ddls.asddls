@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_VP_SALES_HEADER1'
@ObjectModel.semanticKey: [ 'SalesID' ]
define root view entity ZC_VP_SALES_HEADER1
  provider contract transactional_query
  as projection on ZI_VP_SALES_HEADER1
{
  key SalesID,
  @Consumption.valueHelpDefinition: [{entity : { name: 'ZI_VP_SALES_CUSTOMER', element: 'CustID' }}]
  CustID,
  @Consumption.valueHelpDefinition: [{entity : { name: 'ZI_VP_SALES_EMP', element: 'EmpID' }}]
  EmpID,
  Descrip,
  LastChangedAt,
  
  // asoociations
  
  _Item:redirected to composition child ZC_VP_SALES_ITEM1,
  _Customer,
 // _Customer.CustID as cust_id,
  _Customer.Name as Name,
 _Customer.Phone as Phone,
  _Customer.Email as Email,
  
  _Employee,
  _Employee.Name as EmpName,
  _Employee.Dob as Dob,
  _Employee.Des as Des
 
 
 // Customer Fields
//  Name,
//  Phone,
//  Email,
  
  //Employee Fields
//  EmpName,
//  Dob,
//  Des
  
}
