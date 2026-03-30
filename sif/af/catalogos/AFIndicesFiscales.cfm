<cfscript>
	//Procesa los datos del filtro cuando vienen en url
	if (isdefined("url.AFFperiodo") and len(trim(url.AFFperiodo))) form.AFFperiodo = url.AFFperiodo;
	if (isdefined("url.AFFMes") and len(trim(url.AFFMes))) form.AFFMes = url.AFFMes;
	if (isdefined("url.filter") and len(trim(url.filter))) form.filter = url.filter;
</cfscript>

<script language="javascript" type="text/javascript">
	function init_page(){
			if(document.form1.Categoria2){
				document.form1.Categoria2.focus();				
			}
	}
</script>
<cfparam name="form.AFFperiodo" default="#Year(Now())#">

<cf_templateheader title="Activos Fijos" bodyTag="onload='init_page()'">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de &Iacute;ndices de Depreciaci&oacute;n'>
		<cfinclude template="../../cg/consultas/Funciones.cfm">
			<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfinclude template="AFIndicesFiscales-form.cfm"></td>
				</tr>
				<tr>
					<td><cfinclude template="AFIndicesFiscales-lista.cfm"></td>						
				</tr>
				<tr>
					<td><font color="red">(*) No aplica para filtrar</font></td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

