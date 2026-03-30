<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de Setiembre del 2005
	Motivo: Se acomodo los campos para que se mostraran bien los datos
 --->

<cf_templateheader title="Punto de Venta - Clientes Detallistas Corporativos">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Clientes Detallistas Corporativos">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="35%" valign="top">
				<cfif isdefined('url.CDCidentificacion_F') and not isdefined('form.CDCidentificacion_F')>
					<cfparam name="form.CDCidentificacion_F" default="#url.CDCidentificacion_F#">
				</cfif>
				<cfif isdefined('url.CDCnombre_F') and not isdefined('form.CDCnombre_F')>
					<cfparam name="form.CDCnombre_F" default="#url.CDCnombre_F#">
				</cfif>

				<cfinclude template="clientes-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.CDCidentificacion_F") and Len(Trim(Form.CDCidentificacion_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCidentificacion_F=" & Form.CDCidentificacion_F>
				</cfif>				
				<cfif isdefined("Form.CDCnombre_F") and Len(Trim(Form.CDCnombre_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCnombre_F=" & Form.CDCnombre_F>
				</cfif>					
				
                <cfset LvarMaxRows = 300>
                <cfset LvarTop = ''>
                <cfset dbtype = Application.dsinfo[session.dsn].type>
                <cfif dbtype eq 'sybase'>
                	<cfset LvarTop = 'top #LvarMaxRows#'>
                </cfif>
                
				<cfquery name="lista" datasource="#session.DSN#" maxrows="#LvarMaxRows#">
					select #LvarTop#  CDCcodigo, CDCidentificacion, CDCnombre
					<cfif isdefined("Form.CDCidentificacion_F") and Len(Trim(Form.CDCidentificacion_F)) NEQ 0>
						, '#CDCidentificacion_F#' as CDCidentificacion_F
					</cfif>	
					<cfif isdefined("Form.CDCnombre_F") and Len(Trim(Form.CDCnombre_F)) NEQ 0>
						, '#CDCnombre_F#' as CDCnombre_F
					</cfif>											
					
					from ClientesDetallistasCorp 
					
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					<cfif isdefined('form.CDCidentificacion_F') and form.CDCidentificacion_F NEQ ''>
						and CDCidentificacion like '%#form.CDCidentificacion_F#%'
					</cfif>
					<cfif isdefined('form.CDCnombre_F') and form.CDCnombre_F NEQ ''>
						and upper(CDCnombre) like upper('%#form.CDCnombre_F#%')
					</cfif>	
									
					order by CDCcodigo, CDCidentificacion, CDCnombre
				</cfquery>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#lista#"/>
					<cfinvokeargument name="etiquetas" 			value="Identificaci&oacute;n, Nombre"/>
					<cfinvokeargument name="desplegar" 			value="CDCidentificacion, CDCnombre"/>
					<cfinvokeargument name="formatos" 			value="V, V"/>
					<cfinvokeargument name="align" 				value="left, left"/>
					<cfinvokeargument name="ajustar" 			value="N"/>
					<cfinvokeargument name="irA" 				value="clientes.cfm"/>
					<cfinvokeargument name="keys" 				value="CDCcodigo"/>
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					<cfinvokeargument name="showemptylistmsg" 	value="true"/>
				</cfinvoke>
			</td>
			<td width="65%" valign="top"><cfinclude template="clientes-form.cfm"></td>
		</tr>
	</table>
 <cf_web_portlet_end>
<cf_templatefooter>

