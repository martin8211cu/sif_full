<!--- <cf_dump var="#form#"> --->
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
<cfif isdefined('url.Tcodigo') and not isdefined('form.Tcodigo')>
	<cfset form.Tcodigo = url.Tcodigo>
</cfif>
<cfif isdefined('url.fecha') and not isdefined('form.fecha')>
	<cfset form.fecha = url.fecha>
</cfif>
<cfif isDefined("Form.SiImprime")>
	<cfset Form.SiImprime = Url.SiImprime>
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

<!--- Pasa algunos valores de la consulta al Form para poder utilizarlos posteriormente --->
<!--  Rodolfo Jiménez Jara, SOIN, Costa Rica, 21 Nov 2003 -->
<cfif rsRelacionCalculo.RecordCount gt 0>
	<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
	<cfset Form.RCdesde = LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')>
	<cfset Form.RChasta = LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')>
	<cfset Form.RCestado = rsRelacionCalculo.RCestado>
	<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
</cfif>

<cfset regresar = "/cfmx/rh/nomina/operacion/ResultadoCalculo-lista.cfm?RCNid="&form.RCNid>
<style type="text/css">
.chk {  
 background: buttonface; 
 padding: 1px;
 color: buttontext;
}
</style>

<cfquery name="rsCantModificados" datasource="#Session.DSN#">
	select 1 from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and SEcalculado <> 1
