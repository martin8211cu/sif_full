<cfparam name="form.CurrentPage" default="Equilibrio.cfm">
<cfparam name="form.CPPid" default="-1">
<cfparam name="param" default="">
<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CPPid#" returnVariable="CPPid">
<cfif isdefined('form.EnviarAprobarI')>
	<cfquery datasource="#session.dsn#" name="rsEInc">
		select FPEEid
		from FPEEstimacion
		where Ecodigo = #session.Ecodigo# 
		  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
		  and FPEEestado = 2
	</cfquery>
	<cfif rsEInc.recordcount gt 0>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="fnValidarInconsistencias">
			<cfinvokeargument name="FPEEid" value="#ValueList(rsEInc.FPEEid)#">
			<cfinvokeargument name="IrA" value="#form.CurrentPage#">
		</cfinvoke>
	</cfif>
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="fnAprobarI">
			<cfinvokeargument name="CPPid" 	value="#CPPid#">
		</cfinvoke>
		
	</cftransaction>
<cfelseif isdefined('form.EnviarAprobarE')>
	<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
		<cfinvokeargument name="FPEEestado" 	value="4">
		<cfinvokeargument name="Filtro" 		value="CPPid = #CPPid# and FPEEestado = 3">
	</cfinvoke>	
<cfelseif isdefined('form.RegresarE')>
	<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
		<cfinvokeargument name="FPEEestado" 	value="2">
		<cfinvokeargument name="Filtro" 		value="CPPid = #CPPid# and FPEEestado = #form.Estado#">
	</cfinvoke>
<cfelseif isdefined('form.generarFormulacion')>
	<cfinvoke component="sif.Componentes.PRES_Formulacion" method="GeneraPresupuesto" returnvariable="idVersion">
		<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
	</cfinvoke>
<cfelseif isdefined('form.generarVariacion')>
	<cfinvoke component="sif.Componentes.PCG_Traslados" method="fnCrearTablasTemporales">
		<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
		<cfinvokeargument name="FPEEestado" 	value="4">
	</cfinvoke>
	<cfquery dbtype="query" name="rsTraslados">	
		select count(1) cantidad from Request.query
		where IngresosEstimacion -  IngresosPlan <> 0 or EgresosEstimacion - EgresosPlan <> 0
	</cfquery>
	<cftransaction>
		<cfif rsTraslados.recordcount eq 0 or rsTraslados.cantidad eq 0>
			<cfthrow message="No existe movimientos en la estimaciones por lo que no se generaran traslados, debe de existir movimientos para continuar con el proceso, Proceso cancelado.">
		<cfelse>
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="ALTATrasladoMasivo">
				<cfinvokeargument name="CPPid" 			value="#form.CPPid#">
				<cfinvokeargument name="FPEEestado" 	value="4">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
				<cfinvokeargument name="FPEEestado" 	value="5">
				<cfinvokeargument name="Filtro" 		value="CPPid = #form.CPPid# and FPEEestado = 4">
			</cfinvoke>
		</cfif>
	</cftransaction>
<cfelseif isdefined('form.Equilibrio')>
	<cfoutput>
	<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>
	<form name="form1" action="#form.CurrentPage#" method="post">
		<input type="hidden" name="FPEEid" 		value="#form.FPEEid#" />
		<input type="hidden" name="FPEPid" 		value="#form.FPEPid#" />
		<input type="hidden" name="FPDElinea" 	value="#form.FPDElinea#" />
		<input type="hidden" name="tab" 		value="#form.tab#" />
		<input type="hidden" name="Equilibrio" 	value="true" />
	</form>
	<script language="javascript1.2" type="text/javascript">
		document.form1.submit();
	</script>
	</body></html>
	</cfoutput>
</cfif>
<cfif not isdefined('form.Equilibrio')>
<cflocation url="#form.CurrentPage##param#" addtoken="no">
</cfif>