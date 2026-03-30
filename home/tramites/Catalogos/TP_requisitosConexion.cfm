<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatosC" datasource="#session.tramites.dsn#">
		select * 
		from TPRequisito 
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	
</cfif>
<cfoutput>
<form method="post" name="formC" action="Tp_RequisitosSQL.cfm" onsubmit="return validarC();">
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr>
		  <td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Configuraci&oacute;n de la Conexi&oacute;n</font></td>
		</tr>
		<tr><td>&nbsp;</td></tr>						
		</tr>
		<tr valign="baseline"> 
			<td   align="right">Tipo de Conexi&oacute;n:</td>
			<td>
				<input type="radio" name="con_tipo" id="con_tipo1" 
					<cfif isdefined('rsDatosC.con_tipo') and  Ucase(trim(rsDatosC.con_tipo)) eq "NONE" >checked</cfif>
					value="NONE">
				<label for="con_tipo1">&nbsp;Ninguna</label>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">&nbsp;</td>
			<td>
				<input type="radio" name="con_tipo" id="con_tipo2" 
				<cfif  isdefined('rsDatosC.con_tipo') and  Ucase(trim(rsDatosC.con_tipo)) eq "WS" >checked </cfif>
				value="WS">
				<label for="con_tipo2">&nbsp;Web Service URL</label>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">&nbsp;</td>
			<td>
				<input type="radio" name="con_tipo" id="con_tipo3"
				<cfif   isdefined('rsDatosC.con_tipo') and Ucase(trim(rsDatosC.con_tipo)) eq "WSDL" >checked </cfif>
				value="WSDL">
				<label for="con_tipo3">&nbsp;Web Service WSDL</label>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">&nbsp;</td>
			<td>
				<input type="radio" name="con_tipo" id="con_tipo4" 
				<cfif   isdefined('rsDatosC.con_tipo') and  Ucase(trim(rsDatosC.con_tipo)) eq "EJB" >checked </cfif>
				value="EJB">
				<label for="con_tipo4">&nbsp;J2EE EJB JNDI </label>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">&nbsp;</td>
			<td>
				<input type="radio" name="con_tipo" id="con_tipo5" 
				<cfif   isdefined('rsDatosC.con_tipo') and  Ucase(trim(rsDatosC.con_tipo)) eq "CFC" >checked </cfif>
				value="CFC">
				<label for="con_tipo5">&nbsp;Componente especial CFC</label>
			</td>
		</tr>	
		<tr valign="baseline"> 
			<td nowrap align="right">Direcci&oacute;n del Servicio (URL):</td>
			<td>
				<input type="text" name="con_url" 
				value="#trim(rsDatosC.con_url)#" 
				size="50" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Usuario:</td>
			<td>
				<input type="text" name="con_usuario" 
				value="#trim(rsDatosC.con_usuario)#" 
				size="50" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Contrase&ntilde;a:</td>
			<td>
				<input type="password" name="con_passwd" 
				value="#trim(rsDatosC.con_passwd)#" 
				size="50" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>	
		<tr valign="baseline"> 
			<td nowrap align="right">Confirmar Contrase&ntilde;a:</td>
			<td>
				<input type="password" name="confir_passwd" 
				value="#trim(rsDatosC.con_passwd)#" 
				size="50" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>		
		<tr><td  align="center" colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="Configurar" value="Guardar Configuración">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">
			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_requisito" value="#rsDatos.id_requisito#">
</form>
</cfoutput>
		<script type="text/javascript" language="javascript1.2">
			function validarC(){
				var msj = '';
				if ( !document.formC.con_tipo1.checked ){
					if ( document.formC.con_url.value == '' ){
						var msj = msj + ' - Dirección del Servicio es requerido.\n';
					}
					if ( document.formC.con_usuario.value == '' ){
						var msj = msj + ' - El usuario es requerido.\n';
					}
					if ( document.formC.con_passwd.value == '' ){
						var msj = msj + ' - El password es requerido.\n';
					}	
					if ( document.formC.con_passwd.value != document.formC.confir_passwd.value ){
						var msj = msj + ' - La contraseña de confirmación es diferente \n';
					}												
				}
				if ( msj != ''){
					msj = 'Se presentaron los siguientes errores:\n' + msj;
					alert(msj)
					return false;
				}
				return true
			}
			
		</script>
