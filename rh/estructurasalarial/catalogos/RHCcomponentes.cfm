<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ComponentesSalarial" Default="Componentes Salariales" returnvariable="LB_ComponentesSalarial" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ComponentesSalarialRelacion" Default="Relacionando Componentes Salariales" returnvariable="LB_ComponentesSalarialRelacion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Categoria" Default="Categor&iacute;a" returnvariable="LB_Categoria" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_TablaSalarial" Default="Tabla Salarial" returnvariable="LB_TablaSalarial" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<html>
<head>  <title><cfoutput>#LB_ComponentesSalarialRelacion#</cfoutput></title>  </head>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="javascript">
		function funcEliminar(prn_llave){
			if( confirm('Desea Eliminar el Registro?') ){
				return true;			
			}
			return false;
		}
</script>
<cfif isdefined("form.btnAgregar") and  isdefined("form.ComboComponentes") and len(trim(form.ComboComponentes)) gt 0>
	<cfquery datasource="#session.dsn#" name="validaComponentes">
	select 1 from RHCcomponentes
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
	and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">
	</cfquery>
	<cfif validaComponentes.recordcount eq 0>
		<cfquery datasource="#session.dsn#">
		insert into RHCcomponentes (RHCid,CSid)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">)
		</cfquery>
	</cfif>	
</cfif>

<cfif isdefined("form.btnEliminar") and isdefined("form.CHK")>
	<cfset deleteCSid=''>
	<cfloop list="#form.CHK#" delimiters="," index="i">
		<cfset deleteCSid=listAppend(deleteCSid,ListGetAt(i,3,'|'))>
	</cfloop>
	<cfquery datasource="#session.dsn#" name="a">
	delete from RHCcomponentes 
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
	and CSid in (#deleteCSid#)
	</cfquery>
</cfif>

<form action="RHCcomponentes.cfm?RHCid=<cfoutput>#url.RHCid#</cfoutput>" method="post" name="form1">
<table width="100%" border="0">
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cfquery datasource="#session.DSN#" name="rsListaEncabezado">
        select 
            RHCcodigo #concat# ' - ' #concat# RHCdescripcion as Categoria
        from RHCategoria b
        where b.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
	</cfquery>
	<cfif rsListaEncabezado.recordcount gt 0>
		<cfoutput>
            <tr>
                <td colspan="4"><strong>#LB_Categoria#:</strong>&nbsp;&nbsp;#rsListaEncabezado.Categoria#</td>
            </tr>
        </cfoutput>
	</cfif>
    
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><strong><cfoutput>#LB_ComponentesSalarial#</cfoutput></strong></td>
		<td>
		<cfquery datasource="#session.dsn#" name="rsListaComponentes">
			select CSid, CScodigo,CSdescripcion 
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CSusatabla = 1 <!--- unicamente los componentes que aplica tabla--->
			and CSid not in (select rh.CSid
							from RHCcomponentes rh
								inner join ComponentesSalariales cs
									on rh.CSid=cs.CSid
							where rh.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">)
			Order by CScodigo,CSdescripcion 
		</cfquery>
		<select name="ComboComponentes">
			<cfoutput query="rsListaComponentes">
			<option value="#CSid#">#CScodigo# - #CSdescripcion#</option>
			</cfoutput>
		</select>
		<td>
		<td> <input type="submit" name="btnAgregar" id="btnAgregar" value="+" tabindex="2"></td>	
	</tr>
	<tr>
	 <td width="100%" colspan="4">
		<cfquery name="rsComponentes" datasource="#session.dsn#">
		select cs.CSid, cs.CScodigo,cs.CSdescripcion, rh.RHCid
		from RHCcomponentes rh
			inner join ComponentesSalariales cs
				on rh.CSid=cs.CSid
		where rh.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value=""/>
			<cfinvokeargument name="query" value="#rsComponentes#"/>
			<cfinvokeargument name="desplegar" value="CScodigo, CSdescripcion"/>
			<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Eliminar"/>
			<cfinvokeargument name="MaxRows" value="25"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="fparams" value="url.RHCid">
			<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			<cfinvokeargument name="formName" value="form1"/>
		</cfinvoke>	
	 </td>
	 <tr>
		 <td width="100%" height="100" valign="middle" colspan="4">
			 <center>
				<input type="button" class="btnNormal" name="btCerrar" id="btCerrar" value="Cerrar" onClick="javascript: window.close();" />
			 </center>
		 </td>
	</tr>	
	<input type="hidden" value="<cfif isdefined("url.RHCid")><cfoutput>#url.RHCid#</cfoutput></cfif>" />		
</table>
</form>
</html>