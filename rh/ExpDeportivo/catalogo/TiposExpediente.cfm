<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="BTN_Filtrar"/>
																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Limpiar"
Default="Limpiar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="BTN_Limpiar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Expediente_Deportivo"
	Default="Expediente Deportivo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Expediente_Deportivo"/>

	<cf_templateheader title="#LB_Expediente_Deportivo#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TiposDeExpediente"
			Default="Tipos de Expediente"
			returnvariable="LB_TiposDeExpediente"/>
			
<script language="JavaScript1.2" type="text/javascript">
						function limpiar(){
						document.filtro.codigo.value = "";
						document.filtro.descripcion.value   = "";
													}
						</script>	
 <cfset filtro = "">
				<cfif isdefined("form.codigo") and len(trim(form.codigo)) gt 0 >
				<cfset filtro = filtro & " and upper(EDEXcod) like '%#ucase(form.codigo)#%' " >
				</cfif>
				<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) gt 0 >
				<cfset filtro = filtro & " and upper(EDEXdes) like '%#ucase(form.descripcion)#%' " >
				</cfif>
				<cfset filtro = filtro & "order by EDEXcod">	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
							<td valign="top">							
	  <cf_web_portlet_start titulo="#LB_TiposDeExpediente#">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 			 
							<tr> 
							  <td colspan="3" >
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								   
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
											

			<form name="filtro" method="post">
									<table border="0" width="100%" class="tituloListas">
											<tr> 
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate></td>
									<td colspan="2"><cf_translate key="LB_Descripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate></td>
											</tr>
											<tr> 
								<td><input type="text" name="codigo" tabindex="1" value="<cfif isdefined("form.codigo") 
								and len(trim(form.codigo)) gt 0 ><cfoutput>#form.codigo#</cfoutput></cfif>" 
								size="5" maxlength="5" onFocus="javascript:this.select();"></td>
								<td><input type="text" name="descripcion" tabindex="1" value="<cfif isdefined("form.descripcion")
								 and len(trim(form.descripcion)) gt 0 ><cfoutput>#form.descripcion#</cfoutput></cfif>"
								 size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td nowrap>
																
																<cfoutput>
																<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
																<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
																</cfoutput>
															</td>
														</tr>
										</table>
												</form>						
										
						</td>
														
					<cfquery name="rsLista" datasource="#session.DSN#">
									select EDEXid, EDEXcod, EDEXdes
									from EDExpediente
									where 1=1
									#PreserveSingleQuotes(filtro)#
								
						</cfquery>	
	  
			<cfif isdefined("url.EDEXid") and len(Trim(url.EDEXid))>
				<cfset Form.EDEXid = url.EDEXid>
			</cfif>
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Estructura Organizacional">
			<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">						
 		    <cfset regresar = "/cfmx/rh/indexEstructura.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
	
		<!---	<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="40%">--->
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
							

					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="EDEXcod, EDEXdes"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="V, V"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>				
						<cfinvokeargument name="irA" value="TiposExpediente.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="EDEXid"/>
					</cfinvoke>
 						
		<td width="50%" valign="top"><cfinclude template="formTiposExpediente.cfm"></td>
		</tr>
		</table>
		</td>
					
		</tr>
		</table> 
	  <cf_web_portlet_end>
<cf_templatefooter>      
