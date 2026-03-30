<cfif isdefined('Url.Fcorte') and Len(Trim(Url.Fcorte))>
	<cfparam name="Form.Fcorte" default="#Url.Fcorte#">
</cfif>
<cfif isdefined('Url.CFid') and Len(Trim(Url.CFid))>
	<cfparam name="Form.CFid" default="#Url.CFid#">
</cfif>
<cfif isdefined('Url.CFcodigo') and Len(Trim(Url.CFcodigo))>
	<cfparam name="Form.CFcodigo" default="#Url.CFcodigo#">
</cfif>
<cfif isdefined('Url.CORTECF') and Len(Trim(Url.CORTECF))>
	<cfparam name="Form.CORTECF" default="#Url.CORTECF#">
</cfif>
<cfif isdefined('Url.INCLUIRDEPENDENCIAS') and Len(Trim(Url.INCLUIRDEPENDENCIAS))>
	<cfparam name="Form.INCLUIRDEPENDENCIAS" default="#Url.INCLUIRDEPENDENCIAS#">
</cfif>

<!--- Tabla Temporal para almacenar los saldos de vacaciones --->
<cf_dbtemp name="tbl_SaldosVacaciones" returnvariable="tbl_SaldosVacaciones">
	<cf_dbtempcol name="DEid" 			  		type="numeric" mandatory="yes"> 
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)"> 
	<cf_dbtempcol name="NombreCompleto" 	type="varchar(100)"> 
	<cf_dbtempcol name="CFid" 					type="numeric" mandatory="yes">
	<cf_dbtempcol name="CFcodigo" 			type="varchar(10)">
	<cf_dbtempcol name="CFdescripcion" 		type="varchar(60)"> 
	<cf_dbtempcol name="Regimen" 				type="numeric">
	<cf_dbtempcol name="DiasRegimen" 		type="numeric">
	<cf_dbtempcol name="FAntiguedad" 		type="datetime">
	<cf_dbtempcol name="SaldoAsignado " 	type="numeric(18,4)">
	<cf_dbtempcol name="AnyosLaborados" 	type="numeric">
	<cf_dbtempcol name="meses" 				type="numeric(7,2)">
	<cf_dbtempcol name="FechaCorteRegimen" type="datetime">
	<cf_dbtempcol name="FechaHoy" 			type="datetime">
	<cf_dbtempcol name="saldoProyectado" 	type="float">
	<cf_dbtempkey cols="DEid">
</cf_dbtemp>

	<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid))>
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFpath
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
		</cfquery>
		<cfset vRuta = rsCFuncional.CFpath >
	</cfif>
	<cfquery name="rsins" datasource="#Session.DSN#">
		insert into #tbl_SaldosVacaciones#(CFdescripcion, CFid, CFcodigo, Regimen, NombreCompleto, DEid, DEidentificacion,FAntiguedad,FechaCorteRegimen,SaldoAsignado)
		select f.CFdescripcion, f.CFid, f.CFcodigo, b.RVid, 
				{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )} as nombrecompleto,
				 a.DEid, a.DEidentificacion, 
				coalesce(c.EVfantig, getdate()) as FAntiguedad,
				coalesce(EVfecha, EVfantig) as cortevacaciones,
				coalesce(sum(d.DVEdisfrutados+d.DVEcompensados), 0.00) as Disponibles
		 from DatosEmpleado a
		 inner join LineaTiempo b
			on a.DEid = b.DEid
			<cfif isdefined("Form.Fcorte") and Len(Trim(Form.Fcorte))>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fcorte)#"> between b.LTdesde and b.LThasta
			<cfelse>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between b.LTdesde and b.LThasta
			</cfif>
		inner join RHPlazas e
			on b.RHPid = e.RHPid
		inner join CFuncional f
			on e.CFid = f.CFid
			<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid))>
				<!--- and f.CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.CFcodigo)#"> ---> 
				<cfif isdefined("Form.IncluirDependencias")>
					and ( upper(f.CFpath) like '#ucase(vRuta)#/%' or f.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">)
				<cfelse>
					and f.CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
				</cfif>
			</cfif>
		left outer join EVacacionesEmpleado c
			on b.DEid = c.DEid
		left outer join DVacacionesEmpleado d
			on c.DEid = d.DEid
			<cfif isdefined("Form.Fcorte") and Len(Trim(Form.Fcorte))>
				and d.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fcorte)#">
			<cfelse>
				and d.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			</cfif>
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		group by f.CFcodigo, f.CFdescripcion, f.CFid, b.RVid, {fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre  )}, a.DEid, 
		a.DEidentificacion, coalesce(c.EVfantig, getdate()),coalesce(EVfecha, EVfantig)
	</cfquery>
	
	<!--- Fecha de Hoy --->
	<cfquery name="updFechaHoy" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set FechaHoy = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fcorte)#">
	</cfquery>

	<!--- Cantidad de años transcurridos entre fecha de ingreso y fecha de hoy (parte entera) --->
	<cfquery name="updAnyos" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set AnyosLaborados = (<cf_dbfunction name="datediff" args="FAntiguedad,FechaHoy,yy">)
	</cfquery>

	<!--- calcula los meses  --->
	<cfquery name="updmeses" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set  meses = <cf_dbfunction name="datediff" args="FechaCorteRegimen,FechaHoy,mm"> 
	</cfquery>	

	<!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de años laborados --->
	<cfquery name="rsDias" datasource="#session.DSN#">
		update #tbl_SaldosVacaciones#
		set DiasRegimen = 
						(
							select coalesce(rv.DRVdias, 0)
							from DRegimenVacaciones rv
							where rv.RVid = #tbl_SaldosVacaciones#.Regimen
			  				and rv.DRVcant = 
										( 
											select coalesce(max(rv2.DRVcant), 1) 
											from DRegimenVacaciones rv2 
											where rv2.RVid = #tbl_SaldosVacaciones#.Regimen
											and rv2.DRVcant-1 <= #tbl_SaldosVacaciones#.AnyosLaborados
											)
		  				)		
	</cfquery>

