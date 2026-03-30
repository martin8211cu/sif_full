<script language="JavaScript">
		window.parent.document.form1.id_persona.value="";
		window.parent.document.formB.NOMBRE.value="";
</script>
<cfif isdefined("url.DATO") and url.DATO NEQ "" >
	<cfquery name="rs" datasource="#session.tramites.dsn#">
		select id_persona, nombre || ' '  || apellido1  || ' ' || apellido2 as nombre
		from  TPPersona
		where identificacion_persona= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
		and  id_tipoident =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tipo#">
	</cfquery>

	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.form1.id_persona.value="<cfoutput>#trim(rs.id_persona)#</cfoutput>";
			window.parent.document.formB.NOMBRE.value="<cfoutput>#trim(rs.nombre)#</cfoutput>";
			if (window.parent.document.Busqueda.NOMBRE){
				window.parent.document.Busqueda.NOMBRE.value="<cfoutput>#trim(rs.NOMBRE)#</cfoutput>";
			}
			if (window.parent.document.Busqueda.id_tipoident){	
				window.parent.document.Busqueda.id_tipoident.value="<cfoutput>#trim(url.tipo)#</cfoutput>";
			}
			if (window.parent.document.Busqueda.identificacion_persona){	
				window.parent.document.Busqueda.identificacion_persona.value="<cfoutput>#trim(url.dato)#</cfoutput>";
			}			
			if (window.parent.document.Busqueda.id_persona){	
				window.parent.document.Busqueda.id_persona.value="<cfoutput>#trim(rs.id_persona)#</cfoutput>";
			}			
		<cfelse>
			window.parent.document.form1.id_persona.value="";
			window.parent.document.formB.NOMBRE.value="";
			alert("El funcionario no existe en el padron")
		</cfif>
	</script>
</cfif>
