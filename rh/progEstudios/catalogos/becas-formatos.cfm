<cfset filtro = "tbc.RHTBid = #form.RHTBid#">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_dbfunction name="to_char" args="tbc.RHTBid"		returnvariable="to_RHTBid">
<cf_dbfunction name="to_char" args="tbc.RHECBid"	returnvariable="to_RHECBid">
<cfset eliminar = '<a href="javascript:fnEliminarConcepto(''#_CAT##to_RHTBid##_CAT#''"",''#_CAT##to_RHECBid##_CAT#'')"><img src="/cfmx/rh/imagenes/delete.small.png" border="0"></a>'>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto"returnvariable="LB_Concepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeConceptos" Default="Lista De Conceptos" returnvariable="LB_ListaDeConceptos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto" Default="¿Está seguro de que desea eliminar este concepto?" returnvariable="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoDeExpediente" Default="Tipo de Beca" returnvariable="LB_TipoDeExpediente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EncabezadoDeFormatosDeBecas" Default="Encabezado de Formatos de Becas" returnvariable="LB_EncabezadoDeFormatosDeBecas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DetalleDeFormatosDeExpediente" Default="Detalle de Formatos de Tipos de Beca" returnvariable="LB_DetalleDeFormatosDeExpediente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Etiqueta" Default="Etiqueta" returnvariable="LB_Etiqueta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Captura" Default="Captura" returnvariable="LB_Captura"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fuente" Default="Fuente" returnvariable="LB_Fuente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Arial" Default="Arial" returnvariable="LB_Arial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Courier" Default="Courier" returnvariable="LB_Courier"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_sans_serif" Default="sans-serif" returnvariable="LB_sans_serif"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CHK_Negrita" Default="Negrita" returnvariable="CHK_Negrita"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tamano" Default="Tama&ntilde;o" returnvariable="LB_Tamano"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CHK_Subrayado" Default="Subrayado" returnvariable="CHK_Subrayado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Color" Default="Color" returnvariable="LB_Color"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CHK_Italica" Default="It&aacute;lica" returnvariable="CHK_Italica"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CHK_Compuesta" Default="Compuesta" returnvariable="CHK_Compuesta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CHK_Negativo" Default="Permite Negativos" returnvariable="CHK_Negativo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Combinado" Default="Combinado Con" returnvariable="LB_Combinado"/>


<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetBeca" returnvariable="rsBeca">
        <cfinvokeargument name="RHTBid" 		value="#form.RHTBid#">
</cfinvoke>

<cfparam name="modoD" default="ALTA">
<cfif isdefined('form.RHTBEFid') and len(trim(form.RHTBEFid))>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEFormato" returnvariable="rsFormatoE">
    	<cfinvokeargument name="RHTBid" 		value="#form.RHTBid#">
        <cfinvokeargument name="RHTBEFid" 		value="#form.RHTBEFid#">
    </cfinvoke>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetUltimoGradoBDF" returnvariable="SOrden">
    	<cfinvokeargument name="RHTBEFid" 			value="#form.RHTBEFid#">
	</cfinvoke>
    <cfset modoD = "CAMBIO">
</cfif>
<cfparam name="modoS" default="ALTA">
<cfif isdefined('form.RHTBDFid') and len(trim(form.RHTBDFid))>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetDFormato" returnvariable="rsFormatoD">
    	<cfinvokeargument name="RHTBDFid" 		value="#form.RHTBDFid#">
        <cfinvokeargument name="RHTBEFid" 		value="#form.RHTBEFid#">
    </cfinvoke>
    <cfset modoS = "CAMBIO">
