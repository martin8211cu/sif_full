<cfquery name="rsReporte" datasource="#Session.DSN#">
	select 
		lt.DEid,
		cf.CFid,
		cf.CFcodigo, cf.CFdescripcion, 
		<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2 ,' ',de.DEnombre">  as nombre,
		de.DEidentificacion,
		ev.DVAperiodo,
		ev.DVAsaldodias,
		ev.DVASalarioPdiario,
		ev.DVASalarioProm,
		(ev.DVAsaldodias * ev.DVASalarioPdiario) as MontoVac
	from LineaTiempo lt
	inner join RHPlazas p
		on lt.RHPid = p.RHPid
		and lt.Ecodigo = p.Ecodigo
	inner join CFuncional cf
		on p.CFid = cf.CFid
		and p.Ecodigo = cf.Ecodigo
	inner join DatosEmpleado de
		on lt.DEid = de.DEid
	inner join DVacacionesAcum  ev
		on de.DEid = ev.DEid
		and de.Ecodigo = ev.Ecodigo
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and  ev.DVAsaldodias > 0
	and ev.DVASalarioPdiario > 0
	and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta 
	<cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) and isdefined("form.CFcodigo") and len(trim(form.CFcodigo))>
		and cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigo#"> 
	</cfif>	
	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and lt.DEid = 	#form.DEid#
	</cfif>
	order by CFcodigo,<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2 ,' ',de.DEnombre">,ev.DVAperiodo asc
</cfquery>

<cfquery name="rsRepTotal"  dbtype="query">
	select DVAperiodo, sum(MontoVac) as MontoVac from rsReporte
	group by DVAperiodo
</cfquery>



<cfif rsReporte.recordcount GT 3000 >
	<cfoutput>
	<table width="100%" border="0">
	  <tr>
		<td>&nbsp;</td>
		<td><cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se gener&oacute; un reporte más grande de lo permitido.  Proceso Cancelado!</cf_translate></td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	</cfoutput>
