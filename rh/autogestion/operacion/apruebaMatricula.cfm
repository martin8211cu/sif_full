<!---Esta opción se habilita si se marca el parametro 2109-ParamRH>Modulos>CapayDesa>Activar aprobación de matricula--->
<!------>
<!---<cfset LvarSAporEmpleado=true>--->

<cf_templateheader title="Aprobación de Matricula"> 

 <cf_web_portlet_start border="true" titulo="Aprobación de Matricula" skin="#Session.Preferences.Skin#">
	<cfquery name="RSDeid" datasource="#session.DSN#">
		select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
		where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
		and STabla = 'DatosEmpleado'
		and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
	</cfquery> 

	<cfif len(trim(RSDeid.DEid)) GT 0>
		<!---Determino si el usuario es jefe--->
	 	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaJefe"
		DEid = "#RSDeid.DEid#"
		fecha = "#Now()#"
		returnvariable="esjefe">
	
		<cfif esjefe.Jefe neq 0>
			<!---Determino de quien es jefe--->
			<cfinvoke component="rh.Componentes.RH_Funciones" 
			method="DeterminaSubOrd"
			DEid = "#RSDeid.DEid#"
			fecha = "#Now()#"
			Nivel="4"
			returnvariable="list_sub">
		
			<cfset lista_deid = valuelist(list_sub.DEid) >
		</cfif>
	<cfelse>
	<cfset esjefe = false>
	</cfif>
	
	
	<cfif isdefined("esjefe") and isdefined('esjefe.CFid') and len(trim(esjefe.CFID)) gt 0>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="Lvar"/>
		<cfif Lvar eq 0>
			<cf_translate key="LB_Mensaje" ><font size="+4">Para poder ingresar a esta opci&oacute;n es necesario activar el Parametro que realiza el proceso de Aprobaci&oacute;n de Matricula </font></cf_translate>
		<cfelse>
			<cfinclude template="aprobacionMatricula-lista.cfm">
		</cfif>
	<cfelse>
		 <cf_translate key="LB_Mensaje" ><font size="+4">Para poder ingresar a esta opci&oacute;n es necesario que el usuario logueado sea jefe. Proceso Cancelado!!! </font></cf_translate>
	</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>
	

