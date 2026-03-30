
<cfscript>
	//definiciones iniciales
	Gpaso = 0;
	Gconcurso = 0;
	Gmaxpasoallowed = 0;
	Gdescpasos = ArrayNew(1);
	ArrayAppend(Gdescpasos,'Lista de Solicitudes');
	ArrayAppend(Gdescpasos,'Registro de Concurso');
	ArrayAppend(Gdescpasos,'Selecci&oacute;n de Plazas');
	ArrayAppend(Gdescpasos,'Criterios de Evaluaci&oacute;n');
	ArrayAppend(Gdescpasos,'Publicaci&oacute;n');
	Gmaxpasos = ArrayLen(Gdescpasos)-1;
	//analisis de parámetros por url
	if (isdefined('url.paso')) { //se hizo click sobre una opción del menú de pasos
		Gpaso = url.paso;
		//validación del Gpaso
		if (Gpaso gt 0){
			//en el paso 1,2 y 3 se requiere el concurso
			if (not isdefined('url.RHCconcurso') or (isdefined('url.RHCconcurso') and len(trim(url.RHCconcurso)) eq 0)){
				Gpaso = 0;
			}
			else{
				Gconcurso = url.RHCconcurso;
			}
		}
	}
	//análisis de parámetros por form
	if (isdefined('form.paso')) { //se hizo submit en uno de los forms de las pantallas 0,1,2 o 3.
		Gpaso = form.paso;
		//validación del Gpaso cuando 
		if (Gpaso gt 0){
			//en el paso 1 podría venir el botón de nuevo o el concurso
			if (Gpaso eq 1 and (isdefined('form.btnNuevo') or isdefined('form.Nuevo'))) {
				//ok, el concurso ya está en cero, con esto se maneja bien el modo alta
			}
			//en el paso 1(cuando no está definifo el botón nuevo),2 y 3 se requiere el concurso
			else{
				if (not isdefined('form.RHCconcurso') or (isdefined('form.RHCconcurso') and len(trim(form.RHCconcurso)) eq 0)){
					Gpaso = 0;
				}
				else{
					Gconcurso = form.RHCconcurso;
				}
			}
		}
	}
	//análisis de los pasos permitidos a navegar por medio del menú de pasos}
	if (Gconcurso gt 0){
		Gmaxpasoallowed = 2;
	}
</cfscript>


<!--- Validación adicional de el concurso para los pasos 1,2 y 3, valida que el concurso exista en la tabla RHConcursos --->
<cfif Gpaso gt 0 and Gconcurso gt 0>
	<cfquery name="rsConfig_valida1" datasource="#session.dsn#">
		select count(1) as valida1, RHCcantplazas from RHConcursos
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- Gconcurso MFT --->
	<cfif rsConfig_valida1.valida1 neq 1>
		<cfset Gpaso = 0>
		<cfset Gconcurso = 0>
	</cfif>
	
	<cfquery name="rsConfig_valida1a" datasource="#session.dsn#">
		select RHCcantplazas from RHConcursos
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- Para permitir la publicacion es necesario que existan plazas, areas y pruebas para las competencias --->
	<cfquery name="rsConfig_valida2" datasource="#session.dsn#">
	 	select count(1) as valida2 from RHPlazasConcurso
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsConfig_valida3" datasource="#session.dsn#">
	 	select count(1) as valida3 from RHAreasEvalConcurso
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsConfig_valida4" datasource="#session.dsn#">
	 	select count(1) as valida4 from RHPruebasConcurso
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- Hay plazas --->
 	<!--- <cfif rsConfig_valida2.valida2 gt 0>
		<cfset Gmaxpasoallowed = 3>	
	</cfif>  --->
	
	<!--- No hay Areas de Evaluación  ni Pruebas para las competencias  --->
	<cfif rsConfig_valida3.valida3 LTE 0 and rsConfig_valida4.valida4 LTE 0>
		<cfset Gmaxpasoallowed = 3>
	</cfif>	
	<!--- La cantidad de plazas del concurso (RHConcursos) es igual a la cantidad de plazas asignadas para ese concurso (RHPlazasConcurso) --->	
	 <cfif rsConfig_valida1a.RHCcantplazas EQ rsConfig_valida2.valida2>
		<cfset Gmaxpasoallowed = 3>
	<cfelse>
		<cfset Gmaxpasoallowed = 2>
	</cfif> 

	<!--- PlazasConcurso(RHConcurso) = RConcursos(RHCcantidadplazas) y hay Areas de Evaluación --->
	<cfif rsConfig_valida1a.RHCcantplazas EQ rsConfig_valida2.valida2 and rsConfig_valida3.valida3 GT 0>
		<cfset Gmaxpasoallowed = 4>
	</cfif>
	
	<!--- PlazasConcurso(RHConcurso) = RConcursos(RHCcantidadplazas) y hay Pruebas para las competencias  --->
	<cfif rsConfig_valida1a.RHCcantplazas EQ rsConfig_valida2.valida2 and rsConfig_valida4.valida4 GT 0>
		<cfset Gmaxpasoallowed = 4>
	</cfif>
	

</cfif>