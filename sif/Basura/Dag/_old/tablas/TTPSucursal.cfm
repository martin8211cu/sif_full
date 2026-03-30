<cfquery name="rsInst" datasource="tramites">
	select id_inst
	from TPDocumento
	where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gvar_id_tipo#">
</cfquery>
<cfif rsInst.recordcount and len(rsInst.id_inst)>
	<cfset Lvar_Inst = rsInst.id_inst>
</cfif>
<cfquery name="rsTPSucursal" datasource="tramites">
	select id_sucursal, nombre_sucursal
	from TPSucursal a
	where a.id_inst = 1
</cfquery>
<cfoutput>
<select name="#Gvar_name#">
	<cfloop query="rsTPSucursal">
		<option value="#nombre_sucursal#" <cfif nombre_sucursal eq Gvar_Value>selected</cfif>>#nombre_sucursal#</option>
	</cfloop>
</select>
</cfoutput>