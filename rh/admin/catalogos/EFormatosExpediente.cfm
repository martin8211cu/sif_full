
<table width="100%" cellpadding="0" cellspacing="0" style="padding-left: 5px; padding-right: 5px;">
<!--- <table width="98%" cellpadding="0" cellspacing="0" class="sectionTitle2" style="padding-left: 5px; padding-right: 5px;"> --->
	
	<!--- <tr><td class="<cfoutput>#session.preferences.skin#_thcenter</cfoutput>" colspan="2" align="center">Encabezado de Formatos de Expediente</td></tr> --->

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
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_TipoDeExpediente"
				Default="Tipo de Expediente"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_TipoDeExpediente"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Fecha"
				Default="Fecha"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Fecha"/>

			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEmpl">
				<cfinvokeargument name="tabla" value="EFormatosExpediente a, TipoExpediente b"/>
				<cfinvokeargument name="columnas" value="#form.TEid# as TEid, EFEid, EFEcodigo, EFEdescripcion, TEdescripcion, EFEfecha, 'CAMBIO' as ef_modo "/>
				<cfinvokeargument name="desplegar" value="EFEcodigo,EFEdescripcion,TEdescripcion,EFEfecha"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_TipoDeExpediente#,#LB_Fecha#"/>
				<cfinvokeargument name="formatos" value="S,S,S,D"/>
				<cfinvokeargument name="formName" value="lista"/>	
				<cfinvokeargument name="filtro" value="a.TEid=#form.TEid# and b.CEcodigo=#session.CEcodigo# and a.TEid=b.TEid order by EFEcodigo"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="FormatosPrincipal.cfm"/>
				<cfinvokeargument name="keys" value="TEid,EFEid"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		
		<td width="50%" valign="top">
			<cfinclude template="form-EFormatosExpediente.cfm">
		</td>
		
	</tr>
	
	<cfoutput>
	<form name="formRegresar" method="post"	>
		<input name="TEid" value="#Form.TEid#" type="hidden">
		<input name="modo" value="" type="hidden">						
	</form>
	</cfoutput>		
</table>