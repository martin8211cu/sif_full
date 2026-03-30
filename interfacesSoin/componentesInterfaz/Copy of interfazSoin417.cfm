<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="rsInt" datasource="sifinterfaces">
	SELECT 	*
	FROM 	IE417
	WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>

<cfset DEid = rsInt.DEid>
<cfset Tcodigo = rsInt.Tcodigo>
<cfset RVid = rsInt.RVid>
<cfset Dcodigo = rsInt.Dcodigo>
<cfset Ocodigo = rsInt.Ocodigo>
<cfset RHPid = rsInt.RHPid>
<cfset LTsalario = rsInt.LTsalario>
<cfset LTporcsal = rsInt.LTporcsal>
<cfset LTporcplaza = rsInt.LTporcplaza>
<cfset RHPcodigo = rsInt.RHPcodigo>
<cfset RHCPlinea = rsInt.RHCPlinea>
<cfset CSid = rsInt.CSid>
<cfset DLTtabla = rsInt.DLTtabla>
<cfset DLTunidades = rsInt.DLTunidades>
<cfset DLTmonto = rsInt.DLTmonto>
<cfset RHTcodigo = rsInt.RHTcodigo>	
<cfset FechaRige = rsInt.FechaRige>		            
<cfset FechaHasta = rsInt.FechaHasta>						

<!---Que exista el funcionario, el tipo de Nómina, Régimen de Vacaciones, Departamento, Oficina, Plaza, Puesto, CategoriaPuesto, Componentes Salariales, la acción(RHTcodigo) --->

