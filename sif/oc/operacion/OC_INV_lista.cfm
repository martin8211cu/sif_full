<cfset navegacion ="">
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td>
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista"
				returnvariable="rsLista"
					columnas			= " OCIid, 
											OCInumero, 
											OCIfecha, 
											a.Bdescripcion as Almacen,
											'#LvarOCItipoOD#' as OCItipoOD,
											OCIobservaciones"
					tabla				= "OCinventario oc inner join Almacen a on a.Aid= oc.Alm_Aid"
					filtro				= "oc.Ecodigo=#Session.Ecodigo# and OCItipoOD='#LvarOCItipoOD#' and OCIfechaAplicacion is null
										   order by 2,3"
					Desplegar			= "OCInumero, OCIfecha, Almacen"
					Etiquetas			= "Número, Fecha, Almacén"
					Formatos			= "S,D,S"
					Align				= "left,center,left"
					Ajustar 			= "S"
					checkboxes			= "S"
					maxrows				= "20"
					mostrar_filtro		= "true"
					filtrar_automatico  = "true"
					filtrar_por			= "OCInumero, a.Bdescripcion, OCIfecha"

					IrA					= "OC_INV_#LvarOCItipoOD#I.cfm"
					Navegacion 			= "#navegacion#"
					Botones				= "Nuevo, Aplicar, Ver_Aplicacion"
					IncluyeForm			= "yes"
					FormName			= "form1"
					Keys				= "OCIid"
					showEmptyListMsg	= "true"
					/>
		</td>
	</tr>
</table>
<script language="javascript">
	function funcAplicar()
	{
		document.form1.action = "OC_INV_sql.cfm";
	}
	function funcVer_Aplicacion()
	{
		document.form1.action = "OC_INV_sql.cfm";
	}
</script>