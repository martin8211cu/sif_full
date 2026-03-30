<cfif modoDist EQ 'CAMBIO'>
    <cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsD">
    		<cfinvokeargument name="DGid" 			value="#form.DGid#"/>
    </cfinvoke>
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsD.ts_rversion#" returnvariable="ts"/>   
    <cfset form.NGid  = rsD.NGid>
    <cfset form.Ppais = rsD.Ppais>
</cfif>
<cfif modoNivel EQ 'CAMBIO'>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="lsN">
    		<cfinvokeargument name="NGid" 			value="#form.NGid#"/>
        <cfif isdefined('form.filtro_DGcodigo') and LEN(TRIM(form.filtro_DGcodigo))>
        	<cfinvokeargument name="DGcodigo" 		value="#form.filtro_DGcodigo#"/>
        </cfif>
         <cfif isdefined('form.filtro_DGDescripcion') and LEN(TRIM(form.filtro_DGDescripcion))>
        	<cfinvokeargument name="DGDescripcion" 	value="#form.filtro_DGDescripcion#"/>
        </cfif>
    </cfinvoke>
    <cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" 	  returnvariable="rsN" NGid="#form.NGid#"/>
    <cfset form.Ppais = rsN.Ppais>
</cfif>

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>
<cfoutput>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td rowspan="3" valign="top">
            	<cfset actionArbol = "DistrGeografico.cfm">
                <cfinclude template="NivelGeografico-Arbol.cfm">
            </td>
          
         </tr>
         <tr>
            <td>
                <fieldset>
                        <legend>Información del Distribución Geográfica</legend>
                            <form name="form1" action="DistrGeografico-sql.cfm" method="post">
                                <input name="DGid" 		  id="DGid" 	   type="hidden" value="#rsD.DGid#" />
                                <input name="ts_rversion" id="ts_rversion" type="hidden" value="#ts#" />
                                <table border="0" cellpadding="0" cellspacing="0" align="center">
                                   <tr>
                                        <td>
                                            Nivel Geografico:
                                        </td>
                                        <td>
                                           <cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="ConlistNivelesG" SoloEnArbol="true" Ppais="#form.Ppais#" readOnly="#modoDist EQ 'CAMBIO'#" Fuction="CambiarNivel">
                                                <cfif modoDist EQ 'CAMBIO'><cfinvokeargument name="NGid" value="#rsD.NGid#">
                                                <cfelseif modoNivel EQ 'CAMBIO'><cfinvokeargument name="NGid" value="#rsN.NGid#"></cfif>
                                           </cfinvoke>
                                        </td>
                                    </tr>
                                    <cfif modoNivel EQ 'CAMBIO' and LEN(TRIM(rsN.NGidPadre))>
										<tr>
											<td>
												Padre:
											</td>
											<td>
                                            	<cfif modoDist EQ 'CAMBIO' and (LEN(TRIM(rsD.DGidPadre)))>
                                             		<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="ConlistDistribuciones" NGid="#rsN.NGidPadre#" DGidPadre ="#rsD.DGidPadre#"/>
                                                <cfelse>
                                                	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="ConlistDistribuciones" NGid="#rsN.NGidPadre#"/>
                                                </cfif>
											</td>
										</tr>
                                   </cfif>
                                    <tr>
                                        <td>
                                            Codigo:
                                        </td>
                                        <td>
                                            <input name="DGcodigo" id="DGcodigo" type="text" value="#rsD.DGcodigo#" maxlength="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Descripción:
                                        </td>
                                        <td>
                                            <input name="DGDescripcion" id="DGDescripcion" type="text" value="#rsD.DGDescripcion#" maxlength="60" />
                                        </td>
                                    </tr>
									<tr>
										<td nowrap>Código Postal:&nbsp;</td>
										<td><input type="text" id="DGcodigoPostal" name="DGcodigoPostal" value="#rsD.DGcodigoPostal#" /></td>
									</tr>
                                    <tr>
                                        <td colspan="2">
                                            <cf_botones modo="#modoDist#" include="Regresar">
                                        </td>
                                    </tr>
                                </table>
                            </form>
                    </fieldset>
            </td>
         </tr>
         <tr>
             <td>
                <cfif modoNivel EQ 'CAMBIO'>
                     <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
                        query="#lsN#" 
                        conexion="asp"
                        desplegar="DGcodigo, DGDescripcion, DGcodigoPostal"
                        etiquetas="Codigo,Descripción, C.P"
                        formatos="S,S,S"
                        mostrar_filtro="true"
                      
                        align="left,left,left,"
                        checkboxes="N"
                        ira="#irA#?NGid=#form.NGid#"
                        keys="DGid"
                        formName="listaDist"
                        Cortes = "DGDescripcionPadre"
                        usaAJAX = "true">
                    </cfinvoke>
                 </cfif>
             </td>
         </tr>
    </table>
</cfoutput>
<cf_qforms>
        <cf_qformsRequiredField name="DGcodigo" 	 description="Codigo">
        <cf_qformsRequiredField name="DGDescripcion" description="Descripción">
        <cf_qformsRequiredField name="NGid" 	 	 description="Nivel Geográfico">
    <cfif modoNivel EQ 'CAMBIO' and LEN(TRIM(rsN.NGidPadre))>
    	<cf_qformsRequiredField name="DGidPadre" 	 description="Padre">
    </cfif>
</cf_qforms>
<script language="javascript" type="text/javascript">
	var Mask_1 = new Mask("****", "string");
		Mask_1.attach(document.form1.DGcodigo, Mask_1.mask, "string");
	function filtrar_Plista(){/*sobreEscribe la funcion del Filtrar el plista, ya que la misma Cambia el Action del Form*/}
	function CambiarNivel(){window.location.href = "../../asp/Geografica/Catalogos/DistrGeografico.cfm?NGid="+document.form1.NGid.value;}
	function funcRegresar(){
		objForm.DGcodigo.required=false;
		objForm.DGDescripcion.required=false;
		objForm.NGid.required=false;
		<cfif modoNivel EQ 'CAMBIO' and LEN(TRIM(rsN.NGidPadre))>
		objForm.DGidPadre.required=false;
		</cfif>
}
</script>