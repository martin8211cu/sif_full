<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select RHEDVcodigo, RHEDVid, RHEDVdescripcion
		from RHEDatosVariables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEDVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.codigo#"> 				
			and RHEDVtipo = 0
	</cfquery>
	
	<!---- Se crea una estructura rsFormateado donde se cargan los datos del query para usar la funcion REreplaceNocase()--->			
	<cfset rsFormateado = querynew("RHEDVcodigo, RHEDVid, RHEDVdescripcion")>
	<cfset cont = 1>
	<cfloop query="rs">
		<cfset res = queryaddrow(rsFormateado)>
		<cfset res = querysetcell(rsFormateado, 'RHEDVid', rs.RHEDVid, cont)>
		<cfset res = querysetcell(rsFormateado, 'RHEDVcodigo', rs.RHEDVcodigo, cont)>
		<cfset res = querysetcell(rsFormateado, 'RHEDVdescripcion', REReplaceNoCase(rs.RHEDVdescripcion, '\r|\n|<[^>]*>', '', 'all'), cont)>
		<cfset cont = cont + 1>
	</cfloop>		
		
	<cfif rs.recordcount gt 0>		
		<script language="JavaScript">					
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVid#</cfoutput>.value="<cfoutput>#rsFormateado.RHEDVid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVcodigo#</cfoutput>.value="<cfoutput>#rsFormateado.RHEDVcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVdescripcion#</cfoutput>.value="<cfoutput>#JSStringFormat(rsFormateado.RHEDVdescripcion)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVid#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVcodigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVdescripcion#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>