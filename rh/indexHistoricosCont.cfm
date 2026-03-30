<cfif isdefined('form.CPid') and not isdefined('form.RCNid')>
	<cfset form.RCNid = form.CPid>
</cfif>
<cfif isdefined('url.CPid') and not isdefined('form.RCNid')>
	<cfset form.RCNid = url.CPid>
</cfif>
<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset Form.RCNid = Url.RCNid>
</cfif>
<cfif isdefined('url.fecha') and not isdefined('form.fecha')>
	<cfset form.fecha = url.fecha>
</cfif>

<cfset regresar = "/cfmx/rh/index.cfm">
<style type="text/css">
.chk {  
 background: buttonface; 
 padding: 1px;
 color: buttontext;
}
</style>
<cfset pintarReporte = true>


<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td><cfinclude template="portlets/pNavegacion.cfm"></td></tr>
</table>

<cfoutput>
<form name="form1" method="get" action="/cfmx/rh/nomina/consultas/PConsultaRCalculoHist.cfm">
	<table width="89%" border="0" align="center" cellpadding="1" cellspacing="2">
  		<!--- Línea No.1 --->
		<tr>
    		<td>&nbsp;</td>
    		<td width="16%">&nbsp;</td>
    		<td width="9%">&nbsp;</td>
    		<td width="15%">&nbsp;</td>
    		<td>&nbsp;</td>
  		</tr>
  		<!--- Línea No. 2 --->
		<tr align="center">
    		<td>&nbsp;</td>
    		<td colspan="3"><font size="3"><strong><cf_translate  key="LB_ReportesHistoricos">Reportes Hist&oacute;ricos</cf_translate></strong></font></td>
    		<td>&nbsp;</td>
  		</tr>
 		<!--- Línea No. 3 --->
  		<tr>
    		<td width="21%">&nbsp;</td>
    		<td colspan="3" align="center" valign="middle" nowrap>
				<input name="radRep" id="radRep" type="radio" onClick="javascript: cambioTipoRep(this);" value="1" checked>      
    			<font size="2"><cf_translate  key="RAD_Relacion">Relaci&oacute;n</cf_translate></font>
      	
				<input type="radio" id="radRep" name="radRep" value="2" onClick="javascript: cambioTipoRep(this);">
				<font size="2"><cf_translate  key="RAD_Deducciones">Deducciones</cf_translate></font>
      	
				<input type="radio" name="radRep" value="3" id="radRep" onClick="javascript: cambioTipoRep(this);">
				<font size="2"><cf_translate  key="RAD_CargasPatronales">Cargas Patronales</cf_translate></font>
	  	
	  			<input type="radio" name="radRep" value="4" id="radRep" onClick="javascript: cambioTipoRep(this);">
				<font size="2"><cf_translate  key="RAD_Incidencias">Incidencias</cf_translate></font>
			</td>
    		<td width="39%">&nbsp;</td>
  		</tr>
		<!--- Línea No. 4 --->
  		<tr>
    		<td>&nbsp;</td>
    		<td width="16%" align="right" nowrap> <strong><cf_translate  key="LB_CalendarioDePago">Calendario de Pago</cf_translate> :</strong></td>
    		<td colspan="2"><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true"></td>
    		<td>&nbsp;</td>
  		</tr>
		<!--- Línea No. 5 --->  
		<tr>
    		<td>&nbsp;</td>
    		<td width="16%"  align="right" nowrap><div align="right"><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:</strong>&nbsp;</div>
    		</td>
			<td colspan="2" align="left">
				<select name="formato">
    				<option value="flashpaper" ><cf_translate key="LB_FlashPaper">Flashpaper</cf_translate></option>
      				<option value="pdf"><cf_translate  key="LB_AdobePDF">Adobe PDF</cf_translate></option>
					<option value="excel"><cf_translate key="LB_MicrosoftExcel">Microsoft Excel</cf_translate></option>
    			</select>
				<div align="center">&nbsp;</div>
    		</td>
    		<td>&nbsp;</td>
  		</tr>
		<tr>
			<td>&nbsp;</td><td>&nbsp;</td>
			<td colspan="2" align="left">
				<div style="display:none ;" id="verICalculo">
					<input name="chkICalculo" id="chkICalculo" type="checkbox" onclick="javascript: habilitaInc();">
					<label for="chkICalculo" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_IncluirIncidenciasDeCalculo">Incluir Incidencias de C&aacute;lculo</cf_translate>
					</label>
				</div>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td><td>&nbsp;</td>
			<td colspan="2" align="left">
				<div style="display:none ;" id="verAgrupar">
					<input name="chkAgrupar" id="chkAgrupar" type="checkbox" checked="checked" onclick="javascript: habilita();">
					<label for="chkAgrupar" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_AgruparPorCentroFuncional">Agrupar por Centro Funcional</cf_translate>
					</label>
				</div>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td><td>&nbsp;</td>
			<td colspan="2" align="left">
				<div style="display:none ;" id="verTipo">
					<input name="Tipo" id="Resumido" type="radio" value="R" disabled>
					<label for="Resumido" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_Resumido">Resumido</cf_translate>
					</label>
					<input name="Tipo" id="Detallado" type="radio" checked="checked" value="D" disabled>
					<label for="Detallado" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_Detallado">Detallado</cf_translate>
					</label>
				</div>
				<div style="display:none ;" id="verAgrupa">
					<input name="Agrupa" id="DiaEmpleado" type="radio" value="D" disabled>
					<label for="DiaEmpleado" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_AgruparDiaEmpleado">Agrupar por D&iacute;a/Empleado</cf_translate>
					</label>
					<input name="Agrupa" id="Empleado" type="radio" checked="checked" value="E" disabled>
					<label for="Empleado" style="font-style:normal; font-variant:normal; font-weight:normal">
						<cf_translate key="LB_AgruparPorEmpleado">Agrupar por Empleado</cf_translate>
					</label>
				</div>
			</td>
			<td>&nbsp;</td>
		</tr>
	
		<!--- Línea No. 6 --->
  		<tr>
    		<td>&nbsp;</td>
    		<td width="16%"  align="right" nowrap>
				<div style="display:none ;" id="verTitDeduc">
					<strong><cf_translate  key="LB_Deduccion">Deducción</cf_translate></strong>
				</div>
				<div style="display:none ;" id="verTitCargas">
					<strong><cf_translate  key="LB_Cargas">Cargas</cf_translate></strong>
				</div>
				<div style="display:none ;" id="verTitIncid">
					<strong><cf_translate  key="LB_Incidencias">Incidencias</cf_translate></strong>
				</div>
				<div style="display:none ;" id="verBlanco">
					<strong>&nbsp;</strong>
				</div>
			</td>
    		<td colspan="2" nowrap>
				<div style="display:none ;" id="verDeduc">
					<cf_rhtipodeduccion form="form1" size= "40">
				</div>
				<div style="display:none ;" id="verCargas">
					<cfoutput>
						<input name="DCdescripcion" disabled type="text" value="" size="40" maxlength="40"  tabindex="1">
					</cfoutput>
					<img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
				</div>
				<div style="display:none ;" id="verIncid">
					<cf_rhCIncidentes ExcluirTipo="3">
				</div>
				<div style="display:none ;" id="verIncidC">
					<cf_rhCIncidentes index="1">
				</div>
			</td>
    		<td>&nbsp;</td>
  		</tr>
		<!--- Línea No. 7 --->  
		<tr>
    		<td>&nbsp;</td>
    		<td width="16%">&nbsp;</td>
    		<td width="9%">&nbsp;</td>
    		<td>&nbsp;</td>
    		<td>&nbsp;</td>
  		</tr>
  		<!--- Línea No. 8 --->
		<tr>
    		<td>&nbsp;</td>
    		<td colspan="3" align="right" valign="middle">
				<div align="center"> 
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Consultar"
						Default="Consultar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Consultar"/>
				
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>	
		
	        		<input type="submit" name="Submit" value="#BTN_Consultar#" onClick="javascript: habilitarValidacion();">&nbsp;
					<input type="button" name="Limpiar" value="#BTN_Limpiar#"  onClick="javascript: limpiar();">
					<input type="hidden" name="ECid" value="<cfif isdefined("form.ECid") and len(trim(#form.ECid#)) neq 0><cfoutput>#form.ECid#</cfoutput></cfif>" >
					<input type="hidden" name="Historico" value="H">
        		</div>
			</td>
    		<td>&nbsp;</td>
  		</tr>
	</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	
	if (document.form1.radRep[0].checked) {
		document.form1.radRep[0].click();	
	}
	else if (document.form1.radRep[1].checked) {
		document.form1.radRep[1].click();	
	}
	else if (document.form1.radRep[2].checked) {
		document.form1.radRep[2].click();	
	}
	else if (document.form1.radRep[3].checked) {
		document.form1.radRep[3].click();
	}

	function validar(){	return true; }
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("/cfmx/rh/nomina/consultas/ConlisCargasEmpleados.cfm?historia=1" ,250,200,650,350);
	}
	function habilita(){
		var resumido = document.getElementById("Resumido");
		var detallado= document.getElementById("Detallado");
		var agrupadoE = document.getElementById("DiaEmpleado");
		var agrupadoD = document.getElementById("Empleado");
		if (document.form1.chkAgrupar.checked){
			resumido.disabled = true;
			detallado.disabled = true;
			agrupadoE.disabled = true;
			agrupadoD.disabled = true;
		}else{
			resumido.disabled = false;
			detallado.disabled = false;
			agrupadoE.disabled = false;
			agrupadoD.disabled = false;
		}
	}


	function limpiar() {
		document.form1.ECid.value = "";
		document.form1.TDid.value = "";
		document.form1.TDcodigo.value = "";
		document.form1.TDdescripcion.value = "";
		document.form1.DCdescripcion.value = "";
		document.form1.Tcodigo.value = "";
	}
	function habilitaInc(){
		var connverTitIncid	 = document.getElementById("verTitIncid");
		var connverIncid	 = document.getElementById("verIncid");
		var connverIncidC	 = document.getElementById("verIncidC");
		if (document.form1.chkICalculo.checked){
			connverIncidC.style.display = "";
			connverIncid.style.display = "none";
		}else{
			connverIncid.style.display = "";
			connverIncidC.style.display = "none";
		}
		
	}
	function cambioTipoRep(obj){
		var connverTitDeduc	 = document.getElementById("verTitDeduc");
		var connverTitCargas = document.getElementById("verTitCargas");
		var connverTitIncid	 = document.getElementById("verTitIncid");
		var connverDeduc	 = document.getElementById("verDeduc");
		var connverCargas	 = document.getElementById("verCargas");
		var connverIncid	 = document.getElementById("verIncid");
		var connverBlanco	 = document.getElementById("verBlanco");
		var connverAgrupa	 = document.getElementById("verAgrupar");
		var connverTipo		 = document.getElementById("verTipo");
		var connveraAgrupado = document.getElementById("verAgrupa");
		var connveraICalculo = document.getElementById("verICalculo");

		switch(obj.value){
			case '1':{
				connverTitDeduc.style.display = "none";
				connverDeduc.style.display = "none";
				connverTitCargas.style.display = "none";
				connverCargas.style.display = "none";
				connverBlanco.style.display = "";
				connverTitIncid.style.display = "none";
				connverIncid.style.display = "none";
				connveraICalculo.style.display = "none";
				connverAgrupa.style.display ="none";
				connverTipo.style.display ="none";
				connveraAgrupado.style.display = "none";
				document.form1.action = "/cfmx/rh/nomina/consultas/PConsultaRCalculoHist.cfm<cfif isdefined("form.RCNid")>?RCNid=<cfoutput>#form.RCNid#</cfoutput></cfif>";
				document.form1.formato.disabled=true;
			}
			break;
			case '2':{				
				connverTitDeduc.style.display = "";
				connverDeduc.style.display = "";
				connverTitCargas.style.display = "none";
				connverCargas.style.display = "none";
				connverBlanco.style.display = "none";
				connverTitIncid.style.display = "none";
				connverIncid.style.display = "none";
				connveraICalculo.style.display = "none";
				connverAgrupa.style.display ="";
				connverTipo.style.display ="";
				connveraAgrupado.style.display = "none";
				document.form1.action = "/cfmx/rh/nomina/consultas/SQL-Deducciones.cfm?desde=rh<cfif isdefined("form.RCNid")>&RCNid=<cfoutput>#form.RCNid#</cfoutput></cfif><cfif isdefined("url.fecha")>&fecha=<cfoutput>#url.fecha#</cfoutput></cfif>";
				document.form1.formato.disabled=false;
			}
			break;
			case '3':{
				connverTitDeduc.style.display = "none";
				connverDeduc.style.display = "none";
				connverTitCargas.style.display = "";
				connverCargas.style.display = "";
				connverBlanco.style.display = "none";
				connverTitIncid.style.display = "none";
				connverIncid.style.display = "none";
				connveraICalculo.style.display = "none";
				connverAgrupa.style.display ="";
				connverTipo.style.display ="";
				connveraAgrupado.style.display = "none";
				document.form1.action = "/cfmx/rh/nomina/consultas/Cargas-SQL.cfm?desde=rh<cfif isdefined("form.RCNid")>&RCNid=<cfoutput>#form.RCNid#</cfoutput></cfif>"; 
				document.form1.formato.disabled=false;
			}
			break;
			case '4':{
				connverTitDeduc.style.display = "none";
				connverDeduc.style.display = "none";
				connverTitCargas.style.display = "none";
				connverCargas.style.display = "none";
				connverBlanco.style.display = "none";
				connverTitIncid.style.display = "";
				connverIncid.style.display = "";
				connveraICalculo.style.display = "";
				connverAgrupa.style.display ="";
				connverTipo.style.display ="";
				connveraAgrupado.style.display = "";
				document.form1.action = "/cfmx/rh/nomina/consultas/Incidencias-SQL.cfm?desde=rh<cfif isdefined("form.RCNid")>&RCNid=<cfoutput>#form.RCNid#</cfoutput></cfif>";
				document.form1.formato.disabled=false;
			}
			break;
		}
	}	
	
</script> 
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function deshabilitarValidacion(){
		objForm.CPid.required = false;
		objForm.CPid.description="Calendario de Pago";		
	}
	function habilitarValidacion(){
		objForm.CPid.required = true;
		objForm.CPid.description="Calendario de Pago";		
	}			

</script>