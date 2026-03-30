
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select EPGcodigo from CGGrupoCtasMayor
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_char">
		and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into CGGrupoCtasMayor(ID_Estr, Ecodigo,EPGcodigo,EPGdescripcion,EPTipoAplica, EPCPnota, EPCPcodigoref,BMUsucodigo
				<cfif Form.GrupoAplica1 NEQ "" or Form.GrupoAplica2 NEQ "" >,ID_GrupoPadre</cfif>)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPGcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPGdescripcion)#">,
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
                     <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">,
                     <cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					 <cfif Form.GrupoAplica1 NEQ "" or Form.GrupoAplica2 NEQ "" >
						<cfif Form.Tipoaplica EQ "1" >
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GrupoAplica1#">
						<cfelse>
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GrupoAplica2#">
						</cfif>
					 </cfif>
					)
		</cfquery>
	<cfelse>
		<cfthrow message="El código del grupo ya éxiste">
	</cfif>

<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select m.ID_Estr,m.ID_Grupo,m.CGEPCtaMayor from CGEstrProgCtaM m
        where m.ID_Estr=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
        and m.ID_Grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Grupo#">
	</cfquery>
	<cfif rsExiste.RecordCount eq 0>
		 <cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from CGGrupoCtasMayor
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_char">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
		</cfquery>
	<cfelse>
		<cfthrow message="Existen cuentas de mayor ligadas al grupo">
	</cfif>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="CGGrupoCtasMayor"
		redirect="CatGrupoCtasMayor-form.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="ID_Grupo"
		type2="integer"
		value2="#form.ID_Grupo#"
		field3="ID_Estr"
		type3="integer"
		value3="#form.ID_Estr#">

	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update CGGrupoCtasMayor set
			EPGdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPGdescripcion#">)),
            EPTipoAplica = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
            EPCPcodigoref = <cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
            EPCPnota = <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">,
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			<cfif Form.GrupoAplica1 NEQ "" or Form.GrupoAplica2 NEQ "" >
				<cfif Form.Tipoaplica EQ "1" >
					,ID_GrupoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GrupoAplica1#">
				<cfelse>
					,ID_GrupoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GrupoAplica2#">
				</cfif>
			<cfelse>
				,ID_GrupoPadre = null
			</cfif>
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_char">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>

</cfif>

<cfset params = "">

<cfif isdefined("form.ID_Grupo")>
	<cfset params=params&"&ID_Grupo="&form.ID_Grupo>
</cfif>
<cfif isdefined("form.ID_Estr")>
	<cfset params=params&"&fID_Estr="&form.ID_Estr>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=1">

<cflocation url="CuentasEstrProg.cfm?#params#">