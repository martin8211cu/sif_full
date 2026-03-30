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
<!--- Proveduria Corporativa --->
		<cfset lvarProvCorp = false>
        <cfset lvarFiltroEcodigo = Session.Ecodigo>
        <cfquery name="rsProvCorp" datasource="#session.DSN#">
            select Pvalor 
            from Parametros 
            where Ecodigo=#session.Ecodigo#
            and Pcodigo=5100
        </cfquery>
        <cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
            <cfset lvarProvCorp = true>
            <cfquery name="rsEProvCorp" datasource="#session.DSN#">
                select EPCid
                from EProveduriaCorporativa
                where Ecodigo = #session.Ecodigo#
                 and EPCempresaAdmin = #session.Ecodigo#
            </cfquery>
            <cfif rsEProvCorp.recordcount gte 1>
                <cfquery name="rsDProvCorp" datasource="#session.DSN#">
                    select DPCecodigo as Ecodigo, Edescripcion
                    from DProveduriaCorporativa dpc
                        inner join Empresas e
                            on e.Ecodigo = dpc.DPCecodigo
                    where dpc.Ecodigo = #session.Ecodigo#
                     and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
                    union
                    select e.Ecodigo, e.Edescripcion
                    from Empresas e
                    where e.Ecodigo = #session.Ecodigo#
                    order by 2
                </cfquery>
				<!--- Creacion de la lista de Empresas del corporativo--->
                <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
               	 	<cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
                </cfloop>
            </cfif>    
            <cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
                <cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
            </cfif>
            <cfif isdefined("Form.Ecodigo_f") and Form.Ecodigo_f neq Session.Compras.ProcesoCompra.Ecodigo>
                <cfset Session.Compras.ProcesoCompra.Ecodigo = Form.Ecodigo_f>
                <cfset Session.Compras.ProcesoCompra.DSlinea = "">
            </cfif>
            <cfif isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
                <cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
            </cfif>
        </cfif>
        <cfquery name="rsTipoOrdenes" datasource="#Session.DSN#">
            SELECT * FROM CMTipoOrden 
            WHERE Ecodigo = #session.Ecodigo#
        </cfquery>

