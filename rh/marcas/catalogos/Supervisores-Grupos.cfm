<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td width="40%" valign="top" align="left"> 			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="C&oacute;digo"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				returnvariable="LB_Descripcion"/>
						
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="RHCMGrupos"/>
				<cfinvokeargument name="columnas" value="Gid, Gcodigo, Gdescripcion"/>
				<cfinvokeargument name="desplegar" value="Gcodigo, Gdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# order by Gdescripcion"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Supervisores-tabs.cfm?tab=1"/>
				<cfinvokeargument name="keys" value="Gid"/>
				<cfinvokeargument name="maxRows" value="15"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="Gcodigo,Gdescripcion"/>				
			</cfinvoke>
		</td>
		<td width="60%" valign="top">
			<cfinclude template="Supervisores-Grupos-form.cfm">
		</td>
	</tr>
</table>

