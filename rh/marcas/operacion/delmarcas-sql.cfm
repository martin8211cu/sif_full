<cfset FormParams = "">
<cfloop list="#Form.FieldNames#" index="i">
	<cfif FindNocase('Filtro_',i) and isdefined("Form.#i#")>
		<cfset FormParams = listAppend(FormParams,"#i#="&Evaluate("Form.#i#"),"&")>
	</cfif>
</cfloop>
<cfif Isdefined("Form.btneliminar") and isdefined("Form.chk") and ListLen(Form.chk) GT 0>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			insert into HRHControlMarcas (RHCMid, Ecodigo, DEid, RHASid, fechahorareloj, tipomarca, justificacion, registroaut, fechahoraautorizado, usuarioautor, fechahoramarca, regprocesado, RHJid, RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, numlote, canthoras, grupomarcas, BMUsucodigo, BMfecha)
			select RHCMid, Ecodigo, DEid, RHASid, fechahorareloj, tipomarca, justificacion, registroaut, fechahoraautorizado, usuarioautor, fechahoramarca, regprocesado, RHJid, RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, numlote, canthoras, grupomarcas, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from RHControlMarcas
			where <cf_WhereInList column="RHCMid" ValueList="#Form.chk#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			set grupomarcas = null
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and exists (
				select grupomarcas
				from RHControlMarcas b
				where <cf_WhereInList column="RHCMid" ValueList="#Form.chk#" cfsqltype="cf_sql_numeric">
				and b.grupomarcas = RHControlMarcas.grupomarcas
			)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from RHControlMarcas
			where <cf_WhereInList column="RHCMid" ValueList="#Form.chk#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cftransaction>
</cfif>
<cflocation url="delmarcas.cfm?#FormParams#">