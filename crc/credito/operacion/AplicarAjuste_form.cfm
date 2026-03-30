
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>



<cfoutput>
	
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
		<form name="formAjuste" action="AplicarAjuste_sql.cfm" method="post">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<cfset _cuenta = "">
				<cfif isdefined('form.ID_AJ') and lcase(form.modo) eq 'cambio' >
					<cfquery name="rsAjuste" datasource="#Session.dsn#">
						select  i.* , sn.SNid , c.id as ID_cta ,
							sn.SNidentificacion , sn.SNnombre , c.Numero , 
							Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
							end
						from CRCAjusteCuenta i 
						inner join CRCCuentas c on c.id = i.CRCCuentasid 
						inner join SNegocios sn on sn.SNid = c.SNegociosSNid 
						where i.Ecodigo=#session.Ecodigo#
							AND i.id = #form.ID_AJ#
					</cfquery>
					<cfset _cuenta = [rsAjuste.id,rsAjuste.Numero,rsAjuste.SNnombre,rsAjuste.Tipo]>
				</cfif>


				<tr>
					<td colspan="2">
						<input type="hidden" name="ID_AJ" 
							<cfif isdefined('form.ID_AJ') and form.modo eq 'cambio' >value="#rsAjuste.id#"<cfelse>value="-"</cfif>
						>
					</td>
				</tr>
				<tr>
					<td align="right"> Cuenta: &nbsp; </td>
					<td>
						<cf_conlis
							Campos="id,Numero, SNnombre, Tipo"
							Desplegables="N,S,S,S"
							Modificables="N,S,N,N"
							Size="0,10,30,20"
							valuesArray="#_cuenta#"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="cc.id,Numero,SNnombre, Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
									end"
							form="formAjuste"
							Filtro="sn.Ecodigo = #Session.Ecodigo#
									order by SNnombre"
							Desplegar="Numero, SNnombre, Tipo"
							Etiquetas="Numero, Nombre, Tipo"
							filtrar_por="Numero, SNnombre, Tipo"
							Formatos="S,S,S,S"
							Align="left,left, left, left"
							Asignar="id,Numero,SNnombre, Tipo"
							Asignarformatos="S,S,S,S"
							funcion = "validaTipo()"/>
					</td>
				</tr>
				<tr>
					<td align="right"> Transacci&oacute;n: &nbsp; </td>
					<td>
						<cfquery name="q_TipoTran" datasource="#session.DSN#">
							select * from CRCTipoTransaccion 
							where afectaPagos='1'
								and Codigo in ('NR');
						</cfquery>
						<select name="tipoTransID">
							<cfloop query="#q_TipoTran#">
								<option value="#q_TipoTran.id#"
									<cfif isdefined('form.ID_AJ') and form.modo eq 'CAMBIO' >
										<cfif q_TipoTran.id eq rsAjuste.CRCTipoTransaccionid>
											selected
										</cfif>
									</cfif>
								> #q_TipoTran.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right"> Monto: &nbsp; </td>
					<td><input size="10" maxlength="10" type="text" name="monto" onkeypress="return justNumbers(event);" 
						<cfif isdefined('form.ID_AJ') and form.modo eq 'CAMBIO' >value="#rsAjuste.MONTO#"<cfelse>value=""</cfif>
					> </td>
				</tr>
				<tr>
					<td align="right"> Observaci&oacute;n: &nbsp; </td>
					<td> 
						<textarea name="Observaciones" cols="50" rows="5" maxlength="255"><cfif modo eq 'CAMBIO'><cfif isdefined('form.ID_AJ') and form.modo eq 'CAMBIO' >#rsAjuste.Observaciones#</cfif></cfif></textarea>
						<br/>
						<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center">
						<cfset _include = "Regresar">
						<cfif modo eq "cambio">
							<cfset _include = "Aplicar,#_include#">
						</cfif>
						<cf_botones modo="#modo#" include="#_include#">
					</td>
				</tr>
			</table>
		</form>
	<cfelse>
		<cfthrow message="No cuentas con los permisos para realizar esta operacion">
	</cfif>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formAjuste");

	function deshabilitarValidacion(){
		objForm.id.required = false;
		objForm.Monto.required = false;
		objForm.Observaciones.required = false;
	}
	
	function habilitarValidacion(){
		objForm.Numero.required = true;
		objForm.monto.required = true;
		objForm.observaciones.required = true;
	}

	function funcRegresar(){
		deshabilitarValidacion();
	}
	
	function justNumbers(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
    }
	
</script>