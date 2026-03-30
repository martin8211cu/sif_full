<cfif isdefined("form.Nuevo")>
	<cflocation url="PRJPproducto.cfm">
<cfelseif isdefined("form.btnNuevo")>
	<cflocation url="PRJPproducto.cfm">
<cfelseif isdefined("form.NuevoDet")>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#">
<cfelseif isdefined("form.btnNuevoDet")>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#">
<!--- 

<cfelseif isdefined("form.btnAplicar") or isdefined("form.Aplicar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.PRJPPid")>
		<cfset Cambio()>
		<cfset lista = form.PRJPPid>
	</cfif>
	<cfset arreglo = listtoarray(lista)>
	<cfloop from="1" to="#arraylen(arreglo)#" index="idx">
		<cfinvoke Component="sif.Componentes.IN_AjusteInventario"
			method="IN_AjusteInventario"
			EAid="#arreglo[idx]#"
			Debug = "#Request.Debug#"
			RollBack = "#Request.Debug#"/> 
	</cfloop>
	<cflocation url="Ajustes-lista.cfm">--->
	
	
<cfelseif isdefined("form.Alta")>

	<cftransaction>
	<cfquery name="insert" datasource="#session.dsn#">
		insert into PRJPproducto ( Ecodigo, 	      PRJPPcodigo, 		        PRJPPdescripcion, 
								   Ucodigo, 	      PRJPPfechaIni,            PRJPPfechaFin, 
								   PRJPPcostoDirecto, PRJPPporcentajeIndirecto, BMUsucodigo)
		values ( 
			<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#Form.PRJPPcodigo#" cfsqltype="cf_sql_char">,
			<cfqueryparam value="#Form.PRJPPdescripcion#" cfsqltype="cf_sql_char">, 
			<cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_char">, 
			<cfqueryparam value="#LSParsedateTime(Form.PRJPPfechainicial)#" cfsqltype="cf_sql_timestamp">, 
			<cfqueryparam value="#LSParsedateTime(Form.PRJPPfechafinal)#" cfsqltype="cf_sql_timestamp">,
			<cfqueryparam value="#Form.PRJPPcostoDirecto#" cfsqltype="cf_sql_money">,
			<cfqueryparam value="#Form.PRJPPporcentajeind#" cfsqltype="cf_sql_float">,
			<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">						
		)
		<cf_dbidentity1 datasource="#session.dsn#">
	</cfquery>
	<cf_dbidentity2 name="insert" datasource="#session.dsn#">
	</cftransaction>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#insert.identity#&Ucodigo=#form.Ucodigo#">
	
<cfelseif isdefined("form.Baja")>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete PRJPproductoInsumos
		where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete PRJPproducto
		where PRJPPid    = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	</cftransaction>
	<cflocation url="PRJPproducto.cfm">
	
<cfelseif isdefined("form.Cambio")>
	<cfset Cambio()>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#&Ucodigo=#form.Ucodigo#&pagina=#form.pagina#">

<cfelseif isdefined("form.AltaDet")>
	<!--- 
	<cfoutput>
	<script>alert("#Replace(Form.PRJPIcantidad,',','','all')#")</script>
	</cfoutput>
	--->
	<cfquery datasource="#session.dsn#" name="Verifica">
	Select count(1) as total
	from PRJPproductoInsumos
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	  and PRJRid  = <cfqueryparam value="#Form.PRJRid1#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif Verifica.total eq 0>
	
		<cfquery datasource="#session.dsn#">
			insert into PRJPproductoInsumos ( Ecodigo, 
											  PRJPPid, 
											  PRJRid, 
											  PRJPIcostoUnitario, 
											  PRJPIcantidad, 
											  BMUsucodigo )
			values ( 
				<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,			
				<cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Form.PRJRid1#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Replace(Form.PRJPIcostoUnitario,',','','all')#" cfsqltype="cf_sql_money">,
				<cfqueryparam value="#Replace(Form.PRJPIcantidad,',','','all')#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Session.usucodigo#" cfsqltype="cf_sql_numeric">)
	
		</cfquery>
		<cfset Cambio()>
	
	<cfelse>
		<script>alert("El Insumo que desea agregar ya existe")</script>
	</cfif>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#&Ucodigo=#form.Ucodigo#&pagina=#form.pagina#">
	 
<cfelseif isdefined("form.CambioDet")>

	<cfif isdefined("form.PRJRid1") and len(form.PRJRid1) and not isdefined("form.PRJRid")>
		<cfset form.PRJRid = form.PRJRid1>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update PRJPproductoInsumos
		set PRJPIcostoUnitario = <cfqueryparam value="#Replace(Form.PRJPIcostoUnitario,',','','all')#" cfsqltype="cf_sql_money">, 
			PRJPIcantidad = <cfqueryparam value="#Replace(Form.PRJPIcantidad,',','','all')#" cfsqltype="cf_sql_numeric">			
		where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
		  and PRJRid = <cfqueryparam value="#Form.PRJRid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#&PRJRid=#form.PRJRid#&Ucodigo=#form.Ucodigo#&pagina=#form.pagina#">

<cfelseif isdefined("form.BajaDet")>

	<cfif isdefined("form.PRJRid1") and len(form.PRJRid1) and not isdefined("form.PRJRid")>
		<cfset form.PRJRid = form.PRJRid1>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		delete PRJPproductoInsumos
		where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
		  and PRJRid = <cfqueryparam value="#Form.PRJRid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="PRJPproducto.cfm?PRJPPid=#form.PRJPPid#&Ucodigo=#form.Ucodigo#&pagina=#form.pagina#">

</cfif>

<cffunction access="private" name="Cambio" returntype="boolean">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PRJPproducto"
		redirect="PRJPproducto.cfm"
		timestamp="#form.ts_rversion#"
		field1="PRJPPid"
		type1="numeric"
		value1="#form.PRJPPid#">

	<cfquery datasource="#session.dsn#" name="calculacosto">
	Select coalesce(sum(PRJPIcostoUnitario * PRJPIcantidad), 0) as total
	from PRJPproductoInsumos
	where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset calculado = calculacosto.total>	

	<cfquery datasource="#session.dsn#">
		update PRJPproducto
		set 			
			PRJPPcodigo = <cfqueryparam value="#PRJPPcodigo#" cfsqltype="cf_sql_char">,
			PRJPPdescripcion = <cfqueryparam value="#PRJPPdescripcion#" cfsqltype="cf_sql_char">,
			PRJPPfechaIni = <cfqueryparam value="#LSParsedateTime(PRJPPfechainicial)#" cfsqltype="cf_sql_timestamp">,
			PRJPPfechaFin = <cfqueryparam value="#LSParsedateTime(PRJPPfechafinal)#" cfsqltype="cf_sql_timestamp">,
			PRJPPcostoDirecto = <cfqueryparam value="#calculado#" cfsqltype="cf_sql_money">,
			PRJPPporcentajeIndirecto = <cfqueryparam value="#PRJPPporcentajeind#" cfsqltype="cf_sql_float">,
			Ucodigo = <cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_char">
		where PRJPPid = <cfqueryparam value="#Form.PRJPPid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfreturn true>
</cffunction>
