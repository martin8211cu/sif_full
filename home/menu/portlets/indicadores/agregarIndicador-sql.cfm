<cfif isdefined("form.btnAgregar") or isdefined("form.btnModificar")>
	<cfset LvarCFid = '' >
	<cfset LvarOcodigo = '' >
	<cfset LvarDcodigo = '' >

	<cfif form.filtro_of eq 's'>
		<cfset LvarOcodigo = form.Ocodigo >
	<cfelseif form.filtro_of eq 'f'>
		<cfset LvarOcodigo = form._Ocodigo >
	</cfif>

	<cfif form.filtro_cf eq 's'>
		<cfset LvarCFid = form.CFid >
	<cfelseif form.filtro_cf eq 'f'>
		<cfset LvarCFid = form._CFid >
	</cfif>

	<cfif form.filtro_depto eq 's'>
		<cfset LvarDcodigo = form.Dcodigo >
	<cfelseif form.filtro_depto eq 'f'>
		<cfset LvarDcodigo = form._Dcodigo >
	</cfif>

	<cfif len(trim(form.posicion)) eq 0 >
		<cfset LvarPos = 10 >
		<cfquery name="pos" datasource="asp">
			select coalesce(max(posicion),0) as posicion
			from IndicadorUsuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfquery>
		<cfif pos.recordCount gt 0>
			<cfset LvarPos = pos.posicion + 10 >
		</cfif>
	<cfelse>
		<cfset LvarPos = form.posicion >
	</cfif>
</cfif>	

<cfif isdefined("form.btnCancelar")>
	<cflocation url="personalizar.cfm">

<cfelseif isdefined("form.btnAgregar")>
	<cfquery datasource="asp">
		insert into IndicadorUsuario( Usucodigo, Ecodigo, indicador, posicion, Ocodigo, Dcodigo, CFid, BMfecha, BMUsucodigo )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPos#">,
				<cfif len(trim(LvarOcodigo)) and form.filtro_cf neq 'n' ><cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOcodigo#"><cfelse>null</cfif>,
				<cfif len(trim(LvarDcodigo)) and form.filtro_depto neq 'n' ><cfqueryparam cfsqltype="cf_sql_integer" value="#LvarDcodigo#"><cfelse>null</cfif>,
				<cfif len(trim(LvarCFid)) and form.filtro_cf neq 'n' ><cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCFid#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
	</cfquery>
	
<cfelseif isdefined("form.btnModificar")>	
	<cfquery datasource="asp">
		update IndicadorUsuario
		set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPos#">,
			Ocodigo = <cfif form.filtro_of eq 's' and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#"><cfelse>null</cfif>,
			Dcodigo = <cfif form.filtro_depto eq 's' and len(trim(form.Dcodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#"><cfelse>null</cfif>,
			CFid = <cfif form.filtro_cf eq 's' and len(trim(form.CFid))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#"><cfelse>null</cfif>
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
	</cfquery>
</cfif>

<!--- resecuenciar --->
<cfif isdefined("form.btnAgregar") or isdefined("form.btnModificar")>
	<cfquery name="data" datasource="asp">
		select indicador, posicion
		from IndicadorUsuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		order by posicion  
	</cfquery>
	<cfset LvarPos = 10 >
	<cfoutput query="data">
		<cfif LvarPos neq data.posicion>
			<cfquery datasource="asp">
				update IndicadorUsuario
				set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPos#">
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			  	  and indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data.indicador)#">
			</cfquery>
		</cfif>
		<cfset LvarPos = LvarPos + 10 >
	</cfoutput>

</cfif>

<cflocation url="personalizar.cfm">