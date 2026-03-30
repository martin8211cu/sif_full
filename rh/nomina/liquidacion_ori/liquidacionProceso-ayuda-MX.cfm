<style type="text/css">
.textoAyuda {
	font-family: Tahoma, sans-serif;
	font-size: 8pt;
	background-color: #EEEEEE;
	padding: 3px;
}
</style>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Ayuda"
Default="Ayuda"
returnvariable="LB_Ayuda"/> 

<cf_web_portlet_start titulo='#LB_Ayuda#'>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td class="ayuda">
		<cfoutput>
		<cfif GPaso EQ 0>
			<strong><cf_translate key="LB_Proceso_de_Liquidacion">Proceso de Liquidaci&oacute;n</cf_translate></strong><br>
			<cf_translate key="AYUDA_Proceso">Seleccione el funcionario cesado para confeccionar la Liquidaci&oacute;n. Esto lo llevar&aacute; al Paso 1.</cf_translate>
		<cfelseif GPaso EQ 1>
			<strong>#vOtrosIngresos#</strong><br>
			<cf_translate key="AYUDA_Otros_Ingresos">
			Aquí se registran otros rubros adicionales de tipo importe, que ser&aacute;n asociados a la liquidaci&oacute;n. 
			Una vez registrados estos rubros, seleccione el bot&oacute;n Siguiente. Esto lo llevar&aacute; al Paso 2.</cf_translate>
		<cfelseif GPaso EQ 2>
			<strong>#vPagosLF#</strong><br>
			Aquí se registran los conceptos de Liquidación y Finiquito.Una vez registrados estos rubros, seleccione el bot&oacute;n Siguiente. Esto lo llevar&aacute; al Paso 3
		<cfelseif GPaso EQ 3>
			<strong>#vCargas#</strong><br>
			<cf_translate key="AYUDA_Cargas">
			Aquí se registran las cargas sociales que se deben cancelar.
			Un ejemplo claro de esto es el aporte patronal que brinda la empresa y se lo da a la asociaci&oacute;n 
			para que esta sea quien maneje dicho aporte. Una vez registrados estos rubros, seleccione el bot&oacute;n 
			Siguiente. Esto lo llevar&aacute; al Paso 4.
			</cf_translate>
		<cfelseif GPaso EQ 4>
			<strong>#vDeducciones#</strong><br>
			<cf_translate key="AYUDA_Deducciones">
			Este paso consiste en registrar aquellos conceptos que el funcionario de una u 
			otra forma se comprometi&oacute; a cancelar durante su estancia dentro de la instituci&oacute;n. 
			Estos conceptos no se pueden rebajar de la liquidaci&oacute;n de acuerdo a lo que estipula la ley, es informativo para tesorería. 
			Una vez registrados estas deducciones, seleccione el bot&oacute;n 
			Siguiente. Esto lo llevar&aacute; al Paso 5.
			</cf_translate>
		<cfelseif GPaso EQ 5>
			<strong>#vAprobacion#</strong><br>
			<cf_translate key="AYUDA_Aprobacion">
			Esta aprobaci&oacute;n consiste en una verificaci&oacute;n final de cada uno de los rubros y 
			dar por finalizado el proceso de ingresos de rubros a la liquidaci&oacute;n. 
			Una vez verificados estas deducciones, seleccione el bot&oacute;n Aprobar.
			</cf_translate>
		</cfif>
		</cfoutput>
	</td>
  </tr>
</table>
<cf_web_portlet_end>
