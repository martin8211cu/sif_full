<!---set nocount on
1. Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
    
3. El formato del archivo par kfc debe ser el siguiente:    
	A)Numero de Seguro Social
	b)Primer Apellido
	c)Segundo Apellido
	d)Nombre
	f)Salario percibido por mes     
--->
<cf_dbfunction name="OP_concat" returnvariable="CAT">

<cfparam name="url.CPmes" type="numeric">
<cfparam name="url.CPperiodo" type="numeric">
<cfparam name="session.debug" type="boolean" default="false">
<cfset fechainicio = CreateDate(url.CPperiodo, url.CPmes, 1)>
<cfset fechafin = DateAdd('d', -1,DateAdd('m',1,#fechainicio#) )>


<cfset session.debug = false>
<cfsetting requesttimeout="#3600#">


<cftransaction>

	<cf_dbtemp name="repSegSocal2" returnvariable="reporte" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid"  			      type="numeric" 	mandatory="no">
		<cf_dbtempcol name="Segurosocial"		  type="varchar(60)"	mandatory="no">	
		<cf_dbtempcol name="Primerapellido"		type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="Segundoapellido"	type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="Nombre"				    type="varchar(100)"	mandatory="no">		
		<cf_dbtempcol name="Salario"			    type="money"		mandatory="no">	<!--- 9 digitos en salida--->		
	</cf_dbtemp>

	<!--- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado --->	
	<cfquery datasource="#session.dsn#">
		insert into #reporte#( DEid, Segurosocial, Primerapellido, Segundoapellido, Nombre, Salario )
		
			select	e.DEid, 
						e.DESeguroSocial,	
						e.DEapellido1,
       			e.DEapellido2,
						e.DEnombre,			
						sum(h.SEsalariobruto)

			from CalendarioPagos c, HSalarioEmpleado h, DatosEmpleado e
				where c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 		and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		    and c.CPmes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		    and h.RCNid = c.CPid
		    and e.DEid = h.DEid
				group by  e.DEid,e.DESeguroSocial, e.DEidentificacion,e.DEapellido1, e.DEapellido2, e.DEnombre	
	</cfquery>
		
	
	<!--- Actualizar el monto de salario tomando en cuenta las incidencias aplicadas que afectan el salario promedio --->
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set Salario = Salario + coalesce(
																			(select sum(ic.ICmontores)
																						from 
																							HIncidenciasCalculo ic, 
																							CalendarioPagos c,
																							CIncidentes ci
																						where ic.DEid = #reporte#.DEid
																						  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
																						  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
																						  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
																						  and ic.RCNid = c.CPid
																						  and ci.CIid = ic.CIid
																						  and ci.CInocargasley=0)
																		, 0.00)
	</cfquery>
		
			<cfquery name="ERR" datasource="#session.DSN#">
		select 
					rtrim(Segurosocial) #CAT#  ','  #CAT#
				  <cf_dbfunction name="date_format" args="#fechainicio#,DD/MM/YYYY "   > #CAT#  ','  #CAT# 
			    <cf_dbfunction name="date_format" args="#fechafin#,DD/MM/YYYY "   > #CAT#  ','  #CAT# 			
					rtrim(Primerapellido) #CAT#  ','  #CAT#
					rtrim(Segundoapellido) #CAT#  ','  #CAT#
		      rtrim(Nombre) #CAT#  ','  #CAT#						
		      <cf_dbfunction name="to_char_float"  args="round(Salario,2) "  dec="2"  datasource="#session.dsn#">
		   	
			from #reporte#
			order by Primerapellido
		</cfquery>      
	
	<cfquery name="rsDrop" datasource="#session.DSN#">
		truncate table #reporte#
	</cfquery>
	<cfquery name="rsDrop" datasource="#session.DSN#">
		drop table #reporte#
	</cfquery>
	<cfif session.debug>
		<cf_dump var="#ERR#">
	</cfif>
</cftransaction>