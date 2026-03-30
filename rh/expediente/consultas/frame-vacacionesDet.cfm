<cfset vMostrarDecimales = true >
<cfquery name="rsDecimales" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=600
</cfquery>
<cfif rsDecimales.Pvalor eq 1 >
	<cfset vMostrarDecimales = false >
</cfif>

<cfquery name="rsVacacionesDet" datasource="#Session.DSN#">
	select 	DVEfecha as Fecha,
			DVEdescripcion as Descripcion,
			DVEdisfrutados as Disfrutados,
			DVEcompensados as Compensados,
			DVEmonto as Monto
			,(select sum(b.DVEdisfrutados+b.DVEcompensados)
				from DVacacionesEmpleado b
				where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
				   <!--- LZ Se convierte el DVEfecha a su expresion sin horas y minutos --->
				   and <cf_dbfunction name="to_date00"	args="b.DVEfecha"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> ) as Disponibles
	from DVacacionesEmpleado
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
		and (abs(DVEdisfrutados)+abs(DVEcompensados) > 0) and abs(DVEenfermedad) = 0
	order by DVEfecha, DVEfalta
</cfquery>

<cfquery name="rsVacacionesEnfDet" datasource="#Session.DSN#">
	select DVEfecha as Fecha,
		DVEdescripcion as Descripcion,
		DVEenfermedad as Enfermedad,
		DVEmonto as Monto
	from DVacacionesEmpleado
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and (abs(DVEdisfrutados)+abs(DVEcompensados) = 0) and abs(DVEenfermedad) > 0
	order by DVEfecha, DVEfalta
</cfquery>

<cfif rsVacacionesDet.recordCount GT 0>
<cfquery name="rsSaldoVac" dbtype="query">
	select sum(Disfrutados+Compensados) as Saldo
	from rsVacacionesDet
</cfquery>
<!--- PROCESO PARA CALCULAR EL SALDO PROYECTADO  --->
<cfquery name="rsFIngreso" datasource="#session.DSN#">
	select min(de.DLfvigencia) as Ingreso
	from DLaboralesEmpleado de
	inner join RHTipoAccion ta 
	   on de.RHTid = ta.RHTid
	  and de.Ecodigo =  ta.Ecodigo
	  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and ta.RHTcomportam = 1
	where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
</cfquery> 
<cfset saldo_corriente = 0>
<cfset saldoalcorte = 0>
<!--- Regimen de Vacaciones --->
<cfquery name="rsRegimen" datasource="#session.DSN#">
	select RVid 
	from LineaTiempo 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
</cfquery>

<!--- LZ Se analiza si la Liquidacion ya ha sido cerrada, para que entonces se Elimine o no el Saldo de Vacaciones --->
<cfif rsRegimen.RecordCount LTE 0>
		<cfquery name="rsRegimen" datasource="#session.DSN#">
			select RVid
			from LineaTiempo a
			Where a.LTid in (Select Max(LTid)
						   from LineaTiempo
						   where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
			  				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> >= LThasta)
			and  exists (Select 1
							 from DLaboralesEmpleado b, RHLiquidacionPersonal c
							 Where <cf_dbfunction name="dateadd" args="#1#,a.LThasta,DD"> = b.DLfvigencia
							 and a.DEid=b.DEid
							 and b.DLlinea=c.DLlinea
							 and c.RHLPestado=0
							 )
		</cfquery>
</cfif>

