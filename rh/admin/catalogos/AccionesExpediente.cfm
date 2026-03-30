<table width="98%" cellpadding="0" cellspacing="0" style="padding-left: 5px; padding-right: 5px;">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="C&oacute;digo"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Accion"
				Default="Acci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Accion"/>

			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="AccionesTipoExpediente a, RHTipoAccion b"/>
				<cfinvokeargument name="columnas" value="a.TEid, a.EFEid, b.RHTid, b.RHTcodigo, b.RHTdesc, 'CAMBIO' as ef_modo, 'CAMBIO' as ac_modo"/>
				<cfinvokeargument name="desplegar" value="RHTcodigo, RHTdesc"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Accion#"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="a.TEid = #Form.TEid# and a.EFEid=#form.EFEid# and b.Ecodigo = #Session.Ecodigo# and a.RHTid = b.RHTid"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="irA" value="FormatosPrincipal.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="formName" value="listaAccion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		
		<td width="50%" valign="top">
			<cfinclude template="form-AccionesExpediente.cfm">
		</td>
		
	</tr>
</table>