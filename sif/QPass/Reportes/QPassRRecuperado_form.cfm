
<cfsetting enablecfoutputonly="yes">
<cfif isdefined('form.generar')>
	<cfset LvarReporte = "#GetTempDirectory()#ReporteRecuperados_#dateformat(now(),'dd_mm_yyy')#_#hour(now())#.xls">
	<cfset generaReporte()>
	<cfcontent type="application/vnd.ms-excel" file="#LvarReporte#" deletefile="yes">
	<cfheader name="Content-Disposition" value="attachment; filename=ReporteRecuperados_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<cffunction name="generaReporte" output="no">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		  select Enombre
		 	 from Empresa
		  where CEcodigo = #session.CEcodigo#
	 </cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsRecuperados" maxrows="10000"><!--- 14000 --->
		select  
			s.QPctaSaldosTipo,
			movNeg.QPMCMontoLoc as montoOriNC,
			a.QPMCAFAplicacion  as Fecha_Recuperado,									<!-----Fecha de recuperado--->  
			movNeg.QPMCFInclusion as fechaMovOri,									<!-----Fecha Original del movimiento--->  
		 	a.QPMCAMonAplicar as monto_Aplicar,										<!-----monto Original--->  
			a.QPMCAMonBloqueado as monto_recuperado,								<!-----monto Recuperado--->  
			a.QPMCAMonAplicar - a.QPMCAMonBloqueado as Faltante_por_Recuperar,
			movNeg.QPTPAN as Quick_Pass,											<!-----Dispositivo--->
			cl.QPcteNombre as NombreCliente,										<!-----Nombre del Cliente--->
			cl.QPcteDocumento as tipo_identificacion,								<!-----Identificación del Cliente--->
					
			case 
				  when s.QPctaSaldosTipo =1 then 'PostPago'
				  when s.QPctaSaldosTipo =2 then 'Prepago'
			end as tipo,  	

			((
				select co.QPvtaConvDesc
				from QPventaConvenio  co 
				  inner join QPventaTags vta
					 on vta.QPvtaConvid = co.QPvtaConvid
			 	where vta.QPTidTag = movNeg.QPTidTag	
		    	and vta.QPvtaTagid =(select min(a.QPvtaTagid)  from QPventaTags a 
							inner join QPventaConvenio c
							on c.QPvtaConvid= a.QPvtaConvid
							where a.QPTidTag = movNeg.QPTidTag)
			)) as Nombre_Convenio,

			ca.QPCcodigo as cod_causa,											<!-----Código de la causa--->
			ca.QPCdescripcion as causa,											<!-----Descripción de la causa--->
			((
					select min(b.QPctaBancoNum)
						from QPcuentaBanco b 
						where b.QPctaBancoid = s.QPctaBancoid
			)) as Cuenta    													<!-----Cuenta Cliente--->
		from QPMovCuentaAplicacion a
			inner join QPMovCuenta movNeg
				on  movNeg.QPMCid = a.QPMCidNeg
			inner join QPMovCuenta movPos
				on  movPos.QPMCid = a.QPMCidPos
			inner join QPCausa ca
				on movNeg.QPCid = ca.QPCid
			inner join QPcuentaSaldos s
				on s.QPctaSaldosid = movNeg.QPctaSaldosid 	
			inner join QPcliente cl
				on cl.QPcteid = movNeg.QPcteid	
		where 
		<cfif isdefined("form.fechaDesde") and len(trim(form.fechaDesde)) and isdefined("form.fechaHasta") and len(trim(form.fechaHasta))>
			a.QPMCAFAplicacion between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDesde)#"> 
								   and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHasta)#">
		<cfelseif isdefined("form.fechaDesde") and len(trim(form.fechaDesde)) and not isdefined ("form.fechaDesde")>
			a.QPMCAFAplicacion >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDesde)#">
		<cfelseif isdefined("form.fechaHasta") and len(trim(form.fechaHasta)) and not isdefined ("form.fechaHasta")>
			a.QPMCAFAplicacion <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHasta)#">
		</cfif>
			<!--- Que se haya recuperado algo --->
		   and a.QPMCAMonBloqueado <> 0
			<!--- Que el movimiento negativo haya tenido incobrable alguna vez --->
		   and (
		   		select count(1) 
				  from QPMovCuentaAplicacion 
				 where QPMCidNeg = a.QPMCidNeg 
				   and QPMCAMonIncobrable <> 0
				) > 0
		order by movPos.QPMCFInclusion, movNeg.QPTPAN  asc
	</cfquery>

	<cfset generaHTML()>
</cffunction>

<cffunction name="write_to_buffer" output="no">
	<cfargument name="contents" type="string" required="yes">
	<cfset bufferAjax.append(JavaCast("string", Arguments.contents))>
