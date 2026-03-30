<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluadores"
	Default="Lista de Evaluadores"
	returnvariable="LB_ListaDeEvaluadores"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefe"
	Default="Jefe"
	returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DebeSeleccionarUnEvaluador"
	Default="Debe seleccionar un Evaluador"
	returnvariable="LB_DebeSeleccionarUnEvaluador"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteEmpleadoYaFueAgregado"
	Default="Este Empleado ya fue agregado"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("form.DEid") and len(trim(form.DEid)) gt 0>
	<cfquery name="rsEmpl" datasource="#Session.DSN#">
		select DEidentificacion, {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl
		from DatosEmpleado 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<cfif isdefined('form.RHRCid') and form.RHRCid NEQ ''>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHRCestado
		from RHRelacionCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>
</cfif>


<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">

<form action="actCompe_evaluadoresCF_sql.cfm" method="post" name="form1">
	<cfoutput>
		<input type="hidden" name="SEL" value="">
		<input type="hidden" name="RHRCid" value="#form.RHRCid#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center">
					<table width="80%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><strong>#LB_Jefe#:</strong></td>
							<td>
								<cfset valuesArray = ArrayNew(1)>
								<cfif isdefined("form.DEid") and len(trim(form.DEid))>
									<cfquery name="rsJDEid" datasource="#session.DSN#">
										select DEid, DEidentificacion,
											{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl
										from DatosEmpleado 
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										  and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
									</cfquery>
									<cfset ArrayAppend(valuesArray, rsJDEid.DEid)>
									<cfset ArrayAppend(valuesArray, rsJDEid.DEidentificacion)>
									<cfset ArrayAppend(valuesArray, rsJDEid.nombreEmpl)>
									
								</cfif>
								<cf_conlis
									valuesArray		="#valuesArray#" 
									campos			="DEid,DEidentificacion,nombreEmpl"
									size			="0,10,60"
									desplegables	="N,S,S"
									modificables	="N,S,N"
									title			="#LB_ListaDeEvaluadores#"
									tabla			="RHEvaluadoresCalificacion a
														inner join DatosEmpleado b
															on b.DEid = a.DEid
															and b.Ecodigo = a.Ecodigo"
									columnas		="a.DEid,DEidentificacion,{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl"
									filtro			="a.Ecodigo = #session.Ecodigo#
														and a.RHRCid = #form.RHRCid#"
									filtrar_por		="DEidentificacion|{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )}"
									filtrar_por_delimiters="|"
									desplegar		="DEidentificacion,nombreEmpl"
									etiquetas		="#LB_Identificacion#,#LB_Nombre#"
									formatos		="S,S"
									align			="left,left"
									asignar			="DEid,DEidentificacion,nombreEmpl"
									asignarFormatos	="I,S,S"
									showEmptyListMsg="true"
									tabindex		="1"
									alt				="id,#LB_Identificacion#,#LB_Nombre#"/>	
							</td>						
						</tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		 	<tr>
				<td colspan="2" align="center">
					<div id="div_CF" style="display:;">
						<table width="80%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<table id="tblcf" width="100%"    border="0" cellspacing="0" cellpadding="0">
									  	<tr>
											<td></td>
											<td><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
											<td></td>
											<td></td>
									  	</tr>
									 	<tr>
											<td></td>
											<td><cf_rhcfuncional size="40" tabindex="1"></td>
											<td nowrap>
												  <input type="checkbox" name="CFdependencias" tabindex="1"><strong><cf_translate key="LB_Incluir_dependencias" xmlFile="/rh/generales.xml">Incluir Dependencias</cf_translate></strong>
											</td>
											<td align="right">
												<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
												<input type="button" name="agregarCF" onClick="javascript:if (window.fnNuevoCF) fnNuevoCF();" value="+" tabindex="1">
											</td>
									  	</tr>
									  	<tbody></tbody>
									</table>
								</td>
						  	</tr>
						  	<tr><td>&nbsp;</td></tr>
						  	<tr>
								<td>
									<table width="75%"  border="0" cellspacing="0" cellpadding="0" align="center">
										<tr><td colspan="2"><strong>#LB_Empleado#:</strong>&nbsp;</td></tr>
										<tr>
											<td width="70%"><cf_rhempleado size="40" tabindex="1" index="1"></td>
											<td width="10%" align="left">
												<input type="hidden" name="LastOneEmpleado" id="LastOneEmpleado" value="ListaNon" tabindex="-1">
												<input type="button" name="agregarEmpleado" onClick="javascript:if (window.fnNuevoEmpleado) fnNuevoEmpleado();" value="+" tabindex="1">
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<table id="tblempleado" width="75%" border="0" cellspacing="0" cellpadding="0" align="center">
													<tr>
														<td width="5%">&nbsp;</td>
														<td width="25%">&nbsp;</td>
														<td width="75%">&nbsp;</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr><td colspan="2">&nbsp;</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</table>
								</td>
							</tr>
						  	<tr><td>&nbsp;</td></tr>
							<!--- Solo se pueden eliminar evaluadores si la relacion esta en Proceso --->		
							  <tr>
								<td align="center">
									<cf_botones values="Anterior,Generar,Siguiente" names="Anterior,Generar,Siguiente" nbspbefore="4" nbspafter="4" tabindex="1">
								</td>
							  </tr>				  				  
						</table>
					</div>
				</td>
		  	</tr>
		  	<tr><td>&nbsp;</td></tr>				  
		</table>
	</cfoutput>	
</form>									


<script language="javascript" type="text/javascript">
	var vnContadorListas = 0;

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
	
	function existeCodigoCF(v){
		var LvarTable = document.getElementById("tblcf");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

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
	function sbEliminarTR(e){
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}	
		
		
	//Función para agregar Centros Funcionales
	function fnNuevoCF(){
	  if (document.form1.CFcodigo.value != '' && document.form1.CFid.value != ''){ 
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblcf");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= document.form1.CFid.value.toString();//id
	  var p2 		= document.form1.CFcodigo.value;//cod
	  var p3 		= document.form1.CFdescripcion.value;//desc
	  var p4 		= document.form1.CFdependencias.checked;//agregar dependencias
	  
	  document.form1.CFid.value = "";
	  document.form1.CFcodigo.value = "";
	  document.form1.CFdescripcion.value = "";
	  document.form1.CFdependencias.checked = false;

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCF(p1)) {alert('Este Centro Funcional ya fue agregado.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + ((p4) ? "1" : "0"), "hidden", "CFidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2 + ' - ' + p3);
	  	
	  // Agrega Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, ((p4) ? "imgCheck" : "imgUnCheck"), "right");
	
	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	function fnNuevoEmpleado(){
	  if (document.form1.DEid.value != '' && document.form1.DEidentificacion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblempleado");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneEmpleado;
	  var p1 		= document.form1.DEid1.value.toString();//cod
	  var p2 		= document.form1.NombreEmp1.value;//desc
	  var p3		= document.form1.DEidentificacion1.value;

	  document.form1.DEid1.value="";
	  document.form1.DEidentificacion1.value="";
	  document.form1.NombreEmp1.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeEmpleado(p1)) {alert('<cfoutput>#MSG_EsteEmpleadoYaFueAgregado#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "EmpleadoidList");

		// Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p3);
	  
	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}

	function existeEmpleado(v){
		var LvarTable = document.getElementById("tblempleado");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}
	
	function funcConlis(){
		var f = document.form1;
		if (f.DEidentificacion.value == ''){
			f.DEid.value = '';
			f.nombreEmpl.value = '';
		}
		document.form1.submit();
	}
	function funcGenerar(){
		var f = document.form1;
		if (f.DEid.value == ''){
			alert('<cfoutput>#LB_DebeSeleccionarUnEvaluador#</cfoutput>');
			return false;
		}
		return true;
	}
		
	function funcAnterior(){
		document.form1.SEL.value = "3";
		document.form1.action = "actCompetencias.cfm";
		return true;
	}
	function funcSiguiente(){
		document.form1.SEL.value = "5";
		document.form1.action = "actCompetencias.cfm";
		return true;
	}
</script>