<cfparam name="url.ck" default="">
<cfparam name="url.dsn" default="">
<cf_templateheader title="Generar triggers para la bit&aacute;cora">
<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfquery datasource="asp" name="lista">
		select PBtabla
		from PBitacora
		where PBtabla in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.ck#" list="yes">)
		order by PBtabla
	</cfquery>

	<cfif Not lista.RecordCount>
		<cfthrow message="No se han especificado las tablas por generar">
	</cfif>

		
<cf_web_portlet_start titulo="Generar triggers">
		

<form action="index.cfm">
  <table border="0" cellpadding="2" cellspacing="0">
    <tr >
      <td colspan="3" valign="top">&nbsp;</td>
    </tr>
    <tr class="tituloListas">
      <td colspan="3" valign="top" class="subTitulo"> <strong>Se han generado los triggers de las siguientes tablas </strong></td>
    </tr>
    <cfoutput query="lista">
      <tr class="lista<cfif CurrentRow mod 2>Par<cfelse>Non</cfif>">
        <td valign="middle">&nbsp;</td>
        <td colspan="2" valign="middle">
		 <label for="ck_#HTMLEditFormat(PBtabla)#">#HTMLEditFormat(PBtabla)#</label></td>
      </tr>
    </cfoutput>
      <tr>
        <td colspan="3" valign="top">&nbsp;</td>
      </tr>
      <tr class="tituloListas">
        <td colspan="3" valign="top" class="subTitulo">Y las siguientes bases de datos </td>
      </tr>
	<cfloop list="#url.dsn#" index="my_dsn">
    <tr>
      <td valign="top">&nbsp;</td>
      <td colspan="2" valign="top"><cfoutput>#HTMLEditFormat(my_dsn)#</cfoutput></td>
    </tr></cfloop>
      <tr>
        <td colspan="3" valign="top">&nbsp;</td>
      </tr>
      <tr class="tituloListas">
        <td colspan="3" valign="top" class="subTitulo">Presione este bot&oacute;n para continuar </td>
      </tr>
    <tr align="right">
      <td colspan="3" valign="top"><input type="submit" value=" Listo " class="BtnNormal">
      </td>
    </tr>
  </table>
  </form>

<cf_web_portlet_end>
<cf_templatefooter>


