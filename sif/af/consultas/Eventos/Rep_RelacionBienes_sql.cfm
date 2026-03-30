<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Relaci&oacute;n de bienes que componen su patrimonio" returnvariable="LB_Titulo" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo"
returnvariable="LB_Periodo" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="A"
returnvariable="LB_Mes" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Categoria" default="Categor&iacute;a"
returnvariable="LB_Categoria" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Placa" default="C&oacute;digo"
returnvariable="LB_Placa" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Desc" default="Descripci&oacute;n del Bien"
returnvariable="LB_Desc" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Valor en Libros"
returnvariable="LB_Monto" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha"
returnvariable="LB_Fecha" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hora" default="Hora"
returnvariable="LB_Hora" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cifras" default="Cifras en Pesos y Centavos"
returnvariable="LB_Cifras" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Bienes" default="Muebles e Inmuebles"
returnvariable="LB_Bienes" xmlfile="Rep_RelacionBienes_sql.xml"/>
<!--- Meses --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Enero" default="Enero"
returnvariable="LB_Enero" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Febrero" default="Febrero"
returnvariable="LB_Febrero" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Marzo" default="Marzo"
returnvariable="LB_Marzo" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Abril" default="Abril"
returnvariable="LB_Abril" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayo" default="Mayo"
returnvariable="LB_Mayo" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Junio" default="Junio"
returnvariable="LB_Junio" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Julio" default="Julio"
returnvariable="LB_Julio" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Agosto" default="Agosto"
returnvariable="LB_Agosto" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Septiembre" default="Septiembre"
returnvariable="LB_Septiembre" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Octubre" default="Octubre"
returnvariable="LB_Octubre" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Noviembre" default="Noviembre"
returnvariable="LB_Noviembre" xmlfile="Rep_RelacionBienes_sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Diciembre" default="Diciembre"
returnvariable="LB_Diciembre" xmlfile="Rep_RelacionBienes_sql.xml"/>

<!---<cfset form.Resumido =1>--->
<cfset params = '' >
<cfif isdefined("form.codigodesde") and len(trim(form.codigodesde)) >
	<cfset params = params & "&codigodesde=#form.codigodesde#">
</cfif>
<cfif isdefined("form.ACinicio") and len(trim(form.ACinicio)) >
	<cfset params = params & "&ACinicio=#form.ACinicio#">
</cfif>
<cfif isdefined("form.ACdescripciondesde") and len(trim(form.ACdescripciondesde)) >
	<cfset params = params & "&ACdescripciondesde=#form.ACdescripciondesde#">
</cfif>
<cfif isdefined("form.codigohasta") and len(trim(form.codigohasta)) >
	<cfset params = params & "&codigohasta=#form.codigohasta#">
</cfif>
<cfif isdefined("form.AChasta") and len(trim(form.AChasta)) >
	<cfset params = params & "&AChasta=#form.AChasta#">
</cfif>
<cfif isdefined("form.ACdescripcionhasta") and len(trim(form.ACdescripcionhasta)) >
	<cfset params = params & "&ACdescripcionhasta=#form.ACdescripcionhasta#">
</cfif>
<cfif isdefined("form.AidDesde") and len(trim(form.AidDesde)) >
	<cfset params = params & "&AidDesde=#form.AidDesde#">
</cfif>
<cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde)) >
	<cfset params = params & "&AplacaDesde=#form.AplacaDesde#">
</cfif>
<cfif isdefined("form.AdescripcionDesde") and len(trim(form.AdescripcionDesde)) >
	<cfset params = params & "&AdescripcionDesde=#form.AdescripcionDesde#">
</cfif>
<cfif isdefined("form.AidHasta") and len(trim(form.AidHasta)) >
	<cfset params = params & "&AidHasta=#form.AidHasta#">
</cfif>
<cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta)) >
	<cfset params = params & "&AplacaHasta=#form.AplacaHasta#">
</cfif>
<cfif isdefined("form.AdescripcionHasta") and len(trim(form.AdescripcionHasta)) >
	<cfset params = params & "&AdescripcionHasta=#form.AdescripcionHasta#">
