<!---------
	
	Modificado por: Alejandro Bolaños APH
	Fecha de modificación: 19 de septiembre 2011
	Motivo:	Se agregan los filtros por periodo-mes
	
----------->

<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select distinct Speriodo
    from CGPeriodosProcesados
    where Ecodigo = #session.Ecodigo#
    order by Speriodo desc
</cfquery>

<cfset LvarTitulo = "Reporte de Conciliaci&oacute;n Bancaria Resumido TCE">

<cfif not isdefined("form.ECid") and  isdefined("url.ECid")>
	<cfset form.CBid = url.ECid>
</cfif>

<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
	
<cf_templateheader title="#LvarTitulo#">
	<cfinclude  template="../../portlets/pNavegacionMB.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>			
		<!---Para utilizar en Bancos con formConciliacionResumida.cfm o en TCE con formConciliacionResumidaTCE.cfm--->
		<form name="form1" method="post" onsubmit="return sinbotones()"  action="formConciliacionResumidaTCE.cfm">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="right" width="50%"><strong>Conciliaciones </strong></td>
					<td>				
						<select name="Conciliaciones">
							<option value="-1">Todas</option>
							<option value="1">Aplicadas</option>
							<option value="2">No Aplicadas</option>
						</select>
					</td>
				</tr>
				<tr>
                	<td colspan="2" align="center">
                    	<table width="80%">
                        	<tr>
                                <td align="right" width="45%">
                                    <input type="radio" id="TipoRango1" name="TipoRango" checked="checked" onclick="javascript:CambioRango();"/>
                                     Por fecha
                                </td>
                                <td width="10%">&nbsp;</td>
                                <td align="left" width="45%">
                                    <input type="radio" id="TipoRango2" name="TipoRango" onclick="javascript:CambioRango();"/>
                                     Por Periodo - Mes
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Fecha" style="display:">
					<td align="right" width="50%"><strong>Fecha del Estado de Cuenta:&nbsp;</strong></td>
					<td>
							<cf_sifcalendario name="EChasta">
					</td>
				</tr>
				<input type="hidden" id="Rango" name="Rango" value="Fecha" />
                <tr id="PeriodoMes" style="display:none">
                    <td align="center" colspan="2">
                    	<table width="30%">
                        	<tr>
                                <td align="right"><strong>Periodo:</strong></td>
                                <td>
                                	<select name="Periodo" id="Periodo">
                                    <cfloop query = "rsPeriodos">
                                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                                    </cfloop>
                               		</select>
                                </td>
                                <td align="right"><strong>Mes:</strong></td>
                                <td>
                                	<select name="Mes" id="Mes">
                                    	<option value="1"><cfoutput>#CMB_Enero#</cfoutput></option>
                                        <option value="2"><cfoutput>#CMB_Febrero#</cfoutput></option>
                                        <option value="3"><cfoutput>#CMB_Marzo#</cfoutput></option>
                                        <option value="4"><cfoutput>#CMB_Abril#</cfoutput></option>
                                        <option value="5"><cfoutput>#CMB_Mayo#</cfoutput></option>
                                        <option value="6"><cfoutput>#CMB_Junio#</cfoutput></option>
                                        <option value="7"><cfoutput>#CMB_Julio#</cfoutput></option>
                                        <option value="8"><cfoutput>#CMB_Agosto#</cfoutput></option>
                                        <option value="9"><cfoutput>#CMB_Setiembre#</cfoutput></option>
                                        <option value="10"><cfoutput>#CMB_Octubre#</cfoutput></option>
                                        <option value="11"><cfoutput>#CMB_Noviembre#</cfoutput></option>
                                        <option value="12"><cfoutput>#CMB_Diciembre#</cfoutput></option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnConsultar" value="Consultar">
						<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>            	
	 <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
		
	function limpiar(obj){
		var form = obj.form
		form.EChasta.value = "";
		form.Bid.value			 = '';
		form.CBid.value			 = '';
	}
	
	function CambioRango(){
		if(document.getElementById('TipoRango1').checked){
			document.getElementById('PeriodoMes').style.display='none';
			document.getElementById('Fecha').style.display='';
			document.getElementById('Rango').value='Fecha';
			objForm.EChasta.required = true;
		}
		else {
			document.getElementById('Fecha').style.display='none';
			document.getElementById('PeriodoMes').style.display='';
			document.getElementById('Rango').value='PeriodoMes';
			objForm.EChasta.required = false;
		}
	}

	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/*-------------------------*/		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha del Estado de Cuenta";
</script>