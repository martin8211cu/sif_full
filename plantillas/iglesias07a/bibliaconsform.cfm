<cfinclude template="pNavegacion.cfm">
<style type="text/css">
	.DocsFrame {
	  visibility: hidden;
	}
.style2 {
	font-size: 18px;
	color: #695E3C;
	font-weight: bold;
}
</style>
<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.4" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="form" method="post" action="bibliaconsSQL.cfm">
<table width="400"  border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td colspan="9"><div align="center" class="style2" style="font-family: Verdana, Arial, Helvetica, sans-serif; color: #990000; font-weight: bold;"></div></td>
  </tr>
  <tr>
    <td width="2%">&nbsp;</td>
    <td width="5%">&nbsp;</td>
    <td width="16%">&nbsp;</td>
    <td colspan="6">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap><span style="font-family: Verdana, Arial, Helvetica, sans-serif; color: #990000;">Libro: </span></td>
    <td>
      <select name="Libro">
  		<optgroup label="Antiguo Testamento" style="font-weight:bold:;background-color:#F9EED1">
        <option value="1">G&eacute;nesis</option>
	  	<option value="2">Éxodo</option>
		<option value="3">Levítico</option>
		<option value="4">Números</option>
		<option value="5">Deuteronomio</option>
		<option value="6">Josué</option>
		<option value="7">Jueces</option>
		<option value="8">Rut</option>
		<option value="9">I  Samuel</option>
		<option value="10">II Samuel</option>
		<option value="11">I  Reyes</option>
		<option value="12">II Reyes</option>
		<option value="13">I Crónicas</option>
		<option value="14">II Crónicas</option>
		<option value="15">Esdras</option>
		<option value="16">Nehemías</option>
		<option value="17">Ester</option>
		<option value="18">Job</option>
		<option value="19">Salmos</option>
		<option value="20">Proverbios</option>
		<option value="21">Eclesiastés</option>
		<option value="22">Cantares</option>
		<option value="23">Isaías</option>
		<option value="24">Jeremías</option>
		<option value="25">Lamentaciones</option>
		<option value="26">Ezequiel</option>
		<option value="27">Daniel</option>
		<option value="28">Oseas</option>
		<option value="29">Joel</option>
		<option value="30">Amós</option>
		<option value="31">Abdías</option>
		<option value="32">Jonás</option>
		<option value="33">Miqueas</option>
		<option value="34">Nahúm</option>
		<option value="35">Habacuc</option>
		<option value="36">Sofonías</option>
		<option value="37">Hageo</option>
		<option value="38">Zacarías</option>
		<option value="39">Malaquías</option>
		</optgroup>
		<optgroup label="Nuevo Testamento" style="font-weight:bold:;background-color:#EAD18A">
		<option value="40">Mateo</option>
		<option value="41">Marcos</option>
		<option value="42">Lucas</option>
		<option value="43">Juan</option>
		<option value="44">Hechos</option>
		<option value="45">Romanos</option>
		<option value="46">I  Corintios</option>
		<option value="47">II Corintios</option>
		<option value="48">Gálatas</option>
		<option value="49">Efesios</option>
		<option value="50">Filipenses</option>
		<option value="51">Colosenses</option>
		<option value="52">I  Tesalonicenses</option>
		<option value="53">II Tesalonicenses</option>
		<option value="54">I  Timoteo</option>
		<option value="55">II Timoteo</option>
		<option value="56">Tito</option>
		<option value="57">Filemón</option>
		<option value="58">Hebreos</option>
		<option value="59">Santiago</option>
		<option value="60">I  Pedro</option>
		<option value="61">II Pedro</option>
		<option value="62">I   Juan</option>
		<option value="63">II  Juan</option>
		<option value="64">III Juan</option>
		<option value="65">Judas</option>
		<option value="66">Apocalipsis</option>
		</optgroup>
      </select>    </td>
    <td width="7%">&nbsp;</td>
    <td width="7%"><span style="font-family: Verdana, Arial, Helvetica, sans-serif; color: #990000;">Cap&iacute;tulo:</span></td>
    <td width="35%"><input type="text" name="Capitulo" onKeyPress="return acceptNum(event)" style="text-align:right" ></td>
    <td width="7%">&nbsp;</td>
    <td width="35%"><span style="font-family: Verdana, Arial, Helvetica, sans-serif; color: #990000;">Vers&iacute;culo:</span></td>
    <td width="70%"><input type="text" name="Versiculo" onKeyPress="return acceptNum(event)" style="text-align:right" ></td>
    <td width="70%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="6">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="9"><div align="center">
      <!--- <input type="Button" name="Consultar" value="Consultar" onClick="javascript:TraeTexto(document.form.Libro.value,1,1);"> --->
	  <input type="submit" name="Consultar" value="Consultar">
      <input type="Reset" name="Limpiar" value="Restaurar">
    </div></td>
  </tr>
</table>
<br>
<table width="100%">
<tr>
<td width="100%"><!--- <iframe name="frBusqueda" width="800" height="600" src="" frameborder="0"></iframe>---></td>
</tr>
</table>
<script language="javascript1.4" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
	objForm.Capitulo.required = false;
	objForm.Versiculo.required = false;
	objForm.Capitulo.description = "Capitulo";
	objForm.Versiculo.description = "Versiculo";
	objForm.Capitulo.validateNumeric('El Capítulo debe ser Numérico.');
	objForm.Versiculo.validateNumeric('El Versículo debe ser Numérico.');
</script>
