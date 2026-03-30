<!--- 
Creado por Jose Gutierrez 
	27/04/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Evaluar Categor&iacute;a')>
<cfset TIT_EvaluarCategoria 	= t.Translate('TIT_EvaluarCategoria','Evaluar Categor&iacute;a')>
<cfset LB_Periodo				= t.Translate('LB_Periodo','Mes a Evaluar')>
<cfset LB_ConsiderarSociosN		= t.Translate('LB_ConsiderarSociosN','Considerar Socios de Negocio Nuevos')>
<cfset LB_Nombre				= t.Translate('LB_Nombre','Nombre')>
<cfset LB_PromVentas			= t.Translate('LB_PromVentas','Promedio de Ventas')>
<cfset LB_CategoriaActual		= t.Translate('LB_CategoriaActual','Categor&iacute;a Actual')>
<cfset LB_CategoriaNueva 		= t.Translate('LB_CategoriaNueva', 'Categor&iacute;a Nueva')>
<cfset LB_Movimiento 			= t.Translate('LB_Movimiento', 'Movimiento')>
<cfset LB_Seleccione 			= t.Translate('LB_Seleccione', 'Seleccione')>
<cfset LB_Aplicar 				= t.Translate('LB_Aplicar', 'Aplicar')>
<cfset LB_Imprimir 				= t.Translate('LB_Imprimir', 'Imprimir')>
<cfset LB_SubioCat 				= t.Translate('LB_SubioCat', 'Subir&aacute; de categor&iacute;a')>
<cfset LB_BajoCat 				= t.Translate('LB_BajoCat', 'Bajar&aacute; de categor&iacute;a')>
<cfset LB_SinCambio 			= t.Translate('LB_SinCambio', 'No hay cambios')>
<cfset BTN_Filtrar	 			= t.Translate('BTN_Filtrar', 'Filtrar')>

<cfset This.C_PARAM_LIM_ESTADO_CUENTA_PROM = '30000705'>

<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_ESTADO_CUENTA_PROM#",conexion=#session.DSN#,ecodigo=#session.ecodigo#, descripcion="Recibir promociones de categoría hasta estado" )> 
<cfif paramInfo.valor eq ''>
	<cfthrow errorcode="#This.C_ERROR_LIM_ESTADO_CUENTA_PROM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
</cfif>
<cfset pLimiteEstadoCuentaPromosion = paramInfo.valor>

<cfset considera_nuevos = 0>
<cfif isDefined('form.considerarSNNuevos') and #form.considerarSNNuevos# eq '1'>
	<cfset considera_nuevos = 1>
</cfif>

