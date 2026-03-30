<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluadores"
	Default="Evaluadores"
	returnvariable="LB_Evaluadores"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluador"
	Default="Evaluador"
	returnvariable="LB_Evaluador"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual"
	Default="Esta seguro que desea continuar y perder la configuración actual?"
	returnvariable="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnEmpleado"
	Default="Debe seleccionar al menos un Empleado"
	returnvariable="MSG_DebeSeleccionarAlMenosUnEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteEmpleadoYaFueAgregado"
	Default="Este Empleado ya fue agregado"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">

<cfif isdefined('form.RHRCid') and form.RHRCid NEQ ''>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHRCestado
		from RHRelacionCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>
</cfif>
<cfoutput>
<form action="actCompe_evaluadores_sql.cfm" method="post" name="form1">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="75%"  border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td colspan="2"><strong>#LB_Evaluador#:</strong>&nbsp;</td></tr>
					<tr>
						<td width="70%"><cf_rhempleado size="40" tabindex="1"></td>
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
	  	<tr>
			<td>
				<input type="hidden" name="SEL" value="" >
				<input type="hidden" name="RHRCid" value="#form.RHRCid#">
				<cf_botones values="Anterior,Generar,Siguiente" names="Anterior,Actualizar,Siguiente" nbspbefore="4" nbspafter="4" tabindex="1">
			</td>
	  	</tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	var vnContadorListas = 0;

	function funcSiguiente(){
		if (vnContadorListas <= 0){
			document.form1.SEL.value = "3";
			document.form1.action = "actCompetencias.cfm";
			return true;
		}
		else{
			if (confirm("<cfoutput>#MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual#</cfoutput>")){				
				document.form1.SEL.value = "3";
				document.form1.action = "actCompetencias.cfm";
				return true;
			}
			else {return false;}
		}
	}
	
	function funcAnterior(){
		document.form1.SEL.value = "1";
		document.form1.action = "actCompetencias.cfm";
		return true;
	}	
	//funcion de boton generar, verifica q al menos haya un empleado en la lista
	function funcActualizar(){
		var LvarTable = document.getElementById("tblempleado");
		if(LvarTable.rows.length <= 1){
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnEmpleado#</cfoutput>');
			return false;
		}
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
		
	function fnNuevoEmpleado(){
	  if (document.form1.DEid.value != '' && document.form1.DEidentificacion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblempleado");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneEmpleado;
	  var p1 		= document.form1.DEid.value.toString();//cod
	  var p2 		= document.form1.NombreEmp.value;//desc
	  var p3		= document.form1.DEidentificacion.value;

	  document.form1.DEid.value="";
	  document.form1.DEidentificacion.value="";
	  document.form1.NombreEmp.value="";

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

</script>