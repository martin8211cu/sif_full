<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAP002"
		redirect="monedas_facturacion.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FAP02CON"
		type1="numeric"
		value1="#form.FAP02CON#" >
				
	<cfquery name="update" datasource="#session.DSN#">
		update FAP002 
		set Mcodigo= <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
		FAP02FAC = <cfif isdefined('form.FAP02FAC')>1,<cfelse>0,</cfif>
		FAP02COB = <cfif isdefined('form.FAP02COB')>1,<cfelse>0,</cfif>
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAP02CON = <cfqueryparam value="#form.FAP02CON#" cfsqltype="cf_sql_numeric">
	 </cfquery> 

	<cflocation url="monedas_facturacion.cfm?FAP02CON=#form.FAP02CON#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAP002
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and FAP02CON = <cfqueryparam value="#form.FAP02CON#" cfsqltype="cf_sql_numeric">
	</cfquery>
 	
<cfelseif IsDefined("form.Alta")>
	<cfquery name="Verifica" datasource="#session.DSN#">
		select FAP02CON
		from FAP002
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
		
	<!----- si  no existe la moneda para esta empresa--->	
	<cfif IsDefined('Verifica') and Verifica.recordcount EQ 0>
		<cfquery datasource="#session.dsn#">
			insert into FAP002( Ecodigo, Mcodigo, FAP02FAC, FAP02COB, BMUsucodigo, fechaalta )
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
					<cfif isdefined('form.FAP02FAC')>
						1,
					<cfelse>
						0,
					</cfif>
					<cfif isdefined('form.FAP02COB')>
						1,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
			</cfquery>			
	<cfelse>
		<cf_errorCode	code = "50568" msg = "Esta moneda ya existe">
	</cfif>		
</cfif>

<cflocation url="monedas_facturacion.cfm">

