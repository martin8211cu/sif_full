<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeCargasNominasAplicadas" Default="Reporte de Cargas Nóminas Aplicadas" returnvariable="LB_ReporteDeCargasNominasAplicadas"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Debeselecionarunperiodoymes" Default="Debe seleccionar un periodo y mes" returnvariable="MSG_Debeselecionarunperiodoymes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" 	Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" 	Default="Fecha Vence" returnvariable="LB_FechaVence"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" 		Default="Las fechas son requeridas" returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeTiposDeCarga" Default="Lista de Tipos de Cargas" returnvariable="LB_ListaDeTiposDeCarga"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Carga" 	Default="Deducci�n" returnvariable="MSG_Carga"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ElTipoDeCargaYaFueAgregado" Default="El tipo de Carga ya fue agregado" returnvariable="MSG_TipoCarga"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarAlMenosUnTipoDeCarga" Default="Debe seleccionar al menos un tipo de Carga" returnvariable="MSG_SelTipoCarga"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes" Default="Debe seleccionar una nomina o un periodo/mes" returnvariable="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" 	Default="Periodo" 	returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Mes" 		returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Grupo Oficinas" 		returnvariable="LB_Oficina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Tipo_de_Grupos_de_Oficinas" Default="Tipo de Grupos de Oficinas" returnvariable="LB_Tipo_de_Grupos_de_Oficinas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Todos" Default="Todos" returnvariable="LB_Todos"/>


<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsTipoCarga" datasource="#Session.DSN#">
	select DClinea, DCcodigo, DCdescripcion 
	from DCargas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">	
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeCargasNominasAplicadas#">
		<form name="form1" method="post" action="repCargasNominasAplicadas-form.cfm">
			<cfoutput>
				<table width="89%" cellpadding="3" cellspacing="0" align="center" border="0">
                	<tr>			
						<td align="right" width="272"><cf_translate  key="LB_TipoFiltro">Tipo de filtro</cf_translate>:&nbsp;</td>
						<td width="238">
                        	<input type="radio" checked onclick="javascript:mostrarTR(1);"  name="Tfiltro" value="1" />
                            <cf_translate  key="RAD_Periodo">Periodo</cf_translate>
                        </td>
						<td width="317" >
							<input onclick="javascript:mostrarTR(2);" type="radio" name="Tfiltro" value="2" />
			  				<cf_translate  key="RAD_RangodeFechas">Rango de Fechas</cf_translate>
                        </td>
					</tr>
                    <tr id="TR_Periodo">
                        <td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
                        <td colspan="2">
                            <select name="periodo">
                                <option value=""></option>
                                <cfloop index="i" from="-5" to="0">
                                    <cfset vn_anno = year(DateAdd("yyyy", i, now()))>
                                    <option value="#vn_anno#">#vn_anno#</option>
                                </cfloop>
                            </select>
                      	</td>
                      <cfset paso = 1>	
                    </tr>
                    <tr id="TR_Mes">
                        <td align="right"><b>#LB_Mes#:&nbsp;</b></td>
                        <td colspan="2">
                        	<select name="mes">	<option value=""></option>
                                <cfloop query="rsMeses">
                                    <option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
                                </cfloop>
                            </select>
                         </td>
                    </tr>
                    <tr id="TR_FechaDesde" style="display:none">
                        <td nowrap align="right"> <strong>#LB_FechaRige#:&nbsp;</strong></td>
                        <td colspan="2"><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
                        <cfset paso = 2>
                    </tr>
                    <tr id="TR_FechaHasta" style="display:none">
                        <td nowrap align="right"> <strong>#LB_FechaVence#:&nbsp;</strong></td>
                        <td colspan="2"><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
                    </tr>
