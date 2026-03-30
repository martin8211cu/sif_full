<!--- Se define un tiempo maximo de 15 minutos para generar la consulta o reporte --->
<cfsetting requesttimeout="900">

<cfparam name="form.periodo" type="integer" default="0">
<cfparam name="form.periodo2" type="integer" default="0">
<cfparam name="form.mes" type="integer" default="0">
<cfparam name="form.mes2" type="integer" default="0">
<cfparam name="form.Mcodigo" type="integer" default="0">
<cfparam name="form.Ocodigo" type="integer" default="0">
<cfparam name="form.CHKMesCierre" type="integer" default="0">

<cf_navegacion name="periodo" navegacion="">
<cf_navegacion name="mes" navegacion="">
<cf_navegacion name="periodo2" navegacion="">
<cf_navegacion name="mes2" navegacion="">
<cf_navegacion name="Cmayor_Ccuenta1" navegacion="">
<cf_navegacion name="Cformato1" navegacion="">
<cf_navegacion name="Cmayor_Ccuenta2" navegacion="">
<cf_navegacion name="Cformato2" navegacion="">
<cf_navegacion name="mcodigoopt" navegacion="">
<cf_navegacion name="Ocodigo" navegacion="">
<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
	<cf_navegacion name="ckOrdenXMonto" navegacion="">
</cfif>
<cf_navegacion name="mcodigo" navegacion="">
<cf_navegacion name="Ccuenta1" navegacion="">
<cf_navegacion name="Ccuenta2" navegacion="">
<cf_navegacion name="CFcuenta1" navegacion="">
<cf_navegacion name="CFcuenta2" navegacion="">
<cf_navegacion name="cmayor_ccuenta1_id" navegacion="">
<cf_navegacion name="cmayor_ccuenta2_id" navegacion="">

<cf_navegacion name="cmayor_ccuenta1_mask" navegacion="">
<cf_navegacion name="cmayor_ccuenta2_mask" navegacion="">

<cfset paramsuri = ArrayNew (1)>
<cfset ArrayAppend(paramsuri, 'periodo='         & URLEncodedFormat(form.periodo))>
<cfset ArrayAppend(paramsuri, 'mes='             & URLEncodedFormat(form.mes))>
<cfset ArrayAppend(paramsuri, 'periodo2='        & URLEncodedFormat(form.periodo2))>
<cfset ArrayAppend(paramsuri, 'mes2='            & URLEncodedFormat(form.mes2))>
<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta1=' & URLEncodedFormat(form.Cmayor_Ccuenta1))>
<cfset ArrayAppend(paramsuri, 'Cformato1='       & URLEncodedFormat(form.Cformato1))>
<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta2=' & URLEncodedFormat(form.Cmayor_Ccuenta2))>
<cfset ArrayAppend(paramsuri, 'Cformato2='       & URLEncodedFormat(form.Cformato2))>
<cfset ArrayAppend(paramsuri, 'mcodigoopt='       & URLEncodedFormat(form.mcodigoopt))>
<cfset ArrayAppend(paramsuri, 'Ocodigo='       & URLEncodedFormat(form.Ocodigo))>
<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
	<cfset ArrayAppend(paramsuri, 'ckOrdenXMonto='       & URLEncodedFormat(form.ckOrdenXMonto))>
</cfif>

<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0" and isdefined("form.Mcodigo")> 
	<cfset varMcodigo = form.Mcodigo>
<cfelse>
	<cfset varMcodigo = -1>
</cfif>

<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>
	<cfset varOcodigo = form.Ocodigo>
	<cfset NombreOficina = ''>
	<cfquery datasource="#session.dsn#" name="rsOficina">
		select 
			<cf_dbfunction name="concat" args="o.Oficodigo,' - ',o.Odescripcion"> as Oficodigo
		from Oficinas o
		where o.Ecodigo = #session.Ecodigo#
		 and o.Ocodigo  = #varOcodigo#
	</cfquery>
<cfelse>
	<cfset varOcodigo = -1>
</cfif>
<cfif isdefined("rsOficina") and rsOficina.REcordCount NEQ 0>
	<cfset NombreOficina = rsOficina.Oficodigo>
<cfelse>
	<cfset NombreOficina = 'Todas'>
</cfif>

<cfset LvarCHKMesCierre = form.CHKMesCierre>

<cfquery name="rsMesCierreConta" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 45
</cfquery>

<cfif rsMesCierreConta.Pvalor NEQ form.mes and form.CHKMesCierre EQ "1">
	<cfset LvarCHKMesCierre = "0">
</cfif>

<!--- <cfinclude template="HistoricoContabilidad2-form.cfm"> --->
<cfif isdefined("form.chkResumido")>
	<cfinclude template="HistoricoContabilidad2_form_Resumido.cfm">
<cfelse>
	<cfinclude template="HistoricoContabilidad2_form_Detallado.cfm">
</cfif>
