<cfif isdefined("url.LPid") and not isdefined("form.LPid")>
	<cfset form.LPid = url.LPid >
</cfif>
<cfif isdefined("url.Cambio") and not isdefined("form.Cambio")>
	<cfset form.Cambio = url.Cambio >
</cfif>

<cf_templateheader title="Lista de Precios">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Lista de Precios">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinclude template="formListaPrecios.cfm">
					</td>
				</tr>
				<tr>
					<td>
						<cfif isdefined("form.LPid") and len(trim(form.LPid)) gt 0 >
							<cfset navegacion = "&LPid=#form.LPid#&Cambio=Cambio" >
						
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" form_method="get" keys="LPid,LPlinea" returnvariable="pListaRet">
								<cfinvokeargument name="tabla" 		value="DListaPrecios a, EListaPrecios b "/>
								<cfinvokeargument name="columnas" 	value="a.LPid, LPlinea, DLdescripcion, DLfechaini, DLfechafin, ( case LPtipo when 'A' then 'Artículos' when 'S' then 'Servicios' end) as LPtipo,   a.moneda, a.DLprecio"/>
								<cfinvokeargument name="desplegar" 	value="DLdescripcion, moneda, DLprecio,  DLfechaini, DLfechafin "/>
								<cfinvokeargument name="etiquetas" 	value="Descripción, Moneda,  Precio Cliente,Fecha Inicial, Fecha Final"/>
								<cfinvokeargument name="formatos" 	value="V, V, M, D, D"/>
								<cfinvokeargument name="filtro" 	value="a.LPid=#form.LPid# and a.Ecodigo=#session.Ecodigo# and a.LPid=b.LPid 
														order by LPtipo, DLdescripcion, a.moneda, DLfechaini desc, DLfechafin desc"/>
								<cfinvokeargument name="align" 		value="left, left,right, left, left"/>
								<cfinvokeargument name="ajustar" 	value="N"/>
								<cfinvokeargument name="checkboxes" value="n"/>
								<cfinvokeargument name="debug" 		value="N"/>								
								<cfinvokeargument name="Cortes" 	value="LPtipo"/>
								<cfinvokeargument name="irA" 		value="ListaPrecios.cfm"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
							</cfinvoke>
						</cfif>
					</td>
				</tr>
			</table>		  
		<cf_web_portlet_end>
<cf_templatefooter>  