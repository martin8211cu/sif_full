<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 8-6-2005.
	Motivo: Creación del tag para los beneficiarios.
 --->


<!--- Recibe conexion, form, name, desc, CEcodigo y dato --->

<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select TESBeneficiarioId, TESBeneficiario, TESBid, TESBactivo
		from TESbeneficiario
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		and upper(TESBeneficiarioId) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			<cfif rs.TESBactivo EQ "1">
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.TESBid#</cfoutput>";
				window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="<cfoutput>#rs.TESBeneficiarioId#</cfoutput>";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.TESBeneficiario#</cfoutput>";
				<cfoutput>if (window.parent.funcLimpia#url.id#) {window.parent.funcLimpia#url.id#()}</cfoutput> 
			<cfelse>
				<cfoutput>alert("El Beneficiario está inactivo: #rs.TESBeneficiarioId# #rs.TESBeneficiario#");</cfoutput>
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			</cfif>
		</script>
	<cfelse>
		<script language="JavaScript">
			
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
		<!--- window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.numero#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value=""; --->
	</cfif>
</cfif>