<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
<cfparam name="url.o" default="1">
<cfparam name="url.o2" default="">
<cfquery datasource="sifcontrol" name="lista">
	select 
	EIcodigo,EImodulo, EIdescripcion,EImod_fecha,EImod_login,EIid
	from EImportador
	where not EIcodigo like '%.[0-9][0-9][0-9]'
	order by <cfif url.o IS 1>EIcodigo
	     <cfelseif url.o IS 2>EImodulo
	     <cfelseif url.o IS 3>upper(EIdescripcion)
	     <cfelseif url.o IS 4>EImod_fecha
	     <cfelseif url.o IS 5>EImod_login
	     <cfelse>EIcodigo
	</cfif> <cfif url.o2 IS 1>desc</cfif>
</cfquery>

      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">&nbsp;</td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5"><cf_translate  key="LB_Importador">Importador</cf_translate></font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap>&nbsp; </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Exportar"
		Default="Exportar"
		returnvariable="LB_Exportar"/>					
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Exportar#">
	
<style type="text/css">
.selecc{background-color:#00CCFF;}
</style>
<script type="text/javascript">
function chkclick(r,ch){
	document.all["row"+r].className=
		(r % 2 == 0 ? "listaPar":"listaNon") + 
		(ch?" selecc":"");
}
function rowclick(r){
	var ch=!document.form1["eiid"+r].checked;
	document.form1["eiid"+r].checked = ch;
	chkclick(r,ch);
}
function checkall(value){
	f = document.form1;
	if (f.eiid.length) {
		for(i=0;i<f.eiid.length;i++){
			f.eiid[i].checked=value;
			chkclick(i+1,value)
		}
	} else {
		f.eiid.checked = value;
		chkclick(1,value)
	}
}
</script>
<cfscript>
function lk(n){
	var s = "?o=" & n;
	if (url.o2 neq 1 and url.o is n) {
		s = s & "&o2=1";
	}
	return s;
}
function iu(n){
	if (url.o neq n) {
		return "";
	} else if (url.o2 eq 1) {
		return "&uarr;&nbsp;";
	} else {
		return "&darr;&nbsp;";
	}
}
</cfscript>
<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
						  <tr align="left"> 
							<td width="100%"><a href="/cfmx/hosting/tratado/importar/ListaImportador.cfm">
							<cf_translate  key="LB_ListaDeImportaciones">Lista de Importaciones</cf_translate>
							</a></td>
						  </tr>
						</table>
					</td>
				</tr>
</table>				
				<form name="form1" method="post" action="ExportarWDDX.cfm">
<table border="0" cellpadding="2" cellspacing="0" id="form1">
<cfoutput>
  <tr>
    <td colspan="6" class="subTitulo"><cf_translate  key="LB_SeleccioneLasDefinicionesQueDeseaExportar">Seleccione las definiciones que desea exportar</cf_translate> </td>
  </tr>
  <tr>
    <td colspan="6">&nbsp;</td>
    </tr>
  <tr>
    <td><input type="checkbox" name="e0" id="e0" onClick="checkall(checked)"></td>
    <td><a href="#lk(1)#">#iu(1)#<strong><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></strong></a></td>
    <td><a href="#lk(2)#">#iu(2)#<strong><cf_translate  key="LB_Modulo">M&oacute;dulo</cf_translate></strong></a></td>
    <td><a href="#lk(3)#">#iu(3)#<strong><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></a></td>
    <td><a href="#lk(4)#">#iu(4)#<strong><cf_translate  key="LB_Modificado">Modificado</cf_translate></strong></a></td>
    <td><a href="#lk(5)#">#iu(5)#<strong><cf_translate  key="LB_Usuario">Usuario</cf_translate></strong></a></td>
  </tr></cfoutput>
  <cfoutput query="lista">
  <tr class="<cfif lista.CurrentRow mod 2 eq 0>listaPar<cfelse>listaNon</cfif>" id="row#lista.CurrentRow#">
    <td>
      <input type="checkbox" name="eiid" value="#EIid#" id="eiid#lista.CurrentRow#" 
	  	onClick="chkclick(#lista.CurrentRow#,checked)">
    </td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#EIcodigo#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#EImodulo#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#HTMLEditFormat( EIdescripcion )#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#LSDateFormat( EImod_fecha , 'dd/mm/yyyy' )#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#EImod_login#</td>
  </tr></cfoutput>
<tr>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Exportar"
	Default="Exportar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BTN_Exportar"/>    
	
	<td colspan="6" align="center"><input type="submit" name="Submit" value="<cfoutput>#BTN_Exportar#</cfoutput>"></td>
    </tr>
</table>
</form>

	
		<cf_web_portlet_end>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->