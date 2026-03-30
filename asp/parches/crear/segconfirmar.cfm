<cf_templateheader title="Confirmar archivos">
<cfinclude template="mapa.cfm">
<h1>Confirmar seguridad</h1>

<cfoutput>
<cfparam name="session.parche.seg_file" default="">
<p>
	Se han generado los archivos framework-# HTMLEditFormat( session.parche.seg_file ) #.sql en el parche, para cada
	tipo de base de datos soportado.</p><p>
	Estos archivos contienen la información necesaria para la actualización de
	la seguridad.
</p>

<form id="form1" name="form1" method="post" action="segconfirmar-control.cfm"><table border="0" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" align="right"><input name="buscar" type="submit" id="buscar" value="Agregar más..." class="btnAnterior" />
      <input name="continuar" type="submit" id="continuar" value="Continuar" class="btnSiguiente" /></td>
    </tr>
  
  
<cfif ArrayLen(session.parche.errores)>
<cfinclude template="lista-errores.cfm">
</cfif>
  
</table>
</form></cfoutput>
<cf_templatefooter>
