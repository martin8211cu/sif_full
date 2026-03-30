
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Condonaciones" returnvariable="LB_Title"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Intereses de la Cuenta" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonado" Default="Monto Condonado" returnvariable="LB_Condonado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoTrans" Default="Tipo Transacci&oacute;n" returnvariable="LB_TipoTrans"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Observaciones" Default="Observaciones" returnvariable="LB_Observaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha de Aplicaci&oacute;n" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_esFuturo" Default="Condonaci&oacute;n a Futuro" returnvariable="LB_esFuturo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" returnvariable="LB_Estado"/>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset cuentaValues="">
<cfif modo eq "CAMBIO">
	<cfquery name="q_Condonacion" datasource="#session.DSN#">
		select 
				A.id condonacionID
			,	A.CodigoCondonacion
			,	A.DescripCondonacion
			,	ISNULL(A.Observaciones,'') Observaciones
			,	B.Numero
			,	replace(C.SNnombre,',','') SNnombre
			,	A.CRCCuentasid
			,	CAST(ISNULL(B.Interes,0) AS Numeric (10,2)) as Interes
			,	A.MontoCondonacion
			,	A.CRCTipoTransaccionid
			,	A.CondonacionAplicada
			,	A.FechaAplicacion
			,	A.esFutura
			,	MontoPorCondonar = cn.SV
			<!--- ,	CAST(ISNULL(B.Interes,0) AS Numeric (10,2)) -  CAST(ISNULL(B.Condonaciones,0) AS Numeric (10,2)) as MontoPorCondonar --->
			,	case A.Estado
				when 'V' then 'Vencido'
				when 'A' then 'Aplicado'
				else 'Pendiente' end as EstadoD
			,	A.Estado
		from CRCCondonaciones A
		inner join CRCCuentas B
			on A.CRCCuentasid = B.id
		inner join (
			SELECT 
				SUM(
					case when (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end > 0
							then (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end
							else A.Intereses
						end
				) SV,
				B.CRCCuentasid
			FROM (
					select  A.Ecodigo,A.Corte,A.CRCTransaccionid,A.MontoAPagar,A.Intereses,A.Condonaciones,A.Pagado,A.Descuento,A.MontoRequerido,
						UltimoRequerido = (
							select top 1 MontoRequerido 
							from CRCMovimientoCuenta 
							where MontoRequerido > 0 
								and CRCTransaccionid = A.CRCTransaccionid)
					from CRCMovimientoCuenta A
			) A
			INNER JOIN CRCTransaccion B ON A.CRCTransaccionid = B.id
			INNER JOIN CRCCortes ct on A.Corte = ct.Codigo and A.Ecodigo = ct.Ecodigo
			WHERE A.Ecodigo=#Session.Ecodigo#
			AND MontoAPagar - (Pagado + A.Descuento) > 0
			AND ct.status = 2
			group by B.CRCCuentasid
		) cn on cn.CRCCuentasid = B.id
		inner join SNegocios C
			on C.SNid = B.SNegociosSNid
		where A.id = #form.id#
	</cfquery>
	<cfset cuentaValues = "#q_Condonacion.CRCCuentasid#,#q_Condonacion.Numero#,#q_Condonacion.SNnombre#">
	
	<cfquery name="q_DetalleCondonacion" datasource="#session.DSN#">
		select 
				A.CRCMovimientoCuentaid
			,	A.Monto
		from CRCCondonacionDetalle A
		where A.CRCCondonacionesid = #form.id#
	</cfquery>
	<cfset detallesCondonacion = StructNew()>
	<cfloop query="q_DetalleCondonacion">
		<cfset detallesCondonacion[q_DetalleCondonacion.CRCMovimientoCuentaid] = q_DetalleCondonacion.Monto>
	</cfloop>
</cfif>

<cfquery name="q_TipoTransaccion"  datasource="#session.DSN#">
	select id,Descripcion from CRCTipoTransaccion where afectaCondonaciones = 1 and Ecodigo = #session.ecodigo#;
</cfquery>

<cfoutput>
<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		
		<form method="post" name="form1" action="condonaciones_sql.cfm">
			<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
				<input type="hidden" name="id" value="<cfif modo eq "CAMBIO">#form.id#</cfif>">
				<tr>
					<td nowrap align="right">#LB_Cuenta#:&nbsp;</td>
					<td colspan="3">
						<cfset readonly = "no">
						<cfif modo eq 'CAMBIO'><cfset readonly = "yes"></cfif>
						<cf_conlis
							showEmptyListMsg="true"
							Campos="cuentaID,NumeroCuenta,SNNombre"
							Values="#cuentaValues#"
							Desplegables="N,S,S"
							Modificables="N,N,N"
							Size="0,10,30"
							tabindex="1"
							Tabla="CRCCuentas c inner join SNegocios sn on c.SNegociosSNid = sn.SNid
								inner join (
									SELECT
										SUM(
											case when (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end > 0
													then (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Condonaciones, 0) + ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end
													else A.Intereses
												end
										) SV,
										B.CRCCuentasid
									FROM (
											select  A.Ecodigo,A.Corte,A.CRCTransaccionid,A.MontoAPagar,A.Intereses,A.Condonaciones,A.Pagado,A.Descuento,A.MontoRequerido,
												UltimoRequerido = (
													select top 1 MontoRequerido 
													from CRCMovimientoCuenta 
													where MontoRequerido > 0 
														and CRCTransaccionid = A.CRCTransaccionid)
											from CRCMovimientoCuenta A
									) A
									INNER JOIN CRCTransaccion B ON A.CRCTransaccionid = B.id
									INNER JOIN CRCCortes ct on A.Corte = ct.Codigo and A.Ecodigo = ct.Ecodigo
									WHERE A.Ecodigo=#Session.Ecodigo#
									AND ct.status = 2
									AND MontoAPagar - (Pagado + A.Descuento) > 0
									GROUP BY B.CRCCuentasid
								) cn on cn.CRCCuentasid = c.id"
							Columnas="
									c.id as cuentaID
									, ISNULL(c.Interes, 0 ) MontoPorCondonar
									, c.Numero as NumeroCuenta
									, sn.SNnombre
									, ISNULL(c.Interes, 0 ) as Interes
									, ISNULL(c.Condonaciones, 0 ) as Condonaciones
									, Round(c.SaldoActual,2) as SaldoActual
									, c.tipo
									"
							Filtro="c.Ecodigo = #Session.Ecodigo# and sn.eliminado is null and ISNULL(c.Interes, 0 ) > 0"
							Desplegar="NumeroCuenta,tipo,SNNombre,Interes,SaldoActual"
							Etiquetas="Numero de Cuenta,Tipo de Cuenta,Nombre Socio de Negocio,Intereses,Saldo Actual"
							filtrar_por="c.Numero,c.tipo,sn.SNNombre"
							Formatos="S,S,S"
							Align="left,left,left"
							Asignar="cuentaID,NumeroCuenta,SNNombre,Interes,Condonaciones,MontoPorCondonar"
							Asignarformatos="S,S,S"
							readonly = "#readonly#"
						/>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Interes#:&nbsp;</td>
					<td><input name="MontoPorCondonar" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" disabled="disabled"
						value="<cfif modo eq 'CAMBIO'>#NumberFormat(q_Condonacion.MontoPorCondonar,'0.00')#</cfif>"
						>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">&nbsp;</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Codigo#:&nbsp;</td>
					<td colspan="2"><input name="CodigoC" type="text" size="5" maxlength="5"
						value="<cfif modo eq 'CAMBIO'>#q_Condonacion.CodigoCondonacion#</cfif>"
						></td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
					<td colspan="3"><input name="DescripcionC" type="text" size="77"
						value="<cfif modo eq 'CAMBIO'>#q_Condonacion.DescripCondonacion#</cfif>"
						></td>
				</tr>
				<tr>
					<td nowrap align="right">&nbsp;</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Condonado#:&nbsp;</td>
					<td><input name="Monto" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" disabled="disabled"
						value="<cfif modo eq 'CAMBIO'>#NumberFormat(q_Condonacion.MontoCondonacion,'0.00')#</cfif>"
						>
					</td>
					<td nowrap align="right">#LB_Fecha#:&nbsp;</td>
					<td ><input name="FechaAplicacion" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" disabled="disabled"
						value="<cfif modo eq 'CAMBIO'>#q_Condonacion.FechaAplicacion#</cfif>"
						>
					</td>
				</tr>
					<td nowrap align="right">#LB_esFuturo#:&nbsp;</td>
					<td>
						<input name="esFuturo" type="checkbox" <cfif modo eq 'CAMBIO'><cfif q_Condonacion.esFutura eq 1> checked </cfif> disabled </cfif> >
					</td>
					<td nowrap align="right">#LB_TipoTrans#:&nbsp;</td>
					<td>
						<select name="TipoTransaccionID">
							<cfloop query="q_TipoTransaccion">
								<option value="#q_TipoTransaccion.id#"
									<cfif modo eq 'CAMBIO'><cfif q_Condonacion.CRCTipoTransaccionid eq q_TipoTransaccion.id>selected</cfif></cfif>
								>#q_TipoTransaccion.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				<tr>
					<td nowrap align="right">#LB_Estado#:&nbsp;</td>
					<td> <input name="Estado"
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" readonly="true"
						value="<cfif modo eq 'CAMBIO'>#q_Condonacion.EstadoD#</cfif>"
						>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
					<td nowrap align="right">#LB_Observaciones#:&nbsp;</td>
					<td colspan="3"><textarea name="ObservacionC" cols="100" rows="3" maxlength="255" onkeyup="countCharacter(this.value);"><cfif modo eq 'CAMBIO'>#q_Condonacion.Observaciones#</cfif></textarea>
					<br/>
					<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
				</td>
				</tr>
				<tr>
					<td colspan="4">
						<cfif modo eq "CAMBIO"> 
							<cfif q_Condonacion.CondonacionAplicada neq 1 and q_Condonacion.Estado neq 'V' and q_Condonacion.Estado neq 'A'>
								<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
								<cfset val = objParams.getParametroInfo('30200711')>
								<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
								<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
								<cfquery name="checkRol" datasource="#session.dsn#">
									select * from UsuarioRol where 
												Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
											and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
											and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
								</cfquery>
								<cfif checkRol.recordCount neq 0>
									<cf_botones modo="#modo#" include="Aplicar,Regresar"> 
								<cfelse>
									<cf_botones modo="#modo#" include="Regresar"> 
								</cfif>
							<cfelse>
								<cf_botones values="Regresar">
							</cfif>
						<cfelse> 
							<cf_botones modo="#modo#" include="Regresar"> 
						</cfif>
						
					</td>
				</tr>
				<tr>
				</tr>
			</table>
			<cfif modo eq "CAMBIO">
				<cfif q_Condonacion.esFutura eq 1>
					<cfinclude template="Condonaciones_futuro.cfm">
				<cfelse>
					<cfinclude template="Condonaciones_transaccion.cfm">
				</cfif>
			</cfif>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfoutput>

<script>
	function countCharacter(v){
		document.getElementsByName('txtAreaCounter')[0].innerHTML=v.length+"/255";

	}
	
	function validarForm(validarMontos){
		var form = document.getElementsByName('form1')[0]

		var msg = "Porfavor corrija los siguientes puntos:"
		var result = true;
		var montosEnRango = true;
		
		if(form.CodigoC.value.trim()      == "" ){msg += "\n- Ingrese un Código"; result = false;}
		if(form.DescripcionC.value.trim() == "" ){msg += "\n- Ingrese una Descripción"; result = false;}
		if(form.ObservacionC.value.trim() == "" ){msg += "\n- Ingrese una Observación"; result = false;}
		if(form.NumeroCuenta.value.trim() == "" ){msg += "\n- Seleccione una cuenta"; result = false;}
		if(!document.getElementsByName('esFuturo')[0].checked){
			//if(Number(form.Interes.value) == 0 ){msg += "\n- No puede crear una Condonación con CERO intereses"; result = false;}
			if(Number(form.MontoPorCondonar.value) == 0 ){msg += "\n- No puede crear una Condonación con CERO intereses"; result = false;}
		}
		
		if(validarMontos){
			document.getElementsByName('Monto')[0].disabled = false;
			var $inputs = $(":input[name^='monto_']");
			var DOM_inputs = $inputs.get();
			for(var i = 0; i < DOM_inputs.length; i++){
				var idMonto = DOM_inputs[i].name.split("_")[1];
				var validar = MaxMonto(idMonto,true);
				if(!validar.ok){
					montosEnRango = false;
					msg += validar.msg;
				}
			}
		}

		if(!result || !montosEnRango){
			alert(msg);
			return false;
		}else{
			document.getElementsByName('esFuturo')[0].disabled = false;
			return result;
		}
	}
	
	function funcAlta(){ 
		return validarForm(false); 
	}
	function funcAplicar(){ 
		if(confirm("Esta seguro que desea aplicar la condonacion?")){
			if(!document.getElementsByName('esFuturo')[0].checked){
				var monto = document.getElementsByName('form1')[0].Monto.value;
				if( parseFloat(monto) == 0 || isNaN(parseFloat(monto))){
					alert("No puede aplicar una condonacion cuyo monto es CERO");
					return false;
				}
			}
			
			return validarForm(true);
		}
		return false;
	}

	function funcCambio(){
		return validarForm(true);
	}
	
</script>