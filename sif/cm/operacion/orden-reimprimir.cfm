<cfif isdefined("url.btnFiltro")>
	<cfset form.btnFiltro = "filtrar">
</cfif>

<cf_templateheader title="Reimpresi&oacute;n de &Oacute;rdenes de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresi&oacute;n de Ordenes de Compra'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="ordenReimprimir-filtro.cfm">
					<cfset navegacion = "&btnFiltro=filtrar">

					<cfif isdefined("form.btnFiltro")>
						<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) >
							<cfset navegacion = navegacion & "&CMCid1=#form.CMCid1#">
						<cfelse>
							<cfset navegacion = navegacion & "&CMCid1=#session.compras.comprador#">
						</cfif>
						
						<!-----
						<cfif isdefined("form.fCMTOcodigo") and len(trim(form.fCMTOcodigo)) >
							<cfset navegacion = navegacion & "&fCMTOcodigo=#form.fCMTOcodigo#">
						</cfif>
						--->
						<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
							<cfset navegacion = navegacion & "&CMTOcodigo=#form.CMTOcodigo#">
						</cfif>
						<cfif isdefined("form.CMTOdescripcion") and len(trim(form.CMTOdescripcion)) >
							<cfset navegacion = navegacion & "&CMTOdescripcion=#form.CMTOdescripcion#">
						</cfif>
						
						<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
							<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
						</cfif>

						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
							<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
						</cfif>

						<cfif isdefined("Form.fSNcodigo") and len(trim(form.fSNcodigo)) >
							<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#">
						</cfif>

						<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
							<cfset navegacion = navegacion & "&fEOfecha=#form.fEOfecha#">
						</cfif>
<!--- *1* --->	
						<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.EOidorden, a.Ecodigo, a.EOnumero, a.CMTOcodigo, 
								   a.SNcodigo, a.Mcodigo, a.EOfecha, a.Observaciones, 
								   c.CMTOcodigo#_Cat#'-'#_Cat#c.CMTOdescripcion as CMTOdescripcion, 
								   b.SNnumero, SNnombre
								   , '1' as tipoImpresion 
							from EOrdenCM a
							
							inner join SNegocios b
								on a.SNcodigo=b.SNcodigo
								   and a.Ecodigo=b.Ecodigo
							
							inner join CMTipoOrden c 			
								on c.Ecodigo = a.Ecodigo 
								and c.CMTOcodigo = a.CMTOcodigo

							where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1))>
									and a.CMCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
								</cfif>
								and a.EOestado = 10
								and (a.EOImpresion in ('I','R') or a.EOImpresion is null)
							  
							<!-----
							<cfif isdefined("form.fCMTOcodigo") and len(trim(form.fCMTOcodigo)) >
								and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fCMTOcodigo#">
							</cfif>
							---->								
							
							<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
								and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
							</cfif>

							<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
								and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
							</cfif>
			
							<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
								and upper(Observaciones) like  upper('%#form.fObservaciones#%')
							</cfif>
			
							<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) >
								and a.SNcodigo = #Form.SNcodigo#
							</cfif>
			
							<cfif isdefined("Form.fEOfecha") and len(trim(Form.fEOfecha)) >
								and EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEOfecha)#">
							</cfif>
							order by CMTOdescripcion, EOnumero
						</cfquery>
						
						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="cortes" value="CMTOdescripcion"/>
							<cfinvokeargument name="desplegar" value="EOnumero, Observaciones, SNnumero, SNnombre, EOfecha"/>
							<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Número Proveedor, Nombre Proveedor, Fecha"/>
							<cfinvokeargument name="formatos" value="V, V, V, V, D"/>
							<cfinvokeargument name="align" value="left, left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="ordenReimprimir-sql.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="EOidorden"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="maxRows" value="15"/>
							<cfinvokeargument name="form_method" value="GET"/>
						</cfinvoke>
					<cfelse>
						<!---
						<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
							<tr><td></td></tr>
						</table>
						--->
					</cfif>
				</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>