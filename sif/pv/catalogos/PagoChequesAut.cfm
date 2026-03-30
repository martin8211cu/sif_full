<cf_templateheader title="Punto de Venta - Autorización de Cheques por Cuenta">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Autorización de Cheques por Cuenta">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfif isdefined('url.FAM16NUM_F') and not isdefined('form.FAM16NUM_F')>
						<cfparam name="form.FAM16NUM_F" default="#url.FAM16NUM_F#">
					</cfif>
					
					<cfinclude template="PagosChequesAut-filtro.cfm">
	
					<cfset navegacion = "">
					
					<cfif isdefined("Form.FAM16NUM_F") and Len(Trim(Form.FAM16NUM_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM16NUM_F=" & Form.FAM16NUM_F>
					</cfif>	
				
				
					<cfquery name="lista" datasource="#session.DSN#">
						select A.FAM16NUM, A.Bid, A.FAM16AUT, A.FAM16MAX, B.Bdescripcion
						
						<cfif isdefined("Form.FAM16NUM_F") and Len(Trim(Form.FAM16NUM_F)) NEQ 0>
							, '#FAM16NUM_F#' as FAM16NUM_F
						</cfif>	
						
						
						from FAM016 A, Bancos B
						where A.Bid = B.Bid
						  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						
						  <cfif isdefined('form.FAM16NUM_F') and form.FAM16NUM_F NEQ ''>
						  	and A.FAM16NUM =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM16NUM_F#">
						  </cfif>
						
						
						order by A.FAM16NUM
					</cfquery>
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" FAM16NUM, FAM16AUT, FAM16MAX, Bdescripcion  "/>
							<cfinvokeargument name="etiquetas" value=" Cuenta, Autorizada, Monto Maximo, Banco"/>
							<cfinvokeargument name="formatos" value="V, V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="PagoChequesAut.cfm"/>
							<cfinvokeargument name="keys" value="FAM16NUM, Bid"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="PagoChequesAut-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
