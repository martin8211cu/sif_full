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
<cftransaction>

<!--- <cfset Url.imprimir =""> --->


	<!--- Tabla Temporal para almacenar los saldos de vacaciones --->
	<cf_dbtemp name="SaldosVacaciones" returnvariable="tbl_SaldosVacaciones">
		<cf_dbtempcol name="DEid" type="numeric" mandatory="yes"> 
		<cf_dbtempcol name="DEidentificacion" type="varchar(60)"> 
		<cf_dbtempcol name="NombreCompleto" type="varchar(100)"> 
		<cf_dbtempcol name="CFid" type="numeric" mandatory="yes">
		<cf_dbtempcol name="CFcodigo" type="varchar(10)">
		<cf_dbtempcol name="CFdescripcion" type="varchar(60)"> 
		<cf_dbtempcol name="Regimen" type="numeric">
		<cf_dbtempcol name="DiasRegimen" type="numeric">
		<cf_dbtempcol name="Antiguedad" type="datetime">
		<cf_dbtempcol name="DVEdisfrutados" type="numeric(18,4)">
		<cf_dbtempcol name="DVEcompensados" type="numeric(18,4)">
		<cf_dbtempcol name="DVEenfermedad" type="numeric(18,4)">
		<cf_dbtempcol name="AnyosLaborados" type="numeric">
		<cf_dbtempcol name="FechaCorteRegimen" type="datetime">
		<cf_dbtempcol name="FechaHoy" type="datetime">
		<cf_dbtempcol name="saldocorriente" type="float">
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
	<!------------------------------------------------------------------------------------------------------------------>
	<cfquery name="rsins" datasource="#Session.DSN#">
		insert into #tbl_SaldosVacaciones#(CFdescripcion, CFid, CFcodigo, Regimen, NombreCompleto, DEid, DEidentificacion, Antiguedad, DVEdisfrutados, DVEcompensados, DVEenfermedad)
		select	f.CFdescripcion, f.CFid, f.CFcodigo, b.RVid, 
				rtrim(rtrim(a.DEapellido1) || ' ' || a.DEapellido2) || ', ' || rtrim(a.DEnombre) as nombrecompleto, a.DEid, a.DEidentificacion, 
				coalesce(c.EVfantig, getdate()) as antiguedad,
				coalesce(sum(d.DVEdisfrutados), 0.00) as disfrutados, 
				coalesce(sum(d.DVEcompensados), 0.00) as compensados, 
				coalesce(sum(d.DVEenfermedad), 0.00) as enfermedad
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
		group by f.CFcodigo, f.CFdescripcion, f.CFid, b.RVid, rtrim(rtrim(a.DEapellido1) || ' ' || a.DEapellido2) || ', ' || rtrim(a.DEnombre), a.DEid, a.DEidentificacion, coalesce(c.EVfantig, getdate())
	</cfquery>
	
	<!--- días que corresponden a cada empleado según el régimen de vacaciones actual --->
	<!--- Se suma un año a los años laborados para poder sacar el proximo corte --->
	<!---
		rv2.DRVcant-1 <= #tbl_SaldosVacaciones#.AnyosLaborados es equivalente a decir
		rv2.DRVcant <= #tbl_SaldosVacaciones#.AnyosLaborados+1
	--->	
	<cfquery name="updDiasRegimen" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set DiasRegimen = (
							select coalesce(rv.DRVdias, 0)
							from DRegimenVacaciones rv
							where rv.RVid = #tbl_SaldosVacaciones#.Regimen
							  and rv.DRVcant = ( 
							  	select coalesce(max(rv2.DRVcant), 1) 
								from DRegimenVacaciones rv2 
								where rv2.RVid = #tbl_SaldosVacaciones#.Regimen
								and rv2.DRVcant-1 <= #tbl_SaldosVacaciones#.AnyosLaborados
							)
						  )
	</cfquery>
	
	
	
	
	
	
	<!--- Cantidad de años transcurridos entre fecha de ingreso y fecha de hoy (parte entera) --->
	
	<cfquery name="updAnyos" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set AnyosLaborados = floor(datediff(yy, Antiguedad, FechaHoy))
	</cfquery>
	
