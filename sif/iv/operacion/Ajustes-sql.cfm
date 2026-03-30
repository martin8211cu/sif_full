<cfset Request.Debug = false>
<cfif isdefined("form.Nuevo")>
	<cflocation url="Ajustes.cfm">
<cfelseif isdefined("form.btnNuevo")>
	<cflocation url="Ajustes.cfm">
<cfelseif isdefined("form.NuevoDet")>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#">
<cfelseif isdefined("form.btnNuevoDet")>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#">
    
<!---►►Aplicación del Ajuste de Inventario◄◄--->
<cfelseif isdefined("form.btnAplicar") or isdefined("form.Aplicar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.EAid")>
		<cfset Cambio()>
		<cfset lista = form.EAid>
	</cfif>
	<cfset arreglo = listtoarray(lista)>
	<cfloop from="1" to="#arraylen(arreglo)#" index="idx">
		<cfinvoke Component="sif.Componentes.IN_AjusteInventario" method="IN_AjusteInventario">
        	<cfinvokeargument name="EAid" 			value="#arreglo[idx]#">
            <cfinvokeargument name="Debug" 		value="#Request.Debug#">
            <cfinvokeargument name="RollBack" 		value="#Request.Debug#">
            <cfinvokeargument name="Ktipo" 			value="A">
        </cfinvoke>
	</cfloop>
	<cfif Request.Debug>
		<cfabort>
	</cfif>
	<cflocation url="Ajustes-lista.cfm">
<cfelseif isdefined("form.Alta")>
	<cftransaction>
	<cfquery name="insert" datasource="#session.dsn#">
		insert into EAjustes ( EAdescripcion, Aid, EAdocumento, EAfecha, EAusuario)
		values ( 
			<cfqueryparam value="#Form.EAdescripcion#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#Form.Aid#" 			 cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#Form.EAdocumento#"   cfsqltype="cf_sql_char">, 
			<cfqueryparam value="#LSParsedateTime(form.EAfecha)#" cfsqltype="cf_sql_timestamp">,
			<cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">
		)
		<cf_dbidentity1 datasource="#session.dsn#">
	</cfquery>
	<cf_dbidentity2 name="insert" datasource="#session.dsn#">
	</cftransaction>
	<cflocation url="Ajustes.cfm?EAid=#insert.identity#">
<cfelseif isdefined("form.Baja")>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete from DAjustes
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from EAjustes
		where EAid    = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	</cftransaction>
	<cflocation url="Ajustes-lista.cfm">
<cfelseif isdefined("form.Cambio")>
	<cfset Cambio()>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#&pagina=#form.pagina#">
<cfelseif isdefined("form.AltaDet")>
	<cfquery datasource="#session.dsn#">
		insert into DAjustes ( EAid, Aid, DAcantidad, DAcosto, DAtipo )
		values ( 
			<cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#Replace(Form.DAcantidad,',','','all')#" cfsqltype="cf_sql_float">,
			<cf_jdbcQuery_param value="#Replace(Form.DAcosto,',','','all')#" cfsqltype="cf_sql_money">,
			<cfqueryparam value="#Form.DAtipo#" cfsqltype="cf_sql_numeric">
		)
	</cfquery>
	<cfset Cambio()>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#&pagina=#form.pagina#">
<cfelseif isdefined("form.CambioDet")>
	<cfquery datasource="#session.dsn#">
		update DAjustes
		set Aid    = <cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">, 
			DAcantidad = <cfqueryparam value="#Replace(Form.DAcantidad,',','','all')#" cfsqltype="cf_sql_float">, 
			DAcosto = <cf_jdbcQuery_param value="#Replace(Form.DAcosto,',','','all')#" cfsqltype="cf_sql_money">, 
			DAtipo = <cfqueryparam value="#Form.DAtipo#" cfsqltype="cf_sql_numeric"> 
		where EAid      = <cfqueryparam value="#Form.EAid#"    cfsqltype="cf_sql_numeric">
		  and DALinea   = <cfqueryparam value="#Form.DALinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#&DALinea=#form.DALinea#&pagina=#form.pagina#">
<cfelseif isdefined("form.BajaDet")>
	<cfquery datasource="#session.dsn#">
		delete from DAjustes
		where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
		  and DALinea = <cfqueryparam value="#Form.DALinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="Ajustes.cfm?EAid=#form.EAid#&pagina=#form.pagina#">
</cfif>
<cffunction access="private" name="Cambio" returntype="boolean">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="EAjustes"
		redirect="Ajustes.cfm"
		timestamp="#form.ts_rversion#"
		field1="EAid" 
		type1="numeric" 
		value1="#form.EAid#">
	<cfquery datasource="#session.dsn#">
		update EAjustes 
		set EAdescripcion = <cfqueryparam value="#Form.EAdescripcion#" cfsqltype="cf_sql_varchar">,
			EAfecha       = <cfqueryparam value="#LSParsedateTime(form.EAfecha)#" cfsqltype="cf_sql_timestamp">,
			Aid           = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">,
			EAdocumento   = <cfqueryparam value="#Form.EAdocumento#" cfsqltype="cf_sql_char">
		where EAid      = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfreturn true>
</cffunction>