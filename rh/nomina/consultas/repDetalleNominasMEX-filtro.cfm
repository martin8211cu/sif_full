<!---
<!--- ReporteLibroSalariosFiltro.cfm --->
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioPago" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipodeNomina" Default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NominaAplicada" Default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NominaNoAplicada" Default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElTipoDeCambioDebeSerMayorACero" Default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/>
<cfoutput>
		<form action="repDetalleNominaMEX-form.cfm" method="get" name="form1" style="margin:0">
			<table width="85%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>
					<td width="43%">&nbsp;</td>
					<td colspan="2">
						<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
						<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
					</td>
				</tr>
                <!---nominas historicas--->
				<tr id="NAplicadasdesde">
					<td colspan="1"nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina Inicio</cf_translate> :&nbsp;</strong></td>
					<td colspan="2">
						<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" Excluir="2">
					</td>
				</tr>
       			<tr id="NAplicadashasta" >
					<td  colspan="1" nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina Final</cf_translate> :&nbsp;</strong></td>
					<td colspan="2" align="right">
						<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="false" index="2" tabindex="1"  Excluir="2">
					</td>
				</tr>


                <!---Nominas en proceso--->
				<tr id="NNoAplicadas" style="display:none">
					<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
					<td colspan="2">
						<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="3" tabindex="1"  Excluir="2">
					</td>
				</tr>

				<tr>
					<td align="right" nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
					<td width="0%"><cf_rhcfuncional size="30"></td>
					<td width="57%" align="left">
						&nbsp;&nbsp;&nbsp;&nbsp;<input name="chkDependencias" type="checkbox" id="chkDependencias" value="1"><strong>Incluir dependencias</strong>
					</td>
				</tr>
				<tr>
					<td width="43%">&nbsp;</td>
					<td colspan="2">
						<input name="Agrupar" id="Agrupar" type="checkbox" tabindex="1">
						<label for="Agrupar" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_AgruparPorCentroFuncional">Agrupar por Centro Funcional</cf_translate></strong></label>
					</td>
				</tr>
				<tr>
					<td align="right" valign="top"><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
					<td colspan="2"><cf_rhempleado tabindex="1">&nbsp;</td>
				</tr>
				<tr>
					<th scope="row"  colspan="3" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th>
				</tr>
			</table>
	  </form>
</cfoutput>


<script>
	/*función que prepara las validaciones y muestra oculta campos relacionados con las nóminas aplicadas/sin aplicar*/
	function Verificar(){
		if (document.getElementById("TipoNomina").checked == true){
			document.getElementById("NAplicadasdesde").style.display=''
			document.getElementById("NAplicadashasta").style.display=''

			document.getElementById("NNoAplicadas").style.display='none';
			document.form1.Tcodigo1.value = '';
			document.form1.CPid1.value = '';
			document.form1.CPcodigo1.value = '';
			document.form1.CPdescripcion1.value = '';
			document.form1.Tcodigo2.value = '';
			document.form1.CPid2.value = '';
			document.form1.CPcodigo2.value = '';
			document.form1.CPdescripcion2.value = '';

			}
		else{
			document.getElementById("NAplicadasdesde").style.display='none'
			document.getElementById("NAplicadashasta").style.display='none'

			document.getElementById("NNoAplicadas").style.display='';
			document.form1.Tcodigo3.value = '';
			document.form1.CPid3.value = '';
			document.form1.CPcodigo3.value = '';
			document.form1.CPdescripcion3.value = '';
		}
	}
	Verificar();
	function funcValida(){
		if (!objForm._allowSubmitOnError) {
			<cfoutput>
			objForm.Tcodigo1.description  = "#MSG_TipodeNomina#";
			objForm.CPcodigo1.description = "#MSG_NominaAplicada#";
			objForm.Tcodigo2.description  = "#MSG_TipodeNomina#";
			objForm.CPcodigo2.description = "#MSG_NominaNoAplicada#";
			</cfoutput>
			if (objForm.TipoNomina.getValue()=="on" && objForm.Tcodigo1.getValue() == "")
				objForm.Tcodigo1.throwError('El campo ' + objForm.Tcodigo1.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="on" && objForm.CPcodigo1.getValue() == "")
				objForm.CPcodigo1.throwError('El campo ' + objForm.CPcodigo1.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="" && objForm.Tcodigo3.getValue() == "")
				objForm.Tcodigo3.throwError('El campo ' + objForm.Tcodigo3.description + ' es requerido.');
			if (objForm.TipoNomina.getValue()=="" && objForm.CPcodigo3.getValue() == "")
				objForm.CPcodigo3.throwError('El campo ' + objForm.CPcodigo3.description + ' es requerido.');
		}
	}


</script>

<cf_qforms onValidate="funcValida">
</cf_qforms>

--->

<!--- Modified with Notepad --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" Default="Las fechas son requeridas" returnvariable="MSG_Fecha"/>


<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
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

	<cfquery name="rsTiposNominas" datasource="#session.dsn#">
		select Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
</cfsilent>
<cfoutput>

<cfquery name="rsRegistro" datasource="#session.dsn#">
	select o.Ocodigo, o.Oficodigo, o.Onumpatronal from oficinas o where o.Ecodigo = #session.Ecodigo# and o.Onumpatronal is not null
</cfquery>


