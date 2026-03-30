<cf_templateheader title="Administraci&oacute;n del Sistema">
	<cfinclude template="../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Administraci&oacute;n del Sistema">
		<div>
            <div class="row">
                <div class="col col-md-6">
                    <ul>
                    <cfif acceso_uri("/sif/ad/catalogos/ParametrosAD.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/ParametrosAD.cfm">
                                    <cfoutput>#Request.Translate('ParamGen','Parámetros Generales del Sistema')#</cfoutput>
                                </a>
                            </li>
                            <!---<li>
                                <td colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Parámetros Adicionales◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/ParametrosAuxiliaresAD.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/ParametrosAuxiliaresAD.cfm">Parámetros Adicionales</a>
                            </li>
                            <!---<li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Asignación de Concepto por Auxiliar Contable◄◄--->
                        <cfif acceso_uri("/sif/cg/catalogos/ConceptoContable.cfm")>
                            <li>
                                <a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm">Asignación de Concepto por Auxiliar Contable</a>
                            </li>
                           <!--- <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Parámetros de Cuentas Contables de Operación◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/ParametrosCuentasAD.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/ParametrosCuentasAD.cfm">Cuentas Contables de Operaci&oacute;n</a>
                            </li>
                           <!--- <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Centro Funcional◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/CFuncional.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/CFuncional.cfm"><cfoutput>Centros Funcionales</cfoutput></a>
                            </li>
                            <!---<li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Oficinas◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/Oficinas.cfm") >
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/Oficinas.cfm"><cfoutput>#Request.Translate('Oficinas','Oficinas')#</cfoutput></a>
                            </li>
                          <!---  <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Departamentos◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/Departamentos.cfm") >
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/Departamentos.cfm"><cfoutput>#Request.Translate('Deptos','Departamentos')#</cfoutput></a>
                            </li>
                           <!--- <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Formatos de Impresion◄◄--->
                        <cfif acceso_uri("/sif/ad/catalogos/listaFormatos.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/catalogos/listaFormatos.cfm">Formatos de Impresi&oacute;n </a>
                            </li>
                          <!---  <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Formatos Adicionales◄◄--->
                        <cfif acceso_uri("/cfmx/sif/ad/Formatos/Formatos.cfm")>
                            <li>
                                <a href="/sif/ad/Formatos/Formatos.cfm">Formatos Adicionales</a>
                            </li>
                            <!---<li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Origenes Contables◄◄--->
                        <cfif acceso_uri("/sif/ad/origenes/lista_origenes.cfm")>
                            <li>
                                <a href="/cfmx/sif/ad/origenes/lista_origenes.cfm">Parametrizaci&oacute;n de Origenes Contables </a>
                            </li>
                          <!---  <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                        <!---►►Complementos Finacieros◄◄--->
                        <cfif acceso_uri("/sif/ad/origenes/lista_origenes.cfm")>
                            <li>
                                <a href="origenes/Comp_Finacieros.cfm">Registro de Complementos Finacieros</a>
                            </li>
                          <!---  <li>
                                <td  colspan="2" >
                                    <blockquote><p align="justify">
                                    </p></blockquote>
                                </td>
                            </li>--->
                        </cfif>
                    </ul>
                    <!--- ADMINISTRACIÓN DE REPORTES --->
                    <cfinclude template="MenuAdministracionReportes.cfm">
                </div>
                <div class="col col-md-6">
                    <cfinclude template="MenuCatalogosAD.cfm">
                </div>
            </div>
        </div>
	<cf_web_portlet_end>
<cf_templatefooter>