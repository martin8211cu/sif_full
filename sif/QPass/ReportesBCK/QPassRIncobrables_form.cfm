<!--- <cfoutput>#session.Reporte.QPIncobrable#</cfoutput>
<cfdump var="#form#">
<cfdump var="#url#"> --->
<cfsetting enablecfoutputonly="yes">
<cfif isdefined('url.generar')>
	<cfset LvarReporte = "#GetTempDirectory()#ReporteIncobrables_#dateformat(now(),'dd_mm_yyy')#_#hour(now())#.xls">
	<cfset generaReporte()>
	<cfcontent type="application/vnd.ms-excel" file="#LvarReporte#" deletefile="yes">
	<cfheader name="Content-Disposition" value="attachment; filename=ReporteIncobrables_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<cffunction name="generaReporte" output="no">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	  select Enombre
	    from Empresa
	   where CEcodigo = #session.CEcodigo#
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsIncobrable">
		select 
			s.QPctaSaldosTipo,
			a.QPMCAFAplicacion,
			
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
			
			a.QPMCAFAplicacion  as FPIncobrable,
			movNeg.QPMCMontoLoc as montoOriNC,
			a.QPMCidNeg,
		 	a.QPMCAMonAplicar as monto_Aplicar,
			a.QPMCAMonIncobrable as monto_NoCobrado,
			movNeg.QPMCid,  
			movNeg.QPMCFInclusion as fechaMovOri,							<!-----Fecha de Inclusión--->  
			movNeg.QPTPAN as Quick_Pass,									<!-----Dispositivo--->
			cl.QPcteNombre as NombreCliente,							<!-----Nombre del Cliente--->
			cl.QPcteDocumento as tipo_identificacion,					<!-----Identificación del Cliente--->
												
			case 
				  when s.QPctaSaldosTipo =1 then 'PostPago'
				  when s.QPctaSaldosTipo =2 then 'Prepago'
			end as tipo,  												<!-----Tipo de Convenio--->
			ca.QPCcodigo as cod_causa,									<!-----Código de la causa--->
			ca.QPCdescripcion as causa,									<!-----Descripción de la causa--->
			(
				select min(b.QPctaBancoNum)
					from QPcuentaBanco b 
					where b.QPctaBancoid = s.QPctaBancoid
			) as Cuenta 
			
			
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
		<cfif isdefined("url.fechaDesde") and len(trim(url.fechaDesde)) and isdefined("url.fechaHasta") and len(trim(url.fechaHasta))>
			a.QPMCAFAplicacion between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHasta)#">
		<cfelseif isdefined("url.fechaDesde") and len(trim(url.fechaDesde)) and not isdefined ("url.fechaDesde")>
			a.QPMCAFAplicacion >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDesde)#">
		<cfelseif isdefined("url.fechaHasta") and len(trim(url.fechaHasta)) and not isdefined ("url.fechaHasta")>
			a.QPMCAFAplicacion <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHasta)#">
		</cfif> 
			<!--- Que haya generado incobrable --->
		   and a.QPMCAMonIncobrable <> 0
			<!--- Que sea el primer incobrable del Movimiento Negativo --->
		   and (
				select min(QPMCAid) 
				  from QPMovCuentaAplicacion 
				 where QPMCidNeg = a.QPMCidNeg 
				   and QPMCAMonIncobrable <> 0
				) = a.QPMCAid
		 order by movPos.QPMCFInclusion, movNeg.QPTPAN  asc
	</cfquery>
	
	<cfset generaHTML()>
    <!--- <cfoutput>#session.Reporte.QPIncobrable#</cfoutput>&nbsp; --->
    <cfset session.Reporte.QPIncobrable = 2>
    <!--- <cfoutput>#session.Reporte.QPIncobrable#</cfoutput> --->
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

<!---********sin pasar--->
<!--- <cfcontent type="application/vnd.ms-excel">
	<cfheader name="Content-Disposition" value="attachment; filename=ReporteIncobrables_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")> --->

	<cfset write_to_buffer('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"')>
	<cfset write_to_buffer('	"http://www.w3.org/TR/html4/loose.dtd">')>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">')>
	<cfset write_to_buffer('	<head>')>
	<cfset write_to_buffer('		<title>Consulta Reporte de Incobrables</title>')>
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

