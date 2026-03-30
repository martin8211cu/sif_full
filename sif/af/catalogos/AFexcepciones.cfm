<cf_templateheader title="Activos Fijos" bodyTag="onload='init_page()'">
	<table width="100%"  border="1" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top" nowrap>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Excepciones de Revaluaci&oacute;n'>
				<cfinclude template="../../cg/consultas/Funciones.cfm">
				<cfscript>
					//Procesa los datos del filtro cuando vienen en url
					if (isdefined("url.AFIperiodo") and len(trim(url.AFIperiodo))) form.AFIperiodo = url.AFIperiodo;
					if (isdefined("url.ACcodigoCat") and len(trim(url.ACcodigoCat))) form.ACcodigoCat = url.ACcodigoCat;
					if (isdefined("url.ACidClas") and len(trim(url.ACidClas))) form.ACidClas = url.ACidClas;
					if (isdefined("url.AFImes") and len(trim(url.AFImes))) form.AFImes = url.AFImes;
					if (isdefined("url.Ocodigo") and len(trim(url.Ocodigo))) form.Ocodigo = url.Ocodigo;
					if (isdefined("url.filter") and len(trim(url.filter))) form.filter = url.filter;
					
				</cfscript>
				<cfparam name="form.AFIperiodo" default="#Year(Now())#">
				<!----<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
					<tr><td><cfinclude template="filtroAFIndices.cfm"></td></tr>
				</table>---->
				<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
					<tr>
						<td>
							<cfinclude template="formAFexcepciones.cfm">
						</td>
					</tr>
				</table>
				<table width="100%" align="center"  border="0" cellspacing="1" cellpadding="1">
					<tr>
						<td>
							<cfinclude template="listaAFexcepciones.cfm">
						</td>						
					</tr>
					<tr>
						<td><font color="red">(*) No aplica para filtrar</font></td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</td>	
	  </tr>
	</table>
<script language="javascript" type="text/javascript">
	function init_page(){
			if(document.form1.Categoria2){
				document.form1.Categoria2.focus();				
			}
	}
</script>

<cf_templatefooter>

