<!---  --->
<!---

	Modificado por Andres Lara
	Motivo: Desarrollo del catalogo de compradores en modulo de contratos
--->

<cfif isdefined("Form.Alta")>
				<!--- Valida que el CTCcodigo no exista --->
				<cfquery name="valida" datasource="#session.DSN#">
					select 1 from CTCompradores
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and CTCcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CTCcodigo#">
					  or CTCnombre      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre#">
				</cfquery>
				<cfif valida.RecordCount gt 0>
					<cf_errorCode	code = "50255" msg = "El Código del Comprador ya existe, por favor intente de nuevo.">
				</cfif>

			<!--- Se quitan la separacion por comillas --->
				<cfset form.CTCmontomax = #Form.CTCmontomax.replace(",","")# >
				<cftransaction>
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into CTCompradores (Ecodigo,CTCcodigo,CTCnombre,CTCactivo,CTCarticulo,CTCservicio,CTCactivofijo,CTCobra,CTCMcodigo,CTCmontomax,Usucodigo,BMUsucodigo)
							values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CTCcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre#">,
								<cfif isdefined('Form.ctcactivo')>1,<cfelse>0,</cfif>
								<cfif isdefined('Form.CTCarticulo')>1,<cfelse>0,</cfif>
								<cfif isdefined('Form.CTCservicio')>1,<cfelse>0,</cfif>
								<cfif isdefined('Form.CTCactivofijo')>1,<cfelse>0,</cfif>
								<cfif isdefined('Form.CTCobra')>1,<cfelse>0,</cfif>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#Form.CTCmontomax#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">
									 )
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				</cftransaction>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
<!--- valida que no este en un contrato --->
			<cfquery name ="consultaContrato" datasource="#Session.DSN#">
				select 1
				from CTContrato
				where CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCid#">
			</cfquery>

		<cfif consultaContrato.recordcount eq 0>
			<cfquery name="deleteFirma" datasource="#Session.DSN#">
				delete from CTCompradores
				where CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCid#">
			</cfquery>
		<cfelse>
			<cfthrow message ="El Comprador que se desea eliminar se encuentra asignado a un Contrato.">
		</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
		<!--- Se quitan la separacion por comillas --->
				<cfset form.CTCmontomax = #Form.CTCmontomax.replace(",","")# >
		<cftransaction>
			<cfquery name="insert" datasource="#Session.DSN#">
						update CTCompradores
						   set CTCcodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CTCcodigo#">,
						       CTCnombre 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre#">,
						       CTCactivo 	  = <cfif isdefined('Form.ctcactivo')>1,<cfelse>0,</cfif>
						       CTCarticulo    = <cfif isdefined('Form.CTCarticulo')>1,<cfelse>0,</cfif>
						       CTCservicio    = <cfif isdefined('Form.CTCservicio')>1,<cfelse>0,</cfif>
						       CTCactivofijo  = <cfif isdefined('Form.CTCactivofijo')>1,<cfelse>0,</cfif>
						       CTCobra        = <cfif isdefined('Form.CTCobra')>1,<cfelse>0,</cfif>
						       CTCMcodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mcodigo#">,
						       CTCmontomax    = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CTCmontomax#">,
						       BMUsucodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">
						 where CTCid = #Form.ctcid#
			</cfquery>
		</cftransaction>
			<cfset modo="ALTA">

</cfif>

<form action="Compradores.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("form.Baja")><input name="CTCid" type="hidden" value="<cfif isdefined("Form.CTCid")><cfoutput>#Form.CTCid#</cfoutput></cfif>"></cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>

