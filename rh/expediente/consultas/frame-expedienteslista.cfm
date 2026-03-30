
<cfinclude template="consultas-frame-header.cfm">
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

<cf_web_portlet_start titulo="#titulo#">

	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr valign="top">
		<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
	  </tr>
	  <tr valign="top"> 
		<td>&nbsp;</td>
	  </tr>
	  <tr valign="top"> 
		<td align="center">
			<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td>
					<cfinclude template="frame-infoEmpleado.cfm">
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr valign="top"> 
		<td>
			<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin:0;">
			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
				<input type="hidden" name="DEid" value="#Form.DEid#">
			</cfif>
			<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
				<input type="hidden" name="TEid" value="#Form.TEid#">
			</cfif>
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
			
			<!--- Consulta del Historial de Expedientes para el Tipo de Expediente seleccionado --->
			<cfelseif isdefined("Form.btnHistorial") and Len(Trim(Form.btnHistorial)) and isdefined("Form.TEid") and Len(Trim(Form.TEid))>
				<cfif not (isdefined("rsPermisos") and rsPermisos.recordCount)>
					<cfthrow detail="#MSG_UstedNoTieneAccesoAEsteExpediente#">
					<cfabort>
				</cfif>
				<cfinclude template="frame-expedientehistorial.cfm">
			
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
					  	<cf_translate key="LB_SeleccioneUnTipoDeExpediente">Seleccione un Tipo de Expediente</cf_translate></td>
					</tr>
					<tr> 
					  <td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
						<!--- Chequear los permisos a los cuales tengo permiso a acceder para el empleado seleccionado --->
						<!--- Autogestion --->
						<cfif Session.Params.ModoDespliegue EQ 0>
							<cfquery name="rsListaTExpedientes" datasource="#Session.DSN#">
								select a.TEid, 
									   {fn concat(rtrim(a.TEcodigo),{fn concat(' - ',a.TEdescripcion)})} as descripcion
								from TipoExpediente a
								where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
							</cfquery>
						<!--- Modo Administrador --->
						<cfelseif Session.Params.ModoDespliegue EQ 1>
							<cfquery name="rsListaTExpedientes" datasource="#Session.DSN#">
								select a.TEid, 
									   {fn concat(rtrim(a.TEcodigo),{fn concat(' - ',a.TEdescripcion)})} as descripcion
								from TipoExpediente a
								
								inner join UsuariosTipoExpediente b
								   on a.TEid = b.TEid
								  and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
								
								where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
							</cfquery>
						</cfif>
						<!--- Variable de traduccion --->
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_NoExitenTiposDeExpedienteDisponiblesParaElUsuarioActual"
							Default="No exiten tipos de expediente disponibles para el usuario actual"
							returnvariable="MSG_NoExitenTiposDeExpedienteDisponiblesParaElUsuarioActual"/>

						<cfinvoke
						 component="rh.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsListaTExpedientes#"/>
							<cfinvokeargument name="desplegar" value="descripcion"/>
							<cfinvokeargument name="etiquetas" value=" "/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="keys" value="TEid"/>
							<cfinvokeargument name="MaxRows" value="0"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="botones" value="Regresar"/>
							<cfinvokeargument name="EmptyListMsg" value="--- #MSG_NoExitenTiposDeExpedienteDisponiblesParaElUsuarioActual# ---"/>
						</cfinvoke>
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
