
<cfset Gvar_Action = "NominaContabilidadReporte.cfm">

<!--- Modified with Notepad --->
<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_TipodeNomina"
		Default="Tipo de Nómina"
		returnvariable="JSMSG_TipodeNomina"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_Nomina"
		Default="Nómina"
		returnvariable="JSMSG_Nomina"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_Moneda"
		Default="Moneda"
		returnvariable="JSMSG_Moneda"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_TipoCambio"
		Default="Tipo de Cambio"
		returnvariable="JSMSG_TipoCambio"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_El_campo"
		Default="El campo"
		returnvariable="JSMSG_El_campo"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_es_requerido"
		Default="es requerido"
		returnvariable="JSMSG_es_requerido"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_La_lista_de_Nominas_es_requerida"
		Default="La lista de Nóminas es requerida"
		returnvariable="JSMSG_La_lista_de_Nominas_es_requerida"/> 
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Todos" Default="Todos" returnvariable="LB_Todos"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" Key="LB_Tipo_de_Grupos_de_Oficinas" Default="Tipo de Grupos de Oficinas" returnvariable="LB_Tipo_de_Grupos_de_Oficinas"/>
	
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo
			, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsMonLoc" datasource="#session.dsn#">
		select Mcodigo
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
	<cfquery name="rsTiposNominas" datasource="#session.dsn#">
		select Tcodigo, Tdescripcion 
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select Ocodigo,Oficodigo,Odescripcion
		from Oficinas a
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
		order by Oficodigo
	</cfquery>
	<cfquery name="rsAnexoGOTipo" datasource="#Session.DSN#">
   select GOTid, GOTnombre
     from AnexoGOTipo p
   where p.Ecodigo = #Session.Ecodigo#
</cfquery>
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioPago" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipodeNomina" Default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaAplicada" Default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaNoAplicada" Default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_ElTipoDeCambioDebeSerMayorACero" Default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 

</cfsilent>
<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="#Gvar_action#" style="margin:0;">
	<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<input type="hidden" name="CPidlist2" id="CPidlist2" value="" tabindex="1">
	<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="3">&nbsp;</td></tr>
        
                     <tr>
                	<td>
                    	<cfoutput>#LB_Tipo_de_Grupos_de_Oficinas#</cfoutput>:
                    </td>
                    <td>
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
                            <optgroup label="Oficina">
                                <cfloop query="rsOficinas">
                                   <cfoutput><option value="of,#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option></cfoutput>
                                </cfloop>
                            </optgroup>
                        </select>
                    </td>
                </tr>
<!---		<tr>
			<td align="right" nowrap="nowrap">
			<strong><cf_translate key="LB_Oficina">Oficina</cf_translate>:</strong>&nbsp;
			</td>
			<td colspan="2">
				<select name="Ocodigo" id="Ocodigo">
					<option value="">---Seleccione---</option>
					<cfloop query="rsOficinas">
					<option value="#Ocodigo#">#Oficodigo# - #Odescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>--->
		
		<!---<tr>
			<td align="right" nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" border="0">
				<tr><td>
				<cf_rhcfuncional size="30"></td>
				<td align="left">
					&nbsp;&nbsp;&nbsp;&nbsp;<input name="chkDependencias" type="checkbox" id="chkDependencias" value="1"><strong>Incluir dependencias</strong>
				</td></tr></table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>--->
