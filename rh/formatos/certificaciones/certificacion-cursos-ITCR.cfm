<cfif not isdefined('rsData.RHCid') or len(trim(rsData.RHCid)) eq 0>
	<cfthrow message="El formato seleccionado requiere el parametro de curso">
</cfif>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!---
==============================================================================================
TABLA DE DONDE SALEN VAN A ALMACENARSE LOS VALORES CORRESPONDIENTES AL CURSO: DATOS REQUERIDOS
1-NOMBRE DEL FUNCIONARIO
2-TIPO DE CURSO
3-NOMBRE DEL CURSO
4-FECHAS DESDE Y HASTA
5-CANTIDAD DE HORAS
6-NOTA OBTENIDA
7-NOMBRE DEL INSTRUCTOR
8-FECHA DE HOY
==============================================================================================
--->
		<cf_dbtemp name="constancias_ITCR_v8" returnvariable="datos" datasource="#session.dsn#">
			<cf_dbtempcol name="DEid"					type="numeric"  	mandatory="no">
			<cf_dbtempcol name="nombre"					type="varchar"  	mandatory="no">
			<cf_dbtempcol name="identificacion"			type="varchar"		mandatory="no">
			<cf_dbtempcol name="tipo"				    type="varchar"		mandatory="no">
			<cf_dbtempcol name="curso"		        	type="varchar"		mandatory="no">
			<cf_dbtempcol name="fdesde"					type="date"		    mandatory="no">
			<cf_dbtempcol name="fhasta"					type="date"		    mandatory="no">
			<cf_dbtempcol name="horas"		           	type="varchar"		mandatory="no">
			<cf_dbtempcol name="nota"		         	type="varchar"		mandatory="no">
			<cf_dbtempcol name="instructor"		        type="varchar"		mandatory="no">	
			<cf_dbtempcol name="fecha"			        type="date"  		mandatory="no">		
		</cf_dbtemp>		


<cfquery name="rsQuery" datasource="#session.dsn#">
	select d.DEid,d.DEnombre #LvarCNCT#' ' #LvarCNCT#d.DEapellido1#LvarCNCT#' ' #LvarCNCT#d.DEapellido2 as nombre,
	case c.RHCtipo 
	when 'P' then 'Participación'
	when 'A' then 'Aprovechamiento'
	end as tipo,
	c.RHCnombre as curso,
	<cf_dbfunction name="date_format"	args="c.RHCfdesde,DD/MM/YYYY" > as fdesde,
	<cf_dbfunction name="date_format"	args="c.RHCfhasta,DD/MM/YYYY" > as fhasta,
	c.duracion as horas,
	e.RHEMnota as nota,
	#LSDateFormat(now(),'DD/MM/YYYY')# as fecha,
	s.RHTSdescripcion as tiposervicio,
	coalesce(i.RHInombre,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(i.RHIapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(i.RHIapellido2,'') as instructor
	from RHEmpleadoCurso e
		inner join DatosEmpleado d
		on d.DEid=e.DEid
		
		inner join RHCursos c
		on c.RHCid=e.RHCid
		
		left outer join RHTiposServ s
		on s.RHTSid=c.RHTSid
		
		inner join RHInstructores i
		on i.RHIid=c.RHIid
	where e.RHCid=#rsData.RHCid#
	and e.DEid=#rsData.DEid#
</cfquery>


		