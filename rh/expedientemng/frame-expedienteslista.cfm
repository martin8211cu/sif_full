<!--- Tipo de Expediente --->
<cfquery name="rs_parametro_920" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 920
</cfquery>
<cfif len(trim(rs_parametro_920.Pvalor))>
	<cfparam name="form.TEid" default="#rs_parametro_920.Pvalor#">
</cfif>

<cfif isdefined("Form.btnHistorial") and Len(Trim(Form.btnHistorial)) and isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<!--- Variable de traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_HistorialDeExpedientes"
		Default="Historial de Expedientes"
		returnvariable="LB_HistorialDeExpedientes"/>
	<cfset titulo = LB_HistorialDeExpedientes>

<cfelseif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<!--- Variable de traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ExpedienteVigente"
		Default="Expediente Vigente"
		returnvariable="LB_ExpedienteVigente"/>

	<cfset titulo = LB_ExpedienteVigente>

<cfelse>
	<!--- Variable de traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeTiposDeExpediente"
		Default="Lista de Tipos de Expediente"
		returnvariable="LB_ListaDeTiposDeExpediente"/>
	<cfset titulo = LB_ListaDeTiposDeExpediente>

</cfif>

<!--- *** Revisar esto si es de autogestion o no *** --->
<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<!--- Modo Autogestion --->
	<cfif Session.Params.ModoDespliegue EQ 0>
		<!--- Solo se tiene permisos si corresponde al usuario autenticado en el portal --->
		<cfif rsEmpleado.Usucodigo EQ Session.Usucodigo>
			<cfquery name="rsPermisos" datasource="#Session.DSN#">
				select 1
				from TipoExpediente a
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			</cfquery>
		</cfif>
	<!--- Modo Administrador --->
	<cfelseif Session.Params.ModoDespliegue EQ 1>
		<cfquery name="rsPermisos" datasource="#Session.DSN#">
			select 1
			from UsuariosTipoExpediente a
			where a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		</cfquery>
	</cfif>
</cfif>

<cfinclude template="../expediente/consultas/consultas-frame-header.cfm">
<cfset Lvar_IncluyeFechaNac = true>
<cf_web_portlet_start titulo="#titulo#">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr valign="top">
			<td>
				<!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
			</td>
		</tr>
	  	<tr valign="top"><td>&nbsp;</td></tr>

		<tr valign="top"> 
			<td align="center">
				<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  		<tr><td><cfinclude template="../expediente/consultas/frame-infoEmpleado.cfm"></td></tr>
				</table>
			</td>
	  	</tr>
	  
	  	<tr valign="top"> 
			<td>
				<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin:0;">
					<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))><input type="hidden" name="DEid" value="#Form.DEid#"></cfif>
					<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))><input type="hidden" name="TEid" value="#Form.TEid#"></cfif>

					<!--- Variable de traduccion --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_UstedNoTieneAccesoAEsteExpediente"
						Default="Usted no tiene acceso a este expediente"
						returnvariable="MSG_UstedNoTieneAccesoAEsteExpediente"/>

					<!--- Consulta del Expediente seleccionado --->
					<cfif isdefined("Form.btnHistorial") and Len(Trim(Form.btnHistorial)) and isdefined("Form.TEid") and Len(Trim(Form.TEid)) and isdefined("Form.IEid") and Len(Trim(Form.IEid))>
						<cfif not (isdefined("rsPermisos") and rsPermisos.recordCount)>
							<cfthrow detail="#MSG_UstedNoTieneAccesoAEsteExpediente#">
							<cfabort>
						</cfif>
						<cfinclude template="frame-expedienteincidencia.cfm">
					
					<!--- Consulta del Expediente Actual --->
					<cfelseif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
						<cfif not (isdefined("rsPermisos") and rsPermisos.recordCount)>
							<cfthrow detail="#MSG_UstedNoTieneAccesoAEsteExpediente#">
							<cfabort>
						</cfif>
						<cfinclude template="frame-expedientevigente.cfm">
					
					<!--- Lista de Tipos de Expedientes --->
					<cfelse>
						<table width="98%" cellpadding="3" cellspacing="0" align="center">
							<tr> 
								<td class="#Session.preferences.Skin#_thcenter">
									<cf_translate key="LB_SeleccioneUnTipoDeExpediente">Seleccione un Tipo de Expediente</cf_translate>
								</td>
							</tr>
						</table>
					</cfif>
				</form>
			</td>
	  	</tr>
	</table>
	</cfoutput>
<cf_web_portlet_end>