<cfif isdefined("url.REid") and not isdefined("form.REid")>
	<cfset form.REid = url.REid >
</cfif>
<cfparam name="form.sel" default="3" type="numeric">
<cfparam name="form.Estado" default="0" type="string">

<cfset navegacion = '&REid=#form.REid#&sel=4&Estado=#form.Estado#' >

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" width="40%">
				<cfinvoke 	component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHGruposRegistroE a"/>
					<cfinvokeargument name="columnas" value="a.GREid,a.GREnombre,REid,4 as sel,'#form.Estado#' as Estado"/>
					<cfinvokeargument name="desplegar" value="GREnombre"/>
					<cfinvokeargument name="etiquetas" value="Grupo"/>
					<cfinvokeargument name="formatos" value="S"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.REid = #form.REid#"/>
					<cfinvokeargument name="align" value="left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
					<cfinvokeargument name="keys" value="GREid">
					<cfinvokeargument name="formName" value="listaGrupos">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="No se encontraron registros">
					<cfinvokeargument name="navegacion" value="#navegacion#">
					<cfinvokeargument name="maxrows" value="0">
				</cfinvoke>
			</td>	
			<td width="60%" valign="top">
				<table width="100%" cellpadding="2" cellspacing="">
					<tr><td><cfinclude template="registro_evaluacion_grupos-form.cfm"></td></tr>
					<cfif isdefined("modo") and modo neq 'ALTA'>
						<tr><td><cfinclude template="registro_evaluacion_grupos_cf.cfm"></td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		
		
	</table>	
