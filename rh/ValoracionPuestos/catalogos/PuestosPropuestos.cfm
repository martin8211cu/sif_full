<cfsilent>
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosPropuestos"
	Default="Puestos Propuestos"
	returnvariable="LB_PuestosPropuestos"/>
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

<!--- <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Grados"
	Default="Grados"
	returnvariable="LB_Grados"/> --->
	
</cfsilent>
<cf_templateheader title="#LB_PuestosPropuestos#">
	<cfinclude template="/rh/Utiles/params.cfm">

	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cfset filtro = "a.Ecodigo = #Session.Ecodigo# and RHPropuesto = 1 and RHPactivo = 0">	              
			<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0 >
				<cfset filtro = filtro & " and RHPcodigo like '%#ucase(form.fRHPcodigo)#%' " >
			</cfif>
			<cfif isdefined("form.fRHPdescpuesto") and len(trim(form.fRHPdescpuesto)) gt 0 >
				<cfset filtro = filtro & " and upper(RHPdescpuesto) like '%#ucase(form.fRHPdescpuesto)#%' " >
			</cfif>
			<cfset filtro = filtro & " order by RHPcodigo">
				
			<cf_web_portlet_start titulo="#LB_PuestosPropuestos#">
				<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
					<cfset form.RHPcodigo = url.RHPcodigo >
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
									<td><input type="text" name="fRHPcodigo" tabindex="1" value="<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0 ><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHPdescpuesto" tabindex="1" value="<cfif isdefined("form.fRHPdescpuesto") and len(trim(form.fRHPdescpuesto)) gt 0 ><cfoutput>#form.fRHPdescpuesto#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
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
								<cfinvokeargument name="tabla" value="RHPuestos a"/>
								<cfinvokeargument name="columnas" value="RHPcodigo, 
												case when len(RHPdescpuesto) > 60 
												then {fn concat(substring(RHPdescpuesto,1,57),'...')}
												else RHPdescpuesto end RHPdescpuesto"/>
								<cfinvokeargument name="desplegar" value="RHPcodigo,RHPdescpuesto"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
								<cfinvokeargument name="formatos" value="V,V"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="align" value="left,left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="PuestosPropuestos.cfm"/>
								<cfinvokeargument name="keys" value="RHPcodigo"/>
								<cfinvokeargument name="maxrows" value="30"/>
							</cfinvoke>
						</td>
						<td width="50%" valign="top"><cfinclude template="formPuestosPropuestos.cfm"></td>
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHPcodigo.value = '';
					document.filtro.fRHPdescpuesto.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>