<cfelseif rsReporte.recordcount EQ 0>
	<cfoutput>
	<table width="100%" border="0">
	  <tr>
		<td>&nbsp;</td>
		<td><cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate></td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	</cfoutput>
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_VacacionesAcumuladas"
	Default="Vacaciones Acumuladas por Per&iacute;odo"
	returnvariable="LB_VacacionesAcumuladas"/> 
	
	<cfset LvarFileName = "#LB_VacacionesAcumuladas#_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

	<cf_htmlReportsHeaders 
	title="#LB_VacacionesAcumuladas#" 
	filename="#LvarFileName#"
	irA="VacacionesAcum.cfm"> 

	<style type="text/css">
		.RLTtopline {
			border-bottom-width: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}	
		
		.LTtopline { 
			border-bottom-width: none;
			border-bottom-width: none;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}	
		.LRTtopline {
			border-bottom-width: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}
		
		.RTtopline {
			border-bottom-width: none;
			border-bottom-width: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}	
		
		.Completoline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}	
		
		.topline {
				border-top-width: 1px;
				border-top-style: solid;
				border-top-color: #000000;
				border-right-style: none;
				border-bottom-style: none;
				border-left-style: none;
			}
		
		.bottonline {
				border-bottom-width: 1px;
				border-bottom-style: solid;
				border-bottom-color: #000000;
				border-right-style: none;
				border-top-style: none;
				border-left-style: none;
			}
			
		.RLTbottomline {
			border-top-width: none;
			border-left-width: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000			
		}	
		
		.RLTbottomline2 {
			border-top-width: none;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000			
		}
		
		
		.LTbottomline {
			border-top-width: none;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000			
		}
		
		.Lline {
			border-top-width: none;
			border-bottom-width: none;
			border-right-width: none;

			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;

		}
		.Rline {
			border-top-width: none;
			border-bottom-width: none;
			border-left-width: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
		}
		
		.RLline {
			border-top-width: none;
			border-bottom-width: none;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
		}
				
	</style>
	<cfoutput>
	<cfset centrofuncional = -1>
	<cfset Empleado = -1>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="6">
				<cf_EncReporte
				Titulo   ="#LB_VacacionesAcumuladas#" 
				MostrarPagina="false">
			</td>
		</tr>
		<cfloop query="rsReporte">
			<cfif centrofuncional neq rsReporte.CFid>
				<tr>
					<td   bgcolor="##E3EDEF" colspan="6" class="Completoline" align="left" width="40%">
						<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>#rsReporte.CFcodigo# &nbsp; #rsReporte.CFdescripcion#</font>
					</td>
				</tr>
				<tr>
					<td class="LTtopline" align="left" width="40%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Colaborador">Colaborador</cf_translate></font></b>
					</td>
					<td class="LTtopline" align="center" width="10%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Perido">Per&iacute;odo</cf_translate></font></b>
					</td>
					<td class="LTtopline" align="center" width="10%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_SaldoVacaciones">Saldo Vacaciones</cf_translate></font></b>
					</td>
					<td class="LTtopline" align="right" width="10%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_SalarioPromedio">Salario Promedio</cf_translate></font></b>
					</td>
					<td class="LTtopline" align="right" width="10%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_SalarioDiario">Salario Diario</cf_translate></font></b>
					</td>
					<td class="RTtopline" align="right" width="10%">
						<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_MontoVacaciones">Monto Vacaciones</cf_translate></font></b>
					</td>
				</tr>
				<cfset centrofuncional = rsReporte.CFid>
			</cfif>
			<cfif Empleado neq rsReporte.DEid>
				<tr>
					<td class="LTtopline" align="left" width="40%">
						<font  style="font-size:11px; font-family:'Arial'">#rsReporte.DEidentificacion#&nbsp;#rsReporte.nombre#</font>
					</td>
					<td class="LTtopline" align="center" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#rsReporte.DVAperiodo#</font>
					</td>
					<td class="LTtopline" align="center" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#rsReporte.DVAsaldodias#</font>
					</td>
					<td class="LTtopline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.DVASalarioProm,',.00')#</font>
					</td>
					<td class="LTtopline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.DVASalarioPdiario,',.00')#</font>
					</td>
					<td class="RLTtopline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.MontoVac,',.00')#</font>
					</td>
				</tr>
				<cfset Empleado = rsReporte.DEid>
			<cfelse>
				<tr>
					<td class="Lline" align="left" width="40%">
						&nbsp;
					</td>
					<td class="Lline" align="center" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#rsReporte.DVAperiodo#</font>
					</td>
					<td class="Lline" align="center" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#rsReporte.DVAsaldodias#</font>
					</td>
					<td class="Lline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.DVASalarioProm,',.00')#</font>
					</td>
					<td class="Lline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.DVASalarioPdiario,',.00')#</font>
					</td>
					<td class="RLline" align="right" width="10%">
						<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.MontoVac,',.00')#</font>
					</td>
				</tr>
			</cfif>
		</cfloop>
		 <tr>
			<td class="topline"  colspan="6" align="center">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td   bgcolor="##E3EDEF" colspan="6" class="Completoline" align="left" >
				<b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_TotalPeriodos">Total Por Per&iacute;odo</cf_translate></font></b>
			</td>
		</tr>		
		<tr>
			<td colspan="6"  class="Completoline" align="right">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="right">
					<cfloop query="rsRepTotal">
						<tr>
							<td align="right" width="80%">
								&nbsp;
							</td>
							<td align="right" width="10%">
								<b><font  style="font-size:13px; font-family:'Arial'">#rsRepTotal.DVAperiodo#</font></b>
							</td>
							<td  align="right" width="10%">
								<font  style="font-size:13px; font-family:'Arial'">#LSNumberFormat(rsRepTotal.MontoVac,',.00')#</font>
							</td>
						</tr>
					</cfloop>
				</table>
			</td>	
		</tr>			
	</table>
	</cfoutput>
</cfif>

