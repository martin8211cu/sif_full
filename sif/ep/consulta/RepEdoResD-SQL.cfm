<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->

<cfoutput>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#"></cfif>
<cfif isdefined("url.Unidad") and not isdefined("form.Unidad")>
	<cfparam name="form.Unidad" default="#url.Unidad#"></cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#"></cfif>
<cfif isdefined("url.mcodigoopt") and not isdefined("form.mcodigoopt")>
	<cfparam name="form.mcodigoopt" default="#url.mcodigoopt#"></cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#"></cfif>
<cfif isdefined("url.formato") and not isdefined("form.formato")>
	<cfparam name="form.formato" default="#url.formato#"></cfif>
<cfif isdefined("url.mensAcum") and not isdefined("form.mensAcum")>
	<cfparam name="form.mensAcum" default="#url.mensAcum#"></cfif>
<cfif isdefined("url.chkCeros")>
	<cfparam name="form.chkCeros" default="1">
<cfelse>
   	<cfparam name="form.chkCeros" default="0">
</cfif>
<cfif isdefined("url.PrIngAprob") and not isdefined("form.PrIngAprob")>
	<cfparam name="form.PrIngAprob" type="numeric" default="#url.PrIngAprob#"></cfif>
<cfif isdefined("url.PrIngModif") and not isdefined("form.PrIngModif")>
	<cfparam name="form.PrIngModif" type="numeric" default="#url.PrIngModif#"></cfif>
</cfoutput>
<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaInicio = #DateFormat(CreateDate(form.periodo,#form.mes#,01),"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
        <cfset LabelFechaInicio = #DateFormat(CreateDate(form.periodo,#form.mes#,01),"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaInicio = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>
<!---  <cf_dump var="#form#"> --->
<cfinvoke key="MSG_SitucionFDet" default="Estado de Resultados"	returnvariable="MSG_SitucionFDet"
component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfif #form.Unidad# eq 1>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en"				returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #form.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en miles de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #form.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en millones de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 100000>
</cfif>

<cfinvoke key="LB_Concepto" 		default="Concepto"	returnvariable="LB_Concepto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total" 		default="Total"	returnvariable="LB_Total"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Descripcion" default="Descripci&oacute;n"		returnvariable="MSG_Descripcion"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Momentos" 	default="Momentos contables del ingreso"	returnvariable="MSG_Momentos"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Propuesto" 	default="Presupuesto de Ingresos"			returnvariable="MSG_Propuesto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Aprobado" 	default="Aprobado"			returnvariable="MSG_Aprobado"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Recibir" 	default="por Recibir"		returnvariable="MSG_Recibir"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Modificado" 	default="Modificado"		returnvariable="MSG_Modificado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 	default="Periodo"			returnvariable="MSG_Periodo"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Devengado" 	default="Devengado"			returnvariable="MSG_Devengado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Cobrado" 	default="Cobrado"			returnvariable="MSG_Cobrado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Avance" 		default="Avance de cobro"	returnvariable="MSG_Avance"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_CobrApr" 	default="(cobrado/aprobado)"	returnvariable="MSG_CobrApr"		component="sif.Componentes.Translate" method="Translate"/>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo,cliente_empresarial
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsAliasEmpresa" datasource="asp">
    select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = #rsNombreEmpresa.cliente_empresarial#
</cfquery>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select
        case Mnombre
        when 'Mexico, Peso' then 'Pesos'
        else Mnombre
	end as Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #rsNombreEmpresa.Mcodigo#
</cfquery>

<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
	<cfset varMcodigo = form.Mcodigo>
    <cfset varMonlocal= "false">
<cfelse>
	<cfset varMcodigo = #rsNombreEmpresa.Mcodigo#>
    <cfset varMonlocal= "true">
</cfif>

<cfset LvarIrA = 'RepEdoResD.cfm'>
<cfset LvarFile = 'RepEdoResD'>
<cfset Request.LvarTitle = #MSG_SitucionFDet#>

