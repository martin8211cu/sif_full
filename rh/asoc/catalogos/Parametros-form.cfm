<!--- Consultas para Parámetros Genereles --->
<!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from ACParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select Pvalor 
	from ACParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsSNegocio" datasource="#Session.DSN#">
	select b.SNcodigo, b.SNnumero, b.SNnombre
	from ACParametros a, SNegocios b
	where a.Ecodigo  = b.Ecodigo
		and a.Pvalor = <cf_dbfunction name="to_char" args="b.SNcodigo" datasource="#session.DSN#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 100
</cfquery>

<cfset PvalorPeriodo       		= ObtenerDato(10)>	<!--- Periodo Contable --->
<cfset PvalorMes        		= ObtenerDato(20)>	<!--- Mes Contable --->
<cfset PvalorFactorDiasAnio		= ObtenerDato(30)>	<!--- Factor de días del año --->
<cfset PvalorAdelantoPago  		= ObtenerDato(40)>	<!--- Orden Aplicación de Adelanto de Pago --->
<cfset PvalorCalculoDividendos 	= ObtenerDato(50)>	<!--- Metodo de Cálculo de Dividendos --->
<cfset PvalorNominaMensual	 	= ObtenerDato(60)>	<!--- Factor de Días de Nómina Mensual --->
<cfset PvalorNominaQuincenal 	= ObtenerDato(70)>	<!--- Factor de Días de Nómina Quincenal --->
<cfset PvalorNominaBisemanal 	= ObtenerDato(80)>	<!--- Factor de Días de Nómina Bisemanal --->
<cfset PvalorNominaSemanal  	= ObtenerDato(90)>	<!--- Factor de Días de Nómina Semanal --->
<cfset PvalorSocioNegocio	  	= ObtenerDato(100)>	<!--- Socio de Negocio --->
<cfset PvalorPeriodoAsociado  	= ObtenerDato(110)>	<!--- Periodo de Cálculo de Dividendos --->
<cfset PvalorMesAsociado	  	= ObtenerDato(120)>	<!--- Mes de Cálculo de Dividendos --->
<cfset PvalorCredSilva		  	= ObtenerDato(130)>	<!--- Credito Silvacano --->
<cfset PvalorCredElectro	  	= ObtenerDato(140)>	<!--- Crédito Electrodomesticos --->
<cfset PvalorPeriodoInt  		= ObtenerDato(150)>	<!--- Periodo de Cálculo de Dividendos --->
<cfset PvalorMesInt	  			= ObtenerDato(160)>	<!--- Mes de Cálculo de Dividendos --->


<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<!--- Archivo con las Variables de Traducción --->
<cfinclude template="Parametros-etiquetas.cfm">

<cfoutput>	
<table width="100%" cellpadding="2" cellspacing="0" style="vertical-align:top; ">
	<tr>
		<td valign="top">
			<form name="form1" method="post" action="Parametros-sql.cfm" style="margin:0; ">			
				
				<cf_tabs width="100%" onclick="tab_set_current_param">
					<cf_tab text="#TAB_Parametros#">
						<cfinclude template="Parametros-tab.cfm">
					</cf_tab>
				</cf_tabs>
				
			</form>
		</td>
	</tr>
</table>
</cfoutput>
