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

<cfparam name="url.Ecodigo_f" default="#session.Ecodigo#">
<cfparam name="form.Ecodigo_f" default="#url.Ecodigo_f#">
<cf_templateheader title="Compras - &Oacute;rdenes de Compra-Resumen General">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ordenes de Compra-Resumen General'>

		<form name="form1" method="post" action="ReporteCristal-form.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="80%" align="center">
						<table width="50%" cellpadding="0" cellspacing="0" align="center" border="0">
							 <!----Busqueda por palabra especifica--->
							<tr>
								<td nowrap align="right"><strong>Busqueda por palabra especifica:</strong></td>
								<td width="50%" nowrap>
                                    <input type="text" size="40" name="SpecificWord" value="">
                                </td>
							</tr>
							<!--- Ordenes --->
                            <tr align="left">
                                <td width="50%" nowrap align="right"><strong>De la Orden:</strong></td>
                                <td width="50%" nowrap>
                                    <input type="hidden" name="EOidorden1" value="">
                                    <input type="text" size="10" name="EOnumero1" value="" onBlur="javascript:traerOrdenHasta(this.value,1);">
                                    <input type="text" size="25" readonly name="Observaciones1" value="" >
	                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra Resumen General" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(1);'></a> &nbsp;
                                </td>
                             </tr>
                            <tr>   
                                <td nowrap align="right"><strong>&nbsp;Hasta:</strong>&nbsp;</td>
                                <td width="50%" nowrap>
                                    <input type="hidden" name="EOidorden2" value="">
                                    <input type="text" size="10" name="EOnumero2" value="" onBlur="javascript:traerOrdenHasta(this.value,2);">
                                    <input type="text" size="25" readonly name="Observaciones2" value="" >
                                    <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(2);'></a>
                                </td>
                                <td width="1%">&nbsp;</td>
                            </tr>
							<!--- Centro Funcional --->
							<tr>
                            	<td nowrap align="right"><strong>Centro Funcional:&nbsp;</strong></td>
                            	<td width="14%" nowrap>
									<cf_rhcfuncionalCxP form="form1" size="26" id="CFid" name="CFcodigo" desc="CFdescripcion" tabindex="1">
                                </td>
							</tr>
                            <!--- Periodo  Fecha --->
                            <tr>
                            	<td style="text-align:right"><strong>Rango:&nbsp;</strong></td>
                                <td colspan="2" align="center">
                                    <table width="100%">
                                        <tr>
                                            <td align="left" width="45%">
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
                            <tr id="PeriodoMes" style="display:none">
                                <td align="right"><strong>Periodo:</strong></td>
                                <td>
                                    <select name="Periodo" id="Periodo">
                                    <cfloop query = "rsPeriodos">
                                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                                    </cfloop>
                                    </select>
                                <strong>Mes:</strong>
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
                            <input type="hidden" id="Rango" name="Rango" value="Fecha" />
                            <tr id="Fecha" style="display:">
                                <td align="right" width="50%"><strong>Fecha Desde:&nbsp;</strong></td>
                                <td>
                                    <cf_sifcalendario name="fechaDes">
                                </td>
                               <td align="left" ><strong>Fecha Hasta:&nbsp;</strong></td>
                                <td align="left">
                                    <cf_sifcalendario name="fechaHas">
                                </td>
							</tr>
                            <!--- Tipo de Orden --->
                            <tr>
                            	<td nowrap align="right"><strong>Tipo de &oacute;rden:&nbsp;</strong></td>
                            	<td >
                                		<select name="TipoOrden" >
                                        	<option value="T">---Todas---</option>
                                            <option value="L">Local</option>
                                            <option value="I">Internacional</option>
                                        </select>
                                </td>
                            </tr>
                            <!--- Exportar A excel --->
                            <tr>
                            	<td align="right"><strong>Exportar a Excel:&nbsp;</strong>
								</td>
                                <td><input type="checkbox" name="toExcel" /></td>
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
								<td align="center" colspan="4">
									<input type="submit" name="Consultar" value="Consultar" class="btnNormal">
                                    <input type="reset"  name="Limpiar" value="Limpiar" class="btnNormal">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		
		<cf_web_portlet_end>
	<cf_templatefooter>
    
<script language="JavaScript" type="text/javascript">
		var popUpWin = 0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		
		function doConlisOrdenesHasta(valor) {
			popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraHasta.cfm?idx="+valor+"&Estado=0",30,100,900,500);
		}
		
		function traerOrdenHasta(value, index){
		  if (value!=''){	   
		   document.getElementById("fr").src = 'traerOrdenHasta.cfm?EOnumero='+value+'&index='+index;
		  }
		  else{
		   document.form1.EOidorden1.value = '';
		   document.form1.EOnumero1.value = '';
		   document.form1.Observaciones1.value = '';
		   document.form1.EOidorden2.value = '';
		   document.form1.EOnumero2.value = '';
		   document.form1.Observaciones2.value = '';
		  }
		 }
		 
		 function CambioRango(){
			if(document.getElementById('TipoRango1').checked){
				document.getElementById('PeriodoMes').style.display='none';
				document.getElementById('Fecha').style.display='';
				document.getElementById('Rango').value='Fecha';
			}
			else {
				document.getElementById('Fecha').style.display='none';
				document.getElementById('PeriodoMes').style.display='';
				document.getElementById('Rango').value='PeriodoMes';
			}
	}	 
	</script>