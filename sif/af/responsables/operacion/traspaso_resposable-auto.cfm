<!--- Registro de Documentos de Responsabilidad --->
<!--- Este proceso es exclusivo de autogestión y permite a un EMPLEADO trasladar documentos de responsabilidad a otro EMPLEADO--->
<cf_dbfunction name="now" returnvariable="hoy">
<cfset Lvar_Autogestion = true>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion# (Autogestion)">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Autogestion"
			Default="Autogestión"
			returnvariable="LB_Autogestion"/>
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="#nav__SPdescripcion# (#LB_Autogestion#)">
			<!--- Definición del empleado --->
			<cfif isdefined("Session.DEid") and len(trim(Session.DEid))>
				<cfset form.DEid = Session.DEid>
			<cfelse>
				<cfquery name="rsgetdeid" datasource="#session.dsn#">
					select DEid 
					from DatosEmpleado
					where Ecodigo =  #session.ecodigo# 
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
						Default="Error  40001. No se pudo obtener el Empleado Asociado a su Usuario."
						returnvariable="MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario"/>
					<cf_errorCode	code = "50136"
									msg  = "traspaso_resposable-auto.cfm. @errorDat_1@"
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
						and #hoy#
						between lt.LTdesde and lt.LThasta
				where a.Ecodigo =  #session.ecodigo# 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
			</cfquery>
			<cfif rsEmpleado.recordcount neq 1>
				<cfquery name="rsEmpleado" datasource="#session.dsn#">
					select DEid, CFid
					from EmpleadoCFuncional
					where Ecodigo =  #session.ecodigo# 
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						between ECFdesde and ECFhasta
				</cfquery>
			</cfif>
			<cfif rsEmpleado.recordcount neq 1>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario"
					Default="Error  40002. No se pudo obtener la información del Empleado Asociado a su Usuario."
					returnvariable="MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario"/>

				<cf_errorCode	code = "50137"
								msg  = "traspaso_resposable-auto.cfm @errorDat_1@"
								errorDat_1="#MSG_Error40002NoSePudoObtenerLaInformacionDelEmpleadoAsociadoASuUsuario#"
				>
			</cfif>
			<cfinclude template="/sif/portlets/pEmpleado.cfm">
			<cfinclude template="traspaso_resposable-auto-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>

