<cfset modo = "ALTA">
<cfif isdefined('form.Snumero') and form.Snumero NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		Select 
			so.Snumero
			, case so.Sestado
				when '0' then 'Inactivo'
				when '1' then 'Activo'
				when '2' then 'Nulo'
			end Sestado
			, case so.Sdonde
				when '0' then 'En la Empresa'
				when '1' then 'Agente Autorizado'
				when '2' then 'Asignado al Cliente'	
			end Sdonde
			, so.LGnumero
			, lo.LGlogin
			, so.AGid
			, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2) as nombreAgente
			, so.ts_rversion
		from ISBsobres so
			left outer join ISBlogin lo
				on lo.LGnumero=so.LGnumero
		
			left outer join ISBagente ag
				on ag.AGid=so.AGid
			
			left outer join ISBpersona per
				on per.Pquien=ag.Pquien
		where so.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
			and so.Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Snumero#" null="#Len(form.Snumero) Is 0#">
	</cfquery>
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';

				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.Pid;
					}
				}
				
				if (formulario.Snumero.value == "") {
					error_msg += "\n - El Sobre no puede quedar en blanco.";
					error_input = formulario.Snumero;
				}
				
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguientes datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
							
				//Confirmaciones
				if(btnSelected('Anular', formulario)){
					if (!confirm('Realmente desea Anular este Sobre ?'))
						return false;
				}						
				if(btnSelected('Asignar', formulario)){
					if (!confirm('Realmente desea Asignar este Agente a este Sobre ?'))
						return false;
				}						

			return true;
		}
	//-->
	</script>
	<cfset pintaDato = false>
	<cfif modo NEQ 'ALTA' and isdefined('data') and data.recordCount GT 0>
		<cfset pintaDato = true>
	</cfif>
	
	<form action="ISBsobres-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBsobres-hiddens.cfm">
		
		<table width="100%"  border="0" cellspacing="2" cellpadding="2">
		  <tr>
			<td colspan="6">&nbsp;</td>
		  </tr>		
		  <tr>
			<td colspan="6" class="subTitulo">Asignaci&oacute;n y Anulaci&oacute;n Individual</td>
		  </tr>  
		  <tr>
			<td colspan="6">&nbsp;</td>
		  </tr> 		  
		  <tr>
			<td width="20%" nowrap align="right"><label>Número visible del sobre:</label></td>
			<td width="17%">&nbsp;&nbsp;<cfif pintaDato>#data.Snumero#<cfelse>&nbsp;</cfif></td>
			<td width="6%" align="right"><label>Log&iacute;n:</label></td>
			<td width="33%">&nbsp;&nbsp;<cfif pintaDato>#data.LGlogin#<cfelse>&nbsp;</cfif></td>
			<td width="6%" align="right"><label>Estado:</label></td>
			<td width="18%">&nbsp;&nbsp;<cfif pintaDato>#data.Sestado#<cfelse>&nbsp;</cfif></td>
		  </tr>
		  <tr>
			<td align="right"><label>Ubicaci&oacute;n:</label></td>
			<td class="subTitulo">&nbsp;&nbsp;<cfif pintaDato>#data.Sdonde#<cfelse>&nbsp;</cfif></td>
			<td align="right"><label>Agente:</label></td>
			<td colspan="3" nowrap>&nbsp;&nbsp;<cfif pintaDato>#data.nombreAgente#<cfelse>&nbsp;</cfif></td>
		  </tr>
		  <tr>
			<td colspan="6" class="subTitulo">&nbsp;</td>
		  </tr> 				
			<cfif modo NEQ 'ALTA' and isdefined('data') and data.AGid EQ ''>
				  <tr>
					<td align="right"><label>Agente:</label></td>
					<td colspan="3">
						<cfset idAgente = "">					
						<cfif isdefined('form.Pquien') and form.Pquien NEQ ''>
							<cfset idAgente = Form.Pquien>
						</cfif>									
						<cf_agenteId
							id="#idAgente#">						
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>					  
			</cfif>		    

		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
					  
		  <tr>
			<td colspan="6" align="center">
			<cfif modo NEQ 'ALTA'>
				<cfif data.AGid EQ ''>
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Regresar,Anular,Asignar" includeValues="Regresar,Anular,Asignar Agente">
				<cfelse>
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Regresar,Anular" includeValues="Regresar,Anular">
				</cfif>
			<cfelse>
				<cf_botones tabindex="1" exclude="Alta,Limpiar" include="Regresar,Anular,Asignar" includeValues="Regresar,Anular,Asignar Agente">			
			</cfif>
				
			</td>
		  </tr>
		</table>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</form>
</cfoutput>