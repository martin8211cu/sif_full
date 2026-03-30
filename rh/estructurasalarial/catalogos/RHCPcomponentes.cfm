<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ComponentesSalarial" Default="Componentes Salariales" returnvariable="LB_ComponentesSalarial" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ComponentesSalarialRelacion" Default="Relacionando Componentes Salariales" returnvariable="LB_ComponentesSalarialRelacion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Categoria" Default="Categor&iacute;a" returnvariable="LB_Categoria" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_TablaSalarial" Default="Tabla Salarial" returnvariable="LB_TablaSalarial" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Cerrar" Default="Cerrar" returnvariable="LB_Cerrar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_DeseaEliminarElRegistro" Default="¿Desea Eliminar el Registro?" returnvariable="LB_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml">

<html>
<head>  <title><cfoutput>#LB_ComponentesSalarialRelacion#</cfoutput></title>  </head>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="javascript">
		function funcEliminar(prn_llave){
			if( confirm('<cfoutput>#LB_DeseaEliminarElRegistro#</cfoutput>') ){
				return true;			
			}
			return false;
		}
</script>
<cfif isdefined("form.btnAgregar") and  isdefined("form.ComboComponentes") and len(trim(form.ComboComponentes)) gt 0>
	<cfquery datasource="#session.dsn#" name="validaComponentes">
	select 1 from RHCPcomponentes
	where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">
	and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">
	</cfquery>
	<cfif validaComponentes.recordcount eq 0>
		<cfquery datasource="#session.dsn#">
		insert into RHCPcomponentes (RHCPlinea,CSid)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ComboComponentes#">)
		</cfquery>
	</cfif>	
</cfif>

<cfif isdefined("form.btnEliminar") and isdefined("form.CHK")>
	<cfset deleteCSid=''>
	<cfloop list="#form.CHK#" delimiters="," index="i">
		<cfset deleteCSid=listAppend(deleteCSid,ListGetAt(i,3,'|'))>
	</cfloop>
	<cfquery datasource="#session.dsn#" name="a">
	delete from RHCPcomponentes 
	where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">
	and CSid in (#deleteCSid#)
	</cfquery>
</cfif>

<form action="RHCPcomponentes.cfm?RHCPlinea=<cfoutput>#url.RHCPlinea#</cfoutput>" method="post" name="form1">
<table width="100%" border="0">
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="d.RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
	<cf_translatedata name="get" tabla="RHTTablaSalarial" col="c.RHTTdescripcion " returnvariable="LvarRHTTdescripcion">
	<cf_translatedata name="get" tabla="RHCategoria" col="RHCdescripcion " returnvariable="LvarRHCdescripcion">

	<cfquery datasource="#session.DSN#" name="rsListaEncabezado">
	select 
		#LvarRHTTdescripcion# as Tabla,
		d.RHMPPcodigo #concat# ' - ' #concat# #LvarRHMPPdescripcion# as Puesto,
		RHCcodigo #concat# ' - ' #concat# #LvarRHCdescripcion# as Categoria
	from RHCategoriasPuesto a
		inner join RHTTablaSalarial c
			on a.RHTTid = c.RHTTid
		inner join RHMaestroPuestoP d
			on a.RHMPPid = d.RHMPPid
		left outer join RHCategoria b
			on a.RHCid = b.RHCid
	where a.RHCPlinea= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">
	</cfquery>
	<cfif rsListaEncabezado.recordcount gt 0>
	<cfoutput>
	<tr>
		<td colspan="4"><strong>#LB_TablaSalarial#:</strong>&nbsp;&nbsp;#rsListaEncabezado.Tabla#</td>
	</tr>
	<tr>
		<td colspan="4"><strong>#LB_Categoria#:</strong>&nbsp;&nbsp;#rsListaEncabezado.Categoria#</td>
	</tr>
	<tr>
		<td colspan="4"><strong>#LB_Puesto#:</strong>&nbsp;&nbsp;#rsListaEncabezado.Puesto#</td>
	</tr>
	</cfoutput>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><strong><cfoutput>#LB_ComponentesSalarial#</cfoutput></strong></td>
		<td>
		<cf_translatedata name="get" tabla="ComponentesSalariales" col="CSdescripcion " returnvariable="LvarCSdescripcion">
		<cfquery datasource="#session.dsn#" name="rsListaComponentes">
			select CSid, CScodigo,#LvarCSdescripcion# as CSdescripcion 
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CSusatabla in (1,5) <!--- unicamente los componentes que aplica tabla y que aplican tabla y calculo--->
		    
			and CSid not in (select rh.CSid
							from RHCPcomponentes rh
								inner join ComponentesSalariales cs
									on rh.CSid=cs.CSid
							where rh.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">)
			Order by CScodigo,#LvarCSdescripcion# 
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
		<cf_translatedata name="get" tabla="ComponentesSalariales" col="cs.CSdescripcion " returnvariable="LvarCSdescripcion">

		<cfquery name="rsComponentes" datasource="#session.dsn#">
		select cs.CSid, cs.CScodigo,#LvarCSdescripcion# as CSdescripcion, rh.RHCPlinea
		from RHCPcomponentes rh
			inner join ComponentesSalariales cs
				on rh.CSid=cs.CSid
		where rh.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCPlinea#">
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
			<cfinvokeargument name="fparams" value="url.RHCPlinea">
			<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			<cfinvokeargument name="formName" value="form1"/>
		</cfinvoke>	
	 </td>
	 <tr>
		 <td width="100%" height="100" valign="middle" colspan="4">
			 <center>
				<input type="button" class="btnNormal" name="btCerrar" id="btCerrar" value="<cfoutput>#LB_Cerrar#</cfoutput>" onclick="javascript: window.close();" />
			 </center>
		 </td>
	</tr>	
	<input type="hidden" value="<cfif isdefined("url.RHCPlinea")><cfoutput>#url.RHCPlinea#</cfoutput></cfif>" />		
</table>
</form>
</html>