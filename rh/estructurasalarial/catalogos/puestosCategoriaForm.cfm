<cfif isdefined("url.RHPCid") and not isdefined("form.RHPCid")><cfset form.RHPCid = url.RHPCid></cfif>
<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")><cfset form.RHPcodigo = url.RHPcodigo></cfif>
<cfif isdefined("url.RHPCfinicio") and not isdefined("form.RHPCfinicio")><cfset form.RHPCfinicio = url.RHPCfinicio></cfif>
<cfif isdefined("url.RHPCffinal") and not isdefined("form.RHPCffinal")><cfset form.RHPCffinal = url.RHPCffinal></cfif>
<cfif isdefined("form.RHPCid") and not isdefined("form.Nuevo")><cfset modo = "CAMBIO"><cfelse><cfset modo = "ALTA"></cfif>

<cfif (MODO NEQ "ALTA")>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select RHPCid, RHPCfinicio, RHPCffinal, b.RHTCid, RHTTcodigo, RHTTdescripcion, RHMCcodigo, RHMCpaso, d.RHPcodigo, RHPdescpuesto, a.ts_rversion
		from RHPuestosCategoria a, RHCategoriasTipoTabla b, RHTTablaSalarial c, RHPuestos d
		where RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
		  and a.RHTCid = b.RHTCid
		  and b.RHTTid = c.RHTTid 
		  and a.RHPcodigo = d.RHPcodigo
		  and a.Ecodigo = d.Ecodigo
	</cfquery>
	<cfset ts = "">
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
</cfif>

<cfsavecontent variable="lista">
	<!--- EL CONTENIDO DE ESTA SECCIÓN NO SE PINTA DE INMEDIATO SINO HASTA QUE SE IMPRIMA LA VARIBLE "LISTA" EN DONDE SE ESTÁ ALMACENANDO LA PRESENTE SALIDA. --->
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRHRet">
		<cfinvokeargument name="tabla" value="RHPuestosCategoria a, RHCategoriasTipoTabla b, RHTTablaSalarial d, RHPuestos e"/>
		<cfinvokeargument name="columnas" value="a.RHPCid, e.RHPcodigo, e.RHPdescpuesto, d.RHTTcodigo, d.RHTTdescripcion, b.RHMCcodigo, b.RHMCpaso"/>
		<cfinvokeargument name="desplegar" value="RHTTcodigo, RHTTdescripcion, RHMCcodigo, RHMCpaso"/>
		<cfinvokeargument name="etiquetas" value="Tipo Tabla, Descripci&oacute;n, Categor&iacute;a, Paso"/>
		<cfinvokeargument name="cortes" value="RHPdescpuesto">
		<cfinvokeargument name="formatos" value="S,S,S,S"/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
												  and a.RHTCid = b.RHTCid
												  and b.RHTTid = d.RHTTid
												  and a.RHPcodigo = e.RHPcodigo
												  and a.Ecodigo = e.Ecodigo
												  order by RHPdescpuesto"/>
		<cfinvokeargument name="align" value="left,left,left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="puestosCategoria.cfm"/>
		<cfinvokeargument name="MaxRows" value="15">
	</cfinvoke>
</cfsavecontent>

<cfsavecontent variable="mantenimiento">
	<!--- EL CONTENIDO DE ESTA SECCIÓN NO SE PINTA DE INMEDIATO SINO HASTA QUE SE IMPRIMA LA VARIBLE "MANTENIMIENTO" EN DONDE SE ESTÁ ALMACENANDO LA PRESENTE SALIDA. --->
	<!--- incluye referencia al js necesario en la página html resultante --->
	<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<form name="form1" id="form1" action="puestosCategoriaSQL.cfm" style="margin:0 " method="post">
	<table border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td><strong>Rige:</strong></td>
		<td><strong>Hasta:</strong></td>
	  </tr>
  	  <tr>
		<td>
			<cfif (MODO NEQ "ALTA")>
				<cf_sifcalendario name="RHPCfinicio" value="#LSDateFormat(rsForm.RHPCfinicio,'dd/mm/yyyy')#">
			<cfelseif isdefined("Form.RHPCfinicio")>
				<cf_sifcalendario name="RHPCfinicio" value="#LSDateFormat(Form.RHPCfinicio,'dd/mm/yyyy')#">
			<cfelse>
				<cf_sifcalendario name="RHPCfinicio">
			</cfif>
		</td>
		<td>
			<cfif (MODO NEQ "ALTA")>
				<cf_sifcalendario name="RHPCffinal" value="#LSDateFormat(rsForm.RHPCffinal,'dd/mm/yyyy')#">
			<cfelseif isdefined("Form.RHPCffinal")>
				<cf_sifcalendario name="RHPCffinal" value="#LSDateFormat(Form.RHPCffinal,'dd/mm/yyyy')#">
			<cfelse>
				<cf_sifcalendario name="RHPCffinal">
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td colspan="2"><strong>Puesto</strong></td>
	  </tr>
	  <tr>
		<td colspan="2">
			<cfif (MODO NEQ "ALTA")>
				<cfoutput>
					#rsForm.RHPcodigo# - #rsForm.RHPdescpuesto#
					<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#rsForm.RHPcodigo#">
				</cfoutput>
			<cfelseif isdefined("Form.RHPcodigo")>
				<cfquery name="rsPuesto" datasource="#Session.DSN#">
					select RHPcodigo, RHPdescpuesto
					from RHPuestos
					where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cf_rhpuesto query="#rsPuesto#">			
			<cfelse>
				<cf_rhpuesto>
			</cfif>
		</td>
	  </tr>
	  <tr>
	    <td colspan="2">
			<fieldset><legend>Categoría</legend>
				<cfif (MODO NEQ "ALTA")>
					<cf_rhcategoriasalarial query="#rsForm#">
				<cfelse>
					<cf_rhcategoriasalarial>
				</cfif>
			</fieldset>
	    </td>
	  </tr>
	  <tr>
	  	<td colspan="2" align="center">
			<cf_botones modo="#MODO#">
			<cfif (MODO NEQ "ALTA")>
				<input type="hidden" name="RHPCid" id="RHPCid" value="<cfoutput>#rsForm.RHPCid#</cfoutput>">
				<input type="hidden" name="ts_rversion" id="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
			</cfif>
		</td>
	  </tr>
	</table>
	</form>
	<script language="javascript" type="text/javascript">
		<!--//
		//incluye qforms en la página
		// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// Qforms. carga todas las librerías por defecto
		qFormAPI.include("*");
		//inicializa qforms en la página
		qFormAPI.errorColor = "#FFFFCC";
		//FormTransferir
		objForm = new qForm("form1");
		//validaciones
		objForm.RHPcodigo.description = "Puesto";
		objForm.RHPcodigo.required = true;
		objForm.RHTCid.description = "Categoria";
		objForm.RHTCid.required = true;
		objForm.RHPCfinicio.description = "Fecha Rige";
		objForm.RHPCfinicio.required = true;
		objForm.RHPCffinal.description = "Fecha Hasta";
		objForm.RHPCffinal.required = true;
		objForm.RHPCfinicio.obj.focus();
		//-->
	</script>
</cfsavecontent>

<cf_web_portlet_start titulo="Categor&iacute;as de Pago por Puesto">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
    <td width="60%" valign="top"><cfoutput>#lista#</cfoutput></td>
    <td width="10%">&nbsp;</td>
    <td width="30%" valign="top"><cfoutput>#mantenimiento#</cfoutput></td>
    <td>&nbsp;</td>
  </tr>
</table>
<cf_web_portlet_end>