<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesDelBancoPopular" Default="Reporte de deducciones del Banco Popular" returnvariable="LB_ReporteDeDeduccionesDelBancoPopular"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>											
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeTiposDeDeduccion" Default="Lista de Tipos de Deduccion" returnvariable="LB_ListaDeTiposDeDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ElTipoDeDeduccionYaFueAgregado" Default="El tipo de deduccion ya fue agregado" returnvariable="MSG_TipoDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarAlMenosUnTipoDeDeduccion" Default="Debe seleccionar al menos un tipo de deduccion" returnvariable="MSG_SelTipoDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes" Default="Debe seleccionar una nomina o un periodo/mes" returnvariable="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeDeduccionesDelBancoPopular#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<cfoutput>
		<form name="form1" method="post" action="repDeduccionesBancoPopular-form.cfm" onSubmit="javascript: return funcValidar();">
		<table width="98%" cellpadding="3" cellspacing="0" align="center">			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right" nowrap>
					<b><cf_translate key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></b>		
				</td>
				<td>					
					<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: funcCambioNomina();" checked>				
				</td>
			</tr>
			<tr>
				<td align="right"><b><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;</b></td>
				<td>
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
				<td align="right"><b><cf_translate key="LB_Mes">Mes</cf_translate>:&nbsp;</b></td>
				<td>
					<select name="mes">
						<option value=""></option> 						
						<cfloop query="rsMeses">
							<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>	
			<tr id="NAplicadas">
				<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
				<td colspan="3">
					<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">
				</td>
			</tr>
			<tr id="NNoAplicadas" style="display:none">
				<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
				<td colspan="3">
					<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true">
				</td>
			</tr>
			<tr>				
				<td colspan="4" align="center">
					<input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar">
				</td>
			</tr>		
			<tr><td>&nbsp;</td></tr>				
			<!----Tipos de deduccion a incluir---->
			<tr>
				<td colspan="5" align="center">
					<fieldset><legend><cf_translate key="LB_TiposDeDeduccionAIncluir">Tipos de deducci&oacute;n a incluir</cf_translate></legend>
					<table width="98%" cellpadding="1" cellspacing="0" border="0">									
						<tr>
							<td align="right" width="30%"><b><cf_translate key="LB_TipoDeDeduccion">Tipo de deducci&oacute;n</cf_translate>:</b></td>
							<td width="40%">											
								<cf_conlis title="#LB_ListaDeTiposDeDeduccion#"
									campos = "TDid,TDcodigo,TDdescripcion" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,10,40"
									asignar="TDid,TDcodigo,TDdescripcion"
									asignarformatos="I,S,S"
									tabla="	TDeduccion "																	
									columnas="TDid,TDcodigo,TDdescripcion"
									filtro=" Ecodigo =#session.Ecodigo#"
									desplegar="TDcodigo,TDdescripcion"
									etiquetas="	#LB_CODIGO#, 
												#LB_DESCRIPCION#"
									formatos="S,S"
									align="left,left"
									showEmptyListMsg="true"
									debug="false"
									form="form1"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="TDcodigo,TDdescripcion">
							</td>
							<td width="20%">
								<input type="button" name="btnAgregar" value="+" onClick="javascript: funcNuevoTipo();">
							</td>										
						</tr>
						<tr>
							<td colspan="3">
								<table id="tDeduccion" style="display:none;" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
									<tbody></tbody>
								</table>
							</td>
						</tr>
					</table>
					</fieldset>
				</td>
			</tr>
		</table>	
		<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
		<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</form>
		<script type="text/javascript" language="javascript1.2">
			var vnContadorListas1 = 0;
			function funcNuevoTipo(){
				var LvarTable = document.getElementById("tDeduccion");
				var LvarTbody = LvarTable.tBodies[0];
				var LvarTR    = document.createElement("TR");
				var Lclass 	= document.form1.LastOneCalendario;
				var p1 = document.form1.TDid.value.toString(); //id del tipo
				var p2 = document.form1.TDcodigo.value.toString(); //codigo del tipo
				var p3 = document.form1.TDdescripcion.value.toString(); //descripcion del tipo
				var p6 = "TDidlist";
				vnContadorListas1 = vnContadorListas1 + 1;
				document.form1.TDid.value = '';
				document.form1.TDcodigo.value = '';
				document.form1.TDdescripcion.value = '';
				
				// Valida no agregar vacíos
				if (p1=="") return;	  
				// Valida no agregar repetidos
				if (existeTipoDeduccion(p1)) {alert('#MSG_TipoDeduccion#');return;}
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
			
			//Función para agregar TDs con Objetos
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
			
			//Función para agregar TDs con texto
			function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
				var LvarTD    = document.createElement("TD");
				var LvarTxt   = document.createTextNode(LprmValue);
				LvarTD.appendChild(LvarTxt);
				if (LprmClass!="") LvarTD.className = LprmClass;
				GvarNewTD = LvarTD;
				LvarTD.noWrap = true;
				LprmTR.appendChild(LvarTD);
			}		
			
			//Función para agregar Imagenes
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
			
			function existeTipoDeduccion(v){
				var LvarTable = document.getElementById("tDeduccion");
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
			
			function funcVerificar(){			
				document.getElementById("tDeduccion").style.display='';
				document.form1.TDid.value = '';
				document.form1.TDcodigo.value = '';
				document.form1.TDdescripcion.value = '';				
			}
			
			funcVerificar();
			
			function funcValidar(){
				if (vnContadorListas1 <= 0){
					alert('#MSG_SelTipoDeduccion#');
					return false;
				}				
				if (document.getElementById("TipoNomina").checked == true){
					if(document.form1.CPid1.value == '' && document.form1.periodo.value == '' && document.form1.mes.value == ''){
						alert('#MSG_DebeSeleccionarUnaNominaOUnPeriodoMes#');
						return false;
					}
				}
				else{
					if(document.form1.CPid2.value == '' && document.form1.periodo.value == '' && document.form1.mes.value == ''){
						alert('#MSG_DebeSeleccionarUnaNominaOUnPeriodoMes#');
						return false;
					}
				}	
				return true;
			}			
			function funcCambioNomina(){
				if (document.getElementById("TipoNomina").checked == true){
					document.getElementById("NAplicadas").style.display=''
					document.getElementById("NNoAplicadas").style.display='none'; 
					document.form1.CPid1.value = '';
					document.form1.CPcodigo1.value='';
					document.form1.CPdescripcion1.value = '';
				}
				else{
					document.getElementById("NAplicadas").style.display='none'
					document.getElementById("NNoAplicadas").style.display=''; 
					document.form1.CPid2.value = '';
					document.form1.CPcodigo2.value='';
					document.form1.CPdescripcion2.value = '';
				}
			}			
			funcCambioNomina();	
		</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