</cfif>
<cfif isdefined("form.periodoInicial") and len(trim(form.periodoInicial)) >
	<cfset params = params & "&periodoInicial=#form.periodoInicial#">
</cfif>
<cfif isdefined("form.mesInicial") and len(trim(form.mesInicial)) >
	<cfset params = params & "&mesInicial=#form.mesInicial#">
</cfif>
<cfif isdefined("form.EstadoActivo") and len(trim(form.EstadoActivo)) >
	<cfset params = params & "&EstadoActivo=#form.EstadoActivo#">
</cfif>

<cfif isdefined("form.SalidaActivo") and len(trim(form.SalidaActivo)) >
	<cfset params = params & "&SalidaActivo=#form.SalidaActivo#">
</cfif>

<cf_htmlreportsheaders
        title="#LB_Titulo#"
        filename="#LB_Titulo##session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls"
       ira="Rep_RelacionBienes.cfm?#params#"
	  >
<cfif isdefined("url.ACinicio") and not isdefined("form.ACinicio")>
	<cfset form.ACinicio = url.ACinicio>
</cfif>

<cfif isdefined("url.AChasta") and not isdefined("form.AChasta")>
	<cfset form.AChasta = url.AChasta>
</cfif>

<cfif isdefined("url.CFcodigoinicio") and not isdefined("form.CFcodigoinicio")>
	<cfset form.CFcodigoinicio = url.CFcodigoinicio>
</cfif>

<cfif isdefined("url.CFcodigofinal") and not isdefined("form.CFcodigofinal")>
	<cfset form.CFcodigofinal = url.CFcodigofinal>
</cfif>

<cfif isdefined("url.AidDesde") and not isdefined("form.AidDesde")>
	<cfset form.AidDesde = url.AidDesde>
</cfif>

<cfif isdefined("url.AidHasta") and not isdefined("form.AidHasta")>
	<cfset form.AidHasta = url.AidHasta>
</cfif>
<cfif isdefined("url.periodoInicial") and not isdefined("form.periodoInicial")>
	<cfset form.periodoInicial = url.periodoInicial>
</cfif>

<cfif isdefined("url.mesInicial") and not isdefined("form.mesInicial")>
	<cfset form.mesInicial = url.mesInicial>
</cfif>

<cfif isdefined("url.EstadoActivo") and not isdefined("form.EstadoActivo")>
	<cfset form.EstadoActivo = url.EstadoActivo>
</cfif>

<cfif isdefined("url.SalidaActivo") and not isdefined("form.SalidaActivo")>
	<cfset form.SalidaActivo = url.SalidaActivo>
</cfif>


<cfif isdefined("url.CFdescripcionInicio") and not isdefined("form.CFdescripcionInicio")>
	<cfset form.CFdescripcionInicio = url.CFdescripcionInicio>
</cfif>
<cfif isdefined("url.CFdescripcionFinal") and not isdefined("form.CFdescripcionFinal")>
	<cfset form.CFdescripcionFinal = url.CFdescripcionFinal>
</cfif>
<cfif isdefined("url.ACDescripcionDesde") and not isdefined("form.ACDescripcionDesde")>
	<cfset form.ACDescripcionDesde = url.ACDescripcionDesde>
</cfif>
<cfif isdefined("url.ACDescripcionHasta") and not isdefined("form.ACDescripcionHasta")>
	<cfset form.ACDescripcionHasta = url.ACDescripcionHasta>
</cfif>

<cfif isdefined("url.AplacaDesde") and not isdefined("form.AplacaDesde")>
	<cfset form.AplacaDesde = url.AplacaDesde>
</cfif>
<cfif isdefined("url.AplacaHasta") and not isdefined("form.AplacaHasta")>
	<cfset form.AplacaHasta = url.AplacaHasta>
</cfif>

