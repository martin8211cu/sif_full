<!---<cf_dump var="#form#">--->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteEmpleadoYaFueAgregado"
	Default="Este Empleado Ya Fue Agregado"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>

<cfparam name="session.listaEmpleados" default="">
<cffunction name="delEmpleado" access="public" returntype="string">
	<cfargument name="DEid" required="yes">
	<cfset session.listaEmpleados = listAppend(session.listaEmpleados,Arguments.DEid,',')>
	<cfreturn session.listaEmpleados>
</cffunction>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_EmpresasOr"
	default="Lista Empresas Origen"
	returnvariable="LB_EmpresasOR"/><br />
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_EmpresasDe"
	default="Lista Empresas Destino"
	returnvariable="LB_EmpresasDe"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nombre"
	default="Nombre"
	returnvariable="LB_Nombre"/>	


<form name="form1" method="post" action="clonacion-sql.cfm" >	
	<cfoutput>
	<input type="hidden" name="ACCION" 			value= "1">
	<input type="hidden" name="Usucodigo" 		value= "#session.Usucodigo#">
	<input type="hidden" name="CEcodigoD" 		value= "#form.CEcodigoD#">
	<input type="hidden" name="CEcodigoO" 		value= "#form.CEcodigoO#">
	<cfif not isdefined("form.DSND")>
		
		<input type="hidden" name="DSND" 			value= "#form.DSNO#">
	<cfelse>
		<input type="hidden" name="DSND" 			value= "#form.DSND#">
	</cfif>
	<input type="hidden" name="DSNO" 			value= "#form.DSNO#">
	<input type="hidden" name="EcodigoD" 		value= "<cfif isdefined('form.EcodigoD') and len(trim(form.EcodigoD))>#form.EcodigoD#</cfif>">
	<input type="hidden" name="EcodigoO" 		value= "<cfif isdefined('form.EcodigoO') and len(trim(form.EcodigoO))>#form.EcodigoO#</cfif>">
	<input type="hidden" name="SScodigoO" 		value= "<cfif isdefined('form.SScodigoO') and len(trim(form.SScodigoO))>#form.SScodigoO#</cfif>">
	<cfif isdefined("form.chkSQL")>
		<input type="hidden" name="chkSQL" 	value= "#form.chkSQL#">
	</cfif>
	</cfoutput>
	
<cfoutput>

<cffunction name="reg" returntype="query">
	<cfargument name="tabla" 	type="string" required="true">	
	<cfargument name="DB" 		type="string" required="true">	
	<cfargument name="Eco" 		type="numeric" required="true">	
	
	<cfquery name="rs" datasource="#DB#">
		select count(1) as total from #tabla# where Ecodigo=#Eco#
	</cfquery>
	<cfreturn #rs#>
</cffunction>


