<!---<cfdump var="#Form#">
<cfabort>--->
<cftry>
	<cfquery name="SQLPagos" datasource="#Session.DSN#">
		set nocount on
		
		<cfif isDefined('Form.btnAceptar')>

			<cfif Form.modo eq "ALTA">
			
				Insert into FPagos(
					FCid, ETnumero, Mcodigo, FPtc, 
					FPmontoori, FPmontolocal, FPfechapago, Tipo, 
					FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
					FPtipotarjeta
				)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPtc#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.FPmontoori#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.FPmontolocal#">, 
					getdate(), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tipo#">, 
					<cfif Form.Tipo eq 'E'>
						null, null, null, null, null
					<cfelseif Form.Tipo eq 'T'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPdocnumero#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')#">, 
						null, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">
					<cfelseif Form.Tipo eq 'C'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.C_FPdocnumero#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.C_FPdocfecha,'YYYYMMDD')#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.C_FPBanco#">, 
						null, 
						null 
					<cfelseif Form.Tipo eq 'D'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_FPdocnumero#">, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPBanco#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPCuenta#">, 
						null
					</cfif>
				)			
			
			<cfelseif Form.modo eq "CAMBIO">

				Update FPagos 
				Set Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					FPtc=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPtc#">, 
					FPmontoori=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.FPmontoori#">, 
					FPmontolocal=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.FPmontolocal#">, 
					FPfechapago=getdate(), 
					Tipo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tipo#">, 
					<cfif Form.Tipo eq 'E'>
						FPdocnumero=null, 
						FPdocfecha=null, 
						FPBanco=null, 
						FPCuenta=null, 
						FPtipotarjeta=null
					<cfelseif Form.Tipo eq 'T'>
						FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPdocnumero#">, 
						FPdocfecha=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')#">, 
						FPBanco=null, 
						FPCuenta=null, 
						FPtipotarjeta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">
					<cfelseif Form.Tipo eq 'C'>
						FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.C_FPdocnumero#">, 
						FPdocfecha=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.C_FPdocfecha,'YYYYMMDD')#">, 
						FPBanco=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.C_FPBanco#">, 
						FPCuenta=null, 
						FPtipotarjeta=null 
					<cfelseif Form.Tipo eq 'D'>
						FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_FPdocnumero#">, 
						FPdocfecha=null, 
						FPBanco=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPBanco#">, 
						FPCuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPCuenta#">, 
						FPtipotarjeta=null
					</cfif>
				Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">

			</cfif>

		<cfelseif isDefined('Form.btnBorrar.X')>
			
			Delete from FPagos
			Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
			
		<cfelse>
			select 1
		</cfif>

		set nocount off
	</cfquery>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
</cfcatch>
</cftry>
<form action="PagosFA.cfm" method="post" name="sql">
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid") and not isDefined("Form.Borrar.X")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="ETnumero" type="hidden" value="<cfif isdefined("Form.ETnumero") and not isDefined("Form.Borrar.X")><cfoutput>#Form.ETnumero#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 
