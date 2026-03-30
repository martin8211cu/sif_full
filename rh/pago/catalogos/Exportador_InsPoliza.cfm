<!----=================================================================
Este archivo tiene 
1. La información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
3. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas, 4 o 5 semanas, 2 quincenas o 1 mes
4. El formato del archivo debe ser el siguiente:
  Linea 1
	Póliza			Numérico	    7		Número de póliza Diferente de blancos.Diferente de cero.
	Tipo			Alfanumérico	1		Tipo de planilla	M = mensual ó A = adicional
	Año				Numérico		4		Año de la planilla	
	Mes				Numérico		2		Mes de la Planilla	
	espacio			Alfanumérico	1		Espacio en blanco
	N° de Identif.	Alfanumérico	15		Cédula del patrono
	N° de Telefono	Alfanumérico	8		Telefono del patrono. 
	N° de Fax   	Alfanumérico	8		Fax del patrono. 

  Linea 2
	Direccion 		Alfanumérico	200		Dirección del patrono

  Linea 3
	espacio			Alfanumérico	1		Espacio en blanco

  Linea 4	
	Identificacion	Alfanumérico	15		Cédula del trabajador Diferente de blancos.No existan registros duplicados. 
	No. Asegurado	Alfanumérico	25		Número Asegurado C.C.S.S Según especificaciones que rigen para la C.C.S.S
	Nombre			Alfanumérico	15		Nombre del trabajador	
	Apellido1		Alfanumérico	15		1er Apellido 	
	Apellido2		Alfanumérico	15		2do Apellido	
	Salario			Numérico		10.2	Salario Mensual Diferente de cero si el campo días es mayor que cero.Salarios redondeados los céntimos.(léase 13 caracteres tomando en cuenta el punto decimal)
	Días Laborados	Numérico		3		Días Laborados De 0 a 30 días
	Horas			Numérico		4		Horas laboradas Ceros
	Jornada			Numerico		2		Tipo de Jornada (01: Jornada de 8 o mas horas, 02: Jornadas de menos de 8 horas, 03: Contratos especiales, 04: Destajo)
	Condición Lab.  Numerico		2		Condiciones Especiales (00: Sin Cambios, 01: Ingresos, 02: Exclusiones, 03: Incapac. CCSS, 04: Incap. INS, 05: Vacaciones, 06: Permisos)
	Ocupación		Alfanumérico	5		Ocupación Código según lista de puestos del INS
=================================================================--->
<!----TRADUCCION---->
<cfinvoke returnvariable="MSG_NoSeHaDefinidoElNumeroDePolizaDelIns" Key="MSG_NoSeHaDefinidoElNumeroDePolizaDelIns" Default="No se ha definido el numero de poliza del INS" component="sif.Componentes.Translate" method="Translate" />
<!----PARAMETROS---->
<cfparam name="url.CPmes" >
<cfparam name="url.CPperiodo">

<cf_dbtemp name="reportetmp25" returnvariable="reporte" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="RCNid" 		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="poliza"		type="varchar(7)" 	mandatory="no">
	<cf_dbtempcol name="tipoP"		type="char(1)" 		mandatory="no">
	<cf_dbtempcol name="tipoC"		type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="cedula"		type="varchar(15)" 	mandatory="no">
	<cf_dbtempcol name="numseguro"	type="varchar(25)" 	mandatory="no">
	<cf_dbtempcol name="nombre"		type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="apellido1"	type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="apellido2"	type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="salario"	type="money"		mandatory="no">
	<cf_dbtempcol name="salario2"	type="varchar(13)"	mandatory="no">
	<cf_dbtempcol name="dias"		type="numeric" 			mandatory="no">
	<cf_dbtempcol name="horas"		type="int" 			mandatory="no">
	<cf_dbtempcol name="ocupacion"	type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="puesto"		type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="RHJid"		type="numeric" 		mandatory="no">	
	<cf_dbtempcol name="FactorDias"		type="numeric" 		mandatory="no">	
	<cf_dbtempcol name="jornada"	type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="condicion"	type="char(2)" 		mandatory="no">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp> 

<cf_dbtemp name="reporte1" returnvariable="reporte1" datasource="#session.DSN#">
	<cf_dbtempcol name="ordenado" 	type="int"  		mandatory="no">
	<cf_dbtempcol name="salida"		type="varchar(200)" mandatory="no">
