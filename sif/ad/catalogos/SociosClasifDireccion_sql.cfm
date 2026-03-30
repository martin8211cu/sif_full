<cfinclude template="SociosModalidad.cfm">
<cfparam name="form.clax2" default="">

<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete from SNClasificacionSND
		where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
		and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
		<cfif session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>
		  and SNCDid in (
						select SNCDid
						from SNClasificacionE e
							inner join SNClasificacionD d
								on e.SNCEid = d.SNCEid
						where e.SNCEcorporativo = 0 )
		</cfif>
	</cfquery>
	<cfloop list="#form.clax2#" index="j">
		<cfif Len(j) and session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>
			<cfquery datasource="#session.dsn#" name="corp">
			  select SNCEcorporativo
			  from SNClasificacionE e
				join SNClasificacionD d
					on e.SNCEid = d.SNCEid
				where d.SNCDid = #j#
			</cfquery>
			<cfif corp.SNCEcorporativo EQ 1>
				<cfset j = ''>
			</cfif>
		</cfif>
		
		<cfif Len(j)>
			<cfquery datasource="#session.dsn#">
				insert into SNClasificacionSND (id_direccion, SNid, SNCDid, BMUsucodigo)
					select
						id_direccion,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#"> as SNid,
					#j# as SNCDid,
					0 as BMUsucodigo
					from SNDirecciones
					where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
					and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">					
			</cfquery>
		</cfif>
	</cfloop>
</cftransaction>

<cfoutput>
	<cfif isdefined("form.SNDcodigo")>
		<cflocation url="SociosDirecciones_form.cfm?SNcodigo=#form.SNcodigo#&tab=8&tabs=1&id_direccion=#form.id_direccion#">
	<cfelseif isdefined ("form.clax2") and len(trim(form.clax2))>
		<cflocation url="SociosDirecciones_form.cfm?SNcodigo=#form.SNcodigo#&tab=8&tabs=2&id_direccion=#form.id_direccion#">
	</cfif>
</cfoutput>