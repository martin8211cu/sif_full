<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">

	<cfquery name="rs" datasource="#url.conexion#">
		Select distinct b.Cmayor, b.Cdescripcion
		from Empresas a
			inner join CtasMayor b
			   on b.Ecodigo = a.Ecodigo
		Where a.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and b.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#dato#">
		order by b.Cmayor, b.Cdescripcion
	</cfquery>
	<script language="JavaScript">
		<cfoutput>
		<cfif rs.recordcount gt 0>
			window.parent.document.#url.form#.#url.id#.value="#trim(rs.Cmayor)#";
			window.parent.document.#url.form#.#url.desc#.value="#rs.Cdescripcion#";

			if (window.parent.document.#url.form#.txtAutSubmit.value == "true"){
					window.parent.document.#url.form#.submit();
			}
		<cfelse>
			window.parent.document.#url.form#.#url.id#.value="";
			window.parent.document.#url.form#.#url.desc#.value="";
			alert("La cuenta mayor no existe. Verifique");
		</cfif>
		</cfoutput>
	</script>
</cfif>