</cfif>
<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
</style>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" align="center">
    <tr>
    	<td align="center" class="tituloAlterno">#LB_TipoDeExpediente#:&nbsp;#rsBeca.RHTBcodigo#-#rsBeca.RHTBdescripcion#</td>
	</tr>
    <tr>
        <td align="center"><cf_web_portlet_start titulo="#LB_EncabezadoDeFormatosDeBecas#">
            <table width="98%" cellpadding="0" cellspacing="0" align="center">
                <tr>
                    <td width="40%" valign="top">
                    	<cfinvoke component="rh.Componentes.pListas" method="pListaRH">
                            <cfinvokeargument name="tabla" value="RHTipoBecaEFormatos"/>
                            <cfinvokeargument name="columnas" value="RHTBEFid, RHTBid, RHTBEFcodigo, RHTBEFdescripcion, RHTBEFfecha, 'FormatosB' as FormatosB"/>
                            <cfinvokeargument name="desplegar" value="RHTBEFcodigo, RHTBEFdescripcion, RHTBEFfecha"/>
                            <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Fecha#"/>
                            <cfinvokeargument name="formatos" value="S,S,D"/>
                            <cfinvokeargument name="formName" value="BecasELista"/>	
                            <cfinvokeargument name="filtro" value="RHTBid = #form.RHTBid# order by RHTBEFcodigo, RHTBEFdescripcion"/>
                            <cfinvokeargument name="align" value="left,left,left"/>
                            <cfinvokeargument name="ajustar" value="S"/>
                            <cfinvokeargument name="irA" value="becas.cfm"/>
                            <cfinvokeargument name="keys" value="RHTBEFid"/>
                            <cfinvokeargument name="showEmptyListMsg" value="true"/>
                        </cfinvoke>
                    </td>
                    <td>
                    	<form name="form1" method="post"  action="becas-sql.cfm" >
                            <table width="100%" cellpadding="2" cellspacing="0">
                                <tr>
                                    <td align="right" nowrap><strong>#LB_Codigo#</strong>:&nbsp;</td>
                                    <td>
                                        <input type="text" name="RHTBEFcodigo" id="RHTBEFcodigo" size="11" maxlength="10" value="<cfif modoD neq 'ALTA'>#trim(rsFormatoE.RHTBEFcodigo)#</cfif>">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" nowrap><strong>#LB_Descripcion#</strong>:&nbsp;</td>
                                    <td>
                                        <input type="text" name="RHTBEFdescripcion" id="RHTBEFdescripcion" size="80" maxlength="80" value="<cfif modoD neq 'ALTA'>#rsFormatoE.RHTBEFdescripcion#</cfif>">
                                    </td>
                                </tr>
                                <tr>
                                	<td colspan="2">
                                    	<cf_botones modo="#modoD#" sufijo="BEF" include="Regresar">
                                        <cfset ts = "">	
										<cfif modoD neq "ALTA">
                                            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                                                <cfinvokeargument name="arTimeStamp" value="#rsFormatoE.ts_rversion#"/>
                                            </cfinvoke>
                                            <input type="hidden" name="RHTBEFid" id="RHTBEFid" value="#form.RHTBEFid#">
                                        </cfif>
                                        <cfset fecha = now()>
                                        <cfif modoD neq 'ALTA'>
                                        	<cfset fecha = rsFormatoE.RHTBEFfecha>
                                        </cfif>
                                        <input type="hidden" name="RHTBEFfecha" id="RHTBEFfecha" value="#fecha#">
                                        <input type="hidden" name="RHTBid" id="RHTBid" value="#form.RHTBid#">
                                        <input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
                                    </td>
                                </tr>
                           	</table>
                        </form>
                    </td>
                </tr>
            </table>
        <cf_web_portlet_end></td>
    </tr>
    <cfif modoD neq "ALTA">
    <tr>
        <td align="center"><cf_web_portlet_start titulo="#LB_DetalleDeFormatosDeExpediente#">
            <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
                <tr>
                    <td width="40%" valign="top">
                    	<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
                        <cf_dbfunction name="to_char" args="d.RHTBDFtamFuente" returnvariable="to_RHTBDFtamFuente">
                        <cf_dbfunction name="to_char" args="d.RHTBDFid" returnvariable="to_RHTBDFid">
                        <cf_dbfunction name="to_char" args="d.RHTBDForden" returnvariable="to_RHTBDForden">
                    	<cfset etiqueta = '<label style="cursor:pointer;
														font-family:''#_CAT#d.RHTBDFfuente#_CAT#'';
														font-size:''#_CAT##to_RHTBDFtamFuente##_CAT#''px;
														color:##''#_CAT#rtrim(d.RHTBDFcolor)#_CAT#'';
														font-weight:''#_CAT#case d.RHTBDFnegrita when 1 THEN ''bold'' else ''normal'' end#_CAT#'';
														text-decoration:''#_CAT#case d.RHTBDFsubrayado when 1 THEN ''underline'' else ''normal'' end#_CAT#'';
														font-style:''#_CAT#case d.RHTBDFitalica when 1 THEN ''italic'' else ''normal'' end#_CAT#''
											">''#_CAT#d.RHTBDFetiqueta#_CAT#''</label>'>
        				<cfset arriba = '<a href="javascript:fnMover(''#_CAT##to_RHTBDFid##_CAT#'', ''#_CAT##to_RHTBDForden##_CAT#'', -1);"><img border="0" src="/cfmx/rh/imagenes/arriba.gif"></a>'>
                        <cfset abajo = '<a href="javascript:fnMover(''#_CAT##to_RHTBDFid##_CAT#'', ''#_CAT##to_RHTBDForden##_CAT#'', 1);"><img border="0" src="/cfmx/rh/imagenes/abajo.gif"></a>'>
                        <cfinvoke component="rh.Componentes.pListas" method="pListaRH">
                            <cfinvokeargument name="tabla" value="RHTipoBecaDFormatos d inner join RHTipoBecaEFormatos e on e.RHTBEFid = d.RHTBEFid"/>
                            <cfinvokeargument name="columnas" value="e.RHTBid, d.RHTBDFid, d.RHTBEFid, '#preservesinglequotes(etiqueta)#' as RHTBDFetiqueta, case d.RHTBDFcapturaA when 1 then 'Texto' when 2 then 'Monto' when 3 then 'Num&eacute;rico' when 4 then 'Fecha' when 5 then 'Concepto' end as captura, 'FormatosB' as FormatosB, case d.RHTBDForden when 1 then '' else '#preservesinglequotes(arriba)#' end as arriba, case d.RHTBDForden when #SOrden - 1# then  '' else '#preservesinglequotes(abajo)#' end as abajo"/>
                            <cfinvokeargument name="desplegar" value="RHTBDFetiqueta, captura, arriba, abajo"/>
                            <cfinvokeargument name="etiquetas" value="#LB_Etiqueta#,#LB_Captura#,&nbsp;,&nbsp;"/>
                            <cfinvokeargument name="formatos" value="S,S,V,V"/>
                            <cfinvokeargument name="formName" value="BecasDLista"/>	
                            <cfinvokeargument name="filtro" value="d.RHTBEFid = #form.RHTBEFid# order by RHTBDForden"/>
                            <cfinvokeargument name="align" value="left,left,center,center"/>
                            <cfinvokeargument name="ajustar" value="S"/>
                            <cfinvokeargument name="irA" value="becas.cfm"/>
                            <cfinvokeargument name="keys" value="RHTBDFid"/>
                            <cfinvokeargument name="showEmptyListMsg" value="true"/>
                            <cfinvokeargument name="PageIndex" value="2"/>
                        </cfinvoke>
                    </td>
                    <td valign="top">
                    	<form name="form2" method="post"  action="becas-sql.cfm">
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr>
                                <td align="right" nowrap>#LB_Etiqueta#:&nbsp;</td>
                                <td colspan="5"><input type="text" name="RHTBDFetiqueta" id="RHTBDFetiqueta" size="80" maxlength="255" value="<cfif modoS neq 'ALTA'>#rsFormatoD.RHTBDFetiqueta#</cfif>"></td>
                           	</tr>
                            <tr>
                                <td align="right" nowrap>#LB_Fuente#:&nbsp;</td>
                                <td>
                                    <select name="RHTBDFfuente" id="RHTBDFfuente">
                                        <option value="Arial" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFfuente eq 'Arial'>selected</cfif>>#LB_Arial#</option>
                                        <option value="Courier" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFfuente eq 'Courier'>selected</cfif> >#LB_Courier#</option>
                                        <option value="sans-serif" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFfuente eq 'sans-serif'>selected</cfif>>#LB_sans_serif#</option>
                                    </select>	
                                </td>
                                <td>&nbsp;</td>
                                <td align="right" width="5%" nowrap><input type="checkbox" name="RHTBDFnegrita" id="RHTBDFnegrita" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFnegrita eq 1 >checked</cfif>></td>
                                <td><b>#CHK_Negrita#</b></td>
                            </tr>
                            <tr>
                                <td align="right" nowrap>#LB_Tamano#:&nbsp;</td>
                                <td>
                                    <select name="RHTBDFtamFuente" id="RHTBDFtamFuente">
                                        <option value="6" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 6>selected</cfif>>6</option>
                                        <option value="8" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 8>selected</cfif>>8</option>
                                        <option value="9" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 9>selected</cfif>>9</option>
                                        <option value="10" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 10>selected</cfif>>10</option>
                                        <option value="11" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 11>selected</cfif>>11</option>
                                        <option value="12" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 12>selected<cfelseif modoS eq 'ALTA'>selected</cfif>>12</option>
                                        <option value="14" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 14>selected</cfif>>14</option>
                                        <option value="16" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFtamFuente eq 16>selected</cfif>>16</option>
                                    </select>	
                                </td>
                                <td>&nbsp;</td>
                                <td align="right" width="5%" nowrap><input type="checkbox" name="RHTBDFsubrayado" id="RHTBDFsubrayado" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFsubrayado eq 1 >checked</cfif>></td>
                                <td><u>#CHK_Subrayado#</u></td>
                            </tr>
                            <tr>
                                <td align="right" nowrap>#LB_Color#:&nbsp;</td>
                                <td>
                                	<table border="0" cellpadding="0" cellspacing="0">
                                    	<tr>
                                            <td><input type="text" size="7" maxlength="6"  name="RHTBDFcolor" id="RHTBDFcolor" value="<cfif modoS neq 'ALTA'>#trim(rsFormatoD.RHTBDFcolor)#<cfelse>000000</cfif>" onblur="javascript:traercolor('RHTBDFcolor','colorBox',document.form2.RHTBDFcolor.value)" style="text-transform: uppercase;"></td>
                                            <td>&nbsp;</td>
                                            <td>
                                                <table id="colorBox" width="18" border="0" cellpadding="0" cellspacing="0" bgcolor="##000000" class="cuadro">
                                                    <tr>
                                                        <td align="center" valign="middle" style="color: ##FFFFFF;cursor:hand;">
                                                            <a href="javascript:mostrarpaleta()" style="text-decoration:none;">
                                                                <font size="1">&nbsp;&nbsp;&nbsp;&nbsp;</font>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>	
                                    	</tr>
                                    </table>
                                </td>	
                                <td>&nbsp;</td>									
                                <td align="right" width="5%" nowrap><input type="checkbox" name="RHTBDFitalica" id="RHTBDFitalica" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFitalica eq 1 >checked</cfif>></td>
                                <td><i>#CHK_Italica#</i></td>
                            </tr>
                            <tr>
                                <td align="right">#LB_Captura#:&nbsp;</td>
                                <td>
                                    <select name="RHTBDFcapturaA" id="RHTBDFcapturaA" onchange="fnValidarCapturaA(this.value);fnDisplayCampos(this.value,this.form.RHTBDFcapturaB.value)">
                                        <option value="1" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaA eq 1>selected</cfif>>Texto</option>
                                        <option value="2" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaA eq 2>selected</cfif>>Monto</option>
                                        <option value="3" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaA eq 3>selected</cfif>>Num&eacute;rico</option>
                                        <option value="4" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaA eq 4>selected</cfif>>Fecha</option>
                                        <option value="5" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaA eq 5>selected</cfif>>Concepto</option>
                                    </select>
                                </td>
                                <td>&nbsp;</td>
                                <td colspan="2"><table id="tbNeg" width="100%" border="0" cellpadding="0" cellspacing="0">
                                	<tr>
                                        <td align="right" width="6%" nowrap><input type="checkbox" name="RHTBDFnegativos" id="RHTBDFnegativos" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFnegativos eq 1 >checked</cfif>></td>
                                        <td><i>#CHK_Negativo#</i></td>
                                    </tr>
                                </table></td>
                            </tr>
                            <tr>
                                <td align="right" nowrap>#LB_Combinado#:&nbsp;</td>
                                <td>
                                    <select name="RHTBDFcapturaB" id="RHTBDFcapturaB" onchange="fnValidarCapturaB(this.value);fnDisplayCampos(this.form.RHTBDFcapturaA.value,this.value);">
                                    	<option value="-1" <cfif modoS NEQ 'ALTA' and len(trim(rsFormatoD.RHTBDFcapturaB)) eq 0>selected<cfelseif modoS EQ 'ALTA'>selected</cfif>></option>
                                        <option value="1" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaB eq 1>selected</cfif>>Texto</option>
                                        <option value="2" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaB eq 2>selected</cfif>>Monto</option>
                                        <option value="3" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaB eq 3>selected</cfif>>Num&eacute;rico</option>
                                        <option value="4" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaB eq 4>selected</cfif>>Fecha</option>
                                        <option value="5" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFcapturaB eq 5>selected</cfif>>Concepto</option>
                                    </select>
                                </td>
                                <td>&nbsp;</td>
                                <td align="right" width="5%" nowrap><input type="checkbox" name="RHTBDFrequerido" id="RHTBDFrequerido" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFrequerido eq 1 >checked<cfelseif modoS neq 'ALTA'><cfelse>checked</cfif>></td>
                                <td>Requerido</td>
                            </tr>
                            <tr>
                            <td align="right" nowrap>Reporte:&nbsp;</td>
                                <td>
                                    <select name="RHTBDFreporte" id="RHTBDFreporte">
                                    	<option value="" <cfif modoS NEQ 'ALTA' and len(trim(rsFormatoD.RHTBDFreporte)) eq 0>selected<cfelseif modoS EQ 'ALTA'>selected</cfif>></option>
                                    	<option value="1" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFreporte eq 1>selected</cfif>>Becas</option>
                                        <option value="2" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFreporte eq 2>selected</cfif>>Beneficios</option>
                                        <option value="3" <cfif modoS NEQ 'ALTA' and rsFormatoD.RHTBDFreporte eq 3>selected</cfif>>Ambos</option>
                                    </select>
                                </td>
                                <td>&nbsp;</td>									
                                <td align="right" width="5%" nowrap><input type="checkbox" name="RHTBDFbeneficio" id="RHTBDFbeneficio" <cfif modoS neq 'ALTA' and rsFormatoD.RHTBDFbeneficio eq 1 >checked</cfif>></td>
                                <td>Beneficio</td>
                                
                            </tr>
                            <tr id="tr_concepto" style="<cfif modoS NEQ 'ALTA' and (rsFormatoD.RHTBDFcapturaA eq 5 or rsFormatoD.RHTBDFcapturaB eq 5)><cfelse>display:none;</cfif>">
                                <td align="right">#LB_Concepto#:&nbsp;</td>
                                <td colspan="4">
                                	<cfset valuesArray = ArrayNew(1)>
                                    <cfif modoS eq 'CAMBIO' and len(trim(rsFormatoD.RHECBid)) gt 0>
                                        <cfquery name="rsConcepto" datasource="#session.DSN#">
                                            select RHECBid, RHECBcodigo, RHECBdescripcion
                                            from RHEConceptosBeca
                                            where CEcodigo = #session.CEcodigo#
                                              and RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormatoD.RHECBid#">
                                        </cfquery>
                                        <cfset ArrayAppend(valuesArray, rsConcepto.RHECBid)>
                                      <cfset ArrayAppend(valuesArray, rsConcepto.RHECBcodigo)>
                                      <cfset ArrayAppend(valuesArray, rsConcepto.RHECBdescripcion)>
                                    </cfif>
                                    <cf_conlis
                                        campos="RHECBid,RHECBcodigo,RHECBdescripcion"
                                        desplegables="N,S,S"
                                        modificables="N,S,N"
                                        size="0,10,50"
                                        title="#LB_ListaDeConceptos#"
                                        tabla="RHEConceptosBeca"
                                        columnas="RHECBid, RHECBcodigo, RHECBdescripcion"
                                        filtro="CEcodigo = #session.CEcodigo#"
                                        desplegar="RHECBcodigo, RHECBdescripcion"
                                        filtrar_por="RHECBcodigo|RHECBdescripcion"
                                        filtrar_por_delimiters="|"
                                        etiquetas="#LB_Codigo#,#LB_Descripcion#"
                                        formatos="S,S"
                                        align="left,left"
                                        asignar="RHECBid,RHECBcodigo,RHECBdescripcion"
                                        asignarformatos="I,S,S"
                                        showEmptyListMsg="true"
                                        valuesArray="#valuesArray#"
                                        form = "form2"
                                    >
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="5">
                                	<cf_botones modo="#modoS#" sufijo="BDF">
                                	<cfset ts = "">	
									<cfif modoS neq "ALTA">
                                        <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                                            <cfinvokeargument name="arTimeStamp" value="#rsFormatoD.ts_rversion#"/>
                                        </cfinvoke>
                                        <input name="RHTBDFid" id="RHTBDFid" type="hidden" value="#form.RHTBDFid#">
                                    </cfif>
                                    <cfif modoS neq "ALTA">
                                    	<cfset SOrden = rsFormatoD.RHTBDForden>
                                    </cfif>
                                    <input type="hidden" name="RHTBDForden" id="RHTBDForden" value="#SOrden#">
                                    <input type="hidden" name="RHTBEFid" id="RHTBEFid" value="#form.RHTBEFid#">
                                    <input type="hidden" name="RHTBid" id="RHTBEFid" value="#form.RHTBid#"/>
                                    <input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#" tabindex="-1">
                                </td>
                            </tr>
                        </table>
                   		</form>
                	</td>
                </tr>
                <form name="form3" method="post"  action="becas-sql.cfm">
                	<input type="hidden" name="CambiarGrado" id="CambiarGrado"  value="CambiarGrado">
                	<input type="hidden" name="RHTBEFid" 	 id="RHTBEFid" 		value="#form.RHTBEFid#">
                    <input type="hidden" name="RHTBid" 		 id="RHTBEFid" 		value="#form.RHTBid#"/>
                	<input type="hidden" name="RHTBDFid" 	 id="RHTBDFid" 		value="">
                    <input type="hidden" name="RHTBDForden"  id="RHTBDForden" 	value="">
                    <input type="hidden" name="Posicion" 	 id="Posicion" 		value=""/>
                </form>
            </table>
        <cf_web_portlet_end></td>	
    </tr>
    </cfif>
