<cf_templateheader title="Punto de Venta - Autorización de Cheques por Cliente Cuenta">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Autorización de Cheques por Cliente Cuenta">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					
					<cfif isdefined('url.FAM16NUM_F') and not isdefined('form.FAM16NUM_F')>
						<cfparam name="form.FAM16NUM_F" default="#url.FAM16NUM_F#">
					</cfif>
					
					<cfif isdefined('url.CDCcodigo_F') and not isdefined('form.CDCcodigo_F')>
						<cfparam name="form.CDCcodigo_F" default="#url.CDCcodigo_F#">
					</cfif>
															
					<cfinclude template="PagosCheques-filtro.cfm">
	
					<cfset navegacion = "">
					
					
					<cfif isdefined("Form.FAM16NUM_F") and Len(Trim(Form.FAM16NUM_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM16NUM_F=" & Form.FAM16NUM_F>
					</cfif>	
					
					<cfif isdefined("Form.CDCcodigo_F") and Len(Trim(Form.CDCcodigo_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCcodigo_F=" & Form.CDCcodigo_F>
					</cfif>	
				
								
					<cfquery name="lista" datasource="#session.DSN#">
						select A.Bid, A.FAM16NUM, A.CDCcodigo, CDCnombre, CDCidentificacion, Bdescripcion
						
						<cfif isdefined("Form.CDCcodigo_F") and Len(Trim(Form.CDCcodigo_F)) NEQ 0>
							, '#CDCcodigo_F#' as CDCcodigo_F
						</cfif>	
						
						<cfif isdefined("Form.FAM16NUM_F") and Len(Trim(Form.FAM16NUM_F)) NEQ 0>
							, '#FAM16NUM_F#' as FAM16NUM_F
						</cfif>	
						
						
						from FAM017 A, ClientesDetallistasCorp B, Bancos C
						where A.CDCcodigo = B.CDCcodigo
						  and A.Bid = C.Bid
						  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						
						  <cfif isdefined('form.CDCcodigo_F') and form.CDCcodigo_F NEQ ''>
						  	and A.CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo_F#">
						  </cfif>
						  
						  <cfif isdefined('form.FAM16NUM_F') and form.FAM16NUM_F NEQ ''>
						  	and A.FAM16NUM =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM16NUM_F#">
						  </cfif>
						
						
						order by FAM16NUM
					</cfquery>
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" FAM16NUM, CDCidentificacion, CDCnombre, Bdescripcion "/>
							<cfinvokeargument name="etiquetas" value=" Cuenta, Identificaci&oacute;n, Cliente, Banco"/>
							<cfinvokeargument name="formatos" value="V, V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="PagoCheques.cfm"/>
							<cfinvokeargument name="keys" value="FAM16NUM, Bid"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="PagoCheques-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
