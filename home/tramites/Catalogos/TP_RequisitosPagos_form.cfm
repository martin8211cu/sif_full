<!--- 
	Creado por Gustavo Fonseca Hernández, Fecha: 22-8-2005. Motivo: Manejo de pagos en el modelo de Trámites.
	Modificado por DAG, Fecha: 25-8-2005. Motivo: Agregar Mantenimiento a id_documento_pago.
 --->
<cfif isdefined("url.id_requisito") and len(trim(url.id_requisito)) and not isdefined("form.id_requisito")>
	<cfset form.id_requisito = url.id_requisito>
</cfif>
 <cfquery name="rslista" datasource="#session.tramites.dsn#">
	select 
		a.costo_requisito as Total, 
		a.moneda as moneda, 
		b.costo_requisito as monto_desglosado,
		b.id_requisito,
		b.id_tiposerv,
		c.id_inst
	from TPRequisito a
		inner join TPRequisitoPago b
			on b.id_requisito = a.id_requisito
		left outer join  TPTipoServicio c
			on c.id_tiposerv = b.id_tiposerv
	
	where b.id_requisito =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
</cfquery>
<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	SELECT id_inst,codigo_inst,nombre_inst
	FROM TPInstitucion 
	order by id_inst
</cfquery>
<cfquery name="rstiposserv" datasource="#session.tramites.dsn#">
	SELECT id_inst,id_tiposerv ,codigo_tiposerv ,nombre_tiposerv 
	FROM TPTipoServicio 
	order by id_inst,id_tiposerv
</cfquery>
<cfquery name="rsMonedas" datasource="asp">
	select Miso4217, Mcodigo, Mnombre
	from Moneda
</cfquery>
<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">	
		select * 
		from TPRequisito 
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	
	<cfset modo = 'CAMBIO'>
	<cfoutput>
		<form name="formR" method="post" action="TP_RequisitosPagos_sql.cfm"> <!--- onSubmit="return validar(this);" --->
			<input name="id_requisito" type="hidden" value="#form.id_requisito#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td  bgcolor="##ECE9D8" style="padding:3px;" nowrap><strong><cfif modo neq 'ALTA'>Modificar&nbsp;los<cfelse>Agregar&nbsp;los</cfif>&nbsp;Pagos</strong></td>
			  </tr>
			</table>
			<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="center" valign="top">
			<br>
			<fieldset><legend><strong><input type="radio" name="rd" value="0" <cfif modo neq "ALTA" and isdefined("rsDatos.id_documento_pago") and len(trim(rsDatos.id_documento_pago)) and rsDatos.id_documento_pago>checked</cfif>>Pagar un Documento</strong></legend>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="1%" nowrap><strong>Documento Por Pagar:</strong>&nbsp;</td>
				<td>
					<cfset values = ",,">
					<cfif modo neq "ALTA" and isdefined("rsDatos.id_documento_pago") and len(trim(rsDatos.id_documento_pago)) and rsDatos.id_documento_pago>
						<cfquery name="rsDocumento" datasource="#session.tramites.dsn#">
							select id_documento as id_documento_pago, codigo_documento, nombre_documento
							from TPDocumento
							where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.id_documento_pago#">
						</cfquery>
						<cfif rsDocumento.recordcount eq 1>
							<cfset values = "#rsDocumento.id_documento_pago#,#rsDocumento.codigo_documento#,#rsDocumento.nombre_documento#">
						</cfif>
					</cfif>
					<cf_conlis
						Campos="id_documento_pago, codigo_documento, nombre_documento"
						Desplegables="N,S,S"
						Size="0,15,35"
						Values="#values#"
						Title="Lista de Documentos"
						Tabla="TPDocumento"
						Columnas="id_documento as id_documento_pago, codigo_documento, nombre_documento"
						Filtro="es_pago=1"
						Desplegar="codigo_documento, nombre_documento"
						Etiquetas="Código, Descripción"
						Form="formR"
						Conexion="#session.tramites.dsn#">
				</td>
			  </tr>
			</table>
			</fieldset>
			<br>
			<fieldset><legend><strong><input type="radio" name="rd" value="1" <cfif Modo Neq "ALTA" and not isdefined("rsDatos.id_documento_pago") or (isdefined("rsDatos.id_documento_pago") and len(trim(rsDatos.id_documento_pago)) EQ 0)>checked</cfif>>Pagar un Monto Fijo</strong></legend>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="1%" nowrap><strong>Monto Total:</strong>&nbsp;</td>
					<td width="1%"><input name="costo_requisitoTotalEnca" type="text" value="<cfif isdefined("rslista") and rslista.Total gt 0>#rslista.Total#</cfif>" readonly="true"></td>
					<td>
						<select name="Miso4217" >
							<cfloop query="rsMonedas">
								<option value="#rsMonedas.Miso4217#" 
									<cfif isdefined("rslista.moneda") and (rsDatos.moneda EQ rsMonedas.Miso4217)>
										selected
									</cfif>
								>#rsMonedas.Mnombre#</option>
							</cfloop>
						</select>
					</td>
				  </tr>
				</table>
				
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td class="TituloListas"><strong>Desglose de Acreedores</strong></td>
				  </tr>
				</table>
				
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr class="TituloListas">
						<td nowrap align="left" class="TituloListas"><strong>Instituci&oacute;n&nbsp;</strong></td>
						<td nowrap align="left" class="TituloListas"><strong>Servicio</strong></td>
						<td nowrap align="left" class="TituloListas"><strong>Monto</strong></td>
					</tr>
					<cfloop query="rslista">
						<tr valign="baseline"> 
							<td>
								<select name="id_inst_#rslista.id_inst#_#rslista.id_tiposerv#" onChange="javascript: Cargatiposerv();">
									<cfset LvarId_inst = rslista.id_inst>
									<cfloop query="rsInstitucion">
										<option value="#rsInstitucion.id_inst#" <cfif modo NEQ "ALTA" and (trim(LvarId_inst) eq trim(rsInstitucion.id_inst))>selected</cfif>>#rsInstitucion.codigo_inst#-#rsInstitucion.nombre_inst#</option>
									</cfloop>
								</select>
								<input name="id_inst" type="hidden" value="#rslista.id_inst#">
							</td>
							<td>
								<select name="id_tiposerv_#rslista.id_tiposerv#" >
									<option value=""></option>
								</select>	
							</td>
							<td>
								<cfif isdefined("rslista") and rslista.monto_desglosado gt 0>
									<cfset value=rslista.monto_desglosado>
								</cfif>
								<cfparam name="value" default="0.00" type="numeric">
								<cf_monto name="costo_requisito_#rslista.id_tiposerv#" onChange="total();" value="#value#" decimales="2">
							</td>
						</tr>
					</cfloop>
					<tr valign="baseline"> 
						<td>
							<select name="id_instAgrega" onChange="javascript: Cargatiposerv_Agrega();">
								<cfloop query="rsInstitucion">
									<option value="#rsInstitucion.id_inst#" <cfif modo NEQ "ALTA" and  isdefined('rsDatos.id_inst') and rsDatos.id_inst eq rsInstitucion.id_inst>selected</cfif>>#rsInstitucion.codigo_inst#-#rsInstitucion.nombre_inst#</option>
								</cfloop>
							</select>
						</td>
						<td>
							<select name="id_tiposervAgrega">
								<option value="">&nbsp;</option><!--- dejar esto asi, en mozilla si no pone el nbsp deja el combo cortado a la mitad--->
							</select>	
						</td>
						<td>
							<cfif isdefined("rslista") and rslista.monto_desglosado gt 0>
								<cfset value=rslista.monto_desglosado>
							</cfif>
							<cf_monto name="costo_requisitoAgrega" onChange="total();" decimales="2">
						</td>
					</tr>
				</table>
			</fieldset>		
			<br>
			<cf_botones values="Guardar">
			</td>
			</tr>
			</table>
		</form>
	</cfoutput>