<cfquery name="rsCuentaReg" datasource="#session.DSN#">
	select
		count(1) as registros
	from AFSaldos af
		inner join Activos ac
		on ac.Aid = af.Aid

	<cfif isdefined("form.ACinicio") and len(trim(form.ACinicio)) and isdefined("form.AChasta") and len(trim(form.AChasta))>
		inner join ACategoria act
		on act.Ecodigo = af.Ecodigo
		and act.ACcodigo = af.ACcodigo
		and act.ACcodigodesc between '#form.ACinicio#' and '#form.AChasta#'
	</cfif>

	where af.Ecodigo = #session.Ecodigo#
	  and af.AFSperiodo = #form.PeriodoInicial#
	  and af.AFSmes = #form.MesInicial#
	  and (af.AFSvaladq + af.AFSvalrev + af.AFSvalmej) <> 0

	<cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde)) and isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))>
		and ac.Aplaca between '#form.AplacaDesde#' and '#form.AplacaHasta#'
	</cfif>

	<cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde)) and not isdefined("form.AplacaHasta")>
		and ac.Aplaca >= '#form.AplacaDesde#'
	</cfif>

	<cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta)) and not isdefined("form.AplacaDesde")>
		and ac.Aplaca <= '#form.AplacaHasta#'
	</cfif>

	<cfif isdefined("form.EstadoActivo") and len(trim(form.EstadoActivo))>
			<cfswitch expression="#form.EstadoActivo#">
				<cfcase value="Vigente">
					and ac.Astatus =0
				</cfcase>
				<cfcase value="Depreciado">
					and (af.AFSvaladq + af.AFSvalmej + af.AFSvalrev) - (af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) = ac.Avalrescate
					and Astatus = 0
				</cfcase>
				<cfcase value="Retirado">
					and ac.Astatus =60
				</cfcase>
			</cfswitch>
	</cfif>

	<cfif isdefined("form.SalidaActivo") and form.SalidaActivo neq 0>
		and ac.AEntradaSalida = #form.SalidaActivo#
	</cfif>

</cfquery>

<cfquery name="rsUltimoMesCierreFiscalContable" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 45
</cfquery>

<cfif isdefined("form.MesInicial") and len(trim(form.MesInicial))
	and isdefined("rsUltimoMesCierreFiscalContable") and len(trim(rsUltimoMesCierreFiscalContable.Pvalor))>
	<cfif form.MesInicial GT rsUltimoMesCierreFiscalContable.Pvalor>
		<cfset LvarPeriodoCierre = form.PeriodoInicial>
	<cfelse>
		<cfset LvarPeriodoCierre = form.PeriodoInicial - 1>
	</cfif>
<cfelse>
	<cf_errorCode	code = "50050" msg = "Debe Parametrizar Último Mes de Cierre Fiscal Contable">
	<cfabort>
</cfif>

<cfset LvarMesCierre = rsUltimoMesCierreFiscalContable.Pvalor>

<cfset LvarPeriodoAnt = form.PeriodoInicial>
<cfset LvarMesAnt = form.MesInicial - 1>

<cfif LvarMesAnt LT 1>
	<cfset LvarMesAnt = 12>
	<cfset LvarPeriodoAnt = LvarPeriodoAnt - 1>
</cfif>

