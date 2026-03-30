<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="ReporteViaticos.cfm"
	FileName="Reporte Viaticos.xls"
	title="Consulta"
>
<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;		  
		 } </style>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="row" default="-1">
	<cfsavecontent variable="rsReporte">
		<cfoutput>
			select o.Odescripcion as oficina,gepv.GEPVtipoviatico as tipo,
			de.DEnombre #LvarCNCT#' '#LvarCNCT# de.DEapellido1 #LvarCNCT#' '#LvarCNCT# de.DEapellido2 as empleado,
		  	gel.GELid as GELid, gelv.GEAid as GEAid, gel.GELtotalGastos as gasto, gel.GELnumero,gel.GELdescripcion as descripcion,
            rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# rtrim(cf.CFdescripcion) as CentroFuncional

				from GEliquidacion gel
				
				inner join GEliquidacionViaticos gelv
				on gel.GELid=gelv.GELid
				
				inner join CFuncional cf
				on cf.CFid=gel.CFid
				
				inner join Oficinas o
				on o.Ocodigo=cf.Ocodigo
				and o.Ecodigo=gel.Ecodigo
				
				inner join TESbeneficiario tes
				on tes.TESBid = gel.TESBid
				
				inner join DatosEmpleado de
				on de.DEid=tes.DEid
				
				inner join GEPlantillaViaticos gepv
				on gepv.GEPVid= gelv.GEPVid
				
				where 
				gel.Ecodigo=#session.Ecodigo#
				
				and gelv.GELVfechaIni between #lsparsedatetime(form.FechaDesde)#
				and #lsparsedatetime(form.FechaHasta)#
				and  gel.GELestado in (2,4,5)
				<cfif isdefined("form.OcodigoIni") and len(trim(form.OcodigoIni)) and isdefined("form.OcodigoFin") and len(trim(form.OcodigoFin))>
					<cfif form.OcodigoIni gt form.OcodigoFin >
						 and o.Ocodigo between #form.OcodigoFin#  and #form.OcodigoIni#
					 <cfelse> 
						 and o.Ocodigo between #form.OcodigoIni#  and #form.OcodigoFin#
					</cfif>
				</cfif>
				<cfif isdefined("form.DEid") and len(trim(form.DEid)) >
					 and de.DEid=#form.DEid# 
				</cfif>
				<cfif #form.tipoViatico# NEQ -1>
					and gepv.GEPVtipoviatico=  '#form.tipoViatico#'
				</cfif>	
				
				<!---group by o.Odescripcion,gepv.GEPVtipoviatico, de.DEid,gel.GELid,gel.GELnumero, gelv.GEAid --->
				order by o.Odescripcion,gepv.GEPVtipoviatico, de.DEid,gel.GELid,gel.GELnumero, gelv.GEAid
		</cfoutput>
	</cfsavecontent>
<cfoutput>		
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right">
			<table width="10%" align="right" border="0" height="25px">
				<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
				<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	<tr><td align="center" style="font-size:24px"><span class="titulox"><strong>#session.Enombre#</strong></span></td></tr>
	<tr><td align="center" style="font-size:18px"><strong>Reporte de Vi&aacute;ticos</strong></td></tr>
	<tr><td align="center"><strong>Oficina Desde : </strong>#form.OdescripcionIni# &nbsp;&nbsp; <strong> Hasta : </strong>#form.OdescripcionFin#</td></tr>
	<cfif (isdefined("form.DEid") and len(trim(form.DEid)) gt 0)>
		<tr><td align="center"><strong>Empleado : </strong>#form.DEnombre# &nbsp;&nbsp;</td></tr>
	</cfif>
	<tr><td align="center"><strong> Fecha Desde : </strong>#LSDateFormat(form.FechaDesde,'DD/MM/YYYY')#<strong>&nbsp;&nbsp;Hasta :</strong>#LSDateFormat(form.FechaHasta,'DD/MM/YYYY')#</td></tr>
	<tr>
		<td align="center">
			<strong>Tipo : 
			<cfif #form.tipoViatico# eq -1>				
				</strong>TODOS&nbsp;&nbsp;
			<cfelseif #form.tipoViatico# eq 1>	
				</strong>Interior&nbsp;&nbsp;
			<cfelseif #form.tipoViatico# eq 2>
				</strong>Exterior&nbsp;&nbsp;
			</cfif>
		</td>
	</tr>
</table>
<br />
</cfoutput>

