<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default="#session.DSN#"> 		<!--- Nombre de la conexión --->
<cfparam name="Attributes.empresa" type="string" default="#session.Ecodigo#"> 	<!--- empresa --->
<cfparam name="Attributes.form" default="form1" type="String"> 					<!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> 					<!--- consulta por defecto --->

<cf_templatecss>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
		<cfif isdefined("Attributes.query.ECodigo") and len(trim(Attributes.query.ECodigo))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Empresa">Empresa</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Edescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAid") and len(trim(Attributes.query.RHAid))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Accion_Masiva">Acci&oacute;n Masiva</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.RHAdescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAfdesde") and len(trim(Attributes.query.RHAfdesde))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate></td>
				<td height="25" nowrap>#LSDateFormat(Attributes.query.RHAfdesde,'dd/mm/yyyy')#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAfhasta") and len(trim(Attributes.query.RHAfhasta))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate></td>
				<td height="25" nowrap>#LSDateFormat(Attributes.query.RHAfhasta,'dd/mm/yyyy')#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.DEid") and len(trim(Attributes.query.DEid))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.DEnombre#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHCPlinea") and len(trim(Attributes.query.RHCPlinea))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_CategoriaPuesto">Categor&iacute;a/Puesto</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.RHMPPdescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.Ocodigo") and len(trim(Attributes.query.Ocodigo))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Oficina">Oficina</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Odescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.Dcodigo") and len(trim(Attributes.query.Dcodigo))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Ddescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHPcodigo") and len(trim(Attributes.query.RHPcodigo))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Puesto">Puesto</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.RHPdescpuesto#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.Tcodigo") and len(trim(Attributes.query.Tcodigo))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Tdescripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAporc") and len(trim(Attributes.query.RHAporc))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
				<td height="25" nowrap><cfif Attributes.query.RHAporc NEQ "">#LSCurrencyFormat(Attributes.query.RHAporc,'none')# %<cfelse>0.00 %</cfif></td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAporcsal") and len(trim(Attributes.query.RHAporcsal))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_salario_fijo">Porcentaje de Salario Fijo</cf_translate></td>
				<td height="25" nowrap><cfif Attributes.query.RHAporcsal NEQ "">#LSCurrencyFormat(Attributes.query.RHAporcsal,'none')# %<cfelse>0.00 %</cfif></td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RVid") and len(trim(Attributes.query.RVid))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Regimen_de_vacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Descripcion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHAvdisf") and len(trim(Attributes.query.RHAvdisf))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Vacaciones_por_disfrutar">Vacaciones por disfrutar</cf_translate></td>
				<td height="25" nowrap>#Attributes.query.RHAvdisf#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMreconocido") and len(trim(Attributes.query.RHEAMreconocido))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Reconocido">Reconocido</cf_translate></td>
				<td height="25" nowrap>
					<input name="RHEAMreconocido" type="checkbox"<cfif Attributes.query.RHEAMreconocido EQ 1>checked</cfif> disabled >
				</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMjustificacion") and len(trim(Attributes.query.RHEAMjustificacion))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate></td>
				<td height="25">#Attributes.query.RHEAMjustificacion#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMusuarior") and len(trim(Attributes.query.RHEAMusuarior))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Reconocido_por">Reconocido por </cf_translate></td>
				<td height="25" nowrap>#Attributes.query.Usuario#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMfecha") and len(trim(Attributes.query.RHEAMfecha))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
				<td height="25" nowrap>#LSDateFormat(Attributes.query.RHEAMfecha,'dd/mm/yyyy')#</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMrevaluado") and len(trim(Attributes.query.RHEAMrevaluado))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Reevaluado">Reevaluado</cf_translate></td>
				<td height="25" nowrap>
					<input name="RHEAMrevaluado" type="checkbox"<cfif Attributes.query.RHEAMrevaluado EQ 1>checked</cfif> disabled>
				</td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMevaluacion") and len(trim(Attributes.query.RHEAMevaluacion))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_evaluacion">Porcentaje de Evaluaci&oacute;n</cf_translate></td>
				<td height="25" nowrap><cfif Attributes.query.RHEAMevaluacion NEQ "">#LSCurrencyFormat(Attributes.query.RHEAMevaluacion,'none')# %<cfelse>0.00 %</cfif></td>
			</tr>
		</cfif>
		<cfif isdefined("Attributes.query.RHEAMfuevaluacion") and len(trim(Attributes.query.RHEAMfuevaluacion))>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Fecha_de_ultima_evaluacion">Fecha de &Uacute;ltima Evaluaci&oacute;n</cf_translate></td>
				<td height="25" nowrap>#LSDateFormat(Attributes.query.RHEAMfuevaluacion,'dd/mm/yyyy')#</td>
			</tr>			
		</cfif>
	</table>
</cfoutput>
