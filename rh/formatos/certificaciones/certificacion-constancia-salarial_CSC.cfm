<!---
-----Script para determinar Constancias de Salario
-----Hecho por: Juan Carlos GutiÃ©rrez
-----02/02/2005
--->

<!--- parametros fijos --->
<cfset pDEidentificacion = rsData.DEidentificacion >
<cfset pFecha 		 	 = rsData.fecha >


<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
		<cfinvokeargument name="Fecha" value="#dateformat(pFecha,'dd/mm/yyyy')#"/>
	</cfinvoke>
	<cfset fecha = ' #vFechaEnLetras#' >

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


<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid"					type="numeric"  		mandatory="no">
	<cf_dbtempcol name="nombre"					type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="identificacion"			type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="empresa"				type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="fechaingreso"			type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="puesto"					type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="cf"						type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="fechasalida"			type="varchar(50)"		mandatory="no">
	<cf_dbtempcol name="motivosalida"			type="varchar(50)"		mandatory="no">
	<cf_dbtempcol name="cargas_promedio"		type="money"			mandatory="no">	
	<cf_dbtempcol name="deducciones"			type="money"  			mandatory="no">
	<cf_dbtempcol name="salario_promedio"		type="money"			mandatory="no">
	<cf_dbtempcol name="asociacion_promedio"	type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_promedio_ded"	type="money"			mandatory="no">
	<cf_dbtempcol name="salario_base"			type="money"  			mandatory="no">
	<cf_dbtempcol name="cargas_base"			type="money"  			mandatory="no">
	<cf_dbtempcol name="asociacion_base"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_base_ded"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_promedio"		type="money"			mandatory="no">
	<cf_dbtempcol name="liquido_base"			type="money"			mandatory="no">
	<cf_dbtempcol name="renta_base"				type="money"			mandatory="no">
	<cf_dbtempcol name="renta_promedio"			type="money"			mandatory="no">
	<cf_dbtempcol name="embargo"				type="varchar(50)"  	mandatory="no">
	<cf_dbtempcol name="tipoembargo"			type="varchar(50)"  	mandatory="no">
	<cf_dbtempcol name="labora"					type="varchar(50)"  	mandatory="no">
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
					  and (b.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					  and d.RHTid = b.RHTid 
					  and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and c.Ecodigo = b.Ecodigo
					  and d.Ecodigo = b.Ecodigo ),
	cf = ( 	select CFdescripcion
					from LineaTiempo b, RHPlazas c, RHTipoAccion d, CFuncional e
					where b.DEid=#datos#.DEid 
					  and b.RHPid = c.RHPid
					  and (b.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					  and d.RHTid = b.RHTid 
					  and e.CFid = c.CFid
					  and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and c.Ecodigo = b.Ecodigo
					  and d.Ecodigo = b.Ecodigo )
	
	where exists( 	select 1
					from LineaTiempo b, RHPuestos c, RHTipoAccion d
					where b.DEid=#datos#.DEid 
					and b.RHPcodigo = c.RHPcodigo
					and (b.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					and d.RHTid = b.RHTid 
					and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
					and c.Ecodigo = b.Ecodigo
					and d.Ecodigo = b.Ecodigo )
</cfquery>

<cfquery datasource="#session.DSN#" name="jc">
select * from #datos# 
</cfquery>


<cfquery datasource="#session.DSN#">
	update #datos#
	set fechaingreso =  ( 	select max(b.DLfvigencia)
							from DLaboralesEmpleado b, RHPuestos c, RHTipoAccion d
							where b.DEid = #datos#.DEid
							  and b.RHPcodigo = c.RHPcodigo
							  and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or b.DLffin is null)
							  and d.RHTid = b.RHTid 
							  and d.RHTcomportam = 1
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
							  and c.Ecodigo = b.Ecodigo
							  and d.Ecodigo = b.Ecodigo )
	
	where exists ( 	select 1
					from DLaboralesEmpleado b, RHPuestos c, RHTipoAccion d
					where #datos#.DEid = b.DEid 
					and b.RHPcodigo = c.RHPcodigo
					and (b.DLffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or b.DLffin is null)
					and d.RHTid = b.RHTid 
					and d.RHTcomportam = 1
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
					and c.Ecodigo = b.Ecodigo
					and d.Ecodigo = b.Ecodigo )
</cfquery>


<!--- Nueva fecha de ingreso, desde EVacacionesEmpleado --->
<cfquery datasource="#session.DSN#">
	update #datos#
	set fechaingreso =  EVfantig
	from #datos# a, EVacacionesEmpleado b
	where a.DEid = b.DEid
</cfquery>

<!--- REVISA SI EL EMPLEADO ESTÃ ACTIVO --->
<cfquery name="rsFechaSalida" datasource="#session.DSN#">
	select max(LThasta) as fechasalida
	from #datos# a, LineaTiempo b,  RHTipoAccion d
	where a.DEid = b.DEid 
	and d.RHTid = b.RHTid
</cfquery>
<cfset fechasalida = rsFechaSalida.fechasalida >

<cfif len(trim(fechasalida)) and datecompare(fechasalida, now()) lt 0 >
	<cfset embargos = 'INACTIVO' >
	<cfset tipoembargo = '' >
	<cfset alafecha = '' >
	<cfset labora = 'LaborÃ³' >
	<cfset porlotanto = 'Por lo tanto' >
	<cfset ultima_fecha = fechasalida>
	
	<!--- Determina el Nombre de la acción como Motivo de Salida--->
	<cfquery name="rsMotivoSalida" datasource="#session.DSN#">
		select  RHTdesc Motivo
		from #datos# a, DLaboralesEmpleado b,  RHTipoAccion d
		where a.DEid = b.DEid 
		and d.RHTid = b.RHTid
		and DLfvigencia >= (select max(LThasta) 
					from LineaTiempo b2
					where b2.DEid = b.DEid )
	</cfquery>
	<cfset motivosalida = rsMotivoSalida.Motivo >
	
	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
		<cfinvokeargument name="Fecha" value="#dateformat(fechasalida,'dd/mm/yyyy')#"/>
	</cfinvoke>
	<cfset fechasalida = ' hasta el #vFechaEnLetras#' >
	
	<cfset renta_promedio=0>
	<cfset renta_base=0>	
	
	<cfquery datasource="#session.DSN#">
	update #datos#
	set puesto = ( 	select c.RHPdescpuesto
					from LineaTiempo b, RHPuestos c, RHTipoAccion d
					where b.DEid=#datos#.DEid 
					  and b.RHPcodigo = c.RHPcodigo
					  and b.LThasta = (select max(LThasta) from LineaTiempo x where x.DEid = b.DEid )
					  and d.RHTid = b.RHTid 
					  and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and c.Ecodigo = b.Ecodigo
					  and d.Ecodigo = b.Ecodigo )
	
	where exists( 	select 1
					from LineaTiempo b, RHPuestos c, RHTipoAccion d
					where b.DEid=#datos#.DEid 
					and b.RHPcodigo = c.RHPcodigo
					and b.LThasta = (select max(LThasta) from LineaTiempo x where x.DEid = b.DEid )
					and d.RHTid = b.RHTid 
					and (d.RHTcomportam = 1 or d.RHTcomportam = 6)
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and c.Ecodigo = b.Ecodigo
					and d.Ecodigo = b.Ecodigo )
</cfquery>

<cfelse>
	<cfset fechasalida = '' >
	<cfset motivosalida = '' >
	<cfset porlotanto = '' >
	<cfset labora = 'Labora' >
	<cfset alafecha = 'a la fecha' >
	<cfset ultima_fecha = pFecha>

	<!--- CALCULA SALARIO BASE --->
	<cfquery name="rsSalarioBase" datasource="#session.DSN#">
		select coalesce(LTsalario  ,0) as LTsalario
		from LineaTiempo a, #datos# b
		where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta 
		and a.DEid = b.DEid
	</cfquery>
	<cfif len(trim(rsSalarioBase.LTsalario))>
		<cfset salario_base = rsSalarioBase.LTsalario >
		
		<cfquery name="rsSalarioBase2" datasource="#session.DSN#">
			update #datos#
			set salario_base = <cfqueryparam cfsqltype="cf_sql_varchar" value="#salario_base#">
		</cfquery>
	</cfif>
	
	<cfquery name="ultima" datasource="#session.DSN#">
		select max(RCdesde) desde
		from HPagosEmpleado a, #datos# b, HRCalculoNomina c
		where a.DEid = b.DEid
		and a.RCNid = c.RCNid
	</cfquery>
	
	<!--- CALCULA SALARIO PROMEDIO --->
	<cfquery name="rsSalarioPromedio" datasource="#session.DSN#">
		select coalesce(sum(PEmontores) ,0) as PEsalario
		from HPagosEmpleado a, #datos# b
		where PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-6,ultima.desde)#">     <!---6 = Cantidad de Meses a Calcular --->
		and a.DEid = b.DEid
	</cfquery>
	
	<cfif len(trim(rsSalarioPromedio.PEsalario))>
		<cfset salario_promedio = rsSalarioPromedio.PEsalario >
	</cfif>
	
	<!--- Incidencias --->
	<cfquery name="rsIncidencias" datasource="#session.DSN#">
		select coalesce((sum(ICmontores )), 0) as SEincidencias
		from HIncidenciasCalculo a, #datos# b, HRCalculoNomina c, CIncidentes d
		where c.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-6,now())#">
		and a.DEid = b.DEid
		and c.RCNid = a.RCNid
		and a.CIid = d.CIid
		and d.CIafectasalprom = 1
	</cfquery>
	<!--- antiguo -------
	<cfquery name="rsIncidencias" datasource="#session.DSN#">
		select coalesce((avg(SEincidencias )*2), 0) as SEincidencias
		from HSalarioEmpleado a, #datos# b, HRCalculoNomina c
		where c.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-6,now())#">
		and a.DEid = b.DEid
		and c.RCNid = a.RCNid
	</cfquery>
	--->
	
	<cfquery name="nominas" datasource="#session.DSN#">
		select coalesce(count(distinct RCNid) ,1) as cantidad
		from HPagosEmpleado a, #datos# b
		where PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('m',-6,ultima.desde)#">     <!---6 = Cantidad de Meses a Calcular --->
		and a.DEid = b.DEid
	</cfquery>
	
	<cfif len(trim(rsIncidencias.SEincidencias))>
		<cfset salario_promedio = salario_promedio + rsIncidencias.SEincidencias >
		<cfset salario_promedio = salario_promedio / #nominas.cantidad# * 2 >
	</cfif>

	<!---  CALCULA DEDUCCIONES --->
	<!---  ultimas dos quincenas --->
	<cfquery name="rsDeducciones" datasource="#session.DSN#">
		select  coalesce(sum(DCvalor),0) as DCvalor
		from HDeduccionesCalculo a, #datos# b
		where a.DEid = b.DEid
		and (RCNid = (	select max(RCNid) from HPagosEmpleado where DEid = b.DEid )
		or RCNid = (	select max(RCNid)-1 from HPagosEmpleado where DEid = b.DEid )
		     )
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
		and upper(b.DCcodigo) = 'ASEOB'
	</cfquery>
	<cfif len(trim(rsAsociacion.DCvaloremp))>
		<cfset asociacion = rsAsociacion.DCvaloremp >
	</cfif>
	
	<!---  CALCULA Renta Base--->
	<cfquery name="rsRenta" datasource="#session.DSN#">
	select convert(money,((salario_base - DIRinf ) * (DIRporcentaje / 100)) + DIRmontofijo )as renta_base
		from EImpuestoRenta a, DImpuestoRenta b, RHParametros c, #datos# d
		where a.EIRid = b.EIRid
		and a.EIRestado = 1
		and c.Pcodigo = 30
		and c.Pvalor = a.IRcodigo
		and c.Ecodigo = 1
		and round(salario_base,2) >= round(b.DIRinf,2)
		and round(salario_base,2) <= round(b.DIRsup,2)
	</cfquery>
	
	<!---  CALCULA RENTA REAL --->
	<!---  ultimas dos quincenas --->
	<cfquery name="rsRenta" datasource="#session.DSN#">
		select  coalesce(sum(SErenta),0) as renta_base
		from HSalarioEmpleado a, #datos# b
		where a.DEid = b.DEid
		and (RCNid = (	select max(RCNid) from HPagosEmpleado where DEid = b.DEid )
		or RCNid = (	select max(RCNid)-1 from HPagosEmpleado where DEid = b.DEid )
		     )
	</cfquery>
	
	<cfif len(trim(rsRenta.renta_base))>
	 	<cfset renta_base = rsRenta.renta_base >
	 
	 	<cfquery name="rsRentaBase2" datasource="#session.DSN#">
			update #datos#
			set renta_base = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renta_base#">
		</cfquery>
	<cfelse>
	<cfset renta_base=0>
      </cfif>
	<!---  CALCULA Renta Promedio--->
	<cfquery name="rsRentaP" datasource="#session.DSN#">
	select ((salario_promedio - DIRinf ) * (DIRporcentaje / 100)) + DIRmontofijo as renta_promedio
		from EImpuestoRenta a, DImpuestoRenta b, RHParametros c, #datos# d
		where a.EIRid = b.EIRid
		and a.EIRestado = 1
		and c.Pcodigo = 30
		and c.Pvalor = a.IRcodigo
		and c.Ecodigo = 1
		and round(salario_promedio,2) >= round(b.DIRinf,2)
		and round(salario_promedio,2) <= round(b.DIRsup,2)

	</cfquery>
	<cfif len(trim(rsRentaP.renta_promedio))>
	  <cfset renta_promedio = rsRentaP.renta_promedio >

	  	<cfquery name="rsRentaBase2" datasource="#session.DSN#">
			update #datos#
			set renta_promedio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renta_promedio#">
		</cfquery>
	<cfelse>
	<cfset renta_promedio=0>
       </cfif>
           	
	<!--- CALCULA Embargo --->
	<cfquery name="rsEmbargos" datasource="#session.DSN#">
		select case coalesce(sum(h.DCvalor),0) when 0 then 'libre de embargos / pensiones' else 'embargado o aplicando pensi&oacute;n alimenticia' end as DCvalor,
		t.TDdescripcion as tipo
		   from HDeduccionesCalculo h, DatosEmpleado de, DeduccionesEmpleado d, TDeduccion t
		where  h.DEid = de.DEid
			 and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#">
			 and h.DEid = d.DEid
			 and h.Did = d.Did
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#pfecha#"> between d.Dfechaini and d.Dfechafin
			 and d.TDid = t.TDid
			 and d.Ecodigo = t.Ecodigo
			 and d.Dactivo = 1
			 and (upper(t.TDcodigo) like 'EMB%' or upper(t.TDcodigo) like 'ALIP%')
	</cfquery>
	<cfif len(trim(rsEmbargos.DCvalor))>
		<cfset embargos = rsEmbargos.DCvalor >
		<cfset tipoembargo = rsEmbargos.tipo >
	</cfif>
