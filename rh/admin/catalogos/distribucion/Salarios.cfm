
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsSalarios">
	Select a.DECSid,a.CFid,b.CFcodigo,b.CFdescripcion,a.DECSporcentaje
	from DistEmpCompSal a
	inner join CFuncional b
	on a.CFid = b.CFid
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>	

<cfquery datasource="#Session.DSN#" name="rstotal">
	Select coalesce(sum(DECSporcentaje),0) as DECSporcentaje ,count(DECSid) as cantidad
	from DistEmpCompSal
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>	


<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>

<cfset navegacionSal = "">
<cfset navegacionSal = navegacionSal & Iif(Len(Trim(navegacionSal)) NEQ 0, DE("&"), DE("")) & "o=1">

<cfif isdefined("Form.DEid")>
	<cfset navegacionSal = navegacionSal & Iif(Len(Trim(navegacionSal)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionSal = navegacionSal & Iif(Len(Trim(navegacionSal)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 
	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Porcentaje"
	Default="Porcentaje"
	returnvariable="LB_Porcentaje"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Eliminar_el_centro_funcional"
	Default="Eliminar el centro funcional"
	returnvariable="MSG_Eliminar_el_centro_funcional"/>

<cfoutput>
<form name="form1" method="post" action="salarios-sql.cfm" onSubmit="return valida();">

	<table  id="tbldynamic"  width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="25%">
			#LB_CentroFuncional#
		</td>
		<td colspan="2">
		<cf_rhcfuncional tabindex="1">
		</td>
	  </tr>
	  <tr>
		<td>
			#LB_Porcentaje# (%)
		</td>
		<td nowrap="nowrap">
			<input 
			name="DECSporcentaje" 
			type="text" 
			id="DECSporcentaje"  
			tabindex="1"
			size="12"
			style="text-align: right; font-size:10px" 
			onBlur="javascript: fm(this,2);"  
			onFocus="javascript:this.value=qf(this); this.select();"  
			onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
			value="">	
			<input type="button" name="Agregar" value="+" onClick="javascript: return fnNuevoTR();" />	
		</td>
		<td>
			
		</td>
	  </tr>

	</table>
	<table  width="100%" border="0" cellspacing="0" cellpadding="0">	
 	  	<cfif isdefined("rstotal")>
			<cfif rstotal.cantidad eq 0>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Actualmente_no_hay_distribucion"
					Default="Actualmente no hay distribuci&oacute;n"
					returnvariable="MSG_Actualmente_no_hay_distribucion"/>			  
			  <tr>
				<td  colspan="2">
					#MSG_Actualmente_no_hay_distribucion#	
				</td>
			  </tr>			
			<cfelse>
				<cfif rstotal.DECSporcentaje eq 100>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_distribucion_al_100_porcierto"
					Default="Distribuci&oacute;n al 100 %"
					returnvariable="MSG_distribucion_al_100_porcierto"/>
					<tr>
						<td  colspan="2">
							<b>#MSG_distribucion_al_100_porcierto#</b>	
						</td>
					</tr>
				<cfelseif rstotal.DECSporcentaje gt 100>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_distribucion_supera_el_100_porcierto"
					Default="Distribuci&oacute;n supera el 100 %"
					returnvariable="MSG_distribucion_supera_el_100_porcierto"/>
					<tr>
						<td  colspan="2">
							<b>#MSG_distribucion_supera_el_100_porcierto#</b> &nbsp;&nbsp;<font color="##FF0000"> (#rstotal.DECSporcentaje# %)	</font>
						</td>
					</tr>
				<cfelseif rstotal.DECSporcentaje lt 100>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_distribucion_menor_al_100_porcierto"
					Default="Distribuci&oacute;n menor al 100 %"
					returnvariable="MSG_distribucion_menor_al_100_porcierto"/>
					
					<tr>
						<td  colspan="2">
							<b>#MSG_distribucion_menor_al_100_porcierto#</b> &nbsp;&nbsp;  <font color="##FF0000"> (#rstotal.DECSporcentaje# %)	</font>
						</td>
					</tr>
				</cfif>
				<cfif rstotal.DECSporcentaje neq 100>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Advertencia"
					Default="Si la distribuci&oacute;n no se encuentra al 100%, no ser&aacute; tomada en cuenta."
					returnvariable="MSG_Advertencia"/>
					
					<tr>
						<td  colspan="2">
							<br /><b> <font color="##FF0000">#MSG_Advertencia#</font></b>
						</td>
					</tr>
				</cfif>
			
			</cfif>
		</cfif>

	  <tr>
	  	<td colspan="2">
			<cf_botones values="Aplicar" tabindex="1">
		</td>
	  </tr>
	</table>	
	<input type="hidden" name="LastOne" 		id="LastOne" value="ListaNon">
	<input type="hidden" name="DEid"   			id="DEid"    value="#form.DEid#">
	
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="#MSG_Eliminar_el_centro_funcional#" style="display:none;">
 
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Debe_seleccionar_un_centro_funcional_e_indicar_el_porcentaje_de_distribucion"
	Default="Debe seleccionar un centro funcional e indicar el porcentaje de distribuci&oacute;n"
	returnvariable="MSG_Debe_seleccionar_un_centro_funcional_e_indicar_el_porcentaje_de_distribucion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado"
	returnvariable="MSG_EsteValorYaFueAgregado"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="JSMSG_La_lista_de_distribucion_es_requerida"
	Default="La lista de distribución es requerida"
	returnvariable="JSMSG_La_lista_de_distribucion_es_requerida"/> 	


<script language="JavaScript" type="text/javascript">
	var vnContadorListas1 = 0;
	<cfif isdefined("rsSalarios") and rsSalarios.recordcount gt 0 >
		<cfloop query="rsSalarios">
			<cfoutput>
				<cfset descripcion = LSNumberFormat(rsSalarios.DECSporcentaje,'____.__')  & '  % ' & trim(rsSalarios.CFcodigo) & '-' &  trim(rsSalarios.CFdescripcion)  >
			</cfoutput>
			fnNuevoTRSP('<cfoutput>#rsSalarios.CFid#</cfoutput>','<cfoutput>#rsSalarios.DECSporcentaje#</cfoutput>','<cfoutput>#descripcion#</cfoutput>');
		</cfloop>
	</cfif>	
	
	function fnNuevoTRSP(p1,p2,p3){
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOne;
	  // Valida no agregar vacíos
	  if (p1=="" || p2=="") {
	  alert('<cfoutput>#MSG_Debe_seleccionar_un_centro_funcional_e_indicar_el_porcentaje_de_distribucion#</cfoutput>')
	  return;
	  }
	  
	  // Valida no agregar repetidos
	  
	 
	  if (existeCodigo(p1+'|'+p2)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}
	
	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p2, "hidden", "RHCGidList");
	
	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p3 );
	
	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
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
	

	function fnNuevoTR(){
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOne;
	  var p1 		= document.form1.CFid.value;//id
	  var p2 		= qf(document.form1.DECSporcentaje.value);//cod
 	  var p3 		= document.form1.DECSporcentaje.value + '  % ' + document.form1.CFcodigo.value  +'-'+ document.form1.CFdescripcion.value ;//descripcion
	  // Valida no agregar vacíos
	  if (p1=="" || p2=="") {
	  alert('<cfoutput>#MSG_Debe_seleccionar_un_centro_funcional_e_indicar_el_porcentaje_de_distribucion#</cfoutput>')
	  return;
	  }
	  
	  // Valida no agregar repetidos
	  
	 
	  if (existeCodigo(p1+'|'+p2)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}
	
	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p2, "hidden", "RHCGidList");
	
	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p3 );
	
	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
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
	  var LvarTR;
	  vnContadorListas1 = vnContadorListas1 - 1;	
	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
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
	  vnContadorListas1 = vnContadorListas1 + 1;
	}
	
	function existeCodigo(v){
		var LvarTable = document.getElementById("tbldynamic");
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var  valor = fnTdValue(LvarTable.rows[i]);
			
			if (valor==v){
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
	
	    function  valida(){
	}



</script>


