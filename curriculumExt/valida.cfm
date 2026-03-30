<cfdump var="#url#">
<cfquery name="rs" datasource="#session.dsn#">
	select 1 from DatosOferentes 
	WHERE RHOid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(url.RHOid)#">
	<cfif isdefined("url.RHOemail") and len(trim(url.RHOemail))>
		and RHOemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.RHOemail)#">
	</cfif>
	<cfif isdefined("url.RHOidentificacion") and len(trim(url.RHOidentificacion))>
		and NTIcodigo         = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(url.NTIcodigo)#">
		and RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.RHOidentificacion)#">
	</cfif>
</cfquery>
<cfif rs.recordCount gt 0>
	<script language="JavaScript">
		<!--- window.parent.document.form1.DESCUENTA.value = '<cfoutput>#trim(rs.CTADES)#</cfoutput>'; --->
		<cfif isdefined("url.RHOemail") and len(trim(url.RHOemail))>
			alert("El correo electrónico proporcionado ya está registrado en nuestra base de datos")
			window.parent.document.form1.RHOemail.value = '';
		</cfif>
		<cfif isdefined("url.RHOidentificacion") and len(trim(url.RHOidentificacion))>
			alert("La identificación proporsionada  ya está registrada en nuestra base de datos")
			window.parent.document.form1.RHOidentificacion.value = '';
		</cfif>
	</script>	
</cfif>
