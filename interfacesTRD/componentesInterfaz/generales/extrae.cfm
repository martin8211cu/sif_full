
<!--- Prepararse para la extracción --->
<!---
	Reemplazar las siguientes constantes
	14: EcodigoSDC
	8: Ecodigo
	107: CodICTS
--->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->
		
<!--- Variable Form para CosICTS--->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	
	<cfset varCodICTS = form.CodICTS>
</cfif>			

<cfinclude template="borrar.cfm">
<cfif Not FindNoCase('nofact', directorio)  AND NOT FindNoCase("complementonf",directorio)>
	<cfif Not REFind('^[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]$', form.FechaI)>
		<cfthrow message="Digite la fecha de inicio">
	</cfif>
	<cfset vFechaI = CreateDate(Right(form.FechaI,4),Mid(form.FechaI,4,2),Left(form.FechaI,2))>
	<cfset session.FechaI = DateFormat(vFechaI, 'dd/mm/yyyy')>
</cfif>

<cfif NOT FindNoCase("complementonf",directorio)>
	<cfif Not REFind('^[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]$', form.FechaF)>
		<cfthrow message="Digite la fecha de final">
	</cfif>
	<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>
	<cfset session.FechaF = DateFormat(vFechaF, 'dd/mm/yyyy')>
</cfif>

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" refresh="yes" ></cfinvoke>


<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset preictsdb       = Application.dsinfo.preicts.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>


<cffunction name="DropTableSQL" output="true">
<cfargument name="TableList" type="string">
	<cfloop list="#Arguments.TableList#" index="TableName">
	if object_id('#Tablename#') is not null
		drop table #Tablename#
	</cfloop>
</cffunction>
<!--- CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
 Variable CodICTS tomada de form 
<cfquery datasource="sifinterfaces" name="INTICTS">
	select Ecodigo, CodICTS, EcodigoSDCSoin
	from int_ICTS_SOIN
	where EcodigoSDCSoin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	<!--- Leer como <cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#"> ---->
</cfquery>
--->

<cfinclude template="../#directorio#/extrae.cfm">