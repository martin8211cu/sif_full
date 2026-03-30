<!---
	Creado por Gustavo Fonseca H.
		Fecha: 5-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
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
<cfif isdefined("form.CFidinicio") and len(trim(form.CFidinicio)) >
	<cfset params = params & "&CFidinicio=#form.CFidinicio#">
</cfif>
<cfif isdefined("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) >
	<cfset params = params & "&CFcodigoinicio=#form.CFcodigoinicio#">
</cfif>
<cfif isdefined("form.CFdescripcioninicio") and len(trim(form.CFdescripcioninicio)) >
	<cfset params = params & "&CFdescripcioninicio=#form.CFdescripcioninicio#">
</cfif>
<cfif isdefined("form.CFidfinal") and len(trim(form.CFidfinal)) >
	<cfset params = params & "&CFidfinal=#form.CFidfinal#">
</cfif>
<cfif isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) >
	<cfset params = params & "&CFcodigofinal=#form.CFcodigofinal#">
</cfif>
<cfif isdefined("form.CFdescripcionfinal") and len(trim(form.CFdescripcionfinal)) >
	<cfset params = params & "&CFdescripcionfinal=#form.CFdescripcionfinal#">
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
<cfif isdefined("form.Resumido") and len(trim(form.Resumido)) >
	<cfset params = params & "&Resumido=#form.Resumido#">
</cfif>