<cfsavecontent variable="myQuery">
	<cfoutput>
		select

			 (select min(rtrim(ltrim(aa.ACdescripcion)))
			  	from ACategoria aa
			  where aa.Ecodigo = af.Ecodigo
			   and aa.ACcodigo = af.ACcodigo
			  ) as Categoria,

			(select min(rtrim(ltrim(aa.ACcodigodesc)))
				from ACategoria aa
			  where aa.Ecodigo = af.Ecodigo
				and aa.ACcodigo = af.ACcodigo
			 ) as CategoriaCod,
			af.ACcodigo as Codigo,
			rtrim(ltrim(ac.Aplaca)) as Placa,
			ac.Adescripcion as Activo,

			coalesce((select min(sn.SNnombre)
						from SNegocios sn
					   where sn.Ecodigo = ac.Ecodigo
						and sn.SNcodigo = ac.SNcodigo),'N/A'
			) as Proveedor,

			coalesce((select min(m.AFMdescripcion)
						from AFMarcas m
					   where m.AFMid = ac.AFMid),'N/A'
		    ) as Marca,

			coalesce((select min(mm.AFMMdescripcion)
						from AFMModelos mm
						where mm.AFMMid = ac.AFMMid),'N/A'
			) as Modelo,
			ac.Aserie,

			coalesce((select min(ds.EAcpdoc)
						from  DSActivosAdq ds
						where ds.lin = ac.Areflin
						  and ds.Ecodigo = ac.Ecodigo),'N/A'
			) as Num_Factura,

			ac.Afechaaltaadq as FAdquisicion,
			<cf_dbfunction name="dateaddm" args="ac.Avutil, ac.Afechainidep"> as FfinDeprecia,
			af.AFSvutiladq as MVida,
			af.AFSsaldovutiladq  as MFalta,
            (Select Miso4217 from Moneda m
               where m.Mcodigo= tac.Mcodigo
            ) as MonedaOri,
            <!------   Saldos en moneda local      ----->
			af.AFSvaladq <!---+ af.AFSvalrev + af.AFSvalmej---> as Valor,
			af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev as DepreciacionAcumulada,
			(af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) -
				coalesce( (select sum(afB.AFSdepacumadq + afB.AFSdepacummej + afB.AFSdepacumrev)
					from AFSaldos afB
					where afB.Ecodigo = af.Ecodigo
					and afB.Aid = af.Aid
					and afB.AFSperiodo = #LvarPeriodoCierre#
					and afB.AFSmes = #LvarMesCierre#), 0.00
					) as DepAnual,
			(af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) -
				coalesce(
					(select sum(afB.AFSdepacumadq + afB.AFSdepacummej + afB.AFSdepacumrev)
						from AFSaldos afB
						where afB.Ecodigo = af.Ecodigo
						and afB.Aid = af.Aid
						and afB.AFSperiodo = #LvarPeriodoAnt#
						and afB.AFSmes = #LvarMesAnt#) ,0.00) as DepMensual,
			(af.AFSvaladq + af.AFSvalrev + af.AFSvalmej) -
				(af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) as ValorNeto
		from AFSaldos af
			inner join Activos ac
			on ac.Aid = af.Aid

            inner join TransaccionesActivos tac
              on af.Aid = tac.Aid

			inner join ACategoria act
			on act.Ecodigo = af.Ecodigo
			and act.ACcodigo = af.ACcodigo
		where af.Ecodigo = #session.Ecodigo#
		  and af.AFSperiodo = #form.PeriodoInicial#
		  and af.AFSmes = #form.MesInicial#
          and tac.IDtrans = 1
		  and (af.AFSvaladq + af.AFSvalrev + af.AFSvalmej) <> 0

		<cfif isdefined("form.ACinicio") and len(trim(form.ACinicio)) and isdefined("form.AChasta") and len(trim(form.AChasta))>
			  and act.ACcodigodesc between '#form.ACinicio#' and '#form.AChasta#'
		</cfif>

        <cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde)) and isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))>
			  and ac.Aplaca between '#form.AplacaDesde#' and '#form.AplacaHasta#'
		</cfif>
		<cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde)) and not isdefined("form.AplacaHasta")>
            and ac.Aplaca >= '#form.AplacaDesde#'
        </cfif>

        <cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta)) and not isdefined("form.AplacaDesde")>
            and ac.Aplaca <= '#form.AplacaHasta#'
        </cfif>

		<cfif isdefined("form.EstadoActivo") and len(trim(form.EstadoActivo))>
			<cfswitch expression="#form.EstadoActivo#">
				<cfcase value="Vigente">
					and ac.Astatus =0
				</cfcase>
				<cfcase value="Depreciado">
					and (af.AFSvaladq + af.AFSvalmej + af.AFSvalrev) - (af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) = ac.Avalrescate
					and ac.Astatus = 0
				</cfcase>
				<cfcase value="Retirado">
					and ac.Astatus =60
				</cfcase>
			</cfswitch>
		</cfif>

		<cfif isdefined("form.SalidaActivo") and form.SalidaActivo neq 0>
			and ac.AEntradaSalida = #form.SalidaActivo#
		</cfif>

		order by Categoria, ac.Aplaca <!---, Centro_Funcional--->
	</cfoutput>
</cfsavecontent>

