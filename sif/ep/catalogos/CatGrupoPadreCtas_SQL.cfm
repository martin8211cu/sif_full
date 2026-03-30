
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select EPGcodigo from CGGrupoPadreCtas
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_char">
		and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			insert into CGGrupoPadreCtas(ID_Estr, Ecodigo,EPGcodigo,EPGdescripcion,EPCPnota,EPTipoAplica,ID_Grupo_Ref,  EPCPcodigoref,BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.EPGcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPGdescripcion)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPCPnota)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
                    <!--- <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">, --->
                    <cfif Form.selgrupo NEQ "">
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.selgrupo#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
                     <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
	<cfelse>
		<cfthrow message="El código del grupo ya éxiste">
	</cfif>

<cfelseif isdefined("Form.Baja")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CGGrupoCtasMayor
				set ID_GrupoPadre = null
				where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
				and ID_GrupoPadre in (select ID_GrupoPadre from CGGrupoPadreCtas where EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CGGrupoPadreCtas
				set ID_Grupo_Ref = null
				where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
				and ID_Grupo_Ref in (select ID_GrupoPadre from CGGrupoPadreCtas where EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_varchar">)
		</cfquery>

		<cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from CGGrupoPadreCtas
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EPGcodigo = <cfqueryparam value="#Form.EPGcodigo#" cfsqltype="cf_sql_varchar">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
		</cfquery>

<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="CGGrupoPadreCtas"
		redirect="CatGrupoPadreCtas-form.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="ID_GrupoPadre"
		type2="integer"
		value2="#form.ID_Grupo#"
		field3="ID_Estr"
		type3="integer"
		value3="#form.ID_Estr#">

	<cfquery name="Transacciones" datasource="#Session.DSN#">
		update CGGrupoPadreCtas set
			EPGdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPGdescripcion#">)),
			EPCPnota = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.EPCPnota)#">,
            EPTipoAplica = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
            EPCPcodigoref = <cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
            <!--- EPCPnota = <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">, --->
			<cfif Form.selgrupo NEQ "">
				ID_Grupo_Ref = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.selgrupo#">,
			<cfelse>
				ID_Grupo_Ref = null,
			</cfif>
            BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
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

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=6">

<cflocation url="CuentasEstrProg.cfm?#params#">