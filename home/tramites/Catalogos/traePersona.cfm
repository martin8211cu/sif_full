<cfif not isdefined("url.tipo")>
	<cfquery name="rsTipo" datasource="#session.tramites.dsn#" maxrows="1">
		select id_tipoident
		from TPTipoIdent
	</cfquery>
	<cfset url.tipo = rsTipo.id_tipoident >
</cfif>

<script language="JavaScript">
	window.parent.document.formf.id_persona.value='';
	window.parent.document.formf.nombre.value='';
	window.parent.document.formf.apellido1.value='';
	window.parent.document.formf.apellido2.value='';
	window.parent.document.formf.email.value='';
</script>
<cfif isdefined("url.DATO") and url.DATO NEQ "" >
	<cfquery name="rs" datasource="#session.tramites.dsn#">
		select id_persona, nombre, apellido1, apellido2, email1
		from  TPPersona
		where identificacion_persona= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DATO#">
		<!---and  id_tipoident =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tipo#">--->
	</cfquery>

	<cfif rs.recordcount gt 0>
		<cfquery name="usuario" datasource="asp">
			select Usucodigo
			from UsuarioReferencia
			where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.DATO)#">
			and STabla = 'TPPersona'
		</cfquery>

		<script language="JavaScript">
			window.parent.document.formf.id_persona.value="<cfoutput>#trim(rs.id_persona)#</cfoutput>";
			window.parent.document.formf.nombre.value="<cfoutput>#trim(rs.nombre)#</cfoutput>";
			window.parent.document.formf.apellido1.value="<cfoutput>#trim(rs.apellido1)#</cfoutput>";
			window.parent.document.formf.apellido2.value="<cfoutput>#trim(rs.apellido2)#</cfoutput>";
			window.parent.document.formf.email.value="<cfoutput>#trim(rs.email1)#</cfoutput>";
			
			window.parent.document.formf.nombre.disabled=true;
			window.parent.document.formf.apellido1.disabled=true;
			window.parent.document.formf.apellido2.disabled=true;
			
			<cfif usuario.recordcount gt 0>
				window.parent.document.formf.login.disabled = true;
				window.parent.document.formf.login.value = '';
			<cfelse>
				window.parent.document.formf.login.disabled = false;
				window.parent.document.formf.login.value = '';
			</cfif>	
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.formf.nombre.disabled=false;
			window.parent.document.formf.apellido1.disabled=false;
			window.parent.document.formf.apellido2.disabled=false;
			window.parent.document.formf.id_persona.value="";
			window.parent.document.formf.login.disabled = false;
			window.parent.document.formf.login.value = '';
		</script>
	</cfif>

</cfif>
