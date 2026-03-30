<!---  
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
	N° de Telefono	Alfanumérico	7		Telefono del patrono. 
	N° de Fax   	Alfanumérico	7		Fax del patrono. 

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
	Días Laborados	Numérico		2		Días Laborados De 0 a 30 días
	Horas			Numérico		4		Horas laboradas Ceros
	Jornada			Numerico		2		Tipo de Jornada (01: Jornada de 8 o mas horas, 02: Jornadas de menos de 8 horas, 03: Contratos especiales, 04: Destajo)
	Condición Lab.  Numerico		2		Condiciones Especiales (00: Sin Cambios, 01: Ingresos, 02: Exclusiones, 03: Incapac. CCSS, 04: Incap. INS, 05: Vacaciones, 06: Permisos)
	Ocupación		Alfanumérico	5		Ocupación Código según lista de puestos del INS
 --->
<cfquery name="rsRHParametros" datasource="#session.DSN#">
	select  d.Pvalor, 
	a.Etelefono1, 
	a.Efax, 
	a.Eidentificacion, 
	c.direccion1
	from Empresa a, Empresas b, Direcciones c, RHParametros d
	where a.Ecodigo = b.EcodigoSDC
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.id_direccion = c.id_direccion
	and d.Pcodigo = 420 
	and d.Ecodigo = b.Ecodigo  
</cfquery>
<cfset Poliza = rsRHParametros.Pvalor>
<cfset Etelefono1 = rsRHParametros.Etelefono1>
<cfset Efax = rsRHParametros.Efax>
<cfset Eidentificacion = rsRHParametros.Eidentificacion>
<cfset Direccion1 = rsRHParametros.direccion1>

<cfquery name="rscheck1" datasource="#session.DSN#">
	select min(CPdesde) as f1
	   from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset bf1 = rscheck1.f1>

<cfquery name="rscheck2" datasource="#session.DSN#">
	select  max(CPhasta) as f2 
	   from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset bf2 = rscheck2.f2>



