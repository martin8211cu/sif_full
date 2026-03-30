
<cfinclude template="registroMasivoAjuste-label.cfm">

<cf_dbtemp name="SaldosVacaciones" returnvariable="SaldosVacaciones">
	<cf_dbtempcol name="DEid" 				type="numeric" 		 mandatory="yes"> 
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)"	 mandatory="yes">  
	<cf_dbtempcol name="NombreCompleto" 	type="varchar(100)"  mandatory="yes">  
	<cf_dbtempcol name="CFid" 				type="numeric" 		 mandatory="no">
	<cf_dbtempcol name="CFcodigo" 			type="varchar(10)"	 mandatory="no"> 
	<cf_dbtempcol name="CFdescripcion" 		type="varchar(60)"	 mandatory="no">  
	<cf_dbtempcol name="Ocodigo" 			type="integer" 		 mandatory="no">
	<cf_dbtempcol name="Oficodigo" 			type="varchar(10)"	 mandatory="no"> 
	<cf_dbtempcol name="Odescripcion" 		type="varchar(60)"	 mandatory="no">  
	<cf_dbtempcol name="Dcodigo" 			type="integer" 		 mandatory="no">
	<cf_dbtempcol name="Deptocodigo" 		type="varchar(10)"	 mandatory="no"> 
	<cf_dbtempcol name="Ddescripcion" 		type="varchar(60)"	 mandatory="no">  
	<cf_dbtempcol name="FechaRegistro" 		type="datetime"		 mandatory="yes">
	<cf_dbtempcol name="FechaInicio" 		type="datetime"		 mandatory="yes"> 
	<cf_dbtempcol name="FechaFin" 			type="datetime"		 mandatory="yes"> 		
	<cf_dbtempcol name="Regimen" 			type="numeric"		 mandatory="yes">
	<cf_dbtempcol name="DiasRegimen" 		type="numeric"		 mandatory="no"> 
	<cf_dbtempcol name="FAntiguedad" 		type="datetime"		 mandatory="yes"> 
	<cf_dbtempcol name="SaldoAsignado " 	type="float" 		 mandatory="no">
	<cf_dbtempcol name="AnyosLaborados" 	type="numeric"		 mandatory="no">
	<cf_dbtempcol name="meses" 				type="numeric(7,2)"	 mandatory="no">
	<cf_dbtempcol name="FechaCorteRegimen" 	type="datetime" 	 mandatory="no">
	<cf_dbtempcol name="saldoProyectado" 	type="float">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>

<!--- 	Variables para determinar si se seleccionaron criterios para incluir empleados 
		Si se mantienen	en falso las dos, se agregan todos los empleados nombrados actualmente
--->
<cfset criterio_1 = false >		<!--- se selecciono oficna/departamento o Centro Funcional --->
<cfset criterio_2 = false >		<!--- se selecciono empleado --->

<!--- fechas --->
<cfset fecha_inicio = LSParseDatetime(form.FechaDesde) >
<cfif len(trim(form.FechaHasta)) is 0 >
	<cfset fecha_fin = fecha_inicio >
<cfelse>
	<cfset fecha_fin = LSParseDatetime(form.FechaHasta) >
</cfif>
<cfif datecompare(fecha_inicio, fecha_fin) eq 1 >
	<cfset tmp = fecha_inicio >
	<cfset fecha_inicio = fecha_fin >
	<cfset fecha_fin = tmp >
</cfif>
<!--- formato sql segun bd para las fechas --->
<cfset fecha_inicio = lsdateformat(fecha_inicio, 'dd/mm/yyyy') >
<cfset fecha_fin    = lsdateformat(fecha_fin, 'dd/mm/yyyy') >
<cfset fecha_hoy    = lsdateformat(now(), 'dd/mm/yyyy') >
<cf_dbfunction name="to_date" args="'#fecha_inicio#'" returnvariable="fecha_inicio">
<cf_dbfunction name="to_date" args="'#fecha_fin#'" returnvariable="fecha_fin">
<cf_dbfunction name="to_date" args="'#fecha_hoy#'" returnvariable="fecha_hoy">

