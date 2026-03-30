<!--- 
	<cf_templateheader title="Histórico de Contabilidad">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Histórico de Contabilidad'>
		<cfinclude template="../../portlets/pNavegacion.cfm"> --->

		<cfset paramsuri = ArrayNew (1)>
		<cfset ArrayAppend(paramsuri, 'periodo='         & URLEncodedFormat(url.periodo))>
		<cfset ArrayAppend(paramsuri, 'mes='             & URLEncodedFormat(url.mes))>
		<cfset ArrayAppend(paramsuri, 'periodo2='        & URLEncodedFormat(url.periodo2))>
		<cfset ArrayAppend(paramsuri, 'mes2='            & URLEncodedFormat(url.mes2))>
		<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta1=' & URLEncodedFormat(url.Cmayor_Ccuenta1))>
		<cfset ArrayAppend(paramsuri, 'Cformato1='       & URLEncodedFormat(url.Cformato1))>
		<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta2=' & URLEncodedFormat(url.Cmayor_Ccuenta2))>
		<cfset ArrayAppend(paramsuri, 'Cformato2='       & URLEncodedFormat(url.Cformato2))>
		<cfset ArrayAppend(paramsuri, 'mcodigoopt='       & URLEncodedFormat(url.mcodigoopt))>
		<cfset ArrayAppend(paramsuri, 'Ocodigo='       & URLEncodedFormat(url.Ocodigo))>
		<cfif isdefined("url.ckOrdenXMonto") and url.ckOrdenXMonto EQ 1>
			<cfset ArrayAppend(paramsuri, 'ckOrdenXMonto='       & URLEncodedFormat(url.ckOrdenXMonto))>
		</cfif>

		<cf_templatecss>
		<!--- Se elimino  el llamado al link para que no se caiga, el sql tambien se modifico --->
		<!--- <cf_rhimprime datos="/sif/cg/consultas/HistoricoContabilidad2-form.cfm" paramsuri="&#ArrayToList(paramsuri,'&')#"> --->
		
		<cfinclude template="HistoricoContabilidad2-formXOficina.cfm">
		
		<!--- <cf_web_portlet_end>
	<cf_templatefooter> --->