<cfif rsRegimen.RecordCount gt 0 and len(trim(rsRegimen.RVid))>
	<!--- Este nuevo calculo de saldo proyectado fue modificado por C. Elizondo el día  13/07/2006 --->
	
	<!--- Fecha de antiguedad, a partir de esta fecha se realizan los calculos --->
	<cfquery name="rsFechaIngreso" datasource="#session.DSN#">
		select EVfantig as ingreso,
			coalesce(EVfecha, EVfantig) as cortevacaciones
			,coalesce(EVfecha,EVfantig) as fechaUltimaVaca
		from EVacacionesEmpleado 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	</cfquery>	
	
	<cfif rsFechaIngreso.recordCount gt 0 and len(trim(rsFechaIngreso.ingreso)) >
		<!--- para pruebas
		<cfset tmp = Createdate('2003','04','01') >		
		<cfset vFecha = ListToArray(LSDateFormat(tmp,'dd/mm/yyyy'),'/')>
		--->

		<cfset vFecha = ListToArray(LSDateFormat(rsFechaIngreso.ingreso,'dd/mm/yyyy'),'/')>
		<!--- objeto date con la fecha de ingreso --->
		<cfset fecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
		<!--- calcula la cantidad de años laborados, a partir de su ingreso --->
		<cfset anno = DateDiff('yyyy', fecha_ingreso, Now())>

		<!--- objeto date con la fecha del último corte --->
		<cfset fecha_corte = rsFechaIngreso.cortevacaciones>

		<!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, año en curso) hasta la fecha de hoy --->
		<cfset meses = DateDiff('d', fecha_corte, Now())>
		
		<!--- <cfset dias = DateDiff('d', DateAdd('m', meses, fecha_corte), Now())>
		<cfset meses = meses + (dias / 30.0)> --->
		<cfset meses = meses  / 30.0>

		<!---

		<!--- objeto date con el dia y mes de ingreso, pero con el año actual --->
		<cfset fecha_actual = Createdate(datepart('yyyy',Now()),vFecha[2],vfecha[1]) >
		
		<!--- calcula la cantidad de meses desde la fecha_actual(dia, mes de ingreso, año en curso) hasta la fecha de hoy --->
		<cfset meses = (datediff('d', fecha_actual, now()))/30 >
		
		<!--- calcula la cantidad de años laborados, a partir de su ingreso --->
		<cfset anno = ((datediff('d', fecha_ingreso, now()))/30)/12 >
		
		--->
		
		<!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de años laborados --->
		<cfquery name="rsDias" datasource="#session.DSN#">
			select coalesce(rv.DRVdias, 0) as DRVdias
			from DRegimenVacaciones rv 
			where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
			  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
								 from DRegimenVacaciones rv2 
								 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
								   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
		</cfquery>

		<!--- calcula el saldo corriente de vacaciones --->
		<cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
			<cfset saldo_corriente = (rsDias.DRVdias*meses)/12>
		</cfif>
		<!---======= Saldo de vacaciones al corte (saldo total de vacaciones acumulado al ultimo mes cumplido de antigüedad del empleado)=======---->
		<cfset mesescorte = DateDiff('m', rsFechaIngreso.fechaUltimaVaca, Now())><!---Meses entre la ultima fecha en que se le sumaron dias de vacaciones---->
		<cfset saldoalcorte = (mesescorte*rsDias.DRVdias)/12.0><!----Meses * los dias por mes (segun regimen de vacaciones del empleado)---->
		<!---El saldo al corte son los dias ganados (de periodos anteriores) + los dias ganados al ultimo mes cumplido del periodo actual--->
		<cfif rsVacacionesDet.RecordCount NEQ 0>
			<cfset saldoalcorte = saldoalcorte + rsVacacionesDet.Disponibles >
		</cfif>
	</cfif>
</cfif>
<cfif Len(Trim(rsSaldoVac.Saldo))>
	<cfset disponibles = rsSaldoVac.Saldo + saldo_corriente >
<cfelse>
	<cfset disponibles = saldo_corriente >
</cfif>
<cfquery name="rsMostrarSaldoCorte" datasource="#session.DSN#">
	select Pvalor from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 890
</cfquery>


<cfoutput>
<table width="100%"  border="0" cellpadding="0" cellspacing="0">
<tr> 
  <td class="tituloListas" align="center" nowrap><cf_translate key="InicioDeVacaciones">Inicio de Vacaciones</cf_translate></td>
  <td class="tituloListas" nowrap><cf_translate key="Descripcion">Descripci&oacute;n</cf_translate></td>
  <td class="tituloListas" align="right" nowrap><cf_translate key="DiasDisfrutados">D&iacute;as Disfrutados</cf_translate></td>
  <td class="tituloListas" align="right" nowrap><cf_translate key="DiasCompensados">D&iacute;as Compensados</cf_translate></td>
  <td class="tituloListas" align="right" nowrap><cf_translate key="Monto">Monto</cf_translate></td>
</tr>
<cfloop query="rsVacacionesDet">
<tr> 
  <td <cfif #rsVacacionesDet.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="center">#LSDateFormat(rsVacacionesDet.Fecha,'dd/mm/yyyy')#</td>
  <td <cfif #rsVacacionesDet.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>>#rsVacacionesDet.Descripcion#</td>
  <td <cfif #rsVacacionesDet.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="right">#LSCurrencyFormat(rsVacacionesDet.Disfrutados,'none')#</td>
  <td <cfif #rsVacacionesDet.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="right">#LSCurrencyFormat(rsVacacionesDet.Compensados,'none')#</td>
  <td <cfif #rsVacacionesDet.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="right">#LSCurrencyFormat(rsVacacionesDet.Monto,'none')#</td>
