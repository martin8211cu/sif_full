<cfif isdefined("url.btnFiltro")>
	<cfset form.btnFiltro = "filtrar">
</cfif>

<cf_templateheader title="Reimpresi&oacute;n de Contratos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresi&oacute;n de contratos'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="contratoReimprimir-filtro.cfm">
					<cfset navegacion = "&btnFiltro=filtrar">

					<cfif isdefined("form.btnFiltro")>
						<cfif isdefined("form.CTCid1") and len(trim(form.CTCid1)) >
							<cfset navegacion = navegacion & "&CTCid1=#form.CTCid1#">
						<cfelse>
							<cfset navegacion = navegacion & "&CTCid1=#session.compras.comprador#">
						</cfif>
			
						<cfif isdefined("form.CTCcodigo") and len(trim(form.CTCcodigo)) >
							<cfset navegacion = navegacion & "&CTCcodigo=#form.CTCcodigo#">
						</cfif>
						<cfif isdefined("form.CTCdescripcion") and len(trim(form.CTCdescripcion)) >
							<cfset navegacion = navegacion & "&CTCdescripcion=#form.CTCdescripcion#">
						</cfif>
						
						<cfif isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato)) >
							<cfset navegacion = navegacion & "&fCTCnumContrato=#form.fCTCnumContrato#">
						</cfif>

						<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion)) >
							<cfset navegacion = navegacion & "&fDescripcion=#form.fDescripcion#">
						</cfif>

						<cfif isdefined("Form.fSNcodigo") and len(trim(form.fSNcodigo)) >
							<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#">
						</cfif>

						<cfif isdefined("Form.fCTfecha") and len(trim(form.fCTfecha))>
							<cfset navegacion = navegacion & "&fCTfecha=#form.fCTfecha#">
						</cfif>

						<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.CTContid, a.Ecodigo, a.CTCnumContrato, a.CTTCid, 
								   a.SNid, a.CTMcodigo, a.CTfecha, a.CTCdescripcion, 
								   c.CTTCcodigo#_Cat#'-'#_Cat#c.CTTCdescripcion as CTCdescripcion, 
								   b.SNnumero, SNnombre
								   , '1' as tipoImpresion 
							from CTContrato a
							
							inner join SNegocios b
								on a.SNid=b.SNid
								   and a.Ecodigo=b.Ecodigo
							
							inner join CTTipoContrato c 			
								on c.Ecodigo = a.Ecodigo 
								and c.CTTCid = a.CTTCid
                               
                            inner join CTCompradores d
                            	on a.CTCid = d.CTCid
							where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.CTCestatus = 1
							  
							<cfif isdefined("form.fCTCcodigo") and len(trim(form.fCTCcodigo)) >
								and c.CTTCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CTCcodigo#">
							</cfif>							
							
							<cfif isdefined("form.CTCcodigo1") and len(trim(form.CTCcodigo1)) >
								and d.CTCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CTCcodigo1#">
							</cfif>

							<cfif isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato)) >
								and upper(a.CTCnumContrato) like  upper('%#form.fCTCnumContrato#%')
							</cfif>
                            
							<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion)) >
								and upper(a.CTCdescripcion) like  upper('%#form.fDescripcion#%')
							</cfif>
			
							<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) >
								and a.SNid = #Form.SNcodigo#
							</cfif>
			
							<cfif isdefined("Form.fCTfecha") and len(trim(Form.fCTfecha)) >
								and CTfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fCTfecha)#">
							</cfif>
							order by a.CTCdescripcion, CTCnumContrato
						</cfquery>
						
						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CTCnumContrato, CTCdescripcion, SNnumero, SNnombre, CTfecha"/>
							<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Número Proveedor, Nombre Proveedor, Fecha"/>
							<cfinvokeargument name="formatos" value="V, V, V, V, D"/>
							<cfinvokeargument name="align" value="left, left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="contratoReimprimir-sql.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CTContid"/>
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