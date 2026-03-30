<!--- Registro de Documentos de Responsabilidad --->
<!--- Este archivo debe ser identico a documento.cfm, solo que define la variable Lvar_Autogestion = true --->
<cfset Lvar_Autogestion = true>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Autogestion"
			Default="Autogesti&oacute;n"
			returnvariable="LB_Autogestion"/>
			 
	<cf_templateheader title="#nav__SPdescripcion# (#LB_Autogestion#)">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput> (#LB_Autogestion#)">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfif isdefined("url.CRDRid") and len(trim(url.CRDRid))>
				<cfset Form.CRDRid = url.CRDRid>
			</cfif>
			<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
				<cfset Form.btnNuevo = url.btnNuevo>
			</cfif>
			<cfif isdefined("Session.DEid") and len(trim(Session.DEid))>
				<cfset form.DEid = Session.DEid>
			<cfelse>
				<cfquery name="rsgetdeid" datasource="#session.dsn#">
					select DEid 
					from DatosEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and DEusuarioportal  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				</cfquery>
				<cfif rsgetdeid.recordcount neq 1>
					<cfquery name="rsgetdeid" datasource="asp">
						select llave as DEid 
						from UsuarioReferencia
						where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
							and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
					</cfquery>
				</cfif>
				<cfif rsgetdeid.recordcount eq 1 and len(trim(rsgetdeid.DEid)) gt 0>
					<cfset form.DEid = rsgetdeid.DEid>
				<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario"
						Default="Error  40001. No se pudo obtener el Empleado Asociado a su Usuario"
						returnvariable="MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario"/>
					<cf_errorCode	code = "50128"
									msg  = "documnento-auto.cfm. @errorDat_1@."
									errorDat_1="#MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario#"
					>
				</cfif>
			</cfif>
			<!--- A partir de este punto el empleado es requerido --->
			<cfparam name="form.DEid">
			<cfquery name="rsEmpleado" datasource="#session.dsn#">
				select a.DEid, rhp.CFid
				from DatosEmpleado a
					inner join LineaTiempo lt
							inner join RHPlazas rhp
								on rhp.RHPid = lt.RHPid
						on lt.DEid = a.DEid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						between lt.LTdesde and lt.LThasta
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
			</cfquery>
			<cfif rsEmpleado.recordcount neq 1>
				<cfquery name="rsEmpleado" datasource="#session.dsn#">
					select DEid, CFid
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						between ECFdesde and ECFhasta
				</cfquery>
			</cfif>
			<cfif rsEmpleado.recordcount neq 1>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario"
					Default="Error  40002. No se pudo obtener la información del Empleado Asociado a su Usuario"
					returnvariable="MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario"/>

				<cf_errorCode	code = "50129"
								msg  = "documnento-auto.cfm @errorDat_1@."
								errorDat_1="#MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario#"
				>
			</cfif>
			<cfquery datasource="#session.dsn#" name="RSCentros">
				select a.CRCCid, a.CRCCcodigo, a.CRCCdescripcion
				from  CRCentroCustodia a
					  inner join CRCCCFuncionales b
						on a.CRCCid  = b.CRCCid 
						and  b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.CFid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by a.CRCCcodigo
			</cfquery>
			<cfinclude template="/sif/portlets/pEmpleado.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="right" width="100%"><a href="##" onclick="javascript:location.href='documento-auto-lista.cfm';"><cf_translate key="LB_VerListaDeDocumentosRegistrados">Ver lista de documentos registrados</cf_translate>&nbsp;</a></td>
				<td align="right" width="0%"><a href="##" onclick="javascript:location.href='documento-auto-lista.cfm';"><img src="/cfmx/sif/imagenes/Base.gif" border="0" width="16" height="16" /></a></td>
			  </tr>
			</table>
			<cfinclude template="documento-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>

