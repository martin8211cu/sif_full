<!--- Aprobacion de Transferencias de Documentos de Responsabilidad de Responsable 1 a Responsable 2 --->
<!--- Este proceso es exclusivo de autogestión y permite a un JEFE DE UN CENTRO FUNCIONAL Aprobar o Rechazar 
las transferencias y/o recepciones de los empleados asignados a su centro funcional. --->
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
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput> (#LB_Autogestion#)">
			<!--- Definición del empleado --->
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
					Default="Error 40002. No se pudo obtener la información del Empleado asociado a su Usuario"
					returnvariable="MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario"/>
				<cfthrow message="#MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario#.">
			</cfif>
			<cfinclude template="/sif/portlets/pEmpleado.cfm">
			<cfinclude template="traspaso_aprobacion-auto-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>

