<cfoutput> 
<cfinclude template="consultas-frame-header.cfm">
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
  <table width="95%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 10px; margin-right: 10px;">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
		  <cfinclude template="frame-infoEmpleado.cfm">
	  </td>
    </tr>
    <tr> 
      <td>
		<form name="formFiltroListaDeduc" method="post" action="expediente-globalcons.cfm" style="margin: 3">
			<input type="hidden" name="o" value="<cfif isdefined('Form.o')><cfoutput>#Form.o#</cfoutput></cfif>">
			<input type="hidden" name="sel" value="<cfif isdefined('Form.sel')><cfoutput>#Form.sel#</cfoutput></cfif>">
 			<input name="DEid" type="hidden" value="#rsEmpleado.DEid#"> 
			<table width="100%" border="0" cellspacing="3" cellpadding="3" class="areaFiltro">
			  <tr>
				<td><strong><cf_translate key="Descripcion">Descripci&oacute;n</cf_translate></strong></td>
				<td><strong><cf_translate key="FechaInicial">Fecha Inicial</cf_translate></strong></td>
				<td rowspan="2" align="center" valign="middle">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Filtrar"/>

				
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#"></td>
			  </tr>
			  <tr>
				<td><input name="DdescripcionFiltro" type="text" id="DdescripcionFiltro" value="<cfif isdefined('form.DdescripcionFiltro') and form.DdescripcionFiltro NEQ ''><cfoutput>#form.DdescripcionFiltro#</cfoutput></cfif>" size="80" maxlength="80"></td>
				<td>
					<cfif isdefined('form.DfechainiFiltro') and form.DfechainiFiltro NEQ ''>
						<cfset fecha = form.DfechainiFiltro>
					<cfelse>
						<cfset fecha ="">
					</cfif>
									
					<cf_sifcalendario form="formFiltroListaDeduc" name="DfechainiFiltro" value=#fecha#  tabindex="0">
				</td>
			  </tr>				
			</table>
		</form>	
	  </td>
    </tr>	
	<tr> 
	  <td class="#Session.preferences.Skin#_thcenter"><cf_translate key="Deducciones">DEDUCCIONES</cf_translate></td>
	</tr>
    <tr> 
      <td valign="top" nowrap> 
		  <cfinclude template="frame-deducciones.cfm">
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
<cfelse>
	<cf_translate key="MSG_LosDatosDeSusDeduccionesNoEstanDisponibles">Los datos de sus Deducciones no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>
