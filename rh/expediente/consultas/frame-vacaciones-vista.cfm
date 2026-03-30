

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<table cellpadding="6" cellspacing="6" border="0" width="100%">
	
	<tr>
	  <td class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>"><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></td>
	</tr>
		  
  <tr>
      <td valign="top" nowrap>
		  <cfset rsEmpleado.DEid = form.DEid>
		  <cfinclude template="../../expediente/consultas/frame-vacaciones.cfm">
	  </td>
    </tr>
	
	
	<tr>
      <td valign="top" nowrap align="center">
		  <cfinvoke component="sif.Componentes.Translate"
			method="Translate" key="BTN_Regresar" default="Regresar"
			xmlfile="/rh/generales.xml" returnvariable="BTN_Regresar"/>
			<input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1" onclick="javascript: history.back();">
	  </td>
    </tr>
	
	
</table>


  <tr>
      <td valign="top" nowrap>
		
<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 17 de enero del 2006
	Motivo: se agregaron tres datos mas para desplegar. Fecha de Ingreso, Fecha de Anualidades y Fecha de Vacaciones.
 --->
<!---
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
<cfquery name="rsVacaciones" datasource="#Session.DSN#">
	select 	a.DEid, 
			EVfantig as Antiguedad, 
			EVfanual as Anualidad,
			EVfvacas as Vacaciones,
			coalesce(sum(b.DVEdisfrutados+b.DVEcompensados),0) as Disponibles, 
			sum(b.DVEenfermedad) as DVEenfermedad
	from EVacacionesEmpleado a
	left outer join DVacacionesEmpleado b
	   on a.DEid = b.DEid
	   <!--- LZ Se convierte el DVEfecha a su expresion sin horas y minutos --->
	   and <cf_dbfunction name="to_date00"	args="b.DVEfecha"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	group by a.DEid, EVfantig,EVfanual,EVfvacas
</cfquery>
<cfquery name="rsFIngreso" datasource="#session.DSN#">
	select max(de.DLfvigencia) as Ingreso
	from DLaboralesEmpleado de
	inner join RHTipoAccion ta 
	   on de.RHTid = ta.RHTid
	  and de.Ecodigo =  ta.Ecodigo
	  <!--- and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> --->
	  and ta.RHTcomportam in (1,9)
	where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
<!-----======= Dias de vacaciones acumulados de periodos anteriores ========---> 
<cfquery name="RSDvacacionesAcum" datasource="#session.dsn#">
	Select DVAperiodo, DVASalarioProm, DVAsaldodias
	from DVacacionesAcum
	where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		and DVAsaldodias > 0
</cfquery>		
<!--- ************************************************** --->
<!--- Calculo saldo corriente de Vacaciones 			 --->
<!--- ************************************************** --->
<cfset saldo_corriente = 0>
<cfset saldoalcorte = 0>
<!--- Regimen de Vacaciones --->
<cfquery name="rsRegimen" datasource="#session.DSN#">
	select RVid 
	from LineaTiempo 
	where 
	 <!---  Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	  and ---> 
	  DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
</cfquery>

