<cftransaction>

<cfparam name="url.EcodigoASP" 	type="numeric" default="#session.EcodigoSDC#">	
<cfparam name="url.RCNid" 		type="numeric">	

<!---  <cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.dsn#">
	<cf_dbtempcol name="Constante" 	        type="varchar(1)"  mandatory="no">
	<cf_dbtempcol name="Cuenta" 			      type="varchar(100)"  mandatory="no">
	<cf_dbtempcol name="TipoMov" 		        type="varchar(1)"  	mandatory="no">
	<cf_dbtempcol name="MontoDebito" 	       type="float"  		mandatory="no">
	<cf_dbtempcol name="MontoCredito" 		   type="float"  		mandatory="no">
	<cf_dbtempcol name="Referencia" 		type="varchar(100)" mandatory="no"> 
	<cf_dbtempcol name="prioridad" 	        type="varchar(1)"  mandatory="no">
</cf_dbtemp> --->

<cf_dbfunction name="OP_concat" returnvariable="CAT" >   

<cfquery datasource="#session.DSN#" >  
   Create Table DatosExpContaRox (
	Constante char (1) null,
	Cuenta varchar(100) null,
	TipoMov char(1) null,
	MontoDebito numeric(18,2) null,
	MontoCredito numeric(18,2) null,
	Referencia varchar(100) null,
	prioridad char (1) null)
</cfquery> 

<!--- Si RCuentasTipo.tiporeg diferente a 80 o 85 insertar en prioridad un 2  --->

<cfquery datasource="#session.DSN#" >
	Insert into DatosExpContaRox (
	Constante, 
	Cuenta,
	TipoMov, 
	Referencia, 
	MontoDebito, 
	MontoCredito, 
	prioridad)
	Select 	'1' as Constante, 
		Cformato as Cuenta, 
		tipo as TipoMov, 
		RCDescripcion as Referencia, 
		case when tipo='D' then 
	coalesce(Sum(montores),0) 
	else 0 end as MontoDebito,
		case when tipo='C' then 
	coalesce(Sum(montores),0) 
	else 0 end as MontoCredito,
  '2' as prioridad   
	from   
	RCuentasTipo a, 
	HRCalculoNomina b  
	Where a.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">    <!--- Según La nómina seleccionada en el Filtro --->
	and a.RCNid=b.RCNid
	and a.tiporeg not in (80,85) 
	group by Cformato, tipo,RCDescripcion 
</cfquery>

<!--- Si RCuentasTipo.tiporeg = 80 o 85 insertar en prioridad un 3  --->
<cfquery datasource="#session.DSN#" >
	Insert into DatosExpContaRox (
	Constante, 
	Cuenta,
	TipoMov, 
	Referencia, 
	MontoDebito, 
	MontoCredito, 
	prioridad)
	Select 	'1' as Constante, 
		Cformato as Cuenta, 
		tipo as TipoMov, 
		RCDescripcion as Referencia, 
		case when tipo='D' then 
	coalesce(Sum(montores),0) 
	else 0 end as MontoDebito,
		case when tipo='C' then 
	coalesce(Sum(montores),0) 
	else 0 end as MontoCredito,
  '3' as prioridad   
	from   
	RCuentasTipo a, 
	HRCalculoNomina b  
	Where a.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">    <!--- Según La nómina seleccionada en el Filtro --->
	and a.RCNid=b.RCNid
	and a.tiporeg in (80,85) 
	group by Cformato, tipo,RCDescripcion 
</cfquery>

<!--- Ordenar por la prioridad insertada  --->
<cfquery name="ERR" datasource="#session.DSN#" >
Select 'Index Number' #CAT# ','  #CAT#
			 'Account' #CAT# ','  #CAT#
			 'Debit'	 #CAT# ','  #CAT# 
			 'Credit'  #CAT# ','  #CAT#
			 'Distribution Reference' as Salida, 
			 '0' as prioridad,
			 'A' as TipoMov
union	
Select 	Constante #CAT# ','  #CAT#
		rtrim (substring(Cuenta,6, len(Cuenta)))  #CAT#  ','  #CAT#   <!--- La Cuenta de KFC omite el nivel CuentaMayor de SOIN, por eso se extrae de la Consulta --->
		<cf_dbfunction name="to_char_float"  args="round(MontoDebito,2) "  dec="2"  datasource="#session.dsn#"> #CAT#  ','  #CAT#
	  <cf_dbfunction name="to_char_float"  args="round(MontoCredito,2) "  dec="2"  datasource="#session.dsn#"> #CAT#  ','  #CAT#	
		rtrim (Referencia) as Salida,
		prioridad,
		TipoMov
from DatosExpContaRox 
order by TipoMov,prioridad
</cfquery> 

<cfquery datasource="#session.DSN#" >
drop table DatosExpContaRox 
</cfquery> 

</cftransaction>