<!---<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
--->
<cfset rsAnoMes = #form.periodo#&left("0"&#form.mes#,2)>
<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #rsAnoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>
<cfoutput>
<cfif rsCPPid.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
<!--- <cfelse>
    <cfquery name="rsCuentas" datasource="#Session.DSN#">
        select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where (m.CPTMtipoMov in ('D','A','M','VC','E','P') or m.CPTMtipoMov in ('T1','T6','T7'))
                    and Cmayor <> 'NULL'
            order by c.Cmayor
    </cfquery>
<!---Verificación de las cuentas de mayor entre la estructura programática y la parametrización de la contabilidad presupuestaria--->
    <cfloop query="rsCuentas">
        <cfquery name="rsVerifCuentas" datasource="#Session.DSN#">
            select m.CGEPCtaMayor,r.SPcodigo
            from dbo.CGEstrProgCtaM m
            inner join CGEstrProg ep
            on ep.ID_Estr=m.ID_Estr
			inner join CGReEstrProg r
            on r.ID_Estr=ep.ID_Estr
            where r.SPcodigo='#session.menues.SPCODIGO#'

            and m.CGEPCtaMayor = #rsCuentas.Cmayor#
        </cfquery>
        <cfif rsVerifCuentas.RecordCount eq 0>
            <cfset rsMensaje = "No se encuentran parametrizadas en la estructura programática las cuentas de la contabilidad presupuestaria">
        </cfif>
    </cfloop> --->
</cfif>

<cfif isdefined('rsMensaje')>
	<cflocation url="RepSitFinD.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>

<cfquery name="rsNumEst" datasource="#session.dsn#">
	select top 1 r.ID_Estr, r.ID_Firma from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>

<cfset permes = form.periodo>
<cfset periodoAnt = form.periodo -1>
<cfset permesAnt = (form.periodo - 1)>


<cfinvoke returnvariable="rsArbol" component="sif.ep.componentes.EP_EstrGruposCmayor" method="CG_EstructuraGrupo">
	<!--- <cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#"> --->
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
	<cfinvokeargument name="incluyeCuentas"	value="N">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<cfquery name="aaa" datasource="#session.dsn#">
	select * from #rsArbol#
</cfquery>

<cfinvoke returnvariable="arrsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosMesesAnt" method="SaldosAnteriores">
 <cfinvokeargument name="IDEstrPro" value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio"  value="#form.periodo#">
    <cfinvokeargument name="MesInicio"  value="#form.mes#">
    <cfinvokeargument name="PerFin"  value="#form.periodo#">
    <cfinvokeargument name="MesFin"  value="#form.mes#">
    <cfinvokeargument name="MonedaLoc"  value="#varMonlocal#">
    <cfinvokeargument name="PerIniPP"  value="#form.periodo#">
    <cfinvokeargument name="MesIniPP"  value="#form.mes#">
    <cfinvokeargument name="GvarConexion"  value="#session.dsn#">
 	<cfinvokeargument name="Mcodigo"   value="#varMcodigo#">
</cfinvoke>

