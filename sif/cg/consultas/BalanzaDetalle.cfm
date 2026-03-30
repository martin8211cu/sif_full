<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla.
 --->
 <!---
 Modificado Por Israel Rodríguez Fecha 25-04-2012
 Se realiza Adecuación  para que tenga la funcionalidad de  cambiar la traduccion de las etiquetas
 --->
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Balanza a Detalle" 
returnvariable="LB_Titulo" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoInicial" default="Desde Per&iacute;odo" 
returnvariable="LB_PeriodoInicial" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoFinal" default="Hasta Per&iacute;odo" 
returnvariable="LB_PeriodoFinal" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesInicial" default="Mes" 
returnvariable="LB_MesInicial" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesFinal" default="Mes" 
returnvariable="LB_MesFinal" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaInicial" default="Fecha Inicio" 
returnvariable="LB_FechaInicial" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaFinal" default="Fecha Fin" 
returnvariable="LB_FechaFinal" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaInicial" default="Cuenta Inicial" 
returnvariable="LB_CuentaInicial" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaFinal" default="Cuenta Final" 
returnvariable="LB_CuentaFinal" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Formato" default="Formato" 
returnvariable="LB_Formato" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Orden" default="Ordenamiento" 
returnvariable="LB_Orden" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" 
returnvariable="LB_Oficina" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Todos" default="Todos" 
returnvariable="LB_Todos" xmlfile="BalanzaDetalle.xml"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descarga" default="Descarga de " 
returnvariable="LB_Descarga" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_MonedaLocal" default="Local" 
returnvariable="RBTN_MonedaLocal" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_MonedaOrigen" default="Origen" 
returnvariable="RBTN_MonedaOrigen" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_ImpMontoMO" default="Imprimir Monto en Moneda Origen" 
returnvariable="CHK_ImpMontoMO" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_TotalFecha" default="Totalizar por Fecha" 
returnvariable="CHK_TotalFecha" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CHK_CierreAnual" default="Cierre Anual" 
returnvariable="CHK_CierreAnual" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Limpiar" default="Limpiar" 
returnvariable="BTN_Limpiar" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" 
returnvariable="BTN_Consultar" xmlfile="BalanzaDetalle.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes1" default="Enero" 
returnvariable="opc_mes1" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes2" default="Febrero" 
returnvariable="opc_mes2" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes3" default="Marzo" 
returnvariable="opc_mes3" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes4" default="Abril" 
returnvariable="opc_mes4" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes5" default="Mayo" 
returnvariable="opc_mes5" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes6" default="Junio" 
returnvariable="opc_mes6" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes7" default="Julio" 
returnvariable="opc_mes7" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes8" default="Agosto" 
returnvariable="opc_mes8" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes9" default="Septiembre" 
returnvariable="opc_mes9" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes10" default="Octubre" 
returnvariable="opc_mes10" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes11" default="Noviembre" 
returnvariable="opc_mes11" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_mes12" default="Diciembre" 
returnvariable="opc_mes12" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_Orden0" default="Linea" 
returnvariable="opc_Orden0" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_Orden1" default="Fecha/Concepto/Asiento" 
returnvariable="opc_Orden1" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_Orden2" default="Fecha/Monto/Asiento" 
returnvariable="opc_Orden2" xmlfile="BalanzaDetalle.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="opc_Orden3" default="Monto/Concepto/Asiento" 
returnvariable="opc_Orden3" xmlfile="BalanzaDetalle.xml"/>

<cfquery datasource="#Session.DSN#" name="rsOficinas">
    select Ocodigo, Odescripcion
    from Oficinas 
    where Ecodigo = #Session.Ecodigo#
    order by Ocodigo 
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsNivelDef">
    select Pvalor as valor
    from Parametros 
    where Ecodigo = #Session.Ecodigo#
    and Pcodigo = 10 
</cfquery>			  

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
<cfquery name="rsPer" datasource="#Session.DSN#">
    select distinct Speriodo as Eperiodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Eperiodo desc
