<cfparam name="action" default="listaFormatos.cfm">

	<cftry>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("form.btnAgregar")>
			<cfquery name="insert_FMT001" datasource="emperador">
				set nocount on
				insert FMT001 ( FMT01COD, Ecodigo, FMT01DES, FMT01TOT, FMT01LIN, FMT01DET, FMT01PDT, FMT01USR, FMT01FEC, FMT01LAR,
								FMT01ANC, FMT01ORI, FMT01LFT, FMT01RGT, FMT01TOP, FMT01BOT, FMT01SPC, FMT01CPS, 
								FMT01SP1, FMT01SP2, FMT01COP, FMT01PRV, FMT01TIP, FMT01ENT, FMT01REF )
					values(
						<cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"  >,
						<cfqueryparam value="#form.FMT01DES#"   cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#form.FMT01TOT#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01LIN#"   cfsqltype="cf_sql_integer"  >,
						<cfqueryparam value="#form.FMT01DET#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01PDT#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01USR#"   cfsqltype="cf_sql_varchar" >,
						<cfif Len(Trim(form.FMT01FEC)) gt 0>convert( datetime, <cfqueryparam value="#form.FMT01FEC#" cfsqltype="cf_sql_varchar">, 103 )<cfelse>getDate()</cfif>,
						<cfqueryparam value="#form.FMT01LAR#"   cfsqltype="cf_sql_money"   >,
						<cfqueryparam value="#form.FMT01ANC#"   cfsqltype="cf_sql_money"   >,
						<cfqueryparam value="#form.FMT01ORI#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01LFT#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="#form.FMT01RGT#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="#form.FMT01TOP#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="#form.FMT01BOT#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="#form.FMT01SPC#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01SP1#"   cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#form.FMT01SP2#"   cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT01TIP#"   cfsqltype="cf_sql_integer" >,
						<cfif isdefined("form.FMT01ENT")>1<cfelse>0</cfif>,
						<cfif len(trim(form.FMT01REF)) gt 0>'#form.FMT01REF#'<cfelse>'#session.Ecodigo#'</cfif>
					)
				set nocount off
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "EFormatosImpresion.cfm">
			
		<!--- Caso 2: Borrar un Encabezado --->
		<cfelseif isdefined("Form.btnEliminar")>
			
			<cfquery name="delete_FMT001" datasource="emperador">			
				set nocount on
				delete FMT009 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				delete FMT006 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				delete FMT005 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				delete FMT004 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				delete FMT003 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				delete FMT002 where FMT01COD = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	

				delete FMT001 
				where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and FMT01COD  = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				set nocount off
			</cfquery>	
		  	<cfset modo="ALTA">
			  
		<!--- Caso 3: Modificar el encabezado --->
		<cfelseif isdefined("form.btnModificar")>
			<cfquery name="update_FMT001" datasource="emperador">
				set nocount on
				update FMT001
				set	FMT01DES  = <cfqueryparam  value="#form.FMT01DES#"   cfsqltype="cf_sql_varchar" >,
					FMT01TOT  = <cfqueryparam    value="#form.FMT01TOT#"   cfsqltype="cf_sql_integer" >,
					FMT01LIN  = <cfqueryparam value="#form.FMT01LIN#"   cfsqltype="cf_sql_integer"  >,
					FMT01DET  = <cfqueryparam value="#form.FMT01DET#"   cfsqltype="cf_sql_integer" >,
					FMT01PDT  = <cfqueryparam value="#form.FMT01PDT#"   cfsqltype="cf_sql_integer" >,
					FMT01USR  = <cfqueryparam value="#form.FMT01USR#"   cfsqltype="cf_sql_varchar" >,
					FMT01FEC  = convert( datetime, <cfqueryparam value="#form.FMT01FEC#" cfsqltype="cf_sql_varchar">, 103 ),
					FMT01LAR  = <cfqueryparam value="#form.FMT01LAR#"   cfsqltype="cf_sql_money"   >,
					FMT01ANC  = <cfqueryparam value="#form.FMT01ANC#"   cfsqltype="cf_sql_money"   >,
					FMT01ORI  = <cfqueryparam value="#form.FMT01ORI#"   cfsqltype="cf_sql_integer" >,
					FMT01LFT  = <cfqueryparam value="#form.FMT01LFT#"   cfsqltype="cf_sql_float"   >,
					FMT01RGT  = <cfqueryparam value="#form.FMT01RGT#"   cfsqltype="cf_sql_float"   >,
					FMT01TOP  = <cfqueryparam value="#form.FMT01TOP#"   cfsqltype="cf_sql_float"   >,
					FMT01BOT  = <cfqueryparam value="#form.FMT01BOT#"   cfsqltype="cf_sql_float"   >,
					FMT01SPC  = <cfqueryparam value="#form.FMT01SPC#"   cfsqltype="cf_sql_float"   >,
					FMT01CPS  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01SP1  = <cfqueryparam value="#form.FMT01SP1#"   cfsqltype="cf_sql_varchar" >,
					FMT01SP2  = <cfqueryparam value="#form.FMT01SP2#"   cfsqltype="cf_sql_varchar" >,
					FMT01COP  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01PRV  = <cfqueryparam value="1"                 cfsqltype="cf_sql_integer" >,
					FMT01TIP  = <cfqueryparam value="#form.FMT01TIP#"   cfsqltype="cf_sql_integer" >,
					FMT01ENT  = <cfif isdefined("form.FMT01ENT")>1<cfelse>0</cfif>,
					FMT01REF  = <cfif len(trim(form.FMT01REF)) gt 0>'#form.FMT01REF#'<cfelse>'#session.Ecodigo#'</cfif> 
				where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and FMT01COD  = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
				  and timestamp = convert(varbinary,#lcase(form.timestamp)#)
				set nocount off
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "EFormatosImpresion.cfm">
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

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
