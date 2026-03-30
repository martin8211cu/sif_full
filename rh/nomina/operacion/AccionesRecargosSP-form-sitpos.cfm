<cfif RHTcomportam eq 11> <!--- antigüedad --->
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		  <tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td>
		  </tr>
		  <tr>
			<td height="25"  width="10%" class="fileLabel" nowrap><cf_translate key="LB_FechaAntiguiedad">Fecha de antig&uuml;edad</cf_translate></td>
			<td height="25" nowrap>
				<cfif isdefined("sololectura") and sololectura eq false>
					<cfif isdefined("rsAccion") and len(trim(rsAccion.EVfantig))>
						<cf_sifcalendario value="#LSDateFormat(rsAccion.EVfantig, 'DD/MM/YYYY')#" name="EVfantig_prop" tabindex="1">	</td>
					<cfelse>
						<cf_sifcalendario value="" name="EVfantig_prop" tabindex="1">	</td>
					</cfif>
				<cfelse>
					#LSDateFormat(rsAccion.EVfantig, 'DD/MM/YYYY')#
				</cfif>	
		  </tr>
		</table>
	</cfoutput>
<cfelse> <!--- anotación --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Positiva"
		Default="Positiva"
		returnvariable="vPositiva"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Negativa"
		Default="Negativa"
		returnvariable="vNegativa"/>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		  <tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td>
		  </tr>
		  <tr>
			<td height="25" width="10%" class="fileLabel" nowrap><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
			<td height="25" nowrap>
				#LSDateFormat(rsAccion.DLfvigencia, 'DD/MM/YYYY')#
			</td>
		  </tr>
		  <tr>
			<td height="25" width="10%" class="fileLabel" nowrap><cf_translate key="LB_Tipo">Tipo</cf_translate></td>
			<td height="25" nowrap>
				<select name="RHAtipo" id="RHAtipo" <cfif isdefined("sololectura") and sololectura > disabled</cfif>>
				  <option value="1" <cfif isdefined("rsAccion") and rsAccion.RHAtipo EQ 1>selected</cfif>>#vPositiva#</option>
				  <option value="2" <cfif isdefined("rsAccion") and rsAccion.RHAtipo EQ 2>selected</cfif>>#vNegativa#</option>
				</select>
			</td>
		  </tr>
		  <tr>
			<td height="25" width="10%" valign="top" class="fileLabel" nowrap><cf_translate key="LB_TextoDeLaAnotacion">Texto de la anotaci&oacute;n</cf_translate></td>
			<td height="25" nowrap>
				<textarea name="RHAdescripcion" cols="60" rows="10" id="textarea" onkeyup="ok(1023,this)"  <cfif isdefined("sololectura") and sololectura > disabled</cfif>><cfif isdefined("rsAccion") and len(trim(rsAccion.RHAdescripcion))>#rsAccion.RHAdescripcion#</cfif></textarea>
			</td>
		  </tr>
		</table>
	</cfoutput>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_El_texto_supera_la_cantidad_de_caracteres_permitidos"
	Default="El texto supera la cantidad de caracteres permitidos"
	returnvariable="LB_El_texto_supera_la_cantidad_de_caracteres_permitidos"/>


<script language="JavaScript" type="text/javascript">
 function ok(maxchars,obj) {
 if(obj.value.length > maxchars) {
   alert('<cfoutput>#LB_El_texto_supera_la_cantidad_de_caracteres_permitidos#</cfoutput>' )
   	obj.value = obj.value.substring(0,maxchars) 
   
   }
}	
	
</script>
