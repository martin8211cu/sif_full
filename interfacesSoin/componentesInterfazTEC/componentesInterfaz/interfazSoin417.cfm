<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="rsInt" datasource="sifinterfaces">
	SELECT 	*
	FROM 	IE417
	WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>

<cfset ID= rsInt.ID>
<cfset DEidentificacion =rsInt.DEidentificacion>	
<cfset Tcodigo= rsInt.Tcodigo>
<cfset RVcodigo = rsInt.RVcodigo>
<cfset Deptocodigo= rsInt.Deptocodigo>
<cfset Oficodigo= rsInt.Oficodigo>
<cfset RHPcodigo= rsInt.RHPcodigo>
<cfset RHTcodigo= rsInt.RHTcodigo>
<cfset FechaRige= rsInt.FechaDesde>
<cfset FechaHasta= rsInt.Fechahasta>
<cfset Observaciones=rsInt.Observaciones>
<cfset RHAporc=0>
<cfset RHAporcsal=0>


<!--- Datos que hicieron falta para la acción de personal --->
<cfset LTsalario = 0>
<cfset RHJcodigo = rsInt.RHJcodigo>
<!--- Para el caso de los componentes salariales --->
<!---<cfset CSid = rsInt.CSid>
<cfset DLTtabla = rsInt.DLTtabla>
<cfset DLTunidades = rsInt.DLTunidades>
<cfset DLTmonto = rsInt.DLTmonto>--->

					
<!---Que exista el funcionario, el tipo de Nómina, Régimen de Vacaciones, Departamento, Oficina, Plaza, Puesto, CategoriaPuesto, Componentes Salariales, la acción(RHTcodigo) --->

