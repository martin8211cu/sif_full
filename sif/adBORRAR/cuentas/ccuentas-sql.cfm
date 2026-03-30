<cfif isdefined("form.eAgregar")>
	<cfquery name="e_insert" datasource="asp">
		insert into WTContable (WECdescripcion, WTCmascara, WECtexto)
		values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WECdescripcion#">,
		  		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WTCmascara#">, 
				 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.WECtexto#"> )
			<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="e_insert">
	<cfset form.WTCid = e_insert.identity>
<cfelseif isdefined("form.dAgregar") >
	<cfquery name="d_insert" datasource="asp">
		insert into WEContable( WTCid, Ctipo, Cbalancen, Cformato, Cdescripcion, CdescripcionF, Cmovimiento, Cbalancenormal )
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ctipo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cbalancen#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">,
				 <cfif len(trim(form.CdescripcionF)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CdescripcionF#"><cfelse>null</cfif>,
				 'S',
				 <cfif isdefined("form.Cbalancen") and form.Cbalancen EQ 'D'>1<cfelse>-1</cfif>
		       )
	</cfquery>

	<cfquery name="e_update" datasource="asp">
		update WTContable
		set WECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WECdescripcion#">, 
			WTCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WTCmascara#">, 
			WECtexto = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.WECtexto#">
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>

<cfelseif isdefined("form.Modificar") >
	<cfquery name="e_update" datasource="asp">
		update WTContable
		set WECdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WECdescripcion#">, 
			WTCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.WTCmascara#">, 
			WECtexto = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.WECtexto#">
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>

	<cfquery name="d_update" datasource="asp">
		update WEContable
		set Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">,
			Cbalancen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cbalancen#">,
			Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ctipo#">,
			Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">, 
		    CdescripcionF = <cfif len(trim(form.CdescripcionF)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CdescripcionF#"><cfelse>null</cfif>,
			Cbalancenormal = <cfif isdefined("form.Cbalancen") and form.Cbalancen EQ 'D'>1<cfelse>-1</cfif>
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>

<cfelseif isdefined("form.eEliminar") >
	<cfquery name="e_delete" datasource="asp">
		delete from WEContable
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">

		delete from WTContable
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	</cfquery>

<cfelseif isdefined("form.dEliminar") >
	<cfquery name="e_delete" datasource="asp">
		delete from WEContable
		where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
		  and WECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WECid#">
	</cfquery>

</cfif>

<cfif isdefined("form.lista") or isdefined("form.eEliminar")>
	<cflocation url="listaCatalogos.cfm">
</cfif>

<cfset params = '' >
<cfif isdefined("form.WTCid")>
	<cfset params = params & "&WTCid=#form.WTCid#">
</cfif>
<cflocation url="ccuentas.cfm?1=1#params#">
