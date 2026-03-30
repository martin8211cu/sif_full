<cf_templateheader title="Generar triggers para la bit&aacute;cora">
<cfinclude template="/home/menu/pNavegacion.cfm">

		<cfquery datasource="asp" name="lista">
			select PBtabla
			from PBitacora
			order by PBtabla
		</cfquery>
		
<cf_web_portlet_start titulo="Generar triggers">
		
<form name="form1" method="get" action="selectdb.cfm">
  <table border="0" cellpadding="4" cellspacing="0">
    <tr >
      <td colspan="3" valign="top">&nbsp;</td>
    </tr>
    <tr class="tituloListas">
      <td width="28" valign="top" class="subTitulo"><input type="checkbox" name="checkall" id="checkall" onClick="<cfoutput query="lista">this.form.ck_#HTMLEditFormat(PBtabla)#.checked=</cfoutput>this.checked" checked > </td>
      <td colspan="2" valign="top" class="subTitulo"><strong>Seleccione las tablas para las cuales desea generar los trigger </strong></td>
    </tr>
    <cfoutput query="lista">
      <tr class="lista<cfif CurrentRow mod 2>Par<cfelse>Non</cfif>">
        <td valign="middle"><input type="checkbox" name="ck" id="ck_#HTMLEditFormat(PBtabla)#" value="#HTMLEditFormat(PBtabla)#" checked></td>
        <td width="20" valign="middle">&nbsp;</td>
        <td width="460" valign="middle"><label for="ck_#HTMLEditFormat(PBtabla)#">#HTMLEditFormat(PBtabla)#</label></td>
      </tr>
    </cfoutput>
    <tr>
      <td colspan="3" valign="top">&nbsp;</td>
    </tr>
    <tr align="right">
      <td colspan="3" valign="top">
	  
	  <input type="button" name="edit" value="Lista de tablas" class="BtnAnterior" onClick="location.href='../../catalogos/PBitacora/PBitacora.cfm'">
	  &nbsp;

	  <input type="submit" name="edit" value="Regenerar" class="btnAplicar" onClick="document.form1.action='regenerar.cfm'">
	  &nbsp;
	  
	  <input type="submit" name="Submit" value="Continuar" class="BtnSiguiente"></td>
    </tr>
  </table>
</form>

<cf_web_portlet_end>
<cf_templatefooter>


