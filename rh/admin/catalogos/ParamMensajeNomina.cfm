<cf_templatecss>
<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;		  
		 } </style>
<cfset imgV = "<img border='0' src='/cfmx/rh/imagenes/checked.gif'>">
<cfoutput>
<table>
	<tr><td>&nbsp;</td></tr>
	<tr class="tituloAlterno">
		<td>
			Valores del concepto de pago
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			Para que el concepto de pago sea elegible para el ajuste automático de salario negativo es necesario que tenga
			las siguientes opciones marcadas:
		</td>
	</tr>
	<tr>
		<td>
			#imgV#&nbsp;No conciderar para la proyección de renta en el cálculo de Nómina
		</td>
	</tr>
	<tr>
		<td>
			#imgV#&nbsp;No aplica renta
		</td>
	</tr>
	<tr>
		<td>
			#imgV#&nbsp;No aplica deducciones
		</td>
	</tr>
	<tr>
		<td>
			#imgV#&nbsp;No aplica cargas
		</td>
	</tr>
	<tr>
		<td>
			#imgV#&nbsp;No aplica cargas de ley
		</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
</table>
</cfoutput>
