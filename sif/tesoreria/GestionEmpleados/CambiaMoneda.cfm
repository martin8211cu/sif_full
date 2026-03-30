<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfif #url.Mcodigo# neq 'undefined'>
	<!---Query que busca la moneda del detalle--->
	<cfif isdefined('url.Mcodigo') and len(trim(url.Mcodigo))>
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo, Mnombre, Miso4217
			  from Monedas
			where Mcodigo=#url.Mcodigo#
			  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarMcodigoDep='#url.Mcodigo#'>
	</cfif>
	
	<!---Query que busca el tipo de Cambio--->
	<cfif isdefined('url.Fecha')>
		<cfquery name="TCsug" datasource="#session.dsn#">
			select tc.Mcodigo, tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and tc.Mcodigo=#url.Mcodigo#
			  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(url.Fecha)#">
			  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(url.Fecha)#">
		</cfquery>
	</cfif>
	
	<!---Query que busca el encabezado de la Liquidacion--->
	<cfquery name="rsLiq" datasource="#session.dsn#">
		select a.Mcodigo, coalesce(a.GELtipoCambio,1) as GELtipoCambio, e.Mcodigo as McodigoLocal
		  from GEliquidacion  a
			inner join Empresas e on e.Ecodigo=a.Ecodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID_l#">
	</cfquery>
	
	<cfif LvarMcodigoDep EQ rsLiq.McodigoLocal>
		<!--- Moneda Local o NULL --->
		<cfset LvarTC = 1>
		<cfset LvarFC = 1 / rsLiq.GELtipoCambio>
		<cfset LvarDisabled = "true">
	<cfelseif LvarMcodigoDep EQ rsLiq.Mcodigo>
		<!--- Moneda Liquidacion --->
		<cfset LvarTC = rsLiq.GELtipoCambio>
		<cfset LvarFC = 1>
		<cfset LvarDisabled = "true">
	<cfelse>
		<!--- Otra Moneda --->
		<cfif isdefined("url.factor")>
			<cfset LvarTC = replace(url.factor,",","","ALL") * rsLiq.GELtipoCambio>
		<cfelseif isdefined("url.tipo")>
			<cfset LvarTC = replace(url.Tipo,",","","ALL")>
		<cfelseif isdefined("TCSug") and len(trim(TCSug.TCventa))>
			<cfset LvarTC = TCSug.TCventa>
		<cfelse>
			<cfset LvarTC = 1>
		</cfif>
		<cfset LvarFC = LvarTC / rsLiq.GELtipoCambio>
		<cfset LvarDisabled = "false">
	</cfif>
	
	<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		window.parent.document.formDep.LvarMo.value			= "#rsMoneda.Miso4217#"
		window.parent.document.formDep.tipoCambio.value 	= "#Numberformat(LvarTC,",9.0000")#";
		window.parent.document.formDep.tipoCambio.disabled	= #LvarDisabled#;
		window.parent.document.formDep.factor.value			= "#Numberformat(LvarFC,",9.0000")#";
		window.parent.document.formDep.factor.disabled		= #LvarDisabled#;
		window.parent.document.formDep.liqui.disabled	=	true;
		<cfif isdefined ('url.Monto')>
			<cfset url.Monto = replace(url.Monto,",","","ALL")>
			window.parent.document.formDep.montodep.value	= "#Numberformat(url.Monto,",9.00")#";
			window.parent.document.formDep.liqui.value		= "#Numberformat(url.Monto * LvarFC,",9.00")#";
		<cfelse>
			window.parent.document.formDep.montodep.value	= fm(window.parent.document.formDep.montodep.value,2);
			var MontoDoc = parseFloat(qf(window.parent.document.formDep.montodep.value));
			MontoDoc = Math.round (MontoDoc * #numberFormat(LvarFC,"9.999999999")# * 100)/100;
			window.parent.document.formDep.liqui.value		= fm(MontoDoc,2);
		</cfif>
	</script>
	</cfoutput>
</cfif>	
