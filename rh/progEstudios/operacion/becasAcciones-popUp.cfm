<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sesion" Default="Sesi&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Sesion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Articulo" Default="Art&iacute;culo" XmlFile="/rh/generales.xml" returnvariable="LB_Articulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Justificacion" Default="Justificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Justificacion"/><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>
<cfif isdefined('Auto')>Otros Detalles<cfelse><cfif Tipo eq 1>Aprobar<cfelseif Tipo eq 2>Rechazar</cfif></cfif>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfparam name="accion" default="">
<cfset readonly = "true">
<cfset botones = "Cerrar">
<cfset nombres = "Cerrar">
<cfif not isdefined('Auto')>
	<cfif Tipo eq 1>
        <cfset botones = botones & ",Aprobar">
        <cfset nombres = nombres & ",AprobarCom">
    <cfelseif Tipo eq 2>
        <cfif accion eq 'vice'>
            <cfset botones = botones & ",Rechazar">
            <cfset nombres = nombres & ",RechazarVic">
        <cfelse>
            <cfset botones = botones & ",Rechazar">
            <cfset nombres = nombres & ",RechazarCom">
        </cfif>
    </cfif>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
        <form name="form1" method="post" action="">
        <tr>
            <td colspan="3" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
                <cf_botones formName="form2" values="#botones#" names="#nombres#" align="right">
            </td>
        </tr>
        <cfif isdefined('Auto')>
        	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEBE" returnvariable="rsEBeca">
                <cfinvokeargument name="RHEBEid" 		value="#url.RHEBEid#">
            </cfinvoke>
        	<cfif ListFind('30,70',rsEBeca.RHEBEestado)>
                <tr>
                    <td width="5%" nowrap><strong>#LB_Sesion#:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>#rsEBeca.RHEBEsesionJef#<cfelse>#rsEBeca.RHEBEsesionCom#</cfif></td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td width="5%" nowrap><strong>#LB_Articulo#:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>#rsEBeca.RHEBEarticuloJef#<cfelse>#rsEBeca.RHEBEarticuloCom#</cfif></td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td width="5%" nowrap><strong>#LB_Fecha#:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>#LSdateFormat(rsEBeca.RHEBEfechaJef,'dd/mm/yyyy')#<cfelse>#LSdateFormat(rsEBeca.RHEBEfechaCom,'dd/mm/yyyy')#</cfif></td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
            </cfif>
            <cfif ListFind('20,40,60',rsEBeca.RHEBEestado)>
            <tr>
                <td width="5%" nowrap><strong>#LB_Justificacion#:&nbsp;</strong></td>
                <td colspan="2"><cfif rsEBeca.RHEBEestado eq '20'>#rsEBeca.RHEBEjustificacionJef#<cfelseif rsEBeca.RHEBEestado eq '40'>#rsEBeca.RHEBEjustificacionVic#<cfelse>#rsEBeca.RHEBEjustificacionCom#</cfif></td>
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            </cfif>
            <cfif ListFind('70',rsEBeca.RHEBEestado)>
            	<cfquery name="rsFiadores" datasource="#session.dsn#">
                    select coalesce(DEnombre,RHFnombre) #_CAT# ' ' #_CAT# coalesce(DEapellido1,RHFapellido1) #_CAT# ' ' #_CAT#  coalesce(DEapellido2,RHFapellido2) as nombre,
                           coalesce(DEidentificacion, RHFcedula) as indentificacion
                    from RHFiadoresBecasEmpleado fb
                        left outer join DatosEmpleado d
                            on d.DEid = fb.DEid
                        left outer join RHFiadores f
                            on f.RHFid = fb.RHFid
                    where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEBEid#">
                </cfquery>
                <tr>
                    <td colspan="3"><strong>Fiadores:</strong></td>
                </tr>
                <tr>
                    <td nowrap colspan="3">
                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        	<cfloop query="rsFiadores">
                           		<tr><td>#rsFiadores.indentificacion# - #rsFiadores.nombre#</td></tr>
                            </cfloop>
                        </table>
                     </td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                   <td><strong>Acuerdo:</strong></td>
                </tr>
                <tr>
                   <td style="border:1px">#rsEBeca.RHEBEacuerdo#</td>
                </tr>
            </cfif>
        <cfelse>
			<cfif Tipo eq 1>
            <tr>
                <td align="right"><strong>#LB_Sesion#:&nbsp;</strong></td>
                <td colspan="2"><input type="text" name="RHEBEsesionCom" id="RHEBEsesionCom" value="" size="50" maxlength="60"></td>
            </tr>
            <tr>
                <td align="right"><strong>#LB_Articulo#:&nbsp;</strong></td>
                <td colspan="2"><input type="text" name="RHEBEarticuloCom" id="RHEBEarticuloCom" value="" size="50" maxlength="60"></td>
            </tr>
            <tr>
                <td align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
                <td colspan="2"><cf_sifcalendario name="RHEBEfechaCom" value="#LSDateFormat(Now(),'DD/MM/YYYY')#"></td>
            </tr>
            <tr>
                <td align="right"><strong>Fiadores:&nbsp;</strong></td>
                <td nowrap>
                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <tr id="empleado">
                            <td>
                                <cf_conlis
                                    campos="DEid,DEidentificacion,Empleado"
                                    desplegables="N,S,S"
                                    modificables="N,S,N"
                                    size="0,10,50"
                                    title="Lista de Empleados"
                                    tabla="DatosEmpleado"
                                    columnas="DEid, DEidentificacion, DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido2 as Empleado"
                                    filtro="Ecodigo = #session.Ecodigo#"
                                    desplegar="DEidentificacion, Empleado"
                                    filtrar_por="DEidentificacion|DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido1"
                                    filtrar_por_delimiters="|"
                                    etiquetas="Indentificación,Empleado"
                                    formatos="S,S"
                                    align="left,left"
                                    asignar="DEid, DEidentificacion, Empleado"
                                    asignarformatos="I,S,S"
                                    showEmptyListMsg="true"
                                    form = "form1"
                                    tabindex = "2"
                                >
                            </td>
                            <td>
                                <input type="button" name="AltaE" id="AltaE" class="btnNormal" value="+" onclick="return fnIngresarFiador(1)">
                            </td>
                        </tr>
                        <tr id="fiador" style="display:none">
                            <td>
                                <cf_conlis
                                    campos="RHFid,RHFcedula,Fiador"
                                    desplegables="N,S,S"
                                    modificables="N,S,N"
                                    size="0,10,50"
                                    title="Lista de Fiadores"
                                    tabla="RHFiadores"
                                    columnas="RHFid, RHFcedula, RHFnombre#_CAT#' '#_CAT#RHFapellido1#_CAT#' '#_CAT#RHFapellido2 as Fiador"
                                    filtro="Ecodigo = #session.Ecodigo#"
                                    desplegar="RHFcedula,Fiador"
                                    filtrar_por="RHFid|RHFcedula, RHFnombre#_CAT#' '#_CAT#RHFapellido1#_CAT#' '#_CAT#RHFapellido2"
                                    filtrar_por_delimiters="|"
                                    etiquetas="Indentificación,Empleado"
                                    formatos="S,S"
                                    align="left,left"
                                    asignar="RHFid,RHFcedula,Fiador"
                                    asignarformatos="I,S,S"
                                    showEmptyListMsg="true"
                                    form = "form1"
                                    tabindex = "2"
                                >
                            </td>
                            <td>
                                <input type="button" name="AltaF" id="AltaF" class="btnNormal" value="+" onclick="return fnIngresarFiador(2)">
                            </td>
                        </tr>
                    </table>
                </td>
                <td nowrap><input type="radio" name="TipoFiador" value="1" onClick="fnMostrarCampo(this.value)" checked>Por Empleado&nbsp;<input type="radio" name="TipoFiador" value="2" onClick="fnMostrarCampo(this.value)">Por Fiador</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td colspan="2">
                    <table width="50%" align="left" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
                        <tr><td></td></tr>
                    </table>
                </td>
            </tr>
            <tr>
               <td colspan="3">
                    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Acuerdo">
                        <cf_rheditorhtml name="RHEBEacuerdo" value="">
                    <cf_web_portlet_end>
                    <input type="hidden" name="RHEBEid" id="RHEBEid" value="#url.RHEBEid#">
                    <input type="hidden" name="DEids" 	id="DEids" 	 value="">
                    <input type="hidden" name="RHFids"  id="RHFids"  value="">
                </td>
            </tr>
            
            <cfelseif Tipo eq 2>
                <cfif accion eq 'vice'>
                    <tr>
                        <td align="right" width="10%" nowrap><strong>#LB_Justificacion#:&nbsp;</strong></td>
                        <td><textarea name="RHEBEjustificacionVic" id="RHEBEjustificacionVic" rows="3" style="width:100%"></textarea></td>
                    </tr>
                <cfelse>
                    <tr>
                        <td align="right" width="10%" nowrap><strong>#LB_Justificacion#:&nbsp;</strong></td>
                        <td colspan="2">
                            <textarea name="RHEBEjustificacionCom" id="RHEBEjustificacionCom" rows="3" style="width:100%"></textarea>
                        </td>
                    </tr>
                </cfif>
            </cfif>
        </cfif>
        <tr>
            <td colspan="3" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
                <cf_botones formName="form2" values="#botones#" names="#nombres#" align="right">
               	<input type="hidden" name="clase" id="clase" value="ListaNon">
                <input type="image"  name="imgDel" id="imgDel" value=""	src="/cfmx/rh/imagenes/delete.small.png" title="Eliminar" style="display:none;" tabindex="1">
            </td>
        </tr>
        </form>
	</table>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	<cfif not isdefined('Auto')>
		<cfif Tipo eq 1> 
		function funcAprobarCom(){
			errores = "";
			
			session = document.getElementById('RHEBEsesionCom').value;
			if(trim(session).length == 0)
				errores = errores + " -La sesión es requerido.\n";
			
			articulo = document.getElementById('RHEBEarticuloCom').value;
			if(trim(articulo).length == 0)
				errores = errores + " -La artículo es requerido.\n";
			
			fecha = document.getElementById('RHEBEfechaCom').value;
			if(trim(fecha).length == 0)
				errores = errores + " -La fecha es requerida.\n";
			
			var LvarTable = document.getElementById("tblcuenta");
			var LvarDeid = "";
			var LvarRHFid = "";
			for (var i=0; i<LvarTable.rows.length; i++){
				var value = new String(fnTdValue(LvarTable.rows[i]));
				var data = value.split('|');
				if (data[1] == 1)
					LvarDeid = LvarDeid + "," + data[0];
				else if(data[1] == 2)
					LvarRHFid = LvarRHFid + "," + data[0];
			}
			
			document.form1.DEids.value = LvarDeid;
			document.form1.RHFids.value = LvarRHFid;
			
			if(errores.length > 0){
				alert("Se presentaron los siguientes errores:\n" + errores);
				return false;
			}
			if(confirm("Este seguro de aprobar la beca?")){
				document.form1.action= "becas-sql.cfm";
			}else
				return false;
		}
		
		function fnMostrarCampo(c){
			if(c == 1){
				document.getElementById('fiador').style.display="none";
				document.getElementById('empleado').style.display="";
			}else{
				document.getElementById('fiador').style.display="";
				document.getElementById('empleado').style.display="none";
			}
		}
		
		function fnIngresarFiador(tipo){
			var LvarTable 	= document.getElementById("tblcuenta");
			var LvarTbody 	= LvarTable.tBodies[0];
			var LvarTR    	= document.createElement("TR");
			var Lclass 		= document.form1.clase;
			if(tipo == 1){
				var idFiador	= document.form1.DEid.value;
				var contenido	= document.form1.DEidentificacion.value + " " + document.form1.Empleado.value;
				document.form1.DEid.value = "";
				document.form1.DEidentificacion.value = "";
				document.form1.Empleado.value = "";
			}else{
				var idFiador	= document.form1.RHFid.value;
				var contenido	= document.form1.RHFcedula.value + " " + document.form1.Fiador.value;
				document.form1.RHFid.value = "";
				document.form1.RHFcedula.value = "";
				document.form1.Fiador.value = "";
			}
	
			if (idFiador == "") {
				return;
			}	
	
			if (fnExisteFiador(idFiador, tipo)) {
				alert('El fiador ya fue agregada.');
				return;
			}
	
			sbAgregaTdInput (LvarTR, Lclass.value, idFiador, tipo, "hidden", (tipo == 1 ? "DEidT" : "RHFidT"));
			sbAgregaTdText  (LvarTR, Lclass.value, contenido);
			sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
			if (document.all) {
				GvarNewTD.attachEvent ("onclick", sbEliminarTR);
			}
			else {
				GvarNewTD.addEventListener ("click", sbEliminarTR, false);
			}
			LvarTR.name = "XXXXX";
			LvarTbody.appendChild(LvarTR);
			if (Lclass.value=="ListaNon") {
				Lclass.value="ListaPar";
			}
			else {
				Lclass.value="ListaNon";
			}
		}
		
		function fnExisteFiador(v,tipo){
			var LvarTable = document.getElementById("tblcuenta");
			for (var i=0; i<LvarTable.rows.length; i++){
				var value = new String(fnTdValue(LvarTable.rows[i]));
				var data = value.split('|');
				if (data[0] == v && data[1] == tipo) {
					return true;
				}
			}
			return false;
		}
		
		function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, lprmTipo, LprmType, LprmName){
			var LvarTD    = document.createElement("TD");
			var LvarInp   = document.createElement("INPUT");
			LvarInp.type = LprmType;
			if (LprmName != "") {
				LvarInp.name = LprmName;
			}
			
			if (LprmValue != "") {
				LvarInp.value = LprmValue + "|" + lprmTipo;
			} 
	
			LvarTD.appendChild(LvarInp);
			if (LprmClass!="") { 
				LvarTD.className = LprmClass;
			}
			GvarNewTD = LvarTD;
			LprmTR.appendChild(LvarTD);
			
		}
		
		function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
			var LvarTD    = document.createElement("TD");
			var LvarTxt   = document.createTextNode(LprmValue);
			LvarTD.appendChild(LvarTxt);
			if (LprmClass!="") {
				LvarTD.className = LprmClass;
			}
			GvarNewTD = LvarTD;
			LvarTD.noWrap = true;
			LprmTR.appendChild(LvarTD);
		}
		
		function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
			var LvarTDimg 	= document.createElement("TD");
			var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
			LvarImg.style.display="";
			LvarImg.align=align;
			LvarTDimg.appendChild(LvarImg);
			if (LprmClass != "") {
				LvarTDimg.className = LprmClass;
			}
			GvarNewTD = LvarTDimg;
			LprmTR.appendChild(LvarTDimg);
		}
		
		function fnTdValue(LprmNode){
			var LvarNode = LprmNode;
			while (LvarNode.hasChildNodes()) {
				LvarNode = LvarNode.firstChild;
				if (document.all == null) {
					if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes()) {
						LvarNode = LvarNode.nextSibling;
					}
				}
			}
			if (LvarNode.value) {
				return LvarNode.value;
			} 
			else {
				return LvarNode.nodeValue;
			}
		}
		
		function sbEliminarTR(e){
			var LvarTR;
			if (document.all) {
				LvarTR = e.srcElement;
			}
			else {
				LvarTR = e.currentTarget;
			}
			while (LvarTR.name != "XXXXX") {
				LvarTR = LvarTR.parentNode;
			}
			LvarTR.parentNode.removeChild(LvarTR);	
		}
		<cfelseif Tipo eq 2>
	
			<cfif accion eq 'vice'>
				function funcRechazarVic(){
					errores = "";
					just = document.getElementById('RHEBEjustificacionVic').value;
					if(trim(just).length == 0)
						errores = errores + " -La justificación es requerida.\n";		
					window.opener.document.form1.RHEBEjustificacionVic.value = just;
					if(errores.length > 0){
						alert("Se presentaron los siguientes errores:\n" + errores);
						return false;
					}
					if(confirm("Este seguro de rechazar la(s) beca(s)?")){
						window.opener.document.form1.submit();
						funcCerrar();
					}else
						return false;
				}
			<cfelse>
				function funcRechazarCom(){
					errores = "";
					just = document.getElementById('RHEBEjustificacionCom').value;
					if(trim(just).length == 0)
						errores = errores + " -La justificación es requerida.\n";
					window.opener.document.form2.RHEBEjustificacionCom.value = just;
					if(errores.length > 0){
						alert("Se presentaron los siguientes errores:\n" + errores);
						return false;
					}
					if(confirm("Este seguro de rechazar la beca?")){
						window.opener.document.form2.accion.value = "RechazarCom";
						window.opener.document.form2.submit();
						funcCerrar();
					}else
						return false;
				}
			</cfif>
		</cfif>
		
		function trim(cad){  
			return cad.replace(/^\s+|\s+$/g,"");  
		}
	</cfif>
	function funcCerrar(){
		window.close();
	}
	
</script>
</body>
</html>