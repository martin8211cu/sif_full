<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select ACCTid,ACCTcodigo, ACCTdescripcion, ACCTplazo, ACCTtasa, ACCTtasaMora, ACCTmodificable 
		from ACCreditosTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and upper(rtrim(ltrim(ACCTcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>
	<script language="JavaScript">
		<cfoutput>
		parent.document.#url.form#.#url.id#.value="#rs.ACCTid#";
		parent.document.#url.form#.#url.name#.value="#trim(rs.ACCTcodigo)#";
		parent.document.#url.form#.#url.desc#.value="#rs.ACCTdescripcion#";
		
		window.parent.document.#url.form#._plazo#url.index#.value = "#rs.ACCTplazo#";
		window.parent.document.#url.form#._tasa#url.index#.value = "#rs.ACCTtasa#";
		window.parent.document.#url.form#._tasamora#url.index#.value = "#rs.ACCTtasaMora#";
		window.parent.document.#url.form#._modificable#url.index#.value = "#rs.ACCTmodificable#";
		
		if (window.parent.func#url.name#) {window.parent.func#url.name#()}
		</cfoutput>
	</script>
</cfif>
