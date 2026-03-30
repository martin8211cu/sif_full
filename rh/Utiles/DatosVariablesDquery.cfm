<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select RHDDVcodigo, RHEDVid, RHDDVdescripcion, RHDDVlinea
		from RHDDatosVariables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHDDVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.codigo#"> 		
	</cfquery>

	<cfif rs.recordcount gt 0>		
		<script language="JavaScript">					
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVid2#</cfoutput>.value="<cfoutput>#rs.RHEDVid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHDDVlinea#</cfoutput>.value="<cfoutput>#rs.RHDDVlinea#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHDDVcodigo#</cfoutput>.value="<cfoutput>#rs.RHDDVcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHDDVdescripcion#</cfoutput>.value="<cfoutput>#JSStringFormat(rs.RHDDVdescripcion)#</cfoutput>";
			// Invocar una funcion de recuperacion de datos si la funcion existe 
			if (window.parent.recuperar && window.parent.document.form1) {
				window.parent.recuperar(window.parent.document.form1);
			}
		</script>
	<cfelse>
		<cfabort>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVid2#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHDDVlinea#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVcodigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.RHEDVdescripcion#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>