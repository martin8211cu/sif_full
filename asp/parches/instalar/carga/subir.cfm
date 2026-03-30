<cf_templateheader title="Cargar JAR">
<cfinclude template="../mapa.cfm">
<cfparam name="url.jarfile" default="">
<cfparam name="url.existe" default="0">
<h1>Seleccionar archivos SQL</h1>
<p>
	Seleccione el parche que desea ejecutar
</p>
<cf_web_portlet_start titulo="Cargar JAR">

<form enctype="multipart/form-data" action="subir-control.cfm" method="post">

<table width="462" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="176">&nbsp;</td>
    <td width="278">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2">Indique cuál archivo corresponde al parche que desea instalar 
	<cfif url.existe eq 1>
	  <div style="color:red;font-weight:bold">
	El parche especificado ya había sido cargado</div>
	</cfif>
	</td>
    </tr>
  <tr>
    <td><label for="jarfile">Archivo JAR</label> </td>
    <td align="right">
	<cfoutput>
	<input name="jarfile" type="file" id="jarfile" size="50" value="# HTMLEditFormat( url.jarfile)#" /></cfoutput></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td> <input type="checkbox" id="nameconflict" name="nameconflict" value="overwrite" /><label for="nameconflict">Sobreescribir el parche existente</label> </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" align="right"><input name="subir" type="submit" id="subir" value="Cargar archivo" class="btnSiguiente" /></td>
    </tr>
</table>


</form>

<cf_web_portlet_end>
<cf_templatefooter>