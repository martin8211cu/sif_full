<cfinclude template="../../../Utiles/sifConcat.cfm">
<!--- PARAMETROS --->
<cfif isdefined("url.CPformato")>
	<cfset varCPformato=url.CPformato>
</cfif>
<cfif isdefined("url.CPCano")>
	<cfset varCPCano=url.CPCano>
</cfif>
<cfif isdefined("url.CPCmes")>
	<cfset varCPNAPDtipoMov=url.CPNAPDtipoMov>
</cfif>
<cfif isdefined("url.CPCmes")>
	<cfset varCPCmes=url.CPCmes>
</cfif>
<cfif isdefined("url.CPPid")>
	<cfset varCPPid=url.CPPid>
</cfif>


<cf_web_portlet_start titulo="Detalle de saldo Presupuesto" Width="90%">
	<cfoutput>
		<!--- QUERY TOTAL SALDO NAPS --->
	<cfquery name="rsDatos" datasource="#Session.DSN#">
		SELECT pre.CPcuenta, det.Ocodigo
		FROM CPNAPdetalle det, CPresupuesto pre
		WHERE det.Ecodigo = pre.Ecodigo 
		AND det.CPcuenta = pre.CPcuenta
		<cfif isDefined("varCPformato") AND  #varCPformato# NEQ "">
		AND pre.CPformato like '%#varCPformato#%'
		</cfif>
		<cfif isDefined("varCPCano") AND  #varCPCano# NEQ "">
		AND CPCano = #varCPCano#
		</cfif>
		<cfif isDefined("varCPCmes") AND  #varCPCmes# NEQ "">
		AND CPCmes <= #varCPCmes#
		</cfif>
		<cfif isDefined("varCPNAPDtipoMov") AND  #varCPNAPDtipoMov# NEQ "">
		AND CPNAPDtipoMov = '#varCPNAPDtipoMov#'
		</cfif>
	</cfquery>
	<!--- <cfdump var="#rsDatos#"> --->
	<cfset sbGeneraEstilos()>
	<cfif #rsDatos.recordcount# NEQ 0>
		<cfset varCPcuenta=rsDatos.CPcuenta>
	<cfset varOcodigo=rsDatos.Ocodigo>
<!--- <cfoutput> 
	CPformato: #varCPformato#,
	CPCano: #varCPCano#,
	CPNAPDtipoMov: #varCPNAPDtipoMov#,
	CPCmes: #varCPCmes#,
	CPcuenta: #varCPcuenta#,
	Ocodigo: #varOcodigo#
	CPPid: #varCPPid#
</cfoutput> --->

