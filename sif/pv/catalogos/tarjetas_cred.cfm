<cf_templateheader title="Punto de Venta - Clientes de Crédito">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Tarjetas de Créditos">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfif isdefined('url.FATcodigo_F') and not isdefined('form.FATcodigo_F')>
						<cfparam name="form.FATcodigo_F" default="#url.FATcodigo_F#">
					</cfif>
					<cfif isdefined('url.FATdescripcion_F') and not isdefined('form.FATdescripcion_F')>
						<cfparam name="form.FATdescripcion_F" default="#url.FATdescripcion_F#">
					</cfif>
	
					<cfinclude template="tarjetas_cred-filtro.cfm">
	
					<cfset navegacion = "">
					
					<cfif isdefined("Form.FATcodigo_F") and Len(Trim(Form.FATcodigo_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FATcodigo_F=" & Form.FATcodigo_F>
					</cfif>				
					<cfif isdefined("Form.FATdescripcion_F") and Len(Trim(Form.FATdescripcion_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FATdescripcion_F=" & Form.FATdescripcion_F>
					</cfif>
				
					<cfquery name="lista" datasource="#session.DSN#">
						Select FATid,a.SNcodigo, a.FATcodigo, a.FATtipo, a.FATtiptarjeta, a.FATdescripcion, a.FATporccom, a.CFcuentaComision,  b.SNnombre 
						<cfif isdefined("Form.FATcodigo_F") and Len(Trim(Form.FATcodigo_F)) NEQ 0>
							, '#FATcodigo_F#' as FATcodigo_F
						</cfif>	
						<cfif isdefined("Form.FATdescripcion_F") and Len(Trim(Form.FATdescripcion_F)) NEQ 0>
							, '#FATdescripcion_F#' as FATdescripcion_F
						</cfif>	
									
						from FATarjetas a
						
						left outer join SNegocios b
						on b.SNcodigo=a.SNcodigo
						and b.Ecodigo=a.Ecodigo
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined('form.FATcodigo_F') and form.FATcodigo_F NEQ ''>
							and upper(FATcodigo) like upper('%#form.FATcodigo_F#%')
						 </cfif>
						<cfif isdefined('form.FATdescripcion_F') and form.FATdescripcion_F NEQ ''>
							and upper(FATdescripcion) like upper('%#form.FATdescripcion_F#%')
						</cfif>	
						order by a.SNcodigo 
					</cfquery>
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
						 <cfinvokeargument name="query" value="#lista#"/>
						 <cfinvokeargument name="etiquetas" value="C&oacute;digo, Tarjeta, Tipo, Clasificaci&oacute;n"/>
    					 <cfinvokeargument name="desplegar" value="FATcodigo, FATdescripcion, FATtipo, FATtiptarjeta "/>
						 <cfinvokeargument name="formatos" value="V, V, V, V"/>
						 <cfinvokeargument name="align" value="left, left, left, left"/>
						 <cfinvokeargument name="ajustar" value="N"/>
						 <cfinvokeargument name="irA" value="tarjetas_cred.cfm"/>
						 <cfinvokeargument name="keys" value="FATid"/>
						 <cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="tarjetas_cred-form.cfm"></td>
			</tr>		
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>