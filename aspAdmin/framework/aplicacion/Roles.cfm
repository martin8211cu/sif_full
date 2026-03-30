<table width="98%" cellpadding="0" cellspacing="0" style="padding-left: 5px; padding-right: 5px;">
	<tr>
		<td width="50%" valign="top">
			<cfset columnas = "convert(varchar, Rolcod) as Rolcod, sistema, rol, nombre, descripcion, Rolinfo, case empresarial when 1 then '<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>' end as empresarial, case interno when 1 then '<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>' end as interno" >
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Rol"/>
				<cfinvokeargument name="columnas" value="#columnas# , 'CAMBIO' as s_modo, 'CAMBIO' as r_modo"/>
				<cfinvokeargument name="desplegar" value="rol,nombre,empresarial,interno"/>
				<cfinvokeargument name="etiquetas" value="Rol,Nombre,Empresarial,Interno"/>
				<cfinvokeargument name="formatos" value="V,V,V,V"/>
				<cfinvokeargument name="filtro" value="sistema='#form.sistema#' and activo=1 order by rol"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="irA" value="SistemasPrincipal.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="formName" value="listaRol"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="keys" value="rol"/>
			</cfinvoke>
		</td>
		
		<td width="50%" valign="top">
			<cfinclude template="formRoles.cfm">
		</td>
		
	</tr>
</table>