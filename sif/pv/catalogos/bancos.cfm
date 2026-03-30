<cf_templateheader title="Punto de Venta - Bancos de Cartas Promesa">
<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Bancos de Cartas Promesa">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
			<td width="30%" valign="top">
				<cfif isdefined('url.Bid_F') and not isdefined('form.Bid_F')>
					<cfparam name="form.Bid_F" default="#url.Bid_F#">
				</cfif>
				<cfif isdefined('url.FAM18DES_F') and not isdefined('form.FAM18DES_F')>
					<cfparam name="form.FAM18DES_F" default="#url.FAM18DES_F#">
				</cfif>

				<cfinclude template="bancos-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.Bid_F") and Len(Trim(Form.Bid_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Bid_F=" & Form.Bid_F>
				</cfif>				
				<cfif isdefined("Form.FAM18DES_F") and Len(Trim(Form.FAM18DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM18DES_F=" & Form.FAM18DES_F>
				</cfif>
				
				<cfquery name="lista" datasource="#session.DSN#">
					select A.Bid, B.Bdescripcion ,C.SNnombre, A.FAM18DES
					<cfif isdefined("Form.Bid_F") and Len(Trim(Form.Bid_F)) NEQ 0>
						, '#Bid_F#' as Bid_F
					</cfif>	
					<cfif isdefined("Form.FAM18DES_F") and Len(Trim(Form.FAM18DES_F)) NEQ 0>
						, '#FAM18DES_F#' as FAM18DES_F
					</cfif>							
					
					from FAM018 A, Bancos B, SNegocios C
					
					where A.Bid = B.Bid
					and A.Ecodigo = B.Ecodigo
					and A.SNcodigo = C.SNcodigo
					and A.Ecodigo  = C.Ecodigo
					and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.Bid_F') and form.Bid_F NEQ ''>
						and A.Bid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid_F#">
					</cfif>
					<cfif isdefined('form.FAM18DES_F') and form.FAM18DES_F NEQ ''>
						and upper(FAM18DES) like upper('%#form.FAM18DES_F#%')
					</cfif>				
					order by Bid
				</cfquery>
				<cfinvoke 
					component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="desplegar" value=" Bdescripcion, FAM18DES"/>
					<cfinvokeargument name="etiquetas" value=" Banco, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="bancos.cfm"/>
					<cfinvokeargument name="keys" value="Bid"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			</td>
			<td width="70%" valign="top"><cfinclude template="bancos-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
