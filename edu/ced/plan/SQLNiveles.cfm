<cfset params="">
<cfset pagina="1">
<cfif isdefined("Form.Alta")>
	<cfquery name="rsValida" datasource="#Session.Edu.DSN#">
		select 1 from Nivel 
		where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
		  and Ndescripcion = <cfqueryparam value="#Form.Ndescripcion#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif rsValida.recordcount gt 0>
		<cfthrow message="Error, EL Código ya existe, Proceso Cancelado"/>
	</cfif>
	<cfquery name="rsNorden" datasource="#Session.Edu.DSN#">
		select isnull(max(Norden),0)+10 as Norden
		from Nivel 
		where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
		insert into Nivel (CEcodigo, Ndescripcion, Nnotaminima, Norden )
		values(
			<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#Form.Ndescripcion#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#Form.Nnotaminima#" cfsqltype="cf_sql_smallint">,
			<cfif len(trim(#Form.Norden#)) NEQ 0 >
				<cfqueryparam value="#Form.Norden#" cfsqltype="cf_sql_smallint" >
			<cfelse>
				<cfqueryparam value="#rsNorden.Norden#" cfsqltype="cf_sql_smallint" >
			</cfif>
			)
		<cf_dbidentity1 conexion="#Session.Edu.DSN#">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsInsert">
	</cftransaction>
	<cfquery name="rsPagina" datasource="#Session.Edu.DSN#">
		SELECT count(1) as Cont
		FROM Nivel
		WHERE CEcodigo = #Session.Edu.CEcodigo#
	</cfquery>
	<cfset pagina = Ceiling(rsPagina.Cont / form.MaxRows)>
	<cfset params = params&"&Ncodigo="&rsInsert.identity>
<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsValida" datasource="#Session.Edu.DSN#">
		select 1 from Grado 
		where Ncodigo =  <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsValida.recordcount gt 0>
		<cfthrow message="Error, Existen Grados con ese Nivel, Proceso Cancelado"/>
	</cfif>
	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		delete from PeriodoVigente
		where Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	
		delete from Nivel
		where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset pagina = form.Pagina>
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsNorden" datasource="#Session.Edu.DSN#">
		select isnull(max(Norden),0)+10 as Norden
		from Nivel 
		where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
		update Nivel set
			Ndescripcion = <cfqueryparam value="#Form.Ndescripcion#" cfsqltype="cf_sql_varchar">,
			Nnotaminima = <cfqueryparam value="#Form.Nnotaminima#" cfsqltype="cf_sql_smallint">,
			<cfif len(trim(#Form.Norden#)) NEQ 0 >
				Norden = <cfqueryparam value="#Form.Norden#" cfsqltype="cf_sql_smallint" >
			<cfelse>
				Norden = <cfqueryparam value="#rsNorden.Norden#" cfsqltype="cf_sql_smallint" >
			</cfif>
		where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
		  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset pagina = form.Pagina>
	<cfset params=params&"&Ncodigo="&Form.Ncodigo>
</cfif>
<cflocation url="Nivel.cfm?Pagina=#pagina#&Filtro_Ndescripcion=#Form.Filtro_Ndescripcion#&Filtro_Nnotaminima=#Form.Filtro_Nnotaminima#&Filtro_Norden=#Form.Filtro_Norden#&HFiltro_Ndescripcion=#Form.Filtro_Ndescripcion#&HFiltro_Nnotaminima=#Form.Filtro_Nnotaminima#&HFiltro_Norden=#Form.Filtro_Norden##params#">