<cfinvoke key="LB_Archivo" 			default="EstadoDeResultados" 	returnvariable="LB_Archivo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="EstadoResultados-result.xml"/>
<cfinvoke key="LB_Titulo" 			default="Estado De Resultados - Conversión de Moneda" 	returnvariable="LB_Titulo" 		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CMB_Mes" 			default="Mes" 		returnvariable="CMB_Mes" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

<cfif isdefined("url.periodo")>
	<cfparam name="Form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfparam name="Form.mes" default="#url.mes#">
</cfif>

<cfset varTC = 1>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
    select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
    from Empresas a, Monedas b 
    where a.Ecodigo = #Session.Ecodigo#
      and a.Mcodigo = b.Mcodigo
</cfquery>

<cfif rsMonedaLocal.Mcodigo neq Form.Mcodigo>
    <cfquery datasource="#Session.DSN#" name="rsTC">	
        select Mcodigo,TCtipocambio from TipoCambioReporte
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and TCperiodo = #Form.periodo# and TCmes = #Form.mes# and Mcodigo = #form.Mcodigo#
    </cfquery>
    <cfif rsTC.recordCount eq 0>
        <cfset MSG_TipoCambio = t.Translate('MSG_TipoCambio','No está definido el Tipo de Cambio para el periodo')>
        <cf_errorCode code = "50194" msg = "#MSG_TipoCambio# #Form.periodo# #CMB_Mes# #Form.mes#">
        <cfabort>
    </cfif>  
    <cfset varTC = #rsTC.TCtipocambio#>
<cfelse>
	<cfset varTC = 1>
</cfif>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<style type="text/css">
				#printerIframe {
		  			position: absolute;
		  			width: 0px; height: 0px;
		 			border-style: none;
		  			/* visibility: hidden; */
				}
			</style>
            
<!---			<cfif isdefined("form.ADMIN") and form.ADMIN eq 'S'>
				<cfset LvarIr  = 'EstadoResultadosAdmin.cfm'>
			<cfelse>
				<cfif isdefined("LvarInfo")>
					<cfset LvarIr = 'EstadoResultados_INFO.cfm'>
				<cfelse>
					<cfset LvarIr = 'EstadoResCM.cfm'>
				</cfif>
			</cfif>
--->            
            <cfset LvarIr = 'EstadoResCM.cfm'>
			<cfif not isDefined("form.toExcel")>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>
				<cfset LvarFileName = "#LB_Archivo##Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
				<cf_htmlReportsHeaders 
					title="#LB_Titulo#" 
					filename="#LvarFileName#"
					irA="#LvarIr#" 
					>									
			</cfif>
			<cfinclude template="EstadoResCM-form.cfm">
		</td>	
	</tr>
</table>



					