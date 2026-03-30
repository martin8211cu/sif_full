<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgregarCursos"
	Default="Agregar cursos"
	returnvariable="LB_AgregarCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccioneUnCursoDeLaOfertaInternaMostradaAquiAbajoPuedeRealizarBsquedasUsandoLosFitrosDeLaIzquierda"
	Default="Seleccione un curso de la oferta interna mostrada aqu&iacute; abajo. Puede realizar b&uacute;squedas usando los fitros de la izquierda."
	returnvariable="LB_SeleccioneUnCursoDeLaOfertaInternaMostradaAquiAbajoPuedeRealizarBsquedasUsandoLosFitrosDeLaIzquierda"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HagaClicEnElCursoDeseado"
	Default="Haga clic en el curso deseado"
	returnvariable="LB_HagaClicEnElCursoDeseado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CompleteLosDatosQueSeLeRequieran"
	Default="Complete los datos que se le requieran."
	returnvariable="LB_CompleteLosDatosQueSeLeRequieran"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0" style="border:1px solid black; background-color:CCCCCC ">
		<tr>
			<td valign="top" class="subtitulo">&nbsp;</td>
			<td colspan="2" class="subtitulo" style="font-size:16px">#LB_AgregarCursos#</td>
		</tr>
		<tr>
			<td rowspan="3" valign="top"><img src="info.gif" width="31" height="30"></td>
			<td valign="top">1. </td>
			<td valign="top">#LB_SeleccioneUnCursoDeLaOfertaInternaMostradaAquiAbajoPuedeRealizarBsquedasUsandoLosFitrosDeLaIzquierda#</td>
		</tr>
		<tr>
			<td valign="top"> 2. </td>
			<td valign="top">#LB_HagaClicEnElCursoDeseado#</td>
		</tr>
		<tr>
			<td valign="top">3. </td>
			<td valign="top">#LB_CompleteLosDatosQueSeLeRequieran#</td>
		</tr>
	</table>
</cfoutput>