<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="tipoGruposOficinas-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="tipoGruposOficinas-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Nuevo" 	default="Nuevo" 
returnvariable="BTN_Nuevo" xmlfile="tipoGruposOficinas-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Filtrar" 	default="Filtrar" 
returnvariable="BTN_Filtrar" xmlfile="tipoGruposOficinas-filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Imprimir" 	default="Imprimir" 
returnvariable="BTN_Imprimir" xmlfile="tipoGruposOficinas-filtro.xml"/>

<!--- CAMPOS POR EL(OS) CUAL(ES) SE REALIZARÁ EL FILTRO--->

<cfif isdefined("url.Codigo_F") and Len(Trim(url.Codigo_F))>
	<cfparam name="Form.Codigo_F" default="#Url.Codigo_F#">
</cfif>
<cfif isdefined("url.Descripcion_F") and Len(Trim(url.Descripcion_F))>
	<cfparam name="Form.Descripcion_F" default="#Url.Descripcion_F#">
</cfif>

<cfoutput>
<form style="margin: 0" action="tipoGruposOficinas.cfm" name="Goficinas" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_Codigo#<strong></td>		
		<td align="left"><input type="text" name="Codigo_F" size="20" maxlength="10" value="<cfif isdefined('form.Codigo_F')><cfoutput>#form.Codigo_F#</cfoutput></cfif>"></td>	
		<td align="right"><strong>#LB_Nombre#<strong></td>		
		<td align="left"><input type="text" name="Descripcion_F" size="80" maxlength="50" value="<cfif isdefined('form.Descripcion_F')><cfoutput>#form.Descripcion_F#</cfoutput></cfif>"></td>
		<td align="right"><input type="submit" name="btnFiltro"  value="#BTN_Filtrar# "></td>
		<td align="letf">
			<input  type="submit"  name="btnNuevo"  value="#BTN_Nuevo#" onClick="javascript: return funcNuevo();">
		</td>
		<td align="letf">
			<input   type="button"  name="btnNuevo"  value="#BTN_Imprimir#" onClick="javascript: return funcImprime();">
		</td>
	</tr>
 </table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcNuevo(){
		location.href='tipoGruposOficinas-form.cfm';
		return false;
	}
	function funcImprime(){
		location.href='tipoGruposOficinas-listado-sql.cfm';
		return false;
	}
	var f = document.Goficinas;
	f.Codigo_F.focus();
</script>
