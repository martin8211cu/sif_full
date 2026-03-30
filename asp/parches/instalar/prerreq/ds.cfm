<cfparam name="session.instala.ds" default="">
<cfquery datasource="asp" name="dss">
	select c.Ccache, e.Enombre
	from Caches c
		join Empresa e
			on e.Cid = c.Cid
	order by c.Ccache, e.Enombre
</cfquery>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
<cfset asp_type = Application.dsinfo.asp.type>


<cf_templateheader title="Seleccionar datasources">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Seleccionar datasources">
<cfinclude template="/home/menu/pNavegacion.cfm">

<form action="ds-control.cfm" method="post" name="form1" id="form1"><br>


<table width="80%"  border="0" cellspacing="0" cellpadding="2" align="center">
  <tr class="subTitulo">
    <td colspan="4" valign="top" class="subTitulo">Seleccione los datasources en que desea instalar el parche</div></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr class="tituloListas">
    <td valign="middle">&nbsp;</td>
    <td valign="middle"><input onClick="click_todos(this.form,this.checked)" type="checkbox" name="todos" id="todos" value=""></td>
    <td valign="middle"><label for="todos"><strong>Nombre</strong></label></td>
    <td valign="middle"><label for="todos"><strong>Empresas relacionadas </strong></label></td>
  </tr>
<cfset n=0>
<cfoutput query="dss" group="Ccache">

	<cfset type = ''>
	<cfif StructKeyExists(Application.dsinfo, Ccache)>
		<cfset type = Application.dsinfo[Ccache].type>
		<cfset n=n+1>
		  <tr class="<cfif n mod 2>listaNon<cfelse>listaPar</cfif>">
			<td valign="top">&nbsp;</td>
			<td valign="top"><input onClick="click_uno(this.form)" type="checkbox" name="ds" id="ds_#n#" value="#HTMLEditFormat(Ccache)#" <cfif type neq asp_type>disabled<cfelseif ListFind(session.instala.ds, Ccache) Or (Len(session.instala.ds) EQ 0)>checked</cfif> ></td>
			<td valign="top"><label for="ds_#n#"># HTMLEditFormat( Ccache)#<br>(#HTMLEditFormat(type)#)</label></td>
			<td valign="top"><label for="ds_#n#"><cfset x=0><cfoutput><cfif x>, </cfif><cfset x=1><span style="text-decoration:underline">#Enombre#</span></cfoutput></label></td>
		  </tr>
	</cfif>
</cfoutput>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" align="right"><input type="submit" value="Seleccionar" name="aplicar" class="btnAplicar"/>
	<input type="submit" value="Continuar" name="siguiente" class="btnSiguiente" />	</td>
    </tr>
</table>


</form>

<cfoutput>
<script type="text/javascript">
<!--
	function click_todos(f,new_value){
		for (i=1;i<=#n#;i++){
			if (f['ds_'+i].checked != new_value)
				f['ds_'+i].checked = new_value;
		}
	}
	function click_uno(f){
		var new_value = true;
		for (i=1;i<=#n#;i++){
			if (!f['ds_'+i].checked){
				new_value=false;
				break;
			};
		}
		if (f.todos.checked != new_value)
			f.todos.checked = new_value;
	}
//-->
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>