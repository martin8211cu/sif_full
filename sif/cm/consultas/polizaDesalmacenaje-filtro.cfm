<!--- Tranbaja con los campos del filtro_rsEPD --->
<cfif isdefined("form.feoidorden") and len(form.feoidorden) eq 0><cfset form.feoidorden = "0"></cfif>
<cfif isdefined("form.fepdnumero") and len(trim(form.fepdnumero)) eq 0><cfset form.fepdnumero = ""></cfif>
<cfif isdefined("form.fsncodigo") and len(form.fsncodigo) eq 0><cfset form.fsncodigo = "0"></cfif>
<cfif isdefined("form.fcmaaid") and len(form.fcmaaid) eq 0><cfset form.fcmaaid = "0"></cfif>
<cfif isdefined("form.fcmaid") and len(form.fcmaid) eq 0><cfset form.fcmaid = "0"></cfif>
<cfparam name="form.feoidorden" default="0" type="numeric">
<cfparam name="form.fepdnumero" default="" type="string">
<cfparam name="form.fsncodigo" default="0" type="numeric">
<cfparam name="form.fcmaaid" default="0" type="numeric">
<cfparam name="form.fcmaid" default="0" type="numeric">
<cfif isdefined("url.feoidorden") and len(url.feoidorden) and url.feoidorden and form.feoidorden lte 0><cfset form.feoidorden = url.feoidorden></cfif>
<cfif isdefined("url.fepdnumero") and len(trim(url.fepdnumero)) gt 0 and len(trim(form.fepdnumero)) lte 0><cfset form.fepdnumero = url.fepdnumero></cfif>
<cfif isdefined("url.fsncodigo") and len(url.fsncodigo) and url.fsncodigo and form.fsncodigo lte 0><cfset form.fsncodigo = url.fsncodigo></cfif>
<cfif isdefined("url.fcmaaid") and len(url.fcmaaid) and url.fcmaaid and form.fcmaaid lte 0><cfset form.fcmaaid = url.fcmaaid></cfif>
<cfif isdefined("url.fcmaid") and len(url.fcmaid) and url.fcmaid and form.fcmaid lte 0><cfset form.fcmaid = url.fcmaid></cfif>
<cfset navegacion = "Lista=Lista">
<cfif form.feoidorden>
	<cfset navegacion = navegacion & "&feoidorden=" & form.feoidorden>
</cfif>
<cfif len(trim(form.fepdnumero)) gt 0>
	<cfset navegacion = navegacion & "&fepdnumero=" & form.fepdnumero>
</cfif>
<cfif form.fsncodigo>
	<cfset navegacion = navegacion & "&fsncodigo=" & form.fsncodigo>
</cfif>
<cfif form.fcmaaid>
	<cfset navegacion = navegacion & "&fcmaaid=" & form.fcmaaid>
</cfif>
<cfif form.fcmaid>
	<cfset navegacion = navegacion & "&fcmaid=" & form.fcmaid>
</cfif>
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
	<cfoutput>
	<form action="" method="post" name="form1">
		<tr>
				<td><strong>N&uacute;mero&nbsp;:&nbsp;</strong></td>
				<td><strong>Agencia Aduanal&nbsp;:&nbsp;</strong></td>
				<td><strong>Aduana&nbsp;:&nbsp;</strong></td>
				<td><strong>Exportador&nbsp;:&nbsp;</strong></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<input name='fEPDnumero' 
						type='text' 
						size='20' 
						maxlength='20' 
						onFocus=''
						onBlur=''
						onKeyUp=""
						value="<cfif len(trim(form.fepdnumero)) gt 0>#form.fepdnumero#<cfelse></cfif>">
				</td>
				<td>
					<select name="fCMAAid">
						<option value="0">Todos</option>
						<cfloop query="rsCMAgenciaAduanal">
							<option value="#CMAAid#" <cfif (form.fcmaaid and form.fcmaaid eq CMAAid)>selected</cfif>>
								#HTMLEditFormat(CMAAdescripcion)#
							</option>
						</cfloop>
					</select>
				</td>
				<td>
					<select name="fCMAid">
						<option value="0">Todos</option>
						<cfloop query="rsCMAduanas">
							<option value="#CMAid#" <cfif (form.fcmaid and form.fcmaid eq CMAid)>selected</cfif>>
								#HTMLEditFormat(CMAdescripcion)#
							</option>
						</cfloop>
					</select>
				</td>
				<td>
					<cfif (form.fsncodigo)>
						<cf_sifsociosnegocios2 sntiposocio="P" idquery="#form.fsncodigo#" sncodigo="fsncodigo">
					<cfelse>
						<cf_sifsociosnegocios2 sntiposocio="P" sncodigo="fsncodigo">
					</cfif>
				</td>
				<td align="right"><input type="submit" name="btnFiltrar" value="Filtrar"></td>
		</tr>
	</form>
	</cfoutput>
</table>