</table>
<script language="javascript1.2" type="text/javascript">
	
	function fnMover(RHTBDFid,RHTBDForden,P){
		document.form3.RHTBDFid.value = RHTBDFid;
		document.form3.RHTBDForden.value = RHTBDForden;
		document.form3.Posicion.value = P;
		document.form3.submit();
	}
	
	function trim(cad){  
    	return cad.replace(/^\s+|\s+$/g,"");  
	}
	
	function funcAltaBEF(){
		return fnValidarBEF();	
	}
	
	function funcCambioBEF(){
		return fnValidarBEF();	
	}
	
	function fnValidarBEF(){
		Lcod = trim(document.form1.RHTBEFcodigo.value).length;
		Ldec = trim(document.form1.RHTBEFdescripcion.value).length;
		errores = "";
		if(Lcod == 0)
			errores = errores + " -La código es requerido.\n";
		if(Ldec == 0)
			errores = errores + " -La descripción es requerido.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function funcAltaBDF(){
		return fnValidarBDF();	
	}
	
	function funcCambioBDF(){
		return fnValidarBDF();	
	}
	
	function fnValidarBDF(){
		
		Let = trim(document.form2.RHTBDFetiqueta.value).length;
		errores = "";
		if(Let == 0)
			errores = errores + " -El etiqueta es requerido.\n";
		if((document.form2.RHTBDFcapturaA.value == 5 || document.form2.RHTBDFcapturaB.value == 5) && trim(document.form2.RHECBid.value).length == 0)
			errores = errores + " -El concepto es requerido.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function fnEliminarConcepto(RHTBid, RHECBid) {
		if (confirm('#MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto#')) {
			document.formD.RHTBid.value = RHTBid;
			document.formD.RHECBid.value = RHECBid;
			document.formD.submit();
		}
	}
	
	function traercolor(obj,tabla,color){
		if ( trim(color) == '' ){
			color = '000000';
		}		

		if ( trim(color) != '' && color.length == 6 ){
			tabla = document.getElementById("colorBox");
			tabla.bgColor = "##" + color;
			document.form2.RHTBDFcolor.value = color;
		}
	}
	
	function mostrarpaleta(){
		window.open("/cfmx/sif/ad/catalogos/color.cfm?obj=RHTBDFcolor&tabla=colorBox","Paleta",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height=60,width=308,left=375, top=250');
	}
	
	function fnDisplayCampos(v1,v2){
		objC = document.getElementById('tr_concepto');
		objN = document.getElementById('tbNeg');
		objC.style.display = (v1 == 5 || v2 == 5 ? '' : 'none');
		objN.style.display = (v1 == 2 || v1 == 3 || v2 == 2 || v2 == 3 ? '' : 'none');
	}
	
	function fnVisibilidadEtiqueta(v){
		obj = document.getElementById('tr_etq2');
		if(v)
			obj.style.display = "";
		else
			obj.style.display = "none";
	}
	
	function fnValidarCapturaB(v){
		if(document.form2.RHTBDFcapturaA.value == v)
			document.form2.RHTBDFcapturaB.value = "-1";
	}
	
	function fnValidarCapturaA(v){
		if(document.form2.RHTBDFcapturaB.value == v)
			document.form2.RHTBDFcapturaB.value = "-1";
	}
	<cfif modoD neq "ALTA">
	traercolor('RHTBDFcolor','colorBox',document.form2.RHTBDFcolor.value);
	fnDisplayCampos(document.form2.RHTBDFcapturaA.value,document.form2.RHTBDFcapturaB.value);
	</cfif>
</script>
</cfoutput>