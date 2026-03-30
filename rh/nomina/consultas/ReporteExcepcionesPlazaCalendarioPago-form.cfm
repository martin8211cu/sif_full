<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Proceso" Default="Proceso" returnvariable="LB_Proceso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Calculo" Default="Cálculo" returnvariable="LB_Calculo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Terminado" Default="Terminado" returnvariable="LB_Terminado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Pagado" Default="Pagado" returnvariable="LB_Pagado" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton limpiar ---->
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" XmlFile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Consultar ---->
<cfinvoke Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset Form.RCNid = Url.RCNid>
</cfif>

<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
	select a.RCNid, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   a.RCDescripcion, 
		   a.RCdesde, 
		   a.RChasta,
		   (case a.RCestado 
				when 0 then '#LB_Proceso#'
				when 1 then '#LB_Calculo#'
				when 2 then '#LB_Terminado#'
				when 3 then '#LB_Pagado#'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo,
		   c.CPcodigo
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
</cfquery>

<cfif rsRelacionCalculo.RecordCount gt 0>
	<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
	<cfset Form.RCdesde = LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')>
	<cfset Form.RChasta = LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')>
	<cfset Form.RCestado = rsRelacionCalculo.RCestado>
	<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
</cfif>

<!--- Consulta Relación de Cálculo --->
<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
	select 	a.RCNid, 
		   	rtrim(a.Tcodigo) as Tcodigo, 
		   	a.RCDescripcion, 
		   	a.RCdesde, 
		  	a.RChasta,
		   (case a.RCestado 
				when 0 then 'Proceso'
				when 1 then 'Cálculo'
				when 2 then 'Terminado'
				when 3 then 'Pagado'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo,
		   c.CPcodigo,
			case when c.CPtipo = 0 then 'Normal'
			when c.CPtipo = 2 then 'Anticipo' end as TipoCalendario,
			c.CPnodeducciones
	from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.Ecodigo = b.Ecodigo
	and a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
</cfquery>

<!--- Pasa algunos valores de la consulta al Form para poder utilizarlos posteriormente --->
<cfif rsRelacionCalculo.RecordCount gt 0>
	<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
	<cfset Form.RCdesde = LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')>
	<cfset Form.RChasta = LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')>
	<cfset Form.RCestado = rsRelacionCalculo.RCestado>
	<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
</cfif>

<!--- Pinta Info de Relación de Cálculo --->
<cfoutput>
	
  <table width="70%" border="0" cellspacing="0" cellpadding="2" align="center">
      <tr valign="bottom">
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n: </cf_translate></td>
        <td colspan ="3" nowrap>#rsRelacionCalculo.RCDescripcion#</td> 
        <td width="14%" align="right" nowrap class="fileLabel">&nbsp;</td>
      </tr>
    <tr> 
      <td width="21%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina:</cf_translate> 
      </td>
      <td width="22%" nowrap> #rsRelacionCalculo.Tdescripcion# </td>
      <td width="9%" align="right" nowrap class="fileLabel">&nbsp;</td>
      <td width="9%" nowrap>&nbsp;</td>
      <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_desde">Fecha Desde: </cf_translate></td>
      <td nowrap> <cf_locale name="date" value="#rsRelacionCalculo.RCdesde#"/> </td>
    </tr>
    <tr> 
      <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Codigo_del_Calendario_de_Pago">C&oacute;digo del Calendario de Pago:</cf_translate></td>
	  <cfset pagina = GetFileFromPath(GetTemplatePath()) >
      <td nowrap><cfif trim(pagina) eq 'ResultadoCalculo-lista.cfm' ><table><tr><td><a href="javascript:funcDeducciones();">#rsRelacionCalculo.CPcodigo#</a></td><td><a href="javascript:funcDeducciones();"><img border="0" src="/cfmx/rh/imagenes/Documentos2.gif"></a></td></tr></table><cfelse>#rsRelacionCalculo.CPcodigo#</cfif></td>
      <td align="right" nowrap class="fileLabel">&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta: </cf_translate></td>
      <td nowrap> <cf_locale name="date" value="#rsRelacionCalculo.RChasta#"/> </td>
    </tr>
	<tr> 
		<td align="right" nowrap class="fileLabel"><cf_translate key="LB_TipodeCalendarioDePago">Tipo de Calendario de Pago:</cf_translate></td>
		<td nowrap colspan="3">#rsRelacionCalculo.TipoCalendario#</td>
		<td align="right" nowrap class="fileLabel"></td>
		<td nowrap></td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
  </table>
</cfoutput>
<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="get" action="/cfmx/rh/nomina/consultas/PConsultaRCalculo.cfm?RCNid=#Form.RCNid#">
<table width="80%" border="0" align="center" cellpadding="1" cellspacing="2">
	<tr>
		<td colspan="3" align="center" valign="middle" nowrap>			
			<input type="radio" id="radRep1" name="radRep" value="2" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep1"><font size="2"><cf_translate key="LB_Deducciones">Deducciones</cf_translate></font></label>
			
			<input type="radio" id="radRep2" value="3" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep2"><font size="2"><cf_translate key="LB_Cargas_Patronales">Cargas Patronales</cf_translate></font></label>
		</td>
	</tr>
	
	<tr>
		<td colspan="3" align="center" valign="middle" nowrap>	
			<table><tr>
			<td align="right" nowrap class="fileLabel"><input name="mostrarEmpleados" type="checkbox" value="1" id="mostrarEmpleados"/></td>
			<td nowrap><cf_translate key="LB_Mostrar_Empleados">Mostrar Empleados (solo para cr&eacute;ditos)</cf_translate></td>
			</tr></table>
		</td>
	</tr>
	<tr height="20px">
		<td>
			<div style="display:none", id="tabCargas">
			<table id="tblCar" align="center"   border="0" cellspacing="0" cellpadding="0">
				
				<tr height="20px">
					<td align="left" nowrap>
						<div style="display:none ;" id="verTitCargas"><strong><cf_translate key="LB_Cargas">Cargas</cf_translate>:</strong>&nbsp;</div>
						<div style="display:none ;" id="verBlanco"><strong>&nbsp;</strong></div>
					</td>
					<td  nowrap="nowrap">
						<div style="display:none ;" id="verCargas">
						    <input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
							<cf_conlis 
									campos="ECid,DCdescripcion,DClinea,ECauto,DCmetodo"
									asignar="ECid,DCdescripcion,DClinea,ECauto,DCmetodo"
									size="0,50,0,0,0"
									desplegables="N,S,N,N,N"
									modificables="N,N,N,N,N"						
									title="Lista de Cargas Obrero Patronales"
									tabla="DCargas a,ECargas b"
									columnas="a.ECid,ECdescripcion,DClinea,DCdescripcion,ECauto,DCmetodo,a.DCvaloremp,a.DCvalorpat"
									filtro="a.ECid=b.ECid
											and b.Ecodigo= #Session.Ecodigo# 
											order by a.ECid, DCdescripcion"
									filtrar_por="DCdescripcion"
									desplegar="DCdescripcion"
									etiquetas="Descripci&oacute;n"
									formatos="S"
									align="left"								
									asignarFormatos="S,S,S,S"
									form="form1"
									showEmptyListMsg="true"
									Cortes="ECdescripcion"
									MaxRows="15"
								/>
<!--- 							<input name="DCdescripcion" disabled type="text" value="" size="40" maxlength="40"  tabindex="1">
							<img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();"> --->
						</div>
					</td>
					<td>
						<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar();" value="+" tabindex="2">
					</td>
				</tr>
			</table>
			</div>
			<div style="display:none", id="tabDed">
				<table id="tblDed" width="50%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right" nowrap valign="top">
						<div style="display:none ;" id="verTitDeduc"><strong><cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate>:</strong>&nbsp;</div>
						<div style="display:none ;" id="verBlanco"><strong>&nbsp;</strong></div>
					</td>
					<div style="display:none ;" id="verDeduc">
					<td nowrap="nowrap">						
						<cf_rhtipodeduccion form="form1" size= "40" tabindex="1">
						<input type="hidden" name="LastOneDed" id="LastOneDed" value="ListaNon">																		
					</td>
					<td align="left" valign="top">
						<input type="button" name="agregarDed" onClick="javascript:if (window.fnNuevoDed) fnNuevoDed();" value="+" tabindex="2">
					</td>
					</div>
				</tr>
			</table>
			</div>
		</td>
	</tr>

	<tr>
		<td colspan="3" align="center" valign="middle"><div align="center"> 
			<input type="submit" name="Submit" value="#BTN_Consultar#" tabindex="1">&nbsp;
			<input type="button" name="Limpiar" value="#BTN_Limpiar#"  tabindex="1" onClick="javascript: limpiar();">
			<input type="hidden" name="RCNid" value="<cfif isdefined("form.RCNid") and len(trim(#form.RCNid#)) neq 0><cfoutput>#form.RCNid#</cfoutput></cfif>">
			<input type="hidden" name="Tcodigo" value="<cfif isdefined("form.Tcodigo") and len(trim(#form.Tcodigo#)) neq 0><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
			<input type="hidden" name="fecha" value="<cfif isdefined("form.fecha") and len(trim(#form.fecha#)) neq 0><cfoutput>#form.fecha#</cfoutput></cfif>">
			<!--- <input type="hidden" name="ECid" value="<cfif isdefined("form.ECid") and len(trim(#form.ECid#)) neq 0><cfoutput>#form.ECid#</cfoutput></cfif>" > --->
		</div></td>
	</tr>	
</table>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/qForms/qforms.js">//</script>
<script language="javascript">


	function cambioTipoRep(obj){
		var connverTitDeduc	= document.getElementById("verTitDeduc");
		var connverTitCargas= document.getElementById("verTitCargas");	
		var connverDeduc	= document.getElementById("verDeduc");
		var connverCargas	= document.getElementById("verCargas");	
		var connverBlanco	= document.getElementById("verBlanco");
		var connverTabCarga = document.getElementById("tabCargas");
		var connverTabDed   = document.getElementById("tabDed");
		
		switch(obj.value){
			case '2':{				
				connverTitDeduc.style.display = "";
				connverDeduc.style.display = "";
				connverTitCargas.style.display = "none";
				connverCargas.style.display = "none";
				connverBlanco.style.display = "none";
				connverTabCarga.style.display="none";
				connverTabDed.style.display ="";
				document.form1.action = "/cfmx/rh/nomina/consultas/RepDedCargas-SQL.cfm?RCNid=<cfoutput>#form.RCNid#</cfoutput>";
			}
			break;
			case '3':{
				connverTitDeduc.style.display = "none";
				connverDeduc.style.display = "none";
				connverTitCargas.style.display = "";
				connverCargas.style.display = "";
				connverBlanco.style.display = "none";
				connverTabCarga.style.display="";
				connverTabDed.style.display ="none";
				document.form1.action = "/cfmx/rh/nomina/consultas/RepDedCargas-SQL.cfm?RCNid=<cfoutput>#form.RCNid#</cfoutput>";
			}
			break;			
			
		}
		
	}	

	function doConlis() {
		popUpWindow("/cfmx/rh/nomina/consultas/ConlisCargasEmpleados.cfm" ,250,200,650,350);
	}
	
	function validar(){	return true; }
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	//**********************************Tabla Dinámica de las cargas obrero patronal**********************************************
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/rh/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	

	var vnContadorListas = 0;
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoCar()
	{
	  if (document.form1.DClinea.value != '' && document.form1.DCdescripcion.value != ''){ 
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblCar");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= document.form1.DClinea.value.toString();//id
	  var p2 		= document.form1.DCdescripcion.value;//cod

	  
	  document.form1.DClinea.value = "";
	  document.form1.DCdescripcion.value = "";

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCar(p1)) {alert('El código seleccionado es repetido.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CaridList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  
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
	  
	//Función para agregar TRs
	function fnNuevoDed()
	{
	  if (document.form1.TDid.value != '' && document.form1.TDcodigo.value != ''){ 
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblDed");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneDed;
	  var p1 		= document.form1.TDid.value.toString();//id
	  var p2 		= document.form1.TDcodigo.value;//cod
	  var p3 		= document.form1.TDdescripcion.value;//desc
	  
	  document.form1.TDid.value = "";
	  document.form1.TDcodigo.value = "";
	  document.form1.TDdescripcion.value = "";


	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoDed(p1)) {alert('Esta deducción ya fue seleccionada.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 , "hidden", "DedidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2 + ' - ' + p3);
	  	
	
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
	  
	function existeCodigoCar(v){
		var LvarTable = document.getElementById("tblCar");
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
	
		function existeCodigoDed(v){
		var LvarTable = document.getElementById("tblDed");
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
	
	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
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
	
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
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
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
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
	function sbEliminarTR(e)
	{
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
</script>