<!---
-----Script para determinar Constancias de Salario
-----Hecho por: Juan Carlos Gutiérrez
-----02/02/2005
--->

<!--- parametros fijos --->
<cfset pDEidentificacion = rsData.DEidentificacion >
<cfset pFecha 		 	 = rsData.fecha >
<!--- --->

<cfset salario_promedio 	= 0  >
<cfset salario_base 		= 0  >
<cfset fechaingreso 		= '' >
<cfset fechasalida 			= '' >
<cfset deducciones_emp 		= 0  >
<cfset deducciones 			= 0  >
<cfset embargos 			= '' >
<cfset asociacion 			= 0  >
<cfset asociacion_promedio	= 0  >
<cfset asociacion_base 		= 0  >
<cfset cargas_promedio 		= 0  >
<cfset cargas_base 			= 0  >
<cfset labora 				= '' >
<cfset pension 				= ''>
<cfset fechaL 				= ''>

<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid"					type="numeric"  		mandatory="no">
	<cf_dbtempcol name="nombre"					type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="identificacion"			type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="empresa"				type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="fechaingreso"			type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="puesto"					type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="fechasalida"			type="varchar(50)"		mandatory="no">
	<cf_dbtempcol name="cargas_promedio"		type="money"			mandatory="no">	
	<cf_dbtempcol name="deducciones_monto"		type="money"  			mandatory="no">
	<cf_dbtempcol name="salario_promedio"		type="money"			mandatory="no">
	<cf_dbtempcol name="asociacion_promedio"	type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_promedio_ded"	type="money"			mandatory="no">
	<cf_dbtempcol name="salario_base"			type="money"  			mandatory="no">
	<cf_dbtempcol name="cargas_base"			type="money"  			mandatory="no">
	<cf_dbtempcol name="asociacion_base"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_base_ded"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_promedio"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_base"			type="money"			mandatory="no">
	<cf_dbtempcol name="embargo"				type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="labora"					type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="pension"				type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="fecha"					type="varchar(100)"		mandatory="no"><!---Fecha en letras---->
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #datos# ( DEid, nombre , identificacion , empresa , fechaingreso , puesto )
	select 	DEid, 
			{fn concat( {fn concat( {fn concat(	{fn concat(DEapellido1, ' ') }, DEapellido2 )}, ' ' )}, DEnombre)},
			DEidentificacion, 
			Edescripcion, 
			null, 
			null

	from DatosEmpleado a, Empresas e

	where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
	and a.Ecodigo = e.Ecodigo
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
</cfquery>

<cfquery datasource="#session.DSN#">
	update #datos#
	set puesto = ( 	select c.RHPdescpuesto
					from LineaTiempo b, RHPuestos c, RHTipoAccion d
					where b.DEid=#datos#.DEid 
					  and b.RHPcodigo = c.RHPcodigo
					  <!---and (b.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )---->
					  and b.LTdesde = (select max(LTdesde) 
               			 				from LineaTiempo a 
										where a.DEid = b.DEid) 
					  and d.RHTid = b.RHTid 
					  and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
					  and c.Ecodigo = b.Ecodigo
					  and d.Ecodigo = b.Ecodigo )
	
	where exists( 	select 1
					from LineaTiempo b, RHPuestos c, RHTipoAccion d
					where b.DEid=#datos#.DEid 
						and b.RHPcodigo = c.RHPcodigo
						<!----and (b.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )----->
						and b.LTdesde = (select max(LTdesde) 
										from LineaTiempo a 
										where a.DEid = b.DEid)
						and d.RHTid = b.RHTid 
						and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
						and c.Ecodigo = b.Ecodigo
						and d.Ecodigo = b.Ecodigo )
</cfquery>

<!--- REVISA SI EL EMPLEADO ESTÁ ACTIVO --->
<cfquery name="rsFechaSalida" datasource="#session.DSN#">
	select max(LThasta) as fechasalida
	from #datos# a, LineaTiempo b,  RHTipoAccion d
	where a.DEid = b.DEid 
	and d.RHTid = b.RHTid
</cfquery>
<cfset fechasalida = rsFechaSalida.fechasalida >

