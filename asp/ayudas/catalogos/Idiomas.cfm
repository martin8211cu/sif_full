<cf_templateheader title="Idiomas">
<cf_web_portlet_start titulo="Idiomas">
	<cfinclude template="/home/menu/pNavegacion.cfm">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top">
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Idiomas"/>
				<cfinvokeargument name="columnas" value="Iid, Icodigo, Descripcion, Inombreloc"/>
				<cfinvokeargument name="desplegar" value="Icodigo, Descripcion, Inombreloc"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción, Locale"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="1=1 order by Icodigo, Descripcion"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Idiomas.cfm"/>
				<cfinvokeargument name="Conexion" value="sifcontrol"/>
			</cfinvoke>
		</td>
		<td valign="top">
			<cfinclude template="Idiomas_form.cfm">
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	
<cf_web_portlet_end>
<cf_templatefooter>
