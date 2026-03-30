<cf_templateheader title="Punto de Venta - M&aacute;quinas">
<cf_templatecss>
	
<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Máquinas">
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfif isdefined('url.FAM09MAQ_F') and not isdefined('form.FAM09MAQ_F')>
					<cfparam name="form.FAM09MAQ_F" default="#url.FAM09MAQ_F#">
				</cfif>
				<cfif isdefined('url.FAM09DES_F') and not isdefined('form.FAM09DES')>
					<cfparam name="form.FAM09DES_F" default="#url.FAM09DES_F#">
				</cfif>

				<cfinclude template="maquinas-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.FAM09MAQ_F") and Len(Trim(Form.FAM09MAQ_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM09MAQ_F=" & Form.FAM09MAQ_F>
				</cfif>				
				<cfif isdefined("Form.FAM09DES_F") and Len(Trim(Form.FAM09DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM09DES_F=" & Form.FAM09DES_F>
				</cfif>	
			
				
			
				<cfquery name="lista" datasource="#session.DSN#">
					select FAM09MAQ, FAM09DES
					<cfif isdefined("Form.FAM09MAQ_F") and Len(Trim(Form.FAM09MAQ_F)) NEQ 0>
						, '#FAM09MAQ_F#' as FAM09MAQ_F
					</cfif>	
					<cfif isdefined("Form.FAM09DES_F") and Len(Trim(Form.FAM09DES_F)) NEQ 0>
						, '#FAM09DES_F#' as FAM09DES_F
					</cfif>	
					
					from FAM009
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.FAM09MAQ_F') and form.FAM09MAQ_F NEQ ''>
						and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_integer" value ="#form.FAM09MAQ_F#">
					</cfif>
					<cfif isdefined('form.FAM09DES_F') and form.FAM09DES_F NEQ ''>
						and upper(FAM09DES) like upper('%#form.FAM09DES_F#%')
					</cfif>	
					
					order by FAM09MAQ, FAM09DES
				</cfquery>
					
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="FAM09MAQ, FAM09DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left ,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="maquinas.cfm"/>
					<cfinvokeargument name="keys" value="FAM09MAQ"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
			</td>
			<td width="50%" valign="top"><cfinclude template="maquinas-form.cfm"></td>
		</tr>		
	</table>
<cf_web_portlet_end>
<cf_templatefooter>