<cf_htmlreportsheaders
        title="Consulta Adquisiciones y Depreciaciones "
        filename="AdquisicionesyDepreciaciones#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls"
       ira="Adq_Dep_form.cfm?#params#"
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

	<cfif isdefined("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) and isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal))>
		inner join CFuncional cf
		  on cf.CFid = af.CFid
		 and cf.CFcodigo between '#form.CFcodigoinicio#' and '#form.CFcodigofinal#'
	</cfif>

	<cfif isdefined("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) and not isdefined("form.CFcodigofinal")>
		inner join CFuncional cf
		 on cf.CFid = af.CFid
		and cf.CFcodigo >= '#form.CFcodigoinicio#'
	</cfif>
	<cfif isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) and not isdefined("form.CFcodigoinicio")>
		inner join CFuncional cf
		 on  cf.CFid = af.CFid
		and cf.CFcodigo <= '#form.CFcodigofinal#'
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

			 (select min(<cf_dbfunction name="concat" args="rtrim(ltrim(aa.ACcodigodesc)),' - ', rtrim(ltrim(aa.ACdescripcion))">)
			  	from ACategoria aa
			  where aa.Ecodigo = af.Ecodigo
			   and aa.ACcodigo = af.ACcodigo
			  ) as Categoria,

			(select min(rtrim(ltrim(aa.ACcodigodesc)))
				from ACategoria aa
			  where aa.Ecodigo = af.Ecodigo
				and aa.ACcodigo = af.ACcodigo
			 ) as CategoriaCod,

			coalesce((select min(<cf_dbfunction name="concat" args="rtrim(ltrim(cf.CFcodigo)),' - ', CFdescripcion">)
						from CFuncional cf
					  where cf.CFid = af.CFid),'N/A'
		    ) as Centro_Funcional,

			coalesce((select min(rtrim(ltrim(cf.CFcodigo)))
					    from CFuncional cf
				       where cf.CFid = af.CFid),'N/A'
			) as Centro_FuncionalCod,

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
			af.AFSvaladq + af.AFSvalrev + af.AFSvalmej as Valor,
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

			<cfif isdefined("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) and isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal))>
				inner join CFuncional cf
				  on cf.CFid = af.CFid
				 and cf.CFcodigo between '#form.CFcodigoinicio#' and '#form.CFcodigofinal#'
			</cfif>

			<cfif isdefined("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) and not isdefined("form.CFcodigofinal")>
				inner join CFuncional cf
				 on cf.CFid = af.CFid
				and cf.CFcodigo >= '#form.CFcodigoinicio#'
			</cfif>

			<cfif isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) and not isdefined("form.CFcodigoinicio")>
				inner join CFuncional cf
				 on  cf.CFid = af.CFid
				and cf.CFcodigo <= '#form.CFcodigofinal#'
			</cfif>

		where af.Ecodigo = #session.Ecodigo#
		  and af.AFSperiodo = #form.PeriodoInicial#
		  and af.AFSmes = #form.MesInicial#
          and tac.IDtrans = 1
		  and (af.AFSvaladq + af.AFSvalrev + af.AFSvalmej) <> 0

		<cfif isdefined("form.ACinicio") and len(trim(form.ACinicio)) and isdefined("form.AChasta") and len(trim(form.AChasta))>
			  and act.Ecodigo      = #session.Ecodigo#
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

		order by Categoria, Centro_Funcional
	</cfoutput>
</cfsavecontent>

<cfset form.formatos = 1>
<cfif form.formatos EQ 1>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 9px; }
		</style>
	</head>
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
		<table border="0" align="center" cellpadding="2" cellspacing="0" style="width:113%">
		<tr style="font-weight:bold">
		  <td colspan="22" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="22" align="center" class="niv2">Consulta de Adquisiciones y Depreciaciones <cfif isDefined('form.Resumido')>Resumido</cfif></td>
		  <td colspan="2" class="niv4" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr align="center">
			<td align="right" colspan="11" class="niv3" style="width:43%">Per&iacute;odo:&nbsp;<cfoutput>#form.PeriodoInicial#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Mes:&nbsp;<cfoutput>#form.MesInicial#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">Categor&iacute;a&nbsp;Inicial:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.ACinicio# - #form.ACdescripciondesde#<cfelse>Todos</cfif></cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Categor&iacute;a&nbsp;Final:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.AChasta# - #form.ACdescripcionhasta#<cfelse>Todos</cfif></cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">C.F.&nbsp;Inicial:&nbsp;<cfoutput>#form.CFdescripcionInicio#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;C.F.&nbsp;Final:&nbsp;<cfoutput>#form.CFdescripcionFinal#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">Activo&nbsp;Inicial:&nbsp;<cfoutput>#form.AplacaDesde#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Activo&nbsp;Final:&nbsp;<cfoutput>#form.AplacaHasta#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">Estado&nbsp;de&nbsp;Activo:&nbsp;<cfoutput>#form.EstadoActivo#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="1">&nbsp;</td>
		</tr>
	  </table>
		<table cellpadding="2" cellspacing="0" border="0" width="100%" align="center">
			<cfset TotalValorGen = 0>
			<cfset TotalDepreciacionAcumuladaGen = 0>
			<cfset TotalDepAnualGen = 0>
			<cfset TotalDepMensualGen = 0>
			<cfset TotalValorNetoGen = 0>

			<cfoutput query="rsReporte" group="Categoria">
				<cfset TotalValorCat = 0>
				<cfset TotalDepreciacionAcumuladaCat = 0>
				<cfset TotalDepAnualCat = 0>
				<cfset TotalDepMensualCat = 0>
				<cfset TotalValorNetoCat = 0>
				<cfif  isDefined('form.Resumido')>
					<tr>
						<td colspan="17" align="left" style="font-weight:bold" nowrap="nowrap" class="niv4" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;Categor&iacute;a: #Categoria#</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="left" class="niv4"   style="width:1% ;font-weight:bold"><cfif form.Resumido NEQ 'ResumidoCat'>Centro Funcional</cfif></td>
						<td nowrap="nowrap" align="center" class="niv4" style="width:1% ;font-weight:bold">Valor</td>
						<td nowrap="nowrap" align="center" class="niv4" style="width:1% ;font-weight:bold">Depreciación Acum.</td>
						<td nowrap="nowrap" align="center" class="niv4" style="width:1% ;font-weight:bold">Dep&nbsp;Anual</td>
						<td nowrap="nowrap" align="center" class="niv4" style="width:1% ;font-weight:bold">Dep&nbsp;Mensual</td>
						<td nowrap="nowrap" align="center" class="niv4" style="width:1% ;font-weight:bold"colspan="1">Valor&nbsp;Neto</td>
					</tr>
				<cfelse>
					<tr>
						<td colspan="17" align="left" style="font-weight:bold" nowrap="nowrap" class="niv4" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;Categor&iacute;a: #Categoria#</td>
					</tr>
				</cfif>
				<cfoutput group="Centro_Funcional">
				<cfset TotalValor = 0>
				<cfset TotalDepreciacionAcumulada = 0>
				<cfset TotalDepAnual = 0>
				<cfset TotalDepMensual = 0>
				<cfset TotalValorNeto = 0>
					<cfif not isDefined('form.Resumido')>
							<tr>
								<td colspan="17" align="left" style="font-weight:bold" nowrap="nowrap" class="niv4" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Centro&nbsp;Funcional: #Centro_Funcional#</td>
							</tr>
							<tr style="font-weight:bold">
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Placa</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">Proveedor</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">Marca</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">Modelo</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">Serie</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">Num.&nbsp;Factura</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">F.&nbsp;Adquisici&oacute;n</td>
							  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">F. Fin Deprecia.</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">M.&nbsp;Vida</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">M.&nbsp;Falta</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Valor</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Depreciación Acum.</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Dep&nbsp;Anual</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Dep&nbsp;Mensual</td>
							  <td nowrap="nowrap" align="right" class="niv4" style="width:1%"colspan="1">Valor&nbsp;Neto</td>
							</tr>
						<cfoutput>
							<cfset LvarListaNon = (CurrentRow MOD 2)>

							<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
							  <td align="right" style="width:1%" nowrap="nowrap" class="niv4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Placa#</td>
							  <td class="niv4" nowrap="nowrap">#trim(Proveedor)#</td>
							  <td align="left" nowrap="nowrap" class="niv4">#Marca#</td>
							  <td align="left"  nowrap="nowrap" class="niv4">#Modelo#</td>
							  <td align="left" nowrap="nowrap" class="niv4">#Aserie#</td>
							  <td align="left" nowrap="nowrap" class="niv4" style="width:1%">#Num_Factura#</td>
							  <td align="left" class="niv4">#dateformat(FAdquisicion,'dd/mm/yyyy')#</td>
							  <td align="left" class="niv4">#dateformat(FfinDeprecia,'dd/mm/yyyy')#</td>
							  <td align="right" class="niv4">#MVida#</td>
							  <td align="right" class="niv4">#MFalta#</td>
							  <td align="right" class="niv4">#NumberFormat(Valor,'_,_.__')#</td>
							  <td align="right" class="niv4">#NumberFormat(DepreciacionAcumulada,'_,_.__')#</td>
							  <td align="right" class="niv4">#NumberFormat(DepAnual,'_,_.__')#</td>
							  <td align="right" class="niv4">#NumberFormat(DepMensual,'_,_.__')#</td>
							  <td align="right" colspan="1" class="niv4">#NumberFormat(ValorNeto,'_,_.__')#</td>
							</tr>
							<cfset TotalValor = TotalValor + Valor>
							<cfset TotalDepreciacionAcumulada = TotalDepreciacionAcumulada + DepreciacionAcumulada>
							<cfset TotalDepAnual = TotalDepAnual + DepAnual>
							<cfset TotalDepMensual = TotalDepMensual + DepMensual>
							<cfset TotalValorNeto = TotalValorNeto + ValorNeto>
							</cfoutput>
					<cfelse>
						<cfoutput>
							<cfset TotalValor = TotalValor + Valor>
							<cfset TotalDepreciacionAcumulada = TotalDepreciacionAcumulada + DepreciacionAcumulada>
							<cfset TotalDepAnual = TotalDepAnual + DepAnual>
							<cfset TotalDepMensual = TotalDepMensual + DepMensual>
							<cfset TotalValorNeto = TotalValorNeto + ValorNeto>
						</cfoutput>
					</cfif>


				<cfif isDefined('form.Resumido')>

					<tr>
						<cfif form.Resumido NEQ 'ResumidoCat'> <td <!---colspan="17"---> align="left" class="niv4">
								&nbsp;#Centro_Funcional#
							</td>
							<td class="niv4" align="center"  >#NumberFormat(TotalValor,'_,_.__')#</td>
							<td class="niv4" align="center"  >#NumberFormat(TotalDepreciacionAcumulada,'_,_.__')#</td>
							<td class="niv4" align="center"  >#NumberFormat(TotalDepAnual,'_,_.__')#</td>
							<td class="niv4" align="center"  >#NumberFormat(TotalDepMensual,'_,_.__')#</td>
							<td class="niv4" align="center"  >#NumberFormat(TotalValorNeto,'_,_.__')#</td>
						</cfif>
					</tr>
				<cfelse>
					<tr>
						<td colspan="7">&nbsp;</td>
						<td class="niv4" align="right" style="font-weight:bold" colspan="3" nowrap="nowrap">Total Centro Funcional:&nbsp;#Centro_FuncionalCod#</td>
						<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValor,'_,_.__')#</td>
						<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepreciacionAcumulada,'_,_.__')#</td>
						<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepAnual,'_,_.__')#</td>
						<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepMensual,'_,_.__')#</td>
						<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorNeto,'_,_.__')#</td>
					</tr>
				</cfif>
					<cfset TotalValorCat = TotalValorCat + TotalValor>
					<cfset TotalDepreciacionAcumuladaCat = TotalDepreciacionAcumuladaCat + TotalDepreciacionAcumulada>
					<cfset TotalDepAnualCat = TotalDepAnualCat + TotalDepAnual>
					<cfset TotalDepMensualCat = TotalDepMensualCat + TotalDepMensual>
					<cfset TotalValorNetoCat = TotalValorNetoCat + TotalValorNeto>
			</cfoutput>

			<cfif isDefined('form.Resumido')>
				<tr>
					<!---<td colspan="-1">&nbsp;</td>--->
					<td class="niv4" align="left"  >Total por Categoría:&nbsp;#CategoriaCod#</td>
					<td class="niv4" align="center" >#NumberFormat(TotalValorCat,'_,_.__')#</td>
					<td class="niv4" align="center"  >#NumberFormat(TotalDepreciacionAcumuladaCat,'_,_.__')#</td>
					<td class="niv4" align="center"  >#NumberFormat(TotalDepAnualCat,'_,_.__')#</td>
					<td class="niv4" align="center"  >#NumberFormat(TotalDepMensualCat,'_,_.__')#</td>
					<td class="niv4" align="center"  >#NumberFormat(TotalValorNetoCat,'_,_.__')#</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="7">&nbsp;</td>
					<td class="niv4" align="right" style="font-weight:bold" colspan="3">Total por Categoría:&nbsp;#CategoriaCod#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorCat,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepreciacionAcumuladaCat,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepAnualCat,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepMensualCat,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorNetoCat,'_,_.__')#</td>
				</tr>
			</cfif>
					<cfset TotalValorGen = TotalValorGen + TotalValorCat>
					<cfset TotalDepreciacionAcumuladaGen = TotalDepreciacionAcumuladaGen + TotalDepreciacionAcumuladaCat>
					<cfset TotalDepAnualGen= TotalDepAnualGen + TotalDepAnualCat>
					<cfset TotalDepMensualGen = TotalDepMensualGen + TotalDepMensualCat>
					<cfset TotalValorNetoGen = TotalValorNetoGen + TotalValorNetoCat>

		</cfoutput>

		<cfoutput>
		<cfif isDefined('form.Resumido')>
		<tr>
				<td class="niv4" align="left" style="font-weight:bold" >Total General:&nbsp;</td>
				<td class="niv4" align="center" style="font-weight:bold">#NumberFormat(TotalValorGen,'_,_.__')#</td>
				<td class="niv4" align="center" style="font-weight:bold">#NumberFormat(TotalDepreciacionAcumuladaGen,'_,_.__')#</td>
				<td class="niv4" align="center" style="font-weight:bold">#NumberFormat(TotalDepAnualGen,'_,_.__')#</td>
				<td class="niv4" align="center" style="font-weight:bold">#NumberFormat(TotalDepMensualGen,'_,_.__')#</td>
				<td class="niv4" align="center" style="font-weight:bold">#NumberFormat(TotalValorNetoGen,'_,_.__')#</td>
			</tr>
		<cfelse>
			 <tr>
				<td colspan="7">&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold" colspan="3">Total General:&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorGen,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepreciacionAcumuladaGen,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepAnualGen,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDepMensualGen,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorNetoGen,'_,_.__')#</td>
			</tr>
		</cfif>
			<tr>
				<td colspan="15">&nbsp;</td>
			</tr>
		</cfoutput>
		<tr>
				<td colspan="15" align="center" class="niv3">
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
</cfif>

