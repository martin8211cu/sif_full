<cfparam name="url.id" default="-1">
<cfif not isdefined('url.id') or not len(trim(url.id))>
	<cfset url.id= -1>
</cfif>
<cfif url.tipo eq 'A'>
	<cfquery datasource="#session.dsn#" name="rsQuery" maxrows="1">
		select  FPCCExigeFecha as valor
			from FPCatConcepto 
		where Ecodigo = #session.Ecodigo#
		  and FPCCconcepto = 'A'
		  and FPCCTablaC = (select a.Ccodigo
			from Articulos a 
				inner join Clasificaciones b
					on a.Ecodigo = b.Ecodigo
					and a.Ccodigo = b.Ccodigo
		where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">)
		order by FPCCid
	</cfquery>
<cfelseif ListFind('S,P',url.tipo)>
	<cfquery datasource="#session.dsn#" name="rsQuery" maxrows="1">
		select FPCCExigeFecha as valor
			from FPCatConcepto 
		where Ecodigo = #session.Ecodigo#
		  and FPCCconcepto in ('S','P')
		  and FPCCTablaC = (select a.CCid
					from Conceptos a 
						inner join CConceptos b
							on a.CCid = b.CCid
				where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">)
		order by FPCCid
	</cfquery>
<cfelseif url.tipo eq 'M'>
	<cfquery datasource="#session.dsn#" name="rsQuery" maxrows="1">
		select  coalesce(FPPAPrecio,0) as valor
		from FPPreciosArticulo
		where Ecodigo = #session.Ecodigo#
			and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPPid#">
			and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		order by FPPAPrecio
	</cfquery>
</cfif>
<cfset rsUnidad.Ucodigo = "">
<cfif isdefined('url.UnidadName') and len(trim(url.UnidadName))>
	<cfif url.tipo eq 'M'>
		<cfquery datasource="#session.dsn#" name="rsUnidad" maxrows="1">
			select Ucodigo
			from Articulos
			where Ecodigo = #session.Ecodigo#
				and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			order by Ucodigo
		</cfquery>
	<cfelseif ListFind('S,P',url.tipo)>
		<cfquery datasource="#session.dsn#" name="rsUnidad" maxrows="1">
			select Ucodigo
			from Conceptos
			where Ecodigo = #session.Ecodigo#
				and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			order by Ucodigo
		</cfquery>
	</cfif>
</cfif>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	<cfif isdefined('url.name') and len(trim(url.name))>
		window.parent.document.#url.form#.#url.name#.value = <cfif len(trim(rsQuery.valor))>"#rsQuery.valor#"<cfelse>"0.00"</cfif>;
	</cfif>
	<cfif isdefined('url.UnidadName') and len(trim(url.UnidadName))>
		if(window.parent.TraeUnidades#UnidadName#)
			window.parent.TraeUnidades#UnidadName#("#trim(rsUnidad.Ucodigo)#");
	</cfif>
	<cfif isdefined('url.funcion') and len(trim(url.funcion))>
	window.parent.#url.funcion#;
	</cfif>
</script>
</cfoutput>
