<cfparam name="action" default="listaFormatos.cfm">
 
		<!--- ==================================================== --->
		<!--- Valida la existencia del archivo de formato estatico --->
		<cfif isdefined("form.btnModificar") or isdefined("form.btnAgregar")>
			<cfif listfind('0,1,4', form.FMT01tipfmt) gt 0 >
				<cfset LvarFMT01cfccfm = trim(form.FMT01cfccfm)>


				<!--- ================================================================ --->
				<!--- Valida extension del archivo, para no grabar datos incongruentes --->
				<!--- tipo:0 Jasper--->
				<cfif form.FMT01tipfmt eq 0 >
					<cfif not len(LvarFMT01cfccfm)>
						<cfthrow message="No se especifico el Archivo del formato">
					</cfif>
					<cfset extension = mid(LvarFMT01cfccfm, len(LvarFMT01cfccfm)-5, 6 ) >
					<cfif trim(ucase(extension)) neq 'JASPER' >
						<cf_errorCode	code = "50022" msg = "La extensión del archivo no corresponde al tipo de formato definido (jasper).">
					</cfif>
				<cfelseif form.FMT01tipfmt eq 4 >
					<cfif not len(LvarFMT01cfccfm)>
						<cfthrow message="No se especifico el Archivo del formato">
					</cfif>
					<cfset extension = mid(LvarFMT01cfccfm, len(LvarFMT01cfccfm)-2, 3 ) >
					<cfif trim(ucase(extension)) neq 'CFR' >
						<cf_errorCode	code = "50023" msg = "La extensión del archivo no corresponde al tipo de formato definido (cfr).">
					</cfif>
				</cfif>
				<!--- ================================================================ --->

				<cfinclude template="../../Utiles/validaUri.cfm">
				<cfset LvarOK = validarUrl(LvarFMT01cfccfm) >
				<!--- Si es formato jasper, puede ser de dos formas: 
					1. Que hay aindicado archivo .jasper a ejecutar
					2. Que haya usado el reporteador de formato s de impresion y hay adefinido el reporte ahi.
					
					Por eso cuando es jasper no se valida la existencia del archivo, pues puede que no la tenga.
				 --->
				<cfif form.FMT01tipfmt eq 0 and len(trim(form.FMT01cfccfm)) eq 0 >
					<cfset LvarOK = true >
				</cfif>
				
				<cfif not LvarOK ><cf_errorCode	code = "50024"
				                  				msg  = "No existe el archivo indicado para el formato japser/estático/coldfusion: @errorDat_1@"
				                  				errorDat_1="#LvarFMT01cfccfm#"
				                  ></cfif>
			</cfif>
		</cfif>
		<!--- ==================================================== --->

		<!--- Caso 1: Agregar Encabezado ---> 
		<cfif isdefined("form.btnAgregar")>
			<cfquery name="insert_FMT001" datasource="#session.DSN#">
				insert into FMT001 ( FMT01COD, Ecodigo, FMT01DES, FMT01TOT, FMT01LIN, FMT01DET, FMT01PDT, FMT01USR, FMT01FEC, FMT01LAR,
									 FMT01ANC, FMT01ORI, FMT01LFT, FMT01RGT, FMT01TOP, FMT01BOT, FMT01SPC, FMT01CPS, 
									 FMT01COP, FMT01PRV, FMT01TIP, FMT01ENT, FMT01REF, FMT01SP1, FMT01SP2, FMT01tipfmt, FMT01cfccfm
									 <cfif len(trim(form.FMT01imgfpre))>,FMT01imgfpre</cfif>
								)
					values(
						<cf_jdbcquery_param value="#rtrim(form.FMT01COD)#"   cfsqltype="cf_sql_varchar" LEN="10">,
						<cf_jdbcquery_param value="#session.Ecodigo#" cfsqltype="cf_sql_integer" null="#IsDefined('form.esglobal')#"  >,
						<cf_jdbcquery_param value="#form.FMT01DES#"   cfsqltype="cf_sql_varchar" LEN="50">,
						<cf_jdbcquery_param value="#form.FMT01TOT#"   cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01LIN#"   cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01DET#"   cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01PDT#"   cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01USR#"   cfsqltype="cf_sql_varchar" LEN="50">,
						<cfif Len(Trim(form.FMT01FEC)) gt 0>
							<cf_jdbcquery_param value="#LSParseDateTime(form.FMT01FEC)#" cfsqltype="cf_sql_timestamp">
						<cfelse>
							<cf_jdbcquery_param value="#Now()#" cfsqltype="cf_sql_timestamp">
						</cfif>,
						<cf_jdbcquery_param value="#form.FMT01LAR#"   cfsqltype="cf_sql_money"   >,
						<cf_jdbcquery_param value="#form.FMT01ANC#"   cfsqltype="cf_sql_money"   >,
						<cf_jdbcquery_param value="#form.FMT01ORI#"   cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01LFT#"   cfsqltype="cf_sql_float"   >,
						<cf_jdbcquery_param value="#form.FMT01RGT#"   cfsqltype="cf_sql_float"   >,
						<cf_jdbcquery_param value="#form.FMT01TOP#"   cfsqltype="cf_sql_float"   >,
						<cf_jdbcquery_param value="#form.FMT01BOT#"   cfsqltype="cf_sql_float"   >,
						<cf_jdbcquery_param value="#form.FMT01SPC#"   cfsqltype="cf_sql_float"   >,
						<cf_jdbcquery_param value="1"                 cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="1"                 cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="1"                 cfsqltype="cf_sql_integer" >,
						<cf_jdbcquery_param value="#form.FMT01TIP#"   cfsqltype="cf_sql_integer" >,
						<cfif isdefined("form.FMT01ENT")>1<cfelse>0</cfif>,
						<cfif len(trim(form.FMT01REF)) gt 0>'#form.FMT01REF#'<cfelse>'#session.Ecodigo#'</cfif>,
						'YA NO SE USA', 'YA NO SE USA',
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.FMT01tipfmt#">,
						<cfif listfind('0,1,4', form.FMT01tipfmt) gt 0 and isdefined("LvarFMT01cfccfm")><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarFMT01cfccfm)#" null="#len(trim(LvarFMT01cfccfm)) is 0#"><cfelse>null</cfif>
						<cfif len(trim(form.FMT01imgfpre))>,<cf_dbupload filefield="FMT01imgfpre"></cfif>
					)
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "EFormatosImpresion.cfm">
			
		<!--- Caso 2: Borrar un Encabezado --->
		<cfelseif isdefined("Form.btnEliminar")>
			
			<cfquery datasource="#session.DSN#">			
				delete from FMT009 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT006 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT005 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT004 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT003 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT002 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from FMT001 
				where (Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> or Ecodigo is null)
				  and FMT01COD  = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>	
		  	<cfset modo="ALTA">
			  
		<!--- Caso 3: Modificar el encabezado --->
		<cfelseif isdefined("form.btnModificar")>
			<cfquery name="update_FMT001" datasource="#session.DSN#">
				update FMT001
				set	FMT01DES  = <cfqueryparam  value="#form.FMT01DES#"   cfsqltype="cf_sql_varchar" >,
					FMT01TOT  = <cfqueryparam    value="#form.FMT01TOT#"   cfsqltype="cf_sql_integer" >,
					FMT01LIN  = <cfqueryparam value="#form.FMT01LIN#"   cfsqltype="cf_sql_integer"  >,
					FMT01DET  = <cfqueryparam value="#form.FMT01DET#"   cfsqltype="cf_sql_integer" >,
					FMT01PDT  = <cfqueryparam value="#form.FMT01PDT#"   cfsqltype="cf_sql_integer" >,
					FMT01USR  = <cfqueryparam value="#form.FMT01USR#"   cfsqltype="cf_sql_varchar" >,
					FMT01FEC  = <cfqueryparam value="#LSParseDateTime(form.FMT01FEC)#" cfsqltype="cf_sql_timestamp">,
					FMT01LAR  = <cfqueryparam value="#form.FMT01LAR#"   cfsqltype="cf_sql_money"   >,
					FMT01ANC  = <cfqueryparam value="#form.FMT01ANC#"   cfsqltype="cf_sql_money"   >,
					FMT01ORI  = <cfqueryparam value="#form.FMT01ORI#"   cfsqltype="cf_sql_integer" >,
					FMT01LFT  = <cfqueryparam value="#form.FMT01LFT#"   cfsqltype="cf_sql_float"   >,
					FMT01RGT  = <cfqueryparam value="#form.FMT01RGT#"   cfsqltype="cf_sql_float"   >,
					FMT01TOP  = <cfqueryparam value="#form.FMT01TOP#"   cfsqltype="cf_sql_float"   >,
					FMT01BOT  = <cfqueryparam value="#form.FMT01BOT#"   cfsqltype="cf_sql_float"   >,
					FMT01SPC  = <cfqueryparam value="#form.FMT01SPC#"   cfsqltype="cf_sql_float"   >,
					FMT01CPS  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01COP  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01PRV  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01TIP  = <cfqueryparam value="#form.FMT01TIP#"   cfsqltype="cf_sql_integer" >,
					FMT01ENT  = <cfif isdefined("form.FMT01ENT")>1<cfelse>0</cfif>,
					FMT01REF  = <cfif len(trim(form.FMT01REF)) gt 0>'#form.FMT01REF#'<cfelse>'#session.Ecodigo#'</cfif>,
					FMT01tipfmt = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT01tipfmt#">,
					FMT01cfccfm = <cfif listfind('0,1,4', form.FMT01tipfmt) gt 0 and isdefined("LvarFMT01cfccfm") ><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarFMT01cfccfm)#" null="#len(trim(LvarFMT01cfccfm)) is 0#"><cfelse>null</cfif>,
					Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" null="#IsDefined('form.esglobal')#">
					<cfif len(trim(form.FMT01imgfpre))>,FMT01imgfpre = <cf_dbupload filefield="FMT01imgfpre"></cfif>
                    , FMT01COD = rtrim(FMT01COD)

				where FMT01COD  = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				  and (Ecodigo is null or Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >)
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "EFormatosImpresion.cfm">
		</cfif> 

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"     type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="FMT01COD" type="hidden" value="<cfif isdefined("form.FMT01COD")>#form.FMT01COD#</cfif>">
	<input name="Pagina"   type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