</cfquery>
<cfset pintarReporte = true>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td><cfinclude template="portlets/pNavegacion.cfm"></td></tr>
</table>
<cfinclude template="portlets/pRelacionCalculo.cfm">
<cfoutput>
<form name="form1" method="get" action="/cfmx/rh/nomina/consultas/PConsultaRCalculo.cfm?Tcodigo=#Form.RCTcodigo#&fecha=#Form.RCdesde#&RCNid=#Form.RCNid#">
<table width="89%" border="0" align="center" cellpadding="1" cellspacing="2">
	<tr>
		<td>&nbsp;</td>
		<td width="8%">&nbsp;</td>
		<td width="12%">&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr align="center">
		<td>&nbsp;</td>
		<td colspan="3"><font size="3"><strong><cf_translate key="LB_Reportes">Reportes</cf_translate></strong></font></td>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td width="24%">&nbsp;</td>
		<td colspan="3" align="center" valign="middle" nowrap>
			<input name="radRep"  id="radRep0" type="radio" tabindex="1"  onClick="javascript: cambioTipoRep(this);" value="1" checked>      
			<label for="radRep0"><font size="2"><cf_translate key="LB_Relacion_en_Proceso">Relaci&oacute;n en Proceso</cf_translate></font></label>
			
			<input type="radio" id="radRep1" name="radRep" value="2" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep1"><font size="2"><cf_translate key="LB_Deducciones">Deducciones</cf_translate></font></label>
			
			<input type="radio" id="radRep2" value="3" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep2"><font size="2"><cf_translate key="LB_Cargas_Patronales">Cargas Patronales</cf_translate></font></label>
			
			<input type="radio" id="radRep3" value="4" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep3"><font size="2"><cf_translate key="LB_Incidencias">Incidencias</cf_translate></font></label>
		</td>
		<td width="28%">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td width="8%">&nbsp;</td>
		<td width="12%">&nbsp;</td>
		<td width="28%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td width="8%"  align="right" nowrap>
			<div align="right"><strong><cf_translate key="LB_Formato">Formato:</cf_translate></strong>&nbsp;</div>
		</td>
		<td colspan="2" align="left">
			<select name="formato"  tabindex="1">
				<option value="flashpaper" ><cf_translate key="LB_FlashPaper" XmlFile="/rh/generales.xml">Flashpaper</cf_translate></option>
				<option value="pdf"><cf_translate key="LB_Adobe_PDF" XmlFile="/rh/generales.xml">Adobe PDF</cf_translate></option>
				<option value="Excel">Microsoft Excel</option>
			</select>     
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
	<tr>
		<td>&nbsp;</td>
		<td width="8%"  align="right" nowrap>
			<div style="display:none ;" id="verTitDeduc"><strong><cf_translate key="LB_Deduccion">Deducción</cf_translate></strong></div>
			<div style="display:none ;" id="verTitCargas"><strong><cf_translate key="LB_Cargas">Cargas</cf_translate></strong></div>
			<div style="display:none ;" id="verTitIncid"><strong><cf_translate key="LB_Incidencias">Incidencias</cf_translate></strong></div>
			<div style="display:none ;" id="verBlanco"><strong>&nbsp;</strong></div>
		</td>
		<td colspan="2" nowrap>
			<div style="display:none ;" id="verDeduc"><cf_rhtipodeduccion form="form1" size= "40" tabindex="1"></div>
			<div style="display:none ;" id="verIncid">
				<cf_rhCIncidentes ExcluirTipo="3">
			</div>
			<div style="display:none ;" id="verIncidC">
				<cf_rhCIncidentes index="1">
			</div>
			<div style="display:none ;" id="verCargas">
				<input name="DCdescripcion" disabled type="text" value="" size="40" maxlength="40"  tabindex="1">
				<img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
			</div>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td width="8%">&nbsp;</td>
		<td width="12%">&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3" align="right" valign="middle"><div align="center"> 
			<input type="submit" name="Submit" value="#BTN_Consultar#" tabindex="1">&nbsp;
			<input type="button" name="Limpiar" value="#BTN_Limpiar#"  tabindex="1" onClick="javascript: limpiar();">
			<input type="hidden" name="RCNid" value="<cfif isdefined("form.RCNid") and len(trim(#form.RCNid#)) neq 0><cfoutput>#form.RCNid#</cfoutput></cfif>">
			<input type="hidden" name="Tcodigo" value="<cfif isdefined("form.Tcodigo") and len(trim(#form.Tcodigo#)) neq 0><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
			<input type="hidden" name="fecha" value="<cfif isdefined("form.fecha") and len(trim(#form.fecha#)) neq 0><cfoutput>#form.fecha#</cfoutput></cfif>">
			<input type="hidden" name="ECid" value="<cfif isdefined("form.ECid") and len(trim(#form.ECid#)) neq 0><cfoutput>#form.ECid#</cfoutput></cfif>" >
		</div></td>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">
	if (document.form1.radRep0.checked) {
		document.form1.radRep0.click();	
	}
	else if (document.form1.radRep1.checked) {
		document.form1.radRep1.click();	
	}
	else if (document.form1.radRep2.checked) {
		document.form1.radRep2.click();	
	}
	else if (document.form1.radRep3.checked) {
		document.form1.radRep3.click();
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


	function validar(){	return true; }
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("/cfmx/rh/nomina/consultas/ConlisCargasEmpleados.cfm" ,250,200,650,350);
	}
	function limpiar() {
		document.form1.ECid.value = "";
		document.form1.DCdescripcion.value = "";
		document.form1.TDid.value = "";
		document.form1.TDcodigo.value = "";
		document.form1.TDdescripcion.value = "";
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
		var connverTitDeduc	= document.getElementById("verTitDeduc");
		var connverTitCargas= document.getElementById("verTitCargas");
		var connverTitIncid	= document.getElementById("verTitIncid");
		var connverDeduc	= document.getElementById("verDeduc");
		var connverCargas	= document.getElementById("verCargas");
		var connverIncid	= document.getElementById("verIncid");		
		var connverBlanco	= document.getElementById("verBlanco");
		var connverAgrupa	= document.getElementById("verAgrupar");
		var connverTipo		= document.getElementById("verTipo");
		var connveraAgrupado= document.getElementById("verAgrupa");
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
				document.form1.action = "/cfmx/rh/nomina/consultas/PConsultaRCalculo.cfm?Tcodigo=<cfoutput>#Form.RCTcodigo#</cfoutput>&fecha=<cfoutput>#Form.RCdesde#</cfoutput>&RCNid=<cfoutput>#Form.RCNid#</cfoutput>";
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
				document.form1.action = "/cfmx/rh/nomina/consultas/SQL-Deducciones.cfm?desde=rh&RCNid=<cfoutput>#form.RCNid#</cfoutput>";
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
				document.form1.action = "/cfmx/rh/nomina/consultas/Cargas-SQL.cfm?desde=rh&RCNid=<cfoutput>#form.RCNid#</cfoutput>";
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
				document.form1.action = "/cfmx/rh/nomina/consultas/Incidencias-SQL.cfm?desde=rh&RCNid=<cfoutput>#form.RCNid#</cfoutput>";
				document.form1.formato.disabled=false;
			}
			break;
		}
		
	}	


</script> 