</cf_dbtemp>

<cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
	select 	d.Pvalor as Poliza, 
			coalesce(a.Etelefono1,'') as Etelefono1,  
			coalesce(a.Efax,'') as Efax, 
			coalesce(a.Eidentificacion,'') as Eidentificacion, 
			coalesce(c.direccion1,'') as direccion1
	from Empresa a, Empresas b, Direcciones c, RHParametros d
	where a.Ecodigo = b.EcodigoSDC
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.id_direccion = c.id_direccion
		and d.Pcodigo = 420 
		and d.Ecodigo = b.Ecodigo
</cfquery>
<cfquery name="rsFDesde" datasource="#session.DSN#">
	select  min(CPdesde) as f1
   from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsFhasta" datasource="#session.DSN#">
	select  max(CPhasta) as f2
	   from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- numero de poliza --->
<cfquery name="rs_poliza" datasource="#session.DSN#">
	select RHDDVvaloracion as Poliza
	from RHDDatosVariables
	where RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.poliza#">
</cfquery>
<cfif len(trim(rs_poliza.Poliza)) EQ 0>
	<cf_throw message="#MSG_NoSeHaDefinidoElNumeroDePolizaDelIns#" errorcode="6005">
	<cfabort>
</cfif>
<!--- formatea a no decimales, por aquello que traiga decimales--->
<cfset vPoliza = LSNumberFormat(rs_poliza.Poliza, '9') >


<!----inserta la primera linea---->
<cfset cantespactel= len(rtrim(rsDatosEmpresa.Etelefono1))>
<cfset cantespacfax= len(rtrim(rsDatosEmpresa.Efax))>
<cfif cantespactel GT 8>
	<cfset cantespactel= 8>
</cfif>
<cfif cantespacfax GT 8>
	<cfset cantespacfax= 8>
</cfif>
<cfset vs_salida = 
	  mid(vPoliza,1,7)&
	  'M'&
	  url.CPperiodo &
	  RepeatString('0',2-len(trim(url.CPmes)))&
	  trim(url.CPmes)&
	  ' '&
	  rsDatosEmpresa.Eidentificacion&
	  RepeatString(' ',15-len(rtrim (mid(rsDatosEmpresa.Eidentificacion , 1,15)  )))&
	  rsDatosEmpresa.Etelefono1 & 
	  RepeatString(' ',8-cantespactel)&
	  rsDatosEmpresa.Efax&
	  RepeatString(' ',8-cantespacfax)>	  
<cfquery datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 	1,
			'#vs_salida#'
	from dual		
</cfquery>
<!----- inserta la segunda linea ----->
<cfquery datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select	2,
			'#rsDatosEmpresa.direccion1#'
	from dual		
</cfquery>
<!---- inserta la tercera linea ----->
<cfquery datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 	3, 
			' '
	from dual
