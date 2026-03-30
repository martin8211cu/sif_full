<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid))>
	<cfset form.RHTTid = url.RHTTid>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cf_translatedata name="validar" col="RHTTdescripcion" tabla="RHTTablaSalarial"	filtro="RHTTid = #form.RHTTid#"/>
	<cf_translatedata name="get" col="RHTTdescripcion" tabla="RHTTablaSalarial"	returnvariable="LvarRHTTdescripcion">
	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHTTid, a.RHTTcodigo, #LvarRHTTdescripcion# as RHTTdescripcion,a.ts_rversion
		from  RHTTablaSalarial a
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#"> 
	</cfquery>	
</cfif>

<cfoutput>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Modificar" Default="Modificar" XmlFile="/rh/generales.xml" returnvariable="BTN_Modificar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Eliminar" Default="Eliminar" XmlFile="/rh/generales.xml" returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Nuevo" Default="Nuevo" XmlFile="/rh/generales.xml" returnvariable="BTN_Nuevo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Agregar" Default="Nuevo" XmlFile="/rh/generales.xml" returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" XmlFile="/rh/generales.xml" returnvariable="BTN_Limpiar"/>


<form action="RHTTablaSalarial-sql.cfm"  method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">		
		<tr>
			<td align="right"><strong>#LB_Codigo#: </strong></td>
			<td>
				<input name="RHTTcodigo" size="5"  id="RHCcodigo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHTTcodigo)#</cfif>" maxlength="5" onfocus="this.select()" tabindex="1">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Descripcion#:</strong></td>
			<td>
				<input name="RHTTdescripcion" size="40" id="RHTTdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHTTdescripcion)#</cfif>" maxlength="80" onfocus="this.select()" tabindex="2">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
				<cfelse>
					<input type="submit" name="Cambio" value="#BTN_Modificar#" onClick="habilitarValidacion();">
					<input type="submit" name="Baja" value="#BTN_Eliminar#" onClick="deshabilitarValidacion(); return true;">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="deshabilitarValidacion();">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHTTid" value="#data.RHTTid#">
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

	objForm.RHTTcodigo.required = true;
	objForm.RHTTcodigo.description="<cfoutput>#LB_Codigo#</cfoutput>";				
	objForm.RHTTdescripcion.required= true;
	objForm.RHTTdescripcion.description="<cfoutput>#LB_Descripcion#</cfoutput>";	
	
	function habilitarValidacion(){
		objForm.RHTTcodigo.required = true;
		objForm.RHTTdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHTTcodigo.required = false;
		objForm.RHTTdescripcion.required = false;
	}
</script>


