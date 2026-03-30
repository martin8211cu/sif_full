<!---set nocount on
Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Para el caso de Nación, esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
4. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
5. El formato del archivo debe ser el siguiente:
    a) 01 - 01 Todos los registros 4
    b) 02 - 07 Número patronal
    c) 08 - 09 Sector del patrono
    d) 10 - 10 Digito verificador 
    e) 11 - 11 Tipo de cédula (0 nacionales, 7 extranjeros)
    f) 12 - 21 Número de cédula o asegurado
    g) 22 - 51 Apellidos y nombre del empleado (En MAYÚSCULA)
    h) 52 - 61 Espacio en blanco
    i) 62 - 70 Salario (con dos decimales y sin punto)
    j) 71 - 71 Clase de seguro (En MAYUSCULA)
    k) 72 - 72 Observaciones (En MAYUSCULA)
    l) 73 - 80 Espacios en Blanco

k) Esto se llena solamente para aquellos empleados 
que en el mes que se esta sacando hayan 'ingresado', 'salido' 
o hayan estado incapacitados.   
Para el caso que hayan ingresado se pone una 'E', 
para el caso que hayan salido se pone una 'S' 
y para el caso que hayn tenido una incapacidad en el mes actual se pone una 'I'
           
l) Para el caso reciba de monto 0 en su salario (incapacidad diferente a maternidad), debe sustituirse el campo 72 la I por el mes en que se inició la incapacidad, de acuerdo a la siguiente simbología
        1 Enero
        2 Febrero
        3 Marzo
        4 Abril
        5 Mayo
        6 Junio
        7 Julio
        8 Agosto
        9 Setiembre
        0 Octubre
        N Noviembre
        X Diciembre
--->
<cfparam name="url.tiporep" type="string">
<cfparam name="url.CPmes" type="numeric">
<cfparam name="url.CPperiodo" type="numeric">
<cfparam name="session.debug" type="boolean" default="false">
<cfset session.debug = false>
<cfsetting requesttimeout="#3600#">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!--- Definiciones iniciales --->
<!--- Obtiene la fecha inicial de las nómias que correspondan al periodo mes indicados por los parámetros --->
<cfquery name="rscheck1" datasource="#session.DSN#">
	select min(CPdesde) as f1 
	from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>	
<cfset bf1 = rscheck1.f1>
<!--- Obtiene la fecha final de las nómias que correspondan al periodo mes indicados por los parámetros --->
<cfquery name="rscheck2" datasource="#session.DSN#">
	select  max(CPhasta) as f2
	from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset bf2 = rscheck2.f2>
<!--- Obtiene el numero patronal inidicado en la tabla de parámetros de la aplicación --->
<cfquery name="rscheck3" datasource="#session.DSN#">
	select Pvalor as numeropatronal
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 300
</cfquery>
<cfset bNumeropatronal = rscheck3.numeropatronal>
<cfif len(trim(bNumeropatronal)) eq 0 >
	<cfthrow detail="Error. Debe definir el N&uacute;mero Patronal en Par&aacute;metros del Sistema.">
</cfif>

