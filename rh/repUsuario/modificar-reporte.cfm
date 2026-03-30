
<cfif isdefined("url.Cambio")>
	<cfquery datasource="#session.DSN#">
		update RHRUReportes
		set	RHRURcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.codigo#">,
			RHRURdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.descripcion#">,
			RHRURsistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.sistema#">,
			RHRURcategoria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.categoria#">,
			RHRURparametros = <cfif isdefined("url.RHRURparametros")>1<cfelse>0</cfif>
		where RHRURid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	</cfquery>
	<script>
		window.opener.location.href = 'eliminar-reporte.cfm';
	</script>
</cfif>

<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"	
	xmlfile="/rh/generales.xml"
	returnvariable="vCodigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"	
	xmlfile="/rh/generales.xml"
	returnvariable="vDescripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Categoria"
	Default="Categoría"
	xmlfile="/rh/generales.xml"
	returnvariable="vCategoria"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sistema"
	Default="Sistema"
	xmlfile="/rh/generales.xml"
	returnvariable="vSistema"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleados"
	Default="Empleados"
	xmlfile="/rh/generales.xml"
	returnvariable="vEmpleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estructura_Organizacional"
	Default="Estructura Organizacional"
	xmlfile="/rh/generales.xml"
	returnvariable="vEstructura"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nomina"
	Default="N&oacute;mina"
	xmlfile="/rh/generales.xml"
	returnvariable="vNomina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Parametros"
	Default="Par&aacute;metros"
	xmlfile="/rh/generales.xml"
	returnvariable="vParametros"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_seleccionar"
	Default="seleccionar"
	xmlfile="/rh/generales.xml"
	returnvariable="vseleccionar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrar"
	Default="Cerrar"
	xmlfile="/rh/generales.xml"
	returnvariable="vCerrar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Modificacion_de_informacion_de_reporte"
	Default="Modificaci&oacute;n de informaci&oacute;n de reporte"
	xmlfile="/rh/repUsuario/ejecutar-reporte.xml"
	returnvariable="vtitulo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Archivo_asociado"
	Default="Archivo asociado"
	xmlfile="/rh/repUsuario/ejecutar-reporte.xml"
	returnvariable="varchivoasociado"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Requiere_parametros_para_ejecucion"
	Default="Requiere par&aacute;metros para ejecuci&oacute;n"
	xmlfile="/rh/repUsuario/upload-reporte.xml"
	returnvariable="vReqParametros"/>	

<cfquery name="datos" datasource="#session.DSN#">
	select 	RHRURcodigo as codigo,
			RHRURdescripcion as descripcion,
			RHRURsistema as sistema,
			RHRURcategoria as categoria,
			RHRURnombre as archivo,
			RHRURparametros as parametros
	from RHRUReportes
	where RHRURid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>

<cfoutput>

<table width="90%" align="center" border="0" cellpadding="2" cellspacing="0">
	<tr><td ><table width="100%" class="navbar"><tr><td align="center"><font style="color:##000000"><strong>#vtitulo#</strong></font></td></tr></table></td></tr>
</table>

<form name="form1" method="url" >
	<table width="50%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right" width="1%" nowrap="nowrap"><strong>#vCodigo#:</strong></td>
			<td><input type="text" name="codigo" 		value="#datos.codigo#"  maxlength="5" size="10" ></td>
		</tr>
		<tr>
			<td align="right"><strong>#vDescripcion#:</strong></td>
			<td><input type="text" name="descripcion" value="#datos.descripcion#" maxlength="100" size="35" ></td>
		</tr>
		<tr>
			<td align="right"><strong>#vSistema#:</strong></td>
			<td>
				<select name="sistema">
					<option value="">-- #vseleccionar# --</option>
					<option value="RH" <cfif trim(datos.sistema) eq 'RH'>selected</cfif> >RH - Recursos Humanos</option>
					<option value="SIF" <cfif trim(datos.sistema) eq 'SIF'>selected</cfif> >SIF - Sistema Financiero Integral</option>					
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#vCategoria#:</strong></td>
			<td>
				<select name="categoria">
					<option value="">-- #vseleccionar# --</option>
					<option value="empleados" <cfif datos.categoria eq 'empleados'>selected</cfif> >#vEmpleados#</option>
					<option value="estructura" <cfif datos.categoria eq 'estructura'>selected</cfif>>#vEstructura#</option>
					<option value="nomina" <cfif datos.categoria eq 'nomina'>selected</cfif>>#vNomina#</option>
					<option value="parametros" <cfif datos.categoria eq 'parametros'>selected</cfif>>#vParametros#</option>					
				</select>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellspacing="0" cellpadding="1">
					<tr>
						<td><input type="checkbox" id="RHRURparametros" name="RHRURparametros" value="0" <cfif datos.parametros eq 1>checked="checked"</cfif> /></td>
						<td nowrap="nowrap"><label for="RHRURparametros">#vReqParametros#</label></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td nowrap="nowrap"><strong>#varchivoasociado#:</strong></td>
			<td>#datos.archivo#</td>
		</tr>
		<tr><td colspan="2" align="center">
			<table>
			<tr>
			<td><cf_botones modo="Cambio" exclude="Baja,Nuevo" ></td>
			<td><input type="button" name="Cerrar" class="btnNormal" value="#vCerrar#" onclick="javascript: window.close();"></td>
			</tr>
			</table>
		</td></tr>
	</table>
	<input type="hidden" name="id" value="#url.id#" >
</form>
</cfoutput>
<cf_qforms>