<!---                   <tr id="TR_Oficina">
                        <td nowrap align="right"> <strong>#LB_Oficina#:&nbsp;</strong></td>
                        <td colspan="2">
                          	<input type="text" name="Id_Oficina" id="Id_Oficina" maxlength="10" size="12" />
                        </td>
                  </tr>--->
				<tr>
					<td  nowrap align="right"><b><cfoutput>#LB_Tipo_de_Grupos_de_Oficinas#</cfoutput></b>:</td>
					<td>
						<cfquery name="rsAnexoGOTipo" datasource="#Session.DSN#">
						   select GOTid, GOTnombre
							 from AnexoGOTipo p
						   where p.Ecodigo = #Session.Ecodigo#
						</cfquery>
						<select name="Oficina" id="Oficina" tabindex="9">
							<option value="TD,Todas las Oficinas">--<cfoutput>#LB_Todos#</cfoutput>--</option>
							<cfloop query="rsAnexoGOTipo">
								<optgroup label="<cfoutput>#rsAnexoGOTipo.GOTnombre#</cfoutput>">
									<cfquery name="rsSubgrupo" datasource="#Session.DSN#">
									   select distinct GOid, GOnombre
										 from AnexoGOTipo p
										 inner join AnexoGOficina ago
										 on ago.GOTid =  #rsAnexoGOTipo.GOTid#
										 and ago.Ecodigo = p.Ecodigo
									   where p.Ecodigo = #Session.Ecodigo#
									</cfquery>
										<cfloop query="rsSubgrupo">
											<cfoutput><option value="go,#rsSubgrupo.GOid#">#rsSubgrupo.GOnombre#</option></cfoutput>
										</cfloop>
							</cfloop>
							 </optgroup>
							<cfquery name="rsOficinas" datasource="#session.dsn#">
								select Ocodigo,Oficodigo,Odescripcion
								from Oficinas a
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
								order by Oficodigo
							</cfquery>
							<optgroup label="Oficina">
								<cfloop query="rsOficinas">
								   <cfoutput><option value="of,#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option></cfoutput>
								</cfloop>
							</optgroup>
						</select>
					</td>
				</tr>
				  <tr>		
				     <td align="right"><b><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</b></td>
					<td align="left">
						<cf_rhcfuncional>
					</td>
					<td><input type="checkbox" name="IncluirDependencias" id="IncluirDependencias"><cf_translate key="LB_IncluirDependencias">Incluir dependencias</cf_translate> 
				  </tr>	
                    <tr>
                        <td align="right"><b><cf_translate key="LB_ListaDeTiposDeCarga">Tipo de Carga</cf_translate>:</b></td>
                        <td>
                            <cf_conlis title="#LB_ListaDeTiposDeCarga#"
									campos = "DClinea,DCcodigo,DCdescripcion" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,10,40"
									asignar="DClinea,DCcodigo,DCdescripcion"
									asignarformatos="I,S,S"
									tabla="	DCargas"																	
									columnas="DClinea,DCcodigo,DCdescripcion"
									filtro=" Ecodigo =#session.Ecodigo#"
									desplegar="DCcodigo,DCdescripcion"
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
									filtrar_por="DCcodigo,DCdescripcion">
                        </td>
                         <td>
                            <input type="button" 
                            name="agregarIn" 
                            onClick="javascript:funcNuevoTipo();" 
                            value="+" 
                            tabindex="2">
                        </td>
                       
                         </tr>
                         <tr>
                        	<td align="right"><b><cf_translate key="LB_Agrupar_por_Empleado">Agrupar por Empleado</cf_translate></b></td>
                        	<td colspan="2">
                        	<input name="ChkEmp" type="checkbox" checked="checked" ></td>
                         </tr>
                         <tr>
                        	<td align="right"><b><cf_translate key="LB_DetallarNominas">Detallar Nóminas</cf_translate></b></td>
                        	<td colspan="2">
                        	<input name="DetallarNominas" type="checkbox" ></td>
                         </tr>
                         <tr>
							<td colspan="3">
								<table id="DCargas" style="display:none;" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
									<tbody></tbody>
								</table>
							</td>
						</tr>
                    <tr>				
                        <td colspan="4" align="center">
                            <input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar">
                        </td>
                    </tr>		
				</table>	
        <input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
                <input type="hidden" name="DClinealist"          id="DClinealist" 		 value="" tabindex="1">
                <input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
			</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

	<script type="text/javascript" language="javascript1.2">
	<cfoutput>
			var vnContadorListas1 = 0;
			function funcNuevoTipo(){
				var LvarTable = document.getElementById("DCargas");
				var LvarTbody = LvarTable.tBodies[0];
				var LvarTR    = document.createElement("TR");
				var Lclass 	= document.form1.LastOneCalendario;
				var p1 = document.form1.DClinea.value.toString(); //id del tipo
				var p2 = document.form1.DCcodigo.value.toString(); //codigo del tipo
				var p3 = document.form1.DCdescripcion.value.toString(); //descripcion del tipo
				var p6 = "DClinealist";
				vnContadorListas1 = vnContadorListas1 + 1;
				document.form1.DClinea.value = '';
				document.form1.DCcodigo.value = '';
				document.form1.DCdescripcion.value = '';
				
				// Valida no agregar vac�os
				if (p1=="") return;	  
				// Valida no agregar repetidos
				if (existeTipoCarga(p1)) {alert('#MSG_TipoCarga#');return;}
				// Agrega Columna 0 - DClinea
				sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", p6);
				// Agrega Columna 1 - DCcodigo
				sbAgregaTdText  (LvarTR, Lclass.value, p2);
				// Agrega Columna 2 - DCdescripcion
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
			
			//Funci�n para agregar TDs con Objetos
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
			
			//Funci�n para agregar TDs con texto
			function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
				var LvarTD    = document.createElement("TD");
				var LvarTxt   = document.createTextNode(LprmValue);
				LvarTD.appendChild(LvarTxt);
				if (LprmClass!="") LvarTD.className = LprmClass;
				GvarNewTD = LvarTD;
				LvarTD.noWrap = true;
				LprmTR.appendChild(LvarTD);
			}		
			
			//Funci�n para agregar Imagenes
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
			
			function existeTipoCarga(v){
				var LvarTable = document.getElementById("DCargas");
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
				document.getElementById("DCargas").style.display='';
				document.form1.DClinea.value = '';
				document.form1.DCcodigo.value = '';
				document.form1.DCdescripcion.value = '';				
			}
			
			funcVerificar();
			
            	
			
			</cfoutput>
		</script>