</cfif>



<!--- Cantidad de años laborados --->
<cfquery datasource="#session.DSN#" name="rsPeriodos">
	select convert(int,datediff(dd,fechaingreso,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ultima_fecha#">) / 365.25) as periodos, 
	convert(int,(
		datediff(dd,fechaingreso,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ultima_fecha#">) - 
		(convert(int,(datediff(dd,fechaingreso,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ultima_fecha#">)/365.25)) * 365.25)
		   ) / 30) as meses 
	from #datos#
</cfquery>
<cfset periodos_laborados = rsPeriodos.periodos >
<cfset meses_laborados = rsPeriodos.meses >

<cfquery datasource="#session.DSN#" name="rsFechaIngreso">
	select fechaingreso from #datos#
</cfquery>
<cfset fechaingreso = rsFechaIngreso.fechaingreso >

<!--- Despliegue para cargar variables de pantalla --->
<cfset asociacion_promedio 	= (salario_promedio * asociacion) / 100 >
<cfset asociacion_base 		= (salario_base * asociacion) / 100 >
<cfset cargas_promedio 		= salario_promedio * 0.0917 >
<cfset cargas_base 			= salario_base * 0.0917 >

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

<cfset fechaingreso = dateformat(fechaingreso,'dd/mm/yyyy') >
<cfquery datasource="#session.DSN#">
	update #datos#
	set	fechaingreso = '#fechaingreso#', 
		fechasalida = '#fechasalida#', 
		motivosalida = '#motivosalida#', 
		deducciones = #deducciones#,
		salario_promedio = #salario_promedio#,
		cargas_promedio = #cargas_promedio#,
		asociacion_promedio = #asociacion_promedio#,
		liquido_promedio_ded = #salario_promedio - cargas_promedio - deducciones - asociacion_promedio - renta_promedio#, 
		salario_base = #salario_base#,
		cargas_base = #cargas_base#,
		asociacion_base = #asociacion_base#,
		liquido_base_ded = #salario_base - cargas_base - deducciones - asociacion_base - renta_base#, 
		liquido_promedio = #salario_promedio - cargas_promedio#, 
		liquido_base = #salario_base - cargas_base - asociacion_base#, 
		embargo = '#embargos#',
		tipoembargo = '#tipoembargo#',
		labora = '#labora#'
</cfquery>

<cfquery datasource="#session.DSN#" name="letras">
	select liquido_base_ded, salario_base from  #datos#
</cfquery>

	<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="LvarEnLetras">
		<cfinvokeargument name="Monto" value="#letras.liquido_base_ded#"/>
	</cfinvoke>
	<cfset liquido_letras = ' #LvarEnLetras#' >
	
	<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="LvarEnLetras">
		<cfinvokeargument name="Monto" value="#letras.salario_base#"/>
	</cfinvoke>
	<cfset salario_letras = ' #LvarEnLetras#' >

<cfquery name="rsQuery" datasource="#session.DSN#">
	select 	DEid,
			nombre, 
			identificacion, 
			empresa,  
			fechaingreso, 
			fechasalida, 
			motivosalida,
			puesto, 
			cf as centro_funcional,
			deducciones,
			salario_promedio,
			cargas_promedio,
			asociacion_promedio,
			liquido_promedio_ded, 
	
			salario_base,
			cargas_base,
			asociacion_base,
			liquido_base_ded, 
		
			renta_base,
			renta_promedio,
	
			liquido_promedio, 
			liquido_base, 
			embargo,
			tipoembargo,
			labora, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fecha#"> as fecha,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#periodos_laborados#"> as periodos_laborados,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#meses_laborados#"> as meses_laborados,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#liquido_letras#"> as liquido_letras,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#salario_letras#"> as salario_letras,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#porlotanto#"> as por_lo_tanto,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#alafecha#"> as a_la_fecha

		from #datos#
</cfquery>