<!--- LZ Se analiza si la Liquidacion ya ha sido cerrada, para que entonces se Elimine o no el Saldo de Vacaciones --->
<cfif rsRegimen.RecordCount LTE 0>
		<cfquery name="rsRegimen" datasource="#session.DSN#">
			select RVid
			from LineaTiempo a
			Where a.LTid in (Select Max(LTid)
						   from LineaTiempo
						   where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> >= LThasta)
			and  exists (Select 1
							 from DLaboralesEmpleado b, RHLiquidacionPersonal c
							 Where <cf_dbfunction name="dateadd" args="1, a.LThasta"> = b.DLfvigencia
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
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
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
		<!--- <cfset dias = DateDiff('d', DateAdd('m', meses, fecha_corte), Now())>--->
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
			<cfset saldo_corriente = (rsDias.DRVdias*meses)/12.0>
		</cfif>
		<!---======= Saldo de vacaciones al corte (saldo total de vacaciones acumulado al ultimo mes cumplido de antigüedad del empleado)=======---->
		<cfset mesescorte = DateDiff('m', rsFechaIngreso.fechaUltimaVaca, Now())><!---Meses entre la ultima fecha en que se le sumaron dias de vacaciones---->
		<cfset saldoalcorte = (mesescorte*rsDias.DRVdias)/12.0><!----Meses * los dias por mes (segun regimen de vacaciones del empleado)---->
		<!---El saldo al corte son los dias ganados (de periodos anteriores) + los dias ganados al ultimo mes cumplido del periodo actual--->
		<cfif rsVacaciones.RecordCount NEQ 0>
			<cfset saldoalcorte = saldoalcorte + rsVacaciones.Disponibles >
		</cfif>
	</cfif>
</cfif>
<cfquery name="rsMostrarSaldoCorte" datasource="#session.DSN#">
	select Pvalor from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 890
</cfquery>

<!--- ************************************************** --->
<!--- ************************************************** --->
<cfoutput>
	<cfif rsVacaciones.recordCount GT 0>
		<script type="text/javascript" language="JavaScript">
			function showDetalleVacaciones() {
				document.formVacaciones.submit();
			}
		</script>
	</cfif>
	<form name="formVacaciones" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
		<input type="hidden" name="dvacemp" value="1">
		<input type="hidden" name="Regresar" value="#GetFileFromPath(GetTemplatePath())#">
		<cfif isdefined("Form.o")><input type="hidden" name="o" value="#Form.o#"></cfif>
		<cfif isdefined("Form.sel")><input type="hidden" name="sel" value="#Form.sel#"></cfif>
		<cfif isdefined("Form.DEid")><input type="hidden" name="DEid" value="#Form.DEid#"></cfif>
		<cfif isdefined("rsVacaciones") and  Len(Trim(rsVacaciones.Disponibles)) >
			<cfset disponibles = rsVacaciones.Disponibles + saldo_corriente >
		<cfelse>
			<cfset disponibles = saldo_corriente >
		</cfif>
		<table width="100%" cellpadding="2" cellspacing="2" align="center" border="0">
			<tr <cfif rsVacaciones.recordCount GT 0>onClick="javascript: showDetalleVacaciones();" style="cursor: pointer;" 
				onMouseOver="javascript: style.color = 'red'" onMouseOut="javascript: style.color = 'black'"</cfif>>
				<td width="15%" class="fileLabel" align="right" nowrap><cf_translate key="SaldoProyectado">Saldo Proyectado </cf_translate>	</td>
				<td width="15%" nowrap><cfif vMostrarDecimales >#LSCurrencyFormat(disponibles,'none')#<cfelse>#fix(disponibles)#</cfif></td>
			  <td width="15%" class="fileLabel" align="right" nowrap><cf_translate key="SaldoAsignado">Saldo Asignado</cf_translate>
			    </td>
				<td width="15%" nowrap><cfif Len(Trim(rsVacaciones.Disponibles)) NEQ 0><cfif vMostrarDecimales >#LSCurrencyFormat(rsVacaciones.Disponibles,'none')#<cfelse>#fix(rsVacaciones.Disponibles)#</cfif><cfelse>0</cfif></td>
				<cfif rsMostrarSaldoCorte.RecordCount NEQ 0 and rsMostrarSaldoCorte.Pvalor EQ 1>
					<td width="15%" class="fileLabel" align="right" nowrap>
						<cf_translate key="SaldoAlCorte">Saldo Al Corte</cf_translate>
					</td>
					<td width="15%" nowrap>#fix(saldoalcorte)#</td>
				<cfelse>
					<td width="15%" class="fileLabel" align="right" nowrap><cf_translate key="DiasEnfermedad">D&iacute;as de Enfermedad</cf_translate></td>
					<td width="15%" nowrap><cfif Len(Trim(rsVacaciones.DVEenfermedad)) NEQ 0><cfif vMostrarDecimales >#LSCurrencyFormat(rsVacaciones.DVEenfermedad,'none')#<cfelse>#fix(rsVacaciones.DVEenfermedad)#</cfif><cfelse>0.00</cfif></td>
				</cfif>
			</tr>
			<tr>
				<td class="fileLabel" align="right" nowrap><cf_translate key="FechaIngreso">Fecha de Ingreso</cf_translate></td>
				<td nowrap><cfif Len(Trim(rsFIngreso.Ingreso)) NEQ 0>#LSDateFormat(rsFIngreso.Ingreso,'dd/mm/yyyy')#<cfelse><cf_translate key="NoDefinida">No Definida</cf_translate></cfif></td>
				<td class="fileLabel" align="right" nowrap><cf_translate key="FechadeAnualidad">Fecha de Anualidad</cf_translate> </td>
				<td nowrap><cfif Len(Trim(rsVacaciones.Anualidad)) NEQ 0>#LSDateFormat(rsVacaciones.Anualidad,'dd/mm/yyyy')#<cfelse><cf_translate key="NoDefinida">No Definida</cf_translate></cfif></td>
				<td class="fileLabel" align="right" nowrap><cf_translate key="FechadeVacaciones">Fecha de Vacaciones</cf_translate> </td>
				<td nowrap><cfif Len(Trim(rsVacaciones.Vacaciones)) NEQ 0>#LSDateFormat(rsVacaciones.Vacaciones,'dd/mm/yyyy')#<cfelse><cf_translate key="NoDefinida">No Definida</cf_translate></cfif></td>
			</tr>
			<tr>
				<td width="15%" class="fileLabel" align="right" nowrap><cf_translate key="FechaDeAntiguedad">Fecha de Antig&uuml;edad</cf_translate></td>
				<td nowrap><cfif Len(Trim(rsVacaciones.Antiguedad)) NEQ 0>#LSDateFormat(rsVacaciones.Antiguedad,'dd/mm/yyyy')#<cfelse><cf_translate key="NoDefinida">No Definida</cf_translate></cfif></td>
				<cfif rsMostrarSaldoCorte.RecordCount NEQ 0 and rsMostrarSaldoCorte.Pvalor EQ 1>
					<td width="15%" class="fileLabel" align="right" nowrap><cf_translate key="DiasEnfermedad">D&iacute;as de Enfermedad</cf_translate></td>
					<td width="15%" nowrap><cfif Len(Trim(rsVacaciones.DVEenfermedad)) NEQ 0><cfif vMostrarDecimales >#LSCurrencyFormat(rsVacaciones.DVEenfermedad,'none')#<cfelse>#fix(rsVacaciones.DVEenfermedad)#</cfif><cfelse>0.00</cfif></td>
				</cfif>
			</tr>
			<!-----Dias acumulados de periodos pasados ----->
			<cfif isdefined("RSDvacacionesAcum") and RSDvacacionesAcum.recordcount neq 0>						  	
				
				<tr>
					<td colspan="6">
						<fieldset><legend><i><cf_translate key="LB_DiasAcumuladosDeVacaciones">D&iacute;as Acumulados de Vacaciones</cf_translate></legend></i>
							<table width="100%" cellpadding="0" cellspacing="0">									
								<tr bgcolor="##CCCCCC">
									<td><strong><cf_translate key="LB_Periodo">Periodo</cf_translate></strong></td>
									<td align="center"><strong><cf_translate key="LB_DiasDisponibles">D&iacute;as Disponibles</cf_translate></strong></td>
									<td align="right"><strong><cf_translate key="LB_Salario_Promedio">Salario Promedio</cf_translate></strong></td>
								</tr>
								<cfloop query="RSDvacacionesAcum">
									<cfset LvarListaNon = (RSDvacacionesAcum.CurrentRow MOD 2)>
									<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
									<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
										<td>#RSDvacacionesAcum.DVAperiodo#</td>
										<td align="center">#RSDvacacionesAcum.DVAsaldodias#</td>
										<td align="right">#LSNumberFormat(RSDvacacionesAcum.DVASalarioProm, '999,999,999.99')#</td>
									</tr>
								</cfloop>
							</table>
						</fieldset>
					</td>
				</tr>
			</cfif>												
	  </table>
	</form>
</cfoutput>

 </td>
    </tr>
</table>--->