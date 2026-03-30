<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesAsoc" Default="Reporte de las deducciones de la Asociaci&oacute;n Solidarista " returnvariable="LB_ReporteDeDeduccionesAsoc"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Año" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nomina" Default="Nomina" returnvariable="LB_Nomina"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeDeduccionesAsoc#">
	
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

		<!---<cfinclude template="/rh/portlets/pNavegacion.cfm">		--->
		<form name="form1" method="post" action="RepDeduccAsoccSolidarista-form.cfm">
		<cfoutput>
		<table cellpadding="3" cellspacing="0" align="center" border="0">								
			<tr  id="TR_Periodo">
				<td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
				<td width="238"><select name="periodo">
					<option value=""></option>
					<cfloop index="i" from="-5" to="0">
						<cfset vn_anno = year(DateAdd("yyyy", i, now()))>
						<option value="#vn_anno#">#vn_anno#</option>
					</cfloop>
			  </select></td>
			  <cfset paso = 1>	
			</tr>
				
			<tr id="TR_Mes">
				<td align="right"><b>#LB_Mes#:&nbsp;</b></td>
				<td><select name="mes">	<option value=""></option>
					<cfloop query="rsMeses">
						<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
					</cfloop>
					</select>
			</tr>			
		  </tr>
			<tr> 
			<td nowrap class="fileLabel" align="right"><cf_translate key="LB_CodigoDelCalendarioDePago">Código del Calendario de Pago</cf_translate> :&nbsp;</td>
			<td nowrap colspan="7">
				
				<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" >
			</td>				
			</tr>			
			<tr>				
				<td colspan="4" align="center">
					<input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar"></td>
			</tr>		
			<tr></tr>				
		</table>	
		<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
		<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	
	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Mes#'	
    objForm.CPid.description = '#LB_Nomina#'	
	objForm.CPid.required = true;
		
	</cfoutput>	
</script>
