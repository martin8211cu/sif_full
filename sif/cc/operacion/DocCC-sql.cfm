
<cfset params = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset params = params & "&Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset params = params & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset params = params & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>
<cfif isdefined("form.Altacxc")>
	<cftry>
	<cfquery name="rsInsert" datasource="#session.dsn#">
		insert into DocCompensacionDCxC(idDocCompensacion, Ecodigo, CCTcodigo, Ddocumento, BMUsucodigo,Dmonto, DmontoRet)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">,
		       <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		       <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
		       <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">,
		       <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		       <cfif isdefined("form.DmontoDocCxC")>
			       <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxC,",","","ALL") - replace(form.DmontoRetCxC,",","","ALL")#">,
			       <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxC,",","","ALL")#">
			   <cfelse>
			   		<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Dmonto,",","","ALL")#">,
					0
			   </cfif>)
	</cfquery>
		<cfcatch type = "Database">
			<!--- TODO --->
		</cfcatch>
	</cftry>
<cfelseif isdefined("form.Cambiocxc")><cfdump var="#form#">
	<cfquery datasource="#session.dsn#">
		update DocCompensacionDCxC
		set CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
			, Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.HDdocumento#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif isdefined("DmontoDocCxC")>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxC,",","","ALL") - replace(form.DmontoRetCxC,",","","ALL")#">
				, DmontoRet	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxC,",","","ALL")#">
			<cfelse>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#">
				, DmontoRet	= 0
			</cfif>
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif isdefined("form.Bajacxc")>
	<cfquery datasource="#session.dsn#">
		delete from DocCompensacionDCxC
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
<cfquery datasource="#session.dsn#">
	update DocCompensacion
	set Dmonto =
		coalesce(
				(select sum(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end)
				from DocCompensacionDCxC a, CCTransacciones b
				where a.idDocCompensacion = DocCompensacion.idDocCompensacion
					and b.CCTcodigo = a.CCTcodigo
					and b.Ecodigo = a.Ecodigo), 0.00)
		+
		coalesce(
				(select sum(a.Dmonto * case when b.CPTtipo = 'D' then 1 else -1 end)
				from DocCompensacionDCxP a, EDocumentosCP d, CPTransacciones b
				where a.idDocCompensacion = DocCompensacion.idDocCompensacion
					and d.IDdocumento = a.idDocumento
					and b.Ecodigo = d.Ecodigo
					and b.CPTcodigo = d.CPTcodigo), 0.00)
	where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cflocation url="compensacionDocsCC-form.cfm?idDocCompensacion=#form.idDocCompensacion##params#">