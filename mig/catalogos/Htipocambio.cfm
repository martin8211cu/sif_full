<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 8-3-2006.
		Motivo: Se agrega la navegación y se corrige la numeración del tab.
 --->

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function filtrar( form ){
		form.action = '';
		form.submit();
	}
	
	function limpiar(){
		document.filtro.fMnombre.value = "";
		document.filtro.fHfecha.value = "";
	}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
<cfset fMnombre = "">
<cfset fHfecha = "">
		
<cfif isdefined("url.fMnombre") and len(trim(url.fMnombre)) and not isdefined("form.fMnombre")>
	<cfset form.fMnombre = url.fMnombre>
</cfif>
<cfif isdefined("url.fHfecha") and len(trim(url.fHfecha)) and not isdefined("form.fHfecha")>
	<cfset form.fHfecha = url.fHfecha>
</cfif>

<cfif isdefined("form.fMnombre") AND Len(Trim(form.fMnombre))>
	<cfset filtro = filtro & " and UPPER(m.Mnombre) LIKE '%" & Ucase(Trim(form.fMnombre)) & "%'" >
	<cfset fMnombre = Trim(form.fMnombre)>
	<cfset navegacion = navegacion & "&fMnombre=#form.fMnombre#">
</cfif>
<cfif isdefined("form.fHfecha") and len(Trim(form.fHfecha))> 
	<cfset filtro = filtro & " and htc.Hfecha >= #LSParseDateTime(form.fHfecha)#">
	<cfset fHfecha = Trim(form.fHfecha)>					
	<cfset navegacion = navegacion & "&fHfecha=#form.fHfecha#">
</cfif>

<cfset QueryString_lista = "">
<cfif isdefined("CGI.QUERY_STRING") and len(trim(CGI.QUERY_STRING))>
	<cfset QueryString_lista = CGI.QUERY_STRING>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"fHfecha=","&")>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"fMnombre=","&")>
	<cfif tempPos NEQ 0>
		<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>					
</cfif>


					
<cf_templateheader title="MIG-Modulo Indicadores Gesti&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Hist&oacute;rico de Tipos de Cambio'>	
        	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            	<tr> 
                	<td valign="top" width="50%" nowrap="nowrap">

				 
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="MIGFactorconversion a
								inner join MIGMonedas b
									on a.Mcodigo=b.Mcodigo"
						columnas="a.MIGFCid,a.Mcodigo,a.Factor,b.Mnombre,b.Miso4217,a.Pfecha"
						desplegar="Mnombre, Miso4217,Factor, Pfecha"
						etiquetas="Moneda,ISO,Factor,Fecha"
						formatos="S,S,S,D,S"
						filtro="a.Ecodigo=#session.Ecodigo# Order By b.Mnombre,a.Pfecha"
						align="left,left,left,left,left"
						checkboxes="N"
						keys="MIGFCid"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="Mnombre, Miso4217,Factor,a.Pfecha"
						ira="Htipocambio.cfm"
						showEmptyListMsg="true">
                </td>
                <td valign="top" width="50%">
                	<cfinclude template="formHtipocambio.cfm">
                </td>
              </tr>
            </table>
	 <cf_web_portlet_end>
<cf_templatefooter>