<cfquery datasource="#session.DSN#">
	update #datos#
	set fechaingreso =  ( 	select max(b.DLfvigencia)
							from DLaboralesEmpleado b, RHPuestos c, RHTipoAccion d
							where b.DEid = #datos#.DEid
							  and b.RHPcodigo = c.RHPcodigo
							  <cfif len(trim(fechasalida)) and datecompare(fechasalida, now()) lt 0 >
							  	and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechasalida#"> or b.DLffin is null)
							 <cfelse>
							 	and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or b.DLffin is null)		
							 </cfif>							  					  
							  and d.RHTid = b.RHTid 
							  and d.RHTcomportam = 1
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
							  and c.Ecodigo = b.Ecodigo
							  and d.Ecodigo = b.Ecodigo )
	
	where exists ( 	select 1
					from DLaboralesEmpleado b, RHPuestos c, RHTipoAccion d
					where #datos#.DEid = b.DEid 
						and b.RHPcodigo = c.RHPcodigo
						 <cfif len(trim(fechasalida)) and datecompare(fechasalida, now()) lt 0 >
							and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechasalida#"> or b.DLffin is null)
						 <cfelse>
							and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or b.DLffin is null)		
						 </cfif>
						and d.RHTid = b.RHTid 
						and d.RHTcomportam = 1
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
						and c.Ecodigo = b.Ecodigo
						and d.Ecodigo = b.Ecodigo )
</cfquery>

<cfquery datasource="#session.DSN#" name="rsFechaIngreso">
	select fechaingreso from #datos#
</cfquery>
<cfset fechaingreso = rsFechaIngreso.fechaingreso>

<!---Fecha de ingreso en letras--->
<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechaingresoL">
	<cfinvokeargument name="Fecha" value="#dateformat(pfecha,'dd/mm/yyyy')#"/>
</cfinvoke>
<cfset fechaingreso = fechaingresoL>

<!----Fecha en letras del parametro: pFecha--->
<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechaL">
	<cfinvokeargument name="Fecha" value="#dateformat(pFecha,'dd/mm/yyyy')#"/>
</cfinvoke>

<cfif len(trim(fechasalida)) and datecompare(fechasalida, now()) lt 0 >
	<cfset embargos = 'INACTIVO' >
	<cfset labora = 'Laboró' >
	
	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
		<cfinvokeargument name="Fecha" value="#dateformat(fechasalida,'dd/mm/yyyy')#"/>
	</cfinvoke>
	<cfset fechasalida = ' hasta el #vFechaEnLetras#' >

<cfelse>
	<cfset fechasalida = '' >
	<cfset labora = 'Labora' >

	<!--- CALCULA SALARIO BASE --->
	<cfquery name="rsSalarioBase" datasource="#session.DSN#">
		select coalesce(LTsalario  ,0) as LTsalario
		from LineaTiempo a, #datos# b
		where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta 
		and a.DEid = b.DEid
	</cfquery>
	<cfif len(trim(rsSalarioBase.LTsalario))>
		<cfset salario_base = rsSalarioBase.LTsalario >
	</cfif>
	
	<!--- CALCULA SALARIO PROMEDIO --->
	<cfquery name="rsSalarioPromedio" datasource="#session.DSN#">
		select coalesce(avg(PEsalario) ,0) as PEsalario
		from HPagosEmpleado a, #datos# b
		where PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-3,now())#">     <!---3 = Cantidad de Meses a Calcular --->
		and a.DEid = b.DEid
	</cfquery>
	<cfif len(trim(rsSalarioPromedio.PEsalario))>
		<cfset salario_promedio = rsSalarioPromedio.PEsalario >
	</cfif>
	
	<!--- Incidencias --->
	<cfquery name="rsIncidencias" datasource="#session.DSN#">
		select coalesce((avg(SEincidencias )*2), 0) as SEincidencias
		from HSalarioEmpleado a, #datos# b, HRCalculoNomina c
		where c.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-3,now())#">
		and a.DEid = b.DEid
		and c.RCNid = a.RCNid
	</cfquery>
	<cfif len(trim(rsIncidencias.SEincidencias))>
		<cfset salario_promedio = salario_promedio + rsIncidencias.SEincidencias >
	</cfif>

	<!---  CALCULA DEDUCCIONES --->
	<cfquery name="rsDeducciones" datasource="#session.DSN#">
		select  coalesce(sum(DCvalor),0) as DCvalor
		from HDeduccionesCalculo a, #datos# b
		where a.DEid = b.DEid
		and RCNid = (	select max(RCNid) 
						from HPagosEmpleado 
						where DEid = b.DEid )
	</cfquery>
	<cfif len(trim(rsDeducciones.DCvalor))>
		<cfset deducciones = rsDeducciones.DCvalor >
	</cfif>
	
	<!---  CALCULA Asociacion --->
	<cfquery name="rsAsociacion" datasource="#session.DSN#">
		select coalesce(DCvaloremp,0) as DCvaloremp
		from CargasEmpleado a, DCargas b, #datos# c
		where a.DEid = c.DEid
		and a.DClinea = b.DClinea
		and upper(b.DCcodigo) = 'ASOC'
	</cfquery>
	<cfif len(trim(rsAsociacion.DCvaloremp))>
		<cfset asociacion = rsAsociacion.DCvaloremp >
	</cfif>
	
	<!--- CALCULA Embargo --->
	<cfquery name="rsEmbargos" datasource="#session.DSN#">
		select case coalesce(sum(h.DCvalor),0) when 0 then 'libre de embargos' else 'embargado(a)' end as DCvalor
		   from HDeduccionesCalculo h, DatosEmpleado de, DeduccionesEmpleado d, TDeduccion t
		where  h.DEid = de.DEid
			 and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#">
			 and h.DEid = d.DEid
			 and h.Did = d.Did
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between d.Dfechaini and d.Dfechafin
			 and d.TDid = t.TDid
			 and d.Ecodigo = t.Ecodigo
			 and upper(t.TDcodigo) like 'EMB%'
			 <!----******************************  En el script ***********************************--->
			 and d.Dactivo = 1
	</cfquery>
	<cfif len(trim(rsEmbargos.DCvalor))>
		<cfset embargos = rsEmbargos.DCvalor >
	</cfif>
	
	<!----CALCULA Pension ---->
	<cfquery name="rsPension" datasource="#session.DSN#">
		select 	case isnull(sum(h.DCvalor),0) when 0 then 'libre de embargos y  pensiones' 
				else 'aplicando pensión alimenticia' end as Pension
		from HDeduccionesCalculo h, DatosEmpleado de, DeduccionesEmpleado d, TDeduccion t 
		where  h.DEid = de.DEid
			and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#">
			and h.DEid = d.DEid
			and h.Did = d.Did
			and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between d.Dfechaini and d.Dfechafin
			and d.TDid = t.TDid
			and d.Ecodigo = t.Ecodigo
			and upper(t.TDcodigo) like  '%PEN%'
			and upper(t.TDcodigo) !=  'PENSV'
			and d.Dactivo = 1
	</cfquery>
	<cfif rsPension.RecordCount NEQ 0 and len(trim(rsPension.Pension))>
		<cfset pension = rsPension.Pension>
	</cfif>
