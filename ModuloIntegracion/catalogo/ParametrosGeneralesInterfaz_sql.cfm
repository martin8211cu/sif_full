

<cfif isDefined("form.modo") AND form.modo EQ "Guardar">
	<!--- Insert parámetro --->
	<!--- Primero se valida que no existe el pcodigo --->
	<cfquery name="rsValidaParam" datasource="sifinterfaces">
		SELECT Pcodigo FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.codigo#">
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#session.ecodigo#">
	</cfquery>
	<cfif rsValidaParam.RecordCount GT 0 AND rsValidaParam.Pcodigo NEQ "">
		<script language="javascript">
			alert('Ya existe un parámetro registrado con el código: <cfoutput>#form.codigo#</cfoutput>');
			document.location = 'ParametrosGeneralesInterfaz.cfm';
		</script>
	<cfelse>
		<cfquery name="rsInsertParam" datasource="sifinterfaces">
			INSERT INTO SIFLD_ParametrosAdicionales (Pcodigo, Pvalor, Pdescripcion, Pobservaciones, Ecodigo)
			VALUES (
					<cfif isDefined("form.codigo") AND Len(#form.codigo#)>
					    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.codigo#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif isDefined("form.valor") AND Len(#form.valor#)>
					    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.valor#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif isDefined("form.descripcion") AND Len(#form.descripcion#)>
					    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.descripcion#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif isDefined("form.observaciones") AND Len(#form.observaciones#)>
					    <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.observaciones#">,
					<cfelse>
						NULL,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#session.ecodigo#">
					)
		</cfquery>
		<cflocation url="/cfmx/ModuloIntegracion/catalogo/ParametrosGeneralesInterfaz.cfm">
	</cfif>
<cfelseif isDefined("form.modo") AND form.modo EQ "Update">
	<!--- Update parámetro --->
	<cfquery name="rsUpdateParam" datasource="sifinterfaces">
		UPDATE SIFLD_ParametrosAdicionales
		SET
		<cfif isDefined("form.codigo") AND #form.codigo# EQ '00002'>
			<cfif isDefined("form.valor") AND Len(#form.valor#)>
				Pvalor = 1
			<cfelse>
				Pvalor = 0
			</cfif>
		<cfelse>
			<cfif isDefined("form.valor") AND Len(#form.valor#)>
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.valor#">
			<cfelse>
				Pvalor = 0
			</cfif>
		</cfif>
		<cfif isDefined("form.descripcion") AND Len(#form.descripcion#)>
			,Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.descripcion#">
		<cfelse>
			,Pdescripcion = NULL
		</cfif>
		<cfif isDefined("form.observaciones") AND Len(#form.observaciones#)>
			,Pobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.observaciones#">
		<cfelse>
			,Pobservaciones = NULL
		</cfif>
		WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.codigo#">
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#session.ecodigo#">
	</cfquery>
	<cflocation url="/cfmx/ModuloIntegracion/catalogo/ParametrosGeneralesInterfaz.cfm">
<cfelseif isDefined("form.modo") AND form.modo EQ "Delete">
	<!--- Delete parámetro --->
	<cfquery name="rsDeleteParam" datasource="sifinterfaces">
		DELETE SIFLD_ParametrosAdicionales
		WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.codigo#">
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#session.ecodigo#">
	</cfquery>
	<cflocation url="/cfmx/ModuloIntegracion/catalogo/ParametrosGeneralesInterfaz.cfm">
</cfif>