</cfquery>
<!---- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado ----->
<!----============================= ORACLE =============================---->
<cfif isdefined("Application.dsinfo") and Application.dsinfo[session.dsn].type is 'oracle'>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, 
						apellido2, numseguro, poliza, tipoP, dias, horas, 
						ocupacion, salario, puesto, condicion, jornada)
		select 	e.NTIcodigo, 
				h.DEid ,
				right(e.DEidentificacion,15),  
				rpad(<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">,15,' '),												
				rpad(right(coalesce(e.DEdato3,' '),25),25,' '),  
				'0000000',
				'M',       
				0,
				0000,
				'',
				sum(h.SEsalariobruto),
				null, 
				'00', 
				'00'
		from 	CalendarioPagos c, 
				HSalarioEmpleado h, 
				DatosEmpleado e
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
			and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
			and c.CPid = h.RCNid 
			and h.DEid = e.DEid 
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		group by  e.NTIcodigo, h.DEid, e.DEidentificacion, e.DEnombre, e.DEapellido1,e.DEapellido2, e.DEdato3		
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto, condicion, jornada)
		select 	e.NTIcodigo, 
				dl.DEid ,
				right(e.DEidentificacion,15), 				
				rpad(<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">,15,' '),												
				rpad(right(coalesce(e.DEdato3,' '),25),25,' '), 
				'0000000',
				'M',       
				0,
				0000,
				'',
				0,
				null, 
				'00', 
				'00'
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dl.DLfechaaplic between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
			and e.DEid = dl.DEid
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and not exists(select 1 from #reporte# r 
							where r.DEid = e.DEid)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
		select 	e.NTIcodigo, 
				dl.DEid ,
				right(e.DEidentificacion,15), 
				rpad(<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">,15,' '),
				rpad(<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">,15,' '),												
				rpad(right(coalesce(e.DEdato3,' '),25),25,' '), 
				'0000000',
				'M',       
				0,
				001,
				'',
				0,
				null
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dl.DLfechaaplic between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
			and dl.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
			and e.DEid = dl.DEid
			and not exists(	select 1 
							from #reporte# r 
							where r.DEid = e.DEid)
	</cfquery>	
<cfelse><!----============================= SYBASE =============================---->
	<cfquery name="rs" datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, 
						apellido2, numseguro, poliza, tipoP, dias, horas, 
						ocupacion, salario, puesto, condicion, jornada)
		select 	e.NTIcodigo, 
				h.DEid ,
				right(e.DEidentificacion,15),  
				<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">+replicate(' ',15-len(e.DEnombre)),			
				<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">+replicate(' ',15-len(e.DEapellido1)),
				<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">+replicate(' ',15-len(e.DEapellido2)),
				right(e.DEdato3,25),  
				'0000000',
				'M',       
				0,
				0000,
				'',
				sum(h.SEsalariobruto),
				null, 
				'00', 
				'00'
		from 	CalendarioPagos c, 
				HSalarioEmpleado h, 
				DatosEmpleado e
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
			and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
			and c.CPid = h.RCNid 
			and h.DEid = e.DEid 
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		group by  e.NTIcodigo, h.DEid, e.DEidentificacion, e.DEnombre, e.DEapellido1,e.DEapellido2, e.DEdato3
	</cfquery>

	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto, condicion, jornada)
		select 	e.NTIcodigo, 
				dl.DEid ,
				right(e.DEidentificacion,15), 
				<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">+replicate(' ',15-len(e.DEnombre)),
				<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">+replicate(' ',15-len(e.DEapellido1)),
				<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">+replicate(' ',15-len(e.DEapellido2)),
				right(e.DEdato3,25),  
				'0000000',
				'M',       
				0,
				0000,
				'',
				0,
				null, 
				'00', 
				'00'
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dl.DLfechaaplic between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
			and e.DEid = dl.DEid
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and not exists(select 1 from #reporte# r 
							where r.DEid = e.DEid)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
		select 	e.NTIcodigo, 
				dl.DEid ,
				right(e.DEidentificacion,15), 
				<cf_dbfunction name="string_part"   args="e.DEnombre,1,15">+replicate(' ',15-len(e.DEnombre)),
				<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15">+replicate(' ',15-len(e.DEapellido1)),
				<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15">+replicate(' ',15-len(e.DEapellido2)),
				right(e.DEdato3,25),  
				'0000000',
				'M',       
				0,
				001,
				'',
				0,
				null
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dl.DLfechaaplic between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
			and dl.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">
			and ta.RHTid = dl.RHTid
			and ta.RHTcomportam = 2
			and e.DEid = dl.DEid
			and not exists(	select 1 
							from #reporte# r 
							where r.DEid = e.DEid)
	</cfquery>
			
</cfif>

<cfquery datasource="#session.DSN#">
	update #reporte# 
	set puesto = (
					select min(RHPcodigo )
					from LineaTiempo b 
					where b.DEid = #reporte#.DEid 
						and b.LThasta = (
											select max(lt.LThasta)
											from LineaTiempo lt
											where lt.DEid = #reporte#.DEid
												and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between lt.LTdesde and lt.LThasta
										 )
					)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #reporte# 
	set puesto = (
					select RHPcodigo 
					from LineaTiempo b 
					where b.DEid = #reporte#.DEid 
						and b.LThasta = (
											select max(lt.LThasta)
											from LineaTiempo lt
											where lt.DEid = #reporte#.DEid
										)
				)
	where puesto is null
</cfquery>
<!--- borrar los puestos que no pertenecen a la poliza --->
	<cfquery name="rs_puestos" datasource="#session.DSN#">
		select RHPcodigo
		from RHPuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHDDVlinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.poliza#">
	</cfquery>



<cfif rs_puestos.recordcount gt 0>
	<cfquery datasource="#session.DSN#">
		delete #reporte#
			where puesto not in (#quotedvaluelist(rs_puestos.RHPcodigo)#)
	</cfquery>
	<!--- --->
	
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set ocupacion = (select min(RHPEcodigo)
							from RHPuestos r, RHPuestosExternos o
							where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and r.RHPcodigo = rtrim(ltrim(#reporte#.puesto))
								and o.RHPEid = r.RHPEid
								)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set ocupacion = '00000'
		where ocupacion is null or ocupacion = ''
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
			set dias =  (select  isnull(sum(a.PEcantdias),0) 
						from  HPagosEmpleado a, CalendarioPagos c
						where a.DEid = #reporte#.DEid
							and a.PEtiporeg = 0
							and c.Ecodigo = #session.Ecodigo#
							and c.CPperiodo =#url.CPperiodo#
							and c.CPmes = #url.CPmes#
							and c.CPid = a.RCNid
						),
			   RHJid =  (select  isnull(max(RHJid),0) 
						from  HPagosEmpleado a, CalendarioPagos c
						where a.DEid = #reporte#.DEid
							and a.PEtiporeg = 0
							and c.Ecodigo = #session.Ecodigo#
							and c.CPperiodo =#url.CPperiodo#
							and c.CPmes = #url.CPmes#
							and c.CPid = a.RCNid
						)
	</cfquery>

	<!--- LZ establece segun la Maxima Jornada de la Nómina, la cantidad de dias que trabaja realmente según las horas diarias --->
	<!--- Establezco un Facto de Pago de Día en base a la cantidad de horas normales por jornada y la cantidad de horas indicadas que tiene la jornda --->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set FactorDias = (Select case when a.RHJtipo=0 then
											(8 / RHJhoradiaria) <!---Jornada Diurna --->
										  when a.RHJtipo=1 then
											(7 / RHJhoradiaria) <!---Jornada Mixta  --->
									 else
											(6 / RHJhoradiaria) <!---Jornada Diurna --->
									 end
									 from RHJornadas a
									 Where a.RHJid=#reporte#.RHJid)
	</cfquery>
	
	<!--- Según el Factor de Día y la cantidad de días asignado, se establece la cantidad de días laborados--->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set dias = floor(dias / FactorDias)
	</cfquery>
	
	
	<!---
	LZ. 10-12-2008 Se comenta condicion, pues correo de  que indica: 
	De: Mauricio Madriz/INS [mailto:mmadriz@ins-cr.com]
	Enviado el: Miércoles, 10 de Diciembre de 2008 11:15 a.m.
	Para: Silvia Gonzalez
	Asunto: RE: CONSULTA COOPELESCA REPORTE RIESGOS DEL TRABAJO
	Si perdon talvez no me explique bien, tiene que poner los dias que laboro realmente en el mes y poner el salario total que gana, 
	porque por vacaciones no se hace ningun cambio por rebajo o cualquier otra cosa.
	and RHTcomportam in (4, 5)    
	
	<!---- Resta los días que estuvo Ausente---->
	<cfset x = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
	<cfset y = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
	
	<cf_dbfunction name="datediff" args="#preservesinglequotes(x)#, DLfvigencia"	returnvariable="difd1">
	<cf_dbfunction name="datediff" args="#preservesinglequotes(y)#, DLffin" 		returnvariable="difd2">
	
			<cfquery datasource="#session.DSN#">
				update #reporte#
					set dias = dias -  coalesce( 
												(select  sum(	<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">
																+1
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> > DLfvigencia then abs(#preservesinglequotes(difd1)#) else 0 end
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> < DLffin then abs(#preservesinglequotes(difd2)#) else 0 end 
															)
												from DLaboralesEmpleado a, DatosEmpleado b, RHTipoAccion c
												where 	a.DEid = #reporte#.DEid
														and a.DEid = b.DEid
														and a.RHTid = c.RHTid
														and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between a.DLfvigencia and a.DLffin
																or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">	between a.DLfvigencia and a.DLffin
															)
												and RHTcomportam in (3, 4, 5)    
												) 
											,0)
			</cfquery>
	--->
	
	<!---
	LZ. 10-12-2008 Con base en los Argumentos del Correo indicado en el Comentario anterior 
		unicamente se rebajan días cuando el funcionario no devengue Salario por incapacidades o Permisos SIN SUELDO
		Ademas se deben determinar las Incapacidades según la información de HPagosEmpleado si son Retroactivas 
		y contra RHSaldoPagosExceso si son No Retroactivas
	--->
	
	<!---- Resta los días que estuvo Ausente---->
	<cfset x = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
	<cfset y = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
	
	<cf_dbfunction name="datediff" args="#preservesinglequotes(x)#, PEdesde"	returnvariable="difd1">
	<cf_dbfunction name="datediff" args="#preservesinglequotes(y)#, PEhasta" 	returnvariable="difd2">
	
	<!---LZ. REBAJO DE DIAS POR INCAPACIDAD RETROACTIVOS --->
			<cfquery datasource="#session.DSN#">
				update #reporte#
					set dias = dias -  coalesce( 
												(select  sum(PEcantdias)
												from HPagosEmpleado a, 
													 DatosEmpleado b, 
													 RHTipoAccion c,
													 CalendarioPagos d
												where 	a.DEid = #reporte#.DEid
														and a.DEid = b.DEid
														and a.RCNid = d.CPid													
														and a.RHTid = c.RHTid
														and d.CPmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
														and d.CPperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPPeriodo#">
														and RHTcomportam = 5
														and a.PEtiporeg=0  <!--- LZ 27-02-2009 Solo debe contemplar los Ordinarios no los Retroactivos --->
												
												) 
											,0)
			</cfquery>	
			
	<!---LZ. REBAJO DE DIAS POR INCAPACIDAD NO RETROACTIVOS --->
	<cfset x1 = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
	<cfset y1 = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
	
	<cf_dbfunction name="datediff" args="#preservesinglequotes(x1)#, DLfvigencia"	returnvariable="difd3">
	<cf_dbfunction name="datediff" args="#preservesinglequotes(y1)#, DLffin" 		returnvariable="difd4">
	
			<cfquery datasource="#session.DSN#">
				update #reporte#
					set dias = dias -  coalesce( 
												(select  sum(	<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">
																+1
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> > DLfvigencia then 
																			abs(#preservesinglequotes(difd3)#) else 0 end
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> < DLffin then 
																			abs(#preservesinglequotes(difd4)#) else 0 end 
															)
												from DLaboralesEmpleado a, 
													 DatosEmpleado b, 
													 RHTipoAccion c,
													 RHSaldoPagosExceso d
												where 	a.DEid = #reporte#.DEid
														and a.DEid = b.DEid
														and a.RHTid = c.RHTid
														and d.DLlinea= a.DLlinea
														and d.RHSPEanulado=0   <!--- Acciones no Anuladas--->
														and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between a.DLfvigencia and a.DLffin
																or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">	between a.DLfvigencia and a.DLffin
															)
												and RHTcomportam = 5  
												) 
											,0)
			</cfquery>
	
	
	<!---LZ. REBAJO DE DIAS POR PERMISOS SIN GOCE--->
	<cfset x2 = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
	<cfset y2 = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
	
	<cf_dbfunction name="datediff" args="#preservesinglequotes(x2)#, PEdesde"	returnvariable="difd5">
	<cf_dbfunction name="datediff" args="#preservesinglequotes(y2)#, PEhasta" 	returnvariable="difd6">
			<cfquery datasource="#session.DSN#">
				update #reporte#
					set dias = dias -  coalesce( 
												(select  sum(<cf_dbfunction name="datediff" args="PEdesde, PEhasta">+1)
												from HPagosEmpleado a, 
													 DatosEmpleado b, 
													 RHTipoAccion c,
													 CalendarioPagos d
												where 	a.DEid = #reporte#.DEid
														and a.DEid = b.DEid
														and a.RCNid = d.CPid													
														and a.RHTid = c.RHTid
														and d.CPmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
														and d.CPperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPPeriodo#">
														AND RHTpaga=0
														and RHTcomportam = 5
														and a.PEtiporeg=0  <!--- LZ 27-02-2009 Solo debe contemplar los Ordinarios no los Retroactivos --->
												
												) 
											,0)
			</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set dias = case when  dias < 0 then 0 else dias end
	</cfquery>
	<!---- Modificación SOLO para el caso de Semanales
	si la periodicidad es semanal y la cantidad de días mayor a 26, entonces la cantidad de días será siempre 26----->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set dias = 26
		where DEid in (	select DEid 
						from DLaboralesEmpleado a, TiposNomina b
						where a.Tcodigo = b.Tcodigo
							and b.Ttipopago = 0
					)
			and dias > 26
	</cfquery>
	<cfquery name="r" datasource="#session.DSN#">
		update #reporte#
			set horas =  (	select  coalesce(sum(a.PEhjornada * a.PEcantdias),0) 
							from  HPagosEmpleado a, CalendarioPagos c
							where a.DEid = #reporte#.DEid
								and a.PEtiporeg = 0
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
								and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
								and c.CPid = a.RCNid
								<!---and a.PEmontores > 0---->
						)
	</cfquery>
	<!---- Rebaja las horas de los días de Ausencia ---->
	<cfset x = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
	<cfset y = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
	
	<cf_dbfunction name="datediff" args="#preservesinglequotes(x)#, DLfvigencia"	returnvariable="difd1">
	<cf_dbfunction name="datediff" args="#preservesinglequotes(y)#, DLffin" 		returnvariable="difd2">
	
	
	
	<cfif isdefined("Application.dsinfo") and Application.dsinfo[session.dsn].type is 'oracle'>
		<cf_dbtemp name="reportetmp3" returnvariable="reporte3" datasource="#session.DSN#">
			<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="no">
			<cf_dbtempcol name="horas"		type="int" 			mandatory="no">
			<cf_dbtempcol name="PEhjornada"	type="float" 		mandatory="no">
			<cf_dbtempkey cols="DEid">
		</cf_dbtemp> 
	
		<cfquery name="x" datasource="#session.DSN#">
			insert into #reporte3#(DEid,horas,PEhjornada)
			select #reporte#.DEid, #reporte#.horas, d.PEhjornada
			from  HPagosEmpleado d, CalendarioPagos e, #reporte#
			where d.DEid = #reporte#.DEid
				and d.PEtiporeg = 0
				and e.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and e.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
				and e.CPmes =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
				and e.CPid = d.RCNid
				and #reporte#.RCNid = #reporte#.RCNid
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update ( select a.horas, a.PEhjornada
					from  #reporte3# a, #reporte# b
					where b.DEid=a.DEid)
				
				set horas = horas - coalesce( ( (select  	sum(<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">
																+1 
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> > DLfvigencia then abs(#preservesinglequotes(difd1)#) else 0 end
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> < DLffin then abs(#preservesinglequotes(difd2)#) else 0 end )
												from DLaboralesEmpleado a, DatosEmpleado b, RHTipoAccion c, #reporte#
												where  a.DEid = #reporte#.DEid
													and a.DEid = b.DEid
													and a.RHTid = c.RHTid
													and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
															or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">	between a.DLfvigencia and a.DLffin
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">	between a.DLfvigencia and a.DLffin
														)
													and RHTcomportam in (3, 4, 5)    <!---- 3= Vac   4= Permiso  5= Incap ---->
												) 
											* PEhjornada ) 
										,0)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update #reporte#
				set horas = horas - coalesce( ( (select  	sum(<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">
																+1 
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> > DLfvigencia then abs(#preservesinglequotes(difd1)#) else 0 end
																- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> < DLffin then abs(#preservesinglequotes(difd2)#) else 0 end )
												from DLaboralesEmpleado a, DatosEmpleado b, RHTipoAccion c
												where  a.DEid = #reporte#.DEid
													and a.DEid = b.DEid
													and a.RHTid = c.RHTid
													and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
															or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">	between a.DLfvigencia and a.DLffin
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">	between a.DLfvigencia and a.DLffin
														)
													and RHTcomportam in (3, 4, 5)    <!---- 3= Vac   4= Permiso  5= Incap ---->
												) 
											* PEhjornada ) 
										,0)
				from  HPagosEmpleado d, CalendarioPagos e
				where d.DEid = #reporte#.DEid
					and d.PEtiporeg = 0
					and e.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and e.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
					and e.CPmes =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
					and e.CPid = d.RCNid
		</cfquery>
	</cfif>
	
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set horas = case when  horas < 0 then 0 else horas end
	</cfquery>
	<!---- Modificación SÓLO para el caso de Semanales
	 si la periodicidad es semanal y la cantidad de horas mayor a 208, entonces la cantidad de horas será siempre 208---->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set horas = 208
		where DEid in (	select DEid from DLaboralesEmpleado a, TiposNomina b
						where a.Tcodigo = b.Tcodigo
							and b.Ttipopago = 0
						)
			and horas > 208
	</cfquery>
	<!---- Actualizar el monto de salario tomando en cuenta las incidencias aplicadas ---->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set salario = salario + coalesce((select sum(ic.ICmontores)
												from HIncidenciasCalculo ic, 
													CalendarioPagos c,
													CIncidentes ci
												where ic.DEid = #reporte#.DEid
												  and c.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
												  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
												  and ic.RCNid = c.CPid
												  and ci.CIid = ic.CIid
												  and ci.CInocargasley = 0)
									, 0.00)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce((select sum(ic.ICmontores)
										from IncidenciasCalculo ic, 
											CalendarioPagos c,
											CIncidentes ci
										where ic.DEid = #reporte#.DEid
										  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
										  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
										  and ic.RCNid = c.CPid
										  and ci.CIid = ic.CIid
										  and ci.CInocargasley = 0	)
								, 0.00)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set salario = round(salario,0)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set dias = 1 
		where salario < 100 
			and salario > 0
	</cfquery>
	<!---actualiza incapacidades CCSS--->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '03'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  (	(sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin)
								 )
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0
							and  rh.RHTcomportam = 5 
							and rh.RHTdatoinforme in ('MAT', 'SEM')
					)
	</cfquery>	
	<!----actualiza incapacidades INS---->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '04'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  (	(sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  between sp.DLfvigencia and sp.DLffin) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin)
								  )
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0
							and  rh.RHTcomportam = 5 
							and rh.RHTdatoinforme = 'INS'
					)
	</cfquery>
	<!----actualiza Vacaciones ---->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '05'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
								   or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
								   or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin))
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0 
							and  rh.RHTcomportam = 3
					)
	</cfquery>
	<!----/*actualiza Permisos */---->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '06'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin))
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0 
							and  rh.RHTcomportam = 4	
					)
	</cfquery>
	<!----/*actualiza ingreso*/----->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '01'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and sp.DLestado = 0 
							and  rh.RHTcomportam = 1
					)
	</cfquery>
	<!----/*actualiza egresos*/---->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '02'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh 
						where #reporte#.DEid =  sp.DEid
						and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
						and  sp.RHTid = rh.RHTid 
						and  sp.Ecodigo = rh.Ecodigo 
						and  sp.DLestado = 0 
						and  rh.RHTcomportam = 2
					)
	</cfquery>
	<!-----/*actualiza jornadas completas*/----->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set jornada = '01'
		where exists (	select 1
						from LineaTiempo b, RHJornadas a
						where b.DEid = #reporte#.DEid 
						  and b.LThasta = (	select max(lt.LThasta) 
											from LineaTiempo lt
											where lt.DEid = #reporte#.DEid 
												and (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between lt.LTdesde and lt.LThasta 
														or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between lt.LTdesde and lt.LThasta
													)
										   )
						  and a.RHJid = b.RHJid and a.RHJhoradiaria >= 8
					)
	</cfquery>	
	<!----/*actualiza jornadas incompletas*/--->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set jornada = '02' 
		where exists (	select 1
						from LineaTiempo b, RHJornadas a
						where b.DEid = #reporte#.DEid 
							and b.LThasta = (	select max(lt.LThasta) 
												from LineaTiempo lt
												where lt.DEid = #reporte#.DEid 
													and (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between lt.LTdesde and lt.LThasta 
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between lt.LTdesde and lt.LThasta
														)
											)
							and a.RHJid = b.RHJid and a.RHJhoradiaria < 8)
	</cfquery>
	<!----/*actualiza jornadas de destajo*/---->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set jornada = '04'
		where exists(	select '04' 
						from LineaTiempo b, RHJornadas a
						where b.DEid = #reporte#.DEid 
							and b.LThasta = (	select max(lt.LThasta) from LineaTiempo lt
												where lt.DEid = #reporte#.DEid 
													and (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between lt.LTdesde and lt.LThasta 
															or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between lt.LTdesde and lt.LThasta
														)
											)
							and a.RHJid = b.RHJid and a.RHJornadahora = 1)
	</cfquery>
	<!----/* se borra a los funcionarios que fueron cesados antes de este mes pero que ses pago algo en este periodo */---->
	<cfquery datasource="#session.DSN#">
		delete #reporte# 
		where not exists (select 1 
						from LineaTiempo lt 
						where lt.DEid = #reporte#.DEid 
							and lt.LThasta >=<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">)
	</cfquery>
	<!-----/* inserta la cuarta linea */----->
	<cf_dbfunction name="to_char" args="salario"  	returnvariable="salario">
	<cf_dbfunction name="to_char" args="dias"  		returnvariable="dias">
	<cf_dbfunction name="to_char" args="horas"  	returnvariable="horas">
	<cf_dbfunction name="to_char" args="ocupacion"  returnvariable="ocupacion">
	
	
	<!----============================= ORACLE =============================---->
	<cfif isdefined("Application.dsinfo") and Application.dsinfo[session.dsn].type is 'oracle'>
	
		<cfquery datasource="#session.DSN#">
			update #reporte#
			set salario2 = ltrim(to_char(salario, '999999999.00'))
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update #reporte#
			set cedula = lpad(cedula,10,'0')
			where len(rtrim(cedula)) < 10
		</cfquery>
	
		<cfquery datasource="#session.DSN#">
			insert into #reporte1# (ordenado, salida)
			select 	4, 			
					rpad(<cf_dbfunction name="string_part"   args="cedula,1,15">,15)
					||rpad(<cf_dbfunction name="string_part"   args="numseguro,1,25">,25,' ')
					||rpad(<cf_dbfunction name="string_part"   args="nombre,1,15">,15,' ')
					||rpad(<cf_dbfunction name="string_part"   args="apellido1,1,15">,15,' ')
					||rpad(<cf_dbfunction name="string_part"   args="apellido2,1,15">,15,' ')
					|| lpad('0', 13-char_length(salario2), '0') 
					||salario2
					||lpad(to_char(dias),3,'0')
					||lpad(to_char(horas),4,'0')
					||jornada
					||condicion	
					||lpad(<cf_dbfunction name="string_part"   args="ocupacion,1,4">,5,'0')
				
					as salida				
			from #reporte#
			where salario > 0
				and (	
						(	dias > 0 
							or 	(
									dias = 0 
									and condicion in ('03','04')
								)
						)
					)	
			order by nombre
		</cfquery>
	<cfelse><!----============================= SYBASE =============================---->
		<cfquery datasource="#session.DSN#">
			insert into #reporte1# (ordenado, salida)
			select 	4, 				
					convert(char(10),cedula) +
					convert(char(25),numseguro) +
					convert(char(15),nombre) +
					convert(char(15),apellido1) +
					convert(char(15),apellido2) +
					replicate('0', 13-datalength(ltrim(rtrim(convert(char,salario))))) + ltrim(rtrim(convert(char(13),salario))) +
					replicate('0', 3-datalength(ltrim(rtrim(convert(char,dias))))) + ltrim(rtrim(convert(char(3),dias))) +
					replicate('0', 4-datalength(ltrim(rtrim(convert(char,horas))))) + ltrim(rtrim(convert(char(4),horas))) +
					jornada+
					condicion+
					replicate('0', 4-datalength(ltrim(rtrim(convert(char,ocupacion))))) + ltrim(rtrim(convert(char(5), ocupacion))) as salida				
			from #reporte#
			where salario > 0
				and (	(
							dias > 0 
							or (	dias = 0 and condicion in ('03','04')
								)
						)
					)	
			order by nombre
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="inSQL" datasource="#session.dsn#">
		insert into #reporte1# (ordenado, salida)
			select 	4, 'No existen datos asociados a la póliza seleccionada	'
	</cfquery>	
</cfif>
	<cfquery name="ERR" datasource="#session.DSN#">
		select salida from #reporte1# 
		order by ordenado
	</cfquery>