<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;de&nbsp;la&nbsp;Vista</td>
		</tr>
	</table>
</cfif>
<cfoutput>
<script language="javascript" type="text/javascript">
 	function total() {
		var LvarTotal = 0;
		<cfloop query="rslista">
			LvarTotal = LvarTotal + parseFloat(qf(document.formR.costo_requisito_#rslista.id_tiposerv#.value));
		</cfloop>
		if (!document.formR.costo_requisitoAgrega.value==''){
			LvarTotal = LvarTotal + parseFloat(qf(document.formR.costo_requisitoAgrega.value));
		}
		document.formR.costo_requisitoTotalEnca.value = LvarTotal;
	}
	function Cargatiposerv_Agrega() {
		var combo = document.formR.id_tiposervAgrega;
		var cont = 0;
		codigo = document.formR.id_instAgrega.value;
		combo.length=0;
		<cfloop query="rstiposserv">
			if ( #Trim(id_inst)# == codigo) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rstiposserv.id_tiposerv#';
				combo.options[cont].text='#trim(rstiposserv.codigo_tiposerv)#-#trim(rstiposserv.nombre_tiposerv)#';
				<cfif isdefined("rsDatos.id_tiposerv") and trim(rstiposserv.id_tiposerv) EQ trim(rsDatos.id_tiposerv)>
					combo.options[cont].selected=true;
				</cfif>						
				cont++;
			}
		</cfloop>
	}
	function Cargatiposerv() {
		//var combo = document.formR.id_tiposerv;
		var cont = 0;
		//codigo = document.formR.id_inst.value;
		document.formR.id_tiposerv_#rslista.id_tiposerv#.length=0;
		<cfloop query="rstiposserv">
			<cfset Lvarid_tiposervJ = rstiposserv.id_tiposerv>
			<cfset LvarcodigoJ = rstiposserv.codigo_tiposerv>
			<cfset LvarNombreJ = rstiposserv.nombre_tiposerv>
			<cfset LvarId_Inst = rstiposserv.id_inst>
			
			<cfloop query="rslista">
				if ( #Trim(LvarId_Inst)# == document.formR.id_inst_#rslista.id_inst#_#rslista.id_tiposerv#.value) 
				{
					document.formR.id_tiposerv_#rslista.id_tiposerv#.length=cont+1;
					document.formR.id_tiposerv_#rslista.id_tiposerv#.options[cont].value='#Lvarid_tiposervJ#';
					document.formR.id_tiposerv_#rslista.id_tiposerv#.options[cont].text='#trim(LvarcodigoJ)#-#trim(LvarNombreJ)#';
					<cfif isdefined("Lvarid_tiposervJ") and trim(Lvarid_tiposervJ) EQ trim(rslista.id_tiposerv)>
						document.formR.id_tiposerv_#rslista.id_tiposerv#.options[cont].selected=true;
					</cfif>						
					cont++;
				}
			</cfloop>
		</cfloop>
		
	}
	<cfif modo NEQ "ALTA">
		//ValidarPago();
		Cargatiposerv_Agrega(document.formR.id_instAgrega.value);
		<cfloop query="rslista">
			Cargatiposerv(document.formR.id_inst_#id_inst#_#rslista.id_tiposerv#.value);
		</cfloop>
		//ValidarServicios();
	</cfif>
</script>
</cfoutput>
