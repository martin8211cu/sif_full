<cfif isdefined("form.guardar")>
	<cfquery name="existe" datasource="#session.DSN#">
		select 1 as valor
		from RHPreguntasCompetencia
		where RHPCtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPCtipo#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
		  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif existe.recordcount eq 0>
		<cfquery datasource="#session.DSN#">
			insert into RHPreguntasCompetencia( Ecodigo, idcompetencia, RHPCtipo, PPid, PCid, peso, BMUsucodigo, fechaalta )
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif form.RHPCtipo eq 'H'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#"></cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPCtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.peso, ',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update RHPreguntasCompetencia
			set peso = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.peso, ',','','all')#">,
			    idcompetencia = <cfif form.RHPCtipo eq 'H'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#"></cfif>
			where RHPCtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPCtipo#">
			  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
			  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	 		  and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._idcompetencia#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
<cfelseif isdefined("form.eliminar")>
	<cfquery datasource="#session.DSN#">
		delete from RHPreguntasCompetencia
		where RHPCtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPCtipo#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
		  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfset parametros = ''>
<cfif isdefined("form.PPid")>
	<cfset parametros = parametros & "&PPid=#form.PPid#">
</cfif>
<cfif isdefined("form._pagenum")>
	<cfset parametros = parametros & "&PageNum_lista=#form._pagenum#">
</cfif>
<cflocation url="preguntasCompetencia.cfm?PCid=#form.PCid##parametros#">