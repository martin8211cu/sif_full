<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 6 de setiembre del 2005
	Motivo: se agregó un nuevo parametro para el reporte que indica el idioma para la leyenda del monto en letras.


	Modificado por: Ana Villavicencio
	Fecha: 16 de setiembre del 2005
	Motivo: se agregó un nuevo parametro para el reporte que indica la persona autorizada para la firma de las facturas.
	
	Modificado por: Ana Villavicencio
	Fecha: 26 de setiembre del 2005
	Motivo: El tipo de movimiento determina el archivo .jasper para la impresion ya se Nota de Crédito o Factura. 
			No estaba tomando en cuenta el tipo de movimiento seleccionado.  Se cambio la condicion para q tomara 
			en cuenta el CCtipo.
--->
<!--- PROCESO DE IMPRESIÓN DE LA SOLICITUD --->

<cfif isdefined("url.Dreferencia") and len(trim(url.Dreferencia))>
	<cfquery datasource="#session.DSN#">
		update EDocumentosAgrupados
		set EDAestado='I'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Dreferencia#">
	</cfquery>
	<cfquery name="rsTrans" datasource="#session.DSN#">
		select CCTtipo
		from EDocumentosAgrupados a left outer join CCTransacciones b
		on a.Ecodigo = b.Ecodigo and
		   a.CCTcodigo = b.CCTcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Dreferencia#">
	</cfquery>
	<cfif isdefined('url.CCtipo') and url.CCtipo EQ 'D'>
	
		<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_RPDCC001.jasper" >
		<!---<cfinclude template="/sif/reportes/4_RPDCC001.cfm">prueba con otro codigo de empresa--->
		<cfinclude template="/sif/reportes/#session.Ecodigo#_RPDCC001.cfm">
	<cfelse> 
		<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_RPDCC002.jasper" >
		<!---<cfinclude template="/sif/reportes/4_RPDCC002.cfm">prueba con otro codigo de empresa--->
		<cfinclude template="/sif/reportes/#session.Ecodigo#_RPDCC002.cfm">
	</cfif>

	<!---<cf_jasperreport datasource="#session.DSN#"
					 output_format="pdf"
					 jasper_file="#tipoFormato#">
		<cf_jasperparam name="Ecodigo" value="#session.Ecodigo#">
		<cf_jasperparam name="Dreferencia" value="#url.Dreferencia#">
		<cf_jasperparam name="Idioma" value="#url.Idioma#">
		<cf_jasperparam name="firmaAutorizada" value="#url.firmaAutorizada#">
		<cf_jasperparam name="CCtipo" value="#url.CCtipo#">
	</cf_jasperreport>--->
</cfif>
