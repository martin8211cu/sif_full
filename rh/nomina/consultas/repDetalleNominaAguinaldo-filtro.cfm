<body onLoad="ajaxFunction_ComboNomina()">
<cfsilent>

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
		Key="LB_NominaAguinaldo"
		Default="La lista de Nóminas de Aguinaldo"
		returnvariable="LB_NominaAguinaldo"/> 
        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CODIGO"
		Default="C&oacute;digo"
		returnvariable="LB_CODIGO"/> 
        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DESCRIPCION"
		Default="Descripci&oacute;n"
		returnvariable="LB_DESCRIPCION"/> 
        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoHayRegistrosRelacionados"
		Default="No Hay Regsitros Relacionados"
		returnvariable="MSG_NoHayRegistrosRelacionados"/>
        
	<cfquery name="rsTiposNominas" datasource="#session.dsn#">
		select Tcodigo, Tdescripcion 
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
</cfsilent>

<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="repDetalleNominaAguinaldo-rep.cfm" style="margin:0;">
	<!---<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<input type="hidden" name="CPidlist2" id="CPidlist2" value="" tabindex="1">--->
    <!---<input type="hidden" name="vFiltro" id="vFiltro" value="1" tabindex="1">--->
    
	<table  width="70%" cellpadding="2" cellspacing="0" border="0" align="center">
    	<tr height="20px"> 
            <td nowrap align="right" valign="top">
            </td>
            <td nowrap> 
            </td>
        </tr>
        <tr> 
            <td nowrap align="right" valign="top"><input name="NAplicada" id="NAplicada" type="checkbox"></td>
            <td nowrap valign="top"> 
 <label style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate></strong></label>
            </td>
        </tr>
    	<tr> 
            <td nowrap align="right" valign="top"><cf_translate key="LB_Tipo_de_Nomina"><strong>Tipo de nomina&nbsp;:&nbsp;</strong></cf_translate></td>
            <td nowrap valign="top"> 
            	<select name="TipoNomina" id="TipoNomina" onChange="ajaxFunction_ComboNomina();">
                		<option value="-1" selected>-- Selecciona Nomina --</option>	
						<cfloop query="rsTiposNominas">
							<option value="#Tcodigo#">#Tdescripcion#</option>	
						</cfloop>
				</select>
            <!---   <input name="Nominaid" type="hidden" id="Nominaid" value="document.form1['TipoNomina'].options[document.form1['TipoNomina].selectedIndex].value;">--->
            </td>
        </tr>
        <tr >
        	<td nowrap align="right" valign="top"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
            <td nowrap>
				<cfquery name="rsConcepto" datasource="#session.DSN#">
        			select CPid,CPcodigo,CPdescripcion 
					from CalendarioPagos cp <cfif isdefined ('form.NAplicada') and #form.NAplicada# EQ false>
                    						inner join RCalculoNomina rcn on rcn.RCNid = cp.CPid
                                            <cfelseif isdefined ('form.NAplicada') and #form.NAplicada# EQ true>
                                            inner join HRCalculoNomina rcn on rcn.RCNid = cp.CPid
                                            </cfif>
					where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
					and cp.CPTipoCalRenta = 2
					and cp.Tcodigo = '01'
    			</cfquery>
                
            	<table id="tblCar" align="left"   border="0" cellspacing="0" cellpadding="0">
				<tr height="20px">
					<td><span id="contenedor_Concepto1">					
					<!---<select name="Nomina" id="nomina">
						<cfloop query="rsConcepto">
							<option value="#CPid#">#CPcodigo# - #CPdescripcion#</option>	
						</cfloop>
					</select>	--->
					</span> </td>	
							
					<td  nowrap="nowrap">
						<div style="display:none ;" id="verCargas">
						    <input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
						</div>
					</td>
					<td>
						<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar();" value="+" tabindex="2">
					</td>
				</tr>
			</table>	
			</td>
        </tr>
        <tr>
        	<td nowrap align="right" valign="top"><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
        	<td nowrap colspan="2" valign="top"><cf_rhempleado tabindex="1">&nbsp;</td>
        </tr>
        <tr>
            <td align="center" colspan="3" >
            	<cf_botones values="Generar" tabindex="1">
            </td>
         </tr>
	</table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	var vnContadorListas = 0;
	var GvarNewTD;
		
	//Función para agregar TRs
	function fnNuevoCar()
	{
	  var IndexSelect= document.form1.Nomina.selectedIndex ;
	  var CIcodigoSelec = document.form1.Nomina.options[IndexSelect].value ;	  
	  var CIdescripcionSelec = document.form1.Nomina.options[IndexSelect].text;	  
			 	
	  if (CIcodigoSelec != '' && CIdescripcionSelec != ''){ 
	 		vnContadorListas = vnContadorListas + 1; 	
	  }
	   
	  var LvarTable = document.getElementById("tblCar");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("tr");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= CIcodigoSelec;//id
	  var p2 		= CIdescripcionSelec;//desc
	 
	  CIcodigoSelec = "";
	  CIdescripcionSelec = "";

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	   
	  // Valida no agregar repetidos
	  if (existeCodigoCar(p1)) {alert('El concepto de pago seleccionado es repetido.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1,"hidden", "CaridList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  
	   // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	   //Nombra el TR
	  LvarTR.name = "ConceptosPagos";
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
	  var LvarTDimg = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align = align;
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
	
	  while (LvarTR.name != "ConceptosPagos")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	function ajaxFunction_ComboNomina(){
		<!---alert('Aqui estoy');--->
		var ajaxRequest1;  // The variable that makes Ajax possible!
		
		var vID_tipo_comportamiento ='';
		var NAplicada = false;
		
		var IndexSelect= document.form1.TipoNomina.selectedIndex ;
	 	var CIcodigoSelec = document.form1.TipoNomina.options[IndexSelect].value ;	  
	    var CIdescripcionSelec = document.form1.TipoNomina.options[IndexSelect].text;	
		
		vID_tipo_comportamiento = CIcodigoSelec;
		NAplicada = document.form1.NAplicada.checked;
	
		try{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest1 = new XMLHttpRequest();
		} catch (e){
			// Internet Explorer Browsers
			try{
				ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try{
					ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}
		ajaxRequest1.open("GET", '/cfmx/rh/nomina/consultas/ComboAguinaldo.cfm?RHTcomportam='+ vID_tipo_comportamiento + '&NAplicada=' + NAplicada, false);
		ajaxRequest1.send(null);
		document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
	}
	
</script>




