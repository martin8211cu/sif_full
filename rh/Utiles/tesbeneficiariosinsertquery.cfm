<!--- <cf_dump var="#session#"> --->

<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 8-6-2005.
	Motivo: Creación del tag para los beneficiarios.
 --->


<!--- Recibe conexion, form, name, desc, CEcodigo y dato --->

<cfif isdefined("url.codigo") and len(trim(url.codigo)) and isdefined("url.desc")and len(trim(url.desc))>
	<cfquery name="rsValida1" datasource="#session.DSN#">
		select TESBeneficiarioId, TESBeneficiario
		from TESbeneficiario
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
			and TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
	</cfquery>
	<cfif rsValida1.recordcount EQ 0>
		<cfquery name="rs" datasource="#session.DSN#">
			insert into TESbeneficiario (CEcodigo, TESBeneficiarioId, TESBeneficiario, BMUsucodigo)
				values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.desc))#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						)
		</cfquery>
		<script language="javascript" type="text/javascript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.disabled = true;
		</script>
	</cfif>
</cfif>