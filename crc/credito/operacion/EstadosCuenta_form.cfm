
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle1" default = "Tablero" returnvariable="TabTitle1" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle2" default = "Transacciones" returnvariable="TabTitle2" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle3" default = "Detalle de Corte" returnvariable="TabTitle3" xmlfile = "cuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "TabTitle4" default = "Incidencias" returnvariable="TabTitle4" xmlfile = "cuentas.xml">

<cfparam name="form.id">

<cfquery name="rsCuenta" datasource="#session.DSN#">
	select *
		,	concat(d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2) as GDEnombreC
		,	d.DEidentificacion GDEidentificacion
		,	c.DatosEmpleadoDEid GDEid
		,	concat(d2.DEnombre,' ',d2.DEapellido1,' ',d2.DEapellido2) as ADEnombreC
		,	d2.DEidentificacion ADEidentificacion
		,	c.DatosEmpleadoDEid2 ADEid
		,	c.Tipo
		,	c.Numero
		,	case c.Tipo
				when 'D' then 'Vales'
				when 'TC' then 'Tarjeta de Credito'
				when 'TM' then 'Tarjeta Mayorista'
				else ''
			end as TipoDescripcion
	from CRCCuentas c
		inner join SNegocios s 
			on c.SNegociosSNid = s.SNid
		inner join CRCEstatusCuentas ce 
			on c.CRCEstatusCuentasid = ce.id
		left join CRCCategoriaDist cd 
			on c.CRCCategoriaDistid = cd.id
		left join DatosEmpleado d 
			on c.DatosEmpleadoDEid = d.DEid
		left join DatosEmpleado d2 
			on c.DatosEmpleadoDEid2 = d2.DEid
	where c.Ecodigo = #Session.Ecodigo#
		and c.id = #form.id#
</cfquery>

<cfquery name="q_currentCorte" datasource="#session.DSN#">
	select top(3) fechainicio, fechafin, codigo from CRCCortes  
		where 
			<!---FechaInicio < CURRENT_TIMESTAMP --->
			status >= 1
			and Tipo = '#rsCuenta.Tipo#'
			and Ecodigo = #session.ecodigo#
			order by FechaFin desc;
</cfquery>

<cfif !isdefined('form.codigocorte')>
	<cfif q_currentCorte.RecordCount gt 0>
		<cfset form.codigocorte="#QueryGetRow(q_currentCorte,1).codigo#">
	<cfelse>
		<cfset form.codigocorte="">
	</cfif>
</cfif>

<cfoutput>

<form name="formDetalleCuenta" action="#parentEntrancePoint#" method="POST" target="_bank">
	<input name="whatToDo" type="hidden" value="" >
	<input name="Tipo" type="hidden" value="#form.Tipo#" >
	<input name="numeroCuenta" type="hidden" value="#rsCuenta.Numero#">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="50%">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td align="right">
							<strong>Numero Cuenta:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.Numero#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							<input name="id" type="hidden" value="#rsCuenta.id#" >
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Tipo Cuenta:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.TipoDescripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
					<cfif TRIM(rsCuenta.tipo) eq 'D'>
						<cfif rsCuenta.Titulo neq "">
							<tr>
								<td align="right">
									<strong>Categoria:&nbsp;</strong>
								</td>
								<td>
									<input type="text" value="#rsCuenta.Titulo#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
								</td>
							</tr>
						</cfif>
					</cfif>
					<tr>
						<td align="right">
							<strong>Socio de Negocio:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.SNnombre#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Estado:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.Descripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
					
				</table>
			</td>
			<td>
				<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
					<cfif q_currentCorte.recordcount gt 0>
						<tr>
							<td align="right">
								<strong>Corte:&nbsp;</strong>
							</td>
							<td>
								<cfif rsCuenta.Tipo eq 'TM'>
									<cfquery name="rsAnno" datasource="#session.dsn#">
										select distinct year(Fecha) Anno
										from CRCTransaccion
										where CRCCuentasid = #rsCuenta.id#
										order by year(Fecha) desc
									</cfquery>
									<select name="corteAnno">
										<cfloop query="rsAnno">
											<option value="#rsAnno.Anno#" <cfif isdefined("form.corteAnno") and form.corteAnno eq "#rsAnno.Anno#" > selected="true"</cfif>> #rsAnno.Anno# </option>
										</cfloop>
									</select>
									<cfset monthName = ['ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE']>
									<select name="codigoSelect">
										<option value="1"> #monthName[1]#</option>
										<option value="2"> #monthName[2]#</option>
										<option value="3"> #monthName[3]#</option>
										<option value="4"> #monthName[4]#</option>
										<option value="5"> #monthName[5]#</option>
										<option value="6"> #monthName[6]#</option>
										<option value="7"> #monthName[7]#</option>
										<option value="8"> #monthName[8]#</option>
										<option value="9"> #monthName[9]#</option>
										<option value="10"> #monthName[10]#</option>
										<option value="11"> #monthName[11]#</option>
										<option value="12"> #monthName[12]#</option>
									</select>
								<cfelse>
									<select name="codigoSelect">
										<cfloop query="#q_currentCorte#">
											<option value="#q_currentCorte.codigo#">#q_currentCorte.codigo# (#DateFormat(q_currentCorte.fechainicio,'dd/mm/yyyy')# - #DateFormat(q_currentCorte.fechafin,'dd/mm/yyyy')#)</option>
										</cfloop>
									</select>
								</cfif>
							</td>
							<td align="left" valign="middle">
								<input type="checkbox" name="regenerar">&ensp;<font><b>Actualizar Estado de Cuenta</b></font>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								&emsp;&emsp;&emsp;&emsp;&emsp;
								<input type="button" value="DESCARGAR PDF" name="estadoCTA" onclick="setWhatToDo('CTA');">
							</td>
						</tr>
						<cfif TRIM(rsCuenta.tipo) eq 'D'>
							<tr>
								<td>&nbsp;</td>
								<td>
									<br/>
									<input type="button" value="DESCARGAR RECIBOS PARA CLIENTE" name"reciboPago" onclick="setWhatToDo('URP');">
								</td>
							</tr>
						</cfif>
						
					<cfelse>
						<tr>
							<td align="center" colspan="2">
								<p align="center"><font color="red"><br/><br/><br/><b>No existen transacciones de usuario o cortes cerrados en la empresa</b></font> </p>
							</td>
						</tr>
					</cfif>
				<table>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script>
	function setWhatToDo(toDo){
		document.formDetalleCuenta.whatToDo.value = toDo;
		document.formDetalleCuenta.submit();
	}
</script>