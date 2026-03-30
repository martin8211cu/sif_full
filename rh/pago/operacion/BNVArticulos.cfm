<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_BNVArticulo" default="Art&iacute;culos Presupuestales de BN Vital" returnvariable="LB_BNVArticulo" component="sif.Componentes.Translate" method="Translate"/>	 
<cfinvoke key="LB_COD_ARTICULO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_COD_EGRESO" default="Egreso" xmlfile="/rh/generales.xml" returnvariable="LB_COD_EGRESO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_COD_ARTICULO_REM" default="Remplazo" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO_REM" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
         
<cf_web_portlet_start titulo="#LB_BNVArticulo#">
	<table width="600" border="0" cellspacing="0" cellpadding="0">
		<tr valign="top"> 
			<td width="450"> 
				<!-------------------------------------------------------------- Filtro -------------------------------------------------------------->	
				<cfif isDefined("Url.Fcod_articulo") and not isDefined("Form.Fcod_articulo")>
					<cfset Form.Fcod_articulo = Url.Fcod_articulo>
				</cfif>
				<cfif isDefined("Url.Fdescripcion") and not isDefined("Form.Fdescripcion")>
					<cfset Form.Fdescripcion = Url.Fdescripcion>
				</cfif>
				<cfif isDefined("Url.fcodigo_rem") and not isDefined("Form.fcodigo_rem") >
					<cfset Form.fcodigo_rem = Url.fcodigo_rem >
				</cfif>

				<cfset filtro = "1=1">
				<cfset navegacion = "">

				<cfset camposExtra = ''>
				<cfif isdefined("Form.Fcod_articulo") and Len(Trim(Form.Fcod_articulo)) NEQ 0>
					<cfset filtro = filtro & " and upper(cod_articulo) like '%" & #UCase(Form.Fcod_articulo)# & "%'">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fcod_articulo=" & Form.Fcod_articulo>
					<cfset camposExtra = ", '#form.Fcod_articulo#' as Fcod_articulo" >
				</cfif>

				<cfif isdefined("Form.Fcod_egreso") and Len(Trim(Form.Fcod_egreso)) NEQ 0>
					<cfset filtro = filtro & " and upper(cod_egreso) like '%" & #UCase(Form.Fcod_egreso)# & "%'">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fcod_egreso=" & Form.Fcod_egreso>
					<cfset camposExtra = ", '#form.Fcod_egreso#' as Fcod_egreso" >
				</cfif>
				
				<cfif isdefined("Form.Fdescripcion") and Len(Trim(Form.Fdescripcion)) NEQ 0>
					<cfset filtro = filtro & " and upper(desc_articulo) like '%" & #UCase(Form.Fdescripcion)# & "%'">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fdescripcion=" & Form.Fdescripcion>
					<cfset camposExtra = camposExtra & ", '#form.Fdescripcion#' as Fdescripcion" >
				</cfif>

				<cfif isdefined("Form.fcodigo_rem") and Len(Trim(Form.fcodigo_rem)) gt 0>
					<cfset filtro = filtro & " and cod_articulo_remp = #form.fcodigo_rem# " >
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fcodigo_rem=" & form.fcodigo_rem >
					<cfset camposExtra = camposExtra & ", '#form.fcodigo_rem#' as fcodigo_rem" >
				</cfif>


				<form style="Margin:0" action="BNVArticulos.cfm" method="post" name="filtro">
					<table border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					  <tr>
						<cfoutput>
						<td nowrap class="fileLabel">#LB_COD_ARTICULO#</td>
						<td nowrap class="fileLabel">#LB_DESCRIPCION#</td>
						<td nowrap class="fileLabel">#LB_COD_EGRESO#</td>
						<td nowrap class="fileLabel">#LB_COD_ARTICULO_REM#</td>
						</cfoutput>
						<td nowrap>
							<input name="butFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
						</td>
					  </tr>
					  <tr>
						<td nowrap>
							<input name="Fcod_articulo" type="text" size="5" maxlength="5" value="<cfif isDefined("Fcod_articulo")><cfoutput>#Form.Fcod_articulo#</cfoutput></cfif>">
						</td>
						<td nowrap>
							<input name="Fdescripcion" type="text" size="20" maxlength="80" value="<cfif isDefined("Fdescripcion")><cfoutput>#Form.Fdescripcion#</cfoutput></cfif>">
						</td>
						<td nowrap>
							<input name="Fcod_egreso" type="text" size="5" maxlength="5" value="<cfif isDefined("Fcod_egreso")><cfoutput>#Form.Fcod_egreso#</cfoutput></cfif>">
						</td>
						<td>
							<input name="Fcodigo_rem" type="text" size="5" maxlength="5" value="<cfif isDefined("Fcodigo_rem")><cfoutput>#Form.Fcodigo_rem#</cfoutput></cfif>">
						</td>
						<td nowrap>
							<input name="resButton" type="button" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="document.filtro.Fcod_articulo.value=''; document.filtro.Fdescripcion.value=''; document.filtro.Fcod_egreso.value=''; document.filtro.fcodigo_rem.value='';">
						</td>
					  </tr>
					</table>
				</form>
				<!------------------------------------------------------------------------------------------------------------------------------------>	
				<cfinvoke component="rh.Componentes.pListas"  method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="Conexion" 	value="sifinterfaces"/>
					<cfinvokeargument name="tabla" 		value="INTP_Articulos_BNV"/>
					<cfinvokeargument name="columnas" 	value="cod_articulo, desc_articulo, cod_egreso,cod_articulo_remp"/>
					<cfinvokeargument name="desplegar" 	value="cod_articulo, desc_articulo, cod_egreso,cod_articulo_remp"/>
					<cfinvokeargument name="etiquetas" 	value="#LB_COD_ARTICULO#,#LB_DESCRIPCION#,#LB_COD_EGRESO#,#LB_COD_ARTICULO_REM#"/>
					<cfinvokeargument name="formatos" 	value=""/>
					<cfinvokeargument name="filtro" 	value="#filtro# order by cod_articulo"/>
					<cfinvokeargument name="align" 		value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" 	value=""/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" 		value="BNVArticulos.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="keys"		value="cod_articulo"/>
					<cfinvokeargument name="fontsize"	value="10"/>
					<cfinvokeargument name="MaxRows"	value="10"/>
					
				</cfinvoke>
			</td>
			<td width="60%"><cfinclude template="BNVArticulos-form.cfm"></td>
		</tr>
		<tr valign="top"><td>&nbsp;</td><td>&nbsp;</td></tr>
	</table>
<cf_web_portlet_end>
		