<!---<cfif isdefined('url.generar')>--->
	<!--- Query:
		Tabla Principal:  
			QPMovCuentaAplicacion		-- Registros de Movimientos
		Tablas:
			QPcliente			-- Cliente del banco. Join por QPCente ( ente del banco )
			QPtipoCiente		-- Tipo de Cliente del Banco
			QPassTag				-- Maestro de TAGS.  Join desde QPSalida por el TAG
			QPventaTags			-- Registro de Ventas.  Join desde QPassTag y QPcliente por QPidtag y QPcteid
			QPventaConvenio	-- Tipos de Convenio de Ventas.  Se accede desde QPventaTags--->


 		
	
		<cfset write_to_buffer('<table>')>
		<cfset write_to_file('write')>
		<cfset write_to_buffer('	<tr>')>
		<cfset write_to_buffer('		<td colspan="10" align="center"><strong>#rsEmpresa.Enombre#</strong></td>')>
		<cfset write_to_buffer('	</tr>')>
		<cfset write_to_buffer('	<tr>')>
		<cfset write_to_buffer('		<td colspan="10" align="center"><strong>Sistema de Telepeaje QuickPass</strong></td>')>
		<cfset write_to_buffer('	</tr>')>
		<cfset write_to_buffer('	<tr>')>
		<cfset write_to_buffer('		<td colspan="10" align="center"><strong>Reporte de Incobrables Desde:#url.fechaDesde# hasta:#url.fechaHasta#</strong></td>')>
		<cfset write_to_buffer('	</tr>')>
		<cfset write_to_buffer('	<tr>')>
		<cfset write_to_buffer('		<td colspan="10">&nbsp;</td>')>
		<cfset write_to_buffer('	</tr>')>
		
		<cfset write_to_buffer('	<tr>')>
		<cfset write_to_buffer('		<td align="left" nowrap="nowrap"><strong>Fecha Primer Incobrable</strong></td>')>
		<cfset write_to_buffer('		<td align="left" nowrap="nowrap"><strong>Fecha de Movimiento Origen</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Mto Orig Mov. No Cobrado</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Mto a Cobrar</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Monto Incobrable</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Tag</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Nombre del Cliente</strong></td> ')>
		<cfset write_to_buffer('		<td align="left"><strong>Identificación del Cliente</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Causa</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Tipo de Convenio</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Nombre del Convenio</strong></td>')>
		<cfset write_to_buffer('		<td align="left"><strong>Cuenta Cliente</strong></td>')>
		<cfset write_to_buffer('	</tr>')>
		<cfset write_to_file()>
			
			<cfloop query="rsIncobrable">
				<cfset write_to_buffer('<tr>')>
				<cfset write_to_buffer('	<td x:date nowrap="nowrap" style="font-size:12px" align="left">#DateFormat(FPIncobrable,'dd/mm/yyyy')# #timeFormat(FPIncobrable, "hh:mm:ss tt")#</td>')>
				<cfset write_to_buffer('	<td x:date nowrap="nowrap" style="font-size:12px" align="left">#DateFormat(fechaMovOri,'dd/mm/yyyy')# #timeFormat(fechaMovOri, "hh:mm:ss tt")#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(montoOriNC, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(monto_Aplicar, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(monto_NoCobrado, ',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="right">#Quick_Pass#</td>	')>
				<cfset write_to_buffer('	<td x:str nowrap="nowrap" style="font-size:12px" align="left">#NombreCliente#</td>	')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#tipo_identificacion#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#cod_causa# - #causa#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#tipo#</td>')>
				<cfset write_to_buffer('<td x:str nowrap="nowrap" style="font-size:12px" align="left">#Nombre_Convenio#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="right"><cfif #rsIncobrable.QPctaSaldosTipo# eq 1>#Cuenta# <cfelse> N/A </cfif></td>')>
				<cfset write_to_buffer('</tr>')>
				<cfset write_to_file()>
			</cfloop>
			<cfset write_to_buffer('<tr>')>
				<cfset write_to_buffer('<td>&nbsp;</td>')>
			<cfset write_to_buffer('</tr>')>

		<cfset write_to_buffer('</table>')>
		<cfset write_to_file()>
</cffunction>