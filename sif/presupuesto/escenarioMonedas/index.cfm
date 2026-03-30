<!--- 
	Archivo: Mantenimientos de Escenarios de Tipos de Cambio.
	Fecha de Creación: Viernes 30 de Julio del 2004.
	Funcionalidad:
		1. Alta de CVTipoCambioEscenario.
		2. Cambio de CVTipoCambioEscenario.
		3. Baja de CVTipoCambioEscenario.
		4. Alta de CVTipoCambioEscenarioMes.
		5. Cambio de CVTipoCambioEscenarioMes.
		6. Baja de CVTipoCambioEscenarioMes.
		7. Alta Automática de CPmeses en caso de que no exista, se agregan con CPPid en nulo.
	Reglas:
		1. CVTtipo: (N)Normal, (O)Optimista, (P)Pesimista.
		2. CVTaplicado: (0)No, (1)Sí. Solo los que no han sido aplicados pueden ser modificados, los que ya fueron aplicados deben poder verse como una consulta.
	Archivos:
		1. Index: Archivo de control de flujo.
		2. Escenario: Atiende puntos 1, 2, y 3.
		3. Meses: Atiende puntos 4,5,6 y 7.
--->

<!--- 
	Sección 1. Dependiendo de esta sección se decide que pantalla mostrar.
		Acciones de Escenario:
			1.Pantalla de Mantenimiento de Escenarios: por defecto.
			2.SQL de Mantenimiento de Escenarios: está definido CVTid y CVTSQL.
			3.Pantalla de Mantenimiento de Meses: esta definido CVTid y CVTMeses.
			4.SQL de Mantenimiento de Meses: está definido CVTid, CPCano, CPCmes, Mcodigo y CVTMSQL.
--->
<cfscript>
	//Variables Globales
	GDebug = false;
	GPantalla = 0;
	GCurrentPage=GetFileFromPath(GetTemplatePath());
	GTitle="Escenarios de Tipos de Cambio";
	
	//Pantallas Disponibles
	mantenimiento_Escenarios = 0;
	sql_Escenarios = 1;
	//mantenimiento_Meses = 2;
	sql_Meses = 3;
	
	//Pasa parámetros del url al form para los casos en que los parámetros sean pasados por get y poder utilizarlos solo en la variable form.
	if (isdefined("url.CVTid") and len(url.CVTid) and url.CVTid and not isdefined("form.CVTid")) form.CVTid = url.CVTid;
	if (isdefined("url.CVTMeses") and len(url.CVTMeses) and url.CVTMeses and not isdefined("form.CVTMeses")) form.CVTMeses = url.CVTMeses;
	if (isdefined("url.CPCano") and len(url.CPCano) and url.CPCano and not isdefined("form.CPCano")) form.CPCano = url.CPCano;
	if (isdefined("url.CPCmes") and len(url.CPCmes) and url.CPCmes and not isdefined("form.CPCmes")) form.CPCmes = url.CPCmes;
	if (isdefined("url.Mcodigo") and len(url.Mcodigo) and url.Mcodigo and not isdefined("form.Mcodigo")) form.Mcodigo = url.Mcodigo;
	
	//1.Pantalla de Mantenimiento de Escenarios: por defecto.
	GPantalla = mantenimiento_Escenarios;
	
	//2.SQL de Mantenimiento de Escenarios: está definido CVTid y una Acción.
	//if (isdefined("form.Alta") or (isdefined("form.CVTid") and (isdefined("form.Cambio") or isdefined("Baja")))
	if 	(
			isdefined("form.Alta") or 
			(
				(isdefined("form.Cambio") or isdefined("form.Baja")) and isdefined("form.CVTid") and len(form.CVTid) 
			)
		) 
			GPantalla = sql_Escenarios;

	//3.Pantalla de Mantenimiento de Meses: esta definido CVTid y CVTMeses.
	//if (isdefined("form.CVTid") and len(form.CVTid)) GPantalla = mantenimiento_Meses;

	//4.SQL de Mantenimiento de Meses: está definido CVTid, CPCano, CPCmes, Mcodigo.
	if ((isdefined("form.CVTid") and isdefined("form.CPCano") and isdefined("form.CPCmes") and isdefined("form.Mcodigo")) and (isdefined("form.AltaMes") or isdefined("form.CambioMes") or isdefined("BajaMes") or isdefined("form.btnProyectar"))) GPantalla = sql_Meses;
	
	//Consideraciones de los botones Nuevo
	if (IsDefined("form.Nuevo")) form.cvtid = '';
	if (IsDefined("form.NuevoMes")) form.cpcmes = '';
</cfscript>
<!---
	Sección 3. Dependiendo de GPantalla reacliza las acciones con la bd necesarias y muestra la pantalla requerida.
--->
<!--- Acciones --->
<cfswitch expression="#GPantalla#">
	<cfcase value="1">
		<cfinclude template="escenariosSql.cfm">
		<cfset GPantalla = mantenimiento_Escenarios>
	</cfcase>
	<cfcase value="3">
		<cfinclude template="mesesSql.cfm">
		<!--- <cfset GPantalla = mantenimiento_Meses> --->
		<cfset GPantalla = mantenimiento_Escenarios>
	</cfcase>
</cfswitch>

<!--- Realiza las Consultas de las pantallas --->
<cfinclude template="dbCommon.cfm">

<cf_templateheader title="#GTitle#">
	<cf_web_portlet_start titulo="#GTitle#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<!--- mantenimiento_Meses --->
		<cfif isdefined("form.btnMeses") AND isdefined("form.cvtid") and len(form.cvtid)>
			<cfinclude template="meses.cfm">
		<cfelse>
			<cfinclude template="escenarios.cfm">
		</cfif>
	<cf_web_portlet_end>		
<cf_templatefooter>