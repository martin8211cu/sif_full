<style type="text/css">
	.estiloLetra {
		font-size:12px;
		font:Arial, Helvetica, sans-serif;
	}
</style>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <br>
            <cfif ArrayLen(menu3) gt 0>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <cfloop from="1" to="#ArrayLen(menu3)#" index="i">
                        <cfoutput>
                            <cfif findnocase("Solicitudes",menu3[i].titulo,1)  and TituloSol EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Solicitudes de Compra</strong></td></tr>
                                <cfset TituloSol = TituloSol +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Solicitudes",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <!---Proceso de Compra--->
                            <cfif findnocase("Procesos",menu3[i].titulo,1)  and TituloPro EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Procesos de Compras</strong></td></tr>
                                <cfset TituloPro = TituloPro +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Procesos",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Ciclos",menu3[i].titulo,1)>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                            </cfif>		
                            <cfif findnocase("&Oacute;rdenes",menu3[i].titulo,1)  and TituloOrd EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead"style="font-size:#letra#px; " colspan="2" align="left"><strong>&Oacute;rdenes de Compra</strong></td></tr>
                                <cfset TituloOrd = TituloOrd +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("&Oacute;rdenes",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="left" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra" align="left"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("de Mercader&iacute;a",menu3[i].titulo,1)  and TituloRecep EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Recepci&oacute;n</td></tr>
                                <cfset TituloRecep = TituloRecep +1>
                                </cfif>
                            </cfif>
							<cfif findnocase("An&aacute;lisis",menu3[i].titulo,1)  and TituloAn EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Análisis de compras</strong></td></tr>
                                <cfset TituloAn = TituloAn +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("An&aacute;lisis",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>	
                            <cfif findnocase("de Mercader&iacute;a",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                        </cfoutput>
                    </cfloop>
                </table>
            <cfelse>
                Usted No tiene acceso para realizar ninguna operaci&oacute;n en este M&oacute;dulo.
            </cfif>
            <br>
        </td>
        <td valign="top">
            <br>
            <cfif ArrayLen(menu3) gt 0>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <cfloop from="1" to="#ArrayLen(menu3)#" index="i">
                        <cfset opcion = StructNew()>
                        <cfset opcion = menu3[i]>
                        <cfoutput> 
                          <cfif findnocase("los Compradores",menu3[i].titulo,1)  and TituloCom EQ 0>
                          		<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Compradores</strong></td></tr>
                                <cfset TituloCom = TituloCom +1>
                                </cfif>
                            </cfif>
                            
                            <cfif findnocase("los Compradores",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra" ><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("de Solicitantes",menu3[i].titulo,1)  and TituloPer EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Solicitantes</strong></td></tr>
                                <cfset TituloPer = TituloPer +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("de Solicitantes",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Reclamos",menu3[i].titulo,1)  and TituloRec EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2"><strong>Reclamos</strong></td></tr>
                                <cfset TituloRec = TituloRec +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Reclamos",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Tr&aacute;mites",menu3[i].titulo,1)  and TituloTra EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr><td>&nbsp;</td></tr>
                                <tr><td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; "><strong>Tr&aacute;mites</strong></td></tr>
                                <cfset TituloTra = TituloTra +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Tr&aacute;mites",menu3[i].titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Desalmacenaje",menu3[i].titulo,1)  and TituloDes EQ 0>
                            	<cfif acceso_uri(""&menu3[i].uri&"")>
                                    <tr><td>&nbsp;</td></tr>
                                    <tr><td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; "><strong>Importaciones</strong></td></tr>
                                    <cfset TituloDes = TituloDes +1>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Desalmacenaje",menu3[i].titulo,1)>
                           		<cfif acceso_uri(""&menu3[i].uri&"") >
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Embarque",opcion.titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"") >
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Transacciones",opcion.titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"") >
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Aduanales",opcion.titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"") >
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <cfif findnocase("Tr&aacute;nsito",opcion.titulo,1)>
                            	<cfif acceso_uri(""&menu3[i].uri&"") >
                                <tr>
                                    <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                    <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                </tr>
                                </cfif>
                            </cfif>
                            <!-------------------------- Contratos--------------------------------------->
                            <cfif verifica_Parametro.recordcount GT 0 >
                                <cfif findnocase("Contratos",opcion.titulo,1)  and TituloContrato EQ 0>
                                	<cfif acceso_uri(""&menu3[i].uri&"") >
                                    <tr><td>&nbsp;</td></tr>
                                    <tr>
                                      <td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; "><strong>Contratos</strong></td>
                                    </tr>
                                    <cfset TituloContrato = TituloContrato +1>
                                    </cfif>
                                </cfif>
                                <cfif findnocase("Contratos",opcion.titulo,1)>
                                	<cfif acceso_uri(""&menu3[i].uri&"") >
                                    <tr>
                                        <td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#menu3[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                                        <td valign="middle" class="estiloLetra"><a href="/cfmx#menu3[i].uri#">#menu3[i].titulo#</a></td>
                                    </tr>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfoutput>
                    </cfloop>
                </table>
            </cfif>
        </td>
    </tr>
</table>