<cfquery name="rssaldos" datasource="#session.dsn#">
	select EPCodigo,SaldoG,SaldoGA from (
		select ar.EPCodigo,isnull(sSaldoG.SaldoG,0.00) SaldoG,isnull(sSaldoGA.SaldoG,0.00) SaldoGA
		from #rsArbol# ar
		left join (
			select EPCodigo, SaldoG from (
				select right(Orden,1) EPCodigo, sum(SaldoG) SaldoG from (
					select left(ar.Orden,3) Orden,  sum(SaldoG) SaldoG
					from #rsArbol# ar
					left join (
						select Cmayor, sum(isnull(<cfif #form.mensAcum# eq 2> SLinicial + </cfif>DLdebitos - CLcreditos,0)/#varUnidad#) SaldoG
						from #arrsSaldoMes[1]#
						group by Cmayor
					) saldo
						on ar.Cmayor = saldo.Cmayor
					group by left(ar.Orden,3)
				) sGrupo
				group by right(Orden,1)
			) sSaldo
		) sSaldoG
			 on ar.EPCodigo = sSaldoG.EPCodigo
		left join (
			select EPCodigo, SaldoG from (
				select right(Orden,1) EPCodigo, sum(SaldoG) SaldoG from (
					select left(ar.Orden,3) Orden,  sum(SaldoG) SaldoG
					from #rsArbol# ar
					left join (
						select Cmayor, sum(isnull(<cfif #form.mensAcum# eq 2> SLinicial + </cfif>DLdebitos - CLcreditos,0)/#varUnidad#) SaldoG
						from #arrsSaldoMes[2]#
						group by Cmayor
					) saldo
						on ar.Cmayor = saldo.Cmayor
					group by left(ar.Orden,3)
				) sGrupo
				group by right(Orden,1)
			) sSaldo
		) sSaldoGA
			 on ar.EPCodigo = sSaldoGA.EPCodigo
		where Nivel = 1
	) a
	order by EPCodigo

</cfquery>

<cfquery name="rsResult" datasource="#session.dsn#">
	select ar.Cmayor, ar.EPCodigo, ar.EPGdescripcion, ar.Nivel, ar.Orden, ar.DescripcionCmayor,isnull(sSaldoG.SaldoG,0.00) SaldoG,isnull(sSaldoGA.SaldoG,0.00) SaldoGA
	from #rsArbol# ar
	left join (
		select EPCodigo, SaldoG from (
			select right(Orden,1) EPCodigo, sum(SaldoG) SaldoG from (
				select left(ar.Orden,3) Orden,  sum(SaldoG) SaldoG
				from #rsArbol# ar
				left join (
					select Cmayor, sum(isnull(<cfif #form.mensAcum# eq 2> SLinicial + </cfif>DLdebitos - CLcreditos,0)/#varUnidad#) SaldoG
					from #arrsSaldoMes[1]#
					group by Cmayor
				) saldo
					on ar.Cmayor = saldo.Cmayor
				group by left(ar.Orden,3)
			) sGrupo
			group by right(Orden,1)
		) sSaldo
	) sSaldoG
		 on ar.EPCodigo = sSaldoG.EPCodigo
	left join (
		select EPCodigo, SaldoG from (
			select right(Orden,1) EPCodigo, sum(SaldoG) SaldoG from (
				select left(ar.Orden,3) Orden,  sum(SaldoG) SaldoG
				from #rsArbol# ar
				left join (
					select Cmayor, sum(isnull(<cfif #form.mensAcum# eq 2> SLinicial + </cfif>DLdebitos - CLcreditos,0)/#varUnidad#) SaldoG
					from #arrsSaldoMes[2]#
					group by Cmayor
				) saldo
					on ar.Cmayor = saldo.Cmayor
				group by left(ar.Orden,3)
			) sGrupo
			group by right(Orden,1)
		) sSaldo
	) sSaldoGA
		 on ar.EPCodigo = sSaldoGA.EPCodigo
	where Nivel = 1
	union all
	 select null, '2.1','Utilidad Bruta',1,'0/2.1',null,#rssaldos["SaldoG"][1]-rssaldos["SaldoG"][2]#,#rssaldos["SaldoGA"][1]-rssaldos["SaldoGA"][2]#
	union all
	 select null, '3.1','Gastos de Operacion (Presupuestarios)',1,'0/3.1',null,#rssaldos["SaldoG"][4]+rssaldos["SaldoG"][5]#,#rssaldos["SaldoGA"][4]+rssaldos["SaldoGA"][5]#
	union all
	 select null, '5.1','Utilidad de Operación (o Pérdida de Operación)',1,'0/5.1',null,#rssaldos["SaldoG"][1]-rssaldos["SaldoG"][2]+rssaldos["SaldoG"][3]-rssaldos["SaldoG"][4]+rssaldos["SaldoG"][5]#,
	 		#rssaldos["SaldoGA"][1]-rssaldos["SaldoGA"][2]+rssaldos["SaldoGA"][3]-rssaldos["SaldoGA"][4]+rssaldos["SaldoGA"][5]#
	union all
	 select null, '8.1','Utilidad o Perdida Neta antes de ISR y PTU',1,'0/8.1',null,#rssaldos["SaldoG"][1]-rssaldos["SaldoG"][2]+rssaldos["SaldoG"][3]-rssaldos["SaldoG"][4]+rssaldos["SaldoG"][5] +rssaldos["SaldoG"][6]+rssaldos["SaldoG"][7]-rssaldos["SaldoG"][8]#,
	 		#rssaldos["SaldoGA"][1]-rssaldos["SaldoGA"][2]+rssaldos["SaldoGA"][3]-rssaldos["SaldoGA"][4]+rssaldos["SaldoGA"][5]+rssaldos["SaldoGA"][6]+rssaldos["SaldoGA"][7]-rssaldos["SaldoGA"][8]#
	order by EPCodigo
</cfquery>

    <cfoutput>
        <cf_htmlreportsheaders
            title="#request.LvarTitle#"
            filename="#LvarFile#-#Session.Usucodigo#.xls"
            ira="#LvarIrA#">
        <cfif not isdefined("btnDownload")>
            <cf_templatecss>
        </cfif>
    </cfoutput>
    <cfflush interval="20">
    <cfoutput>
		<style type="text/css" >
            .corte {
                font-weight:bold;
            }
        </style>
        <table width="80%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF" align="center">
            <tr>
                <td style="font-size:16px" align="center" colspan="6">
                <strong>#rsNombreEmpresa.Edescripcion#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" >
                    <strong>#MSG_SitucionFDet#</strong>
                </td>
            </tr>
			<tr>
                <td style="font-size:16px" align="center" nowrap="nowrap">
                	<strong>
					 Del #LabelFechaInicio# al #LabelFechaFin#
						<cfif #form.mensAcum# eq 1>
						   (Mensual)
						<cfelse>
							(Acumulado)
						</cfif>
					</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" ><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
		<table width="80%" border="0" align="center">
			<tr>
            	<td valign="top">
					<table width="100%" cellspacing="0">
						<tr style="background-color:lightblue;">
						  <td nowrap width="50%" align="center"><strong>&nbsp;</strong></td>
						  <td nowrap align="center" colspan="2"><strong>Año</strong></td>
						</tr>
					  	<tr style="background-color:lightblue;">
						  <td nowrap width="50%" align="center"><strong>#LB_Concepto#</strong></td>
						  <td nowrap align="center">#permes#</td>
						  <td nowrap align="center">#permesAnt#</td>
					  	</tr>
			        	<cfloop query="rsResult">
				            <tr>
						       <td align="left"><cfif len(EPCodigo) GT 1><strong></cfif>#EPGdescripcion#<cfif len(EPCodigo) GT 1></strong></cfif></td>
						       <td nowrap align="right">#LSNumberFormat(rsResult.SaldoG, ',9.00')#</td>
						       <td nowrap align="right">#LSNumberFormat(rsResult.SaldoGA, ',9.00')#</td>
						    </tr>
						</cfloop>
					</table>
				</td>
            </tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
		</table>
		<table width="80%" cellpadding="0" cellspacing="0" align="center">
            <tr>
                <td style="font-size:16px" align="center" colspan="3">
					<cfset idFirma = 0>
					<cfif rsNumEst.ID_Firma NEQ "">
						<cfset idFirma=rsNumEst.ID_Firma>
	                	<cfinvoke component="sif.ep.componentes.EP_Firmas" method="RP_PieFirma">
								<cfinvokeargument name="IdFirma"	value="#idFirma#">
							    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
						</cfinvoke>
					</cfif>
				</td>
            </tr>
         </table>
    </cfoutput>
