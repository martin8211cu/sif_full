<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.id") and url.id NEQ "">
	<cfquery name="rs" datasource="#session.DSN#">
		select PCDcatid, PCDvalor, PCDdescripcion
		from CGAreaResponsabilidad a
		inner join PCDCatalogo b
		on b.PCEcatid = a.PCEcatid
		and upper(b.PCDvalor) = '#ucase(url.id)#'
		where a.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CGARid#" >
	</cfquery>
	
	<script language="JavaScript">
		function trim(dato) {
			dato = dato.replace(/^\s+|\s+$/g, '');
			return dato;
		}
		
		<cfoutput>
		window.parent.document.form2.PCDcatid.value="#trim(rs.PCDcatid)#";
		window.parent.document.form2.PCDvalor.value="#JSStringFormat(rs.PCDvalor)#";
		window.parent.document.form2.PCDdescripcion.value="#JSStringFormat(rs.PCDdescripcion)#";
		</cfoutput>
	</script>
</cfif>