<cftransaction>
	<cf_dbtemp name="reporte" returnvariable="reporte" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="poliza"  	type="varchar(7)" 	mandatory="no">
		<cf_dbtempcol name="tipoP"  	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="tipoC"  	type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="cedula"  	type="varchar(15)" 	mandatory="no">
		<cf_dbtempcol name="numseguro"  type="varchar(15)" 	mandatory="no">
		<cf_dbtempcol name="nombre"  	type="char(15)" 	mandatory="no">
		<cf_dbtempcol name="apellido1"  type="char(15)"  	mandatory="no">
		<cf_dbtempcol name="apellido2" 	type="char(15)" 	mandatory="no">
		<cf_dbtempcol name="salario" 	type="money" 		mandatory="no">
		<cf_dbtempcol name="dias"	   	type="int"  		mandatory="no">
		<cf_dbtempcol name="horas" 		type="char(3)"  	mandatory="no">
		<cf_dbtempcol name="ocupacion" 	type="char(5)" 	mandatory="no">
		<cf_dbtempcol name="puesto" 	type="char(10)" 	mandatory="no">
		<cf_dbtempcol name="jornada" 		type="char(2)"  	mandatory="no">
		<cf_dbtempcol name="condicion" 		type="char(2)"  	mandatory="no">
	</cf_dbtemp>
	
	<cf_dbtemp name="reporte1" returnvariable="reporte1" datasource="#session.dsn#">
		<cf_dbtempcol name="ordenado"	type="int"  			mandatory="no">
		<cf_dbtempcol name="salida"  	type="varchar(200)" 	mandatory="no">
	</cf_dbtemp>
	 <!--- inserta la primera linea  --->
	<cfquery datasource="#session.DSN#">
		insert into #reporte1# (ordenado, salida)
		select 1,
		'#Poliza#' || 'M' || convert(char(4), #url.CPperiodo#) || 
		replicate('0', 2-datalength(ltrim(rtrim(convert(char,#url.CPmes#))))) || ltrim(rtrim(convert(char(2),#url.CPmes#))) ||
		' ' || '#Eidentificacion#' || '#Etelefono1#' || '#Efax#'
	</cfquery>
	
	<!--- inserta la segunda linea  --->
	<cfquery datasource="#session.DSN#">
		insert into #reporte1# (ordenado, salida)
		select
		2,
		'#direccion1#'
	</cfquery>
	 <!--- inserta la tercera linea  --->
	<cfquery datasource="#session.DSN#">
		insert into #reporte1# (ordenado, salida)
		select 3, ' '
	</cfquery>
	

	<!--- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado  --->
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP, dias, horas, ocupacion, salario, puesto, condicion, jornada)
		select 
			e.NTIcodigo, 
			h.DEid ,
			coalesce(e.DEsegurosocial,DEdato3,e.DEidentificacion),
			e.DEnombre,
			e.DEapellido1,
			e.DEapellido2,
			e.DEidentificacion,
			'0000000',
			'M',       
			0,
			'0000','',
			sum(h.SEsalariobruto),
			null, '00', '00'
		from CalendarioPagos c <cf_dbforceindex name="CalendarioPagos_01">, HSalarioEmpleado h, DatosEmpleado e
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		  and c.CPid = h.RCNid 
		  and h.DEid = e.DEid 
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		group by  e.NTIcodigo, h.DEid, e.DEidentificacion, e.DEnombre, e.DEapellido1,e.DEapellido2
	</cfquery>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto, condicion, jornada)
		select 
			e.NTIcodigo, 
			dl.DEid ,
			e.DEidentificacion,
			e.DEnombre,
			e.DEapellido1,
			e.DEapellido2,
			e.DEidentificacion,
			'0000000',
			'M',       
			0,
			'0000','',
			0,
			null, '00', '00'
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and dl.DLfechaaplic 
		  	between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
		  	and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> 
		  and ta.RHTid = dl.RHTid
		  and ta.RHTcomportam = 2
		  and e.DEid = dl.DEid
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and not exists(select 1 from #reporte# r where r.DEid = e.DEid)
	</cfquery>	
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
		select 
			e.NTIcodigo, 
			dl.DEid ,
			e.DEidentificacion,
			e.DEnombre,
			e.DEapellido1,
			e.DEapellido2,
			e.DEidentificacion,
			'0000000',
			'M',       
			0,
			'001','',
			0,
			null
		from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
		where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and dl.DLfechaaplic between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">  
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> 
		  and dl.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
		  and ta.RHTid = dl.RHTid
		  and ta.RHTcomportam = 2
		  and e.DEid = dl.DEid
		  and not exists(select 1 from #reporte# r where r.DEid = e.DEid)
		
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
						   and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between lt.LTdesde and lt.LThasta)
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
					where lt.DEid = #reporte#.DEid)
				)
		where puesto is null
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set ocupacion = RHPEcodigo
		from RHPuestos r
			inner join RHPuestosExternos o
				on o.RHPEid = r.RHPEid
				and o.Ecodigo = r.Ecodigo
		where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and r.RHPcodigo = #reporte#.puesto
	</cfquery>
	<cfquery datasource="#session.DSN#">	
		update #reporte#
		set ocupacion = '00000'
		where ocupacion is null or ocupacion = ''	
	</cfquery>
				
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set dias =	(
			select coalesce(sum(a.PEcantdias),0) 
			from  HPagosEmpleado a
				inner join CalendarioPagos c
					on c.CPid = a.RCNid
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
					and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
			where a.DEid = #reporte#.DEid
			  and a.PEmontores > 0
			  and a.PEtiporeg = 0
		)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
		set dias = (case when dias  > 24 then 24 else dias end)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = coalesce(
				(select sum(se.PEmontores)
					from PagosEmpleado se
					inner join CalendarioPagos c
					  on c.CPid = se.RCNid
						and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
						and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#"> 
					where se.DEid = #reporte#.DEid)
				, 0)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = coalesce(
				(select sum(se.PEmontores)
					from PagosEmpleado se
					inner join CalendarioPagos c
					  on c.CPid = se.RCNid
						and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
						and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
					where se.DEid = #reporte#.DEid)
				, 0)
	</cfquery>

	 <!--- Actualizar el monto de salario tomando en cuenta las incidencias aplicadas --->
	 <cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce(
			(select sum(ic.ICmontores)
			from HIncidenciasCalculo ic 
				inner join 	CalendarioPagos c
				  on ic.RCNid = c.CPid
				    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				    and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			    	and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
				inner join 	CIncidentes ci
				  on  ci.CIid = ic.CIid
				  and ci.CInocargas = 0
			where ic.DEid = #reporte#.DEid), 0.00)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce(
			(select sum(ic.ICmontores)
			from IncidenciasCalculo ic 
				inner join 	CalendarioPagos c
				  on ic.RCNid = c.CPid
				    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				    and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
			    	and c.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
				inner join 	CIncidentes ci
				  on  ci.CIid = ic.CIid
				  and ci.CInocargas = 0
			where ic.DEid = #reporte#.DEid), 0.00)
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #reporte# set salario = round(salario,0)
	</cfquery>	
	<cfquery datasource="#session.DSN#">
		update #reporte# set dias = 1 where salario < 100 and salario > 0
	</cfquery>

	<!--- actualiza incapacidades CCSS --->
	<cfquery datasource="#session.DSN#">

		update #reporte# set condicion = '03'
		where exists(select 1 from DLaboralesEmpleado sp
		  					  inner join RHTipoAccion rh
							    on  sp.RHTid = rh.RHTid 
								and sp.Ecodigo = rh.Ecodigo 
								and rh.RHTcomportam = 5 
								and rh.RHTdatoinforme in ('MAT', 'SEM')
			where #reporte#.DEid =  sp.DEid 
			and sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and sp.DLestado = 0
			and ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">  
			   and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
			   or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
			   and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> between sp.DLfvigencia and sp.DLffin) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between sp.DLfvigencia and sp.DLffin)))
	</cfquery>
	
	<!--- actualiza incapacidades INS --->
	<cfquery datasource="#session.DSN#">
		update #reporte# set condicion = '04'
		where exists(select 1 from DLaboralesEmpleado sp
		  						inner join RHTipoAccion rh
								  on  sp.RHTid = rh.RHTid 
								  and sp.Ecodigo = rh.Ecodigo 
								  and rh.RHTcomportam = 5 
								  and rh.RHTdatoinforme = 'INS'
								where #reporte#.DEid =  sp.DEid 
								  and sp.DLestado = 0
								  and sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">
								  and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
								  or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
								      and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> between sp.DLfvigencia and sp.DLffin) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between sp.DLfvigencia and sp.DLffin))
)
	</cfquery>
	
		<!--- actualiza Vacaciones --->
	<cfquery datasource="#session.DSN#">
		update #reporte# set condicion = '05'
		where exists(select 1 from DLaboralesEmpleado sp
		 				inner join RHTipoAccion rh
						  on  sp.RHTid   = rh.RHTid 
						  and sp.Ecodigo = rh.Ecodigo 
						  and rh.RHTcomportam = 3
						where #reporte#.DEid = sp.DEid 
						  and sp.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and sp.DLestado = 0 
						  and ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
						    or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">) 
				   		    or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> between sp.DLfvigencia and sp.DLffin) or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between sp.DLfvigencia and sp.DLffin))
						)
	</cfquery>
	
	<!--- actualiza Permisos ---> 
	<cfquery datasource="#session.DSN#">
		update #reporte# set condicion = '06'
		where exists(select 1 from DLaboralesEmpleado sp 
						inner join RHTipoAccion rh
						  on  sp.RHTid   = rh.RHTid 
						  and sp.Ecodigo = rh.Ecodigo 
						  and rh.RHTcomportam = 4	
			where #reporte#.DEid = sp.DEid 
			and  sp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and  sp.DLestado = 0
			and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> ) 
			 or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> ) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">  between sp.DLfvigencia and sp.DLffin) 
				   or (<cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">  between sp.DLfvigencia and sp.DLffin))
			)
	</cfquery>	
	
	<!--- actualiza ingreso --->
	<cfquery datasource="#session.DSN#">		
		update #reporte# set condicion = '01'
		where exists(select 1 from DLaboralesEmpleado sp
			inner join RHTipoAccion rh
			  on sp.RHTid = rh.RHTid
			  and sp.Ecodigo = rh.Ecodigo 
			  and sp.DLestado = 0 
			where #reporte#.DEid =  sp.DEid 
			and sp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and rh.RHTcomportam = 1
			and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
			and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#">
			)
	</cfquery>	
		
	<!--- actualiza egresos --->
	<cfquery datasource="#session.DSN#">
		update #reporte# set condicion = '02'
		where exists(select 1 from DLaboralesEmpleado sp 
								inner join  RHTipoAccion rh 
								  on sp.Ecodigo = rh.Ecodigo  
								  and  rh.RHTcomportam = 2
								where #reporte#.DEid = sp.DEid
								and sp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
								and <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> 
								and sp.RHTid = rh.RHTid 
								and sp.DLestado = 0)
	</cfquery>	
		
	<!--- actualiza jornadas completas --->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set jornada = '01'
			where exists (select 1
				from LineaTiempo b
				  inner join  RHJornadas a
				  on a.RHJid = b.RHJid 
				  and a.RHJhoradiaria >= 8
				where b.DEid = #reporte#.DEid 
				  and b.LThasta = (select max(lt.LThasta) from LineaTiempo lt
									where lt.DEid = #reporte#.DEid 
									  and (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> between lt.LTdesde and lt.LThasta 
									  or  <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between lt.LTdesde and lt.LThasta))
				  )
	</cfquery>	
			
	<!--- actualiza jornadas incompletas --->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set jornada = '02' 
			where exists (select 1
							from LineaTiempo b 
							inner join RHJornadas a
							  on  a.RHJid = b.RHJid 
							  and a.RHJhoradiaria < 8
							where b.DEid = #reporte#.DEid 
							  and b.LThasta = (select max(lt.LThasta) 
							  					from LineaTiempo lt
												where lt.DEid = #reporte#.DEid 
												and (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> 
												between lt.LTdesde and lt.LThasta 
												or <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between lt.LTdesde and lt.LThasta))
							  )

	</cfquery>			

	<!--- actualiza jornadas de destajo --->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set jornada = '04'
			where exists(select '04' 
				from LineaTiempo b 
				inner join RHJornadas a
				  on  a.RHJid = b.RHJid 
				  and a.RHJornadahora = 1
				where b.DEid = #reporte#.DEid 
				  and b.LThasta = (	select max(lt.LThasta) 
				  					from LineaTiempo lt
									where lt.DEid = #reporte#.DEid 
									  and (<cfqueryparam cfsqltype="cf_sql_date" value="#bf1#"> between lt.LTdesde and lt.LThasta 
									  or <cfqueryparam cfsqltype="cf_sql_date" value="#bf2#"> between lt.LTdesde and lt.LThasta))
				  )
				  
	</cfquery>			
	<!--- se borra a los funcionarios que fueron cesados antes de este mes pero que ses pago algo en este periodo --->
	<cfquery datasource="#session.DSN#">
		delete #reporte# where not exists (select 1 from LineaTiempo lt where lt.DEid = #reporte#.DEid and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#bf1#">)
	</cfquery>	

	<!--- inserta la cuarta linea  --->
