<cf_templateheader title="Punto de Venta - Tipos de Bonos">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Tipos de Bonos">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="60%" valign="top">
				<!---  --->
				<cfif isdefined('url.Codigo_F') and not isdefined('form.Codigo_F')>
					<cfparam name="form.Codigo_F" default="#url.Codigo_F#">
				</cfif>
				<cfif isdefined('url.Descripcion_F') and not isdefined('form.Descripcion_F')>
					<cfparam name="form.Descripcion_F" default="#url.Descripcion_F#">
				</cfif>
				<cfif isdefined('url.Fecha_F') and not isdefined('form.Fecha_F')>
					<cfparam name="form.Fecha_F" default="#url.Fecha_F#">
				</cfif>
				<!---  --->
				
				<cfinclude template="tiposBonos-filtro.cfm">

				<!---  NAVEGACION--->
				<cfset navegacion = "">
				
				<cfif isdefined("Form.Codigo_F") and Len(Trim(Form.Codigo_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_F=" & Form.Codigo_F>
				</cfif>
				
				<cfif isdefined("Form.Descripcion_F") and Len(Trim(Form.Descripcion_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_F=" & Form.Descripcion_F>
				</cfif>
				
				<cfif isdefined("Form.Fecha_F") and Len(Trim(Form.Fecha_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fecha_F=" & Form.Fecha_F>
				</cfif>
				<!---  --->
				<cfquery name="lista" datasource="#session.DSN#">
					select IdTipoBn, BNCodigo, BNDescripcion, BNFecha_Vence
					from FATiposBono
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					
					<!--- filtro por codigo --->
					<cfif isdefined('form.Codigo_F') and form.Codigo_F NEQ ''>
						and ltrim(rtrim(upper(BNCodigo))) like '%#trim(ucase(form.Codigo_F))#%'
					</cfif>	
					
					<!--- filtro por Descripcion --->
					<cfif isdefined('form.Descripcion_F') and form.Descripcion_F NEQ ''>
						and ltrim(rtrim(upper(BNDescripcion))) like '%#trim(ucase(form.Descripcion_F))#%'
					</cfif>
					
					<!--- filtro por Fecha Vence --->
					<cfif isdefined('form.Fecha_F') and form.Fecha_F NEQ ''>
						and BNFecha_Vence = <cfqueryparam value="#LSParseDateTime(form.Fecha_F)#" cfsqltype="cf_sql_timestamp">
					</cfif>
					order by BNCodigo, BNDescripcion, BNFecha_Vence
				</cfquery>
					
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="BNCodigo, BNDescripcion,BNFecha_Vence"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n, Fecha de Vencimiento"/>
					<cfinvokeargument name="formatos" value="V, V, D"/>
					<cfinvokeargument name="align" value="left, left, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="tiposBonos.cfm"/>
					<cfinvokeargument name="keys" value="IdTipoBn"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxrows" value="17"/>
				</cfinvoke>
				</td>
				<td width="40%" valign="top"><cfinclude template="tiposBonos-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>