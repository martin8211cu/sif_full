<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Filtrar"
xmlfile="/rh/generales.xml"	
Default="Filtrar"
returnvariable="BTN_Filtrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Codigo"
xmlfile="/rh/generales.xml"	
Default="Codigo"
returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Descripcion"
xmlfile="/rh/generales.xml"	
Default="Descripci&oacute;n"
returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Equipos"
Default="Administraci&oacute;n de Equipos"
returnvariable="LB_Administracion_de_Equipos"/>	
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Nuevo"
xmlfile="/rh/generales.xml"	
Default="Nuevo"
returnvariable="BTN_Nuevo"/>	
	<cf_templateheader title="#LB_Administracion_de_Equipos#">
	<cfoutput> 
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<script language="javascript" type="text/javascript">
		function funcCancelar3() {
			showList(false);
		}
	</script>
	
								
	<cfset filtro = " 1=1 ">
		<cfif isdefined("form.Ecodigo") and len(trim(form.Ecodigo)) gt 0 >
		<cfset filtro = filtro & " and upper(Ecodigo) like '%#ucase(form.Ecodigo)#%' " >
		</cfif>
		<cfif isdefined("form.Edescripcion") and len(trim(form.Edescripcion)) gt 0 >
		<cfset filtro = filtro & " and upper(Edescripcion) like '%#ucase(form.Edescripcion)#%' " >
		</cfif>
	<cf_web_portlet_start titulo="#LB_Administracion_de_Equipos#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  
	  
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">

			<form name="filtroCuentas" method="post" action="Equipos-form.cfm">
				
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				  <tr> 
			<td width="27%" height="17" class="fileLabel"><cfoutput>#LB_Codigo#</cfoutput></td>
			<td width="68%" class="fileLabel"><cfoutput>#LB_Descripcion#</cfoutput></td>
			<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
					</tr>
				<tr> 
				<td><input name="Ecodigo" type="text" id="Ecodigo" size="30" maxlength="60" value="<cfif isdefined('form.Ecodigo')><cfoutput>#form.Ecodigo#</cfoutput></cfif>"></td>
				<td><input name="Edescripcion" type="text" id="Edescripcion" size="100" maxlength="260" value="<cfif isdefined('form.Edescripcion')><cfoutput>#form.Edescripcion#</cfoutput></cfif>"></td>
											</tr>
	 </table>
				
			</form>
		</td>
  	</tr>
	<tr style="display: ;" id="verLista"> 
          				  		<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  		<tr>
											<td>
			<cfquery name="rsLista" datasource="#session.DSN#">
									select Edescripcion, Ecodigo
									from Equipo
									where 
									#PreserveSingleQuotes(filtro)#
									order by Ecodigo
								
	  </cfquery>	
	
								<cfinvoke 
											component="rh.Componentes.pListas"
								 			method=	"pListaQuery"
								 			returnvariable="pListaEmpl">
								 			<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="Ecodigo, Edescripcion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
											<cfinvokeargument name="formatos" value="V,V"/>
											<cfinvokeargument name="align" value="left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="irA" value="Equipos-form.cfm"/>
											<cfinvokeargument name="keys" value="EDid"/>
											</cfinvoke>
												</td>
												</tr>
												<tr>
												<td align="center">
	 <form name="formNuevoEmplLista" method="post" action="Equipos-form.cfm">
													<input type="hidden" name="Pantalla" value="1">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
												</form>
												</td>
												</tr>
												</table>
						
	</cfoutput> 
	</table><cf_web_portlet_end> 
<cf_templatefooter>