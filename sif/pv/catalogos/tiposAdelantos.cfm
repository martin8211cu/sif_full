<cf_templateheader title="Punto de Venta - Tipos de Adelantos">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Tipos de Adelantos">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfif isdefined('url.Descripcion_F') and not isdefined('form.Descripcion_F')>
					<cfparam name="form.Descripcion_F" default="#url.Descripcion_F#">
				</cfif>

				<cfinclude template="tiposAdelantos-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.Descripcion_F") and Len(Trim(Form.Descripcion_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_F=" & Form.Descripcion_F>
				</cfif>
		
				<cfquery name="lista" datasource="#session.DSN#">
					select IdTipoAd, CodInterno, Descripcion
					<cfif isdefined("Form.Descripcion_F") and Len(Trim(Form.Descripcion_F)) NEQ 0>
						, '#Descripcion_F#' as Descripcion_F
					</cfif>		
							
					from FATiposAdelanto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.Descripcion_F') and form.Descripcion_F NEQ ''>
						and upper(Descripcion) like upper('%#form.Descripcion_F#%')
					</cfif>	
					 
					order by CodInterno, Descripcion
				</cfquery>
					
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="CodInterno, Descripcion"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="tiposAdelantos.cfm"/>
					<cfinvokeargument name="keys" value="IdTipoAd"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="tiposAdelantos-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>