<cfquery name="rsPresupuestoControl" datasource="#Session.DSN#">
	select 	a.CPPid, 
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion,
			a.CPCano, 
			a.CPCmes, 
			case 
				a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end 
			as Mdescripcion,
			a.CPcuenta, c.CPformato,
			(select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#varCPPid# and CPcuenta=c.CPcuenta) 
			as CPCPcalculoControl,
			coalesce(case (select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#varCPPid# and CPcuenta=c.CPcuenta)
				when 1 then 'MENSUAL' 
				when 2 then 'ACUMULADO'
				else 'TOTAL'
			end, 'N/A')	as CalculoControl,
			coalesce(case (select CPCPtipoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#varCPPid# and CPcuenta=c.CPcuenta)
				when 0 then 'ABIERTO' 
				when 1 then 'RESTRINGIDO'
				else 'RESTRICTIVO'
			end, 'N/A')	as TipoControl,
			a.Ocodigo, o.Odescripcion,
			e.Mcodigo, m.Mnombre
	  from CPresupuestoControl a, CPresupuestoPeriodo p, CPresupuesto c, Oficinas o, Empresas e, Monedas m
	 where a.Ecodigo	= #session.Ecodigo#
	   and a.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPPid#">
	   and a.CPCano 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCano#">
	   and a.CPCmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCmes#">
	   and a.CPcuenta 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPcuenta#">
	   and a.Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#varOcodigo#">
	   and p.Ecodigo	= a.Ecodigo
	   and p.CPPid 		= a.CPPid
	   and o.Ecodigo	= a.Ecodigo
	   and o.Ocodigo	= a.Ocodigo
	   and e.Ecodigo 	= a.Ecodigo
	   and m.Ecodigo 	= e.Ecodigo
	   and m.Mcodigo 	= e.Mcodigo
	   and c.CPcuenta 	= a.CPcuenta
</cfquery>


<cfquery name="rsPresupuestoControlMes" datasource="#Session.DSN#">
	select 
		   a.CPCpresupuestado, 
		   a.CPCmodificado,
		   a.CPCmodificacion_Excesos, 
		   a.CPCvariacion, 
		   a.CPCtrasladado, 
		   a.CPCtrasladadoE, 
		   a.CPCmodificacion_Excesos, 

		   a.CPCreservado_Anterior, 
		   a.CPCcomprometido_Anterior, 
		   a.CPCreservado_Presupuesto, 
		   a.CPCreservado, 
		   a.CPCcomprometido, 

		   a.CPCejecutado, a.CPCejecutadoNC,
		   (a.CPCejecutado + a.CPCejecutadoNC) - case when a.CPCejercido <> 0 then a.CPCejercido else a.CPCpagado end as CPCdevengado,
		   case when a.CPCejercido <> 0 then a.CPCejercido-a.CPCpagado else 0 end as CPCejercido,
		   a.CPCpagado as CPCpagado,

		   a.CPCnrpsPendientes,

		   a.CPCpresupuestado			+
		   a.CPCmodificado				+ 
		   a.CPCmodificacion_Excesos +
		   a.CPCvariacion				+
		   a.CPCtrasladado				+
		   a.CPCtrasladadoE				as PresupuestoAutorizado, 
		   a.CPCreservado_Anterior 		+
		   a.CPCcomprometido_Anterior 	+
		   a.CPCreservado_Presupuesto 	+
		   a.CPCreservado		+ 
		   a.CPCcomprometido	+ 
		   a.CPCejecutado + a.CPCejecutadoNC
		   								as PresupuestoConsumido,
		   a.CPCpresupuestado			+
		   a.CPCmodificado 				+
		   a.CPCmodificacion_Excesos +
		   a.CPCvariacion 				+
		   a.CPCtrasladado				+
		   a.CPCtrasladadoE				-
		   a.CPCreservado_Anterior 		-
		   a.CPCcomprometido_Anterior 	-
		   a.CPCreservado_Presupuesto 	-
		   a.CPCreservado		- 
		   a.CPCcomprometido	- 
		   a.CPCejecutado - a.CPCejecutadoNC
		   								as PresupuestoDisponible
	  from CPresupuestoControl a
	 where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPPid#">
	   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCano#">
	   and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCmes#">
	   and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPcuenta#">
	   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varOcodigo#">
</cfquery>



<cfquery name="rsPresupuestoControlAcumulado" datasource="#Session.DSN#">
	select 
		   sum(	a.CPCpresupuestado			) as CPCpresupuestado, 
		   sum(	a.CPCmodificado				) as CPCmodificado, 
		   sum(	a.CPCmodificacion_Excesos) as CPCmodificacion_Excesos, 
		   sum(	a.CPCvariacion				) as CPCvariacion, 
		   sum(	a.CPCtrasladado				) as CPCtrasladado, 
		   sum(	a.CPCtrasladadoE			) as CPCtrasladadoE, 

		   sum(	a.CPCreservado_Anterior		) as CPCreservado_Anterior, 
		   sum(	a.CPCcomprometido_Anterior	) as CPCcomprometido_Anterior, 
		   sum(	a.CPCreservado_Presupuesto	) as CPCreservado_Presupuesto, 
		   sum(	a.CPCreservado				) as CPCreservado, 
		   sum(	a.CPCcomprometido			) as CPCcomprometido, 

		   sum(a.CPCejecutado) as CPCejecutado, sum(a.CPCejecutadoNC) as CPCejecutadoNC,
		    
		   sum(	(a.CPCejecutado+a.CPCejecutadoNC) - case when a.CPCejercido <> 0 then a.CPCejercido else a.CPCpagado end ) as CPCdevengado,
		   sum(	case when a.CPCejercido <> 0 then a.CPCejercido-a.CPCpagado else 0 end ) as CPCejercido,
		   sum(	a.CPCpagado					) as CPCpagado,

		   sum(	a.CPCnrpsPendientes			) as CPCnrpsPendientes,

		   sum(	a.CPCpresupuestado			+
				a.CPCmodificado				+
				a.CPCmodificacion_Excesos +
				a.CPCvariacion				+
				a.CPCtrasladado				+
				a.CPCtrasladadoE 			) as PresupuestoAutorizado, 
		   sum(	a.CPCreservado_Anterior 	+
				a.CPCcomprometido_Anterior 	+
				a.CPCreservado_Presupuesto 	+
				a.CPCreservado				+ 
				a.CPCcomprometido			+ 
				a.CPCejecutado + a.CPCejecutadoNC
											) as PresupuestoConsumido,
		   sum(	a.CPCpresupuestado			+
				a.CPCmodificado				+
				a.CPCmodificacion_Excesos	+
				a.CPCvariacion				+
				a.CPCtrasladado				+
				a.CPCtrasladadoE 			-
				a.CPCreservado_Anterior 	-
				a.CPCcomprometido_Anterior 	-
				a.CPCreservado_Presupuesto 	-
				a.CPCreservado				-
				a.CPCcomprometido			-
				a.CPCejecutado - a.CPCejecutadoNC
											) as PresupuestoDisponible
	from CPresupuestoControl a
	where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPPid#">
	<cfif rsPresupuestoControl.CPCPcalculoControl EQ 1>
	and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCano#">
	and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCmes#">
	<cfelseif rsPresupuestoControl.CPCPcalculoControl EQ 2>
	and 
		(a.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCano#">
	  OR a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCano#">
	 and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCPCmes#">
		)
	</cfif>
	and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPcuenta#">
	and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varOcodigo#">
</cfquery>
<!--- <cf_dump var="#rsPresupuestoControlAcumulado#"> --->

	
<!--- Despliegue de Datos de Presupuesto --->
	<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	  <tr>
		<td class="fileLabel" align="right" style="font-size:14px" nowrap width="50%">Per&iacute;odo Presupuestario:&nbsp;</td>
		<td colspan="2" nowrap style="font-size:14px">#rsPresupuestoControl.Pdescripcion#</td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap style="font-size:14px">Mes Presupuestario:&nbsp;</td>
		<td colspan="2" nowrap style="font-size:14px">#rsPresupuestoControl.CPCano#-#rsPresupuestoControl.Mdescripcion#</td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap style="font-size:14px">Cuenta de Presupuesto:&nbsp;</td>
		<td colspan="2" nowrap style="font-size:14px">#rsPresupuestoControl.CPformato#</td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap style="font-size:14px">Oficina:&nbsp;</td>
		<td colspan="2" nowrap style="font-size:14px">#rsPresupuestoControl.Odescripcion#</td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap style="font-size:14px">Montos en Moneda Local:&nbsp;</td>
		<td colspan="2" nowrap style="font-size:14px">#rsPresupuestoControl.Mnombre#</td>
	  </tr>
	  <tr>
		<td class="fileLabel" align="right" nowrap style="font-size:14px">Tipo Control: #rsPresupuestoControl.TipoControl#&nbsp;</td>
		<td class="fileLabel" colspan="2" nowrap style="font-size:14px">M&eacute;todo Control: #rsPresupuestoControl.CalculoControl#</td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px">PARTIDA</td>
		<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px">&nbsp;&nbsp;ASIGNADO AL MES</td>
		<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px">&nbsp;&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#rsPresupuestoControl.CalculoControl#</cfif></td>
		<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Presupuesto Ordinario: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCpresupuestado, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCpresupuestado, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Presupuesto Extraordinario: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCmodificado, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCmodificado, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Excesos Autorizados:</td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCmodificacion_Excesos, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCmodificacion_Excesos, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Monto por Variacion Cambiaria: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCvariacion, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCvariacion, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Monto Trasladado: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCtrasladado, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCtrasladado, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Traslados con Autorizaci&oacute;n Externa: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCtrasladadoE, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCtrasladadoE, ',9.00')#</cfif></td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black; font-size:15px">TOTAL PRESUPUESTO AUTORIZADO: </td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-size:15px">(+)&nbsp;#LSNumberFormat(rsPresupuestoControlMes.PresupuestoAutorizado, ',9.00')#</td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-size:15px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(+)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoAutorizado, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Reservado Per&iacute;odo Anterior: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCreservado_Anterior, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado_Anterior, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Comprometido Per&iacute;odo Anterior: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCcomprometido_Anterior, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCcomprometido_Anterior, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Provisi&oacute;n Presupuestaria: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCreservado_Presupuesto, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado_Presupuesto, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Reservado: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCreservado, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Comprometido: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCcomprometido, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCcomprometido, ',9.00')#</cfif></td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel">Monto Ejecutado Contable: </td>
		<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCejecutado, ',9.00')#</td>
		<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutado, ',9.00')#</cfif></td>
		<td align="right" nowrap>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right" nowrap class="fileLabel" style="font-size:14px">Monto Ejecutado No Contable: </td>
		<td align="right" nowrap style="font-size:14px">#LSNumberFormat(rsPresupuestoControlMes.CPCejecutadoNC, ',9.00')#</td>
		<td align="right" nowrap style="font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutadoNC, ',9.00')#</cfif></td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="border-bottom: 1px solid black;border-top: 1px solid black; font-size:15px">TOTAL PRESUPUESTO CONSUMIDO: </td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black; font-size:15px">(-)&nbsp;#LSNumberFormat(rsPresupuestoControlMes.PresupuestoConsumido, ',9.00')#</td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;font-size:15px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(-)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoConsumido, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;font-size:15px">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="4" style="font-size:14px">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;font-size:15px">PRESUPUESTO DISPONIBLE ACTUAL: </td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px; font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.PresupuestoDisponible, ',9.00')#</td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold; font-size:14px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoDisponible, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-size:14px">&nbsp;</td>
	  </tr>
	  <!--- <tr>
		<td colspan="4">&nbsp;</td>
	  </tr> --->
	  <tr>
		<td colspan="4" style="font-size:12px">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##EEEEEE">
		<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;font-weight:bold; font-size:15px">EJECUTADO TOTAL: </td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold; font-size:15px">#LSNumberFormat(rsPresupuestoControlMes.CPCejecutado+rsPresupuestoControlMes.CPCejecutadoNC, ',9.00')#</td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold; font-size:15px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutado+rsPresupuestoControlAcumulado.CPCejecutadoNC, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##EEEEEE">
		<td align="right" nowrap class="fileLabel" style="font-size:15px">DEVENGADO: </td>
		<td align="right" nowrap style="font-weight:bold; font-size:15px">#LSNumberFormat(rsPresupuestoControlMes.CPCdevengado, ',9.00')#</td>
		<td align="right" nowrap style="font-weight:bold; font-size:15px">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCdevengado, ',9.00')#</cfif></td>
		<td align="right" nowrap style="font-size:14px">&nbsp;</td>
	  </tr>
	  <cfif rsPresupuestoControlMes.CPCejercido NEQ 0>
	  <tr bgcolor="##EEEEEE">
		<td align="right" nowrap class="fileLabel" style="">EJERCIDO: </td>
		<td align="right" nowrap style="font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCejercido, ',9.00')#</td>
		<td align="right" nowrap style="font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejercido, ',9.00')#</cfif></td>
		<td align="right" nowrap style="">&nbsp;</td>
	  </tr>
	  </cfif>
	  <tr bgcolor="##EEEEEE">
		<td align="right" nowrap class="fileLabel" style=";border-bottom: 1px solid black;">PAGADO: </td>
		<td align="right" nowrap style="border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCpagado, ',9.00')#</td>
		<td align="right" nowrap style="border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCpagado, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-bottom: 1px solid black;">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="4" style="font-size:12px">&nbsp;</td>
	  </tr>
	  <cfif rsPresupuestoControlMes.CPCnrpsPendientes NEQ 0 OR rsPresupuestoControl.CPCPcalculoControl NEQ 1 AND rsPresupuestoControlAcumulado.CPCnrpsPendientes NEQ 0>
		  <cfset LvarDisponibleNetoMes 			= rsPresupuestoControlMes.PresupuestoDisponible			+ rsPresupuestoControlMes.CPCnrpsPendientes>
		  <cfset LvarDisponibleNetoAcumulado 	= rsPresupuestoControlAcumulado.PresupuestoDisponible	+ rsPresupuestoControlAcumulado.CPCnrpsPendientes>
		  <tr bgcolor="##CCCCCC">
			<td align="right" nowrap class="fileLabel" style="border-bottom: 1px solid black;border-top: 1px solid black;">NRPs Aprobados Pendientes de Aplicar: </td>
			<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">#LSNumberFormat(rsPresupuestoControlMes.CPCnrpsPendientes, ',9.00')#</td>
			<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(+)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.CPCnrpsPendientes, ',9.00')#</cfif></td>
			<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		  <tr bgcolor="##CCCCCC">
			<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;">DISPONIBLE NETO ACTUAL: </td>
			<td align="right" nowrap style="<cfif LvarDisponibleNetoMes LT 0>color:##FF0000;</cfif>border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(LvarDisponibleNetoMes, ',9.00')#</td>
			<td align="right" nowrap style="<cfif LvarDisponibleNetoAcumulado LT 0>color:##FF0000;</cfif>border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(LvarDisponibleNetoAcumulado, ',9.00')#</cfif></td>
			<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
		  </tr>
	  </cfif>
	  <cfif isdefined("form.CVPcuenta")>
			<cfquery name="rsTotalModificacionMes" datasource="#session.dsn#">
				select 
					coalesce(CVFTmontoAplicar,0) as colonesModificar
				  from CVFormulacionTotales a
				 where a.Ecodigo = #session.ecodigo#
				   and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
				   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cpcano#">
				   and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cpcmes#">
				   and a.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvpcuenta#">
				   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
			</cfquery>

			<cfset LvarModificaMes = rsTotalModificacionMes.colonesModificar>
			<cfif LvarModificaMes EQ "">
				<cfset LvarModificaMes = 0>
			</cfif>

			<cfset LvarDisponibleMes = rsPresupuestoControlMes.PresupuestoDisponible + rsPresupuestoControlMes.CPCnrpsPendientes + LvarModificaMes>
			<cfquery name="rsTotalModificacionAcum" datasource="#session.dsn#">
				select 
					coalesce(sum(CVFTmontoAplicar),0) as colonesModificar
				  from CVFormulacionTotales a
				 where a.Ecodigo = #session.ecodigo#
				   and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
				<cfif rsPresupuestoControl.CPCPcalculoControl EQ 1>
				   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
				   and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
				<cfelseif rsPresupuestoControl.CPCPcalculoControl EQ 2>
				   and 
					   (a.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
				     OR a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
				    and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
					   )
				</cfif>
				   and a.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvpcuenta#">
				   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
			</cfquery>
			<cfset LvarModificaAcum = rsTotalModificacionAcum.colonesModificar>
			<cfset LvarDisponibleAcum = rsPresupuestoControlAcumulado.PresupuestoDisponible + rsPresupuestoControlAcumulado.CPCnrpsPendientes + LvarModificaAcum>
	  <tr>
		<td colspan="4">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="color:<cfif LvarModificaAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">Total Modificación Solicitada: </td>
		<td align="right" nowrap style="color:<cfif LvarModificaMes LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">#LSNumberFormat(LvarModificaMes, ',9.00')#</td>
		<td align="right" nowrap style="color:<cfif LvarModificaAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(*)#LSNumberFormat(LvarModificaAcum, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="color:<cfif LvarDisponibleAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">(**) Total <cfif LvarDisponibleAcum GTE 0>Disponible<cfelse>Exceso</cfif> Tentativo: </td>
		<td align="right" nowrap style="color:<cfif LvarDisponibleMes LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">#LSNumberFormat(LvarDisponibleMes, ',9.00')#</td>
		<td align="right" nowrap style="color:<cfif LvarDisponibleAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(*)#LSNumberFormat(LvarDisponibleAcum, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
	  </tr>
	  <cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>
	  <tr>
		<td colspan="4" style="">
			&nbsp;&nbsp;&nbsp;(*)&nbsp;&nbsp; Incluye solicitudes en otros meses<BR>
			&nbsp;&nbsp;&nbsp;(**) El monto disponible/exceso no es un valor fijo, cambia en linea<BR>
		</td>
	  </tr>
	  </cfif>
	 </cfif>
	</table>
	</cfif>
	</cfoutput>
<cf_web_portlet_end>


	<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	</style>
</cffunction>