<cfinclude template="Funciones.cfm">
<cfinvoke  key="Msg_SePreSigErr" default="Se presentaron los siguientes errores:\n\n" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_SePreSigErr" />
<cfinvoke  key="Msg_LaDescr" default="La Descripción" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_LaDescr" />
<cfinvoke  key="Msg_esreq" default="es requerido.\n" component="sif.Componentes.Translate" method="Translate"
returnvariable="Msg_esreq" />

<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion
	from ConceptoContableE 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<style type="text/css">
	.corteConsulta {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>
<cfoutput>
<script language="JavaScript" type="text/javascript">
	<!--
		var popUpWin=0;
		function popUpWindow(URLStr, left, top, width, height)
		{
			if(popUpWin)
			{
			if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		function doConlisIDcontable() {
			popUpWindow("ConlisPolizas.cfm?form=form1&id=IDcontable&desc=Poliza",50,200,950,450);
		}
		function MM_findObj(n, d) { //v4.01
			var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
			if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
			for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
			if(!x && d.getElementById) x=d.getElementById(n); return x;
		}
		function MM_validateForm() { //v4.0
			var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
			for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
			if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
				if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
				if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
				} else if (test!='R') { num = parseFloat(val);
				if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
				if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
					min=test.substring(8,p); max=test.substring(p+1);
					if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
			} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' #Msg_esreq#'; }
			} if (errors) alert('#Msg_SePreSigErr#'+errors);
			document.MM_returnValue = (errors == '');
		}
		function showLink(c) {
			var a = document.getElementById("linkP");
			if (c.value != '') {
				a.style.display = "";
			} else {
				a.style.display = "none";
			}
		}
		function hideLink() {
			var a = document.getElementById("linkP");
			a.style.display = "none";
		}
		
		function go() {
			location.href="../consultas/SQLPolizaConta.cfm?IDcontable=" + document.form1.IDcontable.value + "&Cconcepto=" + document.form1.Cconcepto.value + "&Edocumento=";
		}
	//-->
</script>
</cfoutput>