<!--- VERIFICAR QUE SE INGRESARON LOS DATOS --->
<cfif  len(trim(#DEidentificacion#)) eq 0 >
	<cfthrow message="La identificacion es requerida">
</cfif>
<cfif  len(trim(#Tcodigo#)) eq 0 >
	<cfthrow message="El tipo de nómina es requerido">
</cfif>
<cfif  len(trim(#RVcodigo#)) eq 0 >
	<cfthrow message="El id del regimen de vacaciones es requerido">
</cfif>
<cfif  len(trim(#Deptocodigo#)) eq 0 >
	<cfthrow message="El código del departamento es requerido">
</cfif>
<cfif  len(trim(#Oficodigo#)) eq 0 >
	<cfthrow message="El código de la oficina es requerido">
</cfif>
<cfif  len(trim(#RHPcodigo#)) eq 0 >
	<cfthrow message="El código de la plaza es requerida">
</cfif>
<!---<cfif  len(trim(#CSid#)) eq 0 >
	<cfthrow message="El id del componente salarial es requerido">
</cfif>--->
<cfif  len(trim(#RHTcodigo#)) eq 0 >
	<cfthrow message="El código de la acción es requerido">
</cfif>
<cfif  len(trim(#RHJcodigo#)) eq 0 >
	<cfthrow message="La jornada es requerida">
</cfif>


<cfset FechaRige = #DateFormat(FechaRige, "dd/mm/yyyy")# >
<cfset FechaHasta= #DateFormat(FechaHasta, "dd/mm/yyyy")#>

<!---Validacion que la fechahasta sea mayor a la fecha desde --->
<cfif #FechaHasta# lt #FechaRige#>
	<cfthrow message="La fecha hasta es menor a la fecha rige">
</cfif>
<!--- Verificar si el empleado existe --->
<cfquery name="rsDatosEmpl" datasource="#session.DSN#">
 Select DEid
from DatosEmpleado
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
and DEidentificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(DEidentificacion)#">
</cfquery>
<cfif rsDatosEmpl.RecordCount EQ 0 >
	<cfthrow message="El empleado no existe">
</cfif>
<!--- Verificar el tipo de nomina --->
<cfquery name="rsTiposNomina" datasource="#session.DSN#">
select 1
from TiposNomina
where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
and Upper(rtrim(Tcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(Tcodigo))#">
</cfquery>
<cfif rsTiposNomina.RecordCount EQ 0>
	<cfthrow message="El tipo de nomina no existe #Tcodigo#">
</cfif>	
<!--- Verificar el Regimen Vacaciones --->	
<cfquery name="rsRegimenVac" datasource="#session.DSN#">
	select RVid
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and  RVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RVcodigo)#">	
</cfquery>
<cfif rsRegimenVac.RecordCount EQ 0>
	<cfthrow message="El regimen de vacaciones no existe">
</cfif>
<!--- Verificar el departamento --->	
<cfquery name="rsDepto" datasource="#session.DSN#">
	select Dcodigo
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Deptocodigo)#">
</cfquery>
<cfif rsDepto.RecordCount EQ 0>
	<cfthrow message="El departamento no existe">
</cfif>
<!--- Verificar la oficina --->	
<cfquery name="rsOfc" datasource="#session.DSN#">	
	select Ocodigo
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Oficodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Oficodigo)#">
</cfquery>
<cfif rsOfc.RecordCount EQ 0>
	<cfthrow message="La Oficina no existe">
</cfif>
<!--- Verificar la plaza --->	
<cfquery name="rsPLZ" datasource="#session.DSN#">
	select RHPid
	from RHPlazas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RHPcodigo)#">
</cfquery>
<cfif rsPLZ.RecordCount EQ 0>
	<cfthrow message="La plaza no existe">
</cfif>	
<!--- SACAR EL PUESTO A PARTIR DE LA PLAZA --->
<cfquery name="rsPuestoyPlaza" datasource="#session.DSN#">
	select RHPpuesto
	from RHPlazas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	and RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RHPcodigo)#">
</cfquery>
<!--- VALIDA LA JORNADA --->
<cfquery name="rsJornada" datasource="#session.DSN#">
	select RHJid
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	  and RHJcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(RHJcodigo)#">  
</cfquery>
<cfif rsJornada.RecordCount EQ 0>
	<cfthrow message="Error de Interfaz 417. Jornada #RHJcodigo# no existe. Proceso Cancelado!">
</cfif>

<!---<!--- Verificar Componentes salariales --->		
<cfquery name="rsComponentesSal" datasource="#session.DSN#">	
	select 1
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and CSid= <cfqueryparam cfsqltype="cf_sql_integer" value="#CSid#"> 
</cfquery>	
<cfif rsComponentesSal.RecordCount EQ 0>
	<cfthrow message="El componente salarial">
</cfif>	--->

<!--- Verificar el tipo de accion --->	
<cfquery name="rsTipoAcc" datasource="#session.DSN#">
	select RHTid
	from RHTipoAccion
	where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and RHTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RHTcodigo)#">
</cfquery>
<cfif rsTipoAcc.RecordCount EQ 0>
	<cfthrow message="El tipo de acción  no existe :#RHTcodigo#">
</cfif>	



<!--- ---------------------------------------------------------------------- --->
<!--- Inserta los registros en la tabla RHAcciones --->
<!--- ---------------------------------------------------------------------- --->
<cftransaction>

<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into RHAcciones(
			DEid, 
			RHTid, 
			Ecodigo, 
			RHPcodigo,			
			Dcodigo,
			Ocodigo,			
			Tcodigo, 			
			RVid, 			
			RHJid, 			
			RHPid, 
			DLfvigencia, 
			DLffin, 
			DLsalario, 
			DLobs, 
			IDInterfaz,
			Usucodigo,
			RHAporc, 		
			RHAporcsal)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpl.DEid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoAcc.RHTid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" 	 value="#rsPuestoyPlaza.RHPpuesto#">,			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDepto.Dcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOfc.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">,			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRegimenVac.RVid#">,			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsJornada.RHJid#">,			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPLZ.RHPid#">,			
			<cfqueryparam cfsqltype="cf_sql_date" 	 value="#FechaRige#">, 
			<cfqueryparam cfsqltype="cf_sql_date" 	 value="#FechaHasta#">, 
			<cf_dbfunction name="to_float" args="#LTsalario#" datasource="#session.DSN#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Observaciones#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			#RHAporc#,
			#RHAporcsal#
		)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset Lvar_RHAlinea = rsInsert.identity>

<!---<cfif len(trim(#DLTtabla#)) eq 0>
	<cfset DLTtabla = 'null'>
</cfif>--->

<!---<cftransaction>
<cfquery datasource="#session.DSN#" name="x">		
	insert into RHDAcciones(
		Usucodigo,				Ulocalizacion,			RHAlinea, 
		CSid,					RHDAtabla,				RHDAunidad,
		RHDAmontobase, 			RHDAmontores ) 	
		
	values(
		#session.Usucodigo#,
		'00',
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.identity#">,
		#CSid#,
		#DLTtabla#,
		#DLTunidades#,		
		0,
		0
	)
</cfquery>		
</cftransaction>	--->

<!--- GvarXML_OE no se usa por ser por tabla, se debe llenar la tabla OExx --->