<!--- arma el sql en partes para agreagar las partes especificas a cada filtro --->
<cfset sql_parte_1 = "	insert into #SaldosVacaciones#( DEid, 
														DEidentificacion, 
														NombreCompleto, 
														CFid, 
														CFcodigo, 
														CFdescripcion,
														FechaRegistro, 
														FechaInicio,
														FechaFin,
														Regimen, 
														FAntiguedad,
														FechaCorteRegimen,
														SaldoAsignado)
						select	a.DEid, 
								a.DEidentificacion, 
								{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )},
								f.CFid, 
								f.CFcodigo, 
								f.CFdescripcion, 
								#preservesinglequotes(fecha_hoy)#,
								#preservesinglequotes(fecha_inicio)#,
								#preservesinglequotes(fecha_fin)#,
								b.RVid, 
								c.EVfantig,
								coalesce(EVfecha, EVfantig),
								coalesce(sum(d.DVEdisfrutados+d.DVEcompensados), 0.00)
						from DatosEmpleado a
				
						inner join LineaTiempo b
						on a.DEid = b.DEid
						and #preservesinglequotes(fecha_inicio)# between b.LTdesde and b.LThasta
				
						inner join RHPlazas e
						on b.RHPid = e.RHPid
				
						inner join CFuncional f
						on e.CFid = f.CFid " >

<cfset sql_parte_3 = "	left outer join EVacacionesEmpleado c
						on b.DEid = c.DEid
				
						left outer join DVacacionesEmpleado d
						on c.DEid = d.DEid
						and d.DVEfecha <= #preservesinglequotes(fecha_inicio)# 
				
						where a.Ecodigo = #Session.Ecodigo# ">

<cfset sql_parte_5 ="	group by a.DEid, 
								 a.DEidentificacion, 
								{fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre  )}, 		
								 f.CFid, 
								 f.CFcodigo, 
								 f.CFdescripcion, 
								 b.RVid, 
								 c.EVfantig, 
								 coalesce(EVfecha, EVfantig)" >


<cfset sql_parte_2 = "" >		<!--- cf y oficinas --->
<cfset sql_parte_4 = "" >		<!--- filtro para empleados --->

