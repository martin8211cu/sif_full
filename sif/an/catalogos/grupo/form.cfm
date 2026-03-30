<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGrupo" 	default="Datos de Grupos" 
returnvariable="LB_DatosGrupo" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Padre" 	default="Padre" 
returnvariable="LB_Padre" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Seleccion" 	default="Ninguno" 
returnvariable="LB_Seleccion" xmlfile="form.xml"/>

<cfset modo="ALTA"><cfif isdefined("form.GAid") and form.GAid GT 0><cfset modo="CAMBIO"></cfif>
<cfif modo neq "ALTA">
	<cfquery name="rsForm" dbtype="query">
		select GAid, GAcodigo, GAnombre, GAdescripcion, GApadre, GAruta, GAprofundidad, ts_rversion
		from rsAnexoGrupo
		where GAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#">
	</cfquery>
</cfif>
<cfquery name="rsGAs" dbtype="query">
	select GAid, GAcodigo, GAnombre, GAprofundidad
	from rsAnexoGrupo
	<cfif modo neq "ALTA">
	where GAruta not like '#rsForm.GAruta#%'
	</cfif>	
	order by GAruta
</cfquery>

<cfoutput>
<form action="sql.cfm" method="post" name="form1">
	<cfif modo neq "ALTA">
		<input type="hidden" name="GAid" value="#rsForm.GAid#">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	<br>
	<table 
		width="100%"  
		border="0" 
		cellspacing="2" 
		cellpadding="0">
	<tr>
	  <td colspan="2" class="subTitulo">#LB_DatosGrupo# </td>
	  </tr>
	<tr>
	<td><strong> #LB_Codigo#:&nbsp;
	</strong></td>
	<td>
		<input type="text" name="GAcodigo" maxlength="10" <cfif modo neq "ALTA">value="#rsForm.GAcodigo#"</cfif>>
	</td>
	</tr>
	<tr>
	<td><strong>#LB_Nombre# &nbsp;:&nbsp;
	</strong></td>
	<td>
		<input type="text" name="GAnombre" maxlength="60" <cfif modo neq "ALTA">value="#rsForm.GAnombre#"</cfif>>
	</td>
	</tr>
	<tr>
	<td><strong> #LB_Descripcion#&nbsp;:
	</strong></td>
	<td>
	<textarea name="GAdescripcion" cols="40" rows="2" style="font-family:Arial, Helvetica, sans-serif;"><cfif modo neq "ALTA">#rsForm.GAdescripcion#</cfif></textarea>
	</td>
	</tr>
	<tr>
	<td><strong> #LB_Padre#&nbsp;:
	</strong></td>
	<td>
		<select name="GApadre">
			<option value=""> --#LB_Seleccion#-- </option>
			<cfloop query="rsGAs">
				<option value="#GAid#"<cfif modo neq "ALTA" and rsForm.GApadre eq rsGAs.GAid>selected</cfif>>#RepeatString('&nbsp;',rsGAs.GAprofundidad*2)##rsGas.GAcodigo# - #rsGas.GAnombre#</option>
			</cfloop>
		</select>
	</td>
	</tr>
	</table>
	<br>
	<cf_botones modo="#modo#">
</form>
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.GAcodigo.description = "#JSStringFormat('Cdigo')#";
	objForm.GAnombre.description = "#JSStringFormat('Nombre')#";
	objForm.GAdescripcion.description = "#JSStringFormat('Descripcin')#";
	function habilitarValidacion(){
		objForm.GAcodigo.required = true;
		objForm.GAnombre.required = true;
		objForm.GAdescripcion.required = true;
	}
	function desahabilitarValidacion(){
		objForm.GAcodigo.required = false;
		objForm.GAnombre.required = false;
		objForm.GAdescripcion.required = false;
	}
	habilitarValidacion();
	objForm.GAcodigo.obj.focus();
//-->
</script>
</cfoutput>	