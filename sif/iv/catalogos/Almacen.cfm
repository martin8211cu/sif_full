<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<cfif isdefined("url.Aid") and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">		

<cf_templateheader title="Inventarios">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Almacenes'>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td valign="top" width="40%" align="center">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 				value="Almacen"/>
						<cfinvokeargument name="columnas" 			value="Aid, rtrim(Almcodigo) as Almcodigo, Bdescripcion"/>
						<cfinvokeargument name="desplegar" 			value="Almcodigo, Bdescripcion"/>
						<cfinvokeargument name="etiquetas" 			value="C&oacute;digo, Almac&eacute;n"/>
						<cfinvokeargument name="formatos" 			value="S,S"/>
						<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo# order by Almcodigo, Bdescripcion"/>
						<cfinvokeargument name="align" 				value="left, left"/>
						<cfinvokeargument name="ajustar" 			value="N,N"/>
						<cfinvokeargument name="checkboxes" 		value="N"/>
						<cfinvokeargument name="irA" 				value="Almacen.cfm"/>
						<cfinvokeargument name="keys" 				value="Aid"/>
						<cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/>	
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="mostrar_filtro" 	value="true"/>
						<cfinvokeargument name="filtrar_por" 		value="Almcodigo, Bdescripcion"/>
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>									
					</cfinvoke>
				</td>
				<td valign="top" width="60%" align="center">
					<cfinclude template="formAlmacen.cfm">
					<cfif isdefined("Form.Aid") and form.Aid NEQ ''>
						<table width="100%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td align="center">
									<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Responsables por Almac&eacute;n'>
										<cfinclude template="formAResponsables.cfm">
									<cf_web_portlet_end>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="center">
									<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Almacenes Cercanos'>
										<cfinclude template="formACercanos.cfm">
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>