<!--- Query para obtener registros a modificar categoria --->
<cfif isDefined('form.periodo') and #form.periodo# neq ''>
	<cfquery name="rsEvaluarCat" datasource="#session.DSN#" result="q_EvaluarCat">
		select 
			s.SNid, s.SNnombre,
			a.CRCCuentasid idCta,a.primera_venta, 
			b.Monto, 
			c.CRCCategoriaDistid,
			c.Numero,
			cd.Orden, cd.Descripcion,
			case when datediff(month,a.primera_venta,getdate()) >= #form.periodo#
				then round(b.Monto/#form.periodo#,2)
				else round(b.Monto/datediff(month,a.primera_venta,getdate()),2)
			end promedio_venta,
			nc.id idCat, nc.Orden Orden2, nc.Descripcion Descripcion2,
			ec.Descripcion as EstatusCuenta
		from (
			select t.CRCCuentasid, min(t.Fecha) primera_venta 
			from CRCTransaccion t 
			where t.TipoTransaccion = 'VC' 
			group by CRCCuentasid
		) a
		inner join (
			select sum(t.Monto) Monto, t.CRCCuentasid 
			from 
				CRCTransaccion t 
				where t.TipoTransaccion = 'VC'
					and datediff(month,t.fecha, getdate()) <= #form.periodo#
					and datediff(month,t.fecha, getdate()) > 0
			group by CRCCuentasid
		) b on a.CRCCuentasid = b.CRCCuentasid
		inner join CRCCuentas c on c.id = a.CRCCuentasid
		inner join CRCEstatusCuentas ec on c.CRCEstatusCuentasid = ec.id
		inner join SNegocios s on c.SNegociosSNid = s.SNid
		inner join CRCCategoriaDist cd on c.CRCCategoriaDistid = cd.id
		left join (
			select * from CRCCategoriaDist
		) nc on case when datediff(month,a.primera_venta,getdate()) >= #form.periodo#
					then round(b.Monto/#form.periodo#,2)
					else round(b.Monto/datediff(month,a.primera_venta,getdate()),2)
				end between nc.MontoMin and nc.MontoMax
		where (datediff(month,a.primera_venta,getdate()) >= #form.periodo# or #considera_nuevos# = 1)
			AND ec.Orden <
				(SELECT Pvalor
				FROM CRCParametros
				WHERE Pcodigo IN ('30000710'))
			AND nc.Orden <> cd.Orden
	</cfquery>
	
</cfif>
<!--- Query para obtener las categorias disponibles--->
<cfquery name="rsCategoriasDis" datasource="#session.DSN#">
	select id, Titulo 
	from CRCCategoriaDist
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfset periodos = [1,2,3,4,5,6,7,8,9,10,11,12] >
 
<cfoutput>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset>
			<table  width="95%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="4">&nbsp;</td></tr>
				<form name="form1" action="EvaluarCategoria.cfm" method="post">
					<tr>
						<td>&nbsp;</td>
						<td width="15%" nowrap><strong>#LB_Periodo#:&nbsp;</strong></td>
						<td width="10%" nowrap>
						 <select name="periodo" id="periodo" tabindex="1">
						 	<cfloop array="#periodos#" index="idx"> 
							  	<option value="#idx#" <cfif isdefined("form.periodo") and form.periodo eq idx> selected </cfif>>#idx#</option>
							</cfloop>
						  </select>
						</td>
						
						<td><input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="2"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width="15%" nowrap><strong>#LB_ConsiderarSociosN#:&nbsp;</strong></td>
						<td width="10%" nowrap>
							<input type="checkbox" name="considerarSNNuevos" id="considerarSNNuevos" value="1" <cfif isDefined('form.considerarSNNuevos')> checked </cfif> >
						</td>
					</tr>
					<tr>
						<td colspan="8">&nbsp;</td>
					</tr>

				</form>	
				<tr>
					<td colspan="8">
						<cfif isDefined('q_EvaluarCat')>
							<form name="form2" action = "EvaluarCategoria_sql.cfm" method="post">		
								<table  width="98%" cellpadding="2" cellspacing="0" border="0" align="center">			
									<input type="hidden" name="query" value="#q_EvaluarCat.sql#">
									<input type="hidden" name="formPeriodo" id="formPeriodo" value="<cfif isDefined('form.periodo') and #form.periodo# neq ''>#form.periodo#<cfelse>1</cfif>">
		
									<input type="hidden" name="formCsnn" id="formCsnn" value="<cfif isDefined('form.considerarSNNuevos') and #form.considerarSNNuevos# neq ''>#form.considerarSNNuevos# <cfelse> 0 </cfif>">
		
									<tr class="tituloListas" height="30">
										<td>
											<label class="toggle">
												<input type="checkbox"> Todos
											</label>
										</td>
										<td> <strong>No. Cuenta</strong></td>
										<td> <strong>#LB_Nombre#&nbsp;</strong> </td>
										<td> <strong>Estado&nbsp;</strong></td>
										<td> <strong>#LB_PromVentas#&nbsp;</strong> </td>
										<td> <strong>#LB_CategoriaActual#&nbsp;</strong></td>
										<td> <strong>#LB_CategoriaNueva#&nbsp;</strong></td>
										<td> <strong>#LB_Movimiento#&nbsp;</strong></td>
									</tr>
									<cfif isDefined('rsEvaluarCat') and rsEvaluarCat.RecordCount gt 0>
									<cfloop query = "rsEvaluarCat">
										<tr>
											<input type="hidden" name="catAct#idCta#" value="#idCat#">
											<td class="control-group">
												<input type="checkbox" class="checkGroup" name="IdCuenta" value="#idCta#" <!--- onchange="validaCheck()" --->>
											</td>
											<td width="15px">#Numero#</td>
											<td nowrap>#SNnombre#</td>
											<td>
												#EstatusCuenta#
											</td>
											<td>#LSNumberFormat(promedio_venta,',9.00')#</td>
											<td>#descripcion#</td>
											<td>
												#descripcion2#
											</td>
											<td>
												<cfif #Orden2# gt #Orden#  >
													#LB_SubioCat#
												<!--- <cfelseif #nuevaCategoria# lt #idCat#>
													#LB_BajoCat# --->
												<cfelse> 
													#LB_BajoCat#
												</cfif>
		
											</td>
										</tr>
									</cfloop>
										<cfelse>
												<tr><td colspan="7">&nbsp;</td></tr>
												<tr><td colspan="7" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
										</cfif>
		
									<tr>
										<td>&nbsp;</td>
										<td width="15%"></td>
										<td align="right" colspan="6">
											<table>
												<tr>
													<td>
														<!---<input type="submit" class="btnGuardar" name="aplicar" id="aplicar" value="#LB_Aplicar#">--->
													</td>
													<td>
														<!---<input type="button" name="imprimir" class="btnImprimir" value="#LB_Imprimir#" tabindex="2" 
														onclick="location.href='EvaluarCategoria_imprimir.cfm?periodo=<cfif isDefined('form.periodo') and #form.periodo# neq ''>#form.periodo#<cfelse>1</cfif>&csnn=<cfif isDefined('form.considerarSNNuevos') and #form.considerarSNNuevos# neq ''>#form.considerarSNNuevos#<cfelse>1</cfif>&p=0';">--->
		
														<input type="submit" class="btnGuardar" name="aplicar" value="#LB_Aplicar#"/>
														<input type="submit" name="imprimir" class="btnImprimir" value="#LB_Imprimir#" onclick = "this.form.action = 'EvaluarCategoria_imprimir.cfm?p=0'" value="accion 2" />
														
													</td>
												</tr>
											</table>
										</td>
										<td colspan="6">&nbsp;</td>
									</tr>
		
									<tr>
										<td>&nbsp;</td>
										<td width="15%"></td>
										<td align="right" ><label id = "mensaje"></label></td>
										<td colspan="3">&nbsp;</td>
									</tr>
								</table>
							</form>	
						</cfif>
					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
	

<script type="text/javascript">
	//window.onload=validaCheck,actailizaMov;

	$('.toggle input').click(function () {
		$('.checkGroup').prop("checked", this.checked);
	});

	function actailizaMov(){
		var catA = document.getElementById('catAct').value;
		var catN = document.getElementById('catNueva').value;
	}

	//Funcion para mostrar mensaje de si subira, bajara o se mantendrá igual la categoría.
	function actualizaMovimiento(ca, cn, snid){

		var catActual = ca;
		var catNueva = cn;
		var SNid = snid;

		if (Number(catActual) < Number(catNueva)){
			document.getElementById('mov_'+SNid).innerHTML = '#LB_SubioCat#';
			document.getElementById('movimiento').value = 'subio';
		}else if (Number(catActual) > Number(catNueva)){
			document.getElementById('mov_'+SNid).innerHTML = '#LB_BajoCat#';
			document.getElementById('movimiento').value = 'bajo';
		}else{
			document.getElementById('mov_'+SNid).innerHTML = '#LB_SinCambio#';
			document.getElementById('movimiento').value = 'sin cambios';
		}

	}
	function validaCheck(){

		chk=document.getElementsByName('IdCuenta');
		for(i=0;i<chk.length;i++)
		if(chk[i].checked){
			document.form2.aplicar.disabled = false;
			break;
		}
		else{
			document.form2.aplicar.disabled = true;
		}	
	}

</script>
</cfoutput>


