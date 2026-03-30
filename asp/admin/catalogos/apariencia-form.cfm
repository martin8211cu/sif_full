<cfparam name="url.id_apariencia" default="">
<cfparam name="form.id_apariencia" default="#url.id_apariencia#">
<cfquery name="data" datasource="asp">
	select id_apariencia,descripcion,template,home,login,css,footer from MSApariencia
	where id_apariencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_apariencia#" null="#Len(form.id_apariencia) EQ 0#">
</cfquery>
<form action="apariencia-sql.cfm" method="post" name="form1">
<cfoutput>
<table width="419" border="0">
  <tr>
    <td colspan="2" class="subTitulo">
          <cfif Len(form.id_apariencia) eq 0>
			Nueva Plantilla
			  <cfelse>
			Editar Plantilla 
          </cfif>        </td>
      </tr>
  <tr>
    <td width="14">&nbsp;</td>
    <td width="395">Descripci&oacute;n
      <input type="hidden" name="id_apariencia" value="#data.id_apariencia#"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>      <input name="descripcion" id="descripcion" type="text" value="#data.descripcion#" size="60" onFocus="this.select()"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Template</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="template" id="template" type="text" value="#data.template#" size="60" onBlur="javascript:pagina(this);" onFocus="this.select()">      <a tabindex="-1" href="javascript:conlisFiles(document.form1.template)" ><img width="16" height="16" src="foldericon.gif" border="0"></a></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Home (default) </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="home" id="home" type="text" value="#data.home#" size="60" onBlur="javascript:pagina(this);" onFocus="this.select()">      <a tabindex="-1" href="javascript:conlisFiles(document.form1.home)" ><img width="16" height="16" src="foldericon.gif" border="0"></a></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Login (default) </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="login" id="login" type="text" value="#data.login#" size="60" onBlur="javascript:pagina(this);" onFocus="this.select()">      <a tabindex="-1" href="javascript:conlisFiles(document.form1.login)" ><img width="16" height="16" src="foldericon.gif" border="0"></a></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>CSS (default) </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="css" id="css" type="text" value="#data.css#" size="60" onBlur="javascript:pagina(this);" onFocus="this.select()">      <a tabindex="-1" href="javascript:conlisFiles(document.form1.css)" ><img width="16" height="16" src="foldericon.gif" border="0"></a></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Footer (default) </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="Footer" id="Footer" type="text" value="#data.Footer#" size="60" onBlur="javascript:pagina(this);" onFocus="this.select()">      <a tabindex="-1" href="javascript:conlisFiles(document.form1.Footer)" ><img width="16" height="16" src="foldericon.gif" border="0"></a></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/portlets/pBotones.cfm">
	</td>
    </tr>
</table>
</cfoutput>
<script type="text/javascript">
<!--
	popUpWin = 0;
	conlis_input = 0;
	function closePopup() {
		if (popUpWin && !popUpWin.closed ) {
			popUpWin.close();
			popUpWin = null;
		}
	}
	
	function conlisFiles(text_input){
		closePopup();
		popUpWin = window.open('../../portal/catalogos/files.cfm?p='+escape(text_input.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		conlis_input = text_input;
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelect(filename){
		closePopup();
		window.focus();
		if (conlis_input) {
			conlis_input.value = filename;
			conlis_input.focus();
			conlis_input = 0;
		}
	}
	
	function pagina(obj){
		obj.value = obj.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'').
				replace(/^\s+/,'').
				replace(/\s+$/,'');
		if (obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}
//-->
</script>

</form>