<cfinvoke  key="LB_Titulo" default="Copiar / Reversar Documentos Contables" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="CopiaAsientos.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Copiar" 		default="Copiar" returnvariable="BTN_Copiar" component="sif.Componentes.Translate" method="Translate" 
xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" 
xmlfile="/sif/generales.xml"/>
	<cf_templateheader title="#LB_Titulo#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					
						<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
						<cfset PolizaE = t.Translate('LB_Poliza','P&oacute;liza')>
						<cfset PolizaList = t.Translate('PolizaList','Lista de P&oacute;lizas Contables')>
						<cfset PolizaSel = t.Translate('LB_PolizaSel','Seleccionar P&oacute;liza a Copiar')>
						<cfset PolizaCon = t.Translate('PolizaCon','Consultar P&oacute;liza')>
						<cfset PolizaDat = t.Translate('LB_PolizaDat','Datos de Nueva P&oacute;liza')>
						<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
						
						<cfoutput>
						<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
							<tr align="left"> 
								<td>
									<cfinclude template="../../portlets/pNavegacion.cfm">
								</td>
							</tr>
							</cfoutput>
						</table>
						<!---<table width="100%" align="center"><tr><td align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Reversar_documentos_contables.htm"></td></tr></table>--->
						<form action="SQLCopiaAsientos.cfm" method="post" name="form1" onSubmit="MM_validateForm('Poliza','','R','Eperiodo','','RinRange1980:2050','Edescripcion','','R','Edocbase','','R');return document.MM_returnValue">
							<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr> 
									<td colspan="6">&nbsp;</td>
								</tr>
								<tr> 
									<td colspan="6" class="corteConsulta"><cfoutput>#PolizaSel#</cfoutput></td>
								</tr>
								<tr> 
									<td colspan="6">&nbsp;</td>
								</tr>
								<tr> 
									<td colspan="4"><cfoutput>#PolizaE#</cfoutput>: 
										<input name="Poliza" type="text" size="40" alt="<cfoutput>#PolizaE#</cfoutput>" onSelect="javascript:showLink(this);" readonly="readonly"> 
										<a href="#"><img src="../../imagenes/Description.gif" alt="<cfoutput>#PolizaList#</cfoutput>" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisIDcontable();"></a> 
										<a id="linkP" href="javascript:go()" style="display: none"><img src="../../imagenes/find.small.png" alt="<cfoutput>#PolizaCon#</cfoutput>" name="imagen" width="16" height="16" border="0" align="absmiddle"></a> 
										<input name="IDcontable" type="hidden" id="IDcontable" vale=""> 
                                        <input name="intercompany" type="hidden" id="intercompany" vale=""> 
									</td>
									<td width="13%" colspan="1"><cf_translate key=LB_Reversar>Reversar </cf_translate>
										<input name="chkReversar" type="checkbox" id="chkReversar" value="1"> 
								  	</td>		
								  	<td width="14%" colspan="1"><cf_translate key=LB_CopiaOri>Copiar Origen </cf_translate>
                                    	<input name="chkCopiarOri" type="checkbox" id="chkCopiarOri" value="1" />
									</td>							
								</tr>
								<tr> 
									<td colspan="6">&nbsp;</td>
								</tr>
								<tr> 
									<td colspan="6" class="corteConsulta"><cfoutput>#PolizaDat#</cfoutput></td>
								</tr>
								<tr> 
									<td colspan="6" nowrap>&nbsp;</td>
								</tr>
								<tr> 
								  <td width="9%" nowrap> <cf_translate key=LB_Lote>Lote</cf_translate>: </td>
									<td width="41%" nowrap>
										<select name="Cconcepto">
											<cfoutput query="rsConceptos"> 
											<option value="#rsConceptos.Cconcepto#">#rsConceptos.Cdescripcion#</option>
											</cfoutput>
										</select>
								  </td>
									<td width="8%" nowrap><cf_translate key=LB_Periodo> Per&iacute;odo</cf_translate>: </td>
									<td width="15%" nowrap><input name="Eperiodo" type="text" value="<cfoutput>#periodo#</cfoutput>" maxlength="4" alt="El Período"></td>
									<td nowrap> <cf_translate key=LB_Mes>Mes</cf_translate>: </td>
									<td nowrap>
										<select name="Emes" size="1"><cfoutput>
											<option value="1" <cfif #mes# EQ 1>selected</cfif>>#CMB_Enero#</option>
											<option value="2" <cfif #mes# EQ 2>selected</cfif>>#CMB_Febrero#</option>
											<option value="3" <cfif #mes# EQ 3>selected</cfif>>#CMB_Marzo#</option>
											<option value="4" <cfif #mes# EQ 4>selected</cfif>>#CMB_Abril#</option>
											<option value="5" <cfif #mes# EQ 5>selected</cfif>>#CMB_Mayo#</option>
											<option value="6" <cfif #mes# EQ 6>selected</cfif>>#CMB_Junio#</option>
											<option value="7" <cfif #mes# EQ 7>selected</cfif>>#CMB_Julio#</option>
											<option value="8" <cfif #mes# EQ 8>selected</cfif>>#CMB_Agosto#</option>
											<option value="9" <cfif #mes# EQ 9>selected</cfif>>#CMB_Setiembre#</option>
											<option value="10" <cfif #mes# EQ 10>selected</cfif>>#CMB_Octubre#</option>
											<option value="11" <cfif #mes# EQ 11>selected</cfif>>#CMB_Noviembre#</option>
											<option value="12" <cfif #mes# EQ 12>selected</cfif>>#CMB_Diciembre#</option>
                                            </cfoutput>
										</select>
									</td>
								</tr>
                                <cfoutput>
								<tr> 
									<td nowrap><cf_translate key=LB_Descripcion> Descripci&oacute;n</cf_translate>: </td>
									<td nowrap><input name="Edescripcion" type="text" value="" size="63" maxlength="100" alt="#Msg_LaDescr#"> 
									<script language="JavaScript">document.form1.Edescripcion.focus();</script></td>
									<td colspan="2" nowrap>&nbsp;</td>
									<td colspan="2" nowrap>&nbsp;</td>
								</tr>
                               
								<tr> 
									<td nowrap><cf_translate key=LB_Fecha> Fecha</cf_translate>: </td>
									<td nowrap>
									<cf_sifcalendario name="Efecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
									</td>
									<td nowrap><cf_translate key=LB_Referencia> Referencia</cf_translate>: </td>
									<td nowrap><input name="Ereferencia" type="text" value="" size="25" maxlength="25"></td>
									<td nowrap><cf_translate key=LB_Documento> Documento</cf_translate>: </td>
									<td nowrap><input name="Edocbase" type="text" value="" size="20" alt="#LB_Documento#" maxlength="20"></td>
								</tr>
                                 </cfoutput>
								<tr> 
									<td colspan="6" nowrap>&nbsp;</td>
								</tr>
								<tr align="center"> 
                                	<cfoutput>
									<td colspan="6" nowrap> <input name="btnCopiar" type="submit" id="btnCopiar" value="#BTN_Copiar#"> 
									<input name="btnReset" type="reset" id="btnReset" value="#BTN_Limpiar#" onClick="javascript:hideLink();"> 
									</td>
                                    </cfoutput>
								</tr>
							</table>
						</form>
				</td>	
			</tr>	
		</table>	
		<cf_web_portlet_end>
	<cf_templatefooter>