<!--- Inicio de las  operaciones --->

	<!--- Se define tabla temporal con cada uno de los campos de la salida del reporte --->
	<cf_dbtemp name="repSegSocal1_temp" returnvariable="reporte_temp" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid"  				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="constante"			type="varchar(1)"	mandatory="no">
		<cf_dbtempcol name="numero_patronal"	type="varchar(9)"	mandatory="no">
		<cf_dbtempcol name="sector"				type="varchar(2)"	mandatory="no">	<!--- se supone que sector y digito verificador vienen en el numero patronal,  --->
		<cf_dbtempcol name="verificador"		type="varchar(1)"	mandatory="no"> <!--- eso se deduce del script de bd. Dejamos los campo spor si se necesitaran ---> 
		<cf_dbtempcol name="tipo_cedula"		type="varchar(1)"	mandatory="no"> <!--- 0 nacionales, 7 extranjeros--->
		<cf_dbtempcol name="identificacion"		type="varchar(10)"	mandatory="no">
		<cf_dbtempcol name="nombre"				type="varchar(30)"	mandatory="no">
		<cf_dbtempcol name="blancos1"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="salario"			type="money"		mandatory="no">	<!--- 9 digitos en salida--->
		<cf_dbtempcol name="clase_seguro"		type="varchar(1)"	mandatory="no">	<!--- mayuscula--->
		<cf_dbtempcol name="observaciones"		type="varchar(1)"	mandatory="no">	<!--- mayuscula--->
		<cf_dbtempcol name="blancos2"			type="varchar(8)"	mandatory="no">	<!--- mayuscula--->
	</cf_dbtemp>
	<!--- Se define tabla temporal para formar resultados, por complejidad de las consultas --->
	<cf_dbtemp name="repSegSocal2" returnvariable="reporte" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid"  			type="numeric" 	mandatory="no">
		<cf_dbtempcol name="denombre"  		type="char(30)"	mandatory="no">
		<cf_dbtempcol name="texto"  		type="char(80)"	mandatory="no"> <!--- 61 --->
		<cf_dbtempcol name="observaciones"  type="char(1)" 	mandatory="no">
		<cf_dbtempcol name="salario"  		type="money" 	mandatory="no">
		<cf_dbtempcol name="ordenar"  		type="char(1)" 	mandatory="no">
	</cf_dbtemp>

	<!--- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado --->
	<cf_dbfunction name="concat" args="upper(e.DEapellido1),' ',upper(e.DEapellido2),' ',upper(e.DEnombre)" returnvariable="nombre_concat">
	<cf_dbfunction name="string_part" args="#nombre_concat#,1,30" returnvariable="nombre" >
	<cfquery datasource="#session.dsn#">
		insert into #reporte_temp#( DEid, constante, numero_patronal, tipo_cedula, identificacion, nombre, blancos1, salario )
		select	e.DEid, 
				'4',
				<cfqueryparam cfsqltype="cf_sql_char" value="#mid(bNumeropatronal,1,9)#">,
				case e.NTIcodigo when 'C' then '0' else '7' end,
				<cf_dbfunction name="string_part" args="e.DEidentificacion,1,10">,
				#preservesinglequotes(nombre)#,
				'          ',
				sum(h.SEsalariobruto)

		from CalendarioPagos c, HSalarioEmpleado h, DatosEmpleado e

		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		  and h.RCNid = c.CPid
		  and e.DEid = h.DEid

		group by e.NTIcodigo, e.DEid, e.DEidentificacion,e.DEapellido1, e.DEapellido2, e.DEnombre
	</cfquery>

	<!--- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado --->
	<cfquery datasource="#session.dsn#">
		insert into #reporte# (DEid, denombre, texto, observaciones, salario, ordenar)
		select 	DEid, 
				nombre,
				constante #LvarCNCT# 
				numero_patronal #LvarCNCT#
				tipo_cedula #LvarCNCT#
				replicate ('0', 10 - {fn LENGTH(	substring(rtrim(ltrim(identificacion)),1,10)	)}) #LvarCNCT#
				substring(rtrim(ltrim(identificacion)),1,10) #LvarCNCT#
				rtrim(ltrim(nombre)) #LvarCNCT# 
				replicate(' ',30 - {fn LENGTH(rtrim(ltrim(nombre)))}) #LvarCNCT#
				blancos1 as texto,
				observaciones,
				salario,
				' '

		from #reporte_temp#
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + 
			coalesce((
				select sum(se.SEsalariobruto)
				from SalarioEmpleado se, 
					CalendarioPagos c
				where se.DEid = #reporte#.DEid
				  and c.CPid = se.RCNid
				  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
				  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			), 0)
	</cfquery>		
	<!--- Actualizar el monto de salario tomando en cuenta las incidencias aplicadas --->
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce(
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
			  and ci.CInocargas = 0)
		, 0.00)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce(
			(select sum(ic.ICmontores)
			from 
				IncidenciasCalculo ic, 
				CalendarioPagos c,
				CIncidentes ci
			where ic.DEid = #reporte#.DEid
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			  and ic.RCNid = c.CPid
			  and ci.CIid = ic.CIid
			  and ci.CInocargas = 0	)
		, 0.00)
	</cfquery>
	<!--- Determinacion de registros de Salida / Entrada / Incapacidad en el mes --->
	<!--- Salida --->
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'S'
		where exists(
			select 1 
			from DLaboralesEmpleado dl, RHTipoAccion ta 
			where dl.DEid = #reporte#.DEid 
			  and dl.DLfvigencia 
					between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
			  and ta.RHTid = dl.RHTid
			  and ta.RHTcomportam = 2
			)
	</cfquery>
	<!--- Entrada. Cuando tiene el empleado una accion de nombramiento entre las fechas --->
	<cfquery name="rsUpdateF" datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'E'
		where observaciones = ' '
		  and exists(
			select 1 
			from DLaboralesEmpleado dl, RHTipoAccion ta 
			where dl.DEid = #reporte#.DEid 
			  and dl.DLfvigencia 
			  		between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
			  and ta.RHTid = dl.RHTid
			  and ta.RHTcomportam = 1
		  )
	</cfquery>
	<!--- Entradas retroactivas, antes del inicio de las fechas del mes seleccionado, procesadas entre las fechas de la nomina.--->
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'E'
		where observaciones = ' '
		  and exists(
			select 1 
			from DLaboralesEmpleado dl, RHTipoAccion ta 
			where dl.DEid = #reporte#.DEid 
			  and dl.DLfechaaplic 
			  	between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
				and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
			  and dl.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">
			  and ta.RHTid = dl.RHTid
			  and ta.RHTcomportam = 1
		  )
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'I'
		where observaciones = ' '
		  and exists(
			select 1 
			from CalendarioPagos c, HIncidenciasCalculo ic, RHSaldoPagosExceso sp, RHTipoAccion ta 
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			  and ic.RCNid = c.CPid
			  and ic.DEid = #reporte#.DEid
			  and ic.RHSPEid is not null
			  and sp.RHSPEid = ic.RHSPEid
			  and ta.RHTid = sp.RHTid
			  and ta.RHTcomportam = 5
		  )
	</cfquery>
	<cfquery name="rsUpdateH" datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'I'
		where observaciones = ' '
		  and exists(
			select 1 
			from HPagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
			where pe.DEid = #reporte#.DEid
			  and c.CPid = RCNid
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			  and ta.RHTid = pe.RHTid
			  and ta.RHTcomportam = 5)
	</cfquery>
	<cfquery name="rsUpdateH" datasource="#session.DSN#">
		update #reporte#
		set observaciones = 'I'
		where observaciones = ' '
		  and exists(
			select 1 
			from PagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
			where pe.DEid = #reporte#.DEid
			  and c.CPid = RCNid
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			  and ta.RHTid = pe.RHTid
			  and ta.RHTcomportam = 5)
	</cfquery>
	<!---
		Insertar todas las salidas de funcionarios aplicables  
		entre las fechas del reporte y que no esten incluidas en el reporte generado
		(no tuvieron salario) en el mes seleccionado.
		Se incluyen las salidas retroactivas a esta nomina aplicadas entre las fechas del mes seleccionado
		en el segundo query
	--->
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (DEid, denombre, texto, observaciones, salario, ordenar)
		select 
			e.DEid as DEid, 
			substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30) as denombre,
			'4' #LvarCNCT# 
			<cfqueryparam cfsqltype="cf_sql_char" value="#mid(bNumeropatronal,1,9)#"> #LvarCNCT#
			case e.NTIcodigo when 'C' then '0' else '7' end #LvarCNCT#
			replicate ('0', 10 - {fn LENGTH(	substring(e.DEidentificacion,1,10)	)}) #LvarCNCT#
			substring(e.DEidentificacion,1,10) #LvarCNCT#
			substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30) #LvarCNCT# 
			replicate(' ',30 - {fn LENGTH(substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30))}) #LvarCNCT#
			'          ' as texto,
			'S' as observaciones,
			0.00 as salario, '0'
		from DLaboralesEmpleado dl, 
				DatosEmpleado e, 
				RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and dl.DLfvigencia 
		  		between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
				and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
		  and ta.RHTid = dl.RHTid
		  and ta.RHTcomportam = 2
		  and e.DEid = dl.DEid
		  and not exists(select 1 from #reporte# r where r.DEid = e.DEid)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (DEid, denombre, texto, observaciones, salario, ordenar)
		select 
			e.DEid as DEid, 
			substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30) as denombre,
			'4' #LvarCNCT# 
			<cfqueryparam cfsqltype="cf_sql_char" value="#mid(bNumeropatronal,1,9)#"> #LvarCNCT#
			case e.NTIcodigo when 'C' then '0' else '7' end #LvarCNCT#
			replicate ('0', 10 - {fn LENGTH(	substring(e.DEidentificacion,1,10)	)}) #LvarCNCT#
			substring(e.DEidentificacion,1,10) #LvarCNCT#
			substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30) #LvarCNCT# 
			replicate(' ',30 - {fn LENGTH(substring(upper(e.DEapellido1) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEapellido2) #LvarCNCT# ' ' #LvarCNCT# upper(e.DEnombre),1,30))}) #LvarCNCT#
			'          ' as texto,
			'S' as observaciones,
			0.00 as salario, '0'
		from DLaboralesEmpleado dl, 
				DatosEmpleado e, 
				RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and dl.DLfvigencia 
		  		between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
				and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
		  and dl.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">
		  and ta.RHTid = dl.RHTid
		  and ta.RHTcomportam = 2
		  and e.DEid = dl.DEid
		  and not exists(select 1 from #reporte# r where r.DEid = e.DEid)
	</cfquery>
	<!---
		Poner el mes de inicio de la incapacidad actual cuando la persona 
		esta incapacitada y el salario es cero, segun especificacion.
		Pendiente de completar este punto!
	--->
	<cfquery name="rsUpdateI" datasource="#session.DSN#">
		update #reporte#
		set observaciones = '%', ordenar = '1'
		where observaciones = 'I'
		  and salario = 0.00
	</cfquery>

	<cfif url.tiporep is not 'D' >
		<cfquery name="ERR" datasource="#session.DSN#">
			select 
				texto 
				#LvarCNCT#
				replicate(' ', 61 - {fn LENGTH( texto )}) 
				#LvarCNCT#
				replicate('0', 9 - {fn LENGTH( <cf_dbfunction name="to_char_integer" args="round(salario,2) * 100"> )}) 
				#LvarCNCT#
				<cf_dbfunction name="to_char_integer" args="round(salario,2) * 100">
				#LvarCNCT# 
				'C'
				#LvarCNCT#
				observaciones 
				#LvarCNCT# 
				'        ' as salida
			from #reporte#
			order by ordenar, denombre
		</cfquery>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 
				<!---left(texto, 21) as texto,--->
				<cf_dbfunction name="string_part" args="texto,1,21"> as texto,
				denombre as Nombre,
				<cf_dbfunction name="to_char_currency" args="round(salario,2)"> #LvarCNCT# replicate(' ',15 - {fn LENGTH( <cf_dbfunction name="to_char_currency" args="round(salario,2)"> )}) as Salario, 
				'C'
				#LvarCNCT#
				observaciones 
				#LvarCNCT# 
				'        ' as salida			
			from #reporte#
			order by ordenar, denombre
		</cfquery>
	</cfif>
	<cfquery name="rsDrop" datasource="#session.DSN#">
		truncate table #reporte#
	</cfquery>
	<cfquery name="rsDrop" datasource="#session.DSN#">
		drop table #reporte#
	</cfquery>
	<cfif session.debug>
		<cf_dump var="#ERR#">
	</cfif>
