
<cfif IsDefined("form.Agrega")>
	<cfquery name="rsNewSol" datasource="#session.dsn#">
		select coalesce(max(AFTRdocumento),0) + 1 as newSol
		from AFTRelacionCambio
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insert">
				insert into
						AFTRelacionCambio
						 (
								Ecodigo,
								AFTRdescripcion,
								Usucodigo,
								AFTRfecha,
								AFTRtipo,
								BMfecha,
								UsucodigoAplica,
								AFTRdocumento
						)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFTRdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFTRtipo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">
						)
		<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="AFTRid">
	
	</cftransaction>

<cflocation url="ValorRescate.cfm?AFTRid=#AFTRid#">
</cfif>

<cfif isdefined ("form.modifica")>
		<cfquery datasource="#session.dsn#" name="actualizar">
			update AFTRelacionCambio
				set 
				AFTRdescripcion = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFTRdescripcion#">
		where AFTRid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
		</cfquery>

<cflocation url="ValorRescate.cfm?AFTRid=#AFTRid#">

</cfif>


<cfif isdefined ('form.Baja')>
	<cfquery name="elActivo" datasource="#session.dsn#">
		delete from AFTRelacionCambioD 
		where AFTRid = #form.AFTRid# 
	</cfquery>

	<cfquery name="EliminaVal" datasource="#session.DSN#">
		delete from AFTRelacionCambio
		where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
	</cfquery>
	
<cflocation url="ValorRescate.cfm">
</cfif>


<cfif isdefined ('form.nuevo')>
<cflocation url="ValorRescate.cfm?Nuevo=1">
</cfif>


<cfif isdefined ('form.irLista')>
<cflocation url="ValorRescate.cfm">
</cfif>

<cfif isdefined ('form.Importa')>
	<cfinclude template="ValorRescateImporta.cfm">
</cfif>

<cfif isdefined ('form.Exporta')>
	<cfinclude template="ValorRescate_exportar.cfm">
</cfif>

<cfif isdefined ('form.Generar')>
</cfif>



<cfif isdefined ('form.BorrarDet')>
	<cfquery name="elActivo" datasource="#session.dsn#">
		delete from AFTRelacionCambioD 
		where AFTDid = #form.BorrarDet# 
		  and AFTRid = #form.AFTRid# 
	</cfquery>
	<cflocation url="ValorRescate.cfm?AFTRid=#AFTRid#">
</cfif>

<cfif isdefined('form.aplicar')>
	<cfinvoke component="sif.af.operacion.ValorRescate.CambioValorRescate" 
	  method="AF_CambioValorRescate"
		AFTRid = "#form.AFTRid#"
	/>
	<cflocation url="ValorRescate.cfm">
</cfif>
