<title>

</title>	
<cf_templatecss>
<cf_web_portlet_start titulo="Asiento de Ajuste">

<table border="0" align="center" width="95%">
<tr>
	<td colspan="2" align="center"><strong>Activos que se van a Ajustar</strong></td>
</tr>
<tr>
	<td colspan="2">
	
		<table border="0" align="center">
		<tr>
			<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
			<td><cfoutput>#URL.concepto#</cfoutput></td>
			<td><strong>Periodo:&nbsp;&nbsp;</strong></td>
			<td><cfoutput>#URL.periodo#</cfoutput></td>
		</tr>			
		<tr>
			<td width="10%"><strong>Documento:&nbsp;&nbsp;</strong></td>
			<td width="90%"><cfoutput>#URL.edocumento#</cfoutput></td>
			<td><strong>Mes:&nbsp;&nbsp;</strong></td>
			<td><cfoutput>#URL.mes#</cfoutput></td>
		</tr>
		</table>

	</td>
</tr>
<tr>
	<td colspan="2"><hr></td>
</tr>
<tr>
	<td colspan="2">
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			columnas="  a.GATperiodo, 
						a.GATmes, 
						a.Cconcepto, 
						a.Edocumento,
						a.GATplaca, 
						a.CFid,
						a.OcodigoAnt, 
						a.Ocodigo,
						b.Oficodigo,
						c.Oficodigo as OficodigoAnt,
						rtrim(ltrim(cf.CFcodigo)) #_Cat# '-' #_Cat# rtrim(ltrim(cf.CFdescripcion)) as Centro,
						a.GATmonto"
			tabla="GATransacciones a
						inner join Oficinas b
							on b.Ocodigo = a.Ocodigo
						   and b.Ecodigo = a.Ecodigo
						inner join Oficinas c
							on c.Ocodigo = a.OcodigoAnt
						   and c.Ecodigo = a.Ecodigo
						inner join CFuncional cf
							on cf.CFid 	  = a.CFid
						   and cf.Ecodigo = a.Ecodigo
					"
			filtro=" a.Ecodigo = #SESSION.ECODIGO#						
					  and a.OcodigoAnt is not null
					  and a.Ocodigo != a.OcodigoAnt
					  and a.GATperiodo = #URL.periodo#
					  and a.GATmes = #URL.mes#
					  and a.Cconcepto = #URL.concepto#
					  and a.Edocumento = #URL.edocumento#						
					"	
			desplegar="GATplaca, Centro, OficodigoAnt, Oficodigo, GATmonto"
			etiquetas="Placa, Centro Funcional, Oficina Anterior, Oficina Actual, Monto"
			formatos="S, S, S, S, M"
			align="left, left, left, left, left"
			irA=""
			keys="GATperiodo, GATmes, Cconcepto, Edocumento"
			checkboxes="N"
			showLink="false"
			botones=""
			mostrar_filtro="false"
			filtrar_automatico="false"
			debug="N"
		/>
	
	</td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
	<td colspan="2" align="center"><input type="button" name="btnclose" class="btnNormal" value="Cerrar" onClick="javascript:window.close()"></td>
</tr>
</table>

<cf_web_portlet_end>