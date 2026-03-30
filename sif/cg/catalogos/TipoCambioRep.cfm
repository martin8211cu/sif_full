<!--- 
	Creado por: E. Raúl Bravo Gómez
		Fecha: 8-7-2013.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo 	= t.Translate('LB_Titulo','Tipos de Cambio de Conversión para Reportes')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Periodo 	= t.Translate('LB_Periodo','Periodo')>
<cfset LB_Mes 		= t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>

<cfinvoke key="BTN_Filtrar" default="Filtrar" 	returnvariable="BTN_Filtrar" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" 	returnvariable="BTN_Limpiar" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="/sif/generales.xml"/>

<cfset LvarForm = 'TipoCambioRep.cfm'>
<cfset LvarTitulo = '#LB_Titulo#'>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function filtrar( form ){
		form.action = '';
		form.submit();
	}
	
	function limpiar(){
		document.filtro.fMoneda.value = "";
		document.filtro.fPeriodo.value = "";
		document.filtro.fMes.value = "";
	}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
<cfset fMoneda = "">
<cfset fPeriodo = "">
<cfset fMes = ""> 
       
<cfif isdefined("url.fMoneda") and len(trim(url.fMoneda)) and not isdefined("form.fMoneda")>
	<cfset form.fMoneda = url.fMoneda>
</cfif>
<cfif isdefined("url.fPeriodo") and len(trim(url.fPeriodo)) and not isdefined("form.fPeriodo")>
	<cfset form.fPeriodo = url.fPeriodo>
</cfif>
<cfif isdefined("url.fMes") and len(trim(url.fMes)) and not isdefined("form.fMes")>
	<cfset form.fMes = url.fMes>
</cfif>


<cfif isdefined("form.fMoneda") AND Len(Trim(form.fMoneda))>
	<cfset filtro = filtro & " and UPPER(m.Mnombre) LIKE '%" & Ucase(Trim(form.fMoneda)) & "%'" >
	<cfset fMoneda = Trim(form.fMoneda)>
	<cfset navegacion = navegacion & "&fMnombre=#form.fMoneda#">
</cfif>
<cfif isdefined("form.fPeriodo") and len(Trim(form.fPeriodo))> 
	<cfset filtro = filtro & " and tc.TCperiodo >= #form.fPeriodo#">
	<cfset fPeriodo = form.fPeriodo>					
	<cfset navegacion = navegacion & "&fPeriodo=#form.fPeriodo#">
</cfif>
<cfif isdefined("form.fMes") and len(Trim(form.fMes))> 
	<cfset filtro = filtro & " and tc.TCmes >= #form.fMes#">
	<cfset fMes = form.fMes>					
	<cfset navegacion = navegacion & "&fMes=#form.fMes#">
</cfif>


<cfset QueryString_lista = "">
<cfif isdefined("CGI.QUERY_STRING") and len(trim(CGI.QUERY_STRING))>
	<cfset QueryString_lista = CGI.QUERY_STRING>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"fMes=","&")>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"fPeriodo=","&")>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"fMoneda=","&")>    
	<cfif tempPos NEQ 0>
		<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>					
</cfif>

<cfset LvarFormTC = 'formTipocambiorep.cfm'>

<cfquery name="periodo_desde" datasource="#Session.DSN#">
    select distinct coalesce ( min (Speriodo ), # Year(Now()) - 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>
<cfquery name="periodo_hasta" datasource="#Session.DSN#">
    select distinct coalesce ( max (Speriodo ), # Year(Now()) + 3 #) as Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>
					
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
								<td><input name="fMoneda" type="text" size="20" maxlength="20" tabindex="1" value="<cfif isdefined("form.fMoneda") and len(trim(form.fMoneda))>#form.fMoneda#</cfif>"></td>
								<td align="right" ><strong>#LB_Periodo#</strong></td>
                              	<td colspan="2">
                                    <select name="fPeriodo" tabindex="1">
                                        <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
                                          <option value="#Speriodo#" <cfif #Speriodo# EQ "#fPeriodo#">selected</cfif>>#Speriodo#</option>
                                        </cfloop>
                                    </select>
                              	</td>  
								<td align="right" ><strong>#LB_Mes#</strong></td>
                      			<td width="23%">
                                  <select name="fMes" size="1" tabindex="2">
                                      <option value="1" <cfif fmes EQ 1>selected</cfif>>#CMB_Enero#</option>
                                      <option value="2" <cfif fmes EQ 2>selected</cfif>>#CMB_Febrero#</option>
                                      <option value="3" <cfif fmes EQ 3>selected</cfif>>#CMB_Marzo#</option>
                                      <option value="4" <cfif fmes EQ 4>selected</cfif>>#CMB_Abril#</option>
                                      <option value="5" <cfif fmes EQ 5>selected</cfif>>#CMB_Mayo#</option>
                                      <option value="6" <cfif fmes EQ 6>selected</cfif>>#CMB_Junio#</option>
                                      <option value="7" <cfif fmes EQ 7>selected</cfif>>#CMB_Julio#</option>
                                      <option value="8" <cfif fmes EQ 8>selected</cfif>>#CMB_Agosto#</option>
                                      <option value="9" <cfif fmes EQ 9>selected</cfif>>#CMB_Septiembre#</option>
                                      <option value="10" <cfif fmes EQ 10>selected</cfif>>#CMB_Octubre#</option>
                                      <option value="11" <cfif fmes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
                                      <option value="12" <cfif fmes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
                                  </select>
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
						<cfinvokeargument name="tabla" 			   value="TipoCambioReporte tc, Monedas m"/>
						<cfinvokeargument name="columnas" 		   value="tc.Mcodigo, m.Mnombre, tc.TCperiodo, tc.TCmes, tc.TCtipocambio"/>
						<cfinvokeargument name="desplegar" 		   value="Mnombre, TCperiodo, TCmes, TCtipocambio"/>
						<cfinvokeargument name="etiquetas" 		   value="#LB_Moneda#, #LB_Periodo#, #LB_Mes#, #LB_Tipo_de_Cambio#"/>
						<cfinvokeargument name="formatos" 		   value="S,I,I,F"/>
						<cfinvokeargument name="filtro" 		   value="tc.Ecodigo = #Session.Ecodigo# and tc.Ecodigo = m.Ecodigo and tc.Mcodigo=m.Mcodigo #filtro# order by m.Mnombre, tc.TCperiodo, tc.TCmes desc"/>
						<cfinvokeargument name="align" 			   value="left, left, left, left"/>
						<cfinvokeargument name="ajustar" 		   value="N"/>
						<cfinvokeargument name="checkboxes" 	   value="N"/>
						<cfinvokeargument name="navegacion" 	   value="#navegacion#"/>
						<cfinvokeargument name="keys" 			   value="Mcodigo,TCperiodo,TCmes"/>
						<cfinvokeargument name="MaxRows" 		   value="15"/>
						<cfinvokeargument name="irA" 			   value="#LvarForm#"/>
						<cfinvokeargument name="Cortes" 		   value="Mnombre"/>
						<cfinvokeargument name="QueryString_lista" value="#QueryString_lista#"/>
					</cfinvoke>
                </td>
                <td valign="top">
                	<cfinclude template="#LvarFormTC#">
                </td>
              </tr>
            </table>
	 <cf_web_portlet_end>
<cf_templatefooter>