</cfif>

<!--- Despliegue para cargar variables de pantalla --->
<cfset deducciones 			= deducciones*2 >
<cfset asociacion_promedio 	= (salario_promedio * asociacion) / 100 >
<cfset asociacion_base 		= (salario_base * asociacion) / 100 >
<cfset cargas_promedio 		= salario_promedio * 0.09 >
<cfset cargas_base 			= salario_base * 0.09 >

<!--- lista de meses consu respectica traduccion para el idioma en session--->
<!---
<cfquery name="meses" datasource="#session.dsn#">
	select VSdesc as m
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	order by <cf_dbfunction name="to_number" args="b.VSvalor">
</cfquery>
<cfset lmeses = valuelist(meses.m) >

<cfif listlen(lmeses) gte month(fechaingreso) >
	<cfset elmes = Listgetat(lmeses, month(fechaingreso)) >
<cfelse>
	<cfset elmes = monthasstring(month(fechaingreso)) >
</cfif>

<cfset lafecha = '#day(fechaingreso)# de #elmes# del #year(fechaingreso)#' >
--->

<!---<cfset fechaingreso = dateformat(fechaingreso,'dd/mm/yyyy') >--->
<cfquery datasource="#session.DSN#">
	update #datos#
	set	fechaingreso = '#fechaingreso#', 
		fechasalida = '#fechasalida#', 
		deducciones_monto = #deducciones#,
		salario_promedio = #salario_promedio#,
		cargas_promedio = #cargas_promedio#,
		asociacion_promedio = #asociacion_promedio#,
		liquido_promedio_ded = #salario_promedio - cargas_promedio - deducciones - asociacion_promedio#, 
		salario_base = #salario_base#,
		cargas_base = #cargas_base#,
		asociacion_base = #asociacion_base#,
		liquido_base_ded = #salario_base - cargas_base - deducciones - asociacion_base#, 
		liquido_promedio = #salario_promedio - cargas_promedio#, 
		liquido_base = #salario_base - cargas_base#, 
		embargo = '#embargos#',
		labora = '#labora#',
		pension = '#pension#',
		fecha = '#fechaL#'
</cfquery>

<cfquery name="rsQuery" datasource="#session.DSN#">
	select 	DEid,
			nombre, 
			identificacion, 
			empresa,  
			fechaingreso, 
			fechasalida, 
			puesto, 
			deducciones_monto as deducciones,
			salario_promedio,
			cargas_promedio,
			asociacion_promedio,
			liquido_promedio_ded, 
	
			salario_base,
			cargas_base,
			asociacion_base,
			liquido_base_ded, 
	
			liquido_promedio, 
			liquido_base, 
			embargo,
			labora,
			pension,
			fecha
	from #datos#
</cfquery>
