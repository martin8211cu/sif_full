<cfoutput>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td width="1">
			<img border="0" src="/cfmx/rh/imagenes/number#Form.paso#_64.gif" align="absmiddle">
		</td>
		<td style="padding-left: 10px;" valign="top">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
			  </tr>
			<cfif modo EQ "CAMBIO">
			  <tr>
			    <td class="tituloEncab" align="left" nowrap><cf_translate key="LB_Modificando">Modificando: </cf_translate><font color="##003399"><strong>#rsDatosAccion.RHAdescripcion#</strong></font></td>
			  </tr>
			<cfelse>
				<cfif Form.paso EQ 0>
				  <tr>
					<td class="tituloEncab" align="left" nowrap><cf_translate key="LB_Seleccione_la_accion_masiva_de_personal_que_desea_modificar">Seleccione la acci&oacute;n masiva de personal que desea modificar</cf_translate></td>
				  </tr>
				<cfelse>
				  <tr>
					<td class="tituloEncab" align="left" nowrap><cf_translate key="LB_Configure_los_parametros_de_la_nueva_accion_masiva_de_personal">Configure los par&aacute;metros de la nueva acci&oacute;n masiva de personal</cf_translate></td>
				  </tr>
			  	</cfif>
			</cfif>
			</table>
		</td>
	  </tr>
	</table>
</cfoutput>
