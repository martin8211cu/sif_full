<cfquery name="rsGrupo" datasource="#Session.DSN#">
	Select RHGMcodigo,Descripcion
	from RHGrupoMaterias 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHGMid#">
</cfquery>

<!--- Lista a desplegar --->
<cfquery name="rsMatGrupo" datasource="#Session.DSN#">
	Select mg.Mcodigo,Mnombre,Msiglas,mg.RHGMid,RHGMcodigo,Descripcion
	from RHMateriasGrupo mg
		inner join RHGrupoMaterias gm
			on gm.Ecodigo=mg.Ecodigo
				and gm.RHGMid=mg.RHGMid
		inner join RHMateria m
			on m.Ecodigo=mg.Ecodigo
				and m.Mcodigo=mg.Mcodigo
				and Mactivo=1
	where mg.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and mg.RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHGMid#">
	order by Mnombre
</cfquery>
<style type="text/css">
<!--
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="center"><td bgcolor="#EEEEEE">&nbsp;</td></tr>
  <tr align="center">
	<td bgcolor="#EEEEEE"><span class="style2"><cf_translate key="LB_MateriasdelGrupo">Materias del Grupo</cf_translate></span></td>
  </tr>
  <tr align="center">
	<td bgcolor="#EEEEEE"><cfoutput><span class="style2">#rsGrupo.RHGMcodigo# - #rsGrupo.Descripcion#</span></cfoutput></td>
  </tr>
  <tr align="center"><td bgcolor="#EEEEEE">&nbsp;</td></tr>  
  <tr>
	<td align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Materia"
			Default="Materia"
			returnvariable="LB_Materia"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Sigla"
			Default="Sigla"
			returnvariable="LB_Sigla"/>
	
		<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsMatGrupo#"/>
				<cfinvokeargument name="desplegar" value="Mnombre,Msiglas"/> 
				<cfinvokeargument name="etiquetas" value="#LB_Materia#, #LB_Sigla#"/>
				<cfinvokeargument name="formatos" value="V, V"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N, N"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Cerrar"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
	  </cfinvoke>
	</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	function funcCerrar(){
		window.close();
	}
</script>