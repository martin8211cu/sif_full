<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteSalarioEscolar" Default="Reporte Salario Escolar" returnvariable="LB_ReporteSalarioEscolar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" returnvariable="LB_Mes"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
	select TDid, TDcodigo, TDdescripcion 
	from TDeduccion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="#nav__SPdescripcion#" returnvariable="LB_titulo"/>

<cf_templateheader title="#LB_ReporteSalarioEscolar#">
	<cf_web_portlet_start titulo="#LB_ReporteSalarioEscolar#">
		<cfoutput>#pNavegacion#</cfoutput>
			<br/>
			<table width="975" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td width="25">&nbsp;</td>
				<td width="300" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
						<p><cf_translate  key="LB_texto_de_ayuda">
								Reporte de nóminas adicionales (salarios pagados retroactivamente y 
								que no fueron tomados en cuenta en el reporte de la CCSS) I.T.C.R
						</cf_translate></p>
				    <cf_web_portlet_end>
				</td>

				<td width="25">&nbsp;</td>
				<td width="400" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_filtros#" tituloalign="left" wifth="300" height="300">
						<form name="form1" method="post" action="repNominaAdicional-form.cfm">
						<cfoutput>
						<table width="90%" cellpadding="4" cellspacing="0" align="center" border="0">			
							<tr  id="TR_Periodo">
								<td width="418" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
								<td width="107"><cf_rhperiodos name="periodo"></td>
								<td width="102" align="right"><b>#LB_Mes#:&nbsp;</b></td>
								<td width="449"><cf_meses name="mes"></td>
							</tr>
							<tr>				
								<td colspan="4" align="center">
									<input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar"></td>
							</tr>		
						</table>	
						<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
						<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
						<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
						</cfoutput>
						</form>
					<cf_web_portlet_end>
				</td>
				<td width="25">&nbsp;</td>
			  </tr>
			</table>
			<br/>
			<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	
	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Mes#'

	</cfoutput>	
</script>
