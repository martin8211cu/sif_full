<cfparam name="action" default="CierreCaja.cfm">

<!---  Crea un query de Monedas, pues pueden venir repetidas en form.Mcodigo, la idea es trabajar
	   una sola vez con una moneda	especifica --->
<cfset rsMonedas = QueryNew("Mcodigo")>
<cfloop index="i" list="#form.Mcodigo#" delimiters=",">
	<cfset fila = QueryAddRow(rsMonedas, 1)>
	<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #i#) >
</cfloop>	
<cfquery name="rsMonedas2" dbtype="query">
	select distinct Mcodigo from rsMonedas
</cfquery>

<cfif isdefined("form.btnCerrar") or isdefined("form.btnCancelar")  >
	<cftransaction>
		<cftry>
			<cfif isdefined("form.btnCerrar")>
					<!--- proceso de datos por moneda --->
					<cfloop query="rsMonedas2">
						<cfset i = rsMonedas2.Mcodigo >
						<!--- crea los nombres de los objetos --->
						<cfif isdefined("form.FADCfcreditosis_"  & i)><cfset FADCfcreditosis  = Evaluate("form.FADCfcreditosis_"  & i ) ><cfelse><cfset FADCfcreditosis  = 0 ></cfif>
						<cfif isdefined("form.FADCncreditosis_"  & i)><cfset FADCncreditosis  = Evaluate("form.FADCncreditosis_"  & i ) ><cfelse><cfset FADCncreditosis  = 0 ></cfif>
						<cfif isdefined("form.FADCefectivosis_"  & i)><cfset FADCefectivosis  = Evaluate("form.FADCefectivosis_"  & i)  ><cfelse><cfset FADCefectivosis  = 0 ></cfif>
						<cfif isdefined("form.FADCchequessis_"   & i)><cfset FADCchequessis   = Evaluate("form.FADCchequessis_"   & i ) ><cfelse><cfset FADCchequessis   = 0 ></cfif>
						<cfif isdefined("form.FADCvoucherssis_"  & i)><cfset FADCvoucherssis  = Evaluate("form.FADCvoucherssis_"  & i ) ><cfelse><cfset FADCvoucherssis  = 0 ></cfif>
						<cfif isdefined("form.FADCdepositossis_" & i)><cfset FADCdepositossis = Evaluate("form.FADCdepositossis_" & i ) ><cfelse><cfset FADCdepositossis = 0 ></cfif>
						<cfif isdefined("form.FADCcontadosis_" & i)><cfset FADCcontadosis = Evaluate("form.FADCcontadosis_" & i ) ><cfelse><cfset FADCcontadosis = 0 ></cfif>
						
						<!--- update al tabla de cierres para actualizar los datos --->
						<cfquery name="sql_dcierre" datasource="#session.DSN#">
							set nocount on
							update FADCierres 
							set FADCcontadosis     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcontadosis#">, 
								FADCefectivosis    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCefectivosis#">, 
								FADCchequessis     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCchequessis#">, 
								FADCvoucherssis    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCvoucherssis#">, 
								FADCdepositossis   = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdepositossis#">, 
								FADCfcreditosis    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCfcreditosis#">,
								FADCncreditosis    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCncreditosis#">,
								FADCdiferencias    = 0
							where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
							  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
							set nocount off
						</cfquery>
					</cfloop>
					
					<!--- asigna el id de cierre a las transacciones procesadas --->
					<cfquery name="sql_ecierre" datasource="#session.DSN#">
						set nocount on
						update FACierres
						set FACestado = 'A'
						where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						set nocount off  
					</cfquery>	
		
					<!--- asigna el id de cierre a las transacciones procesadas --->
					<cfquery name="sql_transacciones" datasource="#session.DSN#">
						set nocount on
						update ETransacciones
						set FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
						where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
						  and ETestado = 'T'
						set nocount off  
					</cfquery>
			<cfelse>
				<!--- asigna el id de cierre a las transacciones procesadas --->
				<cfquery name="sql_transacciones" datasource="#session.DSN#">
					set nocount on
					update FACierres
					set FACestado = 'P'
					where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					set nocount off  
				</cfquery>
			</cfif>
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	<cftransaction>
</cfif>	

<cfoutput>
<form action="CalculoCierreSis.cfm" method="post" name="sql">
	<input type="hidden" name="FCid" value="-1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>