<!--- Verificar que se ingresaron los datos --->
<cfif  len(trim(#DEid#)) eq 0 >
	<cfthrow message="El DEid es requerido">
</cfif>
<cfif  len(trim(#Tcodigo#)) eq 0 >
	<cfthrow message="El tipo de nómina es requerido">
</cfif>
<cfif  len(trim(#RVid#)) eq 0 >
	<cfthrow message="El id del regimen de vacaciones es requerido">
</cfif>
<cfif  len(trim(#Dcodigo#)) eq 0 >
	<cfthrow message="El código del departamento es requerido">
</cfif>
<cfif  len(trim(#Ocodigo#)) eq 0 >
	<cfthrow message="El código de la oficina es requerido">
</cfif>
<cfif  len(trim(#Ocodigo#)) eq 0 >
	<cfthrow message="El código de la oficina es requerido">
</cfif>
<cfif  len(trim(#RHPid#)) eq 0 >
	<cfthrow message="La id de la plaza es requerida">
</cfif>
<cfif  len(trim(#LTsalario#)) eq 0 >
	<cfthrow message="Se debe ingresar el salario">
</cfif>
<cfif  len(trim(#LTporcsal#)) eq 0 >
	<cfthrow message="Se debe ingresar el porcentaje del salario">
</cfif>
<cfif  len(trim(#LTporcplaza#)) eq 0 >
	<cfthrow message="Se debe ingresar el porcentaje de la plaza">
</cfif>
<cfif  len(trim(#RHPcodigo#)) eq 0 >
	<cfthrow message="Se debe ingresar el código del puesto">
</cfif>
<cfif  len(trim(#RHCPlinea#)) eq 0 >
	<cfthrow message="Se debe ingresar el id de la categoría">
</cfif>
<cfif  len(trim(#CSid#)) eq 0 >
	<cfthrow message="El id del componente salarial es requerido">
</cfif>
<cfif  len(trim(#RHTcodigo#)) eq 0 >
	<cfthrow message="El tipo de acción es requerido">
</cfif>



<cfset FechaRige = #DateFormat(FechaRige, "dd/mm/yyyy")# >
<cfset FechaHasta= #DateFormat(FechaHasta, "dd/mm/yyyy")#>

<cfif #FechaHasta# lt #FechaRige#>
	<cfthrow message="La fecha hasta es menor a la fecha rige">
</cfif>

<!--- Verificar si el empleado existe --->
<cfquery name="rsDatosEmpl" datasource="#session.DSN#">
 Select 1
from DatosEmpleado
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
and DEid=<cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
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
	
<cfquery name="rsRegimenVac" datasource="#session.DSN#">
	select 1
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RVid#">	
</cfquery>
<cfif rsRegimenVac.RecordCount EQ 0>
	<cfthrow message="El regimen de vacaciones no existe">
</cfif>

<cfquery name="rsDepto" datasource="#session.DSN#">
	select 1
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Dcodigo#">
</cfquery>
<cfif rsDepto.RecordCount EQ 0>
	<cfthrow message="El departamento no existe">
</cfif>

<cfquery name="rsOfc" datasource="#session.DSN#">	
	select 1
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ocodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ocodigo#">
</cfquery>
<cfif rsOfc.RecordCount EQ 0>
	<cfthrow message="La Oficina no existe">
</cfif>

<cfquery name="rsPLZ" datasource="#session.DSN#">
	select 1
	from RHPlazas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHPid#">
</cfquery>
<cfif rsPLZ.RecordCount EQ 0>
	<cfthrow message="La plaza no existe">
</cfif>	
	
<cfquery name="rsPuesto" datasource="#session.DSN#">		
	select 1
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPcodigo#">
</cfquery>
<cfif rsPuesto.RecordCount EQ 0>
	<cfthrow message="El puesto no existe">
</cfif>	
	
<!--- Verificar si el puesto esta relacionado a la plaza --->
<cfquery name="rsPuestoyPlaza" datasource="#session.DSN#">
	select 1
	from RHPlazas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHPid#">
	and RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPcodigo#">
</cfquery>
<cfif rsPuestoyPlaza.RecordCount EQ 0>
	<cfthrow message="El puesto #RHPcodigo# no esta relacionado a la plaza #RHPid#">
</cfif>	

<cfquery name="rsCategPuesto" datasource="#session.DSN#">
	select 1
	from RHCategoriasPuesto
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHCPlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCPlinea#">
</cfquery>
<cfif rsCategPuesto.RecordCount EQ 0>
	<cfthrow message="La Categoría del puesto no existe">
</cfif>	
	
<cfquery name="rsComponentesSal" datasource="#session.DSN#">	
	select 1
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and CSid= <cfqueryparam cfsqltype="cf_sql_integer" value="#CSid#"> 
</cfquery>	
<cfif rsComponentesSal.RecordCount EQ 0>
	<cfthrow message="El componente salarial">
</cfif>	

<cfquery name="rsTipoAcc" datasource="#session.DSN#">
	select RHTid
	from RHTipoAccion
	where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and RHTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#RHTcodigo#">
</cfquery>
<cfif rsTipoAcc.RecordCount EQ 0>
	<cfthrow message="El tipo de acción  no existe :#RHTcodigo#">
</cfif>	


<!--- Falta la validacion de las fechas --->


<!--- ---------------------------------------------------------------------- --->
<!--- Inserta los registros en la tabla RHAcciones --->
<!--- ---------------------------------------------------------------------- --->

<!---<cfthrow message="DEid = #DEid#, rsTipoAcc = #rsTipoAcc.RHTid#, Ecodigo=#session.Ecodigo#, Tcodigo = #Tcodigo#, RVid = #RVid#, RHPid = #RHPid#, 
RHPcodigo= #RHPcodigo#,FechaRige = #FechaRige#, FechaHasta = #FechaHasta#, LTsalario = #LTsalario#, LTporcsal = #LTporcsal#, Usucodigo=#session.Usucodigo# ">--->
<cftransaction>
<cfquery datasource="#session.DSN#" name="rsAccion">
	insert into RHAcciones (
		DEid,			RHTid,			Ecodigo,		Tcodigo, 
		RVid, 			RHJid, 			RHPid, 			RHPcodigo, 
		DLfvigencia, 	DLffin, 		DLsalario, 		DLobs, 
		Usucodigo, 		Ulocalizacion,	RHAporc, 		RHAporcsal, 
		RHAidtramite, 	IEid,			TEid )
values( 
	#DEid#,
	#rsTipoAcc.RHTid#,
	#session.Ecodigo#,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">,
	#RVid#,
	null,
	#RHPid#,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPcodigo#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaRige#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaHasta#">,
	<cf_dbfunction name="to_float" args="#LTsalario#" datasource="#session.DSN#">,
	null,
	#session.Usucodigo#, 				
	'00',	
	null,
	#LTporcsal#,
	null,
	null,
	null)
	
	<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="no">
</cfquery>
<cf_dbidentity2 datasource="#session.DSN#" name="rsAccion" verificar_transaccion="no">	
<!--- me falta la llave que se retorna el RHAlinea de la accion que se acaba de insertar--->
</cftransaction>

<!---<cfthrow message="Usucodigo =#session.Usucodigo#, identity = #rsAccion.identity#, CSid =#CSid#, DLTtabla = #DLTtabla#, DLTunidades = #DLTunidades# 
 DLTmonto = #DLTmonto#">--->
 
<cftransaction>

<cfif len(trim(#DLTtabla#)) eq 0>
	<cfset DLTtabla = 'null'>
</cfif>

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
		<cf_dbfunction name="to_float" args="#DLTmonto#" datasource="#session.DSN#">,
		<cf_dbfunction name="to_float" args="#DLTmonto#" datasource="#session.DSN#"> 
	)
</cfquery>		
</cftransaction>	

<!--- GvarXML_OE no se usa por ser por tabla, se debe llenar la tabla OExx --->


