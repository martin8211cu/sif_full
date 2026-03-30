<cfif not isdefined("form.DocumentoCP") and isdefined ("url.DocumentoCP") and len(trim(url.DocumentoCP))>
    <cfset form.DocumentoCP = url.DocumentoCP>
</cfif>
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/Sapiens/css/soinasp01_sapiens.css">

<form style="margin: 0" action="popUp-EAdq.cfm" name="fsolicitud" id="fsolicitud" method="post">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
                <tr>
	                <td class="tituloAlterno" align="center">Lista de Adquisiciones Pendientes</td>
                </tr>
            </table>
            <cfoutput>
            <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                <tr> 
                    <td class="fileLabel" align="left"><strong>Documento CxP:</strong></td>
                    <td class="fileLabel" align="left">&nbsp;</td>
                </tr>
                <tr>	
                    <td width="10%">
                    <input type="text" name="DocumentoCP" size="30" maxlength="20" value="<cfif isdefined('form.DocumentoCP')>#form.DocumentoCP#</cfif>" style="text-transform: uppercase;" tabindex="1">
                    </td>
                	<td align="left" valign="center"><input type="submit" name="btnFiltro" value="Filtrar"></td>
                </tr>
            </table>
            </cfoutput>
        </td>
    </tr>
</table>
 
	<cfset LvarMaxRows = 18>
    <cftry>       
        <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AF_AdquisicionActivos" returnvariable="rsFacturas">
            <cfinvokeargument name="Ecodigo"   value="#Session.Ecodigo#">
            <cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#">
            <cfinvokeargument name="Modulo"    value="Adquisicion">
            <cfinvokeargument name="Debug" 	   value="false">
        </cfinvoke>
    <cfcatch type="any">
    	<cfthrow message="#cfcatch.message#">
    </cfcatch>
    </cftry>
    
    <cftry>
        <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AF_VerificaErrores" returnvariable="rsFacturas2">
        </cfinvoke>
        <cfquery name="rsExiste" dbtype="query">
			select * 
			from rsFacturas2
			where 1=1
            <cfif isdefined("form.DocumentoCP") and len(trim(form.DocumentoCP))>
            	and upper(Documento) like upper('%#form.DocumentoCP#%')
			</cfif>
		</cfquery>
    <cfcatch type="any">
    	<cfthrow message="#cfcatch.message#">
    </cfcatch>
    </cftry>
                
    

<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfset navegacion = "">
    			<cfif isdefined("rsExiste") and rsExiste.recordcount gt 0>
                <table width="99%" cellspacing="0" cellpadding="0" border="0" align="center">
                	<tbody>
                    	<tr>
		 	               <td>
							<script src="/cfmx/commons/js/pLista1.js" language="JavaScript" type="text/javascript"></script>
                            <!-- Rutinas de Control del CF_onKeyEnter para el documento -->
                            <input type="text" style="display:none;">
                            <script src="/cfmx/sif/js/utilesOnEnterKey.js" type="text/javascript" language="javascript"></script>
                            <script>CF_onEnter_Initializate("submit");</script>
                
                			<table width="100%" cellspacing="1" cellpadding="0" border="0" align="center" class="PlistaTable"> 
                				<tbody>
					                <tr> 
                                    	<td valign="bottom" align="Left" class="tituloListas"></td>
                						<td valign="bottom" align="Left" class="tituloListas" width="15%"> 
           							    	<strong> Documento CxP</strong> 
                						</td> 
                						<td valign="bottom" align="Left" class="tituloListas"> 
                							<strong> Problema Presentado</strong> 
                						</td> 
                					</tr>
                                    <cfoutput>
                                    <cfloop query="rsExiste" >
                                        <tr onmouseout="<cfif rsExiste.CurrentRow mod 2>this.className='listaPar'<cfelse>this.className='listaNon'</cfif>;" onmouseover="<cfif rsExiste.CurrentRow mod 2>this.className='listaParSel'<cfelse>this.className='listaNonSel'</cfif>;" class="<cfif rsExiste.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"> 
                                            <td width="18" nowrap="" height="18" align="left"></td>
                                            <td align="Left" onmouseout="javascript:  window.status = '';  return true;" onmouseover="javascript:  window.status = '';  return true;" style="padding-right: 3px; cursor: pointer; " class="pStyle_Documento">#rsExiste.Documento#&nbsp;</td>
                                            <cfset msg  = "">
                                            <cfswitch expression="#rsExiste.TipoError#"> 
                                                <cfcase value="1"> 
                                                    <cfset msg  = "No se encontraron Documentos de Responsabilidad de Activos Fijos (Vales) registrados para: Documento '#rsExiste.Documento#'">
                                                </cfcase> 
                                                <cfcase value="2"> 
                                                    <cfset msg  = "No se encontro el Documento de Responsabilidad de Activo Fijos (Vale) registrados para: Documento '#rsExiste.Documento#' Linea: '#rsExiste.Linea#' Cantidad '#rsExiste.Cantidad#' Total Linea '#rsExiste.Moneda#s #numberFormat(rsExiste.TotalLin,',.00')#' Monto Unitario Local '#numberFormat(rsExiste.MontoUnit,',.00')#' #rsExiste.OC#.">
                                                </cfcase> 
                                                <cfcase value="3"> 
                                                    <cfset msg  = "El monto ('#rsExiste.MonedaLoc#s #rsExiste.Monto#') del Documento: '#rsExiste.Documento#', es mayor que la suma de los montos ('#rsExiste.MonedaLoc#s #rsExiste.MontoVales#') de los Documentos de Responsabilidad asociados.">
                                                </cfcase> 
                                                <cfcase value="4"> 
                                                    <cfset msg  = "El monto ('#rsExiste.MonedaLoc#s #rsExiste.MontoVales#') del Documento de Responsabilidad, es mayor que el monto ('#rsExiste.MonedaLoc#s #rsExiste.Monto#') del Documento: '#rsExiste.Documento#'.">
                                                </cfcase> 
                                                <cfcase value="5"> 
                                                    <cfset msg  = "Los Documentos de Responsabilidad de Activos Fijos (Vales) registrados para el Documento '#rsExiste.Documento#' no contienen lineas de detalle">
                                                </cfcase> 
                                            </cfswitch>
                                            <td align="Left" onmouseout="javascript:  window.status = '';  return true;" onmouseover="javascript:  window.status = '';  return true;" style="padding-right: 3px; cursor: pointer; " class="pStyle_Error">#msg#&nbsp;</td>
                                        </tr>
                                    </cfloop> 
                                    </cfoutput>     
                					<tr><td align="center" colspan="3">&nbsp;</td></tr>
                					<tr>
                                    	<td align="center" colspan="3" class="listaNon"> 
										<table width="100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td align="center">
                                                        <input type="button" tabindex="0" onclick="javascript: window.close();" value="Cerrar" class="btnNormal" name="btnCerrar">
                                                    </td>
                                                </tr>
                                            </tbody>
                						</table>
                						</td>
                					</tr>
                				</tbody>
                			</table>
                			</td>
                		</tr>
                	</tbody>
             	</table>
            	</cfif>
            </td>
        </tr>
    </table>
</form>

	
    <hr width="99%" align="center">