<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	
	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Mes#'
    


	function mostrarTR(opcion){
		var TR_FechaDesde = document.getElementById("TR_FechaDesde");
		var TR_FechaHasta = document.getElementById("TR_FechaHasta");
		var TR_Periodo	  = document.getElementById("TR_Periodo");
		var TR_Mes	 	  = document.getElementById("TR_Mes");

		switch(opcion){
			case 1:{
				document.form1.FechaDesde.value = '';
				document.form1.FechaHasta.value = '';
				TR_Periodo.style.display = "";
				TR_Mes.style.display     = "";
				TR_FechaDesde.style.display  = "none";
				TR_FechaHasta.style.display  = "none";

				objForm.FechaHasta.required = false;
				objForm.FechaDesde.required = false;
				objForm.periodo.required    = true;
				objForm.mes.required        = true;
				objForm.periodo.description = '#LB_Periodo#';
				objForm.mes.description     = '#LB_Mes#'
		}
			break;
			case 2:{
				document.form1.periodo.value = ''; 
				document.form1.mes.value 	 = '';
				TR_Periodo.style.display     = "none";
				TR_Mes.style.display         = "none";
				TR_FechaDesde.style.display  = "";
				TR_FechaHasta.style.display  = "";
	
				objForm.periodo.required 	= false;
				objForm.mes.required 		= false;
				objForm.FechaHasta.required = true;
				objForm.FechaDesde.required = true;
				
				objForm.FechaHasta.description = '#LB_FechaRige#';
				objForm.FechaDesde.description = '#LB_FechaVence#';
			}
			break;
		}
	}	
	
<!---	    function funcValidar(){
				if (vnContadorListas1 <= 0){
					alert('#MSG_SelTipoCarga#');
					return false;
				}	
		}	
--->
	</cfoutput>	
</script>