<!--- 	<cfquery datasource="#session.DSN#">	
		insert into #reporte1# (ordenado, salida)
		select 
			4, 
			case tipoC when 'C'  then '0' || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="cedula">)) else '1' || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="cedula">)) end ||
			replicate(' ',25 - {fn LENGTH(<cf_dbfunction name="to_char" args ="numseguro">)}) || ltrim(rtrim((<cf_dbfunction name="to_char" args ="numseguro">)) ||
			replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido1">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="apellido1">)) ||
			replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido2">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="apellido2">)) ||
			replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="nombre">)}) ||  ltrim(rtrim(<cf_dbfunction name="to_char" args ="nombre">)) ||
			replicate('0',13 - {fn LENGTH(<cf_dbfunction name="to_char" args ="salario">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="salario">)) ||
			replicate('0',3 - {fn LENGTH(<cf_dbfunction name="to_char" args ="dias">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="dias">)) ||
			horas||
			jornada||
			condicion||
			replicate('0', 5 - {fn LENGTH(<cf_dbfunction name="to_char" args ="ocupacion">)}) || ltrim(rtrim(<cf_dbfunction name="to_char" args ="ocupacion">))  
		from #reporte#
		order by nombre
	</cfquery>			 --->
	<cfquery datasource="#session.DSN#">	
		insert into #reporte1# (ordenado, salida)
		select 
			4, 
			case tipoC when 'C'  then '0' ||  <cf_dbfunction name="to_char" args ="cedula"> || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)}) else '1' || <cf_dbfunction name="to_char" args ="cedula"> || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)}) end ||
			<cf_dbfunction name="to_char" args ="numseguro"> || replicate(' ',25 - {fn LENGTH(<cf_dbfunction name="to_char" args ="numseguro">)}) ||
			<cf_dbfunction name="to_char" args ="apellido1"> || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido1">)}) ||
			<cf_dbfunction name="to_char" args ="apellido2"> || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido2">)}) ||
			<cf_dbfunction name="to_char" args ="nombre">    || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="nombre">)}) ||
			<cf_dbfunction name="to_char" args ="salario">   || replicate('0',13 - {fn LENGTH(<cf_dbfunction name="to_char" args ="salario">)}) ||
			<cf_dbfunction name="to_char" args ="dias">      || replicate('0', 3 - {fn LENGTH(<cf_dbfunction name="to_char" args ="dias">)}) ||
			horas||
			jornada||
			condicion||
			<cf_dbfunction name="to_char" args ="ocupacion">|| replicate('0', 5 - {fn LENGTH(<cf_dbfunction name="to_char" args ="ocupacion">)})  
		from #reporte#
		order by nombre
	</cfquery>			
	<!--- <cfquery name="ERR" datasource="#session.DSN#">
		select  
			<cf_dbfunction name="to_char" args ="poliza"> || replicate(' ',7 - {fn LENGTH(<cf_dbfunction name="to_char" args ="poliza">)}) || 'M'  || ' '  ||
			<cfqueryparam cfsqltype="cf_sql_char" value="#url.CPperiodo&repeatstring(' ',4-Len(url.CPperiodo))#"> || ' '  ||
			<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0',2-Len(url.CPmes))&url.CPmes#"> || 
			case tipoC when 'C'  
				then  '0' || <cf_dbfunction name="to_char" args ="cedula"> || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)})
				else  '1' || <cf_dbfunction name="to_char" args ="cedula"> || replicate(' ',14 - {fn LENGTH(<cf_dbfunction name="to_char" args ="cedula">)})
				end  ||
			<cf_dbfunction name="to_char" args ="numseguro"> || replicate(' ',25 - {fn LENGTH(<cf_dbfunction name="to_char" args ="numseguro">)}) ||
			<cf_dbfunction name="to_char" args ="nombre"> || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="nombre">)}) ||
			<cf_dbfunction name="to_char" args ="apellido1"> || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido1">)}) ||
			<cf_dbfunction name="to_char" args ="apellido2"> || replicate(' ',15 - {fn LENGTH(<cf_dbfunction name="to_char" args ="apellido2">)}) ||
			<cf_dbfunction name="to_char" args="right('0000000000000' || ltrim(rtrim(salario)),13)"> || ' ' ||
			<cf_dbfunction name="to_char" args ="dias"> || replicate(' ',2 - {fn LENGTH(<cf_dbfunction name="to_char" args ="dias">)}) || ' '  ||
			horas || replicate('0',5 - {fn LENGTH(<cf_dbfunction name="to_char" args ="ocupacion">)}) || ltrim(rtrim(ocupacion)) as salida
		from #reporte#
		order by nombre
	</cfquery>  --->
	
	
	<cfquery name="ERR" datasource="#session.DSN#">
		select salida from #reporte1# order by ordenado
	</cfquery> 
	
	<cfquery name="rsdrop" datasource="#session.DSN#">
		drop table #reporte#, #reporte1#
	</cfquery>
</cftransaction>