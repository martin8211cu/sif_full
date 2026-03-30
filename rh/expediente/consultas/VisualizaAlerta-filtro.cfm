<!--- Consultas --->
<!--- Tipos de Nómina --->

<!--- Empleado --->
<!--- <cfif isdefined("Form.Filtrar") and isdefined("Form.DEid") AND Len(Trim(Form.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select convert(varchar, a.DEid) as DEid, 
			   a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2 as NombreEmp,
		       a.DEidentificacion, a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
</cfif> --->
<!--- JavaScript --->
<cfquery name="rsRHTipoAccion" datasource="#Session.DSN#">
	select RHTid, RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, 
		   RHTpmax, RHTcomportam, RHTposterior, RHTautogestion, RHTindefinido, 
		   RHTctiponomina, RHTcregimenv, RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, 
		   RHTccomp, RHTcsalariofijo, RHTcjornada, RHTvisible, RHTccatpaso, 
		   RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, RHTcuentac, RHTnoretroactiva, 
		   RHTcantdiascont, CIncidente1, CIncidente2, RHTliquidatotal, RHTnocargasley, ts_rversion
	from RHTipoAccion
	where Ecodigo = 1
</cfquery>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<form name="filtro" method="get" action="VisualizaAlerta.cfm">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center">
  <tr>
    <td nowrap class="fileLabel" align="right"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:</strong>&nbsp;</td>
    <td nowrap>
		<!--- Empleado --->
		<cf_rhempleado form="filtro">	</td>
  </tr>
  <tr>
  		<td class="fileLabel"><div align="right"><strong><cf_translate key="LB_TipoDeAccionDePersonal">Tipo de Acci&oacute;n de Personal</cf_translate>:</strong>&nbsp;</div></td>
			<td>
				<select name="RHTid">
					<option value="-1">--- <cf_translate key="CMB_Todos">Todos</cf_translate> ---</option>
					<cfloop query="rsRHTipoAccion">
						<option value="<cfoutput>#rsRHTipoAccion.RHTid#</cfoutput>" <cfif isdefined("form.RHTid") and form.RHTid EQ rsRHTipoAccion.RHTid> selected </cfif>><cfoutput>#rsRHTipoAccion.RHTdesc#</cfoutput></option>
					</cfloop>
				</select>
		
			</td>
  </tr>
	<tr>
		<td class="fileLabel"><div align="right"><strong><cf_translate key="LB_AlertasMenoresAl">Alertas menores al</cf_translate>:</strong>&nbsp;</div></td>
		<td>
			<cfset fechahoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
			<cf_sifcalendario form="filtro" value="#fechahoy#" name="fechaH">
	  </td>
	</tr>
	<tr>
		<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
		<td >
			<select name="formato">
				<option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
				<option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
				<option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
			</select>
		</td>
	</tr>
	<tr>
		<td nowrap align="center" colspan="10">
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Consultar"
		Default="Consultar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Consultar"/>		

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Limpiar"
		Default="Limpiar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Limpiar"/>		
		<cfoutput>
			<input type="submit" name="btnFiltrar" id="btnFiltrar" value="#BTN_Consultar#">
			<input type="reset" name="btnLimpiar" id="btnLimpiar" value="#BTN_Limpiar#">
		</cfoutput>
		<!--- <input type="submit" name="btnGenerar" id="btnGenerar" value="Generar"> --->
			</td>
	</tr>
</table>
</form>
<script language="JavaScript" type="text/javascript">
	//Instancia de qForm
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	//Validaciones 
	//objForm.Tcodigo.required = true;
	//objForm.Tcodigo.description = "Tipo Nómina";
	//objForm.CPcodigo.required = true;
	//objForm.CPcodigo.description = "Código";
	//objForm.Tcodigo.obj.focus();
</script>