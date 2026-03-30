<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">

	<cfquery name="rs" datasource="#url.conexion#">
		SELECT cm.Cmayor,substring(ma.PCEMformato#tipoCuenta#,len(#dato#)+2,len(ma.PCEMformato#tipoCuenta#)) Formato
		from CtasMayor cm
		inner join PCEMascaras ma
		on cm.PCEMid = ma.PCEMid
		where cm.Ecodigo = <cfqueryparam cfsqltype="int" value="#session.Ecodigo#">
			and cm.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#dato#">
	</cfquery>
	<script language="JavaScript">
		<cfoutput>

		<cfif rs.recordcount gt 0>
			<cfif rs.Formato NEQ "" >
				window.parent.document.#url.form#.#url.id#.value="#trim(rs.Cmayor)#";
				window.parent.document.#url.form#.#url.desc#.value="#rs.Formato#";
				window.parent.document.#url.form#.#url.desc#.readOnly=false;
				window.parent.document.#url.form#.#url.desc#.disabled=false;
			<cfelse>
				window.parent.document.#url.form#.#url.id#.value="";
				window.parent.document.#url.form#.#url.desc#.value="";
				window.parent.document.#url.form#.#url.desc#.readOnly=true;
				window.parent.document.#url.form#.#url.desc#.disabled=true;
				alert("La cuenta mayor no formato para el tipo de cuenta. Verifique");
			</cfif>
		<cfelse>
			window.parent.document.#url.form#.#url.id#.value="";
			window.parent.document.#url.form#.#url.desc#.value="";
			window.parent.document.#url.form#.#url.desc#.readOnly=true;
			window.parent.document.#url.form#.#url.desc#.disabled=true;
			alert("La cuenta mayor no existe. Verifique");
		</cfif>
		</cfoutput>
	</script>
</cfif>