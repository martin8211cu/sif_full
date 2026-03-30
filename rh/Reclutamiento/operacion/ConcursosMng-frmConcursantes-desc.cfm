<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2">&nbsp;</td>
	    <td>&nbsp;</td>
	    <td width="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>
			<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td>&nbsp;<strong><cf_translate key="LB_DESCALIFICARCONCURSANTE">DESCALIFICAR CONCURSANTE</cf_translate></strong></td>
					<td align="right" width="25" onMouseOver="javascript: this.style.cursor = 'pointer';">&nbsp;</td>
				  </tr>
				</table>
			</fieldset>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td>&nbsp;</td>
		<td valign="top">
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<table width="99%" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid ##CCCCCC">
				  <tr style="height: 25;">
					<td class="tituloListas" colspan="2" nowrap>
						<strong>
							<font color="##000099" style="font-size:11px;">
							#rsConcursante.identificacion#&nbsp;&nbsp;#rsConcursante.nombre#
							</font>
						<cfif rsConcursante.RHCdescalifica EQ 1>
							<font color="##FF0000" style="font-size:11px;">
							&nbsp;(<cf_translate key="LB_DESCALIFICADO">DESCALIFICADO</cf_translate>)
							</font>
						</cfif>
						</strong>
					</td>
				  </tr>
				</table>
				<form name="form1" method="post" action="ConcursosMng-sql.cfm">
				  <div id="divNuevo" style="overflow:auto; height: #tamVentanaConcursantes-25#; margin:0;" >
					<cfinclude template="ConcursosMng-hiddens.cfm">
					<input type="hidden" name="op" value="2">
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <cfif rsConcursante.RHCdescalifica EQ 1>
					  <tr>
						<td colspan="2" style="border-bottom: 1px solid ##CCCCCC"><strong><font color="##FF0000"><cf_translate key="LB_UnicamentePuedeModificarLaJustificacionParaLaDescalificacion">&Uacute;nicamente puede modificar la justificaci&oacute;n para la descalificaci&oacute;n</cf_translate></font></strong></td>
					  </tr>
					  </cfif>
					  <tr>
						<td align="right" valign="top"><strong><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:&nbsp;</strong></td>
						<td>
							<textarea name="RHCrazondeacalifica" id="RHCrazondeacalifica" rows="6" cols="50" ><cfif len(trim(rsConcursante.RHCrazondeacalifica))>#HTMLEditFormat(trim(rsConcursante.RHCrazondeacalifica))#</cfif></textarea>
						</td>
					  </tr>
					  <tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					  </tr>
					</table>
				  </div>
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <tr style="height: 25;">
						<td align="center" valign="middle" nowrap>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Descalificar"
								Default="Descalificar"
								returnvariable="BTN_Descalificar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Aceptar"
								Default="Aceptar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Aceptar"/>
							<cfif rsConcursante.RHCdescalifica EQ 0>
								<input type="submit" name="btnDescalificar" value="#BTN_Descalificar#">
							<cfelse>
								<input type="submit" name="btnAceptar" value="#BTN_Aceptar#">
							</cfif>
						</td>
					  </tr>
					</table>
				</form>
			</fieldset>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>