<!--- 	<cfquery name="updDiasRegimen" datasource="#Session.DSN#">
			 update #tbl_SaldosVacaciones#
					set DiasRegimen = (
						select 	sum(b.DVEdisfrutados+b.DVEcompensados)
						from EVacacionesEmpleado a
						inner join DVacacionesEmpleado b
						   on a.DEid = b.DEid
						where a.DEid = #tbl_SaldosVacaciones#.DEid
						<cfif isdefined("Form.Fcorte") and Len(Trim(Form.Fcorte))>
							and b.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fcorte)#">
						<cfelse>
							and b.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						</cfif>						  

					)
	</cfquery> --->
	
	<!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, año en curso) hasta la fecha de hoy --->
	
	
	<!--- <cfset meses = DateDiff('m', Form.Fcorte, Now())>
	<cfset dias = DateDiff('d', DateAdd('m', meses, Form.Fcorte), Now())>
	<cfset meses = meses + (dias / 30.0)>

	
	<cfquery name="updDiasRegimen" datasource="#Session.DSN#">
	update #tbl_SaldosVacaciones#
	set DiasRegimen =  DiasRegimen + (((
						select coalesce(rv.DRVdias, 0)
						from DRegimenVacaciones rv
						where rv.RVid = #tbl_SaldosVacaciones#.Regimen
						  and rv.DRVcant = ( 
							select coalesce(max(rv2.DRVcant), 1) 
							from DRegimenVacaciones rv2 
							where rv2.RVid = #tbl_SaldosVacaciones#.Regimen
							and rv2.DRVcant-1 <= #tbl_SaldosVacaciones#.AnyosLaborados
						)
					  )*#meses#)/12)
	</cfquery> --->
	
	

	<!--- Fecha de Hoy --->
	<cfquery name="updFechaHoy" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set FechaHoy = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fcorte)#">
	</cfquery>


	<!--- Ultima fecha de corte por el Regimen de Vacaciones --->
	<cfquery name="updFCorte" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set FechaCorteRegimen = dateadd(yy, AnyosLaborados, Antiguedad)
	</cfquery>

	<!--- Calculo de meses adicionales despues de Fecha de Corte --->
	<cfquery name="updSaldo" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set saldocorriente = datediff(dd, FechaCorteRegimen, FechaHoy) / 30
	</cfquery>

	<!--- Calculo de dias adicionales menor al mes después de Fecha de Corte --->
	<cfquery name="updSaldo" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set saldocorriente = saldocorriente + (datediff(dd, dateadd(mm, saldocorriente, FechaCorteRegimen), FechaHoy) / 30.0)
	</cfquery>

	<!--- Calculo de dias que le corresponden segun tiempo transcurrido a partir de la Fecha de Corte del Regimen --->
	<cfquery name="updSaldo" datasource="#Session.DSN#">
		update #tbl_SaldosVacaciones#
		set saldocorriente = (saldocorriente * DiasRegimen) / 12.0
	</cfquery>
	
	<cfquery name="rsSaldos" datasource="#Session.DSN#">
		select DEidentificacion,DiasRegimen,DVEdisfrutados, DVEcompensados,saldocorriente,(DVEdisfrutados + DVEcompensados + saldocorriente) as SaldoVacaciones
		from #tbl_SaldosVacaciones#
		order by CFcodigo, CFdescripcion, CFid, NombreCompleto
	</cfquery>	
	<cfdump var="#rsSaldos#">
	

	<cfquery name="rsSaldos" datasource="#Session.DSN#">
		select CFdescripcion, 
			   CFid,
			   CFcodigo,
			   DEidentificacion,
			   NombreCompleto, 
			   Antiguedad,
			   (DVEdisfrutados + DVEcompensados + saldocorriente) as SaldoVacaciones, 
			   DVEenfermedad as SaldoEnfermedad
		from #tbl_SaldosVacaciones#
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
	
	<cfoutput>
	<cfsavecontent variable="ENCABEZADO_IMP">
		<td colspan="4">
			<!--- Encabezado --->
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td colspan="3" align="center" class="tituloAlterno"><strong><font size="3">#Session.Enombre#</font></strong></td>
			  </tr>
			  <tr>
				<td nowrap colspan="3">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="3" align="center"><strong><font size="3">Consulta de Saldos de Vacaciones</font></strong></td>
			  </tr>
			<cfif isdefined("Form.Fcorte") and Len(Trim(Form.Fcorte))>
			  <tr>
				<td colspan="3" align="center"><font size="2"><strong>Fecha de Corte:&nbsp;</strong>#Form.Fcorte#</font></td>
			  </tr>
			</cfif>
			  <tr>
				<td colspan="3" align="center"><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></td>
			  </tr>
			  <tr>
				<td colspan="3" nowrap>&nbsp;</td>
			  </tr>
			</table>
		</td>
		</tr>
		<tr>
		<td class="titulolistas">Identificaci&oacute;n</td>
		<td class="titulolistas">Empleado</td>
		<td class="titulolistas" align="center">Fecha de Ingreso</td>
		<td class="titulolistas" align="right">Saldo d&iacute;as ordinarios</td>
		</tr>
	</cfsavecontent>
		<!----- Pintado Encabezado ----->
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

		<cfset contadorlineas = 1>
		<cfset primercorte = true>
		<cfif rsSaldos.recordCount>
			<cfset corte = ''>

			<cfloop query="rsSaldos">
				<cfif (isdefined('Url.imprimir') and contadorlineas gte 50 and rsSaldos.CurrentRow NEQ 1) or  primercorte>
				  #ENCABEZADO_IMP#
				  <tr>
					<td class="listaCorte" colspan="4" nowrap>Centro Funcional: #rsSaldos.CFcodigo# - #rsSaldos.CFdescripcion#</td>
				  </tr>
				  <cfset corte = rsSaldos.CFid>
				  <cfset primercorte = false>
				  <cfset contadorlineas = 1>  
				</cfif> <!--- Fin de isdefined('Url.imprimir') and rsSaldos.CurrentRow mod 35 EQ 0 and rsSaldos.CurrentRow NEQ 1 --->
				
				<cfif corte NEQ rsSaldos.CFid>
				  <cfset corte = rsSaldos.CFid>
				  <cfif isdefined('Url.imprimir') and  isdefined('Form.CORTECF')>
					  <tr><td colspan="4">&nbsp;</td></tr>
			 		  <tr>
			 		    <td colspan="4" align="center"><strong>------------------------ Ultima l&iacute;nea para este centro funcional ------------------------</strong></td>
			 		  </tr>
					  <tr><td colspan="4"><H1 class=Corte></H1></td></tr>
					  #ENCABEZADO_IMP#
					  <cfset contadorlineas = 1>  
				  </cfif>
				  <tr>
					<td class="listaCorte" colspan="4" nowrap>Centro Funcional: #rsSaldos.CFcodigo# - #rsSaldos.CFdescripcion#</td>
				  </tr>
				</cfif>
				  <tr>
					<td class="detalle">#rsSaldos.DEidentificacion#</td>
					<td class="detalle">#rsSaldos.NombreCompleto#</td>
					<td class="detallec">#LSDateFormat(rsSaldos.Antiguedad, 'dd/mm/yyyy')#</td>
					<td class="detaller">#LSNumberFormat(rsSaldos.SaldoVacaciones, ',9.00')#</td>
				  </tr>
				<cfset contadorlineas = contadorlineas + 1>  
			</cfloop>
			<cfif isdefined('Url.imprimir')>
			  <tr><td colspan="4">&nbsp;</td></tr>
			  <tr><td colspan="4" align="center"><strong>------------------------ Fin del reporte ------------------------</strong></td></tr>
			</cfif>
			</table>
		</cfif>
	</cfoutput>
	
</cftransaction>
