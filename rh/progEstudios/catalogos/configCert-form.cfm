<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_CodigodeBeca" Default="Tipo de Beca" returnvariable="MSG_CodigodeBeca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Detalle" Default="Detalle" returnvariable="MSG_Detalle" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Variable" Default="Variable" returnvariable="MSG_Variable" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

<cfset excludeBTN = "">
<cfset readonly = false>
<cfset readonlyD = false>
<cfif isdefined('form.RHECCBid') and len(trim(form.RHECCBid))>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEConfig" returnvariable="rsConfig">
        <cfinvokeargument name="RHECCBid" 			value="#form.RHECCBid#">
    </cfinvoke>
	<cfset modo = "CAMBIO">
    <cfset excludeBTN = "CAMBIO">
    <cfset readonly = true>
    <cfif isdefined('form.RHTBDFid') and len(trim(form.RHTBDFid))>
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetDConfig" returnvariable="rsDConfig">
        	<cfinvokeargument name="RHECCBid" 			value="#form.RHECCBid#">
            <cfinvokeargument name="RHTBDFid" 			value="#form.RHTBDFid#">
   		</cfinvoke>
    	<cfset modoD = "CAMBIO">
        <cfset readonlyD = true>
    </cfif>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
   		<form name="form1" method="post" action="configCert-sql.cfm">
		<tr>
			<td align="right"><strong>Tipo de Beca:</strong></td>
            <td>
            <cfset valuesArray = ArrayNew(1)>
			<cfif modo eq 'CAMBIO' and len(trim(form.RHECCBid)) gt 0>
                <cfquery name="rsTBeca" datasource="#session.DSN#">
                    select RHTBid,RHTBcodigo,RHTBdescripcion
                    from RHTipoBeca
                    where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConfig.RHTBid#">
                </cfquery>
              	<cfset ArrayAppend(valuesArray, rsTBeca.RHTBid)>
             	<cfset ArrayAppend(valuesArray, rsTBeca.RHTBcodigo)>
              	<cfset ArrayAppend(valuesArray, rsTBeca.RHTBdescripcion)>
            </cfif>
            <cf_conlis
                    campos="RHTBid,RHTBcodigo,RHTBdescripcion"
                    desplegables="N,S,S"
                    modificables="N,S,N"
                    size="0,10,50"
                    title="Becas del Empleado"
                    tabla="RHTipoBeca"
                    columnas="RHTBid, RHTBcodigo, RHTBdescripcion"
                    filtro="RHTBesCorporativo = 1 or (RHTBesCorporativo = 0 and  Ecodigo = #session.Ecodigo#)"
                    desplegar="RHTBcodigo, RHTBdescripcion"
                    filtrar_por="RHTBcodigo|RHTBdescripcion"
                    filtrar_por_delimiters="|"
                    etiquetas="C&oacute;digo,Descripci&oacute;n"
                    formatos="S,S"
                    align="left,left"
                    asignar="RHTBid,RHTBcodigo,RHTBdescripcion"
                    asignarformatos="I,S,S"
                    showEmptyListMsg="true"
                    form = "form1"
                    tabindex = "1"
                    readonly="#readonly#"
                    valuesArray="#valuesArray#"
                >
            </td>
            <td width="6%">
                <div align="right">
                    <!---<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">--->
                    <img style="cursor:pointer;" src="/cfmx/sif/imagenes/Help02_T.gif" onclick="javascrip:popUpWindowimgAyuda();" />
                </div>
            </td>
        </tr>
        <tr>
        	<td colspan="3">
            	<cf_botones modo="#modo#" sufijo="EC" exclude="#excludeBTN#">
                <cfif modo eq 'CAMBIO'>
              		<input type="hidden" name="RHECCBid" value="#form.RHECCBid#" />
                </cfif>
			</td>
        </tr>
        </form>
        <cfif modo eq 'CAMBIO' and len(trim(form.RHECCBid)) gt 0>
        <tr>
        	<td colspan="3"><fieldset><legend>Variables</legend>
            	<table width="100%" border="0" cellspacing="1" cellpadding="1">
                	<form name="form2" method="post" action="configCert-sql.cfm">
                	<tr>
                    	<td><strong>Detalle:</strong></td>
                        <td>
                        	<cfset valuesArray = ArrayNew(1)>
							<cfif modoD eq 'CAMBIO' and len(trim(form.RHTBDFid)) gt 0>
                                <cfquery name="rsDF" datasource="#session.DSN#">
                                    select RHTBDFid,RHTBDFetiqueta
                                    from RHTipoBecaDFormatos
                                    where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDConfig.RHTBDFid#">
                                </cfquery>
                                <cfset ArrayAppend(valuesArray, rsDF.RHTBDFid)>
                                <cfset ArrayAppend(valuesArray, rsDF.RHTBDFetiqueta)>
                            </cfif>
                        	<cf_conlis
                                campos="RHTBDFid,RHTBDFetiqueta"
                                desplegables="N,S"
                                modificables="N,S"
                                size="0,64"
                                title="Lista de Formatos"
                                tabla="RHTipoBecaEFormatos etb inner join RHTipoBecaDFormatos dtb on dtb.RHTBEFid = etb.RHTBEFid"
                                columnas="RHTBDFid,RHTBDFetiqueta"
                                filtro="etb.RHTBid = #rsConfig.RHTBid# and dtb.RHTBDFcapturaB is null order by RHTBDFetiqueta"
                                desplegar="RHTBDFetiqueta"
                                filtrar_por="RHTBDFetiqueta"
                                filtrar_por_delimiters="|"
                                etiquetas="Etiqueta"
                                formatos="S"
                                align="left"
                                asignar="RHTBDFid,RHTBDFetiqueta"
                                asignarformatos="I,S"
                                showEmptyListMsg="true"
                                form = "form2"
                                tabindex = "1"
                                readonly="#readonlyD#"
                                valuesArray="#valuesArray#"
                            >
                        </td>
                    </tr>
                    <tr>
                    	<td><strong>Variable:</strong></td>
                        <td><input type="text" name="RHDCCBcodigo" size="100" maxlength="100" value="<cfif modoD eq 'CAMBIO'>#rsDConfig.RHDCCBcodigo#</cfif>"/></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_botones modo="#modoD#" sufijo="DC" exclude="">
                            <input type="hidden" name="RHECCBid" value="#form.RHECCBid#" />
                        </td>
        			</tr>
                  	</form>
                    <tr>
                    	<td colspan="2">
                        	<cfinvoke 
                             component="rh.Componentes.pListas"
                             method="pListaRH"
                             returnvariable="pListaRet">
                                <cfinvokeargument name="tabla" value="RHDConfigCertBecas dccb inner join RHTipoBecaDFormatos tb on tb.RHTBDFid = dccb.RHTBDFid"/>
                                <cfinvokeargument name="columnas" value="dccb.RHECCBid, tb.RHTBDFid, RHTBDFetiqueta, RHDCCBcodigo"/>
                                <cfinvokeargument name="desplegar" value="RHTBDFetiqueta, RHDCCBcodigo"/>
                                <cfinvokeargument name="etiquetas" value="Etiqueta, Variable"/>
                                <cfinvokeargument name="formatos" value="V, V"/>
                                <cfinvokeargument name="filtro" value="dccb.Ecodigo = #session.Ecodigo# and dccb.RHECCBid = #form.RHECCBid#"/>
                                <cfinvokeargument name="align" value="left, left"/>
                                <cfinvokeargument name="ajustar" value="S"/>
                                <cfinvokeargument name="formname" value="lista2"/>
                                <cfinvokeargument name="checkboxes" value="N"/>				
                                <cfinvokeargument name="irA" value="configCert.cfm"/>
                                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                <cfinvokeargument name="keys" value="RHECCBid,RHTBDFid"/>
                            </cfinvoke>
                        </td>
                    </tr>
                </table>
            </fieldset></td>
        </tr>
        </cfif>
	</table>
 <cf_qforms form="form1" objForm="objForm">
 <cfif isdefined('form.RHTBid')>
 <cf_qforms form="form2" objForm="objForm2">
 </cfif>   
    <script language="javascript1.2" type="text/javascript">

		<cfoutput>
		objForm.RHTBcodigo.description = "#JSStringFormat('#MSG_CodigodeBeca#')#";
 	<cfif isdefined('form.RHTBid')>
		objForm2.RHTBDFid.description = "#JSStringFormat('#MSG_Detalle#')#";
		objForm2.RHDCCBcodigo.description = "#JSStringFormat('#MSG_Variable#')#";
	</cfif>	
		
		function deshabilitarValidacion(){
			objForm.RHTBcodigo.required = false;
		<cfif isdefined('form.RHTBid')>
			objForm2.RHTBDFid.required =false;
			objForm2.RHDCCBcodigo.required =false;
		</cfif>	
			}
		
		function habilitarValidacion(){
			objForm.RHTBcodigo.required = true;
		<cfif isdefined('form.RHTBid')>
			objForm2.RHTBDFid.required =true;
			objForm2.RHDCCBcodigo.required =true;
		</cfif>	
		}
		
		habilitarValidacion();
		</cfoutput>

    	var popUpWinimgAyuda=0;
		
		function popUpWindowimgAyuda(){
			ww = 650;
			wh = 550;
			wl = 250;
			wt = 200;
		
			if(popUpWinimgAyuda){
				if(!popUpWinimgAyuda.closed) popUpWinimgAyuda.close();
			}
		
			popUpWinimgAyuda = open('/cfmx/rh/progEstudios/catalogos/configCert-ayuda.cfm', 'popUpWinimgAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');			
		}
	</script>
</cfoutput>