<!---<script language="javascript1.2" type="text/javascript">
	function check(obj, empresa, sistema, modulo, cantidad){
		for ( var i=1; i<=cantidad; i++ ){
			var objeto = empresa + '|' + sistema + '|' + modulo + '|' + i;
			
			if (obj.checked){
				document.getElementById(objeto).checked = true;
			}
			else{
				document.getElementById(objeto).checked = false;
			}
		}
		
		// verifica check de empresa
		var obj_empresa = document.getElementById(empresa);
		check_empresa2(obj_empresa,empresa);
		
	}

	function check_sistema(obj, empresa, sistema, modulo, cantidad){
		// nada que ver con esta funcion pero se pone aqui
		//borrar(obj);
		<!---var objeto = empresa + '|' + sistema + '|' + modulo;		// check de modulo
		var empresa2 = "empresa_" + empresa;		// check de modulo
		
		if (obj.checked){
			// VERIFICA LOS DEMAS OBJETOS PARA ESA EMPRESA Y MODULO ACTUAL
			for ( var i=1; i<=cantidad; i++ ){
				var objeto2 = empresa + '|' + sistema + '|' + modulo + '|' + i;		// check de procesos
				if (!document.getElementById(objeto2).checked){
					document.getElementById(empresa2).value = "false";
					return;
				}
			}	
			document.getElementById(objeto).checked = true;
		}
		else{
			document.getElementById(objeto).checked = false;
			document.getElementById(empresa2).value = "false";
		}
		

		// verfica check de empresa
		var obj_empresa = document.getElementById(empresa);
		check_empresa2(obj_empresa,empresa );--->
		
	}
	
	function check_empresa(obj, empresa){
	// RESULTADO
	// Marca los checks para todos los modulos y procesos de una empresa
		f = obj.form;
		
		for ( var i=0; i< f.elements.length; i++ ){
			if (f.elements[i].type == 'checkbox'){
				if ( f.elements[i].id.substring(0, f.elements[i].id.indexOf('|')) == empresa ){
					if (obj.checked){
						f.elements[i].checked = true;
					}
					else{
						f.elements[i].checked = false;
					}
				}
			}
		}
	}

	function check_empresa2(obj, empresa){
	// RESULTADO
	// Marca el check de empresa si todas sus empresas y procesos estan marcados

		f = obj.form;
		
		for ( var i=0; i< f.elements.length; i++ ){
			if (f.elements[i].type == 'checkbox' || f.elements[i].name == 'modulo' ){
				if ( f.elements[i].id.substring(0, f.elements[i].id.indexOf('|')) == empresa){
					if ( !f.elements[i].checked){
						obj.checked=false;
						return;
					}
				}
			}
		}
		obj.checked=true;
		return
	}

	function filtrar(){
		document.form1.action = '';
		document.form1.submit();
	}

	function prueba(empresa, sistema, modulo, modo){
		document.getElementById(empresa+'|'+sistema+'|'+modulo+'|div').style.display = modo;
				
	}
	
	function imagen(obj, empresa, sistema, modulo){
		if (obj.name == 'mas'){
			obj.name = 'menos';
			obj.src = '../imagenes/menos.gif';
			prueba(empresa,sistema,modulo, '');
		}
		else{
			obj.name = 'mas';
			obj.src = '../imagenes/mas.gif';
			prueba(empresa,sistema,modulo,'none');
		}
	}
	
	function borrar(obj){
		// agrega el codigo del registro a borrar
		if (!obj.checked){
			document.form1.procesos_borrar.value = document.form1.procesos_borrar.value + obj.value + '*';
		}
	}
	
</script>--->


<!---<cfquery name="rsDetallesO" datasource="#form.DSNO#">
	select count(1) as total from Oficinas where Ecodigo=#form.EcodigoO#
</cfquery>
<cfquery name="rsDetallesD" datasource="#form.DSND#">
	select count(1) as total from Departamentos where Ecodigo=#form.EcodigoD#
</cfquery>--->


<cf_dbtemp name="clonacion" returnvariable="session.clonacion" datasource="#form.DSNO#">
	<cf_dbtempcol name="Empresa"	type="numeric" 		mandatory="no">
	<cf_dbtempcol name="Sistema"	type="varchar(10)" 	mandatory="no">
	<cf_dbtempcol name="Orden" 		type="numeric" 		mandatory="no">  
	<cf_dbtempcol name="Grupo"	 	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="subGrupo"	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Proceso" 	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Tabla" 		type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Padre"	 	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Hijo"	 	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Lista" 		type="varchar(10)" 	mandatory="no">
	<cf_dbtempcol name="Nivel" 		type="integer" 		mandatory="no">
	<cf_dbtempcol name="Fuente"	 	type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="Llave"	 	type="varchar(50)" 	mandatory="no">
</cf_dbtemp>

