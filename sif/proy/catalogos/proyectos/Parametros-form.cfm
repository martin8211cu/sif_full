<cfquery name="rsParametros" datasource="#Session.DSN#">
	select a.PCEcatidProyecto, a.PCEcatidRecurso, a.ts_rversion,
		   b.PCEcodigo as PCEcodigoProyecto, b.PCEdescripcion as PCEdescripcionProyecto,
		   c.PCEcodigo as PCEcodigoRecurso, c.PCEdescripcion as PCEdescripcionRecurso
	from PRJparametros a, PCECatalogo b, PCECatalogo c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.PCEcatidProyecto = b.PCEcatid
	and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.PCEcatidRecurso = c.PCEcatid
	and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="Parametros-sql.cfm">
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
              <td align="right" nowrap>Cat&aacute;logo Proyecto:</td>
              <td>
				  <cfif rsParametros.recordCount GT 0>
					<cf_sifcatalogos form="form1" query="#rsParametros#" name="PCEcatidProyecto" codigo="PCEcodigoProyecto" desc="PCEdescripcionProyecto" index="1">
				  <cfelse>	
					<cf_sifcatalogos form="form1" name="PCEcatidProyecto" codigo="PCEcodigoProyecto" desc="PCEdescripcionProyecto" index="1">
				  </cfif>		  		  						
			  </td>
		    </tr>
			<tr>
              <td align="right" nowrap>Cat&aacute;logo Recurso:</td>
              <td>
				  <cfif rsParametros.recordCount GT 0>
					<cf_sifcatalogos form="form1" query="#rsParametros#" name="PCEcatidRecurso" codigo="PCEcodigoRecurso" desc="PCEdescripcionRecurso" index="2">
				  <cfelse>	
					<cf_sifcatalogos form="form1" name="PCEcatidRecurso" codigo="PCEcodigoRecurso" desc="PCEdescripcionRecurso" index="2">
				  </cfif>		  		  						
			  </td>
		    </tr>
			<tr>
			  <td align="right" nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif rsParametros.recordCount GT 0>
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsParametros.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif rsParametros.recordCount GT 0><cfoutput>#ts#</cfoutput></cfif>">
				<input type="submit" name="btnGuardar" value="Guardar">
				<input type="reset" name="btnLimpiar" value="Limpiar">
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.PCEcodigoProyecto.required = true;
	objForm.PCEcodigoProyecto.description = "Catálogo Proyecto";
	objForm.PCEcodigoRecurso.required = true;
	objForm.PCEcodigoRecurso.description = "Catálogo Recurso";
	
</script>
