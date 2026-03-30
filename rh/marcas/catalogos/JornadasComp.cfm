<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#"
Default="Recursos Humanos"
VSgrupo="103"
returnvariable="nombre_modulo"/>

<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Comportamiento de Jornadas"
VSgrupo="103"
returnvariable="nombre_proceso"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
xmlfile="/rh/generales.xml"
returnvariable="vCodigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
xmlfile="/rh/generales.xml"
returnvariable="vDescripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Jornada"
Default="Jornada"
xmlfile="/rh/generales.xml"
returnvariable="vJornada"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Horas_Diarias"
Default="Horas Diarias"
returnvariable="vHorasDiarias"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_De"
Default="De"
returnvariable="vDE"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_A"
Default="A"
returnvariable="vA"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
xmlfile="/rh/generales.xml"
returnvariable="vFiltrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Limpiar"
Default="Limpiar"
xmlfile="/rh/generales.xml"
returnvariable="vLimpiar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Agregar"
Default="Agregar"
xmlfile="/rh/generales.xml"
returnvariable="vAgregar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Modificar"
Default="Modificar"
xmlfile="/rh/generales.xml"
returnvariable="vModificar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Eliminar"
Default="Eliminar"
xmlfile="/rh/generales.xml"
returnvariable="vEliminar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Nuevo"
Default="Nuevo"
xmlfile="/rh/generales.xml"
returnvariable="vNuevo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Fecha_Rige"
Default="Fecha Rige"
xmlfile="/rh/generales.xml"
returnvariable="vFechaRige"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Fecha_Vence"
Default="Fecha Vence"
xmlfile="/rh/generales.xml"
returnvariable="vFechaVence"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Comportamiento"
Default="Comportamiento"
xmlfile="/rh/generales.xml"
returnvariable="vComportamiento"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Tiempo_min"
Default="Tiempo"
returnvariable="vTiempo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Antes_de_Entrada"
Default="Antes de Entrada"
returnvariable="vAntesdeEntrada"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Despues_de_Entrada"
Default="Despues de Entrada"
returnvariable="vDespuesdeEntrada"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Antes_de_Salida"
Default="Antes de Salida"
returnvariable="vAntesdeSalida"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Despues_de_Salida"
Default="Despues de Salida"
returnvariable="vDespuesdeSalida"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Periodo_de_Tiempo"
Default="Per&iacute;odo de Tiempo"
returnvariable="vPeriodo"/>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nombre_modulo#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>

		<script type="text/javascript" language="javascript1.2">
			function limpiar(){
				document.filtro.fRHJcodigo.value = '';
				document.filtro.fRHJdescripcion.value = '';
			}
		</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">		    	            <cfif isdefined("Url.RHJid") and not isdefined("Form.RHJid")>
			<cfset Form.RHJid = Url.RHJid>
		            </cfif>
	              <cfif isdefined("Form.RHJid")>
			<cfset modo = "CAMBIO">
		<cfelse>
			<cfset modo = "ALTA">
		            </cfif>
	              <cfif isdefined("Form.RHCJid")>
			<cfset modoDet = "CAMBIO">
		<cfelse>
			<cfset modoDet = "ALTA">
		            </cfif>
                  <cf_web_portlet_start titulo="#nombre_proceso#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<form style="margin: 0" name="filtro" method="post">
							<table border="0" width="100%" class="areaFiltro">
							  <tr> 
								<td><cfoutput>#vCodigo#</cfoutput></td>
								<td><cfoutput>#vDescripcion#</cfoutput></td>
							  </tr>
							  <tr> 
								<td><input type="text" name="fRHJcodigo" value="<cfif isdefined("form.fRHJcodigo") and len(trim(form.fRHJcodigo)) gt 0 ><cfoutput>#form.fRHJcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();" ></td>
								<td><input type="text" name="fRHJdescripcion" value="<cfif isdefined("form.fRHJdescripcion") and len(trim(form.fRHJdescripcion)) gt 0 ><cfoutput>#form.fRHJdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
								<td><input type="submit" name="Filtrar" value="<cfoutput>#vFiltrar#</cfoutput>"><input type="button" name="Limpiar" value="<cfoutput>#vLimpiar#</cfoutput>" onClick="javascript:limpiar();"></td>
							  </tr>
							</table>
						  </form>						

						<cfset filtro = '' >
						<cfif isdefined("form.fRHJcodigo") and len(trim(form.fRHJcodigo))>
							<cfset filtro = filtro & " and upper(RHJcodigo) like '%#ucase(form.fRHJcodigo)#%' " >
						</cfif>
						<cfif isdefined("form.fRHJdescripcion") and len(trim(form.fRHJdescripcion))>
							<cfset filtro = filtro & " and upper(RHJdescripcion) like '%#ucase(form.fRHJdescripcion)#%' " >
						</cfif>
						
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHJornadas"/>
							<cfinvokeargument name="columnas" value="RHJid, {fn concat({fn concat(rtrim(RHJcodigo), ' - ')}, RHJdescripcion)} as Jornada, RHJhoradiaria, RHJhoraini, RHJhorafin"/>
							<cfinvokeargument name="desplegar" value="Jornada, RHJhoradiaria, RHJhoraini, RHJhorafin"/>
							<cfinvokeargument name="etiquetas" value="#vJornada#, #vHorasDiarias#, #vDe#, #vA#"/>
							<cfinvokeargument name="formatos" value="V, F, H, H"/>
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro#"/>
							<cfinvokeargument name="align" value="left, left, center, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="JornadasComp.cfm"/>
							<cfinvokeargument name="maxRows" value="0"/>
							<cfinvokeargument name="keys" value="RHJid"/>
						</cfinvoke>
					</td>
					<cfif modo EQ "CAMBIO">
					<td width="50%" valign="top" align="left">
						<cfinclude template="JornadasComp-form.cfm">
					</td>
					</cfif>
				</tr>
			</table>
	<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>