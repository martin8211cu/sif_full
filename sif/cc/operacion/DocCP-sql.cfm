<cfset params = "">
<cfif isdefined("form.Altacxp")>
	<cftry>
	<cfquery name="rsInsert" datasource="#session.dsn#">
		insert into DocCompensacionDCxP (idDocCompensacion, idDocumento, CPTcodigo, Ddocumento, BMUsucodigo, Dmonto, DmontoRet)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumento#">,
			   <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">,
			   <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			   <cfif isdefined("form.DmontoDocCxP")>
				   <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxP,",","","ALL") - replace(form.DmontoRetCxP,",","","ALL")#">,
				   <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxP,",","","ALL")#">
			   <cfelse>
	               	<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Dmonto,",","","ALL")#">,
				   0
			   </cfif>)
	</cfquery>
		<cfcatch type = "Database">
			<!--- TODO --->
		</cfcatch>
	</cftry>
<cfelseif isdefined("form.Cambiocxp")>
	<cfquery datasource="#session.dsn#">
		update DocCompensacionDCxP
		set CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">
			, Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.HDdocumento#">
			, idDocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumento#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif isdefined("DmontoDocCxP")>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxP,",","","ALL") - replace(form.DmontoRetCxP,",","","ALL")#">
				, DmontoRet	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxP,",","","ALL")#">
			<cfelse>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#">
				, DmontoRet	= 0
			</cfif>
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
<cfelseif isdefined("form.Bajacxp")>
	<cfquery datasource="#session.dsn#">
		delete from DocCompensacionDCxP
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
</cfif>
<cfquery datasource="#session.dsn#">
	UPDATE DocCompensacion
	SET Dmonto = coalesce((SELECT sum(a.Dmonto * CASE WHEN b.CCTtipo = 'D' THEN 1 ELSE -1 END)
	                         FROM DocCompensacionDCxC a, CCTransacciones b
	                         WHERE a.idDocCompensacion = DocCompensacion.idDocCompensacion
	                           AND b.CCTcodigo = a.CCTcodigo
	                           AND b.Ecodigo = a.Ecodigo), 0.00)
	                       + coalesce((SELECT sum(a.Dmonto * CASE WHEN b.CPTtipo = 'D' THEN 1 ELSE -1 END)
    FROM DocCompensacionDCxP a, EDocumentosCP d, CPTransacciones b
    WHERE a.idDocCompensacion = DocCompensacion.idDocCompensacion
      AND d.IDdocumento = a.idDocumento
      AND b.Ecodigo = d.Ecodigo
      AND b.CPTcodigo = d.CPTcodigo), 0.00)
	WHERE idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cflocation url="compensacionDocsCC-form.cfm?idDocCompensacion=#form.idDocCompensacion##params#">
