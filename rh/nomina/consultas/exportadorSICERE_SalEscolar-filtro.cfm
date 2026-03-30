<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar" Default="Generaci&oacute;n de Archivo Salario Escolar para SICERE" returnvariable="LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AyudaDelExportador" Default="Ayuda del Exportador" returnvariable="LB_AyudaDelExportador"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" XmlFile="/rh/generales.xml"returnvariable="BTN_Generar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes" Default="Debe seleccionar un Periodo y Mes" returnvariable="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ValidaConceptoParaSalarioEscolar" Default="Debe seleccionar un Concepto de Pago para Salario Escolar" returnvariable="MSG_ValidaConceptoParaSalarioEscolar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ElTipoDeConceptoYaFueAgregado" Default="Este Concepto de Pago ya fue agregado" returnvariable="MSG_ElTipoDeConceptoYaFueAgregado"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%">
		<tr>
			<td width="50%" valign="top">
				<cf_web_portlet_start tipo="mini" titulo="#LB_AyudaDelExportador#" tituloalign="left" wifth="300" height="300">
					<table>
						<tr>
							<td><p><cf_translate key="LB_Ayuda_Sicere">Reporte para ser enviado a SICERE, Incluye los conceptos que se  indiquen en la lista</cf_translate>.</p>
						    </p></td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_GeneracionDeArchivoParaSICEREsobreSalarioEscolar#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">		
					<cfoutput>
					<form name="form1" method="post" action="exportadorSICERE_SalEscolar-form.cfm" onSubmit="javascript: return funcValidar();">
						<table width="98%" cellpadding="3" cellspacing="0" align="center" border="0">			
							<tr>
								<td align="left"><b><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;</b>
									<select name="periodo">
										<option value=""></option> 
										<option value="#year(DateAdd("yyyy", -1, now()))#">#year(DateAdd("yyyy", -1, now()))#</option>
										<cfloop index="i" from="0" to="2">
											<cfset vn_anno = year(DateAdd("yyyy", i, now()))>
											<option value="#vn_anno#">#vn_anno#</option>
										</cfloop>
									</select>
							  	</td>
							</tr>
							<tr>	
							  <td width="4%" align="left" nowrap="nowrap"><b><cf_translate key="LB_Mes">Mes</cf_translate>:&nbsp;</b>
								<select name="mes">
									<option value=""></option> 						
									<cfloop query="rsMeses">
										<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
									</cfloop>
								</select>
							  </td>				
							</tr>
							<tr>
							<td nowrap align="left"> <strong><cf_translate  key="LB_ConceptoDePagoParaSalarioEscolar">Concepto(s) de Pago para Salario Escolar</cf_translate> :&nbsp;</strong></td>
							</tr>
							<tr>
								<td>
									<table>
										<tr>
											<td><cf_rhCIncidentes Omitir=""></td>
											<td><input type="button" name="btnAgregar" value="+" onClick="javascript: funcNuevoConcepto();"></td>
										</tr>
									</table>		
								</td>
							</tr>
							<tr><!---- espacio para la lista de conceptos----->
								<td>
									<table id="tConceptos" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
										<tbody></tbody>
									</table>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>				
								<td align="center">
									<input type="submit" name="btnGenerar" value="#BTN_Generar#" class="BTNAplicar">
								</td>
							</tr>		
							<tr><td>&nbsp;</td></tr>				
						</table>	
						<input type="hidden" name="LastOneConcepto" id="LastOneConcepto" value="ListaNon" tabindex="1">
						<input type="hidden" name="CIidlist" id="CIidlist" value="" tabindex="1">
						<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
					</form>
					<script type="text/javascript" language="javascript1.2">
						function funcValidar(){
							if (document.form1.periodo.value == '' || document.form1.mes.value == ''){
									alert('#MSG_DebeSeleccionarUnaNominaOUnPeriodoMes#');
									return false;			
							}			
							
							if (vnContadorListas1 <= 0){
									alert('#MSG_ValidaConceptoParaSalarioEscolar#');
									return false;
							}	
										
							return true;
						}
			var vnContadorListas1 = 0;
			function funcNuevoConcepto(){				
				var LvarTable = document.getElementById("tConceptos");
				var LvarTbody = LvarTable.tBodies[0];
				var LvarTR    = document.createElement("TR");
				var Lclass 	= document.form1.LastOneConcepto;
				var p1 = document.form1.CIid.value.toString(); //id del tipo
				var p2 = document.form1.CIcodigo.value.toString(); //codigo del tipo
				var p3 = document.form1.CIdescripcion.value.toString(); //descripcion del tipo
				var p6 = "CIidlist";
				vnContadorListas1 = vnContadorListas1 + 1;
				document.form1.CIid.value = '';
				document.form1.CIcodigo.value = '';
				document.form1.CIdescripcion.value = '';
				
				// Valida no agregar vacos
				if (p1=="") return;	  
				// Valida no agregar repetidos
				if (existeConcepto(p1)) {alert('#MSG_ElTipoDeConceptoYaFueAgregado#');return;}
				// Agrega Columna 0 - TDid
				sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", p6);
				// Agrega Columna 1 - TDcodigo
				sbAgregaTdText  (LvarTR, Lclass.value, p2);
				// Agrega Columna 2 - TDdescripcion
				sbAgregaTdText (LvarTR, Lclass.value, p3);
				//Agrega Colunma 3 - Imagen eliminar
				sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");

			  	if (document.all)
					GvarNewTD.attachEvent ("onclick", sbEliminarTR1);
			  	else
					GvarNewTD.addEventListener ("click", sbEliminarTR1, false);
				// Nombra el TR
				LvarTR.name = "XXXXX";
				// Agrega el TR al Tbody
				LvarTbody.appendChild(LvarTR);
				if (Lclass.value=="ListaNon")
				Lclass.value="ListaPar";
				else
				Lclass.value="ListaNon";
			}
			
			//Funcin para agregar TDs con Objetos
			function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
				var LvarTD    = document.createElement("TD");
				var LvarInp   = document.createElement("INPUT");
				LvarInp.type = LprmType;
				if (LprmName!="") LvarInp.name = LprmName;
				if (LprmValue!="") LvarInp.value = LprmValue;
				LvarTD.appendChild(LvarInp);
				if (LprmClass!="") LvarTD.className = LprmClass;
				GvarNewTD = LvarTD;
				LprmTR.appendChild(LvarTD);
			}	
			
			//Funcin para agregar TDs con texto
			function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
				var LvarTD    = document.createElement("TD");
				var LvarTxt   = document.createTextNode(LprmValue);
				LvarTD.appendChild(LvarTxt);
				if (LprmClass!="") LvarTD.className = LprmClass;
				GvarNewTD = LvarTD;
				LvarTD.noWrap = true;
				LprmTR.appendChild(LvarTD);
			}		
			
			//Funcin para agregar Imagenes
			function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
				// Copia una imagen existente
				var LvarTDimg    = document.createElement("TD");
				var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
				LvarImg.style.display="";
				LvarImg.align=align;
				LvarTDimg.appendChild(LvarImg);
				if (LprmClass != "") LvarTDimg.className = LprmClass;
				GvarNewTD = LvarTDimg;
				LprmTR.appendChild(LvarTDimg);
			}	
			
			function existeConcepto(v){
				var LvarTable = document.getElementById("tConceptos");
				for (var i=0; i<LvarTable.rows.length; i++){
					var value = new String(fnTdValue(LvarTable.rows[i]));
					var data = value.split('|');
					if (data[0] == v){
						return true;
					}
				}
				return false;
			}		
			
			function fnTdValue(LprmNode){
				var LvarNode = LprmNode;
				while (LvarNode.hasChildNodes()){
					LvarNode = LvarNode.firstChild;
					if (document.all == null){
					  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
						LvarNode.nextSibling.hasChildNodes())
						LvarNode = LvarNode.nextSibling;
					}
				}
				if (LvarNode.value)
				return LvarNode.value;
				else
				return LvarNode.nodeValue;
			}	
			function sbEliminarTR1(e){
				vnContadorListas1 = vnContadorListas1 - 1;
				var LvarTR;
				if (document.all)
					LvarTR = e.srcElement;
				else
					LvarTR = e.currentTarget;
				while (LvarTR.name != "XXXXX")
				LvarTR = LvarTR.parentNode;
				LvarTR.parentNode.removeChild(LvarTR);
			}

					</script>
					</cfoutput>
				<cf_web_portlet_end>
			</td>
		</tr>
	</table>	
<cf_templatefooter>