<!---			<td colspan="2">
				<input name="Agrupar" id="Agrupar" type="checkbox" tabindex="1">
				<label for="Agrupar" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_AgruparPorCentroFuncional">Agrupar por Centro Funcional</cf_translate></strong></label>
			</td>--->
		</tr>
		<tr>
			<td align="right" valign="top"><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
			<td colspan="2"><cf_rhempleado tabindex="1"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
				<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">Nóminas Aplicadas</cf_translate></strong></label>			</td>
			<td>&nbsp;</td>
		</tr>
		
		<!---- filtro por fechas---->
		<tr>
			<td colspan="1%">&nbsp;</td>
			<td colspan="90%" align="left" colspan="2"><input type="checkbox" name="chkUtilizarFiltro" id="chkUtilizarFiltro" onclick="javascript:utilizarFechas(this);" /><b><i><cf_translate key="LB_Utilizar_Rango_de_Fechas" xmlFile="/rh/generales.xml">Utilizar Rango de Fechas</cf_translate></i></b></td>
		</tr>				
		<tr>
			<td>&nbsp;</td>
			<td colspan="2">
				<table id="divFiltroFechas" style="display:none">
					<tr>
						<td align="left"> <strong><cf_translate  key="LB_Fecha_Desde"  xmlFile="/rh/generales.xml">Fecha Desde</cf_translate> :&nbsp;</strong></td>
						<td align="left"> <cf_sifcalendario form="form1" value="#LSDateFormat(Now(), "DD/MM/YYYY")#"  name="Filtro_FechaDesde"> </td>
					</tr>	
					<tr>
						<td  align="left"> <strong><cf_translate  key="LB_Fecha_Hasta"  xmlFile="/rh/generales.xml">Fecha Hasta</cf_translate> :&nbsp;</strong></td>
						<td  align="left"><cf_sifcalendario form="form1" value="#LSDateFormat(Now(), "DD/MM/YYYY")#"  name="Filtro_FechaHasta"></td>
					</tr>
					<tr>
						<td  align="left"> <strong><cf_translate  key="LB_Tipo_Nomina"  xmlFile="/rh/generales.xml">Tipo Nómina</cf_translate> :&nbsp;</strong></td>
						<td  align="left"> <cf_rhtiponomina form="form1" index="10" agregarEnLista="true"></td>
					</tr>
				</table>	
			</td>
		</tr>
		<!--- fin de filtro por fechas--->
				
		<tr id="NAplicadas">
			<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">Nómina</cf_translate> :&nbsp;</strong></td>
			<td>
				<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">			</td>
			<td>
				<input type="button" name="agregarCalendario1" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario(1);" value="+" tabindex="1" class="btnNormal">			</td>
		</tr>
		<tr id="NNoAplicadas" style="display:none">
			<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">Nómina</cf_translate> :&nbsp;</strong></td>
			<td>
				<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true">			</td>
			<td>
				<input type="button" name="agregarCalendario2" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario(2);" value="+" tabindex="1" class="btnNormal">			</td>
		</tr>
		<tr>
			<td colspan = "3">
				<table id="tblcalendario1" style="display:none;" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tbody>
					</tbody>
				</table>
				<table id="tblcalendario2" style="display:none;" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tbody>
					</tbody>
				</table>			</td>
		</tr>
		
		<cfif FindNoCase('SA',Gvar_action) GT 0>
			<tr id="tdMonedas" style="display:none">
				<td nowrap align="right"> <strong><cf_translate  key="LB_Moneda">Moneda</cf_translate> :&nbsp;</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr id="tdTipoCambio" style="display:none">
				<td nowrap align="right"> <strong><cf_translate  key="LB_TipoCambio">Tipo de Cambio</cf_translate> :&nbsp;</strong></td>
			  <td><cf_inputNumber name="TipoCambio" decimales="2" tabindex="1" value="1.00">
				  <select name="Mcodigo" onchange="javascript: setTipoCambio();">
                    <cfloop query="rsMonedas">
                      <option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo eq rsMonLoc.Mcodigo>selected</cfif>>#rsMonedas.Mnombre#</option>
                    </cfloop>
                  </select ></td>
				<td>&nbsp;</td>
			</tr>
		</cfif>
		
		<!---<tr>
			<td align="center" colspan="3">
				<cf_botones values="Generar" tabindex="1">			</td>
		</tr>--->
		<tr>
				<th scope="row"  colspan="3" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th>
			</tr>
	</table>
</form>

