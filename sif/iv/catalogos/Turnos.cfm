<cf_templateheader title="Turnos">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Turnos'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	</tr>
	<tr>
		<td valign="top" width="50%">
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
			<cfif isdefined('url.filtro_Codigo_turno') and not isdefined('form.filtro_Codigo_turno')>
				<cfset form.filtro_Codigo_turno = url.filtro_Codigo_turno>
			</cfif>			
			<cfif isdefined('url.filtro_Tdescripcion') and not isdefined('form.filtro_Tdescripcion')>
				<cfset form.filtro_Tdescripcion = url.filtro_Tdescripcion>
			</cfif>			
			<cfif isdefined('url.Turno_id') and not isdefined('form.Turno_id')>
				<cfset form.Turno_id = url.Turno_id>
			</cfif>
						
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="25">					
								
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Turnos"/>
				<cfinvokeargument name="columnas" value="Turno_id
														,Codigo_turno
														,Tdescripcion"/> 
				<cfinvokeargument name="desplegar" value="Codigo_turno
														,Tdescripcion"/> 
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/> 
				<cfinvokeargument name="formatos" value="S,S"/> 
				<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
														order by Tdescripcion"/> 
				<cfinvokeargument name="align" value="left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="Turnos.cfm"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Turno_id"/> 
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>																													
			</cfinvoke>			
		</td>
		<td valign="top" width="50%" align="center">
			<cfinclude template="formTurnos.cfm">
		</td>
	</tr>
</table>
		<cf_web_portlet_end>
	<cf_templatefooter>

			


