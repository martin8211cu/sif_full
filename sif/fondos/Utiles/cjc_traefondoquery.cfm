<!--- Recibe conexion, form, name, desc, ecodigo, dato y filtrarUsuario--->
<cfif not isdefined("url.filtrarUsuario") or len(trim(url.filtrarUsuario)) eq 0 >
	<cfset filtrarUsuario = false>
</cfif>

<cfif filtrarUsuario>
	<cfquery name="rsUsuarioFondo" datasource="#session.Fondos.dsn#">
		select count (1) as cantidad
		from CJM010 a, CJM000 b 
		where a.CJM00COD = b.CJM00COD 
		   and CJM10LOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
		   and CJM10EST = 'A'
	</cfquery>
	
	<cfif rsUsuarioFondo.cantidad eq 0 >
		<cfset filtrarUsuario = false>
	</cfif>
</cfif>


<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfif filtrarUsuario>
		<cfquery name="rs" datasource="#session.Fondos.dsn#">
			select a.CJM00COD,a.CJM00DES
			from CJM000 a, CJM010 b
			where a.CJM00COD = b.CJM00COD
				and a.CJM00EST='A'  
				and a.CJM00COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#"> 
				and b.CJM10LOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
		</cfquery>
	<cfelse>
		<cfquery name="rs" datasource="#session.Fondos.dsn#">
			select CJM00COD,CJM00DES 
			from CJM000
			where CJM00EST='A' 
			and CJM00COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
		</cfquery>
	</cfif>

	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CJM00COD)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CJM00DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("El fondo no existe")
		</cfif>
	</script>
</cfif>

