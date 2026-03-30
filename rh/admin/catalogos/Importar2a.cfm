<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Importador" Default="Importador" returnvariable="LB_Importador" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<style type="text/css">.selecc{background-color:#00CCFF;}</style>
<cfif not IsDefined("session.importar_enc")><cflocation url="ImportarRep.cfm"></cfif>
<cfquery  dbtype="query" name="lista">
	select RHRPTNid ,RHRPTNcodigo, RHRPTNdescripcion, RHRPTNlineas,BMUsucodigo, fechaalta
	from session.importar_enc
	order by RHRPTNid  
</cfquery>
<cf_templateheader title="#LB_Importador#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#session.preferences.skin#" >

		<form name="form1" method="post" action="Importar3.cfm">
			<table width="50%" border="0" align="center" id="form1">
				<cfoutput>
					<tr><td colspan="6" class="subTitulo">Seleccione las definiciones que desea importar</td></tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr>
						<td><input type="checkbox" name="e0" id="e0" onClick="checkall(checked)"></td>
						<td><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
						<td><strong><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
						<td><strong><cf_translate  key="LB_Modificado">Modificado</cf_translate></strong></a></td>
					</tr>
				</cfoutput>
				<cfoutput query="lista">
					<tr class="<cfif lista.CurrentRow mod 2 eq 0>listaPar<cfelse>listaNon</cfif>" id="row#lista.CurrentRow#">
						<td><input type="checkbox" name="RHRPTNid" value="#RHRPTNid#" id="RHRPTNid#lista.CurrentRow#"onClick="chkclick(#lista.CurrentRow#,checked)"></td>
						<td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#RHRPTNcodigo#</td>
						<td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#HTMLEditFormat( RHRPTNdescripcion )#</td>
						<td onclick="rowclick(#lista.CurrentRow#)" style="cursor:default">#LSDateFormat( fechaalta , 'dd/mm/yyyy' )#</td>
					</tr>
				</cfoutput>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6" align="center"><cf_botones values="Importar"></td></tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript">
function chkclick(r,ch){
	document.all["row"+r].className=
		(r % 2 == 0 ? "listaPar":"listaNon") + 
		(ch?" selecc":"");
}
function rowclick(r){
	var ch=!document.form1["RHRPTNid"+r].checked;
	document.form1["RHRPTNid"+r].checked = ch;
	chkclick(r,ch);
}
function checkall(value){
	f = document.form1;
	if (f.RHRPTNid.length) {
		for(i=0;i<f.RHRPTNid.length;i++){
			f.RHRPTNid[i].checked=value;
			chkclick(i+1,value)
		}
	} else {
		f.RHRPTNid.checked = value;
		chkclick(1,value)
	}
}
</script>
