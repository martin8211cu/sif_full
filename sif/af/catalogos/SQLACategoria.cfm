<cfset modo = "ALTA">

<cftry>
		<cfif isdefined ('form.Importa')>
			<cflocation  url="importaCategoriaClase.cfm?ACcodigo=#Form.ACcodigo#">
		</cfif>

		<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>

			<!--- Si ya existe un registro con ACcodigodesc no permite insertarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select ACcodigodesc
				from ACategoria
				where Ecodigo = #Session.Ecodigo#
				  and upper(ACcodigodesc) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.ACcodigodesc))#">
			</cfquery>

			<cfif #rsVerifica.recordCount# eq 0>

				<cfquery name="data" datasource="#session.DSN#">
					select max(ACcodigo) as ACcodigo
					from ACategoria
					where Ecodigo = #Session.Ecodigo#
				</cfquery>

				<cfif data.RecordCount gt 0 and len(trim(data.ACcodigo))>
					<cfset vACcodigo = data.ACcodigo + 1>
				<cfelse>
					<cfset vACcodigo = 1>
				</cfif>

				<cftransaction>
					<cfquery name="rsInserta" datasource="#Session.DSN#">
						insert into ACategoria (Ecodigo, ACcodigo, ACcodigodesc, ACdescripcion, ACvutil, ACcatvutil, ACmetododep, ACmascara, cuentac
						<cfif isdefined("Form.Ucodigo")>,Ucodigo</cfif>,ACdepadq, BMUsucodigo
						)
						values( #Session.Ecodigo#,
								<cfqueryparam value="#vACcodigo#" 			cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.ACcodigodesc#" 	cfsqltype="cf_sql_char">,
								<cfqueryparam value="#Form.ACdescripcion#" 	cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Form.ACvutil#" 		cfsqltype="cf_sql_integer">,
								<cfif isdefined("Form.ACcatvutil")>'S'<cfelse>'N'</cfif>,
								<cfqueryparam value="#Form.ACmetododep#" 	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Form.ACmascara#" 		cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Form.cuentac#" 		cfsqltype="cf_sql_varchar">
							    <cfif isdefined("Form.Ucodigo")>
								,<cfqueryparam value="#trim(Form.Ucodigo)#" cfsqltype="cf_sql_varchar">
								</cfif>
								,<cfif isdefined("Form.ACdepadq")>1<cfelse>0</cfif>
                                ,#session.Usucodigo#

							  )
					</cfquery>
				</cftransaction>

				<cfset modo="CAMBIO">
			<cfelse>
				<cf_errorCode	code = "50033" msg = "No se puede agregar. Ya existe una categoría asignada.">
			</cfif>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete_excep" datasource="#Session.DSN#">
				delete from ClasificacionCFuncional
				where Ecodigo  = #Session.Ecodigo#
				  and ACcodigo = <cfqueryparam value="#Form.ACcodigo#"   cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="delete_cla" datasource="#Session.DSN#">
				delete from AClasificacion
				where Ecodigo  = #Session.Ecodigo#
				  and ACcodigo = <cfqueryparam value="#Form.ACcodigo#"   cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="delete_cat" datasource="#Session.DSN#">
				delete from ACategoria
				where Ecodigo  = #Session.Ecodigo#
				and ACcodigo = <cfqueryparam value="#Form.ACcodigo#"   cfsqltype="cf_sql_integer">
			</cfquery>

		<cfelseif isdefined("Form.Cambio")>
			<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select ACcodigodesc
				from ACategoria
				where Ecodigo = #Session.Ecodigo#
				  and upper(ACcodigodesc) =  <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.ACcodigodesc))#">
				  and upper(ACcodigodesc) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.ACcodigodescL))#">
			</cfquery>
			<cfif #rsVerifica.recordCount# eq 0>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="ACategoria"
								redirect="ACategoria.cfm"
								timestamp="#form.ts_rversion#"
								field1="ACcodigo"
								type1="integer"
								value1="#form.ACcodigo#"
								field2="Ecodigo"
								type2="integer"
								value2="#session.Ecodigo#"
								>

				<cfquery name="update" datasource="#Session.DSN#">
					update ACategoria set
						   ACcodigodesc = <cfqueryparam value="#Form.ACcodigodesc#" 	cfsqltype="cf_sql_char">,
						  ACdescripcion = <cfqueryparam value="#Form.ACdescripcion#" 	cfsqltype="cf_sql_varchar">,
						   ACvutil      = <cfqueryparam value="#Form.ACvutil#" 			cfsqltype="cf_sql_integer">,
						   ACcatvutil   = <cfif isdefined("Form.ACcatvutil")>'S'<cfelse>'N'</cfif>,
						   ACmetododep  = <cfqueryparam value="#Form.ACmetododep#" 		cfsqltype="cf_sql_integer">,
						   ACmascara    = <cfqueryparam value="#Form.ACmascara#" 		cfsqltype="cf_sql_varchar">,
						   cuentac      = <cfqueryparam value="#Form.cuentac#" 			cfsqltype="cf_sql_varchar">
						<cfif isdefined("Form.Ucodigo")>
						    ,Ucodigo    = <cfqueryparam value="#trim(Form.Ucodigo)#" 	cfsqltype="cf_sql_varchar">
						</cfif>
						    ,ACdepadq   = <cfif isdefined("Form.ACdepadq")>1<cfelse>0</cfif>
                            ,BMUsucodigo = #session.Usucodigo#
					where Ecodigo   = #Session.Ecodigo#
					  and ACcodigo  = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfset modo="CAMBIO">
			<cfelse>
				<cf_errorCode	code = "50034" msg = "No se puede modificar. Ya existe una categoría asignada.">
			</cfif>
		</cfif>

		<cfif isdefined("Form.ACcatvutil") and form.ACcatvutil EQ "S" and not isdefined("Form.Baja")>
			<cfquery name="update_cla" datasource="#Session.DSN#">
				update AClasificacion
				set ACvutil = <cfqueryparam value="#Form.ACvutil#" cfsqltype="cf_sql_integer">
				where Ecodigo = #Session.Ecodigo#
				  and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
		  </cfquery>
		</cfif>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="ACategoria.cfm" method="post" name="sql">
	<cfif not isdefined("Form.Nuevo") and (modo neq 'BAJA')>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="ACcodigo" type="hidden" value="<cfif isdefined("Form.ACcodigo") and modo neq 'ALTA'>#Form.ACcodigo#</cfif>">
	</cfif>
	<input name="Pagina1" type="hidden" value="<cfif isdefined("Form.Pagina") and len(trim(Form.Pagina)) and not isDefined("form.Baja")>#Form.Pagina#<cfelse>1</cfif>">

	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<input name="ACcodigo" type="hidden" value="#vACcodigo#">
		</cfif>
	</cfif>
</form>
</cfoutput>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>