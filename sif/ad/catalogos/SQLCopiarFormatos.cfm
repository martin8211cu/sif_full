 
<cftransaction>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.btnCopiar")>
			<cfquery name="iformato" datasource="#session.DSN#">
				-- inserta encabezado de formato	
				insert into FMT001( FMT01COD, Ecodigo, FMT01DES, FMT01TOT, FMT01LIN, FMT01DET, FMT01PDT, FMT01USR, FMT01FEC, FMT01LAR, 
							   FMT01ANC, FMT01ORI, FMT01LFT, FMT01RGT, FMT01TOP, FMT01BOT, FMT01SPC, FMT01CPS, FMT01SP1, FMT01SP2, 
							   FMT01COP, FMT01HTM, FMT01NP1, FMT01NP2, FMT01NP3, FMT01NP4, FMT01NP5, FMT01INP, FMT01ML1, FMT01ML2, 
							   FMT01IML, FMT01ICB, FMT01CB1, FMT01CB2, FMT01CBH, FMT01CBW, FMT01TCB, FMT01TPL, FMT01TAM, FMT01BOL, 
							   FMT01UND, FMT01ITA, FMT01AJU, FMT01LON, FMT01PRV, FMT01TIP, FMT01ENT, FMT01GRD,
							   FMT01REF, FMT01SQL, BMUsucodigo, FMT01cfccfm, FMT01imgfpre, FMT01tipfmt, FMT01TXT)
				select '#trim(form.dFMT01COD)#', 
					   #form.Ecodigo#, FMT01DES, FMT01TOT, FMT01LIN, FMT01DET, FMT01PDT, FMT01USR, FMT01FEC, FMT01LAR, FMT01ANC, FMT01ORI, 
					   FMT01LFT, FMT01RGT, FMT01TOP, FMT01BOT, FMT01SPC, FMT01CPS, FMT01SP1, FMT01SP2, FMT01COP, FMT01HTM, FMT01NP1, 
					   FMT01NP2, FMT01NP3, FMT01NP4, FMT01NP5, FMT01INP, FMT01ML1, FMT01ML2, FMT01IML, FMT01ICB, FMT01CB1, FMT01CB2, 
					   FMT01CBH, FMT01CBW, FMT01TCB, FMT01TPL, FMT01TAM, FMT01BOL, FMT01UND, FMT01ITA, FMT01AJU, FMT01LON, FMT01PRV, 
					   FMT01TIP, FMT01ENT, FMT01GRD,
					   FMT01REF, FMT01SQL, BMUsucodigo, FMT01cfccfm, FMT01imgfpre, FMT01tipfmt, FMT01TXT
				from FMT001
				where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and FMT01COD  = <cfqueryparam value="#form.FMT01COD#"   cfsqltype="cf_sql_varchar"  >	
			</cfquery>
			<cfquery name="iformato" datasource="#session.DSN#">
				-- inserta detalle de formato
				insert into FMT002 ( FMT01COD, FMT02LIN, FMT02CAM, FMT02DES, FMT02LON, FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM, FMT02FIL, FMT02COL, FMT02AJU, FMT02POS, FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS, FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL, FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG, FMT02CLR, FMT07NIV, FMT11NOM)
				select '#trim(form.dFMT01COD)#', FMT02LIN, FMT02CAM, FMT02DES, FMT02LON, FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM, FMT02FIL, FMT02COL, FMT02AJU, FMT02POS, FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS, FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL, FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG, FMT02CLR, FMT07NIV, FMT11NOM
				from FMT002 a, FMT001 b
				where a.FMT01COD=<cfqueryparam value="#form.FMT01COD#"    cfsqltype="cf_sql_varchar" >
				  and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and a.FMT01COD=b.FMT01COD
			</cfquery>
			<cfquery name="iformato" datasource="#session.DSN#">
				  
				-- inserta las lineas
				insert into FMT009 ( FMT01COD, FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR, FMT09HEI, FMT09WID, FMT09GRS, FMT09CFN )
				select '#trim(form.dFMT01COD)#', FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR, FMT09HEI, FMT09WID, FMT09GRS, FMT09CFN
				from FMT009 a, FMT001 b
				where a.FMT01COD=<cfqueryparam value="#form.FMT01COD#"    cfsqltype="cf_sql_varchar" >
				  and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and a.FMT01COD=b.FMT01COD
			</cfquery>
			<cfquery name="iformato" datasource="#session.DSN#">
				  
				-- inserta imagenes
				insert into FMT003 ( FMT01COD, FMT03LIN, FMT03IMG, FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR, FMT03EMP )
				select '#trim(form.dFMT01COD)#', FMT03LIN, FMT03IMG, FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR, FMT03EMP
				from FMT003 a, FMT001 b
				where a.FMT01COD=<cfqueryparam value="#form.FMT01COD#"    cfsqltype="cf_sql_varchar" >
				  and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and a.FMT01COD=b.FMT01COD
			</cfquery>
		</cfif>
</cftransaction>

<cfoutput>
<form action="CopiarFormatos.cfm" method="post" name="sql">
	<input name="estado"   type="hidden" value="true">
	<input name="sqlFMT01COD" type="hidden" value="<cfif isdefined("form.dFMT01COD")>#form.dFMT01COD#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>