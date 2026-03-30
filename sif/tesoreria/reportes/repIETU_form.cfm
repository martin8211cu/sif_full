<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsRep" datasource="#session.dsn#">
	SELECT		
		(select Edescripcion from Empresas where Ecodigo=p.EcodigoPago) Edescripcion,	
		case d.IETUDorigen 
			when 1 then 'CUENTAS X COBRAR' 
			when 2 then 'CUENTAS X PAGAR' 
			when 3 then 'VENTAS DE CONTADO' 
			when 4 then 'COMPRAS DE CONTADO' 
			else 'OTRO' 
		end as origen,			
		<cf_dbfunction name="concat" args="d.IETUDreferencia,'-',d.IETUDdocumento"> as IETUDreferencia,
		d.IETUDfecha,
		p.IETUPfecha as IETUPfechaPago,
		<cf_dbfunction name="concat" args="case p.IETUPtipo when 1 then 'COBRO' else 'PAGO' end,': ',p.IETUPreferencia,'-',p.IETUPdocumento"> as IETUPdocumento,
		<cf_dbfunction name="to_char" args="p.Eperiodo">#LvarCNCT#'-'#LvarCNCT#<cf_dbfunction name="to_char" args="p.Emes"> as periodo,
		case when p.IETUPmontoLocal < 0 then -d.IETUDmontoBaseLocal else d.IETUDmontoBaseLocal end as IETUDmontoBaseLocal,
		d.TESRPTCietuP,			
		(c.TESRPTCcodigo) as descrip,

		p.EcodigoPago,
		p.Eperiodo,
		p.Emes,			
		c.TESRPTCcodigo,
		c.TESRPTCdescripcion,
		case when (d.IETUDsigno) < 0 then IETUDmonto end as Debito,			
		case when (d.IETUDsigno) > 0 then IETUDmonto end as Credito,		

		'#url.aniod#-#url.mesd#' as aniod,
		'#url.anioh#-#url.mesh#' as anioh
		from IETUpago p
			inner join IETUdoc d
				inner join TESRPTconcepto c
				on c.TESRPTCid=d.TESRPTCid
			on p.IETUPid=d.IETUPid
		where 
			p.Eperiodo*100+p.Emes between #url.aniod*100+url.mesd# and #url.anioh*100+url.mesh# 
			and d.EcodigoDoc=#session.Ecodigo#
	order by IETUPfechaPago, p.IETUPreferencia,p.IETUPdocumento
</cfquery>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	<cfset typeRep = 1>
	<cf_js_reports_service_tag queryReport = "#rsRep#" 
	isLink = False 
	typeReport = #typeRep#
	fileName = "tesoreria.reportes.IETU_detallado"/>
<cfelse>
	<cfreport format="flashpaper" template="IETU_detallado.cfr" query="rsRep">
	</cfreport>
</cfif>
<!---Snegocios ?????			
		Fecha Doc ????	
<cfdump var="#url#">
<cfdump var="#form#">--->