<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="#Gvar_action#" style="margin:0;">
	<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<input type="hidden" name="CPidlist2" id="CPidlist2" value="" tabindex="1">

    <input type="hidden" name="vFiltro" id="vFiltro" value="1" tabindex="1">

	<table  width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
    	<tr>
            <td colspan="3">
                <table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
                    <tr>
                        <td colspan="2" align="right"><cf_translate  key="LB_TipoFiltro">Tipo de filtro</cf_translate>:&nbsp;</td>
                        <td ><input type="radio" checked onclick="javascript:mostrarTR(1);"  name="Tfiltro" value="1"  id="Tfiltro1"/>
                            <cf_translate  key="RAD_Nominas">Nominas</cf_translate></td>
                        <td >
                            <input onclick="javascript:mostrarTR(2);" type="radio" name="Tfiltro" value="2" id="Tfiltro2" />
                            <cf_translate  key="RAD_RangodeFechas">Rango de Fechas</cf_translate></td>
                     </tr>
                </table>
           </td>
    	</tr>

        <tr id="TR_Tnomina" style="display:none">
            <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Nomina">Tipo de nomina:</cf_translate></td>
            <td nowrap>
                <cf_rhtiponominaCombo index="0"  combo="True" todas="False">
            </td>
        </tr>

        <tr><td colspan="3">
        	<tr id="TR_FechaDesde" style="display:none">
                <td nowrap align="right"> #LB_FechaRige#:</td>
                <td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
                <cfset paso = 2>
            </tr>
            <tr id="TR_FechaHasta" style="display:none">
                <td nowrap align="right"> #LB_FechaVence#: </td>
                <td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
            </tr>

            <tr id="tb_Nominas">
            	<td colspan="3">
                    <table  width="80%" cellpadding="2" cellspacing="0" border="0" align="center" >
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
                                <label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
                            </td>
                            <td>&nbsp;</td>
                        </tr>

                        <tr id="NNoAplicadas" >
                            <td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
                            <td>
                                <cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true" Excluir = "1,2">
                            </td>
                            <td>
                                <input type="button" name="agregarCalendario2" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario(2);" value="+" tabindex="1">
                            </td>
                        </tr>
                        <tr id="NAplicadas" style="display:none">
                            <td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
                            <td>
                                <cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true" Excluir = "1,2">
                            </td>
                            <td>
                                <input type="button" name="agregarCalendario1" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario(1);" value="+" tabindex="1">
                            </td>
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
                                </table>
                            </td>
                        </tr>
                    </table>
               	</td>
            </tr>

            <tr>
                <td align="left" valign="top"><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
                <td colspan="2"><cf_rhempleado tabindex="1">&nbsp;</td>
            </tr>
			<tr>
				<td nowrap align="left">
					<strong>Oficina:&nbsp;</strong>
				</td>
				<td>
					<cfoutput>
						<select name="RegPat" onchange="Archivo();">
							<option value="0" >-- Seleccione una opci&oacute;n --</option>
							<cfloop query="rsRegistro">
							 	<option value="#Onumpatronal#" ><cf_translate key="CMB_RegistrPatronalOficina">#Onumpatronal#</cf_translate></option>
							</cfloop>
						</select>
					</cfoutput>
				</td>
			</tr>
            <tr>
                <td align="center" colspan="3">
                    <cf_botones values="Generar" tabindex="1">
                </td>
            </tr>
        </td></tr>
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
	/*función que prepara las validaciones y muestra oculta campos relacionados con las nóminas aplicadas/sin aplicar*/
	function Verificar(){

		if (document.getElementById("TipoNomina").checked == true){
			document.getElementById("NAplicadas").style.display=''
			document.getElementById("NNoAplicadas").style.display='none';
			document.getElementById("tblcalendario1").style.display='';
			document.getElementById("tblcalendario2").style.display='none';
			document.form1.Tcodigo1.value = '';
			document.form1.CPid1.value = '';
			document.form1.CPcodigo1.value = '';
			document.form1.CPdescripcion1.value = '';
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
		}
	}
	Verificar();
	/*validar el formulario 1*/
	function _validateForm1(){
		if (!objForm._allowSubmitOnError) {
			if (document.getElementById("vFiltro").value == 1){
			<!---if (document.getElementById("TipoNomina").checked == true){--->
				if (vnContadorListas1+vnContadorListas2<=0) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
			}
		}
	}

	function mostrarTR(opcion){
		var TR_FechaDesde = document.getElementById("TR_FechaDesde");
		var TR_FechaHasta = document.getElementById("TR_FechaHasta");
		var TB_Nominas	  =  document.getElementById("tb_Nominas");
		var TR_Tnomina	  =  document.getElementById("TR_Tnomina");
		var vFiltro	  =  document.getElementById("vFiltro");



		switch(opcion){
			case 1:{
				document.form1.FechaDesde.value = '';
				document.form1.FechaHasta.value = '';
				document.getElementById("vFiltro").value= 1


				TB_Nominas.style.display = "";
				TR_FechaDesde.style.display  = "none";
				TR_FechaHasta.style.display  = "none";
				TR_Tnomina.style.display  = "none";

				objForm.FechaHasta.required = false;
				objForm.FechaDesde.required = false;
		}
			break;
			case 2:{

				document.getElementById("vFiltro").value= ""
				TB_Nominas.style.display = "none";
				TR_FechaDesde.style.display  = "";
				TR_FechaHasta.style.display  = "";
				TR_Tnomina.style.display  = "";

				objForm.FechaHasta.required = true;
				objForm.FechaHasta.description = '#LB_FechaRige#';
				objForm.FechaDesde.required = true;
				objForm.FechaDesde.description = '#LB_FechaVence#';
			}
			break;
		}
	}



</script>
</cfoutput>
<cf_qforms onValidate="_validateForm1" >