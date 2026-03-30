<cfif isdefined("url.btnFiltro")>
	<cfset form.btnFiltro = "filtrar">
</cfif>
<style type="text/css">
<!--
.style1 {
	font-size: medium;
	font-weight: bold;
}
-->
</style>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templateheader title="Solicitudes de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresi&oacute;n de Solicitudes de Compra'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<cfif not isdefined("session.compras.solicitante") and len(trim(#session.compras.solicitante#)) EQ 0>
			<cf_errorCode	code = "50326" msg = "No tiene acceso, a las solicitudes">
			<cfabort>
		</cfif>
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="solicitudes-filtroglobal.cfm">
					<cfset navegacion = "&btnFiltro=filtrar">
					<cfif isdefined("form.btnFiltro") and isdefined("session.compras.solicitante") and len(trim(#session.compras.solicitante#)) NEQ 0>

						<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
							<cfset navegacion = navegacion & "&fCMTScodigo=#Trim(form.fCMTScodigo)#">
						</cfif>
						<cfif isdefined("form.fCMTSdescripcion") and len(trim(form.fCMTSdescripcion)) >
							<cfset navegacion = navegacion & "&fCMTSdescripcion=#form.fCMTSdescripcion#">
						</cfif>							

						<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) >
							<cfset navegacion = navegacion & "&fESnumero=#form.fESnumero#">
						</cfif>

						<cfif isdefined("form.fESnumero2") and len(trim(form.fESnumero2)) >
							<cfset navegacion = navegacion & "&fESnumero2=#form.fESnumero2#">
						</cfif>

						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
							<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
						</cfif>
						<cfif isdefined("Form.CFid_filtro") and len(trim(form.CFid_filtro)) >
							<cfset navegacion = navegacion & "&CFid_filtro=#form.CFid_filtro#">
						</cfif>
						<cfif isdefined("Form.CFcodigo_filtro") and len(trim(form.CFcodigo_filtro)) >
							<cfset navegacion = navegacion & "&CFcodigo_filtro=#form.CFcodigo_filtro#">
						</cfif>
						
						<cfif isdefined("Form.fESfecha") and len(trim(form.fESfecha))>
							<cfset navegacion = navegacion & "&fESfecha=#form.fESfecha#">
						</cfif>
						
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.ESidsolicitud, a.Ecodigo, a.ESnumero, a.CFid, 
								   a.CMSid, a.CMTScodigo, a.SNcodigo, a.Mcodigo, 
								   a.CMCid, a.CMElinea, a.EStipocambio, a.ESfecha, 
								   a.ESobservacion, a.NAP, a.NRP, a.NAPcancel, 
								   a.EStotalest, a.ESestado, a.Usucodigo, a.ESfalta, 
								   a.Usucodigomod, a.fechamod, a.ESreabastecimiento,
								   rtrim(b.CFcodigo) #_Cat# ' - ' #_Cat# b.CFdescripcion as CFdescripcion,
								   c.CMTScodigo#_Cat#'-'#_Cat# c.CMTSdescripcion as CMTSdescripcion
							from ESolicitudCompraCM a
							
							inner join CFuncional b
								on b.CFid = a.CFid
							
							inner join CMTiposSolicitud c 			
								on c.Ecodigo = a.Ecodigo 
								and c.CMTScodigo = a.CMTScodigo

							where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante)) NEQ 0>
								and a.CMSid=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.solicitante#">
							</cfif>
							  and a.ESestado in (20,25,30,40,50)
							  and (a.ESImpresion in ('I','R') or a.ESImpresion is null)
							  <!---and a.ESImpresion in ('I','R')--->
							<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
								and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.fCMTScodigo)#">
							</cfif>

							<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) and isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
								and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
							<cfelseif isdefined("form.fESnumero") and len(trim(form.fESnumero))>
								and a.ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#">
							<cfelseif isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
								and a.ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
							</cfif>
			
							<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
								and upper(ESobservacion) like  upper('%#form.fObservaciones#%')
							</cfif>
							<cfif isdefined("Form.CFid_filtro") and len(trim(Form.CFid_filtro)) >
								and b.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid_filtro#">
							</cfif>
			
							<cfif isdefined("Form.fESfecha") and len(trim(Form.fESfecha)) >
								and ESfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fESfecha)#">
							</cfif>
							order by CMTSdescripcion, ESnumero
						</cfquery>

						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="cortes" value="CMTSdescripcion"/>
							<cfinvokeargument name="desplegar" value="ESnumero, ESobservacion, CFdescripcion, ESfecha"/>
							<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Centro Funcional, Fecha"/>
							<cfinvokeargument name="formatos" value="V, V, V, D"/>
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="solicitudesReimprimir-sql.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="form_method" value="get"/>
							<cfinvokeargument name="keys" value="ESidsolicitud"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="maxRows" value="15"/>							
						</cfinvoke>
					<cfelseif isdefined("form.btnFiltro") and isdefined("session.compras.solicitante") and len(trim(#session.compras.solicitante#)) EQ 0>
						<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
							<tr><td><div align="center" class="style1">No tiene acceso a las solicitudes Impresas.</div></td>
							</tr>
						</table>
					<cfelse>	
						&nbsp;
					</cfif>
				</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


