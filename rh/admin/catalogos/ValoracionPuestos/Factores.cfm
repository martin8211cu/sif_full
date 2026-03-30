<cfinclude template="Factores-translate.cfm">
<cf_templateheader title="#LB_Factores#">
	<cfinclude template="/rh/Utiles/params.cfm">
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cfset filtro = "1 = 1">	              
			<cfif isdefined("form.fRHHFcodigo") and len(trim(form.fRHHFcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHHFcodigo like '%#ucase(form.fRHHFcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHHFdescripcion") and len(trim(form.fRHHFdescripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(RHHFdescripcion) like '%#ucase(form.fRHHFdescripcion)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHHFcodigo">
				
			<cf_web_portlet_start titulo="#nombre_proceso#">
				<cfif isdefined("url.RHHFid") and not isdefined("form.RHHFid")>
					<cfset form.RHHFid = url.RHHFid >
					<cfset form.modo = 'CAMBIO'>
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
									<td><input type="text" name="fRHHFcodigo" tabindex="1" value="<cfif isdefined("form.fRHHFcodigo") and len(trim(form.fRHHFcodigo)) gt 0 ><cfoutput>#form.fRHHFcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHHFdescripcion" tabindex="1" value="<cfif isdefined("form.fRHHFdescripcion") and len(trim(form.fRHHFdescripcion)) gt 0 ><cfoutput>#form.fRHHFdescripcion#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
									<td  align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>		
		
							<cfquery name="rsTotales" datasource="#session.DSN#">
								select 
								sum(RHHFponderacion) as RHHFponderacion ,sum(RHHFpuntuacion) as RHHFpuntuacion
								from RHHFactores 
							</cfquery>
							<cf_dbfunction name="length" args="RHHFdescripcion" returnvariable="RHHFdescripcion_length">
							<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
							<cf_dbfunction name="sPart" args="RHHFdescripcion,1,57" returnvariable="RHHFdescripcion_sPart">
							<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="RHHFactores a"/>
								<cfinvokeargument name="columnas" value="a.RHHFid, RHHFcodigo, 
												case when #preservesinglequotes(RHHFdescripcion_length)# > 60 
												then #preservesinglequotes(RHHFdescripcion_sPart)# #_CAT# '...'
												else RHHFdescripcion end RHHFdescripcion,RHHFponderacion,RHHFpuntuacion,
												(select count(1) from RHHSubfactores g where a.RHHFid = g.RHHFid) as Subfactores"/>
								<cfinvokeargument name="desplegar" value="RHHFcodigo,RHHFdescripcion,RHHFponderacion,RHHFpuntuacion,Subfactores"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Ponderacion#, #LB_RHHFpuntuacion#,#LB_Subfactores#"/>
								<cfinvokeargument name="formatos" value="V,V,M,M,V"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left,left,Right,Right,Right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="Factores.cfm"/>
								<cfinvokeargument name="keys" value="RHHFid"/>
								<cfinvokeargument name="maxrows" value="30"/>
							</cfinvoke>
							<fieldset><legend><cf_translate key="LB_Totales" >Totales</cf_translate></legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_Ponderacion" >Ponderaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.RHHFponderacion,'____.__')#</cfoutput>&nbsp;<b>%</b>&nbsp;&nbsp;
										<cfif rsTotales.RHHFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>	
										<cfelseif rsTotales.RHHFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>
										<cfelseif rsTotales.RHHFponderacion gt 100>
											<img src="/cfmx/rh/imagenes/stop2.gif"/>									
										</cfif>
									</td>
									<td width="20%" valign="bottom">
										<b>
								  		<cf_translate key="LB_RHHFpuntuacion" >Puntuaci&oacute;n:</cf_translate>
										</b>									</td>
									<td width="30%" valign="bottom"><cfoutput>#LSNumberFormat(rsTotales.RHHFpuntuacion,',.__')#</cfoutput></td>
								</tr>
								<tr>
									<td colspan="4" valign="bottom">
										<cfif rsTotales.RHHFponderacion eq 100>
											<img src="/cfmx/rh/imagenes/w-check.gif"/>&nbsp;&nbsp;<cf_translate key="LB_PonderacionIdeal" >Ponderaci&oacute;n ideal</cf_translate>	
										<cfelseif rsTotales.RHHFponderacion lt 100>
											<img src="/cfmx/rh/imagenes/stop.gif"/>&nbsp;&nbsp;<cf_translate key="LB_LaPonderacionEsMenorAl100" >La ponderaci&oacute;n es menor al 100 %</cf_translate>	
										<cfelseif rsTotales.RHHFponderacion gt 100>
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
					document.filtro.fRHHFcodigo.value = '';
					document.filtro.fRHHFdescripcion.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>