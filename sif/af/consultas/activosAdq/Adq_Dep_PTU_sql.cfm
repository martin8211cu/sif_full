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

<cfset LvarPeriodoAnt = form.PeriodoInicial>

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
			tac.TAmontolocmej as ProcentajePTU,
            (Select Miso4217 from Moneda m               
               where m.Mcodigo= tac.Mcodigo
            ) as MonedaOri,                   
            <!------   Saldos en moneda local      ----->
			af.AFSvaladq + af.AFSvalmej as Valor,
            tac.TAmontoorimej as SaldoAnteriorPTU,
			tac.TAmontolocadq as DisminucionPTU,
			tac.TAmontooriadq as SaldoPTU
		from TransaccionesActivos tac
			inner join AFSaldos af
			on af.Aid = tac.Aid
			and af.AFSperiodo = tac.TAperiodo
			and af.AFSmes     = tac.TAmes
			and af.Ecodigo    = tac.Ecodigo
                    	
            inner join Activos ac
			on ac.Aid = af.Aid
    		  
			inner join ACategoria act
			on act.Ecodigo = af.Ecodigo
			and act.ACcodigo = af.ACcodigo
            
            inner join AClasificacion acl
            	on acl.ACcodigo = act.ACcodigo
                and acl.Ecodigo = act.Ecodigo
                and acl.ACid = af.ACid

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
		  and tac.IDtrans = 13
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
        <title>Adquisiciones y Depreciaciones PTU</title>
		<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 9px; }
		</style>
	</head>
	<body>
	<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="24" align="right" class="noprint">
				<cfoutput>
					<cfset params = "&ACinicio=#form.ACinicio#&AChasta=#form.AChasta#&CFcodigoinicio=#form.CFcodigoinicio#&CFcodigofinal=#form.CFcodigofinal#&AidDesde=#form.AidDesde#&AidHasta=#form.AidHasta#&periodoInicial=#form.periodoInicial#&CFdescripcionInicio=#form.CFdescripcionInicio#&CFdescripcionFinal=#form.CFdescripcionFinal#&ACDescripcionDesde=#form.ACDescripcionDesde#&ACDescripcionHasta=#form.ACDescripcionHasta#&AplacaDesde=#form.AplacaDesde#&AplacaHasta=#form.AplacaHasta#">
					<a href="Adq_Dep_PTU_form.cfm?1=1#params#">Regresar <img border="0" title="Regresar" style="cursor:pointer" src="/cfmx/sif/imagenes/back.png" class="noprint"></a> 
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
			<cf_exportQueryToFile query="#rsReporte#" filename="Adq_Dep_PTU_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
		</cfif>
		<table border="0" align="center" cellpadding="2" cellspacing="0" style="width:100%">
		<tr>
			<td colspan="24" align="right">
				<cf_rhimprime datos="/sif/af/consultas/activosAdq/Adq_Dep_PTU_sql.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="24" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td colspan="24" align="center" class="niv2">Consulta de Adquisiciones y Depreciaciones PTU</td>
		</tr>
		<tr align="center">
			<td align="center" colspan="24" class="niv3" style="width:100%">Per&iacute;odo:&nbsp;<cfoutput>#form.PeriodoInicial#</cfoutput></td>
		</tr>
		<tr align="center">
			<td align="right"  class="niv3">Categor&iacute;a&nbsp;Inicial:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.ACinicio# - #form.ACdescripciondesde#<cfelse>Todos</cfif></cfoutput></td>
			<td align="left"  class="niv3">&nbsp;&nbsp;Categor&iacute;a&nbsp;Final:&nbsp;<cfoutput><cfif isdefined("form.ACinicio") and len(trim(form.ACinicio))>#form.AChasta# - #form.ACdescripcionhasta#<cfelse>Todos</cfif></cfoutput></td>
		</tr>
		<tr align="center">
			<td align="right"  class="niv3">C.F.&nbsp;Inicial:&nbsp;<cfoutput>#form.CFdescripcionInicio#</cfoutput></td>
			<td align="left"  class="niv3">&nbsp;&nbsp;C.F.&nbsp;Final:&nbsp;<cfoutput>#form.CFdescripcionFinal#</cfoutput></td>
		</tr>
		<tr align="center">
			<td align="right" class="niv3">Activo&nbsp;Inicial:&nbsp;<cfoutput>#form.AplacaDesde#</cfoutput></td>
			<td align="left"  class="niv3">&nbsp;&nbsp;Activo&nbsp;Final:&nbsp;<cfoutput>#form.AplacaHasta#</cfoutput></td>
		</tr>
        <tr align="center">
			<td  class="niv3" align="right"><strong>Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></strong></td>
            <td  class="niv3" align="left"><strong>&nbsp;&nbsp;Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput></strong> </td>
		</tr>
		<tr align="center">
			<td colspan="24">&nbsp;</td>
		</tr>  
	  </table>
		<table cellpadding="2" cellspacing="0" border="0" width="100%" align="center">
			<cf_templatecss>
			<cfset TotalValorGen = 0>
			<cfset TotalDisminucionPTUGen = 0>
			<cfset TotalSaldoPTUGen = 0>
            <cfset TotalSaldoAPTUGen = 0>
			
			<cfoutput query="rsReporte" group="Categoria">
				<cfset TotalValorCat = 0>
				<cfset TotalDisminucionPTUCat = 0>
				<cfset TotalSaldoPTUCat = 0>
                <cfset TotalSaldoAPTUCat = 0>
				<tr>
					<td colspan="17" align="left" style="font-weight:bold" nowrap="nowrap" class="niv4" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;Categor&iacute;a: #Categoria#</td>
				</tr>
				<cfoutput group="Centro_Funcional">
				<cfset TotalValor = 0>
				<cfset TotalDisminucionPTU = 0>
				<cfset TotalSaldoPTU = 0>
                <cfset TotalSaldoAPTU = 0>
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
                      <td nowrap="nowrap" align="left" class="niv4" style="width:1%">F.&nbsp;Fin&nbsp;Depreciaci&oacute;n</td>
                      <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Valor</td>
					  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Porcentaje Deducci&oacute;n PTU</td>
                      <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Saldo PTU Anterior</td>
                      <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Disminuci&oacute;n a la Base PTU</td>
                      <td nowrap="nowrap" align="right" class="niv4" style="width:1%">Saldo PTU Pendiente</td>
                      
					</tr>
				<cfoutput>
					<cfset LvarListaNon = (CurrentRow MOD 2)>
					
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					  <td align="left" style="width:1%" nowrap="nowrap" class="niv4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Placa#</td>
					  <td class="niv4" nowrap="nowrap">#trim(Proveedor)#</td>
					  <td align="left" nowrap="nowrap" class="niv4">#Marca#</td>
					  <td align="left"  nowrap="nowrap" class="niv4">#Modelo#</td>
					  <td align="left" nowrap="nowrap" class="niv4">#Aserie#</td>
					  <td align="left" nowrap="nowrap" class="niv4" style="width:1%">#Num_Factura#</td>
					  <td align="left" class="niv4">#dateformat(FAdquisicion,'dd/mm/yyyy')#</td>
					  <td align="left" class="niv4">#dateformat(FfinDeprecia,'dd/mm/yyyy')#</td>
                      <td align="right" class="niv4">#NumberFormat(Valor,'_,_.__')#</td>
                      <td align="right" class="niv4">#ProcentajePTU#</td>
 					  <td align="right" class="niv4">#NumberFormat(SaldoAnteriorPTU,'_,_.__')#</td>
                      <td align="right" class="niv4">#NumberFormat(DisminucionPTU,'_,_.__')#</td>
					  <td align="right" class="niv4">#NumberFormat(SaldoPTU,'_,_.__')#</td>
					</tr>
					<cfset TotalValor = TotalValor + Valor>
					<cfset TotalDisminucionPTU = TotalDisminucionPTU + DisminucionPTU>
                    <cfset TotalSaldoPTU = TotalSaldoPTU + SaldoPTU>
                    <cfset TotalSaldoAPTU = TotalSaldoAPTU + SaldoAnteriorPTU>
				</cfoutput>
				
				<tr>
					<td colspan="5">&nbsp;</td>
					<td class="niv4" align="right" style="font-weight:bold" colspan="3" nowrap="nowrap">Total Centro Funcional:&nbsp;#Centro_FuncionalCod#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValor,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold"></td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoAPTU,'_,_.__')#</td>
                    <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDisminucionPTU,'_,_.__')#</td>
					<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoPTU,'_,_.__')#</td>
				</tr>
					<cfset TotalValorCat = TotalValorCat + TotalValor>
                   	<cfset TotalDisminucionPTUCat = TotalDisminucionPTUCat + TotalDisminucionPTU>
                    <cfset TotalSaldoPTUCat = TotalSaldoPTUCat + TotalSaldoPTU>
                    <cfset TotalSaldoAPTUCat = TotalSaldoAPTUCat + TotalSaldoAPTU>
			</cfoutput>
			<tr>
				<td colspan="5">&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold" colspan="3">Total por Categoría:&nbsp;#CategoriaCod#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorCat,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold"></td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoAPTUCat,'_,_.__')#</td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDisminucionPTUCat,'_,_.__')#</td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoPTUCat,'_,_.__')#</td>
			</tr>
					<cfset TotalValorGen = TotalValorGen + TotalValorCat>
					<cfset TotalDisminucionPTUGen = TotalDisminucionPTUGen + TotalDisminucionPTUCat>
                    <cfset TotalSaldoPTUGen= TotalSaldoPTUGen + TotalSaldoPTUCat>
                    <cfset TotalSaldoAPTUGen= TotalSaldoAPTUGen + TotalSaldoAPTUCat>
		</cfoutput>
			
		<cfoutput>
			 <tr>
				<td colspan="5">&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold" colspan="3">Total General:&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalValorGen,'_,_.__')#</td>
                <td class="niv4" align="right" style="font-weight:bold"></td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoAPTUGen,'_,_.__')#</td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalDisminucionPTUGen,'_,_.__')#</td>
                <td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalSaldoPTUGen,'_,_.__')#</td>
			</tr>
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

