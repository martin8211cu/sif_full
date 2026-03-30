<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
<cfsilent>
<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 6 de setiembre del 2005
	Motivo: se agregó un nuevo parametro para el reporte que indica el idioma para la leyenda del monto en letras.

	Modificado por: Ana Villavicencio
	Fecha: 16 de setiembre del 2005
	Motivo: se agregó un nuevo parametro para el reporte que indica la persona autorizada para la firma de las facturas.
			Se puso la condicion del tipo de impresion ya  sea nota de credito o factura.
	
	Modificado por: Ana Villavicencio
	Fecha: 29 de setiembre del 2005
	Motivo: se agregó un nuevo parámetro para el reporte que indica la el tipo de documento a reimprimir.
	
--->
	<!---<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_RPDCC002.jasper" >--->
	<cfquery datasource="#session.DSN#">
		update EDocumentosAgrupados
		set EDAestado='R'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Dreferencia#">
	</cfquery>
	<cfquery name="rsIdioma" datasource="#session.DSN#">
		select Pvalor as valor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 750
	</cfquery>
	<cfquery name="rsFirma" datasource="#session.DSN#">
		select Pvalor as firma
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 751
	</cfquery>
	<cfoutput>
	<cfif isdefined('url.CCTtipo') and url.CCTtipo EQ 'D'>
	 <cftry> 
		<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_RPDCC001.jasper" >
		<cfinclude template="/sif/reportes/#session.Ecodigo#_RPDCC001.cfm">
		<cfcatch type="any">
		<cf_errorCode	code = "50404"
						msg  = "No existe un reporte para la empresa @errorDat_1@"
						errorDat_1="#session.enombre#"
		>
		</cfcatch>
		</cftry> 
	<cfelse> 
	<cftry> 
	
		<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_RPDCC002.jasper" >
		<cfinclude template="/sif/reportes/#session.Ecodigo#_RPDCC002.cfm">
		<cfcatch type="any">
		 <cf_errorCode	code = "50404"
		 				msg  = "No existe un reporte para la empresa @errorDat_1@"
		 				errorDat_1="#session.enombre#"
		 >
		</cfcatch>
		</cftry> 
	</cfif>
	</cfoutput>
</cfsilent>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
<!---<cf_jasperreport datasource="#session.DSN#"
		 output_format="pdf"
		 jasper_file="#tipoFormato#">
	<cf_jasperparam name="Ecodigo" value="#session.Ecodigo#">
	<cf_jasperparam name="Dreferencia" value="#url.Dreferencia#">
	<cf_jasperparam name="Idioma" value="#rsIdioma.valor#">
	<cf_jasperparam name="firmaAutorizada" value="#rsFirma.firma#">
	<cf_jasperparam name="CCtipo" value="#url.CCTtipo#">
</cf_jasperreport>--->
<form action="reimprimeFactura.cfm" method="post" name="sql"></form>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>


