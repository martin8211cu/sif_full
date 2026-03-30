<cfset modo = "ALTA">
<cftry>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>

			<!--- Si ya existe un registro con ACcodigodesc no permite insertarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select ACcodigodesc
				from AClasificacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
				  and upper(ACcodigodesc) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.ACcodigodesc))#">
			</cfquery>

			<cfif #rsVerifica.recordCount# eq 0>
				<cfquery name="data" datasource="#session.DSN#">
					select max(ACid) as ACid
					from AClasificacion
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif data.RecordCount gt 0 and len(trim(data.ACid))>
					<cfset vACid = data.ACid + 1>
				<cfelse>
					<cfset vACid = 1 >
				</cfif>

				<cfquery name="ABC_AClasificacion" datasource="#Session.DSN#">
					insert into AClasificacion(Ecodigo, ACcodigo, ACcodigodesc, ACid, ACdescripcion, ACvutil, ACdepreciable, ACrevalua, ACexigeVale, ACcsuperavit, ACcadq, ACcdepacum, ACcrevaluacion,ACccomodato, ACcdepacumrev, ACgastodep, ACgastorev, ACtipo, ACvalorres, cuentac, ACgastoret, ACingresoret,ACNegarMej, ACVidaUtilFiscal, ACImporteMaximo, ACPorcentajeFiscal, ACPorcentajePTU,ACcgastodepreciacion, ACfgastodepreciacion,ACmascara)
					values( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.ACcodigodesc#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#vACid#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.ACdescripcion#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.ACvutil#" cfsqltype="cf_sql_integer">,
							<cfif isdefined("Form.ACdepreciable")>'S'<cfelse>'N'</cfif>,
							<cfif isdefined("Form.ACrevalua")>'S'<cfelse>'N'</cfif>,
							<cfif isdefined("Form.ACexigeVale")>'S'<cfelse>'N'</cfif>,
							<cfqueryparam value="#Form.ACcsuperavit#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Form.ACcadq#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Form.ACcdepacum#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Form.ACcrevaluacion#" cfsqltype="cf_sql_numeric">,
							<cfif isdefined("Form.ACccomodato")> #Form.ACccomodato# <cfelse> null </cfif>,
							<cfqueryparam value="#Form.ACcdepacumrev#" cfsqltype="cf_sql_numeric">,
							<cfif len(trim(Form.ACgastodep))><cfqueryparam value="#Form.ACgastodep#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
							<cfif len(trim(Form.ACgastorev))><cfqueryparam value="#Form.ACgastorev#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACtipo#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ACvalorres#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.cuentac#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACgastoret#" null="#len(trim(Form.ACgastoret)) EQ 0#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACingresoret#" null="#len(trim(Form.ACingresoret)) EQ 0#">,
							<cfif isdefined("Form.ACNegarMej")>1<cfelse>0</cfif>,
                            <cfif isdefined("Form.ACvutilfiscal") and len(trim(#Form.ACvutilfiscal#)) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACvutilfiscal#"><cfelse>0</cfif>,
                            <cfif isdefined("Form.ACimportemax") and len(trim(#Form.ACimportemax#)) GT 0><cfqueryparam cfsqltype="cf_sql_money" value="#Form.ACimportemax#"><cfelse>0</cfif>,
                            <cfif isdefined("Form.ACporfiscal") and len(trim(#Form.ACporfiscal#)) GT 0><cfqueryparam cfsqltype="cf_sql_float" value="#Form.ACporfiscal#"><cfelse>0</cfif>,
                            <cfif isdefined("Form.ACpordeducPTU") and len(trim(#Form.ACpordeducPTU#)) GT 0><cfqueryparam cfsqltype="cf_sql_float" value="#Form.ACpordeducPTU#"><cfelse>0</cfif>,
							<cfif isdefined("Form.Ccuenta") and #Form.Ccuenta# NEQ '' and not find("?",#Form.Cformato#)>
								<cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">
							<cfelse>
								null
							</cfif>,
							<cfif isdefined("Form.Cformato") and #Form.Cformato# NEQ ''>
								<cfqueryparam value="#trim(Form.Cmayor) & "-" & trim(Form.Cformato)#">
							<cfelse>
								ACfgastodepreciacion = null
							</cfif>
                            <cfif isdefined("Form.ACmascara") and #Form.ACmascara# NEQ ''>
                        		,<cfqueryparam value="#Form.ACmascara#" cfsqltype="cf_sql_char">
                        	<cfelse>
                        		,null
                        	</cfif>)
				</cfquery>
				<cfset modo="CAMBIO">
			<cfelse>
				<cf_errorCode	code = "50035" msg = "No se puede agregar. Ya existe una clasificación asignada.">
			</cfif>

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete_excep" datasource="#Session.DSN#">
				delete from ClasificacionCFuncional
				where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and ACid = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="delete_cla" datasource="#Session.DSN#">
				delete from AClasificacion
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and ACid = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
			</cfquery>

		<cfelseif isdefined("Form.Cambio")>
			<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select ACcodigodesc
				from AClasificacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
				  and upper(ACcodigodesc) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.ACcodigodesc))#">
				  and upper(ACcodigodesc) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.ACcodigodescL))#">
			</cfquery>
			<cfif #rsVerifica.recordCount# eq 0>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="AClasificacion"
								redirect="AClasificacion.cfm"
								timestamp="#form.ts_rversion#"
								field1="ACcodigo"
								type1="integer"
								value1="#form.ACcodigo#"
								field2="Ecodigo"
								type2="integer"
								value2="#session.Ecodigo#"
								field3="ACid"
								type3="integer"
								value3="#form.ACid#"
								>

				<cfquery name="update" datasource="#Session.DSN#">
					update AClasificacion
					set ACcodigo           = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">,
						ACcodigodesc       = <cfqueryparam value="#Form.ACcodigodesc#" cfsqltype="cf_sql_char">,
						ACdescripcion      = <cfqueryparam value="#Form.ACdescripcion#" cfsqltype="cf_sql_varchar">,
						ACvutil            = <cfqueryparam value="#Form.ACvutil#" cfsqltype="cf_sql_integer">,
						ACdepreciable      = <cfif isdefined("Form.ACdepreciable")>'S'<cfelse>'N'</cfif>,
						ACrevalua          = <cfif isdefined("Form.ACrevalua")>'S'<cfelse>'N'</cfif>,
						ACexigeVale	       = <cfif isdefined("Form.ACexigeVale")>'S'<cfelse>'N'</cfif>,
						ACcsuperavit       = <cfqueryparam value="#Form.ACcsuperavit#" cfsqltype="cf_sql_numeric">,
						ACcadq 		       = <cfqueryparam value="#Form.ACcadq#" cfsqltype="cf_sql_numeric">,
						ACcdepacum 	       = <cfqueryparam value="#Form.ACcdepacum#" cfsqltype="cf_sql_numeric">,
						ACcrevaluacion     = <cfqueryparam value="#Form.ACcrevaluacion#" cfsqltype="cf_sql_numeric">,
						ACcdepacumrev      = <cfqueryparam value="#Form.ACcdepacumrev#" cfsqltype="cf_sql_numeric">,
						ACccomodato		   = <cfif isdefined("Form.ACccomodato")> #Form.ACccomodato# <cfelse> null </cfif>,
						ACgastodep 	       = <cfif len(trim(Form.ACgastodep))><cfqueryparam value="#Form.ACgastodep#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
						ACgastorev 	       = <cfif len(trim(Form.ACgastorev))><cfqueryparam value="#Form.ACgastorev#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
						ACtipo 	           = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACtipo#">,
						ACvalorres	       = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ACvalorres#">,
						cuentac		       = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.cuentac#">,
						ACgastoret 	       = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACgastoret#" null="#len(trim(Form.ACgastoret)) EQ 0#">,
						ACingresoret       = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACingresoret#" null="#len(trim(Form.ACingresoret)) EQ 0#">,
						ACNegarMej	       = <cfif isdefined("Form.ACNegarMej")>1<cfelse>0</cfif>,
						ACVidaUtilFiscal   = <cfif isdefined("Form.ACvutilfiscal") and len(trim(#Form.ACvutilfiscal#)) GT 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACvutilfiscal#"><cfelse>0</cfif>,
                        ACImporteMaximo    = <cfif isdefined("Form.ACimportemax") and len(trim(#Form.ACimportemax#)) GT 0><cfqueryparam cfsqltype="cf_sql_money" value="#Form.ACimportemax#"><cfelse>0</cfif>,
                        ACPorcentajeFiscal = <cfif isdefined("Form.ACporfiscal") and len(trim(#Form.ACporfiscal#)) GT 0><cfqueryparam cfsqltype="cf_sql_float" value="#Form.ACporfiscal#"><cfelse>0</cfif>,
                        ACPorcentajePTU    = <cfif isdefined("Form.ACpordeducPTU") and len(trim(#Form.ACpordeducPTU#)) GT 0><cfqueryparam cfsqltype="cf_sql_float" value="#Form.ACpordeducPTU#"><cfelse>0</cfif>,
						<cfif isdefined("Form.Ccuenta") and #Form.Ccuenta# NEQ '' and not find("?",#Form.Cformato#)>
							ACcgastodepreciacion = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">
						<cfelse>
							ACcgastodepreciacion = null
						</cfif>,
						<cfif isdefined("Form.Cformato") and #Form.Cformato# NEQ ''>
							ACfgastodepreciacion = <cfqueryparam value="#trim(Form.Cmayor) & "-" & trim(Form.Cformato)#">
						<cfelse>
							ACfgastodepreciacion = null
						</cfif>
                        <cfif isdefined("Form.ACmascara") and #Form.ACmascara# NEQ ''>
                        	,ACmascara = <cfqueryparam value="#Form.ACmascara#" cfsqltype="cf_sql_char">
                        <cfelse>
                        	,ACmascara = null
                        </cfif>
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and ACid = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset modo="CAMBIO">
			<cfelse>
				<cf_errorCode	code = "50036" msg = "No se puede modificar. Ya existe una clasificación asignada.">
			</cfif>
		</cfif>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<form action="AClasificacion.cfm" method="post" name="sql">
<cfoutput>
	<input name="ACcodigo" type="hidden" value="<cfif isdefined("Form.ACcodigo")>#Form.ACcodigo#</cfif>">
	<cfif not isdefined("Form.Nuevo") and (modo neq "BAJA")>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="ACid" type="hidden" value="<cfif isdefined("Form.ACid") and modo NEQ 'ALTA'>#Form.ACid#</cfif>">
	</cfif>
	<input name="Pagina2" type="hidden" value="<cfif isdefined("Form.Pagina2") and len(trim(Form.Pagina2)) and not isDefined("form.Baja")>#Form.Pagina2#<cfelse>1</cfif>">

	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<input name="ACid" type="hidden" value="#vACid#">
		</cfif>
	</cfif>
</cfoutput>
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


