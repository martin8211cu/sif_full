<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfset filtro = '' >
	<cfif isdefined("url.financiada") and url.financiada eq 1>
		<cfset filtro = " and a.TDfinanciada=1" >
	</cfif>

	<cfif isdefined("Url.val") and Url.val EQ 1>
		<cfquery name="rs" datasource="#url.conexion#">
			select a.TDid, rtrim(ltrim(a.TDcodigo)) as TDcodigo, a.TDdescripcion
			from TDeduccion a
			inner join RHUsuarioTDeduccion b
			  on a.TDid = b.TDid
			  and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
  			  and rtrim(ltrim(upper(a.TDcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			  and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			  #filtro#
			union
			select a.TDid, rtrim(ltrim(a.TDcodigo)) as TDcodigo, a.TDdescripcion
			from TDeduccion a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			#filtro#
			and rtrim(ltrim(upper(a.TDcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			and not exists (
				select 1 from RHUsuarioTDeduccion b where b.TDid = a.TDid and b.Ecodigo = a.Ecodigo
			)
		</cfquery>
		<!---
		 <cfquery name="rs" datasource="#url.conexion#">
			select a.TDid, rtrim(ltrim(a.TDcodigo)) as TDcodigo, a.TDdescripcion
			from TDeduccion a, RHUsuarioTDeduccion b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			and rtrim(ltrim(upper(a.TDcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			and a.TDid = b.TDid
			and a.Ecodigo = b.Ecodigo
			and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			#filtro#
			union
			select a.TDid, rtrim(ltrim(a.TDcodigo)) as TDcodigo, a.TDdescripcion
			from TDeduccion a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			#filtro#
			and rtrim(ltrim(upper(a.TDcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			and not exists (
				select 1 from RHUsuarioTDeduccion b where b.TDid = a.TDid and b.Ecodigo = a.Ecodigo
			)
		</cfquery>
		 --->
	<cfelse>
		<cfquery name="rs" datasource="#url.conexion#">
			select a.TDid, rtrim(ltrim(a.TDcodigo)) as TDcodigo, a.TDdescripcion
			from TDeduccion a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			and rtrim(ltrim(upper(a.TDcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		</cfquery>
	</cfif>
	<script language="JavaScript">
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.TDid#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.TDcodigo)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.TDdescripcion)#</cfoutput>";
		if (window.parent.func<cfoutput>#trim(Url.id)#</cfoutput>) {window.parent.func<cfoutput>#trim(Url.id)#</cfoutput>();}		
	</script>
</cfif>
