<!---------
	Creado por: Ana Villavicencio
	Fecha: 18 de julio del 2005
	Motivo:	forma para el proceso de importación de documentos de CxC a netear.  
			Se utiliza el tag de importacion q ya a sido definido. 
			

	Modificado por: Ana Villavicencio
	Fecha: 20 de julio del 2005
	Motivo:	se modificó para q recibiera como parámetro el importador q va a utilizar ComprasPagos o VentasCobro.
	Línea: 61

----------->
<cfif isdefined("url.Fecha_F")  and LEN(TRIM(url.Fecha_F)) and not isdefined('form.Fecha_F')>
	<cfset form.Fecha_F= url.Fecha_F>
</cfif>
<cfif isdefined("url.DocumentoNeteo_F") and LEN(TRIM(url.DocumentoNeteo_F)) and not isdefined('form.DcouemtoNeteo_F')>
	<cfset form.DocumentoNeteo_F= url.DocumentoNeteo_F>
</cfif>
<cfif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F)) and not isdefined('form.SNcodigo_F')>
	<cfset form.SNcodigo_F=url.SNcodigo_F>
</cfif>
<cfset regresar = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset regresar = regresar & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
	<cfset regresar = regresar & "&DocumentoNeteo_F=#form.DocumentoNeteo_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset regresar = regresar & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>
<cfif TRIM(Session.monitoreo.smcodigo) EQ 'CC'>
	<cfset LvarTitulo = "Cobrar">
<cfelseif TRIM(Session.monitoreo.smcodigo) EQ 'CP'>
	<cfset LvarTitulo = "Pagar">
</cfif>
<cf_templateheader title="Cuentas por #LvarTitulo#">
		
	<cfquery name="rsArchivo" datasource="sifcontrol">
		select EIid, EIcodigo
		from EImportador
		where EIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Importador#">
	</cfquery>
		<cf_web_portlet_start border="true" titulo="Importación de Documentos a Netear" skin="#Session.Preferences.Skin#">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  	<tr><td align="center" colspan="2">&nbsp;</td></tr>
			  	<tr>
					<cfif isdefined('rsArchivo') and rsArchivo.RecordCount GT 0>
					<td width="60%">
						<cf_sifFormatoArchivoImpr EIcodigo = "#rsArchivo.EIcodigo#">
					</td>
					<td width="15%" align="center" valign="top" style="padding-left: 15px ">
						<cf_sifimportar EIid="#rsArchivo.EIid#" EIcodigo="#rsArchivo.EIcodigo#" mode="in">
					</td>
					<td valign="top">
						<cfoutput>
							<input name="Regresar" type="button" value="Regresar" 
								onClick="javascript: funcRegresar();">
						</cfoutput>
					</td>
					<cfelse>
						<td width="8%" align="center">
							<strong>
								No se a definido un formato de Importador de Documentos de 
								<cfif isdefined('url.Importador') and url.Importador EQ 'VENTASCOBRO'>CxC 
								<cfelseif isdefined('url.Importador') and url.Importador EQ 'VENTASCOBRO'>CxP</cfif> a Netear.</strong></td>
					</cfif>
			  	</tr>
				<tr><td></td></tr>
			</table>
		<cf_web_portlet_end>

  
	<cf_templatefooter>

<script  language="JavaScript1.2">
	function funcRegresar(){
		<cfif Session.monitoreo.smcodigo EQ 'CC'>
		location.href = "../../cc/operacion/Neteo-Lista2.cfm?<cfoutput>#regresar#</cfoutput>";
		<cfelse>
		location.href = "../../cp/operacion/Neteo-Lista1.cfm?<cfoutput>#regresar#</cfoutput>";
		</cfif>
	}
</script>