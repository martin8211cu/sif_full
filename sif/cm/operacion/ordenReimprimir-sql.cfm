
<cfif isdefined("url.CMTOcodigo") and len(trim(url.CMTOcodigo))>
	<cfset form.CMTOcodigo = url.CMTOcodigo> 
</cfif>
<cfif isdefined("url.CMTOdescripcion") and len(trim(url.CMTOdescripcion))>
	<cfset form.CMTOdescripcion = url.CMTOdescripcion> 
</cfif>
<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo))>
	<cfset form.Ecodigo = url.Ecodigo> 
</cfif>
<cfif isdefined("url.EOfecha") and len(trim(url.EOfecha))>
	<cfset form.EOfecha = url.EOfecha> 
</cfif>	
<cfif isdefined("url.EOIDorden") and len(trim(url.EOIDorden))>
	<cfset form.EOIDorden = url.EOIDorden> 
</cfif>	
<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
	<cfset form.EOnumero = url.EOnumero> 
</cfif>	
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo))>
	<cfset form.Mcodigo = url.Mcodigo> 
</cfif>	
<cfif isdefined("url.modo") and len(trim(url.modo))>
	<cfset form.modo = url.modo> 
</cfif>	 
<cfif isdefined("url.observaciones") and len(trim(url.observaciones))>
	<cfset form.observaciones = url.observaciones> 
</cfif>	 
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo> 
</cfif>	 
<cfif isdefined("url.SNnombre") and len(trim(url.SNnombre))>
	<cfset form.SNnombre = url.SNnombre> 
</cfif>	 
<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
	<cfset form.SNnumero = url.SNnumero> 
</cfif>	 
<cfif isdefined("url.TipoImpresion") and len(trim(url.TipoImpresion))>
	<cfset form.TipoImpresion = url.TipoImpresion> 
</cfif>	
 
<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
<!--- *1* --->
<cfset bandImpresion = false>
<!----
<cfquery datasource="#session.DSN#">
	update EOrdenCM
	set EOImpresion='R'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>
----->
<cfquery name="rsTipoOrden" datasource="#Session.DSN#">
	select a.EOnumero, a.CMTOcodigo, a.CMCid, rtrim(b.FMT01COD) as formato
	from EOrdenCM a 
		 inner join CMTipoOrden b
			on a.Ecodigo = b.Ecodigo
			and a.CMTOcodigo = b.CMTOcodigo 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery> 

<cfif rsTipoOrden.recordcount gt 0 and len(trim(rsTipoOrden.formato)) >
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select FMT01tipfmt, FMT01cfccfm
		from FMT001
		where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoOrden.formato)#">
	</cfquery>


<!---	<cfdump var="#rsFormato#">--->
	<cfif trim(rsFormato.FMT01tipfmt) eq 1 >
		<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
		<cfinclude template="../../Utiles/validaUri.cfm">
		<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
		<cfif not LvarOK ><cf_errorCode	code = "50274"
		                  				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
		                  				errorDat_1="#LvarSPhomeuri#"
		                  ></cfif>
	</cfif> 
</cfif>

<cfif isdefined("LvarArchivo") > 	
	<cf_templateheader title="Compras - Orden Compra Local">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Orden de Compra Local'>
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<cfset parametros = "">
			<cfif isdefined("rsTipoOrden.EOnumero") and len(trim(rsTipoOrden.EOnumero))>
				<cfset parametros = parametros & "&EOnumero=" & rsTipoOrden.EOnumero >
			</cfif>

			<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#"> 

			<!---<cfinclude template="../consultas/OrdenCompraLocal-html.cfm">--->
			<cfinclude template="#LvarArchivo#">
			<DIV align="center"><input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='orden-reimprimir.cfm'" ></DIV>
			<br>
			
		<cf_web_portlet_end>
	<cf_templatefooter>
	<cfset bandImpresion = true>
<cfelse>
	<cfif rsTipoOrden.RecordCount GT 0>

		<cfinclude template= "/sif/reportes/#session.Ecodigo#_#rsTipoOrden.Formato#.cfm">
		 <!--- <cfinclude template="../../reportes/1_FLASH01.cfm">--->	
		<!---<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_#rsTipoOrden.Formato#.jasper" >--->
		<!---<cf_jasperreport datasource="#session.DSN#"
						 output_format="html"
						 debug="false"
						 jasper_file="#tipoFormato#">
			<cf_jasperparam name="Ecodigo"   value="#session.Ecodigo#">
			<cf_jasperparam name="EOnumero"   value="#rsTipoOrden.EOnumero#">
			<cf_jasperparam name="CMTOcodigo"   value="#rsTipoOrden.CMTOcodigo#"> 

			<!--- Datos adicionales del Comprador que se ocupan en la OC. --->
			<cf_jasperparam name="PhoneComprador"   	value="#session.datos_personales.oficina#">
			<cf_jasperparam name="FaxComprador"   		value="#session.datos_personales.fax#">
			<cf_jasperparam name="ApartadoComprador"   	value="#session.datos_personales.email2#">
			<cf_jasperparam name="EmailComprador"   	value="#session.datos_personales.email1#">
		</cf_jasperreport>--->					
	<cfelse>
		<script>alert('No hay Formato de Impresión para esta Solicitud.');</script>
	</cfif>
	<cfset bandImpresion = true>		
</cfif>

<!---
<form action="solicitudes-reimprimir.cfm" method="post" name="sql"></form>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
--->

<!--- *2* --->
<!----
<cfif not bandImpresion>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>	
</cfif>
------>

