<cfinclude template="Subfactores-translate.cfm">
<cf_templateheader title="#LB_Factores#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
        	<cfif not isdefined('form.RHHFid') and isdefined('url.RHHFid') and len(trim(url.RHHFid))>
            	<cfset form.RHHFid = url.RHHFid>
            </cfif>
		    <td valign="top">
			<cfset filtro = "a.RHHFid = #form.RHHFid# ">	              
			<cfif isdefined("form.fRHHSFcodigo") and len(trim(form.fRHHSFcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHHSFcodigo like '%#ucase(form.fRHHSFcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHHSFdescripcion") and len(trim(form.fRHHSFdescripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(RHHSFdescripcion) like '%#ucase(form.fRHHSFdescripcion)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHHSFcodigo">
				
			<cf_web_portlet_start titulo="#nombre_proceso#">
				<cfif isdefined("url.RHHSFcodigo") and not isdefined("form.RHHSFcodigo")>
					<cfset form.RHHSFcodigo = url.RHHSFcodigo >
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
									<td><input type="text" name="fRHHSFcodigo" tabindex="1" value="<cfif isdefined("form.fRHHSFcodigo") and len(trim(form.fRHHSFcodigo)) gt 0 ><cfoutput>#form.fRHHSFcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHHSFdescripcion" tabindex="1" value="<cfif isdefined("form.fRHHSFdescripcion") and len(trim(form.fRHHSFdescripcion)) gt 0 ><cfoutput>#form.fRHHSFdescripcion#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
									<td  align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>		
		
							<cfquery name="rsTotales" datasource="#session.DSN#">
								select sum(RHHSFponderacion) as RHHSFponderacion ,sum(RHHSFpuntuacion) as RHHSFpuntuacion
								from RHHSubfactores
                                where RHHFid = #form.RHHFid#
							</cfquery>
							<cf_dbfunction name="length" args="RHHSFdescripcion" returnvariable="RHHSFdescripcion_length">
							<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
							<cf_dbfunction name="sPart" args="RHHSFdescripcion,1,57" returnvariable="RHHSFdescripcion_sPart">
							<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet"> 
								<cfinvokeargument name="tabla" value="RHHSubfactores a"/>
								<cfinvokeargument name="columnas" value="a.RHHFid,a.RHHSFid, RHHSFcodigo, 
												case when #preservesinglequotes(RHHSFdescripcion_length)# > 60 
												then #preservesinglequotes(RHHSFdescripcion_sPart)# #_CAT# '...'
												else RHHSFdescripcion end RHHSFdescripcion,RHHSFponderacion,RHHSFpuntuacion"/>
								<cfinvokeargument name="desplegar" value="RHHSFcodigo,RHHSFdescripcion,RHHSFponderacion,RHHSFpuntuacion"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Ponderacion#, #LB_RHHSFpuntuacion#"/>
								<cfinvokeargument name="formatos" value="V,V,M,M"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left,left,Right,Right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="Subfactores.cfm"/>
								<!--- <cfinvokeargument name="totales" value="RHHSFponderacion,RHHSFpuntuacion"/> --->
								<cfinvokeargument name="keys" value="RHHFid,RHHSFid"/>
								<cfinvokeargument name="maxrows" value="30"/>
							</cfinvoke>
							<fieldset><legend><cf_translate key="LB_Totales" >Totales</cf_translate></legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.RHHSFponderacion,'____.__')#</cfoutput>&nbsp;<b>%</b>&nbsp;&nbsp;
										<cfif rsTotales.RHHSFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>	
										<cfelseif rsTotales.RHHSFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>
										<cfelseif rsTotales.RHHSFponderacion gt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>									
										</cfif>
									</td>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_RHHSFpuntuacion" >Puntuaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.RHHSFpuntuacion,',.__')#</cfoutput></td>
								</tr>
								<tr>
									<td colspan="4" valign="bottom">
										<cfif rsTotales.RHHSFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>&nbsp;&nbsp;<cf_translate key="LB_PonderacionIdeal" >Ponderaci&oacute;n ideal</cf_translate>	
										<cfelseif rsTotales.RHHSFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>&nbsp;&nbsp;<cf_translate key="LB_LaPonderacionEsMenorAl100" >La ponderaci&oacute;n es menor al 100 %</cf_translate>	
										<cfelseif rsTotales.RHHSFponderacion gt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>&nbsp;&nbsp;<cf_translate key="LB_LaPonderacionEsMayorAl100" >La ponderaci&oacute;n es mayor al 100 %</cf_translate>										
										</cfif>
									</td>
								</tr>
							</table>
							</fieldset>
							
							
							
							
						</td>
						<td width="50%" valign="top"><cfinclude template="formSubfactores.cfm"></td>
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHHSFcodigo.value = '';
					document.filtro.fRHHSFdescripcion.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>