<!--- modificado con notepad --->
<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_GradosParaElFactor"
	Default="Grados para el factor"
	returnvariable="LB_GradosParaElFactor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puntuacion"
	Default="Puntuaci&oacute;n"
	returnvariable="LB_Puntuacion"/>	

	
</cfsilent>

<cfquery name="rsTitulo" datasource="#session.DSN#">
	select 
	{fn concat(upper(rtrim(RHFcodigo)),{fn concat(' ',RHFdescripcion)})} as titulo
	from RHFactores 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
</cfquery>


<cf_templateheader title="#LB_GradosParaElFactor#&nbsp;&nbsp;( #rsTitulo.titulo# )">
	<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cfset filtro = "a.RHFid = #form.RHFid# ">	              
			<cfif isdefined("form.fRHGcodigo") and len(trim(form.fRHGcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHGcodigo like '%#ucase(form.fRHGcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHGdescripcion") and len(trim(form.fRHGdescripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(RHGdescripcion) like '%#ucase(form.fRHGdescripcion)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHGporcvalorfactor">
				
			<cf_web_portlet_start titulo="#LB_GradosParaElFactor#&nbsp;&nbsp;( #rsTitulo.titulo# )">
				<cfif isdefined("url.RHGcodigo") and not isdefined("form.RHGcodigo")>
					<cfset form.RHGcodigo = url.RHGcodigo >
				</cfif>
				<cfif isdefined("url.modo") and not isdefined("form.modo")>
					<cfset form.modo = url.modo >
				</cfif>
				
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="50%">
							<form style="margin:0" name="filtro" method="post">
								<table border="0" width="100%" class="titulolistas">
								  <tr > 
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
									<td colspan="3"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
								  </tr>
								  <tr nowrap="nowrap"> 
									<td><input type="text" name="fRHGcodigo" tabindex="1" value="<cfif isdefined("form.fRHGcodigo") and len(trim(form.fRHGcodigo)) gt 0 ><cfoutput>#form.fRHGcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHGdescripcion" tabindex="1" value="<cfif isdefined("form.fRHGdescripcion") and len(trim(form.fRHGdescripcion)) gt 0 ><cfoutput>#form.fRHGdescripcion#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
									<td  align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>		
		
							<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="RHGrados a"/>
								<cfinvokeargument name="columnas" value="RHFid,RHGid,RHGcodigo, 
												case when len(RHGdescripcion) > 60 
												then {fn concat(substring(RHGdescripcion,1,57),'...')}
												else RHGdescripcion end RHGdescripcion,RHGporcvalorfactor"/>
								<cfinvokeargument name="desplegar" value="RHGcodigo,RHGdescripcion,RHGporcvalorfactor"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Puntuacion#"/>
								<cfinvokeargument name="formatos" value="V,V,M"/>
								<cfinvokeargument name="filtro" value="#filtro# "/>
								<cfinvokeargument name="align" value="left,left,Right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="Grados.cfm"/>
								<cfinvokeargument name="keys" value="RHFid,RHGid"/>
								<cfinvokeargument name="maxrows" value="30"/>
							</cfinvoke>
						</td>
						<td width="50%" valign="top"><cfinclude template="formGrados.cfm"></td>
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHGcodigo.value = '';
					document.filtro.fRHGdescripcion.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>