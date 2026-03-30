<cfif instancia.completado eq 0 >
	<cfquery datasource="asp" name="monedas">
		select Miso4217, Mnombre
		from Moneda
		order by 2
	</cfquery>
	<cfoutput>
	
	<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<!--- Style para que los botones sean de colores --->
		<cfquery datasource="#session.tramites.dsn#" name="total_header">
			select 	costo_requisito as saldo,
					costo_requisito as importe,
					moneda,
					nombre_requisito,
					id_documento_pago  
			from  TPRequisito
			where id_requisito   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">                
		</cfquery>

		<cfset documento = false >
		<cfif len(trim(total_header.id_documento_pago)) >
			<cfset documento = true >
			<cfquery name="tipo_pago" datasource="#session.tramites.dsn#">
				select id_tipo, id_campo_pago
				from TPDocumento
				where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total_header.id_documento_pago#">
			</cfquery>

			<cfinvoke component="home.tramites.componentes.vistas" method="getLista" returnvariable="vistaQuery">
				<cfinvokeargument name="id_tipo" value="#tipo_pago.id_tipo#">
				<cfinvokeargument name="id_persona" value="#form.id_persona#">
			</cfinvoke>
			
			<table border="0" width="100%" align="center" cellpadding="2" cellspacing="0">
				<cfinvoke component="home.tramites.componentes.vistas" method="getCamposLista" returnvariable="campos_lista">
					<cfinvokeargument name="id_tipo" value="#tipo_pago.id_tipo#">
				</cfinvoke>
				<tr>
				<cfloop query="campos_lista">
					<cfquery name="titulo" datasource="#session.tramites.dsn#">
						select nombre_campo
						from DDTipoCampo
						where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#campos_lista.id_campo#">
					</cfquery>
					<td class="tituloListas" valign="top" >#titulo.nombre_campo#</td>
				</cfloop>
				</tr>
			
				<cfset i = 0>
				<cfset total = 0 >
				<cfloop query="vistaQuery">
					<input type="hidden" name="id_registro" value="#vistaQuery.id_registro#" >
					<cfif vistaQuery.pagado eq 0>
						<cfset i = i + 1>
						<tr class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>">
							<cfloop list="#valuelist(campos_lista.id_campo)#" index="id_campo">
								<td>#Evaluate("vistaQuery.C_#id_campo#")#</td>
								<cfif tipo_pago.id_campo_pago eq id_campo >
									<cfset total = total + Replace(Evaluate("vistaQuery.C_#id_campo#"),',','','all') >
								</cfif>
							</cfloop>
						</tr>
					</cfif>
				</cfloop>
			</table>
		</cfif>
		
		<table border="0" width="100%" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td  align="right" class="tituloListas">Total por Pagar:</td>
				<td  class="tituloListas">#total_header.moneda# <cfif documento>#NumberFormat(total,',0.00')#<cfelse>#NumberFormat(total_header.saldo,',0.00')#</cfif></td>
			</tr>
			<tr>
				<td align="right">N&uacute;mero Tiquete Caja: </td>
				<td ><input name="num_tiquete" size="20" type="text" id="num_autorizacion" onfocus="this.select()" maxlength="30"></td>
			</tr>
			<tr>
				<td align="right">N&uacute;mero Referencia: </td>
				<td ><input name="num_Referencia"  size="20" type="text" id="num_Referencia" onfocus="this.select()" maxlength="30"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" class="boton"  onClick="javascript:valida(this.form);" value="Pagar" >
			  </td>
			</tr>
		</table>
	
		<cfquery datasource="#session.tramites.dsn#" name="RSinst">
			select  ts_rversion
			from TPInstanciaRequisito
			where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
			and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
		</cfquery>
		
	
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#RSinst.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	
		<input type="hidden" name="moneda" value="#total_header.moneda#">  
		<input type="hidden" name="monto_pagado" value="#total_header.saldo#">  
		<input type="hidden" name="ts_rversion" 	 value="<cfif isdefined("ts")>#ts#</cfif>">
	
	</cfoutput>
	<script type="text/javascript">
	<!--	
		function valida(f) {
			todobien = true;
			var msg = '';
			var ctl = null;
			if (f.num_tiquete.value == '') { msg += "\n* Digite el número de tiquete"; ctl = ctl?ctl:f.num_tiquete; }
			if (msg.length || ctl) {
				alert('Verifique la siguiente información:' + msg);
				ctl.focus();
				todobien = false;
			}
			if (todobien)
				f.submit();
		}
	//-->
	</script>
<cfelse>
	<cfquery name="infopago" datasource="#session.tramites.dsn#">
		select ir.id_funcionario, ir.id_ventanilla, ir.fecha_registro, p.nombre, p.apellido1, p.apellido2, v.nombre_ventanilla, s.nombre_sucursal
		from TPInstanciaRequisito ir 
		
		inner join TPFuncionario f
		on f.id_funcionario = ir.id_funcionario
		
		inner join TPPersona p
		on p.id_persona = f.id_persona
		
		inner join TPVentanilla v
		on v.id_ventanilla=ir.id_ventanilla
		
		inner join TPSucursal s
		on s.id_sucursal = v.id_sucursal
		
		where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
		  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
	</cfquery>
	
	<cfquery name="pago" datasource="#session.tramites.dsn#">
		select monto_pagado, num_referencia, num_autorizacion, moneda
		from TPPago
		where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
		  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
	</cfquery>
	
	<cfoutput>
	<table align="center" width="60%" cellpadding="2" align="center" cellspacing="0">
		<tr><td><strong>Estado:</strong>&nbsp;</td><td width="1%">Cumplido</td><td><img src="/cfmx/home/tramites/images/check-verde.gif"></td></tr>
		<tr><td nowrap><strong>Fecha de Registro:</strong>&nbsp;</td><td colspan="2"><cfif len(trim(infopago.fecha_registro))>#LSDateFormat(infopago.fecha_registro, 'dd/mm/yyyy')#</cfif></td></tr>
		<tr><td><strong>Sucursal:</strong>&nbsp;</td><td colspan="2">#infopago.nombre_sucursal#</td></tr>
		<tr><td><strong>Ventanilla:</strong>&nbsp;</td><td colspan="2">#infopago.nombre_ventanilla#</td></tr>
		<tr><td nowrap><strong>Registrado por:</strong>&nbsp;</td><td colspan="2" nowrap>#infopago.nombre# #infopago.apellido1# #infopago.apellido2#</td></tr>
	</table>	
	</cfoutput>

</cfif>
