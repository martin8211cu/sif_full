<cfparam name="action" default="DFormatosImpresion.cfm">

	<cftry>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("form.btnAgregar")>
			<cfquery name="insert_FMT002" datasource="emperador">

				set nocount on
				insert FMT002 ( FMT01COD, FMT02LIN, FMT02DES, FMT02LON, FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM, 
								FMT02FIL, FMT02COL, FMT02AJU, FMT02POS, FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS, 
								FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL, FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG, 
								FMT02CLR, FMT07NIV, FMT02CAM 
							  )
					values(
						<cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_char"    >,
						<cfqueryparam value="#form.FMT02LIN#" cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT02DES#" cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#form.FMT02LON#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT02DEC#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT02FMT#"   cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#form.FMT02TPL#"   cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#form.FMT02TAM#"   cfsqltype="cf_sql_tinyint" >,
						<cfqueryparam value="#form.FMT02FIL#"   cfsqltype="cf_sql_float"   >,
						<cfqueryparam value="#form.FMT02COL#"   cfsqltype="cf_sql_float"   >,
						<cfif isdefined("form.FMT02AJU")>1<cfelse>0</cfif>,
						<cfqueryparam value="#form.FMT02POS#"   cfsqltype="cf_sql_char" >,
						<cfqueryparam value="#form.FMT02JUS#"   cfsqltype="cf_sql_tinyint" >,
						<cfqueryparam value="#form.FMT02PRE#"   cfsqltype="cf_sql_char" >,
						<cfqueryparam value="#form.FMT02SUF#"   cfsqltype="cf_sql_char" >,
						<cfif isdefined("form.FMT02STS")>1<cfelse>0</cfif>,
						<cfqueryparam value="#form.FMT02TIP#"   cfsqltype="cf_sql_tinyint" >,
						<cfqueryparam value="#form.FMT02SPC#"   cfsqltype="cf_sql_bit" >,
						<cfqueryparam value="#form.FMT02SQL#"   cfsqltype="cf_sql_integer" >,
						<cfif isdefined("form.FMT02BOL")>1<cfelse>0</cfif>,
						<cfif isdefined("form.FMT02UND")>1<cfelse>0</cfif>,
						<cfif isdefined("form.FMT02ITA")>1<cfelse>0</cfif>,
						<cfif isdefined("form.FMT02TOT")>1<cfelse>0</cfif>,
						<cfif isdefined("form.FMT02PAG")>1<cfelse>0</cfif>,
						upper( <cfqueryparam value="#form.FMT02CLR#"   cfsqltype="cf_sql_char" > ),
						<cfqueryparam value="#form.FMT07NIV#"   cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#form.FMT02CAM#"   cfsqltype="cf_sql_varchar" >
					)				  
				set nocount off	
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "DFormatosImpresion.cfm">
			
		<!--- Caso 2: Borrar un Encabezado --->
		<cfelseif isdefined("Form.btnEliminar")>
			
			<cfquery name="delete_FMT002" datasource="emperador">			
				set nocount on
				delete FMT002 
				where FMT02LIN = <cfqueryparam value="#form.FMT02LIN#" cfsqltype="cf_sql_integer" >
				  and FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_varchar"  >	
				set nocount off
			</cfquery>	
		  	<cfset modo="ALTA">
			  
		<!--- Caso 3: Modificar el encabezado --->
		<cfelseif isdefined("form.btnModificar")>
			<cfquery name="update_FMT002" datasource="emperador">
				set nocount on
				update FMT002
				   set FMT02CAM = <cfqueryparam value="#form.FMT02CAM#" cfsqltype="cf_sql_varchar" >
					  ,FMT02DES = <cfqueryparam value="#form.FMT02DES#" cfsqltype="cf_sql_varchar" >
					  ,FMT02LON = <cfqueryparam value="#form.FMT02LON#"   cfsqltype="cf_sql_integer" >
					  ,FMT02DEC = <cfqueryparam value="#form.FMT02DEC#"   cfsqltype="cf_sql_integer" >
					  ,FMT02FMT = <cfqueryparam value="#form.FMT02FMT#"   cfsqltype="cf_sql_varchar" >
					  ,FMT02TPL = <cfqueryparam value="#form.FMT02TPL#"   cfsqltype="cf_sql_varchar" >
					  ,FMT02TAM = <cfqueryparam value="#form.FMT02TAM#"   cfsqltype="cf_sql_tinyint" >
					  ,FMT02FIL = <cfqueryparam value="#form.FMT02FIL#"   cfsqltype="cf_sql_float"   >
					  ,FMT02COL = <cfqueryparam value="#form.FMT02COL#"   cfsqltype="cf_sql_float"   >
					  ,FMT02AJU = <cfif isdefined("form.FMT02AJU")>1<cfelse>0</cfif>
					  ,FMT02POS = <cfqueryparam value="#form.FMT02POS#"   cfsqltype="cf_sql_char" >
					  ,FMT02JUS = <cfqueryparam value="#form.FMT02JUS#"   cfsqltype="cf_sql_tinyint" >
					  ,FMT02PRE = <cfqueryparam value="#form.FMT02PRE#"   cfsqltype="cf_sql_char"   >
					  ,FMT02SUF = <cfqueryparam value="#form.FMT02SUF#"   cfsqltype="cf_sql_char"   >
					  ,FMT02TIP = <cfqueryparam value="#form.FMT02TIP#"   cfsqltype="cf_sql_tinyint" >
					  ,FMT02SPC = <cfqueryparam value="#form.FMT02SPC#"   cfsqltype="cf_sql_bit" >
					  ,FMT02SQL = <cfqueryparam value="#form.FMT02SQL#"   cfsqltype="cf_sql_integer" >
					  ,FMT02CLR = upper( <cfqueryparam value="#form.FMT02CLR#"   cfsqltype="cf_sql_char" > )
					  ,FMT07NIV = <cfqueryparam value="#form.FMT07NIV#"   cfsqltype="cf_sql_integer" >
					 <cfif isdefined("form.FMT02STS")>, FMT02STS = 1<cfelse>, FMT02STS = 0</cfif>
					 <cfif isdefined("form.FMT02BOL")>, FMT02BOL = 1<cfelse>, FMT02BOL = 0</cfif>
					 <cfif isdefined("form.FMT02UND")>, FMT02UND = 1<cfelse>, FMT02UND = 0</cfif>
					 <cfif isdefined("form.FMT02ITA")>, FMT02ITA = 1<cfelse>, FMT02ITA = 0</cfif>
					 <cfif isdefined("form.FMT02TOT")>, FMT02TOT = 1<cfelse>, FMT02TOT = 0</cfif>
					 <cfif isdefined("form.FMT02PAG")>, FMT02PAG = 1<cfelse>, FMT02PAG = 0</cfif>
				   where FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_char"    >
					 and FMT02LIN = <cfqueryparam value="#form.FMT02LIN#" cfsqltype="cf_sql_integer" >
					 and timestamp = convert(varbinary,#lcase(form.timestamp)#)
				set nocount off
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "DFormatosImpresion.cfm">

		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="FMT01COD" type="hidden" value="<cfif isdefined("form.FMT01COD")>#form.FMT01COD#</cfif>">
	<input name="Pagina"   type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<input name="FMT02LIN" type="hidden" value="<cfif isdefined("form.FMT02LIN")>#form.FMT02LIN#</cfif>">
		<input name="MODO"     type="hidden" value="CAMBIO">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
