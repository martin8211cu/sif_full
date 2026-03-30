<cfset navegacion ="">
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td>
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista"
				returnvariable="rsLista"
					columnas			= " OCOid, 
											OCOnumero, 
											OCOfecha, 
											a.CFformato,
											'#LvarOCOtipoOD#' as OCOtipoOD, m.Miso4217, OCOtotalOrigen
										"
					tabla				= "OCotros oc 
											inner join CFinanciera a on a.CFcuenta= oc.CFcuenta
											inner join Monedas m on m.Mcodigo = oc.Mcodigo"
					filtro				= "oc.Ecodigo=#Session.Ecodigo# and OCOtipoOD='#LvarOCOtipoOD#' and OCOfechaAplicacion is null
										   order by 2,3"
					Desplegar			= "OCOnumero, OCOfecha, CFformato, Miso4217, OCOtotalOrigen"
					Etiquetas			= "Número, Fecha, Cuenta Financiera, Moneda, Total"
					Formatos			= "S,D,S,S,M"
					Align				= "left,center,left,center,center"
					Ajustar 			= "S"
					checkboxes			= "S"
					maxrows				= "20"
					mostrar_filtro		= "true"
					filtrar_automatico  = "true"

					IrA					= "OC_OTROS_#LvarOCOtipoOD#O.cfm"
					Navegacion 			= "#navegacion#"
					Botones				= "Nuevo, Aplicar, Ver_Aplicacion"
					IncluyeForm			= "yes"
					FormName			= "form1"
					Keys				= "OCOid"
					showEmptyListMsg	= "true"
					/>
		</td>
	</tr>
</table>
<script language="javascript">
	function funcAplicar()
	{
		document.form1.action = "OC_OTROS_sql.cfm";
	}
	function funcVer_Aplicacion()
	{
		document.form1.action = "OC_OTROS_sql.cfm";
	}
</script>