<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfinclude template="sifConcat.cfm">
	<cfquery name="rs" datasource="#session.DSN#">
		select CDid, CDidentificacion, CDnombre#_Cat#' ' #_Cat# CDapellido1 #_Cat# ' ' #_Cat# CDapellido2 as CDnombre, coalesce(CDlimitecredito, 0) as CDlimitecredito, coalesce(CDcreditoutilizado, 0) as CDcreditoutilizado
		from ClienteDetallista
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and upper(CDidentificacion) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.CDid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.CDidentificacion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.CDnombre#</cfoutput>";
			
			if ( window.parent.form1.credito_limite ){
				window.parent.form1.credito_limite.value = "<cfoutput>#rs.CDlimitecredito#</cfoutput>";
				if ( window.parent.fm ){
					window.parent.fm(window.parent.form1.credito_limite,2)
				}
			}
			
			if ( window.parent.form1.credito_utilizado ){
				window.parent.form1.credito_utilizado.value = "<cfoutput>#rs.CDcreditoutilizado#</cfoutput>";;
				if ( window.parent.fm ){
					window.parent.fm(window.parent.form1.credito_utilizado,2)
				}
			}
			
			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";

			if ( window.parent.form1.credito_limite ){
				window.parent.form1.credito_limite.value = '';
			}
			
			if ( window.parent.form1.credito_utilizado ){
				window.parent.form1.credito_utilizado.value = '';
			}



			<cfoutput>if (window.parent.func#url.numero#) {window.parent.func#url.numero#()}</cfoutput>
		</script>
	</cfif>
</cfif>