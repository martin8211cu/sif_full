<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>IMPORATA CUENTAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfif isdefined("sub_cta")>

	<cfquery datasource="#Session.DSN#" name="cuentas">
	Select Ecodigo,  Cmayor ,  Cformato ,   Ccuenta ,  msg  
	from CGimportacuenta
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ccuenta < 1
	  and msg is null 
	</cfquery>

	<cfset LvarMSG = "">

	<cfloop query="cuentas">
		<cftransaction>
			<cfinvoke 
			 component="sif.Componentes.PC_GeneraCuentaFinanciera"
			 method="fnGeneraCuentaFinanciera"
			 returnvariable="LvarMSG">
				<cfinvokeargument name="Lprm_CFformato" value="#cuentas.Cformato#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#cuentas.Ecodigo#"/>
				<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
			</cfinvoke>
			
		</cftransaction>
		<cfquery name="actualiza" datasource="#Session.DSN#">
				update CGimportacuenta set msg= '#LvarMSG#' 
				where Cformato = '#cuentas.Cformato#'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfloop>

<cfelse>

	<form action="ImportaCFinanciera.cfm" method="post" name="frm_cuentas">
	
	<table>
	<tr>
		<td>Filtrar por cuenta:</td>
		<td><input type="text" name="Ncuenta" maxlength="4"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" name="sub_cta" value="GENERAR CUENTAS"></td>
	</tr>
	</table>
	
	</form>


</cfif>
</body>
</html>
