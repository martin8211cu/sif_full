<cfquery datasource="asp" name="caches">
	select c.Ccache, e.Enombre
	from Caches c
		join Empresa e
			on e.Cid = c.Cid
	order by c.Ccache, e.Enombre
</cfquery>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
<cfset asp_type = Application.dsinfo.asp.type>

<cf_templateheader title="Crear Vistas"><cf_web_portlet_start titulo="Crear Vistas">
<cfinclude template="/home/menu/pNavegacion.cfm">

<form action="vistas-apply.cfm" method="post" name="form1" id="form1"><br>


<table width="80%"  border="0" cellspacing="0" cellpadding="2" align="center">
  <tr class="subTitulo">
    <td colspan="4" valign="top" class="subTitulo">Seleccione los caches en que desea regenerar las vistas</div></td>
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
<cfoutput query="caches" group="Ccache">
<cfset n=n+1>

	<cfset type = ''>
	<cfif StructKeyExists(Application.dsinfo, Ccache)>
		<cfset type = Application.dsinfo[Ccache].type>
	</cfif>
	
  <tr class="<cfif n mod 2>listaNon<cfelse>listaPar</cfif>">
    <td valign="top">&nbsp;</td>
    <td valign="top"><input onClick="click_uno(this.form)" type="checkbox" name="cache" id="cache_#n#" value="#HTMLEditFormat(Ccache)#" <cfif type neq asp_type>disabled</cfif> ></td>
    <td valign="top"><label for="cache_#n#">#Ccache#<br>(#type#)</label></td>
    <td valign="top"><label for="cache_#n#"><cfset x=0><cfoutput><cfif x>, </cfif><cfset x=1><span style="text-decoration:underline">#Enombre#</span></cfoutput></label></td>
  </tr>
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
    <td><input type="submit" value="Generar"></td>
    <td>&nbsp;</td>
  </tr>
</table>


</form>

<cfoutput>
<script type="text/javascript">
<!--
	function click_todos(f,new_value){
		for (i=1;i<=#n#;i++){
			if (f['cache_'+i].checked != new_value)
				f['cache_'+i].checked = new_value;
		}
	}
	function click_uno(f){
		var new_value = true;
		for (i=1;i<=#n#;i++){
			if (!f['cache_'+i].checked){
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

<cf_web_portlet_end><cf_templatefooter>