<cf_templateheader title="Compras - Estad&iacute;sticas de compras por Comprador">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Rango de Compradores'>
        

		<form name="form1" method="post" action="" >
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Estad&iacute;sticas de compras por Comprador" skin="info1">
										<div align="justify">
											<p> 
											&Eacute;ste reporte muestra las estad&iacute;sticas de las compras por comprador resumido o detallado. &Uacute;nicamente para las ordenes de compra surtidas parcialmente o totalmente.</p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					
					<td width="60%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
							<tr>
                            	<td nowrap align="right"><strong>Tipo de Reporte</strong></td>
                            	<td width="34%" >
                                		&nbsp;<select name="TipoReporte" onchange="javascript: mostrarCheckFechas();">
                                            <option value="0">Resumido</option>
                                            <option value="1">Detallado</option>
                                        </select>
                                </td>
                            </tr>
                            <tr>
								<td width="19%" align="right" nowrap><strong>Del Comprador:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									&nbsp;<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(1,this.value);" >
									<input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores1();'></a>
									<input type="hidden" name="CMCid1" value="" >
								</td>
							</tr>
						
							<tr>
								<td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									&nbsp;<input type="text" name="CMCcodigo2" maxlength="10" value="" size="10" onBlur="javascript:comprador(2,this.value);" >
									<input type="text" name="CMCnombre2" id="CMCnombre2" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores2();'></a>
									<input type="hidden" name="CMCid2" value="" >
								</td>
							</tr>
                            <cfif rsEProvCorp.recordcount gte 1>
                                <tr>
                                    <td nowrap align="right"><strong>Empresa:&nbsp;</strong></td>
                                    <td colspan="2">
                                        &nbsp;<select name="EcodigoE">
                                            <option value="<cfoutput>#Ecodigos#</cfoutput>">--Todas--</option>
                                            <cfloop query="rsDProvCorp">
                                                <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ lvarFiltroEcodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                            </cfloop>	
                                        </select>  
                                    </td>
                                </tr>
                             <cfelse>
                             	<input type="hidden" name="EcodigoE" value="-2"/>
                            </cfif>
                            
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
                                            <td width="2%">&nbsp;</td>
                                            <td width="53%" align="left">
                                                <input type="radio" id="TipoRango2" name="TipoRango" onclick="javascript:CambioRango();"/>
                                                 Por Periodo - Mes
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                        	</tr>
                            <tr id="PeriodoMes" style="display:none">
                                <td align="right"><strong>Periodo:&nbsp;</strong></td>
                                <td>
                                    &nbsp;<select name="Periodo" id="Periodo">
                                    <cfloop query = "rsPeriodos">
                                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                                    </cfloop>
                                    </select>
                                </td>
                                <td width="45%">    
                                <strong>&nbsp;Mes:</strong>
                                    &nbsp;<select name="Mes" id="Mes">
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
                                <td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
                                <td>
                                    <cf_sifcalendario name="fechaDes">
                                </td>
                               <td  align="left" ><strong>&nbsp;&nbsp;Fecha Hasta:&nbsp;</strong></td>
                                <td width="2%" align="left">
                                    <cf_sifcalendario name="fechaHas">
                                </td>
							</tr>
                            
                            <tr>
                            	<td nowrap align="right"><strong>Tipo:&nbsp;</strong></td>
                            	<td width="34%" >
                                		&nbsp;<select name="Tipo" onchange="javascript:cambio_TiposOC(this);">
                                            <option value="T">---Todas---</option>
                                            <option value="L">Local</option>
                                            <option value="I">Internacional</option>
                                        </select>
                                </td>
                            </tr>
                             <tr>
                            	<td nowrap align="right"><strong>Tipo de &Oacute;rden:&nbsp;</strong></td>
                            	<td width="34%" >
                                		&nbsp;<select name="TipoOrden">
                                        	<option value="T">---Todas---</option>
                                        </select>
                                </td>
                            </tr>
                             <!--- <tr>
                                <td align="right" valign="baseline"><strong>Exportar a Excel:</strong></td>
                                <td>
                                	<input type="checkbox" name="toExcel" />
                                </td>    
                            </tr> --->
                            <tr id="MostrarFechas" style="display:none">
                                <td align="right" valign="baseline"><strong>Mostrar Fechas:</strong></td>
                                <td>
                                	<input type="checkbox" name="showDates" />
                                </td>    
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
								<td align="center" colspan="4">
									<input type="button" name="Consultar" class="btnNormal" value="Consultar" onclick="javascript: tipoReporte();">
                                    <input type="reset"  name="Limpiar" class="btnNormal" value="Limpiar">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>

		<cf_web_portlet_end>
	<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
		
			function doConlisCompradores1() {
				var params = "";
					params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1&Ecodigo=-1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function doConlisCompradores2() {
				var params = "";
					params = "?formulario=form1&CMCid=CMCid2&CMCcodigo=CMCcodigo2&desc=CMCnombre2&Ecodigo=-1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function comprador(opcion, value){
				if ( value !='' ){
					document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion+"&Ecodigo=-1";
				}
			}
			
			function tipoReporte()
			{
				if(document.form1.TipoReporte.value == 0)
				{
					document.form1.action = "OrdenesSurtidasComprador-form.cfm";
				}else{
					document.form1.action = "OrdenesSurtidasComprador-form-detalle.cfm";						
				}
					document.forms["form1"].submit();
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
		
		function mostrarCheckFechas(){
			if(document.getElementById('MostrarFechas').style.display == 'none')
			return document.getElementById('MostrarFechas').style.display = '';
			document.getElementById('MostrarFechas').style.display = 'none';
		}
		
		function cambio_TiposOC(obj){
			var form = obj.form;
			var combo = form.TipoOrden;
			
			combo.length = 1;
			combo.options[0].text = '-- Todas --';
			combo.options[0].value = 'T';
			var i = 1;
			<cfoutput query="rsTipoOrdenes">
				var tmp = #rsTipoOrdenes.CMTOimportacion#;
				if (obj.value == 'T')
					{
						combo.length++;
						combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
						combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
						i++;
					}else
					{
						if (obj.value == 'I' && tmp== 1) {
								combo.length++;
								combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
								combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
								i++;
							}else{	
									if (obj.value == 'L' && tmp == 0) {	
										combo.length++;
										combo.options[i].text = '#rsTipoOrdenes.CMTOdescripcion#';
										combo.options[i].value = '#rsTipoOrdenes.CMTOcodigo#';
										i++;
									}
							}	
					}
			</cfoutput>
		}
		</script>