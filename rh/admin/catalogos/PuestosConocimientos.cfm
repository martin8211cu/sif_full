<!--- modificado con notepad --->
<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
<cfinvoke key="LB_Conocimientos" default="Conocimientos" returnvariable="LB_Conocimientos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Inactivo" default="Inactivo" returnvariable="LB_Inactivo" component="sif.Componentes.Translate" method="Translate"/>	
</cfsilent>
<cf_templateheader title="#LB_Conocimientos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cfset filtro = "a.Ecodigo = #Session.Ecodigo#">	              
			<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHCcodigo like '%#ucase(form.fRHCcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(RHCdescripcion) like '%#ucase(form.fRHCdescripcion)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHCcodigo">
			<cfif isdefined('url.RHCid') and not isdefined('form.RHCid')><cfset form.RHCid = url.RHCid></cfif>
			<cf_web_portlet_start titulo="#LB_Conocimientos#">
				<cfif isdefined("url.RHCcodigo") and not isdefined("form.RHCcodigo")>
					<cfset form.RHCcodigo = url.RHCcodigo >
				</cfif>
				<cfif isdefined("url.modo") and not isdefined("form.modo")>
					<cfset form.modo = url.modo >
				</cfif>
				<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarStatusText = ArrayNew(1)>
				<cfset navBarItems[1] = "Administración de Puestos">
				<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
				<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="50%">
							<form style="margin:0" name="filtro" method="post">
								<table border="0" width="100%" class="titulolistas">
								  <tr> 
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
									<td><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
								  </tr>
								  <tr> 
									<td><input type="text" name="fRHCcodigo" tabindex="1" value="<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0 ><cfoutput>#form.fRHCcodigo#</cfoutput></cfif>" size="5" maxlength="5" onfocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHCdescripcion" tabindex="1" value="<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0 ><cfoutput>#form.fRHCdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onfocus="javascript:this.select();" ></td>
								  </tr>	
								  <tr>
									<td colspan="2" align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>			
							<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="RHConocimientos a"/>
								<cfinvokeargument name="columnas" value="RHCid, RHCcodigo, 
												case when len(RHCdescripcion) > 60 
												then {fn concat(substring(RHCdescripcion,1,57),'...')}
												else RHCdescripcion end RHCdescripcion,
												case coalesce(RHCinactivo,0)  when 0 then 
													'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
												else 
													'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
												end as RHCinactivo"/>
								<cfinvokeargument name="desplegar" value="RHCcodigo, RHCdescripcion,RHCinactivo"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#,#LB_Inactivo#"/>
								<cfinvokeargument name="formatos" value="V, V, V"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left, left, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="PuestosConocimientos.cfm"/>
								<cfinvokeargument name="keys" value="RHCid"/>
								<cfinvokeargument name="maxrows" value="25"/>
							</cfinvoke>
						</td>
						<td width="50%" valign="top"><cfinclude template="formPuestosConocimientos.cfm"></td>
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHCcodigo.value = '';
					document.filtro.fRHCdescripcion.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>