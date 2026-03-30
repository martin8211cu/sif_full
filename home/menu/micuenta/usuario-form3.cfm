<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inactivo"
	Default="Inactivo"
	returnvariable="LB_Inactivo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Temporal"
	Default="Temporal"
	returnvariable="LB_Temporal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Activo"
	Default="Activo"
	returnvariable="LB_Activo"/>
<!--- Consultas --->
<cfquery name="rsData" datasource="asp">
select 	a.id_direccion,
		a.datos_personales,
		a.Ufhasta,
		a.Uestado,
		rtrim(a.LOCIdioma) as LOCIdioma,
		a.Usulogin,
		(case when a.Uestado = 0 then '#LB_Inactivo#' 
			  when a.Uestado = 1 and a.Utemporal = 1 then '#LB_Temporal#' 
			  when a.Uestado = 1 and a.Utemporal = 0 then '#LB_Activo#' else '' end) as estado
	from Usuario a
	where a.Usucodigo =
<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfparam name="session.sitio.skinlist" default="">
<cfquery datasource="asp" name="myskin">
select skin, enterActionDefault
	from Preferencias
	where Usucodigo =
<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfquery name="rsIdiomas" datasource="sifcontrol">
select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>
<cfquery name="rsPais" datasource="asp">
select Ppais, Pnombre 
	from Pais
</cfquery>
<!--- leer skins del archivo css
<cfsetting enablecfoutputonly="yes">
	<cffile action="read" file="#  ExpandPath('/sif/css/web_portlet.css') #" variable="web_portlet_css">
	<cfset web_portlet_array = ListToArray(web_portlet_css, chr(10) & chr(13))>
	<cfset skin_array = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(web_portlet_array)#" index="i">
		<cfset skin_line = Trim(web_portlet_array[i])>
		<cfif Left(skin_line, 2) EQ "/*" and Right(skin_line,2) EQ "*/">
			<cfset skin_line = Trim(Mid(skin_line, 3, Len(skin_line) - 4))>
			<cfif ListLen(skin_line,":") EQ 3 AND ListGetAt(skin_line,1,":") EQ "name">
				<cfset ArrayAppend(skin_array, ListGetAt(skin_line, 3, ":") & "," & ListGetAt(skin_line, 2, ":"))>
			</cfif>
		</cfif>
	</cfloop>
	<cfset ArraySort(skin_array,"textnocase")>
<cfsetting enablecfoutputonly="no"> --->

<form name="form1" method="post" action="usuario-apply3.cfm" style="margin:0 ">
	<cfoutput>
		<table width="100%" border="0" align="left" cellpadding="0" cellspacing="4">
			<tr>
				<td class="tituloListas" colspan="2" align="center" nowrap> <cf_translate  key="LB_Preferencias">Preferencias</cf_translate> </td>
			</tr>
			<tr>
				<td align="right" nowrap class="etiquetaCampo"><cf_translate  key="LB_Idioma">Idioma</cf_translate>:&nbsp;</td>
				<td align="left" nowrap>
					<select name="LOCIdioma">
						<cfloop query="rsIdiomas">
							<option value="#rsIdiomas.LOCIdioma#"<cfif Trim(rsData.LOCIdioma) EQ Trim(rsIdiomas.LOCIdioma)> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<!----
			<tr>
				<td   align="right" nowrap class="etiquetaCampo" ><cf_translate  key="LB_CombinacionDeColores">Combinaci&oacute;n de colores</cf_translate>:&nbsp;</td>
				<td  align="left" nowrap><cfif Len(session.sitio.skinlist)>
						<cfset skinfound = false>
						<select name="skin">
							<option value=""> (<cf_translate key="LB_Predeterminada">Predeterminada</cf_translate>) </option>
							<cfloop list="#session.sitio.skinlist#" delimiters=";" index="color">
								<option value="#HTMLEditFormat(ListFirst(color))#"
					<cfif myskin.skin EQ ListFirst(color)>selected<cfset skinfound = true></cfif> > #HTMLEditFormat(ListRest(color))# </option>
							</cfloop>
							<cfif not skinfound>
								<cfif Len(Trim(myskin.skin))>
									<option value="#HTMLEditFormat(myskin.skin)#" selected="selected"> #HTMLEditFormat(myskin.skin)# </option>
								</cfif>
							</cfif>
						</select>
						<cfelse>
						<select name="skin_unica">
							<option value=""><cf_translate key="LB_Unica">&Uacute;nica</cf_translate></option>
						</select>
					</cfif>
				</td>
			</tr>----->
			<tr>
				<td align="right" class="etiquetaCampo" nowrap="true"><cf_translate  key="LB_AccionNormalAlPresionarLaTeclaEnter">Acci&oacute;n normal al&nbsp;&nbsp;<BR>presionar la tecla <strong>Enter</strong></cf_translate>:&nbsp;</td>
				<td align="left" nowrap>
					<select name="enterActionDefault">
						<option value="submit"<cfif Trim(myskin.enterActionDefault) EQ "submit" 
												 OR Trim(myskin.enterActionDefault) EQ ""> 		selected</cfif>><cf_translate  key="LB_submitAccionPrimerBotonSubmitDeLaForma">submit: Acci&oacute;n primer bot&oacute;n submit de la forma</cf_translate></option>
						<option value="tab"<cfif Trim(myskin.enterActionDefault) EQ "tab"> 		selected</cfif>><cf_translate  key="LB_TabSeleccionaSiguienteCampoEnLaPantalla">tab:	Selecciona siguiente campo en la pantalla</cf_translate></option>
						<option value="none"<cfif Trim(myskin.enterActionDefault) EQ "none"> 	selected</cfif>><cf_translate  key="LB_NoneNoEjecutaNingunaAccion">none:	No ejecuta ninguna acci&oacute;n</cf_translate></option>
					</select>
					<br><strong>(Ctrl+Enter: <cf_translate  key="LB_siempreEsAccionSubmit">siempre es Acci&oacute;n submit</cf_translate>)</strong>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap class="etiquetaCampo"><cf_translate  key="LB_FechaExpiracion">Fecha Expiraci&oacute;n</cf_translate>:&nbsp;</td>
				<td align="left" nowrap><cfoutput>#DateFormat(rsData.Ufhasta,'dd-mm-yyyy')#</cfoutput></td>
			</tr>
			<tr>
				<td align="right" nowrap class="etiquetaCampo"><cf_translate  key="LB_Estado">Estado</cf_translate>:&nbsp;</td>
				<td align="left">#rsData.estado#</td>
			</tr>
			<!---
				<tr>
              	<td align="right" nowrap>Estilo de Presentacin</td>
		      	<td align="left" nowrap><select name="skin_cfm">
                	<cfloop from="1" to="#ArrayLen(skin_array)#" index="i">
                  	<option value="#ListGetAt(skin_array[i],2)#" <cfif 
			ListGetAt(skin_array[i],2) EQ session.preferences.skin>selected</cfif>># ListGetAt(skin_array[i],1)#</option>
                	</cfloop>
              	</select></td>
				</tr>
--->
			<tr align="center">
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr align="center">
				<td colspan="2">
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Modificar"
				Default="Modificar"
				returnvariable="BTN_Modificar"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Restablecer"
				Default="Restablecer"
				returnvariable="BTN_Restablecer"/>
				
				
				<input name="Cambio" type="submit" class="btnGuardar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); " value="#BTN_Modificar#">
				<input name="Reset" type="reset" class="btnLimpiar" value="#BTN_Restablecer#"></td>
			</tr>
			<tr align="center">
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	</cfoutput>
</form>
