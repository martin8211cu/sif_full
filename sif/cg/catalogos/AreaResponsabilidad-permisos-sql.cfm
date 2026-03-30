<cfset modo = "ALTA">

<!-----Modo alta---->
<cfif isdefined("Form.Alta")>	
	<cftransaction>				
		<cfquery datasource="#session.dsn#">
			insert into CGPermisosAreaResp( CGARid, Usucodigo, Ecodigo, BMUsucodigo, BMfechaalta )
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGARid#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
		</cfquery>					
	</cftransaction>
	
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from CGPermisosAreaResp 
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">
		  and CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGARid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
</cfif>

<cfset Form.tab = 3>
<cflocation url="AreaResponsabilidad.cfm?tab=3&CGARid=#form.CGARid#">