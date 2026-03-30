<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Ajuste de Cr&eacute;dito" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="T&iacute;tulo" returnvariable="LB_Titulo"/>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		
		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset val = objParams.getParametroInfo('30200711')>
		<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
		<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
		
		<cfquery name="checkRol" datasource="#session.dsn#">
			select * from UsuarioRol where 
						Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
					and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
		</cfquery>

		<cfif checkRol.recordCount neq 0>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="/home/menu/pNavegacion.cfm">
					</td>
				</tr>
				<tr>
					<td>
						<!--- <cfdump var="#form#"> ---> 
						<cfif isdefined('form.id_aj') or (isdefined('form.modo') and form.modo eq 'alta')>
							<cfinclude template="AplicarAjuste_form.cfm">
						<cfelse>
							<cfinclude template="AplicarAjuste_lista.cfm">
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		<cfelse>
			<cfthrow message="No cuentas con los permisos para realizar esta operacion">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
