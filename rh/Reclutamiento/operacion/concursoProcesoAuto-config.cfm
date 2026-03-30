<!--- Variables de Traduccion --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeSolicitudes"
	Default="Lista de Solicitudes"
	returnvariable="LB_ListaDeSolicitudes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeConcurso"
	Default="Registro de Concurso"
	returnvariable="LB_RegistroDeConcurso"/>
<cfscript>
	//definiciones iniciales
	Gpaso = 0;
	Gconcurso = 0;
	Gmaxpasoallowed = 0;
	Gdescpasos = ArrayNew(1);
	ArrayAppend(Gdescpasos,LB_ListaDeSolicitudes);
	ArrayAppend(Gdescpasos,LB_RegistroDeConcurso);
	Gmaxpasos = ArrayLen(Gdescpasos)-1;
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
		select count(1) as valida1 from RHConcursos
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- Gconcurso MFT --->
	<cfif rsConfig_valida1.valida1 neq 1>
		<cfset Gpaso = 0>
		<cfset Gconcurso = 0>
	</cfif>
</cfif>
<!--- Programación para ver si tiene registrado un único concurso o ninguno en cuyo caso iría al paso 1 --->
<cfif Gpaso eq 0 and Gconcurso eq 0>
	<cfquery name="rsConfig_valida2" datasource="#session.dsn#">
		select RHCconcurso
		from RHConcursos
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCestado = 0
	</cfquery>
	<cfif rsConfig_valida2.recordcount LT 1>
		<cfset Gpaso = 1>
		<cfset form.Nuevo = 'Nuevo'>
	<cfelseif rsConfig_valida2.recordcount EQ 1>
		<cfset Gpaso = 1>
		<cfset Gconcurso = rsConfig_valida2.RHCconcurso>
	</cfif>
</cfif>

<cfif isdefined("Form.Alta")>
	<cfset Gpaso = 1>
</cfif>

