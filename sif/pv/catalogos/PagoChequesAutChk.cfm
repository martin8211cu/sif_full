<cf_templateheader title="Punto de Venta - Autorización de cheques por Cliente">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Autorización de cheques por Cliente">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfif isdefined('url.CDCcodigo_F') and not isdefined('form.CDCcodigo_F')>
						<cfparam name="form.CDCcodigo_F" default="#url.CDCcodigo_F#">
					</cfif>
				
					<cfinclude template="PagosChequesAutChek-filtro.cfm">
	
					<cfset navegacion = "">
					
					<cfif isdefined("Form.CDCcodigo_F") and Len(Trim(Form.CDCcodigo_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCcodigo_F=" & Form.CDCcodigo_F>
					</cfif>	
					
					
					<cfquery name="lista" datasource="#session.DSN#">
						select A.CDCcodigo, A.FAM15AUT, A.FAM15MAX, B.CDCnombre, B.CDCidentificacion
						
						<cfif isdefined("Form.CDCcodigo_F") and Len(Trim(Form.CDCcodigo_F)) NEQ 0>
							, '#CDCcodigo_F#' as CDCcodigo_F
						</cfif>	
						
						from FAM015 A, ClientesDetallistasCorp B
						where A.CDCcodigo = B.CDCcodigo
						  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  
						  <cfif isdefined('form.CDCcodigo_F') and form.CDCcodigo_F NEQ ''>
						  and A.CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo_F#">
						  </cfif>
						
						order by A.CDCcodigo
					</cfquery>
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" CDCidentificacion, CDCnombre, FAM15AUT, FAM15MAX "/>
							<cfinvokeargument name="etiquetas" value=" Identificaci&oacute;n, Cliente, Autorizado, Monto Maximo"/>
							<cfinvokeargument name="formatos" value="V, V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="PagoChequesAutChk.cfm"/>
							<cfinvokeargument name="keys" value="CDCcodigo"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="PagoChequesAutChk-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