<!---ljimenez Lee la informacion del XML--->
<!--- Directorio actual --->
<cfset session.LvarFiles = ','>
<cfset rootdir = expandpath('')>
<cfset directorio = "#rootdir#/clonacion/rh/">
<cfset directorio = replace(directorio, '\', '/', 'all') >
<cfset xmlfile="#directorio#RHdefinicion.xml">
<cfset arreglodatos  = XmlSearch(xmlfile, "//tabla")>

<!--- Leer archivo XML --->
<cffile action="read" file="#xmlfile#" variable="definicion">

<!--- Analizarlo --->
<cfset mydoc=XMLParse(definicion)>


<!--- Muestra datos --->

<cfloop from="1" to="#arraylen(arreglodatos)#" index="i">
	
	<cfset id	 		= arreglodatos[i].xmlAttributes.id />
	<cfset lista 		= arreglodatos[i].xmlAttributes.lista />
	<cfset nivel 		= arreglodatos[i].xmlAttributes.nivel />
	<cfset Ssistema		= arreglodatos[i].Sistema.xmlText>
	<cfset grupo		= arreglodatos[i].Grupo.xmlText>
	<cfset subgrupo		= arreglodatos[i].subGrupo.xmlText>
	<cfset NombreProceso= arreglodatos[i].NombreProceso.xmlText>
	<cfset tabla 		= arreglodatos[i].NombreTabla.xmlText>
	<cfset padre		= arreglodatos[i].Padre.xmlText>
	<cfset hijo			= arreglodatos[i].Hijo.xmlText>
	<cfset llave		= arreglodatos[i].Llave.xmlText>
	<cfset fuente		= arreglodatos[i].Fuente.xmlText>
	
	<cfset empresa		= 1>

	
<!---	<cfif not isdefined('form.DSND')>
		<cfquery datasource="#form.DSND#">
			insert into #Session.clonacion#(Empresa,Sistema,Orden,Grupo,subGrupo,Tabla,Proceso,Padre,Hijo,Lista,Nivel,Llave,Fuente)
				values (#empresa#,'#Ssistema#',#id#,'#grupo#','#subgrupo#','#tabla#','#NombreProceso#','#padre#','#hijo#','#lista#',#nivel#,'#llave#','#Fuente#')
		</cfquery>
	<cfelse>
		
	</cfif>
--->	
	<cfquery datasource="#form.DSNO#">
		insert into #Session.clonacion#(Empresa,Sistema,Orden,Grupo,subGrupo,Tabla,Proceso,Padre,Hijo,Lista,Nivel,Llave,Fuente)
			values (#empresa#,'#Ssistema#',#id#,'#grupo#','#subgrupo#','#tabla#','#NombreProceso#','#padre#','#hijo#','#lista#',#nivel#,'#llave#','#Fuente#')
	</cfquery>
</cfloop>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr><td>
	<cfif isdefined("form.SScodigoO") and len((form.SScodigoO)) gt 0 and isdefined("form.EcodigoD") and len((form.EcodigoD)) gt 0>
		<cfswitch expression="#rtrim(form.SScodigoO)#">
			<cfcase value="RH"> <cfinclude template="clonacion_rh.cfm">  </cfcase>
			<cfdefaultcase> </cfdefaultcase>
		</cfswitch>
	</cfif>
<tr>
	<td colspan="2" align="center">
	<input name="BClonar" value="Clonar" type="submit"/></td>
	</tr>
</table>


</cfoutput>
	<!--- Para saber que borrar --->
	<input type="hidden" name="procesos_borrar" value="">
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
</form>

<cf_qforms form="form1">
	<cf_qformsRequiredField name="EcodigoD" description="El valor de Ecodigo Destino es requerido">
</cf_qforms>

<cfoutput>
	<script>
	
	var vnContadorListas = 0;
	
		function showConlis(tr,chk){
			if(chk){
				tr.style.display = "";
			}else{
				tr.style.display = "none";
			}
		}
		
		function Marcar(c) {
			if (c.checked) {
					for (counter = 0; counter < document.form1.Clonar.length; counter++)
					{
						if ((!document.form1.Clonar[counter].checked) && (!document.form1.Clonar[counter].disabled))
							{  document.form1.Clonar[counter].checked = true;}
					}
					if ((counter==0)  && (!document.form1.Clonar.disabled)) {
						document.form1.Clonar.checked = true;
					}
				}
				else {
					for (var counter = 0; counter < document.form1.Clonar.length; counter++)
					{
						if ((document.form1.Clonar[counter].checked) && (!document.form1.Clonar[counter].disabled))
							{  document.form1.Clonar[counter].checked = false;}
					};
					if ((counter==0) && (!document.form1.Clonar.disabled)) {
						document.form1.Clonar.checked = false;
					}
				};
			}
			
			
	function fnNuevoEmpleado()
	{		
	  if (document.form1.DEid.value != '' && document.form1.DEidentificacion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblempleado");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneEmpleado;
	  var p1 		= document.form1.DEid.value.toString();//cod
	  var p2 		= document.form1.NombreEmp.value;//desc
	
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
			
	function existeEmpleado(v){
		var LvarTable = document.getElementById("tblempleado");
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
	
	//Función para agregar TDs con Objetos
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
	
	</script>
</cfoutput>
