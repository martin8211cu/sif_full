<cf_templateheader title="Ajustes de Inventario">
		<!--- Mantiene la navegacion de la lista de detalles --->
		<cfif isdefined("url.EAid") and not isdefined("form.EAid")>
			<cfset form.EAid = url.EAid >
		</cfif>
		<cfif isdefined("url.modo") and not isdefined("form.modo")>
			<cfset form.modo = url.modo >
		</cfif>	                
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajustes'>
			<cfinclude template="formAjustes.cfm">
			<cfif isdefined('Form.EAid') and Form.EAid NEQ "">
				<cfset navegacion = "EAid=#form.EAid#&modo=CAMBIO" >
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="DAjustes a, Articulos b"/>
					<cfinvokeargument name="columnas" value="a.EAid, a.DALinea, b.Adescripcion, a.DAcantidad, a.DAcosto, (case a.DAtipo when 1 then 'Salida' when 0 then 'Entrada' end) as Tipo"/>
					<cfinvokeargument name="desplegar" value="Adescripcion, Tipo, DAcantidad, DAcosto"/>
					<cfinvokeargument name="etiquetas" value="Art&iacute;culo, Tipo, Cantidad, Costo"/>
					<cfinvokeargument name="formatos" value="V, V, M, M"/>
					<cfinvokeargument name="filtro" value="a.Aid = b.Aid and a.EAid = #form.EAid# order by b.Adescripcion" />
					<cfinvokeargument name="align" value="left, left, rigth, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="Ajustes.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="DALinea,EAid"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			<cfelse>
				<cfif not isdefined('form.btnNuevo')>
					<cflocation addtoken="no" url='listaAjuste.cfm'>
				</cfif>
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>