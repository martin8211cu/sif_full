<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->

<!---*******************************************
*******Consultas Comunes************************
********************************************--->
<!--- Consulta de Periodo de Auxiliares --->
<cfquery name="rsPeriodoAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 50 
</cfquery>
<!--- Consulta de Mes de Auxiliares --->
<cfquery name="rsMesAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 60 
</cfquery>
<!--- Consulta de Periodos --->
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select -1 as value, '--Todos--' as description 
		from dual
	union
	select distinct Speriodo as value ,<cf_dbfunction name="to_char" args="Speriodo"> as description  
		from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"/>
	order by value
</cfquery>
<!--- Consulta de Meses --->
<cfquery name="rsMeses" datasource="#session.dsn#">
	select -1 as value, '--Todos--' as description 
		from dual
	union
	select <cf_dbfunction name="to_number" args="VSvalor"> as value, VSdesc as description
		from VSidioma vs
			inner join Idiomas id
			on id.Iid = vs.Iid
			and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#"/>
	where VSgrupo = 1
	order by 1
</cfquery>
<!--- Consulta de Conceptos --->
<cfquery name="rsConceptos" datasource="#session.dsn#">
	select -1 as value, '--Todos--' as description, -2 as orden
		from dual
	union
	select -10 as value, '--(NA) Sin Asignar--' as description, -1 as orden
		from dual
	union
	select Cconcepto as value, Cdescripcion as description, 0 as orden
		from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 3,2
</cfquery>
<!--- Consulta de Estados --->
<cfset rsEstados = querynew("value,description")>
<cfset QueryAddRow(rsEstados,4)>
<cfset QuerySetCell(rsEstados, "value", -1, 1)>
<cfset QuerySetCell(rsEstados, "description", '--Todos--', 1)>
<cfset QuerySetCell(rsEstados, "value", 0, 2)>
<cfset QuerySetCell(rsEstados, "description", 'Incompleto', 2)>
<cfset QuerySetCell(rsEstados, "value", 1, 3)>
<cfset QuerySetCell(rsEstados, "description", 'Completo', 3)>
<cfset QuerySetCell(rsEstados, "value", 2, 4)>
<cfset QuerySetCell(rsEstados, "description", 'Conciliado', 4)>
<!---*******************************************
*******Pasa Parámetros del url al form**********
********************************************--->
<cfif isdefined("url.GATPeriodo") and len(trim(url.GATPeriodo))>
	<cfset form.GATPeriodo = url.GATPeriodo>
</cfif>
<cfif isdefined("url.GATMes") and len(trim(url.GATMes))>
	<cfset form.GATMes = url.GATMes>
</cfif>
<cfif isdefined("url.CConcepto") and len(trim(url.CConcepto))>
	<cfset form.CConcepto = url.CConcepto>
</cfif>
<cfif isdefined("url.EDocumento") and len(trim(url.EDocumento))>
	<cfset form.EDocumento = url.EDocumento>
</cfif>
<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
	<cfset form.Ocodigo = url.Ocodigo>
</cfif>
<cfif isdefined("url.CFcuenta") and len(trim(url.CFcuenta))>
	<cfset form.CFcuenta = url.CFcuenta>
</cfif>
<!---*******************************************
*******Parametros requeridos para continuar*****
********************************************--->
<cfparam name="Form.GATPeriodo" default="#rsPeriodoAux.Pvalor#">
<cfparam name="Form.GATMes" default="#rsMesAux.Pvalor#">
<cfparam name="Form.CConcepto" default="-1">
<cfparam name="Form.EDocumento" default="">
<!---*******************************************
*******Consultas adicionales para los***********
*******detalles de la Conciliacion**************
********************************************--->
<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
	<cfquery name="rsOdescripcion" datasource="#session.dsn#">
		select Odescripcion from Oficinas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
	</cfquery>
	<cfset form.Odescripcion = rsOdescripcion.Odescripcion>
</cfif>
<cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))>
	<cfquery name="rsCFcuenta" datasource="#session.dsn#">
		select CFformato from CFinanciera where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
	</cfquery>
	<cfset form.CFformato = rsCFcuenta.CFformato>
</cfif>
