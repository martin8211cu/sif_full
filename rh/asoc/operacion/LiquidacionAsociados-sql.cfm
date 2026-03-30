<cfset params = "">
<cfif isdefined("btnGenerar")>
	<cfinvoke component="rh.asoc.Componentes.RH_ACLiquidacionAsoc" method="GeneraLiquidacion" returnvariable="ACLid">
		<cfinvokeargument name="ACAid" value="#form.ACAid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
	</cfinvoke>	
	<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "ACLid=" & ACLid>				
<cfelseif isdefined('form.Recalcular')>
	<cfif LEN(TRIM(form.ACLfecha)) EQ 0><cfset form.ACLfecha = Now()></cfif>
	<cfinvoke component="rh.asoc.Componentes.RH_ACLiquidacionAsoc" method="RecalcularLiquidacion" returnvariable="ACLid">
		<cfinvokeargument name="ACLid" value="#form.ACLid#">
		<cfinvokeargument name="ACAid" value="#form.ACAid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="FechaLiq" value="#form.ACLfecha#">
	</cfinvoke>
	<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "ACLid=" & ACLid>
<cfelseif isdefined('form.Aplicar')>
	<cfinvoke component="rh.asoc.Componentes.RH_ACLiquidacionAsoc" method="AplicarLiquidacion" returnvariable="string">
		<cfinvokeargument name="ACAid" value="#form.ACAid#">	
		<cfinvokeargument name="ACLid" value="#form.ACLid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="FechaLiq" value="#form.ACLfecha#">
	</cfinvoke>
	<cflocation url="LiquidacionAsociados-Lista.cfm" >
<cfelseif isdefined('form.Baja')>
	<!--- ELIMINA EL DETALLE DE LA LIQUIDACION --->
	<cfquery name="DeleteDetalle" datasource="#session.DSN#">
		delete from ACDLiquidacion
		where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACLid#">
	</cfquery>
	<cfquery name="DeleteEncab" datasource="#session.DSN#">
		delete from ACLiquidacion
		where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACLid#">
	</cfquery>
	<cflocation url="LiquidacionAsociados-Lista.cfm" >
</cfif>
<cflocation url="LiquidacionAsociados.cfm#params#">