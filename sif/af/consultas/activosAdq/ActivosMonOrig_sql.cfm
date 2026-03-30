<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 5-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
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
            <!------   Saldos en moneda local      ----->
            af.AFSdepacumadq,
            af.AFSdepacummej,
            af.AFSdepacumrev,            
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
				(af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev) as ValorNeto,
                ac.Aid as MyActivo,
                ac.Adescripcion
		from AFSaldos af
			inner join Activos ac
			on ac.Aid = af.Aid
                          
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
		.nivCategoria { font-size: 16px; font-weight:bold }
		.nivCFuncional { font-size: 14px; font-weight:bold }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px;}
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 9px; background-color:#CCC;}
		.niv5 { font-size: 9px; color:#F00; font-weight:bold }
		.niv6 { font-size: 9px; background-color:#999; font-weight:bold}
		.niv7 { font-size: 9px; background-color:#CCC; font-weight:bold}
		.niv8 { font-size: 14px; font-weight:bold}
		.nivD { font-size: 9px;}		
		</style>
	</head>
	<body>
	<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="26" align="right" class="noprint">
				<cfoutput>
					<cfset params = "&ACinicio=#form.ACinicio#&AChasta=#form.AChasta#&CFcodigoinicio=#form.CFcodigoinicio#&CFcodigofinal=#form.CFcodigofinal#&AidDesde=#form.AidDesde#&AidHasta=#form.AidHasta#&periodoInicial=#form.periodoInicial#&mesInicial=#form.mesInicial#&CFdescripcionInicio=#form.CFdescripcionInicio#&CFdescripcionFinal=#form.CFdescripcionFinal#&ACDescripcionDesde=#form.ACDescripcionDesde#&ACDescripcionHasta=#form.ACDescripcionHasta#&AplacaDesde=#form.AplacaDesde#&AplacaHasta=#form.AplacaHasta#">
					<a href="Adq_Dep_form.cfm?1=1#params#">Regresar</a> 
				</cfoutput>
			</td>
		</tr>
	</table>
		
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
		<tr>
			<td colspan="28" align="right">
				<cf_rhimprime datos="/sif/af/consultas/activosAdq/Adq_Dep_sql.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="22" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td  class="nivD" align="right">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="22" align="center" class="niv2">Consulta de Adquisiciones y Depreciaciones</td>
		  <td  class="nivD" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr align="center">
			<td align="right" colspan="11" class="niv3" style="width:43%">Per&iacute;odo:&nbsp;<cfoutput>#form.PeriodoInicial#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Mes:&nbsp;<cfoutput>#form.MesInicial#</cfoutput></td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">Categor&iacute;a&nbsp;Inicial:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.ACinicio# - #form.ACdescripciondesde#<cfelse>Todos</cfif></cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Categor&iacute;a&nbsp;Final:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.AChasta# - #form.ACdescripcionhasta#<cfelse>Todos</cfif></cfoutput></td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">C.F.&nbsp;Inicial:&nbsp;<cfoutput>#form.CFdescripcionInicio#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;C.F.&nbsp;Final:&nbsp;<cfoutput>#form.CFdescripcionFinal#</cfoutput></td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td align="right" colspan="11" class="niv3">Activo&nbsp;Inicial:&nbsp;<cfoutput>#form.AplacaDesde#</cfoutput></td>
			<td align="left" colspan="11" class="niv3">&nbsp;&nbsp;Activo&nbsp;Final:&nbsp;<cfoutput>#form.AplacaHasta#</cfoutput></td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td colspan="1">&nbsp;</td>
		</tr>  
	  </table>
		<table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
			<cf_templatecss>
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
                
				<cfoutput group="Centro_Funcional">
				<cfset TotalValor = 0>
				<cfset TotalDepreciacionAcumulada = 0>
				<cfset TotalDepAnual = 0>
				<cfset TotalDepMensual = 0>
				<cfset TotalValorNeto = 0>						
               
				<cfoutput>	                   
                     <tr style="font-weight:bold">
                      <td colspan="17" nowrap="nowrap" class="niv8">Placa: #Placa# - #Adescripcion# <hr></td>					                                                              
					</tr>
					<tr style="font-weight:bold">                    
					  <td nowrap="nowrap" align="left" class="niv4">Proveedor</td>
					  <td nowrap="nowrap" align="left" class="niv4">Marca</td>
					  <td nowrap="nowrap" align="left" class="niv4">Modelo</td>
					  <td nowrap="nowrap" align="left" class="niv4">Serie</td>
					  <td nowrap="nowrap" align="left" class="niv4">Num.&nbsp;Factura</td>
					  <td nowrap="nowrap" align="left" class="niv4">F.&nbsp;Adquisici&oacute;n</td>
					  <td nowrap="nowrap" align="left" class="niv4">F. Fin Deprecia.</td>
					  <td nowrap="nowrap" align="right" class="niv4">M.&nbsp;Vida</td>
					  <td nowrap="nowrap" align="right" class="niv4">M.&nbsp;Falta</td>                                   
					</tr>				
					<tr>					  
					  <td class="nivD" nowrap="nowrap">#trim(Proveedor)#</td>
					  <td align="left" nowrap="nowrap" class="nivD">#Marca#</td>
					  <td align="left"  nowrap="nowrap" class="nivD">#Modelo#</td>
					  <td align="left" nowrap="nowrap" class="nivD">#Aserie#</td>
					  <td align="left" nowrap="nowrap" class="nivD" style="width:1%">#Num_Factura#</td>
					  <td align="left" class="nivD">#dateformat(FAdquisicion,'dd/mm/yyyy')#</td>
					  <td align="left" class="nivD">#dateformat(FfinDeprecia,'dd/mm/yyyy')#</td>
					  <td align="right" class="nivD">#MVida#</td>
					  <td align="right" class="nivD">#MFalta#</td>                    
					</tr>
					<cfset TotalValor = TotalValor + Valor>
					<cfset TotalDepreciacionAcumulada = TotalDepreciacionAcumulada + DepreciacionAcumulada>
					<cfset TotalDepAnual = TotalDepAnual + DepAnual>
					<cfset TotalDepMensual = TotalDepMensual + DepMensual>
					<cfset TotalValorNeto = TotalValorNeto + ValorNeto>
                    <cfquery name="rsTransacciones" datasource="#session.dsn#">
                    select tac.IDtrans,
                    case IDtrans 
                          when 1 then 
                               'Adquisicion' 
                          when 2 then 
                               'Mejora'
                           when 3 then 
                               'Revaluación'      
                           end as transaccion,
                    case IDtrans 
                      when 1 then
                               tac.TAmontolocadq  
                      when 2 then  
                               tac.TAmontolocmej                           
                      when 3 then  
                               tac.TAmontolocrev                                    
                      end as ValorLocal, 
                    case IDtrans 
                      when 1 then     
                               coalesce(tac.TAmontodepadq,0.00) 
                      when 2 then   
                               coalesce(tac.TAmontodepmej,0.00)                          
                      when 2 then   
                               coalesce(tac.TAmontodeprev,0.00)                          
                       end as DepLocal,
                    case IDtrans                     
                      when 1 then
                             tac.TAmontooriadq         
                      when 2 then
                             tac.TAmontoorimej           
                      when 3 then
                             tac.TAmontoorirev                                     
                      end as  ValorOriginal,
                    case IDtrans 
                      when 1 then     
                              coalesce((tac.TAmontodepadq/tac.TAtipocambio),0.00)
                      when 2 then  
                              coalesce((tac.TAmontodepmej/tac.TAtipocambio),0.00)                   
                      when 3 then  
                              coalesce((tac.TAmontodeprev/tac.TAtipocambio),0.00)                   
                      end as DepOriginal,
                      (Select Miso4217 
				         from Monedas m 
           				 where m.Mcodigo = tac.Mcodigo) as Moneda,
                      tac.TAvutil as VidaUtil,
                       tac.TAtipocambio as TC,
                       tac.TAfecha as Fecha,
                       tac.TAperiodo as Periodo,
                       tac.TAmes as Mes
                     from TransaccionesActivos tac 
                     where tac.Aid = #MyActivo#
                     and tac.IDtrans in (1,2)
                     and (tac.TAperiodo = #form.PeriodoInicial# and tac.TAmes  <= #form.MesInicial#  or tac.TAperiodo < #form.PeriodoInicial#)
                     order by tac.IDtrans
                    </cfquery> 
                 <tr style="font-weight:bold">
                   	<td colspan="11">&nbsp;</td>
                 </tr>       
                 <tr>
                 <td colspan="18"> 
                        <table border="0" align="right" cellpadding="0" cellspacing="0" width="98%"  style="border:solid; border-width: thin">
                          <tr>
                            <td class="niv6" align="center">&nbsp;</td>
                            <td class="niv6" align="center">Transacci&oacute;n</td>
                            <td class="niv6" align="center">Valor Local</td>                  
                            <td class="niv6" align="center">Valor Original</td>                  
                            <td class="niv6" align="center">Moneda</td>
                            <td class="niv6" align="center">Vida Util</td>                    
                            <td class="niv6" align="center">Tipo Cambio</td>                    
                            <td class="niv6" align="center">Fecha</td>   
                            <td class="niv6" align="center">Periodo</td>                    
                            <td class="niv6" align="center">Mes</td>                                     
                          </tr>
                         <cfloop query="rsTransacciones"> 
                          <tr>
                            <td class="nivD" align="center">&nbsp;</td>
                            <td class="nivD" align="center">#transaccion#</td>
                            <td class="nivD" align="right">#NumberFormat(ValorLocal,'_,_.__')#</td>
                            <td class="nivD" align="right">#NumberFormat(ValorOriginal,'_,_.__')#</td>
                            <td class="nivD" align="center">#Moneda#</td>
                            <td class="nivD" align="center">#VidaUtil#</td>                    
                            <td class="nivD" align="right">#TC#</td>                    
                            <td class="nivD" align="center">#DateFormat(Fecha,'dd-mm-yyyy')#</td>   
                            <td class="nivD" align="center">#Periodo#</td>                    
                            <td class="nivD" align="center">#Mes#</td>                 
                          </tr>
                         </cfloop>
                      </table>  
                    </td>
                    </tr>                 
                  <tr style="font-weight:bold">
                   	<td colspan="11">&nbsp;</td>
                  </tr>                    
                  <tr>
                  <td colspan="18">
                      <table border="0" align="right" cellpadding="0" cellspacing="0" width="98%"  style="border:solid; border-width: thin">
                          <tr>                           
                            <td class="niv7" colspan="3" bgcolor="CCCCCC">Depreciaci&oacute;n Acum. ADQ </td>
                            <td class="niv7" colspan="3" bgcolor="CCCCCC">Depreciaci&oacute;n Acum. MEJ</td>
                            <td class="niv7" colspan="3" bgcolor="CCCCCC">Depreciaci&oacute;n Acum. REV</td>
                            <td class="niv7" colspan="3" bgcolor="CCCCCC">Depreciaci&oacute;n ANUAL</td>
                          </tr>  
                           <tr>                            
                            <td class="nivD" colspan="3">#NumberFormat(AFSdepacumadq,'_,_.__')#</td>
                            <td class="nivD" colspan="3">#NumberFormat(AFSdepacummej,'_,_.__')#</td>
                            <td class="nivD" colspan="3">#NumberFormat(AFSdepacumrev,'_,_.__')#</td>
                             <td class="nivD" colspan="3">#NumberFormat(DepAnual,'_,_.__')#</td>
                          </tr>  
                       </table>                 
                     </td>
                   </tr>     
                  <tr style="font-weight:bold">
                   	<td colspan="11">&nbsp;</td>
                  </tr> 
                  <tr style="font-weight:bold; height:30px">
                   	<td colspan="11">&nbsp;</td>
                  </tr>
                                         
            </cfoutput>
	
					<cfset TotalValorCat = TotalValorCat + TotalValor>
					<cfset TotalDepreciacionAcumuladaCat = TotalDepreciacionAcumuladaCat + TotalDepreciacionAcumulada>
					<cfset TotalDepAnualCat = TotalDepAnualCat + TotalDepAnual>
					<cfset TotalDepMensualCat = TotalDepMensualCat + TotalDepMensual>
					<cfset TotalValorNetoCat = TotalValorNetoCat + TotalValorNeto>
			</cfoutput>

					<cfset TotalValorGen = TotalValorGen + TotalValorCat>
					<cfset TotalDepreciacionAcumuladaGen = TotalDepreciacionAcumuladaGen + TotalDepreciacionAcumuladaCat>
					<cfset TotalDepAnualGen= TotalDepAnualGen + TotalDepAnualCat>
					<cfset TotalDepMensualGen = TotalDepMensualGen + TotalDepMensualCat>
					<cfset TotalValorNetoGen = TotalValorNetoGen + TotalValorNetoCat>
			
		</cfoutput>
		 <tr>
				<td colspan="16" class="niv5" align="center" style="height:30px" valign="middle">
                   (*) Los montos de depreciaci&oacute;n acumulada se expresan en Moneda Local &uacute;nicamente </td>
       	</tr>	         
         <tr>
				<td colspan="16" align="center" class="niv3">
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

