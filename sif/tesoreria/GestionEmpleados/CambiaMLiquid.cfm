<!--- 
	Me premite calcular los factores de comberción y los montos en la moneda del Encabezado de la Liquidación...
	Hace los calculo para que se pueda ingresar el factor de conversión y calcule el monto en moneda del Emcabezado de la Liquidación. 
--->

<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfif #url.Mcodigo# eq 'undefined'>
	<cfreturn>
</cfif>

<cfparam name="session.CambiaMLiquid" default="false">
<cfif session.CambiaMLiquid and NOT isdefined('url.Rcodigo')>
	<cfreturn>
</cfif>
<cfset session.CambiaMLiquid = true>

<cftry>
	<!---Query que busca la moneda del detalle--->
	<cfif isdefined('url.Mcodigo') and len(trim(url.Mcodigo))>
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo, Mnombre, Miso4217
			  from Monedas
			where Mcodigo=#url.Mcodigo#
			  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarMcodigoDet='#url.Mcodigo#'>
	</cfif>
	
	<!---Query que busca el tipo de Cambio--->
	<cfif isdefined('url.Fecha')>
		<cfquery name="TCsug" datasource="#session.dsn#">
			select tc.Mcodigo, tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and tc.Mcodigo=#url.Mcodigo#
			  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fecha)#">
			  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fecha)#">
		</cfquery>
	</cfif>
	
	<!---Query que busca el encabezado de la Liquidacion--->
	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, ml.Miso4217, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
		  	inner join Monedas ml on ml.Mcodigo = a.Mcodigo
			inner join Empresas e on e.Ecodigo=a.Ecodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID_l#">
	</cfquery>
	
	<cfif LvarMcodigoDet EQ rsLiq.McodigoLocal>
		<!--- Moneda Local o NULL --->
		<cfset LvarTC = 1>
        <cfset LvarTC1 = 1>
        
		<cfif rsLiq.GELtipoCambio EQ 0>
			<cfset LvarFC = 1>
		<cfelse>
			<cfset LvarFC = 1 / rsLiq.GELtipoCambio>
		</cfif>
		<cfset LvarDisabled = "true">
	<cfelseif LvarMcodigoDet EQ rsLiq.Mcodigo>
		<!--- Moneda Liquidacion --->
		<cfset LvarTC = rsLiq.GELtipoCambio>
        <cfset LvarTC1 = rsLiq.GELtipoCambio>
		<cfset LvarFC = 1>        
		<cfset LvarDisabled = "true">
	<cfelse>
		<!--- Otra Moneda --->
		<cfif isdefined("url.tipo") and len(url.tipo) GT 0>
			<cfset LvarTC = fnAjustaMonto(url.Tipo)>
            <cfset LvarTC1 = TCSug.TCventa>
		<cfelseif isdefined("url.factor")>
        	<cfset LvarTC = fnAjustaMonto(url.factor) * rsLiq.GELtipoCambio>
		<cfelseif isdefined("TCSug") and len(trim(TCSug.TCventa))>
        	<cfset LvarTC  = TCSug.TCventa>
            <cfset LvarTC1 = TCSug.TCventa> 
		<cfelse>
			<cfset LvarTC = 0>
            <cfset LvarTC1 = 1>
		</cfif>
		<cfset LvarFC = LvarTC / rsLiq.GELtipoCambio>
		<cfset LvarDisabled = "false">
	</cfif>

	<!----OBTENEMOS LA RETENCION SI EXISTE------->
	<cfif isdefined('url.Rcodigo') and url.Rcodigo NEQ '' and isdefined ('url.Monto') and #url.Rcodigo# neq -1 >
		<cfset url.Monto = fnAjustaMonto(url.Monto) >
		<cfquery name="rsRetenciones" datasource="#Session.DSN#">
				select Rporcentaje ,isnull(isVariable,0) as isvar
				from Retenciones 
				where Ecodigo = #Session.Ecodigo#
				and Rcodigo = '#url.Rcodigo#'
				order by Rdescripcion
		</cfquery>
		<cfset isvar=rsRetenciones.isvar>
		<cfset montoRetencion = (rsRetenciones.Rporcentaje/100 * url.Monto)> <!---Calculo del % de retencion-	--->
	<cfelse>
		<cfset isvar=0>
		<cfset porcentaje = 0 >
		<cfset monto = 0>
		<cfset montoRetencion = 0>
	</cfif>
	
	<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		//window.parent.document.formDet.LvarMo.value				= "#rsMoneda.Miso4217#"
		window.parent.document.formDet.GELGtipoCambio.value		= "#Numberformat(LvarTC,",9.0000")#";
		window.parent.document.formDet.GELGtipoCambio.disabled	= #LvarDisabled#;
		window.parent.document.formDet.factor.value				= "#Numberformat(LvarFC,",9.0000")#";
		window.parent.document.formDet.factor.disabled			= #LvarDisabled#;
		window.parent.document.formDet.GELGtotal.disabled		= true;

		window.parent.document.formDet.TotalRetenc.value 		= "#Numberformat(montoRetencion,",9.00")#";
		window.parent.document.formDet.MontoRetencionAnti.value	= "#Numberformat(montoRetencion * LvarFC,",9.00")#";
		window.parent.document.formDet.TotalRetenc.value 		= "#Numberformat(montoRetencion,",9.00")#";
		window.parent.document.formDet.M_FC.value 				= "#rsLiq.Miso4217#s/#rsMoneda.Miso4217#";
		<cfif isdefined ('url.Monto')>
			<cfset url.Monto = fnAjustaMonto(url.Monto)>
			window.parent.document.formDet.GELGtotalOri.value	= "#Numberformat(url.Monto,",9.00")#";
			window.parent.document.formDet.GELGtotal.value		= "#Numberformat(url.Monto * LvarFC,",9.00")#";
			window.parent.document.formDet.GELTmonto.value		= "#Numberformat(url.Monto * LvarFC,",9.00")#";
			<cfif isdefined('url.cambMonD') and #url.cambMonD# EQ 1>
			window.parent.document.formDet.GELTmontoTCE.value   = "#Numberformat(url.Monto * LvarFC,",9.00")#";
			window.parent.document.formDet.TC_TCE.value			= "#LvarTC#";
			</cfif>
			
		<cfelse>
			window.parent.document.formDet.GELGtotalOri.value		= fm(window.parent.document.formDet.GELGtotalOri.value,2);
			var MontoDoc = parseFloat(qf(window.parent.document.formDet.GELGtotalOri.value));
			var MontoLiq = Math.round (MontoDoc * #numberFormat(LvarFC,"9.999999999")# * 100)/100;
			window.parent.document.formDet.GELGtotal.value		= fm(MontoLiq,2);
			<cfif isdefined('url.cambMonD') and #url.cambMonD# EQ 1>
			window.parent.document.formDet.GELTmontoTCE.value   = fm(MontoLiq,2);
			</cfif>
		</cfif>

		<cfif isvar EQ 1>
			window.parent.document.formDet.TotalRetenc.readOnly = false;
			window.parent.document.formDet.MontoRetencionAnti.readOnly = false;
		</cfif>
		fm(window.parent.document.formDet.GELGtotal,2);
		fm(window.parent.document.formDet.TotalRetenc,2);
		fm(window.parent.document.formDet.MontoRetencionAnti,2);
		if (window.parent.document.formDet.M_Doc1)
		{
			window.parent.document.formDet.M_Doc1.value = "#rsMoneda.Miso4217#s";
			window.parent.document.formDet.M_Doc2.value = "#rsMoneda.Miso4217#s";
			window.parent.document.formDet.M_Doc3.value = "#rsMoneda.Miso4217#s";
			window.parent.document.formDet.M_Doc4.value = "#rsMoneda.Miso4217#s";
			window.parent.document.formDet.M_Doc5.value = "#rsMoneda.Miso4217#s";
			window.parent.document.formDet.M_Doc6.value = "#rsMoneda.Miso4217#s";
		}
		if (window.parent.CambiaTCE)
			window.parent.CambiaTCE(0);
	</script>
	</cfoutput>
<cfcatch type="any">
	<cfset session.CambiaMLiquid = false>
	<cfrethrow>
</cfcatch>
</cftry>

<cffunction name="fnAjustaMonto" returntype="string">
	<cfargument name="monto">
	<cfset var LvarMonto = trim(replace(Arguments.monto,",","","ALL"))>
	<cfif LvarMonto EQ "">
		<cfset LvarMonto = 0>
	</cfif>
	<cfreturn LvarMonto>
</cffunction>