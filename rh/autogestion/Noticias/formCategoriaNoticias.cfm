<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DeseaEliminarElRegistro" Default="Desea eliminar el registro?" returnvariable="LB_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfif isdefined("url.IdCategoria") and len(trim(url.IdCategoria))>
	<cfset form.IdCategoria = url.IdCategoria>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.IdCategoria") and len(trim(form.IdCategoria)) and form.IdCategoria neq 0 >
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select IdCategoria, CodCategoria, DescCategoria, ts_rversion
		from CategoriaNoticias 
		where IdCategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#"> 
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>	
</cfif>

<cfoutput>
<form action="SQLCategoriaNoticias.cfm"  method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right"><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td>
				<input name="CodCategoria" size="5"  id="CodCategoria" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.CodCategoria)#</cfif>" maxlength="3" onfocus="this.select()" tabindex="1">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td>
				 <input name="DescCategoria" size="40" id="DescCategoria" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.DescCategoria)#</cfif>" maxlength="80" onfocus="this.select()" tabindex="2">
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();" tabindex="3">
					<input type="reset" name="Limpiar" value="Limpiar" tabindex="4">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();" tabindex="5">
					<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('#LB_DeseaEliminarElRegistro#') ){deshabilitarValidacion(); return true;} return false;" tabindex="6">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();" tabindex="7">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="IdCategoria" value="#data.IdCategoria#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
	objForm.CodCategoria.required = true;
	objForm.CodCategoria.description="#LB_Codigo#";				
	objForm.DescCategoria.required= true;
	objForm.DescCategoria.description="#LB_Descripcion#";	
	</cfoutput>
	function habilitarValidacion(){
		objForm.CodCategoria.required = true;
		objForm.DescCategoria.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CodCategoria.required = false;
		objForm.DescCategoria.required = false;
	}
</script>