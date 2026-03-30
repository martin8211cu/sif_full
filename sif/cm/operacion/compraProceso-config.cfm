<!--- 
En este archivo no se puede asumir que se han establecido ciertos valores
porque existen otros que se cambian en otros archivos cf_include
--->
<cfif not isdefined("Session.Compras.ProcesoCompra")>
	<cfset Session.Compras.ProcesoCompra = StructNew()>
	<cfset Session.Compras.ProcesoCompra.Pantalla = "1">
	<cfset Session.Compras.ProcesoCompra.PrimeraVez = true>
</cfif>

<cfif not isdefined("Session.Compras.ProcesoCompra.Pantalla")>
	<cfset Session.Compras.ProcesoCompra.Pantalla = "1">
</cfif>

<cfif isdefined("Form.opt") and Len(Trim(Form.opt))>
	<cfset Session.Compras.ProcesoCompra.Pantalla = Form.opt>
</cfif>

<cfif Session.Compras.ProcesoCompra.Pantalla EQ "9">
	<cfset form.CMPid = ''>
</cfif>

<cfif isdefined("Form.CMPid") and Len(Trim(Form.CMPid)) and Session.Compras.ProcesoCompra.Pantalla NEQ "0">
	<cfset Session.Compras.ProcesoCompra.CMPid = Form.CMPid>
	<cfquery name="CMP" datasource="#Session.DSN#">
		select CMPestado from CMProcesoCompra 
		where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
	<cfset Session.Compras.ProcesoCompra.CMPestado = CMP.CMPestado>
    <cfif CMP.CMPestado eq 83>
    	<cfset Session.Compras.ProcesoCompra.Pantalla = 0>
        <cfset Form.CMPid = "">
        <cfset Session.Compras.ProcesoCompra.CMPid = "">
    </cfif>
</cfif>

<cfquery name="rsPublica" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and Pcodigo=570
</cfquery>
<cfset PublicarProceso = false>
<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
	<cfset PublicarProceso = true>
</cfif>

<!--- Proveduria Corporativa --->
<cfset lvarProvCorp = false>
<cfset lvarFiltroEcodigo = Session.Ecodigo>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo = #session.Ecodigo#
         and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
    <cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
		<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
    </cfif>
    <cfif isdefined("Form.Ecodigo_f") and Form.Ecodigo_f neq Session.Compras.ProcesoCompra.Ecodigo>
        <cfset Session.Compras.ProcesoCompra.Ecodigo = Form.Ecodigo_f>
        <cfset Session.Compras.ProcesoCompra.DSlinea = "">
    </cfif>
    <cfif isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
   		<cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
	</cfif>
</cfif>

<style type="text/css">
	input.botonUp2 {font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
	input.botonDown2 {font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
</style>
