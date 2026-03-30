<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traducción y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<!--- Genera variables de traducción --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Algo_DHC"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Algo_DHC"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Identificacion"
		Default="Identificaci&oacute;n"
		returnvariable="LB_Identificacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Nombre"
		Default="Nombre"
		returnvariable="LB_Nombre"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Bruto"
		Default="Salario Bruto"
		returnvariable="LB_Salario_Bruto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Incidencias"
		Default="Incidencias"
		returnvariable="LB_Incidencias"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Neto"
		Default="Salario Neto"
		returnvariable="LB_Salario_Neto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Salario_Liquido"
		Default="Salario L&iacute;quido"
		returnvariable="LB_Salario_Liquido"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Proporcional_Salario"
		Default="Proporcional Salario"
		returnvariable="LB_Proporcional_salario"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Porcentaje_de_referencia"
		Default="Porcentaje de referencia"
		returnvariable="LB_referencia"/>
		
	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   		type="int"      	mandatory="yes">
		<cf_dbtempcol name="RCdesde" 		type="datetime" 	mandatory="no">
		<cf_dbtempcol name="RChasta" 		type="datetime" 	mandatory="no">
		<cf_dbtempcol name="descripcion" 	type="varchar(255)" mandatory="no">		
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     				type="numeric"      mandatory="yes">
		<cf_dbtempcol name="RCNid"    				type="numeric"		mandatory="no">
		<cf_dbtempcol name="id"     				type="varchar(60)"	mandatory="no">
		<cf_dbtempcol name="nombre"     			type="varchar(255)"	mandatory="no">		
		<cf_dbtempcol name="salario_bruto"     		type="money"		mandatory="no">
		<cf_dbtempcol name="incidencias"     		type="money"		mandatory="no">		
		<cf_dbtempcol name="salario_liquido"    	type="money"		mandatory="no">
		<cf_dbtempcol name="porcentaje"    			type="float"		mandatory="no">
		<cf_dbtempcol name="proporcional"    		type="float"		mandatory="no">
		<cf_dbtempkey cols="DEid,RCNid">
	</cf_dbtemp>

	<!--- Decide si se buscan los datos en las tablas de trabajo o en las históricas --->
	<cfset prefijo = '' >
	<cfif isdefined('form.tiponomina')>
		<cfset prefijo = 'H' >
	</cfif>
	
	<!--- Define Form.CPidlist (Puede venir en Form.CPidlist1 o Form.CPidlist2) --->
	<cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
		<cfset form.CPidlist = form.CPidlist1>
	<cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
		<cfset form.CPidlist = form.CPidlist2>
	<cfelse>
		<!--- Este error no debe presentarse. --->
		<cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
	</cfif>
	<!--- Obtiene información del calendario de pago selecccionado por el usuario. --->
	<cfquery datasource="#session.dsn#">	
		insert into #calendario#(RCNid, RCdesde, RChasta )
		select CPid, CPdesde, CPhasta 
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
	</cfquery>

