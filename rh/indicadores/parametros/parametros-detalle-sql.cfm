<cfif isdefined("form.ALTA")>

	<cfset v_existe = false >	
	<cfif form.RHIDtipo eq 'C'>
		<cfquery datasource="#session.DSN#" name="rs_existe">
			select RHIDllave
			from RHIndicadoresDetalle
			where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
			  and RHIDllave = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#" >
			  and RHIDtipo = 'C'
		</cfquery>
		<cfif len(trim(rs_existe.RHIDllave))>
			<cfset v_existe = true >
		</cfif>
	</cfif>

	<cfif not v_existe>
		<cfquery datasource="#session.DSN#">
			insert into RHIndicadoresDetalle( RHIcodigo, RHIDtipo, RHIDcolumna, RHIDllave, BMUsucodigo, BMfecha )
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHIDtipo#">,
					 1,
					  <cfif form.RHIDtipo eq 'A'>
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#" >,
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#" >,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			 )
		</cfquery>
	</cfif>
<cfelseif isdefined("form.RHIDid") and len(trim(form.RHIDid))>
	<cfquery datasource="#session.DSN#">
		delete from RHIndicadoresDetalle
		where RHIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIdid#">
	</cfquery>
</cfif>
<cflocation url="parametros.cfm?RHIcodigo=#form.RHIcodigo#">