<!--- <cf_dbfunction name="datediff" args="FechaCorteRegimen,FechaHoy,dd"> --->
	<cfquery name="rsDias" datasource="#session.DSN#">
		update #tbl_SaldosVacaciones#
		<cfif Application.dsinfo[session.DSN].type neq 'oracle'>
			set saldoProyectado = (DiasRegimen * ( datediff(dd, FechaCorteRegimen, FechaHoy)/ 30.0))/12
		<cfelse>
			set saldoProyectado = (DiasRegimen * ( datediff('dd', FechaCorteRegimen,FechaHoy)/ 30.0))/12
		</cfif>
	</cfquery> 
	
	<cfquery name="rsDias" datasource="#session.DSN#">
		update #tbl_SaldosVacaciones#
		set saldoProyectado = saldoProyectado + SaldoAsignado
	</cfquery>

	<cfquery name="rsSaldos" datasource="#Session.DSN#">
		select CFdescripcion, 
			CFid,
			CFcodigo,
			DEidentificacion,
			NombreCompleto, 
			FAntiguedad,
			saldoProyectado ,
			SaldoAsignado,
			{fn concat(b.RVcodigo,{fn concat(' - ',Descripcion)})} as codRegimen,
			<!--- b.RVcodigo+' - '+Descripcion codRegimen --->
			(saldoProyectado - SaldoAsignado) as proporcional
		from #tbl_SaldosVacaciones# a, RegimenVacaciones b
		where a.Regimen = b.RVid
		order by CFcodigo, CFdescripcion, CFid, NombreCompleto
	</cfquery>
	
	<cfset HoraReporte = Now()>
	
	<cfif  isdefined("form.formato") and form.formato eq "Excel">
		<cfcontent type="application/msexcel">
		<cfheader 	name="Content-Disposition" 
		value="attachment;filename=SaldoVacaciones_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	</cfif>
		<style>
			h1.corte {
				PAGE-BREAK-AFTER: always;}
			.tituloAlterno {
				font-size:16px;
				font-weight:bold;
				text-align:center;}
			.titulo_empresa2 {
				font-size:14px;
				font-weight:bold;
				text-align:center;}
			.titulo_reporte {
				font-size:12px;
				font-style:italic;
				text-align:center;}
			.titulo_filtro {
				font-size:10px;
				font-style:italic;
				text-align:center;}
			.titulolistas {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				}
			.titulo_columnar {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:right;}
			.listaCorte {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:left;}
			.detalle {
				font-size:10px;
				text-align:left;}
			.detaller {
				font-size:10px;
				text-align:right;}
			.detallec {
				font-size:10px;
				text-align:center;}	
				
			.mensaje {
				font-size:10px;
				text-align:center;}
			.paginacion {
				font-size:10px;
				text-align:center;}
		</style>	
	
	<cfsavecontent variable="ENCABEZADO_IMP">
		<td colspan="7">
			<table width="100%" cellpadding="0" cellspacing="0" border="1">
			<cfoutput>
				<tr><td>
					<cfinvoke key="LB_ConsultaDeSaldosDeVacaciones" default="Consulta de Saldos de Vacaciones" returnvariable="LB_ConsultaDeSaldosDeVacaciones" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_FechaDeCorte" default="Fecha de Corte" returnvariable="LB_FechaDeCorte" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro1 = ''>
					<cfif isdefined("Form.Fcorte") and Len(Trim(Form.Fcorte))>
						<cfset filtro1 = '#LB_FechaDeCorte#: #Form.Fcorte#'>
					</cfif>
					<cf_EncReporte
						Titulo="#LB_ConsultaDeSaldosDeVacaciones#"
						Color="##E3EDEF"
						filtro1="#filtro1#"	
					>
				</td></tr>
				</cfoutput>
			</table>
		</td>
		</tr>
		<tr>
		<td class="titulolistas">Identificaci&oacute;n</td>
		<td class="titulolistas">Empleado</td>
		<td class="titulolistas" align="left">Régimen</td>
		<td class="titulolistas" align="center">Fecha de Ingreso</td>
		<td class="titulolistas" align="right">Saldo Asignado</td>
		<td class="titulolistas" align="right">Saldo Proporcional</td>
		<td class="titulolistas" align="right">Saldo Proyectado</td>
		</tr>
		
	<cfset vMostrarDecimales = true >
	<cfoutput>
	<cfquery name="rsDecimales" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo=600
	</cfquery>
	</cfoutput>
	<cfif rsDecimales.Pvalor eq 1 >
		<cfset vMostrarDecimales = false >
	</cfif>
		
	</cfsavecontent>
		<!----- Pintado Encabezado ----->
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfset contadorlineas = 1>
		<cfset primercorte = true>
		<cfif rsSaldos.recordCount>
			<cfset corte = ''>
				<cfoutput>
					<cfloop query="rsSaldos">
						<cfif (isdefined('Url.imprimir') and contadorlineas gte 50 and rsSaldos.CurrentRow NEQ 1) or  primercorte>
						  #ENCABEZADO_IMP#
						  <tr>
							<td class="listaCorte" colspan="7" nowrap>Centro Funcional: #rsSaldos.CFcodigo# - #rsSaldos.CFdescripcion#</td>
						  </tr>
						  <cfset corte = rsSaldos.CFid>
						  <cfset primercorte = false>
						  <cfset contadorlineas = 1>  
						</cfif> <!--- Fin de isdefined('Url.imprimir') and rsSaldos.CurrentRow mod 35 EQ 0 and rsSaldos.CurrentRow NEQ 1 --->
						
						<cfif corte NEQ rsSaldos.CFid>
						  <cfset corte = rsSaldos.CFid>
						  <cfif isdefined('Url.imprimir') and  isdefined('Form.CORTECF')>
							  <tr><td colspan="7">&nbsp;</td></tr>
							  <tr>
								 <td colspan="7" align="center"><strong>------------------------ Ultima l&iacute;nea para este centro funcional ------------------------</strong></td>
							  </tr>
							  <tr><td colspan="7"><H1 class=Corte></H1></td></tr>
							  #ENCABEZADO_IMP#
							  <cfset contadorlineas = 1>  
						  </cfif>
						  <tr>
							<td class="listaCorte" colspan="7" nowrap>Centro Funcional: #rsSaldos.CFcodigo# - #rsSaldos.CFdescripcion#</td>
						  </tr>
						</cfif>
						  <tr>
							<td class="detalle">#rsSaldos.DEidentificacion#</td>
							<td class="detalle">#rsSaldos.NombreCompleto#</td>
							<td class="detalle">#rsSaldos.codRegimen#</td>
							<td class="detallec">#LSDateFormat(rsSaldos.FAntiguedad, 'dd/mm/yyyy')#</td>
							<cfif vMostrarDecimales >
								<td class="detaller">#LSNumberFormat(rsSaldos.saldoAsignado, ',9.00')#</td>
								<td class="detaller">#LSNumberFormat(rsSaldos.proporcional, ',9.00')#</td>
								<td class="detaller">#LSNumberFormat(rsSaldos.saldoProyectado, ',9.00')#</td>
							<cfelse>
								<td class="detaller">#fix(rsSaldos.saldoAsignado)#</td>
								<td class="detaller">#fix(rsSaldos.proporcional)#</td>
								<td class="detaller">#fix(rsSaldos.saldoProyectado)#</td>
							</cfif>
		
						  </tr>
						<cfset contadorlineas = contadorlineas + 1>  
					</cfloop>
				</cfoutput>
			<cfif isdefined('Url.imprimir')>
			  <tr><td colspan="7">&nbsp;</td></tr>
			  <tr><td colspan="7" align="center"><strong>------------------------ Fin del reporte ------------------------</strong></td></tr>
			</cfif>
			</table>
		</cfif>
	
