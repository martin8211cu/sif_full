<cfparam name="url.formulario" default="form1">
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">

<cfif isdefined("Url.Empresas")>
	<cfset Form.Empresas = #Url.Empresas#>
<cfelse>
	<cfset Form.Empresas = #session.Ecodigo#>
</cfif>

<cfquery name="rsValidar" datasource="#session.DSN#">
	Select EOidorden, EOnumero, Observaciones
    from EOrdenCM 
    where EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.NumeroOC#">
    and Ecodigo in (#Form.Empresas#)
</cfquery>

<cfset index = 1>
<cfif url.opcion eq 2>
	<cfset index = 2>
</cfif>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif rsValidar.recordCount gt 0>
			window.parent.document.#url.formulario#.IDOC#index#.value = #rsValidar.EOnumero#;
			window.parent.document.#url.formulario#.NumeroOC#index#.value = '#trim(rsValidar.EOnumero)#';
			window.parent.document.#url.formulario#.ObservacionOC#index#.value = '#trim(rsValidar.Observaciones)#';
		<cfelse>
			window.parent.document.#url.formulario#.IDOC#index#.value = "#url.NumeroOC#";
			window.parent.document.#url.formulario#.ObservacionOC#index#.value = "No Existe la Orden de Compra";
		</cfif>
	</script>
</cfoutput>