</cfquery>		

<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">
<cfinclude template="Funciones.cfm">
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cfquery name="rsMonedas" datasource="#Session.DSN#">
    select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
    from Monedas
    where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset longitud = len(Trim(rsMonedas.Miso4217))>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b
	where a.Ecodigo = #Session.Ecodigo#
	and a.Ecodigo = b.Ecodigo
	and a.Mcodigo = b.Mcodigo
</cfquery>

<cfquery name="rsParam" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 660
</cfquery>
<cfif rsParam.recordCount> 
	<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = #Session.Ecodigo#
		and Mcodigo = #rsParam.Pvalor#
	</cfquery>
</cfif>

<cf_templateheader title=#LB_Titulo#>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
  
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
            <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
            <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
            <script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
            <script language="JavaScript1.2" type="text/javascript">
                // specify the path where the "/qforms/" subfolder is located
                qFormAPI.setLibraryPath("../../js/qForms/");
                // loads all default libraries
                qFormAPI.include("*");
                
            </script>
                        
              <form name="form1" method="get" action="BalanzaDetalle-sql.cfm" onsubmit="return sinbotones()">
              
                  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
                    <tr> 
                      <td colspan="9"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
                    </tr>
                    <!---<tr><td colspan="9" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_comprobacion.htm"></td></tr>
                    <tr>---> <cfoutput>
                      <td width="11%" nowrap><div align="right">#LB_PeriodoInicial#:&nbsp;</div></td> </cfoutput>
                      <td colspan="2">
                        <select name="periodo1" tabindex="1">
                            <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
                                <cfoutput>
                              <option value="#Speriodo#" <cfif #Speriodo# EQ "#rsPer.Eperiodo#">selected</cfif>>#Speriodo#</option></cfoutput>
                            </cfloop>
                        </select>
                      </td>  
                      <cfoutput><td width="4%">#LB_MesInicial#:</td></cfoutput>
                      <td width="23%"><cfoutput>
                          <select name="mes1" size="1" tabindex="2">
                              <option value="1" <cfif mes EQ 1>selected</cfif>>#opc_mes1#</option>
                              <option value="2" <cfif mes EQ 2>selected</cfif>>#opc_mes2#</option>
                              <option value="3" <cfif mes EQ 3>selected</cfif>>#opc_mes3#</option>
                              <option value="4" <cfif mes EQ 4>selected</cfif>>#opc_mes4#</option>
                              <option value="5" <cfif mes EQ 5>selected</cfif>>#opc_mes5#</option>
                              <option value="6" <cfif mes EQ 6>selected</cfif>>#opc_mes6#</option>
                              <option value="7" <cfif mes EQ 7>selected</cfif>>#opc_mes7#</option>
                              <option value="8" <cfif mes EQ 8>selected</cfif>>#opc_mes8#</option>
                              <option value="9" <cfif mes EQ 9>selected</cfif>>#opc_mes9#</option>
                              <option value="10" <cfif mes EQ 10>selected</cfif>>#opc_mes10#</option>
                              <option value="11" <cfif mes EQ 11>selected</cfif>>#opc_mes11#</option>
                              <option value="12" <cfif mes EQ 12>selected</cfif>>#opc_mes12#</option>
                          </select>			</cfoutput>				  </td> 
                      <td width="2%" nowrap>&nbsp;</td><cfoutput>
                      <td width="12%" align="right" nowrap> #LB_CuentaInicial#:&nbsp; </td></cfoutput>
                      <td colspan="2" align="left" nowrap> <cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="20" tabindex="5"> </td>
                    </tr>
                    <tr> <cfoutput>
                      <td nowrap><div align="right">#LB_PeriodoFinal#:&nbsp;</div></td> </cfoutput>
                      <td colspan="2">
                        <select name="periodo2" tabindex="3">
                            <cfloop from="#periodo_desde.Speriodo#" to="#periodo_hasta.Speriodo#" index="Speriodo">
                            <cfoutput>
                              <option value="#Speriodo#" <cfif #Speriodo# EQ "#rsPer.Eperiodo#">selected</cfif>>#Speriodo#</option></cfoutput>
                            </cfloop>
                        </select>                              </td>
                      <cfoutput><td>#LB_MesFinal#:</td></cfoutput>
                      <td><cfoutput>
                        <select name="mes2" size="1" tabindex="4">
                              <option value="1" <cfif mes EQ 1>selected</cfif>>#opc_mes1#</option>
                              <option value="2" <cfif mes EQ 2>selected</cfif>>#opc_mes2#</option>
                              <option value="3" <cfif mes EQ 3>selected</cfif>>#opc_mes3#</option>
                              <option value="4" <cfif mes EQ 4>selected</cfif>>#opc_mes4#</option>
                              <option value="5" <cfif mes EQ 5>selected</cfif>>#opc_mes5#</option>
                              <option value="6" <cfif mes EQ 6>selected</cfif>>#opc_mes6#</option>
                              <option value="7" <cfif mes EQ 7>selected</cfif>>#opc_mes7#</option>
                              <option value="8" <cfif mes EQ 8>selected</cfif>>#opc_mes8#</option>
                              <option value="9" <cfif mes EQ 9>selected</cfif>>#opc_mes9#</option>
                              <option value="10" <cfif mes EQ 10>selected</cfif>>#opc_mes10#</option>
                              <option value="11" <cfif mes EQ 11>selected</cfif>>#opc_mes11#</option>
                              <option value="12" <cfif mes EQ 12>selected</cfif>>#opc_mes12#</option>
                          </select>			</cfoutput>                              </td>
                      <td nowrap>&nbsp;</td><cfoutput>
                      <td align="right" nowrap>#LB_CuentaFinal#:&nbsp; </td>
                      <td colspan="2" align="left" nowrap> <cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="20" tabindex="6"> </td>
                    </tr>
                    <tr>
                      <td align="right" nowrap>#LB_FechaInicial#:&nbsp;</td>
                      <td colspan="4" nowrap>
                        <cf_sifcalendario name="fechaini" tabindex="7">							  </td> 
                      <td nowrap>&nbsp;</td>
                      <td align="right" nowrap>#LB_FechaFinal#:&nbsp;</td>
                      <td colspan="2" align="left" nowrap>
                      <cf_sifcalendario name="fechafin" tabindex="8">							  </td>
                    </tr>
                    <tr>
                      <td align="right" nowrap>&nbsp;</td>
                      <td colspan="4" nowrap>&nbsp;</td>
                      <td nowrap>&nbsp;</td>
                      <td colspan="2" align="right" nowrap>&nbsp;</td>
                      <td width="15%" nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                        <td nowrap><div align="right">#LB_Moneda#:</div></td>
                      <td colspan="4" rowspan="2" valign="top">
                        <table border="0" cellspacing="0" cellpadding="2">
                          <tr>
                            <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="9"></td>
                            <td nowrap> #RBTN_MonedaLocal#:</td>
                            <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                          </tr>
                          <cfif isdefined("rsMonedaConvertida")>
                            </cfif>
                          <tr>
                            <td nowrap><input name="mcodigoopt" type="radio" value="0" tabindex="10" /></td>
                            <td nowrap>#RBTN_MonedaOrigen#:</td></cfoutput>
                            <td><select name="Mcodigo" tabindex="11">
                              <cfoutput query="rsMonedas">
                                <option value="#rsMonedas.Mcodigo#"
                   <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                        <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
                    </cfif>
                    >#rsMonedas.Mnombre#</option>
                              </cfoutput>
                            </select></td>
                          </tr>
                          <tr>
                            <td nowrap><input type="checkbox" name="chkMontoOrigen" value="false" tabindex="12" /></td>
                            <cfoutput>
                            <td colspan="2" nowrap>#CHK_ImpMontoMO#</td>
                          </tr>
                        </table></td>
                        <td>&nbsp;</td>
                        <td align="right" nowrap>#LB_Oficina#:&nbsp;</td>
                        <td width="17%" align="left" nowrap><select name="Ocodigo" id="select" tabindex="14">
                          <option value="-1">#LB_Todos#</option></cfoutput>
                          <cfoutput query="rsOficinas">
                            <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
                          </cfoutput>
                        </select></td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td nowrap><div align="right">&nbsp;</div></td>
                      <td>&nbsp;</td><cfoutput>
                      <td align="right">#LB_Orden#:</td>
                      <td align="left"><select name="ordenamiento" tabindex="15">
                        <option value="0" selected>#opc_Orden0#</option>
                        <option value="1">#opc_Orden1#</option>
                        <option value="2">#opc_Orden2#</option>
                        <option value="3">#opc_Orden3#</option>
                      </select></td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" nowrap="nowrap">&nbsp;</td>
                      <td width="3%" align="right" nowrap="nowrap"><input type="checkbox" name="chkTotalFecha" value="" tabindex="13"></td>
                      <td width="13%" align="right" nowrap="nowrap">#CHK_TotalFecha#</td>
                      <td align="right" nowrap="nowrap">&nbsp;</td>
                      <td align="right" nowrap="nowrap">&nbsp;</td>
                      <td>&nbsp;</td>
                      <td align="right">#LB_Formato#</td>
                      <td align="left"><select name="formato" tabindex="16">
						<option value="bightml">#LB_Descarga# HTML</option>
                        <option value="FlashPaper">FlashPaper</option>
                        <option value="pdf">Adobe PDF</option>
                        <option value="ExcelColumnar">Excel Columnar</option>                        
                      </select></td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="right" nowrap>&nbsp;</td>
                        <td nowrap width="3%">
                            <input type="checkbox" name="CHKMesCierre" value="1" tabindex="13">
                        </td>
                        <td colspan="7">#CHK_CierreAnual#</td>
                    </tr>
                    <tr>
                      <td align="right">&nbsp;</td>
                      <td colspan="2">&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td colspan="2" align="right">&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" nowrap>&nbsp;</td>
                      <td colspan="2">&nbsp;</td>
                      <td>&nbsp;</td>
                      <td colspan="4" align="right"><input type="submit" name="Submit" value="#BTN_Consultar#" onClick="this.form.btnGenerar2.value=0" tabindex="17">							   
                      <input type="Reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="18">						      </td>
                      </cfoutput>
                      <td><div align="right">
                      <input type="hidden" name="btnGenerar2" value="" />
                        <!--- <input type="submit" name="btnGenerar2btn" value="Download" onclick="this.form.btnGenerar2.value=1"> --->
                      </div></td>
                    </tr>
                    <tr> 
                      <td colspan="9" align="center">&nbsp;							  </td>
                    </tr>
                    <tr> 
                      <td colspan="9">&nbsp;</td>
                    </tr>
                  </table>
                  
            </form> 
            <script language="JavaScript1.2" type="text/javascript">
                //definicion del color de los campos con errores de validación para cualquier instancia de qforms
                qFormAPI.errorColor = "#FFFFCC";
                //instancias de qforms
                objForm = new qForm("form1");
                //descripciones de objetos de la instancia de qform definida
                
                objForm.Cformato1.description = "Formato de la Cuenta Inicial";
                objForm.Cformato1.required = true;
                objForm.Cformato2.description = "Formato de la Cuenta Final";
                objForm.Cformato2.required = true;
                objForm.Cmayor_Ccuenta1.description = "La Cuenta Inicial";
                objForm.Cmayor_Ccuenta1.required = true;
                objForm.Cmayor_Ccuenta2.description = "La Cuenta Final";
                objForm.Cmayor_Ccuenta2.required = true;
                
            </script>
            </td>	
        </tr>
    </table>	
   
    <cf_web_portlet_end>
<cf_templatefooter>
