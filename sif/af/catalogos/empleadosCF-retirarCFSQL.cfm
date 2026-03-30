<!---
 Acrchivo:	empleadoCF-retirarCFSQL.cfm
 Creado: 	Randall Colomer Villalta en SOIN
 Fecha:  	04 Diciembre del 2006.
 --->

<!--- Variables para mostrar el mensaje de Error --->
<cfset mensaje = "">
<cfset Error1 = "La fecha inicial no puede ser mayor o igual que la fecha final.">
<cfset Error2 = "La fecha inicial se encuentra en un rango de fechas existente.">
<cfset Error3 = "La fecha final se encuentra en un rango de fechas existente.">
<cfset Error4 = "El rango de fechas que esta tratando de incluir es invalido.">
<cfset Error5 = "El rango de fechas que esta tratando de incluir es invalido.">
<cfset Error6 = "La fecha de retiro no puede ser mayor a la fecha de hoy.">


<cfif isdefined("form.btnRetirarCF")>

	<!--- Asignación de valores de las fechas --->
	<cfif isdefined("form.ECFdesde") and trim(form.ECFdesde) NEQ "">
		<cfset form.fechaDesde = #LSdateformat(form.ECFdesde,'yyyymmdd')#>
	</cfif>

	<cfif isdefined("form.ECFhasta") and trim(form.ECFhasta) NEQ "">
		<cfset form.fechaHasta = #LSdateformat(form.ECFhasta,'yyyymmdd')#>
	<cfelse>
		<cfset form.fechaHasta = '61000101'>
	</cfif>
	
	<cfif trim(form.fechaDesde) EQ trim(form.fechaHasta)>
		<cfset form.fechaHasta = '#form.fechaHasta# 23:59:59'>
	</cfif> 
	
	<!--- Valida que la fecha final sea mayor que la fecha inicio --->
	<cfset LvarInicial            = LSparseDateTime(form.ecfdesde)>
   <cfset LvarFinal 					= LSparseDateTime(form.ecfhasta)>
   <cfset LvarDifFechas 			= datediff('d', LvarInicial, LvarFinal)>
	<cfif LvarDifFechas GT 0>
	
		<!--- Valida que la fecha final sea mayor que la fecha de hoy
		<cfquery name="rsValidaFechaHoy" datasource="#session.dsn#">
			select datediff(dd,convert(datetime,'#form.fechaHasta#'),'#LSdateformat(Now(),'yyyymmdd 23:59:59')#') as fechaHoy
		</cfquery>

		<cfif rsValidaFechaHoy.fechaHoy GT 0>
		 --->
			<!--- Query que sirve para cerrar una nueva línea de tiempo --->
			<cfquery name="rsUpdateCF" datasource="#session.dsn#">
				Update EmpleadoCFuncional 
				set ECFhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ECFhasta)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ECFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECFlinea#">
			</cfquery>
			
		<!---			
		<cfelse>				
			<cfset mensaje = Error6 >
		</cfif>
		--->	
	<cfelse>
		<cfset mensaje = Error1 >
	</cfif>
	
</cfif>

<!--- Funcion de Javascrip que sirve para mostrar el error al usuario o regresar a la lista. --->
<script language="javascript1.2" type="text/javascript">
	<cfif mensaje neq "">	
		alert("<cfoutput>#mensaje#</cfoutput>");
		history.back(-1);
	<cfelse>
		opener.document.location.reload();
		window.close();
	</cfif>
</script>