<cfswitch expression="#form.MesInicial#">
	<cfcase value="1">
    	<cfset vMes = LB_Enero>
    </cfcase>
	<cfcase value="2">
    	<cfset vMes = LB_Febrero>
    </cfcase>
    <cfcase value="3">
    	<cfset vMes = LB_Marzo>
    </cfcase>
    <cfcase value="4">
    	<cfset vMes = LB_Abril>
    </cfcase>
    <cfcase value="5">
    	<cfset vMes = LB_Mayo>
    </cfcase>
    <cfcase value="6">
    	<cfset vMes = LB_Junio>
    </cfcase>
    <cfcase value="7">
    	<cfset vMes = LB_Julio>
    </cfcase>
    <cfcase value="8">
    	<cfset vMes = LB_Agosto>
    </cfcase>
    <cfcase value="9">
    	<cfset vMes = LB_Septiembre>
    </cfcase>
    <cfcase value="10">
    	<cfset vMes = LB_Octubre>
    </cfcase>
    <cfcase value="11">
    	<cfset vMes = LB_Noviembre>
    </cfcase>
    <cfcase value="12">
    	<cfset vMes = LB_Diciembre>
    </cfcase>
    <cfdefaultcase>
    	<cfset vMes = LB_Enero>
    </cfdefaultcase>
</cfswitch>

<cfoutput>
<style type="text/css">
	.Titulos {
		font-size:18px;
	}
	.Titulos2 {
		font-size:12px;
	}
	.encabReporteLine {
		background-color: ##006699;
		color: ##FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size: 12px;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##CCCCCC;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##CCCCCC;
	}
	.imprimeDatos {
		font-size: 11px;
		padding-left: 5px;
	}
	.imprimeDatosLinea {
		color: ##FF0000;
		font-size: 11px;
		font-weight: bold;
		padding-left: 5px;
	}
	.imprimeMonto {
		font-size: 11px;
		text-align: right;
	}
	.imprimeMontoBold {
		font-size: 14px;
		text-align: right;
		font-weight: bold;
	}
	.imprimeMontoLinea {
		color: ##FF0000;
		font-size: 11px;
		text-align: right;
		font-weight: bold;
	}
