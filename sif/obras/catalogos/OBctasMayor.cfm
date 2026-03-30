<cf_templateheader title="Mantenimiento de OBobraDocumentos">
	<cf_web_portlet_start titulo="Mantenimiento de Cuentas de Mayor de Control por Obras">
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">

		<cf_navegacion name="OBDid" default="" navegacion="">
		<table border="0" width="100%" align="center">
			<tr>
				<td width="20%">&nbsp;</td>
				<td colspan="3">
					<strong>Incluir Cuenta Mayor de Activo o Gasto:</strong>&nbsp;
				</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr>
			<form name="frmOBctasMayor" method="post" action="OBctasMayor_sql.cfm">
				<td>&nbsp;</td>
				<td nowrap="nowrap">
					<cf_conlis
						form="frmOBctasMayor"
						Campos="Cmayor, Cdescripcion"
						Desplegables="S,S"
						Modificables="S,N"
						Size="4,40"
	
						Title="Lista de Cuentas de Mayor"
						Tabla="CtasMayor m
								inner join CPVigencia v
								   on v.Ecodigo = m.Ecodigo
								  and v.Cmayor	= m.Cmayor
								  and #dateFormat(now(),'YYYYMM')# between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
								inner join PCEMascaras ms
								   on ms.PCEMid = v.PCEMid
								 "
						Columnas="
									case Ctipo
										when 'A' then 'Activos'
										when 'P' then 'Pasivos'
										when 'C' then 'Capital'
										when 'I' then 'Ingresos'
										when 'G' then 'Gastos'
									end as Tipo
									, m.Cmayor, m.Cdescripcion, m.PCEMid, ms.PCEMdesc, ms.PCEMformato
									, (
										select max(PCNid) 
										  from PCNivelMascara n
										 where n.PCEMid= ms.PCEMid
									   ) as MaxNivel
							"
						Filtrar_por="m.Cmayor, m.Cdescripcion"
						Filtro="
									m.Ecodigo = #session.Ecodigo# and m.Ctipo in ('A', 'G') 
									and not exists (select 1 from OBctasMayor where Ecodigo = Ecodigo and Cmayor = m.Cmayor)
									order by 1
								"
						Cortes="Tipo"
						Desplegar="Cmayor, Cdescripcion"
						Etiquetas="Mayor,Descripción"
						Formatos="S,S"
						Align="left,left"
	
						Asignar="Cmayor, Cdescripcion, PCEMid, PCEMdesc, PCEMformato, MaxNivel"
						Asignarformatos="S,S,S,S,S"
						MaxRowsQuery="200"
						OnBlur="this.value = right('0000'+this.value,4)"
						enterAction="submit"
					/>
					<script language="javascript">
						function right(LprmHilera, LprmLong)
						{
							var LvarTot = LprmHilera.length;
							return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
						}		 
					</script>
				</td>
				<td nowrap>
					<input type="checkbox" name="OBCcontrolCuentas" checked="checked"
							onclick="if (!this.checked) this.form.OBCliquidacion.checked = true;"
					>
					Control de Ctas,&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="OBCliquidacion" checked="checked"
							onclick="if (!this.checked) this.form.OBCcontrolCuentas.checked = true;"
					>
					Liquidacion&nbsp;&nbsp;&nbsp;
				</td>
				<td>
					<input type="submit" class="btnGuardar" name="btnAgregar" value="Agregar" />
				</td>
				<td>&nbsp;</td>
			</form>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3">
					<cfsavecontent variable="LvarImgBorrar">
							'<img src="/cfmx/sif/imagenes/Borrar01_S.gif" style="cursor:pointer; background-color:inherit;" onclick="return changeAccionform(1)">'
					</cfsavecontent>
					<cfsavecontent variable="LvarImgControlCtas">
						case when om.OBCcontrolCuentas = 1 
							then '<img src="/cfmx/sif/imagenes/checked.gif"		style="cursor:pointer; background-color:inherit;" onclick="return changeAccionform(2)">'
							else '<img src="/cfmx/sif/imagenes/unchecked.gif"	style="cursor:pointer; background-color:inherit;" onclick="return changeAccionform(3)">'
						end as  ControlCtas
					</cfsavecontent>
					<cfsavecontent variable="LvarImgLiquidacion">
						case when om.OBCliquidacion = 1 
							then '<img src="/cfmx/sif/imagenes/checked.gif"		style="cursor:pointer; background-color:inherit;" onclick="return changeAccionform(4)">'
							else '<img src="/cfmx/sif/imagenes/unchecked.gif"	style="cursor:pointer; background-color:inherit;" onclick="return changeAccionform(5)">'
						end as Liquidacion
					</cfsavecontent>

					<cfinvoke component="sif.Componentes.pListas" method="pLista"
						columnas="#PreserveSingleQuotes(LvarImgBorrar)# as Borrar, om.Ecodigo, om.Cmayor, cm.Cdescripcion, #LvarImgControlCtas#, #LvarImgLiquidacion#"
						tabla="OBctasMayor om inner join CtasMayor cm on cm.Ecodigo=om.Ecodigo and cm.Cmayor=om.Cmayor"
						filtro="om.Ecodigo = #session.Ecodigo#"
						desplegar="Borrar, Cmayor, Cdescripcion, ControlCtas, Liquidacion"
						etiquetas=" ,Mayor, Descripcion, Controlar<BR>Ctas en Obras, Liquidar<BR>Obras"
						formatos="S,S,S,S,S"
						align="center,center,left,center,center"
						ira="OBctasMayor_sql.cfm"
						keys="Ecodigo, Cmayor"
						formname="form1"
						mostrar_filtro="no"
						filtrar_automatico="yes"
		 				showEmptyListMsg="yes"
		 				EmptyListMsg="<BR><font color='##FF0000'>No existen Cuentas de Mayor en Control de Obras</font>"
					/>
					<script language="javascript">
						function changeAccionform(type)
						{
							if(type == 1)
								if(confirm('Esta seguro que desea Eliminar la cuenta de mayor?'))
								  {
									document.form1.action = "OBctasMayor_sql.cfm?btnBorrar=true";
									return true;
								  }
								else 
								  return false;
						   else if(type == 2)
						   	document.form1.action = "OBctasMayor_sql.cfm?op=del&btnControlCtas=true";
						   else if(type == 3)
							document.form1.action = "OBctasMayor_sql.cfm?op=add&btnControlCtas=true";
						   else if(type == 4)
						   	document.form1.action = "OBctasMayor_sql.cfm?op=del&btnLiquidacion=true";
						   else if(type == 5)
							document.form1.action = "OBctasMayor_sql.cfm?op=add&btnLiquidacion=true";
						return true;
						}
					</script>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
		<cf_qforms form="frmOBctasMayor" objForm="LobjQForm">
			<cf_qformsRequiredField args="Cmayor, Cuenta Mayor">
		</cf_qforms>
	<cf_web_portlet_end>
<cf_templatefooter>

