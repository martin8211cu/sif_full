<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 8-3-2006.
		Motivo: Se agrega la navegación y se corrige la numeración del tab.
 --->
 <cfinvoke key="LB_Titulo" default="Hist&oacute;rico de Tipos de Cambio" 	returnvariable="LB_Titulo" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>	
 <cfinvoke key="LB_Fecha" default="Fecha" 	returnvariable="LB_Fecha" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Hasta" default="Hasta" 	returnvariable="LB_Hasta" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Compra" default="Compra" 	returnvariable="LB_Compra" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Venta" default="Venta" 	returnvariable="LB_Venta" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Promedio" default="Promedio" 	returnvariable="LB_Promedio" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Moneda" default="Moneda" 	returnvariable="LB_Moneda" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="LB_Fecha" default="Fecha" 	returnvariable="LB_Fecha" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Htipocambio.xml"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" 	returnvariable="BTN_Filtrar" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpar" default="Limpiar" 	returnvariable="BTN_Limpiar" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="/sif/generales.xml"/>


<cfset LvarForm = 'Htipocambio.cfm'>
<cfset LvarTitulo = '#LB_Titulo#'>
<cfif isdefined("LvarQPass")>
	<cfset LvarForm = 'QPassTC.cfm'>
    <cfset LvarTitulo = 'Quick Pass'>
</cfif>
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

<cfset LvarFormTC = 'formHtipocambio.cfm'>
<cfif isdefined("LvarQPass")>
	<cfset LvarFormTC = '/sif/QPass/catalogos/QPassTCForm.cfm'>
</cfif>
					
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>	
		<cfinclude template="../../portlets/pNavegacionCG.cfm">	
        	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            	<tr> 
                	<td valign="top" width="50%">
				  		<table width="100%" border="0" cellspacing="3" cellpadding="0" class="areaFiltro">
						<form name="filtro" method="post" action="<cfoutput>#LvarForm#</cfoutput>">
						  <cfoutput>
						 	<tr> 
								<td align="right" ><strong>#LB_Moneda#</strong></td>
								<td><input name="fMnombre" type="text" size="20" maxlength="20" tabindex="1" value="<cfif isdefined("form.fMnombre") and len(trim(form.fMnombre))>#form.fMnombre#</cfif>"></td>
								<td align="right" ><strong>#LB_Fecha#</strong></td>
								<td>
									<cfif isdefined("form.fHfecha") and len(trim(form.fHfecha))>
										<cf_sifcalendario form="filtro" name="fHfecha" value="#form.fHfecha#" tabindex="1"> 
									<cfelse>
										<cf_sifcalendario form="filtro" name="fHfecha" value="" tabindex="1"> 
									</cfif>
								</td>
								<td nowrap> 
								  <input type="submit" name="btnFiltrar" value="#BTN_Filtrar#"  onClick="javascript:filtrar(this.form)" tabindex="1"> 
								  <input type="button" name="btnLimpiar" value="#BTN_Limpiar#"  onClick="javascript:limpiar()" tabindex="1"> 
								</td>
						  	</tr>
						  </cfoutput>
						</form>
                  	   </table>
				 
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 			   value="Htipocambio htc, Monedas m"/>
						<cfinvokeargument name="columnas" 		   value="htc.Mcodigo, m.Mnombre, htc.Hfecha, htc.Hfechah, Hfecha as orderHfecha, htc.TCcompra, htc.TCventa,htc.TCpromedio"/>
						<cfinvokeargument name="desplegar" 		   value="Hfecha, Hfechah, TCcompra, TCventa, TCpromedio"/>
						<cfinvokeargument name="etiquetas" 		   value="#LB_Fecha#, #LB_Hasta#, #LB_Compra#, #LB_Venta#, #LB_Promedio#"/>
						<cfinvokeargument name="formatos" 		   value="D,D,F,F,F"/>
						<cfinvokeargument name="filtro" 		   value="htc.Ecodigo = #Session.Ecodigo# and htc.Mcodigo=m.Mcodigo #filtro# order by m.Mnombre, orderHfecha desc"/>
						<cfinvokeargument name="align" 			   value="left, left, right, right, right"/>
						<cfinvokeargument name="ajustar" 		   value="N"/>
						<cfinvokeargument name="checkboxes" 	   value="N"/>
						<cfinvokeargument name="navegacion" 	   value="#navegacion#"/>
						<cfinvokeargument name="keys" 			   value="Mcodigo,Hfecha"/>
						<cfinvokeargument name="MaxRows" 		   value="15"/>
						<cfinvokeargument name="irA" 			   value="#LvarForm#"/>
						<cfinvokeargument name="Cortes" 		   value="Mnombre"/>
						<cfinvokeargument name="QueryString_lista" value="#QueryString_lista#"/>
					</cfinvoke>
                </td>
                <td valign="top">
                	<cfinclude template="#LvarFormTC#">
                </td>
				<!---<td valign="top" align="right">
					<cf_sifayudaRoboHelp name="imAyuda" tabindex="0" imagen="1" Tip="true" width="500" url="Historico_tipo_cambio.htm">
				</td>--->	
              </tr>
            </table>
	 <cf_web_portlet_end>
<cf_templatefooter>