</style>
</cfoutput>

	<html>
	<body>

	<cfif isdefined("rsCuentaReg") and rsCuentaReg.registros gt 0>
	<cftry>
			<cfset registros = 0 >
			<cfflush interval="16000">
			<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
			<cfoutput>#myquery#</cfoutput>
			</cf_jdbcquery_open>
		<cfif isdefined("form.Exportar")>
			<cf_exportQueryToFile query="#rsReporte#" filename="Adq_Dep_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
		</cfif>

        <table border="0" align="center" cellpadding="2" cellspacing="0" style="width:100%">
			<cfoutput>
                <tr style="font-weight:bold">
                  <td align="center"><strong class="Titulos">#session.Enombre#</strong></td>
                  <td  align="right">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td align="right"><strong class="Titulos2">Hora:</strong><a class="Titulos2">&nbsp;&nbsp;#timeformat(now(),"HH:mm:ss")#</a></td>
                        </tr>
                        <tr>
                            <td align="right"><strong class="Titulos2">Fecha:</strong><a class="Titulos2"> #dateformat(now(),"dd/mm/yyyy")# </a></td>
                        </tr>
                    </table>
                  </td>
                </tr>
                <tr style="font-weight:bold">
                  <td align="center"><strong class="Titulos">#LB_Titulo#</strong></td>
                  <td  align="right">&nbsp;</td>
                </tr>
                <tr style="font-weight:bold">
                    <td align="center"><strong class="Titulos2">#LB_Bienes#</strong></td>
                    <td>&nbsp;</td>
                </tr>
                <tr style="font-weight:bold">
                    <td align="center"><strong class="Titulos2">#LB_Mes#&nbsp;#vMes#&nbsp;-&nbsp;#form.PeriodoInicial#</strong></td>
                    <td>&nbsp;</td>
                </tr>
                <tr style="font-weight:bold">
                    <td align="center"><strong class="Titulos2">#LB_Cifras#</strong></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            </cfoutput>
        </table>

		<table cellpadding="2" cellspacing="0" border="0" width="100%" align="center">
			<cfset TotalRegGen = 0>
			<cfset TotalValorGen = 0>
			<cfset TotalDepreciacionAcumuladaGen = 0>
			<cfset TotalDepAnualGen = 0>
			<cfset TotalDepMensualGen = 0>
			<cfset TotalValorNetoGen = 0>

            <cfif  isDefined('form.Resumido')>
            	<cfoutput>
                    <tr>
                        <td width="20%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:20% ;font-weight:bold">#LB_Categoria#</td>
                        <td width="25%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:25% ;font-weight:bold">#LB_Desc#</td>
                        <td width="10%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:10% ;font-weight:bold">#LB_Monto#</td>
                    </tr>
                </cfoutput>
            </cfif>
			<cfif not isDefined('form.Resumido')>
				<cfoutput>
                    <tr>
                        <td width="20%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:20% ;font-weight:bold">#LB_Placa#</td>
                        <td width="25%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:25% ;font-weight:bold">#LB_Desc#</td>
                        <td width="10%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:10% ;font-weight:bold">#LB_Monto#</td>
                    </tr>
                </cfoutput>
            </cfif>
			<cfoutput query="rsReporte" group="Categoria">
				<cfset TotalRegCat = 0>
				<cfset TotalValorCat = 0>

				<cfif  isDefined('form.Resumido')>
                    <cfoutput>
                    	<cfset TotalValorCat = TotalValorCat + ValorNeto>
                        <cfset TotalRegCat = TotalRegCat + 1>
                    </cfoutput>
                    <tr>
                        <td class="imprimeDatos" align="center">#CategoriaCod#</td>
                        <td class="imprimeDatos" align="right">#Categoria#</td>
                        <td class="imprimeMonto" align="center">#LSCUrrencyFormat(TotalValorCat,'none')#</td>
                    </tr>
                <cfelse>
                    <!---<tr>
                    	<td >&nbsp;</td>
                        <td nowrap="nowrap" align="center" class="encabReporteLine" style="width:20% ;font-weight:bold">#LB_Categoria#</td>
                        <td nowrap="nowrap" align="center" class="encabReporteLine" style="width:20% ;font-weight:bold">#CategoriaCod#-#Categoria#</td>
                    </tr>

                	<tr>
                    <td width="20%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:20% ;font-weight:bold">#LB_Placa#</td>
                    <td width="25%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:25% ;font-weight:bold">#LB_Desc#</td>
                    <td width="10%" nowrap="nowrap" align="center" class="encabReporteLine" style="width:10% ;font-weight:bold">#LB_Monto#</td>
                    </tr>--->
                	<cfoutput>
                    	<cfset TotalValorCat = TotalValorCat + ValorNeto>
                        <cfset TotalRegCat = TotalRegCat + 1>
                    	<tr>
                            <td class="imprimeDatos" align="center">#Placa#</td>
                            <td class="imprimeDatos" align="right">#Activo#</td>
                            <td class="imprimeMonto" align="center">#LSCUrrencyFormat(ValorNeto,'none')#</td>
                        </tr>
                    </cfoutput>
                </cfif>


                <cfif not isDefined('form.Resumido')>
                    <!---<tr>
                        <td colspan="2">Total por Categoria:</td>
                        <td class="imprimeMonto" align="center">#NumberFormat(TotalValorCat,'_,_.__')#</td>
                   </tr>--->
				</cfif>

				<cfset TotalRegGen = TotalRegGen + TotalRegCat>
                <cfset TotalValorGen = TotalValorGen + TotalValorCat>
			</cfoutput>


		<cfoutput>
            <tr>
                <td class="imprimeMontoBold" colspan="2">Total General:&nbsp;</td>
                <td class="imprimeMontoBold" align="center">#NumberFormat(TotalValorGen,'_,_.__')#</td>
            </tr>
		</cfoutput>
			<tr>
				<td colspan="3" align="center" class="niv3">
					------------------------------------------- Fin de la Consulta -------------------------------------------
				</td>
		  	</tr>
        <cfcatch type="any">
            <cf_jdbcquery_close>
            <cfrethrow>
        </cfcatch>
	</cftry>
		</table>
	<cfelse>
		<div align="center"> ------------------------------------------- No se encontraron registros -------------------------------------------</div>
	</cfif>

	<cf_jdbcquery_close>
	</body>
	</html>
