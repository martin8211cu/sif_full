<cfparam name="url.ck" default="">
<cfquery datasource="asp" name="caches">
	select distinct c.Ccache as cache
	from Caches c
		join Empresa e
			on c.Cid = e.Cid
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by cache
</cfquery>

<cfparam name="url.dsn" default="#caches.cache#">
<cf_templateheader title="Generar triggers para la bit&aacute;cora">
<cfinclude template="/home/menu/pNavegacion.cfm">
		
<cf_web_portlet_start titulo="Generar triggers">
		
<form name="form1" method="get" action="confirmar.cfm">
<cfset dbtype = Application.dsinfo.aspmonitor.type>
<cfoutput>
<input type="hidden" name="ck"  value="#HTMLEditFormat(url.ck)#"></cfoutput>
  <table width="600" border="0" cellpadding="4" cellspacing="0">
    <tr >
      <td colspan="4" valign="top">&nbsp;</td>
    </tr>
    <tr class="tituloListas">
      <td width="28" valign="top" class="subTitulo"><input type="checkbox" name="checkall" id="checkall" onClick="<cfoutput query="caches">this.form.dsn_#HTMLEditFormat(cache)#.checked=</cfoutput>this.checked" checked > </td>
      <td colspan="3" valign="top" class="subTitulo"><strong>Seleccione las bases de datos para las cuales desea generar los trigger </strong></td>
    </tr>
    <cfoutput query="caches">
      <tr class="lista<cfif CurrentRow mod 2>Par<cfelse>Non</cfif>" <cfif Application.dsinfo[cache].type neq dbtype>style="color:##999999;"</cfif>>
        <td valign="middle"><input type="checkbox" name="dsn" id="dsn_#HTMLEditFormat(cache)#" value="#HTMLEditFormat(cache)#" checked <cfif Application.dsinfo[cache].type neq dbtype>disabled</cfif>></td>
        <td width="20" valign="middle">&nbsp;</td>
        <td width="128" valign="middle"><label for="dsn_#HTMLEditFormat(cache)#">#HTMLEditFormat(cache)#</label></td>
        <td width="392" valign="middle"><label for="dsn_#HTMLEditFormat(cache)#">#HTMLEditFormat(Application.dsinfo[cache].type)#</label></td>
      </tr>
    </cfoutput>
    <tr>
      <td colspan="4" valign="top">&nbsp;</td>
    </tr>
    <tr align="right">
      <td colspan="4" valign="top"><input type="submit" name="Submit" class="BtnSiguiente" value="Continuar"></td>
    </tr>
  </table>
</form>

<cf_web_portlet_end>
<cf_templatefooter>