<!--- se selecciono uno o mas CF's, se van a incluir empleados por centro funcional  --->
<cfif isdefined("form.opt") and form.opt eq 0 and isdefined("form.CFidList") and len(trim(form.CFidList))>
	<cfset criterio_1 = true >
	<cfset cf_list = '' >
	<cfloop list="#form.CFidList#" index="i">
		<cfset item = listtoarray(i, '|')>
		<cfset cf_list = ListAppend(cf_list, item[1]) >
	</cfloop>

	<cfquery name="rs_centros" datasource="#session.DSN#">
		select CFid, <cf_dbfunction name="concat" args="CFpath,'/'"> as path 
		from CFuncional
		where CFid in (#cf_list#)
	</cfquery>
	
	<!--- diferencia  --->
	<cfset sql_parte_2 = " and ( f.CFid in (#cf_list#) " >
	<cfloop query="rs_centros">
		<cfif listfind(form.CFidList, '#rs_centros.CFid#|1') gt 0>
			<cfset sql_parte_2 = " #sql_parte_2# or CFpath like '#trim(rs_centros.path)#%' ">
		</cfif>
	</cfloop>
	<cfset sql_parte_2 = " #sql_parte_2# ) " >
	
	<cfset sql = sql_parte_1 & sql_parte_2 & sql_parte_3 & sql_parte_5 > 
	<cfquery datasource="#session.DSN#">
		#preservesinglequotes(sql)#
	</cfquery>
	
<!--- se selecciono uno o mas oficina/departamento, se van a incluir empleados por oficina y departamento  --->
<cfelseif isdefined("form.opt") and form.opt eq 1 and isdefined("form.ODidList") and len(trim(form.ODidList))>
	<cfset criterio_1 = true >
	
	<cf_dbfunction name="to_char" args="f.Ocodigo" returnvariable="ocodigo_char" >
	<cf_dbfunction name="to_char" args="f.Dcodigo"  returnvariable="dcodigo_char">
	<cf_dbfunction name="concat" args="#ocodigo_char#*'|'*#dcodigo_char#" returnvariable="comparar" delimiters="*">
	<cfset od_list = ''>
	<cfloop list="#form.ODidList#" index="i">
		<cfset od_list = listappend(od_list, "'"&i&"'")>
	</cfloop>	
	
	<cfset sql_parte_2 = " and #preservesinglequotes(comparar)# in (	#preservesinglequotes(od_list)# ) " >

	<cfset sql = sql_parte_1 & sql_parte_2 & sql_parte_3 & sql_parte_5 > 
	<cfquery datasource="#session.DSN#">
		#preservesinglequotes(sql)#
	</cfquery>
</cfif>

<!--- se seleccionaron empleados de manera individual, se van a incluir empleados de manera individual --->
<cfif isdefined("form.EmpleadoidList") and len(trim(form.EmpleadoidList))>
	<cfset criterio_2 = true >

	<cfset sql_parte_4 = " and a.DEid in (#form.EmpleadoidList#)
						   and not exists( 	select DEid 
						   					from #SaldosVacaciones# 
											where DEid = a.DEid ) ">

		<cfset sql = sql_parte_1 & sql_parte_3 & sql_parte_4 & sql_parte_5 > 
		<cfquery datasource="#session.DSN#">
			#preservesinglequotes(sql)#
		</cfquery>
</cfif>

<!--- si no se selecciono ningun filtro se agregan todos los empleados nombrados actualmente--->
<cfif not ( criterio_1 or criterio_2 ) >
	<cfset sql = sql_parte_1 & sql_parte_3 & sql_parte_5 > 
	<cfquery datasource="#session.DSN#">
		#preservesinglequotes(sql)#
	</cfquery>
</cfif>

<!--- Proceso tomado del calculo hecho en el reporte  --->
	<!--- Cantidad de años transcurridos entre fecha de ingreso y fecha de hoy (parte entera) --->
	<cfquery datasource="#Session.DSN#">
		update #SaldosVacaciones#
		set AnyosLaborados = (<cf_dbfunction name="datediff" args="FAntiguedad,FechaRegistro,yy">)
	</cfquery>
	
	<!--- calcula los meses  --->
	<cfquery datasource="#Session.DSN#">
		update #SaldosVacaciones#
		set  meses = <cf_dbfunction name="datediff" args="FechaCorteRegimen,FechaRegistro"> 
	</cfquery>	
	
	<!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de años laborados --->
	<cfquery name="rsDias" datasource="#session.DSN#">
		update #SaldosVacaciones#
		set DiasRegimen = (
							select coalesce(rv.DRVdias, 0)
			from DRegimenVacaciones rv
			where rv.RVid = #SaldosVacaciones#.Regimen
			  and rv.DRVcant = ( 
				select coalesce(max(rv2.DRVcant), 1) 
				from DRegimenVacaciones rv2 
				where rv2.RVid = #SaldosVacaciones#.Regimen
				and rv2.DRVcant-1 <= #SaldosVacaciones#.AnyosLaborados
			)
		  )		
	</cfquery>
	
	<cfquery name="rsDias" datasource="#session.DSN#">
		update #SaldosVacaciones#
		set saldoProyectado = (DiasRegimen * (<cf_dbfunction name="datediff" args="FechaCorteRegimen,FechaRegistro"> / 30.0))/12
	</cfquery> 

	<cfquery name="rsDias" datasource="#session.DSN#">
		update #SaldosVacaciones#
		set saldoProyectado = saldoProyectado + SaldoAsignado
	</cfquery>

<cfquery name="datos" datasource="#session.DSN#">
	select 	DEid,
			DEidentificacion,
			NombreCompleto,
			CFid,
			CFcodigo,
			CFdescripcion,
			Ocodigo,
			Oficodigo,
			Odescripcion,
			Dcodigo,
			Deptocodigo,
			Ddescripcion,
			FechaRegistro,
			FechaInicio,
			FechaFin,
			Regimen,
			DiasRegimen,
			FAntiguedad,
			SaldoAsignado,
			AnyosLaborados,
			meses,
			FechaCorteRegimen,
			saldoProyectado

	from #SaldosVacaciones#
	order by DEidentificacion
</cfquery>

<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="filename=RegistroMasivoAjuste.xls">

<table width="100%" border="0" cellspacing="0" cellpadding="0" >

	<cfoutput>
	<!---
	<tr>
		<td colspan="9" style="font-size:20px; font-weight:bold; background-color:##E8E8E8;" align="center" >#LB_RegistroMasivoAjustes#</td>
	</tr>
	<tr>
		<td colspan="9" style="font-size:18px; font-weight:bold; background-color:##E8E8E8;" align="center" >#session.Enombre#</td>
	</tr>	
	<tr>
		<td colspan="9" style="font-size:12px; background-color:##E8E8E8;" align="right" ><strong>#LB_Fecha#:</strong>&nbsp;#LSTimeFormat(Now()," hh:mm:ss tt")#</td>
	</tr>
	--->
	<tr>
		<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#trim(LB_Identificacion)#</td>
		<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Empleado#</td>
		<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Descripcion#</td>		
		<td nowrap="nowrap" align="center" style="font-weight:bold; background-color:##F0F0F0">#LB_FechaDesde#</td>
		<td nowrap="nowrap" align="center" style="font-weight:bold; background-color:##F0F0F0">#LB_FechaHasta#</td>
		<td nowrap="nowrap" align="right" style="font-weight:bold; background-color:##F0F0F0">#LB_SaldoActual#</td>
		<td nowrap="nowrap" align="right" style="font-weight:bold; background-color:##F0F0F0">#LB_SaldoProyectado#</td>
		<td nowrap="nowrap" align="right" style="font-weight:bold; background-color:##F0F0F0">#LB_Ajuste_positivo#</td>
		<td nowrap="nowrap" align="right" style="font-weight:bold; background-color:##F0F0F0">#LB_Ajuste_negativo#</td>
	</tr>
	</cfoutput>	
	<cfoutput query="datos">
		<tr>
			<td>'#datos.DEidentificacion#</td>	<!--- comilla simple porque las cedulas de solo numeros, sean tomadas como string y no como numero --->
			<td>#datos.NombreCompleto#</td>
			<td>#form.Descripcion#</td>
			<td align="center">#LSDateFormat(datos.FechaInicio, 'dd/mm/yyyy')#</td>
			<td align="center">#LSDateFormat(datos.FechaFin, 'dd/mm/yyyy')#</td>
			<td align="right">#LSNumberFormat(datos.saldoAsignado, ',9.00')#</td>
			<td align="right">#LSNumberFormat(datos.saldoProyectado, ',9.00')#</td>
			<td></td>
			<td></td>
		</tr>
	</cfoutput>
</table>


<!---
<cfif isdefined("Form.btnGenerar")>
	<!--- Obtenemos la descripción de la Empresa --->
	<cfquery name="rsEmpresa" datasource="minisif">
  		select Edescripcion as Empresa
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
		
	<!--- Obtenemos la información del saldo de vacaciones del Empleado --->
	<cfquery name="rsDatos" datasource="minisif">
		select 
			a.DEid,
			a.DEidentificacion as Emp_ID, 
			{fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) } as Empleado,
			sum(c.DVEdisfrutados+c.DVEcompensados) as Disponibles
		from DatosEmpleado a
			inner join EVacacionesEmpleado b
				on b.DEid = a.DEid
				inner join DVacacionesEmpleado c
					on c.DEid = b.DEid
					and c.DVEfecha <= '20070719'
			inner join LineaTiempo lt
				on lt.DEid = a.DEid
				and '20070719' between LTdesde and LThasta 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!--- Se debe de filtrar por la lista de empelados que vengan --->
			<!--- and c.DEid in (4838,4839,4847) --->
		group by a.DEid
	</cfquery>

	<cfcontent type="application/msexcel">
	<cfheader name="Content-Disposition" value="filename=RegistroMasivoAjuste.xls">


	<cfinclude template="registroMasivoAjuste-label.cfm">

	<!--- Variables --->
	<cfset CacheDate = LSDateFormat(Now(),"dd/mm/yyyy") & LSTimeFormat(Now()," hh:mm:ss tt")>

	<!--- Pintado de la hoja de Excel --->
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
			<tr>
				<td colspan="6" style="background-color:##E8E8E8;">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="6" style="font-size:20px; font-weight:bold; background-color:##E8E8E8;" align="center" >#LB_RegistroMasivoAjustes#</td>
			</tr>
			<tr>
				<td colspan="6" style="font-size:18px; font-weight:bold; background-color:##E8E8E8;" align="center" >#rsEmpresa.Empresa#</td>
			</tr>	
			<tr>
				<td colspan="6" style="font-size:12px; background-color:##E8E8E8;" align="right" ><strong>#LB_Fecha#:</strong>&nbsp;#CacheDate#</td>
			</tr>	
			<tr>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Fecha#</td>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Identificacion#</td>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Empleado#</td>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_SaldoActual#</td>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Rebajar#</td>
				<td nowrap="nowrap" align="left" style="font-weight:bold; background-color:##F0F0F0">#LB_Aumentar#</td>
			</tr>
			<cfloop query="rsDatos">
	 			<tr>
					<td nowrap="nowrap" align="left">#Form.fechaInicio#</td>
					<td nowrap="nowrap" align="left">#Emp_ID#</td>
					<td nowrap="nowrap" align="left">#Empleado#</td>
					<td nowrap="nowrap" align="center">10</td>
					<td nowrap="nowrap" align="center">3</td>
					<td nowrap="nowrap" align="center">5</td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>
	</cfoutput>

<cfelseif isdefined("Form.btnImportar")>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
			<tr>
				<td nowrap="nowrap" align="center"><strong>--- Gracias por visitarnos pero esta pagina se encuentra en Construccion ---</strong></td>
			</tr>
		</table>
	</cfoutput>
	
</cfif>
--->