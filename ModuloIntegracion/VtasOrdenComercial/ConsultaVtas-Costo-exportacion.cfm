<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>

<cf_navegacion name="fltPeriodoIni" 	navegacion="" session default="-1">
<cf_navegacion name="fltPeriodoFin" 	navegacion="" session default="-1">
<cf_navegacion name="fltMesIni" 		navegacion="" session default="-1">
<cf_navegacion name="fltMesFin" 		navegacion="" session default="-1">
<cf_navegacion name="fltMoneda"  	    navegacion="" session default="-1">
<cf_navegacion name="Contrato"  	    navegacion="" session default="">

<cfquery name="rsReversion" datasource="#Session.DSN#">
	select Umes as NMes, Ecodigo, Uano as Periodo, Case Umes when 1 then 'Enero' when 2 then 'Febrero' when 3    then    'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when    9    then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end as Mes, 
	' '+ Orden_Comercial as Orden_Comercial, ' '+Moneda as Moneda,
	convert (varchar, convert (money,sum(Imp_Ingreso)),1) as Ingreso, convert (varchar, convert(money,sum(Imp_Costo)),1)    as Costo, convert(varchar, convert(money,sum(Imp_Ingreso) - sum(Imp_Costo)),1) as Margen
	from UtilidadVar U
	inner join UtilidadVarValor UV on U.ID_Utilidad = UV.ID_Utilidad
    where 1=1
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif form.fltPeriodoIni neq -1 and form.fltPeriodoFin neq -1>
		and Uano between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoIni#">  and
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoFin#">
	</cfif>
	<cfif form.fltMesIni neq -1 and form.fltMesFin neq -1>
		and Umes between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesIni#"> and
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesFin#">
	</cfif>
	<cfif form.fltMoneda neq "-1">
		and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
	</cfif>
	<cfif form.Contrato neq "">
	   	and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Contrato)#">
	</cfif>
	group by Ecodigo, Orden_Comercial, U.ID_Utilidad, Umes, Uano,  Moneda  
	union
	select 13 as NMes, null as Ecodigo, null as Uano, 'Total por Orden:' as Mes, 
	' '+ Orden_Comercial as Orden_Comercial, ' '+Moneda as Moneda, convert (varchar, convert (money,sum(Imp_Ingreso)),1) as Ingreso, convert (varchar, 					    convert(money,sum(Imp_Costo)),1)    as Costo, convert(varchar, convert(money,sum(Imp_Ingreso) - sum(Imp_Costo)),1) as 	 	Margen
	from UtilidadVar U
	inner join UtilidadVarValor UV on U.ID_Utilidad = UV.ID_Utilidad
	where 1=1
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif form.fltPeriodoIni neq -1 and form.fltPeriodoFin neq -1>
		and Uano between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoIni#">  and
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoFin#">
	</cfif>
	<cfif form.fltMesIni neq -1 and form.fltMesFin neq -1>
		and Umes between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesIni#"> and
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesFin#">
	</cfif>
	<cfif form.fltMoneda neq "-1">
		and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
	</cfif>
	<cfif form.Contrato neq "">
	   	and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Contrato)#">
	</cfif>
	group by Orden_Comercial, Moneda  
	union
	select 20 as NMes, null as Ecodigo, null as Uano, 'TOTALES' as Mes, 
	'----------------' as Orden_Comercial, Moneda, convert (varchar, convert (money,sum(Imp_Ingreso)),1) as Ingreso, convert (varchar, 					    convert(money,sum(Imp_Costo)),1)    as Costo, convert(varchar, convert(money,sum(Imp_Ingreso) - sum(Imp_Costo)),1) as 	 	Margen
	from UtilidadVar U
	inner join UtilidadVarValor UV on U.ID_Utilidad = UV.ID_Utilidad
	where 1=1
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif form.fltPeriodoIni neq -1 and form.fltPeriodoFin neq -1>
		and Uano between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoIni#">  and
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodoFin#">
	</cfif>
	<cfif form.fltMesIni neq -1 and form.fltMesFin neq -1>
		and Umes between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesIni#"> and
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMesFin#">
	</cfif>
	<cfif form.fltMoneda neq "-1">
		and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltMoneda)#">
	</cfif>
	<cfif form.Contrato neq "">
	   	and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Contrato)#">
	</cfif>
	group by Moneda
	order by Orden_Comercial, Moneda, NMes
</cfquery>

<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("rsReversion") and rsReversion.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif rsReversion.recordcount EQ 0>
	<cfthrow message="No existen registros que mostrar">
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Utilidad Bruta por Orden Comercial" 
			filename="UtilidadBrutaOrdComercial.xls" 
			ira="../VtasOrdenComercial/ConsultaVtas-Costo-form.cfm">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="130%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="12">&nbsp;</td>
						<td align="right"><strong>#DateFormat(now(),"DD/MM/YYYY")#</strong></td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>#rsEmpresa.Edescripcion#</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Utilidad Bruta por Orden Comercial</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="130%">
					<tr>
						<td nowrap align="rigth"><strong>Ecodigo</strong></td>
						<td nowrap align="rigth"><strong>Periodo</strong></td>
						<td nowrap align="rigth"><strong>Mes</strong></td>
						<td nowrap align="rigth"><strong>Orden Comercial</strong></td>
						<td nowrap align="rigth"><strong>Moneda</strong></td>
						<td nowrap align="rigth"><strong>Ingreso</strong></td>
						<td nowrap align="rigth"><strong>Costo</strong></td>
						<td nowrap align="rigth"><strong>Margen</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsReversion">
						<tr>
							<td nowrap>#rsReversion.Ecodigo#</td>
							<td nowrap>#rsReversion.Periodo#</td>
							<td nowrap><cfif #rsReversion.Mes# EQ 'Total por Orden:' or #rsReversion.Mes# EQ 'TOTALES'><strong>#rsReversion.Mes#</strong>
							<cfelse>#rsReversion.Mes#</cfif></td>
							<td nowrap><cfif #rsReversion.Mes# EQ 'Total por Orden:'><strong>#rsReversion.Orden_Comercial#			                            </strong><cfelse>#rsReversion.Orden_Comercial#</cfif></td>
							<td nowrap><cfif #rsReversion.Mes# EQ 'Total por Orden:' or #rsReversion.Mes# EQ 'TOTALES'><strong>#rsReversion.Moneda#</strong>
							<cfelse>#rsReversion.Moneda#</cfif></td>
							<td nowrap align="rigth"><cfif #rsReversion.Mes# EQ 'Total por Orden:' or #rsReversion.Mes# EQ 'TOTALES'><strong>#rsReversion.Ingreso#</strong>
							<cfelse>#rsReversion.Ingreso#</cfif></td>
							<td nowrap align="rigth"><cfif #rsReversion.Mes# EQ 'Total por Orden:' or #rsReversion.Mes# EQ 'TOTALES'><strong>#rsReversion.Costo#</strong>
							<cfelse>#rsReversion.Costo#</cfif></td>
							<td nowrap align="rigth"><cfif #rsReversion.Mes# EQ 'Total por Orden:' or #rsReversion.Mes# EQ 'TOTALES'><strong>#rsReversion.Margen#</strong>
							<cfelse>#rsReversion.Margen#</cfif></td>
						</tr>
					</cfloop>
				</table>
		</cfoutput>
</cfif>