<!---	INSERTA EN LA INFORMACION DE SALIDA, LOS DATOS BASICOS DEL FUNCIONARIO --->
<cfquery datasource="#session.dsn#" >
	insert #salida# (RCNid, DEid, id, nombre, porcentaje )
	select  a.RCNid,
			a.DEid, 
			de.DEidentificacion, 
			<cf_dbfunction name="concat" args="de.DEapellido1,'  ', de.DEapellido2 , '  ', de.DEnombre">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.porcentaje#">
	from #prefijo#SalarioEmpleado a, DatosEmpleado de
	where a.RCNid in ( select RCNid from #calendario# )
	and de.DEid=a.DEid
</cfquery>

<!--- descripcion de la nomina --->
<cfquery datasource="#session.DSN#">
	update #calendario#
	set descripcion = ( select RCDescripcion
						from #prefijo#RCalculoNomina
						where RCNid=#calendario#.RCNid )
</cfquery>

<!--- ================================================================== --->
<!--- Salario por hora (Hourly Salary Rate) 							 --->
<!--- ================================================================== --->
	<!--- calcula el salario bruto del empleado --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_bruto = ( select SEsalariobruto
							  from #prefijo#SalarioEmpleado
							  where RCNid = #salida#.RCNid
							    and DEid = #salida#.DEid  )
	</cfquery>

	<!--- incidencias --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set incidencias = ( select sum(ICmontores)
							from #prefijo#IncidenciasCalculo
							where RCNid = #salida#.RCNid
							  and DEid = #salida#.DEid  )
	</cfquery>

	<!--- salario_liquido --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set salario_liquido = ( select SEliquido
							    from #prefijo#SalarioEmpleado
							    where RCNid = #salida#.RCNid
							       and DEid = #salida#.DEid  )
	</cfquery>

	<!--- proporcional --->
	<cfquery datasource="#session.DSN#">
		update #salida#
		set proporcional = (coalesce(salario_liquido, 0)*100)/ (coalesce(salario_bruto, 0)+coalesce(incidencias, 0))
		where (coalesce(salario_bruto, 0)+coalesce(incidencias, 0)) > 0
	</cfquery>

<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	<!--- ===============================
	   Ejecuta  la Salida del Reporte en Pantalla 
	   ===============================--->
	select 
		c.descripcion,
		a.id, 																-- Centro Funcional
		a.nombre, 															-- Indica si la fecha de ingreso conincide con la nomina que se esta pagando
		coalesce( a.salario_bruto, 0 ) as salario_bruto, 					-- Nombre
		coalesce( a.incidencias, 0 ) as incidencias,						-- identificacion
		coalesce( a.salario_liquido, 0 ) as salario_liquido,				-- salario por hora
		a.proporcional		
	from #salida# a, #calendario# c
	where c.RCNid=a.RCNid
	and proporcional < porcentaje
	order by c.descripcion, id
</cfquery>
</cfsilent>
<cf_htmlReportsHeaders irA="proporcionalEmpleadosDHC.cfm"
FileName="Reporte_de_Algo_DHC.xls"
title="#LB_Reporte_de_Algo_DHC#">
<cf_templatecss>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="24">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfset filtro2= ''>
				<cfif isdefined('form.tiponomina')>
					<cfinvoke key="LB_IncluyeNominasAplicadas" default="Incluye N&oacute;minas Aplicadas" returnvariable="LB_IncluyeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2= LB_IncluyeNominasAplicadas>
				<cfelse>
					<cfinvoke key="LB_IncluyeNominasEnProceso" default="Incluye N&oacute;minas En Proceso" returnvariable="LB_IncluyeNominasEnProceso" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2= LB_IncluyeNominasEnProceso>
				</cfif>
				<cf_EncReporte
					Titulo="#LB_Reporte_de_Algo_DHC#"
					Color="##E3EDEF"
					filtro1="#LB_referencia#: #LSNumberformat(form.porcentaje, ',9.00')#%"	
					filtro2="#filtro2#"								
				>
			</td></tr>
		</table>
	</td>
</tr>
<!----============================ ENCABEZADO ANTERIOR ============================
<tr><td colspan="24" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
<tr><td colspan="24" align="center"><strong>#LB_Reporte_de_Algo_DHC#</strong></td></tr>
<tr><td colspan="24" align="center"><strong>#LB_referencia#:</strong>&nbsp;#LSNumberformat(form.porcentaje, ',9.00')#%</td></tr>
<tr><td colspan="24" align="center"><strong><strong>
	<cfif isdefined('form.tiponomina')>
		<cf_translate key="LB_IncluyeNominasAplicadas"> Incluye N&oacute;minas Aplicadas </cf_translate>
	<cfelse>
		<cf_translate key="LB_IncluyeNominasEnProceso"> Incluye N&oacute;minas En Proceso </cf_translate>
	</cfif>
	</strong></strong></td></tr>
<tr><td>&nbsp;</td></tr>
---->
<tr>
	<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
	<td  class="tituloListas" valign="top" ><strong>#LB_Identificacion#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Bruto#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Incidencias#</strong>&nbsp;</td>
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Neto#</strong>&nbsp;</td>	
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario_Liquido#</strong>&nbsp;</td>	
	<td  class="tituloListas" valign="top" align="right"><strong>#LB_Proporcional_Salario#</strong>&nbsp;</td>	
</tr>
</cfoutput>

<cfoutput query="rsReporte" group="descripcion" >
	<tr>
		<td nowrap class="tituloListas" colspan="24"><strong>#rsReporte.descripcion#</strong>&nbsp;</td>
	</tr>

	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap >#rsReporte.id#</td>
			<td nowrap>#rsReporte.nombre#</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Salario_bruto,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.incidencias,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Salario_bruto+rsReporte.incidencias,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#LSCurrencyformat(rsReporte.Salario_liquido,'none')#&nbsp;&nbsp;</td>
			<td nowrap align="right">#LSNumberFormat(rsReporte.proporcional, '.00')#%</td>
		</tr>
	</cfoutput>
</cfoutput>

<tr><td colspan="24" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>