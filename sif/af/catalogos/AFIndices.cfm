<cfscript>
	//Procesa los datos del filtro cuando vienen en url
	if (isdefined("url.AFIperiodo") and len(trim(url.AFIperiodo))) form.AFIperiodo = url.AFIperiodo;
	if (isdefined("url.ACcodigoCat") and len(trim(url.ACcodigoCat))) form.ACcodigoCat = url.ACcodigoCat;
	if (isdefined("url.ACidClas") and len(trim(url.ACidClas))) form.ACidClas = url.ACidClas;
	if (isdefined("url.AFImes") and len(trim(url.AFImes))) form.AFImes = url.AFImes;
	if (isdefined("url.filter") and len(trim(url.filter))) form.filter = url.filter;
</cfscript>

<script language="javascript" type="text/javascript">
	function init_page(){
			if(document.form1.Categoria2){
				document.form1.Categoria2.focus();				
			}
	}
</script>
<cfparam name="form.AFIperiodo" default="#Year(Now())#">

<cf_templateheader title="Activos Fijos" bodyTag="onload='init_page()'">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de &Iacute;ndices de Revaluaci&oacute;n'>
		<cfinclude template="../../cg/consultas/Funciones.cfm">
			<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfinclude template="formAFIndices.cfm"></td>
				</tr>
				<tr>
					<td><cfinclude template="listaAFIndices.cfm"></td>						
				</tr>
				<tr>
					<td><font color="red">(*) No aplica para filtrar</font></td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

