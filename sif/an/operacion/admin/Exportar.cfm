



<cf_template template="#session.sitio.template#">

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Exportador"
	Default="Exportador"
	returnvariable="LB_Exportador"/>

    <cf_templatearea name="title">
        <cfoutput>#LB_Exportador#</cfoutput>
	</cf_templatearea>

	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>


		<!--- InstanceBeginEditable name="titulo" --->



<cfquery datasource="#session.dsn#" name="lista">
select DISTINCT AnexoHoja from AnexoCel where AnexoId=#Form.AnexoId#
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
function chkclick(r,ch,valC){
	///alert(r+" - "+ch+" - "+valC)
	document.all["row"+r].className=
		(r % 2 == 0 ? "listaPar":"listaNon") +
		(ch?" selecc":"");
}
function rowclick(r){
	var ch=!document.form1["eiid"+r].checked;
	document.form1["eiid"+r].checked = ch;
	///alert(ch)
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

function validar(){

f = document.form1;

var num=0;
		for(i=0;i<f.eiid.length;i++){

            if(f.eiid[i].checked==true){
             num++;
            }
		}
		if(num>=1){
         document.form1.submit();
		}else{
		alert('Debes elegir al menos una hoja a exportar');
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
							<td width="100%"><a href="/cfmx/sif/an/operacion/admin/index.cfm">
							<cf_translate  key="LB_ListaDeImportaciones">Administración de Anexos </cf_translate>
							</a></td>
						  </tr>
						</table>
					</td>
				</tr>
</table>


<form name="form1" method="post" action="exportar-anexo.cfm">
<table border="0" cellpadding="2" cellspacing="0" id="form1">
<cfoutput>
  <tr>
    <td colspan="6" class="subTitulo"><cf_translate  key="LB_SeleccioneLasDefinicionesQueDeseaExportar">Seleccione las hojas que desea exportar</cf_translate> </td>
  </tr>
  <tr>
    <td colspan="6">&nbsp;</td>
    </tr>
  <tr>
    <td><input type="checkbox" name="e0" id="e0" onClick="checkall(checked)"></td>
    <td><cf_translate  key="LB_Codigo">Hoja</cf_translate></strong></a></td>
    <!--td><cf_translate  key="LB_Modulo">M&oacute;dulo</cf_translate></strong></a></td>
    <td><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></a></td>
    <td><cf_translate  key="LB_Modificado">Modificado</cf_translate></strong></a></td>
    <td><cf_translate  key="LB_Usuario">Usuario</cf_translate></strong></a></td--->
  </tr></cfoutput>
  <cfoutput query="lista">
  <tr class="<cfif lista.CurrentRow mod 2 eq 0>listaPar<cfelse>listaNon</cfif>" id="row#lista.CurrentRow#">
    <td>
      <input type="checkbox" name="eiid" value="#AnexoHoja#" id="eiid#lista.CurrentRow#"
	  	onClick="chkclick(#lista.CurrentRow#,checked,this.value)">
    </td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#AnexoHoja#</td>
    <!---td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#EImodulo#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#HTMLEditFormat( EIdescripcion )#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#LSDateFormat( EImod_fecha , 'dd/mm/yyyy' )#</td>
    <td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#EImod_login#</td--->
  </tr></cfoutput>
<tr>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Exportar"
	Default="Exportar"
	XmlFile="/sif/generales.xml"
	returnvariable="BTN_Exportar"/>

	<td colspan="6" align="center"><input type="submit" class="btnNormal" name="ExportarAmexo" value="<cfoutput>#BTN_Exportar#</cfoutput>" ></td>

<cfoutput>

<input type="hidden" name="AnexoId" id="AnexoId" value="#Form.AnexoId#">

</cfoutput>
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

