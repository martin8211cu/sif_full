<cfsetting enablecfoutputonly="yes">
<cfif isdefined('form.generar')>
	<cfset LvarReporte = "#GetTempDirectory()#ReporteMovimientos_#dateformat(now(),'dd_mm_yyy')#_#hour(now())#.xls">
	<cfset generaReporte()>
	<cfcontent type="application/vnd.ms-excel" file="#LvarReporte#" deletefile="yes">
	<cfheader name="Content-Disposition" value="attachment; filename=ReporteMovimientos_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>
<!--- Query:
	Tabla Principal:  
		QPMovCuenta			-- Registros de Movimientos
	Tablas:
		QPcliente			-- Cliente del banco. Join por QPCente ( ente del banco )
		QPtipoCliente		-- Tipo de Cliente del Banco
		QPassTag				-- Maestro de TAGS.  Join desde QPSalida por el TAG
		QPventaTags			-- Registro de Ventas.  Join desde QPassTag y QPcliente por QPidtag y QPcteid
		QPventaConvenio	-- Tipos de Convenio de Ventas.  Se accede desde QPventaTags
--->

<cffunction name="generaReporte" output="no">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		  select Enombre
			 from Empresa
		  where CEcodigo = #session.CEcodigo#
	 </cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsMovimiento">
		select  
			(
				select co.QPvtaConvDesc
				  from QPventaConvenio  co 
					inner join QPventaTags vta
					   on vta.QPvtaConvid = co.QPvtaConvid
			 	where vta.QPTidTag		= mov.QPTidTag	
			 	  and vta.QPvtaEstado	= 1
		    	  and vta.QPvtaTagid	= (
											select min(a.QPvtaTagid)  
											  from QPventaTags a 
												inner join QPventaConvenio c
												  on c.QPvtaConvid= a.QPvtaConvid
												where a.QPTidTag = mov.QPTidTag
											)
			) as Nombre_Convenio,

			s.QPctaSaldosTipo,
			mov.QPMCid,  
			m.Miso4217 cod_moneda,
			mov.QPMCFInclusion as fechaInclusion,							<!-----Fecha de Inclusión--->  
			mov.QPTPAN as Quick_Pass,										<!-----Dispositivo--->
			cl.QPcteNombre as NombreCliente,								<!-----Nombre del Cliente--->
			cl.QPcteDocumento as tipo_identificacion,						<!-----Identificación del Cliente--->
			(coalesce(mov.QPMCMontoLoc,0) / case when mov.QPMCMonto = 0 then 1 else mov.QPMCMonto end) as tipoCambio,
			case 
				  when s.QPctaSaldosTipo =1 then 'PostPago'
				  when s.QPctaSaldosTipo =2 then 'Prepago'
			end as tipo,											<!-----Convenio--->
			ca.QPCcodigo as cod_causa,								<!-----Código de la causa--->
			ca.QPCdescripcion as causa,								<!-----Descripción de la causa--->
			(
				select min(b.QPctaBancoNum)
					from QPcuentaBanco b 
					where b.QPctaBancoid = s.QPctaBancoid
			) as Cuenta,                     	  					<!-----Cuenta Cliente--->
			o.Oficodigo as cod_oficina,								<!---sucursal de Movimiento--->
			o.Odescripcion as oficina, 								<!---Nombre de la sucursal --->
			mov.QPMCMonto as QPMCMonto,								<!-----monto  --->
			coalesce(mov.QPMCMontoLoc,0) as QPMCMontoLoc      		<!-----Monto Local  --->
		from QPMovCuenta mov
			inner join QPCausa ca
				on mov.QPCid = ca.QPCid
			inner join QPcuentaSaldos s
				on s.QPctaSaldosid = mov.QPctaSaldosid 	
			inner join QPcliente cl
				on cl.QPcteid = mov.QPcteid	
			inner join Monedas m
				on m.Mcodigo = mov.Mcodigo	
			left outer join Oficinas o
            	 on o.Ecodigo = mov.Ecodigo
             	and o.Ocodigo = mov.Ocodigo
		 where  
		<cfif isdefined("form.fechaDesde") and len(trim(form.fechaDesde)) and isdefined("form.fechaHasta") and len(trim(form.fechaHasta))>
		   mov.QPMCFInclusion between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHasta)#">
		<cfelseif isdefined("form.fechaDesde") and len(trim(form.fechaDesde)) and not isdefined ("form.fechaDesde")>
		   mov.QPMCFInclusion >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDesde)#">
		<cfelseif isdefined("form.fechaHasta") and len(trim(form.fechaHasta))>
		   mov.QPMCFInclusion <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHasta)#">
		</cfif> 
		   <!--- Se excluyen los movimientos de cobro donde el 100% es incobrable --->
		   <!--- and mov.QPMCMonto <> 0 --->
		   and (mov.QPMovProcesado is null) or (mov.QPMovProcesado > 2)
			 order by mov.QPMCFInclusion, mov.QPTPAN  asc
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
	<cfset write_to_buffer('		<title>Consulta Reporte de Movimientos</title>')>
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

	<cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td colspan="15" align="center"><strong>#rsEmpresa.Enombre#</strong></td>')>
	<cfset write_to_buffer('</tr>')>
	<cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td colspan="15" align="center"><strong>Sistema de Telepeaje QuickPass</strong></td>')>
	<cfset write_to_buffer('</tr>')>

	<cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td colspan="15" align="center"><strong>Reporte de Movimientos Desde:#form.fechaDesde# hasta:#form.fechaHasta#</strong></td>')>
	<cfset write_to_buffer('</tr>')>
	<cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td colspan="15">&nbsp;</td>')>
	<cfset write_to_buffer('</tr>')>

	<cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td align="right" nowrap="nowrap"><strong>Fecha de Movimiento</strong></td>')>
		<cfset write_to_buffer('<td align="right"><strong>Tag</strong></td>')>
		<cfset write_to_buffer('<td align="left" nowrap="nowrap"><strong>Nombre del Cliente</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Identificación del Cliente</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Convenio</strong></td> ')>
		<cfset write_to_buffer('<td align="left"><strong>Tipo de Convenio</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Moneda</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Monto</strong></td>')>
		<cfset write_to_buffer('<td align="right"><strong>Tipo Cambio</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Monto Local</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Causa</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Cuenta Cliente</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Sucursal</strong></td>')>
		<cfset write_to_buffer('<td align="left"><strong>Nombre de la Sucursal</strong></td>')>
	<cfset write_to_buffer('</tr>')>
	<cfset write_to_file()>

	<cfloop query="rsMovimiento">
		<cfset write_to_buffer('<tr>')>
			<cfset write_to_buffer('<td x:date nowrap="nowrap" style="font-size:12px" align="left">#DateFormat(fechaInclusion,'dd/mm/yyyy')# #timeFormat(fechaInclusion, "hh:mm:ss tt")#</td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="right">#Quick_Pass#</td>')>
			<cfset write_to_buffer('<td x:str nowrap="nowrap" style="font-size:12px" align="left">#NombreCliente#</td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="left">#tipo_identificacion#</td>	')>
			<cfset write_to_buffer('<td x:str nowrap="nowrap" style="font-size:12px" align="left">#Nombre_Convenio#</td>	')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="left">#tipo#</td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="left">#cod_moneda#</td>')>
			<cfset write_to_buffer('<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(QPMCMonto, ',9.00')#</td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="right">#NumberFormat(tipoCambio,",0.00")#</td>')>
			<cfset write_to_buffer('<td x:numWith2Dec style="font-size:12px" nowrap="nowrap" align="right">#LSNumberFormat(QPMCMontoLoc, ',9.00')#</td>')>
			<cfset write_to_buffer('<td x:str nowrap="nowrap" style="font-size:12px" align="left">#cod_causa# - #causa#</td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="right"><cfif #rsMovimiento.QPctaSaldosTipo# eq 1>#Cuenta# <cfelse> N/A </cfif></td>')>
			<cfset write_to_buffer('<td x:str style="font-size:12px" align="left">#cod_oficina#</td>')>
			<cfset write_to_buffer('<td x:str nowrap="nowrap" style="font-size:12px" align="left">#oficina#</td>')>
		<cfset write_to_buffer('</tr>')>
		<cfset write_to_file()>
	</cfloop>

	<cfset write_to_buffer('<tr>')>
	<cfset write_to_buffer('<td>&nbsp;</td>')>
	<cfset write_to_buffer('</tr>')>

	<cfset write_to_buffer('</table>')>
	<cfset write_to_file()>
</cffunction>