</tr>
</cfloop>
<tr> 
  <td  colspan="5"  align="left" bgcolor="##CCCCCC">
  	<font size="3">
		<b><cf_translate key="SaldoAsignado">Saldo Asignado</cf_translate>:</b>
		&nbsp;&nbsp;<cfif vMostrarDecimales >#LSCurrencyFormat(rsSaldoVac.Saldo,'none')#<cfelse>#fix(rsSaldoVac.Saldo)#</cfif>
 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<b><cf_translate key="SaldoProyectado">Saldo Proyectado</cf_translate>:</b>
		&nbsp;&nbsp;<cfif vMostrarDecimales >#LSCurrencyFormat(disponibles,'none')#<cfelse>#fix(disponibles)#</cfif>
		<cfif rsMostrarSaldoCorte.RecordCount NEQ 0 and rsMostrarSaldoCorte.Pvalor EQ 1>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<b><cf_translate key="SaldoAlCorte">Saldo al Corte</cf_translate>:</b>
			&nbsp;&nbsp;#fix(saldoalcorte)#
		</cfif>
	</font>
  </td>
</tr>
</cfoutput>
<cfelse>
    <cf_translate key="MSG_ElEmpleadoNoTieneVacacionesDefinidasActualmente">El empleado no tiene vacaciones definidas actualmente</cf_translate>	
</cfif>

<cfif rsVacacionesEnfDet.recordCount GT 0>
<cfquery name="rsSaldoVacEnf" dbtype="query">
	select sum(Enfermedad) as Saldo
	from rsVacacionesEnfDet
</cfquery>
<cfoutput>
<tr><td>&nbsp;</td></tr>

<tr> 
  <td colspan="5" class="#Session.preferences.Skin#_thcenter"><cf_translate key="DETALLEDEDIASDEENFERMEDAD">DETALLE DE DIAS DE ENFERMEDAD</cf_translate></td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr> 
  <td colspan="5" align="right" bgcolor="##CCCCCC"><font size="2"><b><cf_translate key="SaldoDeDiasDeEnfermedad">Saldo de D&iacute;as de Enfermedad</cf_translate>: </b>&nbsp;&nbsp;<cfif vMostrarDecimales >#LSCurrencyFormat(rsSaldoVacEnf.Saldo,'none')#<cfelse>#fix(rsSaldoVacEnf.Saldo)#</cfif> </font></td>
</tr>
<tr> 
  <td class="tituloListas" align="center" nowrap><cf_translate key="InicioDeVacaciones">Inicio de Vacaciones</cf_translate></td>
  <td class="tituloListas" nowrap><cf_translate key="Descripcion">Descripci&oacute;n</cf_translate></td>
  <td class="tituloListas" colspan="3" align="right" nowrap><cf_translate key="DiasEnfermedad">D&iacute;as Enfermedad</cf_translate></td>
</tr>
<cfloop query="rsVacacionesEnfDet">
<tr> 
  <td class="listCenterContentNon" align="center">#LSDateFormat(rsVacacionesEnfDet.Fecha,'dd/mm/yyyy')#</td>
  <td class="listCenterContentNon">#rsVacacionesEnfDet.Descripcion#</td>
  <td colspan="3" class="listCenterContentNon" align="right"><cfif vMostrarDecimales >#LSCurrencyFormat(rsVacacionesEnfDet.Enfermedad,'none')#<cfelse>#fix(rsVacacionesEnfDet.Enfermedad)#</cfif></td>
</tr>
</cfloop>

</table>
<script language="JavaScript1.2" type="text/javascript">
	function regresar() {
		document.form1.action = '<cfoutput>#Form.regresar#</cfoutput>';
		document.form1.submit();
	}
</script>	
<form style="margin:0;" name="form1" method="post">
	<input type="hidden" name="DEid" value="<cfoutput>#rsEmpleado.DEid#</cfoutput>">
	<input type="hidden" name="o" value="1">
</form>
</cfoutput>
<cfelse>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>

		<tr> 
		  <td class="#Session.preferences.Skin#_thcenter"><cf_translate key="DETALLEDEDIASDEENFERMEDAD">DETALLE DE DIAS DE ENFERMEDAD</cf_translate></td>
		</tr>

		<tr><td><cf_translate key="MSG_ElEmpleadoNoTieneDiasDeEnfermedadDefinidosActualmente">El empleado no tiene dias de enfermedad definidos actualmente</cf_translate></td></tr>
	</table>
</cfoutput>
</cfif>