</cffunction>
	
<cffunction name="write_to_file" output="no">
	<cfargument name="action" type="string" default="append">

	<cffile action	= "#arguments.action#" 
			file	= "#LvarReporte#" 
			output	= "#bufferAjax.toString()#"
	>
	<cfset bufferAjax.setLength(0)>
</cffunction>

<cffunction name="generaHTML" output="no">
	<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "bufferAjax">
	<cfset write_to_buffer('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"')>
	<cfset write_to_buffer('	"http://www.w3.org/TR/html4/loose.dtd">')>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">')>
	<cfset write_to_buffer('	<head>')>
	<cfset write_to_buffer('		<title>Consulta Reporte de Recuperados</title>')>
	<cfset write_to_buffer('		<style type="text/css">')>
	<cfset write_to_buffer('			table')>
	<cfset write_to_buffer('			{mso-displayed-decimal-separator:"\.";')>
	<cfset write_to_buffer('			mso-displayed-thousand-separator:"\,";}')>
	<cfset write_to_buffer('			.numWithoutDec {mso-number-format:\##\,\##\##0?;text-align:right;}')>
	<cfset write_to_buffer('			.numWith2Dec {mso-number-format:Standard;text-align:right}')>
	<cfset write_to_buffer('			.date {mso-number-format:dd\/mm\/yyyy\;\@}')>
	<cfset write_to_buffer('		</style>')>
	<cfset write_to_buffer('		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">')>
	<cfset write_to_buffer('		<meta http-equiv="content-language" content="es" />')>
	<cfset write_to_buffer('	</head>')>
	<cfset write_to_buffer('	<table>')>
	<cfset write_to_file('write')>		
	
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td colspan="10" align="center"><strong>#rsEmpresa.Enombre#</strong></td>')>
	<cfset write_to_buffer('		</tr>')>
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td colspan="10" align="center"><strong>Sistema de Telepeaje QuickPass</strong></td>')>
	<cfset write_to_buffer('		</tr>')>
	
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td colspan="10" align="center"><strong>Reporte de Recuperados Desde:#form.fechaDesde# hasta:#form.fechaHasta#</strong></td>')>
	<cfset write_to_buffer('		</tr>')>
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td colspan="10">&nbsp;</td>')>
	<cfset write_to_buffer('		</tr>')>
	
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td align="left" nowrap="nowrap"><strong>Fecha de Recuperado</strong></td>')>
	<cfset write_to_buffer('			<td align="left" nowrap="nowrap"><strong>Fecha de Movimiento Origen</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Mto Orig Mov</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Mto a Cobrar</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Monto Recuperado</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Faltante por Recuperar</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Tag</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Nombre del Cliente</strong></td> ')>
	<cfset write_to_buffer('			<td align="left"><strong>Identificación del Cliente</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Tipo de Convenio</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Nombre del Convenio</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Causa</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Cuenta Cliente</strong></td>')>
	<cfset write_to_buffer('		</tr>')>
	<cfset write_to_file()>
			
			<cfloop query="rsRecuperados">
				<cfset write_to_buffer('<tr>')>
				<cfset write_to_buffer('	<td x:date nowrap="nowrap" style="font-size:12px" align="left">#DateFormat(Fecha_Recuperado,'dd/mm/yyyy')# #timeFormat(Fecha_Recuperado, "hh:mm:ss tt")#</td>')>
				<cfset write_to_buffer('	<td x:date nowrap="nowrap" style="font-size:12px" align="left">#DateFormat(fechaMovOri,'dd/mm/yyyy')# #timeFormat(fechaMovOri, "hh:mm:ss tt")#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(montoOriNC, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(monto_Aplicar, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(monto_recuperado, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(Faltante_por_Recuperar, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="right">#Quick_Pass#</td>	')>
				<cfset write_to_buffer('	<td x:str nowrap="nowrap" style="font-size:12px" align="left">#NombreCliente#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#tipo_identificacion#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#tipo#</td>')>
				<cfset write_to_buffer('	<td x:str nowrap="nowrap" style="font-size:12px" align="left">#Nombre_Convenio#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#cod_causa# - #causa#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="right"><cfif #rsRecuperados.QPctaSaldosTipo# eq 1>#Cuenta# <cfelse> N/A </cfif></td>')>
				<cfset write_to_buffer('</tr>')>
				<cfset write_to_file()>
			</cfloop>
			
			<cfset write_to_buffer('<tr>')>
			<cfset write_to_buffer(' <td>&nbsp;</td>')>
			<cfset write_to_buffer('</tr>')>
		<cfset write_to_buffer('</table>')>
		<cfset write_to_file()>
</cffunction>