<script language="javascript" type="text/javascript">
	var vnContadorListas1 = 0;
	var vnContadorListas2 = 0;
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
	
	function existeCalendario(v,p){
		if (p==1)
			var LvarTable = document.getElementById("tblcalendario1");
		else 
			var LvarTable = document.getElementById("tblcalendario2");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v){
				return true;
			}
		}
		return false;
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
	
	//Función para eliminar TRs
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
	function sbEliminarTR2(e){
	  vnContadorListas2 = vnContadorListas2 - 1;
	  var LvarTR;
	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	function getTdescripcion(Tcodigo){
		<cfloop query="rsTiposNominas">
		if (Tcodigo=="#trim(Tcodigo)#") return "#Tdescripcion#";
		</cfloop>
		return "";
	}
		
	function fnNuevoCalendario(v){
	  //verifica que exista una nómina seleccionada
	  if ((v==1&&document.form1.Tcodigo1.value == '' && document.form1.CPid1.value == '')
	  		||(v==2&&document.form1.Tcodigo2.value == '' && document.form1.CPid2.value == '')){
	  	return;
	  }
	  
	  if (document.getElementById("TipoNomina").checked == true){
			var LvarTable = document.getElementById("tblcalendario1");
			var LvarTbody = LvarTable.tBodies[0];
			var LvarTR    = document.createElement("TR");
			var Lclass 	= document.form1.LastOneCalendario;
	  		var p1 = document.form1.CPid1.value.toString(); //id del calendario
	  		var p2 = getTdescripcion(document.form1.Tcodigo1.value.toString()); //tipo de nomina
			var p3 = document.form1.CPcodigo1.value.toString(); //codigo de nomina
			var p4 = document.form1.CPdescripcion1.value.toString(); //descripcion de nomina
			var p5 = 1;
			var p6 = "CPidlist1";
			vnContadorListas1 = vnContadorListas1 + 1;
			document.form1.Tcodigo1.value = '';
			document.form1.CPid1.value = '';
			document.form1.CPcodigo1.value = '';
			document.form1.CPdescripcion1.value = '';
	  } else {
		  	var LvarTable = document.getElementById("tblcalendario2");
			var LvarTbody = LvarTable.tBodies[0];
			var LvarTR    = document.createElement("TR");
			var Lclass 	= document.form1.LastOneCalendario;
	  		var p1 = document.form1.CPid2.value.toString(); //id del calendario
	  		var p2 = getTdescripcion(document.form1.Tcodigo2.value.toString()); //tipo de nomina
			var p3 = document.form1.CPcodigo2.value.toString(); //codigo de nomina
			var p4 = document.form1.CPdescripcion2.value.toString(); //descripcion de nomina
			var p5 = 2;
			var p6 = "CPidlist2";
			vnContadorListas2 = vnContadorListas2 + 1;
			document.form1.Tcodigo2.value = '';
			document.form1.CPid2.value = '';
			document.form1.CPcodigo2.value = '';
			document.form1.CPdescripcion2.value = '';
	  }

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  // Valida no agregar repetidos
	  if (existeCalendario(p1,p5)) {alert('Este Calendario ya fue agregado.');return;}
  	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", p6);
	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  // Agrega Columna 2
	  sbAgregaTdText (LvarTR, Lclass.value, p3);
	  // Agrega Columna 3
	  sbAgregaTdText  (LvarTR, Lclass.value, p4);
	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (p5==1) {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR1);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR1, false);
	  } else {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR2);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR2, false);
	  }
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	/*función que actualiza el tipo de cambio y lo habilita/desahbilita*/
	<cfif FindNoCase('SA',Gvar_action) GT 0>
		function setTipoCambio(){
			document.form1.TipoCambio.value='1.00';
			document.form1.TipoCambio.disabled=(document.form1.Mcodigo.value==#rsMonLoc.Mcodigo#);
		}
	</cfif>
	/*función que prepara las validaciones y muestra oculta campos relacionados con las nóminas aplicadas/sin aplicar*/
	function Verificar(){
		if(document.getElementById("chkUtilizarFiltro").checked==false){
			if (document.getElementById("TipoNomina").checked == true){
				document.getElementById("NAplicadas").style.display=''
				document.getElementById("NNoAplicadas").style.display='none'; 
				document.getElementById("tblcalendario1").style.display='';
				document.getElementById("tblcalendario2").style.display='none';
				document.form1.Tcodigo1.value = '';
				document.form1.CPid1.value = '';
				document.form1.CPcodigo1.value = '';
				document.form1.CPdescripcion1.value = '';
				<cfif FindNoCase('SA',Gvar_action) GT 0>	
					document.getElementById("tdMonedas").style.display='none'; 
					document.getElementById("tdTipoCambio").style.display='none'; 
				</cfif>
				}
			else{
				document.getElementById("NAplicadas").style.display='none'
				document.getElementById("NNoAplicadas").style.display=''; 
				document.getElementById("tblcalendario1").style.display='none';
				document.getElementById("tblcalendario2").style.display='';
				document.form1.Tcodigo2.value = '';
				document.form1.CPid2.value = '';
				document.form1.CPcodigo2.value = '';
				document.form1.CPdescripcion2.value = '';
				<cfif FindNoCase('SA',Gvar_action) GT 0>
					document.getElementById("tdMonedas").style.display=''; 
					document.getElementById("tdTipoCambio").style.display=''; 
					document.form1.Mcodigo.value="#rsMonLoc.Mcodigo#";
					setTipoCambio();
				</cfif>
			}
		}
	}
	Verificar();
	/*validar el formulario 1*/
	function _validateForm1(){
		if (!objForm._allowSubmitOnError) {
			if (document.getElementById("TipoNomina").checked == true){
				if (vnContadorListas1<=0) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
			} else {
				if (vnContadorListas2<=0) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
				<cfif FindNoCase('SA',Gvar_action) GT 0>
					if (objForm.Mcodigo.getValue()=='') objForm.Mcodigo.throwError("#JSMSG_El_campo# #JSMSG_Moneda# #JSMSG_es_requerido#");
					if (objForm.TipoCambio.getValue()=='') objForm.TipoCambio.throwError("#JSMSG_El_campo# #JSMSG_TipoCambio# #JSMSG_es_requerido#");
				</cfif>
			}		
		}
	}
	/*funcion antes de hacer submit*/
	function _submitForm1(){
		<cfif FindNoCase('SA',Gvar_action) GT 0>
		document.form1.TipoCambio.disabled=false;
		</cfif>
	}
	
	function utilizarFechas(e){
		if(e.checked){
			document.getElementById("NNoAplicadas").style.display='none';
			document.getElementById("NAplicadas").style.display='none'; 
			document.getElementById("divFiltroFechas").style.display=''; 
		}
		else{
			document.getElementById("divFiltroFechas").style.display='none'; 
			Verificar();
		}
	}	
</script>
</cfoutput>

<cf_qforms onValidate="funcValida">
</cf_qforms>