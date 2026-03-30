<!--- modificado con notepad --->
<!--- Sección de Etiquetas de Traducción --->


<cfsilent>
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Factores"
	Default="Factores"
	returnvariable="LB_Factores"/>
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
	Key="LB_Ponderacion"
	Default="Ponderaci&oacute;n"
	returnvariable="LB_Ponderacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puntuacion"
	Default="Puntuaci&oacute;n"
	returnvariable="LB_Puntuacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Grados"
	Default="Grados"
	returnvariable="LB_Grados"/>
	
</cfsilent>
<cf_templateheader title="#LB_Factores#">
	<cfinclude template="/rh/Utiles/params.cfm">
	
	<!--- 
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0> 
	--->
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cfset filtro = "a.Ecodigo = #Session.Ecodigo#">	              
			<cfif isdefined("form.fRHFcodigo") and len(trim(form.fRHFcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHFcodigo like '%#ucase(form.fRHFcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHFdescripcion") and len(trim(form.fRHFdescripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(RHFdescripcion) like '%#ucase(form.fRHFdescripcion)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHFcodigo">
				
			<cf_web_portlet_start titulo="#LB_Factores#">
				<cfif isdefined("url.RHFcodigo") and not isdefined("form.RHFcodigo")>
					<cfset form.RHFcodigo = url.RHFcodigo >
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
									<td><input type="text" name="fRHFcodigo" tabindex="1" value="<cfif isdefined("form.fRHFcodigo") and len(trim(form.fRHFcodigo)) gt 0 ><cfoutput>#form.fRHFcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHFdescripcion" tabindex="1" value="<cfif isdefined("form.fRHFdescripcion") and len(trim(form.fRHFdescripcion)) gt 0 ><cfoutput>#form.fRHFdescripcion#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
									<td  align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>		
		
							<cfquery name="rsTotales" datasource="#session.DSN#">
								select 
								sum(RHFponderacion) as RHFponderacion ,sum(Puntuacion) as Puntuacion
								from RHFactores 
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
		
							<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="RHFactores a"/>
								<cfinvokeargument name="columnas" value="a.RHFid, RHFcodigo, 
												case when len(RHFdescripcion) > 60 
												then {fn concat(substring(RHFdescripcion,1,57),'...')}
												else RHFdescripcion end RHFdescripcion,RHFponderacion,Puntuacion,
												grados =(select count(*) from RHGrados g where a.RHFid = g.RHFid)"/>
								<cfinvokeargument name="desplegar" value="RHFcodigo,RHFdescripcion,RHFponderacion,Puntuacion,grados"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Ponderacion#, #LB_Puntuacion#,#LB_Grados#"/>
								<cfinvokeargument name="formatos" value="V,V,M,M,V"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left,left,Right,Right,Right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="Factores.cfm"/>
								<!--- <cfinvokeargument name="totales" value="RHFponderacion,Puntuacion"/> --->
								<cfinvokeargument name="keys" value="RHFid"/>
								<cfinvokeargument name="maxrows" value="30"/>
							</cfinvoke>
							<fieldset><legend><cf_translate key="LB_Totales" >Totales</cf_translate></legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.RHFponderacion,'____.__')#</cfoutput>&nbsp;<b>%</b>&nbsp;&nbsp;
										<cfif rsTotales.RHFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>	
										<cfelseif rsTotales.RHFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>
										<cfelseif rsTotales.RHFponderacion gt 100>
											<img src="/cfmx/rh/imagenes/stop2.gif"/>									
										</cfif>
									</td>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_Puntuacion" >Puntuaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.Puntuacion,',.__')#</cfoutput></td>
								</tr>
								<tr>
									<td colspan="4" valign="bottom">
										<cfif rsTotales.RHFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>&nbsp;&nbsp;<cf_translate key="LB_PonderacionIdeal" >Ponderaci&oacute;n ideal</cf_translate>	
										<cfelseif rsTotales.RHFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>&nbsp;&nbsp;<cf_translate key="LB_LaPonderacionEsMenorAl100" >La ponderaci&oacute;n es menor al 100 %</cf_translate>	
										<cfelseif rsTotales.RHFponderacion gt 100>
											<img src="/cfmx/rh/imagenes/stop2.gif"/>&nbsp;&nbsp;<cf_translate key="LB_LaPonderacionEsMayorAl100" >La ponderaci&oacute;n es mayor al 100 %</cf_translate>										
										</cfif>
									</td>
								</tr>
							</table>
							</fieldset>
							
							
							
							
						</td>
						<td width="50%" valign="top"><cfinclude template="formFactores.cfm"></td>
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHFcodigo.value = '';
					document.filtro.fRHFdescripcion.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>