<table width="100%" border="0" cellspacing="2">
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#rsReporte#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfset registros = 0 >
	<cfset totalvehiculos = 0 >

	<cfoutput query="data" group="oficina"  maxrows="5000">
		<cfset registros = registros + 1 >
		<tr><td class="tituloListas"  colspan="20"><strong>OFICINA: </strong> #oficina#</td></tr>
		 <cfoutput group="tipo"> 
		 <tr><td class="tituloListas" colspan="20"  ><strong>TIPO:</strong> <cfif #tipo# eq 1 > Interior <cfelseif #tipo# eq 2> Exterior </cfif> </td></tr>
		<cfoutput group="empleado"> 
		 <tr><td class="tituloListas" colspan="20" ><strong>EMPLEADO:</strong> #empleado#</td></tr>
         <tr><td class="tituloListas" colspan="20" ><strong>CENTRO FUNCIONAL:</strong> #CentroFuncional#</td></tr>
		<cfoutput group="GELnumero"> 
		 <tr>
		 	<td class="tituloListas" colspan="15"   ><strong>Liquidación:</strong>#GELnumero#</td>
			<td class="tituloListas" colspan="3"  ><strong>Descripción:</strong>#descripcion#</td>
			<td class="tituloListas" colspan="2"  ><strong>Total:</strong>#LSNumberFormat(gasto, ',9.00')#</td>
		 </tr>
		 <tr style="padding:10px;">
		 <td style="padding:3px;font-size:15px" colspan="20"  bgcolor="CCCCCC" nowrap="nowrap"></td>
		<cfquery name="rsLiquidaciones" datasource="#session.dsn#">
			select 
				gep.GEPVid, 
				gep.GEPVdescripcion,  
				gep.Mcodigo,mon.Mnombre, gep.GEPVmonto, 
				gec.GECVid, 
				gec.GECVcodigo, 
				gec.GECVdescripcion,
				gel.GELVfechaIni, gel.GELVfechaFin, 
				gel.GELVhoraIni, gel.GELVhorafin, 
				gel.GELVmontoOri, gel.GEPVmontoGastMV, gel.GELVtipoCambio, gel.GELVmonto,gel.GECid
		
				from GEliquidacionViaticos gel 
				inner join GEPlantillaViaticos gep 
				on gep.GEPVid= gel.GEPVid 
		
				inner join GEClasificacionViaticos gec 
				on gep.GECVid=gec.GECVid 
		
				inner join Monedas mon 
				on mon.Mcodigo = gep.Mcodigo
				and mon.Ecodigo = gep.Ecodigo
				<!---left outer join Htipocambio htc 
				on htc.Mcodigo = mon.Mcodigo 
				and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah --->
		
				where gel.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
				and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and gep.Ecodigo=#session.ecodigo# 
				
				UNION
		
			select 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">  as GEPVid, 
				'--' as GEPVdescripcion, 
				ge.Mcodigo, mon.Mnombre, gel.GELVmontoOri as GEPVmonto,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GECVid,
				 '--' as GECVcodigo,
				 gecg.GECdescripcion as GECVdescripcion, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as GELVfechaIni,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as GELVfechaFin,  
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> as GELVhoraIni,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> as GELVhorafin, 
				gel.GELVmontoOri, gel.GEPVmontoGastMV, coalesce(TCcompra,1)  as GELVtipoCambio, gel.GELVmonto ,gel.GECid
				
				from GEliquidacionViaticos gel 
				
				inner join GEconceptoGasto gecg 
					on gecg.GECid= gel.GECid 
				
				inner join GEanticipo ge
					on ge.GEAid=gel.GEAid
				
				inner join Monedas mon 
				on mon.Mcodigo = ge.Mcodigo
				 and mon.Ecodigo = ge.Ecodigo 
				 left outer join Htipocambio htc 
				 on htc.Mcodigo = mon.Mcodigo 
				and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah 
				
				where gel.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
				and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and ge.Ecodigo=#session.ecodigo#  
				and gel.GELVfechaIni is  null
				order by GELVfechaIni,GELVhoraIni, GECid
						
		</cfquery>
		 
		<table width="100%" border="1" align="center" >
			 <tr bgcolor="999999">
					<td width="150"><div align="center"><strong>Plantilla</strong></div></td>
					<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
					<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
					<td width="65"><div align="center"><strong>Hora Inicio</strong></div></td>
					<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
					<td width="70"><div align="center"><strong>Hora Final</strong></div></td>
					<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
					<td width="90"><div align="center"><strong>Monto Plantilla</strong></div></td>
					<td width="90"><div align="center"><strong>Monto Real </strong></div></td>
					<td width="65"><div align="center"><strong>Tipo de Cambio </strong></div></td>
					<td width="90"><div align="center"><strong>Monto </strong></div></td>
			  </tr>
		</table>
		<cfloop query="rsLiquidaciones">	
			<table width="100%" border="0" align="center">
				<tr>
					<td width="160" nowrap="nowrap"><div align="center"><strong>#GEPVdescripcion#</strong></div></td>
					<td width="178" nowrap="nowrap"><div align="center">#GECVdescripcion#</div></td>
					<td width="80"  nowrap="nowrap"><div align="center">#DateFormat(GELVfechaIni,'DD/MM/YYYY')#	</div></td>
					<td width="60"  nowrap="nowrap"><div align="center"><cf_hora name="GELVhoraIni" form="formDet" value="#GELVhoraIni#" image="false" readOnly="true"></div></td>
					<td width="80"  nowrap="nowrap"><div align="center">#DateFormat(GELVfechaFin,'DD/MM/YYYY')#</div></td>
					<td width="70"  nowrap="nowrap"><div align="center"><cf_hora name="GELVhorafin" form="formDet" value="#GELVhorafin#" image="false" readOnly="true"></div></td>
					<td width="75"  nowrap="nowrap"><div align="center">#Mnombre#</div></td>
					<td width="90"  nowrap="nowrap"><div align="right">#LSNumberFormat(GELVmontoOri, ',9.00')#</div></td>
					<td width="90"  nowrap="nowrap"><div align="right"><cf_inputNumber name="montoReal" size="12" value="#GEPVmontoGastMV#" enteros="12" decimales="2" readonly="true"></div></td>
					<td width="60"  nowrap="nowrap"><div align="right">#LSNumberFormat(GELVtipoCambio, ',9.00')#</div></td>
					<td width="90"  nowrap="nowrap"><div align="right">#LSNumberFormat(GELVmonto,',9.00')#</div></td>
					<td width="10"></td>
				</tr>
			</table>
		</cfloop>
	
<table width="100%" border="0" align="center">		 
		<tr><td>&nbsp;</td></tr>
			</cfoutput>
		</cfoutput> <!---cierra el empleado--->
		</cfoutput><!---cierra el tipo--->
	</cfoutput><!---cierra la oficina--->
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<cfif registros gt 0 >
	<cfelse>
		<tr><td colspan="30" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="30" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>

