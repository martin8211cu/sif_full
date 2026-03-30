<cfquery name="rsTareaRS" datasource="#session.DSN#">
	select TPid,TPxml,TPfecha
	from ISBtareaProgramada 
	where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
			and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
			and TPestado = 'P'
			and TPtipo = 'RS'
</cfquery>

<cfquery name="rsMotivo" datasource="#session.DSN#">
	select 	MRid,MRcodigo,MRnombre
	from 	ISBmotivoRetiro 
	where 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="gestion-retiro-servicios-apply.cfm" onsubmit="javascript: return validar(this);">
		<cfinclude template="gestion-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	  	
			<!-------------------------------------Pintado del XSL de RETIRO DE SERVICIO si existe la Tarea Programada--------------------------------------->
			<tr valign="top"><td class="tituloAlterno" align="center"colspan="2">Tarea Programada</td></tr>	
			<cfif isdefined("rsTareaRS.TPid") and len(trim(rsTareaRS.TPid))>
				<tr><td colspan="2" align="center">
					<table border="0" cellpadding="3" cellspacing="0">
						<tr>
							<td align="right" width="50%"><label>Fecha Programada</label></td>
							<td>#LSDateFormat(rsTareaRS.TPfecha,'dd/mm/yyyy')#</td>
						</tr>
						
						<cfsavecontent variable="Lvarxsl"><cfinclude template="/saci/xsd/retiroServicio.xsl"></cfsavecontent>
						<cfoutput>#XmlTransform(rsTareaRS.TPxml, Lvarxsl)#</cfoutput>
							
					</table>
				</td></tr>
				<tr><td colspan="2"><hr /></td></tr>
			<cfelse>
			<tr><td align="center"colspan="2"><strong>--- Actualmente no existen tareas programadas ---</strong></td></tr>		
			</cfif>
			
			<!-------------------------------------Pintado del para el RETIRO DE SERVICIO--------------------------------------->
			<tr valign="top"><td class="tituloAlterno" align="center" colspan="2">Retiro de Servicio</td></tr>	
			
			<tr><td colspan="2" align="center">
				<table border="0" cellpadding="2" cellspacing="0">
					
					<tr>
						<td align="right"><input name="radio" type="radio" value="1" checked/></td>
							<td align="right"><label>Retirar en la fecha</label></td>
							<td><cf_sifcalendario  name="fretiro" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
						<td align="right"><input name="radio" type="radio" value="2" /></td>
						<td><label>Retirar en este momento</label></td>
					</tr>
					
					<tr>
						<td align="right" colspan="2"><label>Motivo de Retiro</label></td>
						<td colspan="3">
							<select name="MRid" id="MRid" tabindex="1">
								<cfloop query="rsMotivo">
								<option value="#rsMotivo.MRid#">#rsMotivo.MRnombre#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<!---<tr>
						<td align="right"><label>Fecha de Retiro</label></td>
						<td>
							<cf_sifcalendario  name="fretiro" value="#LSDateFormat(now(),'dd/mm/yyyy')#">
						</td>
					</tr>	
					--->
					<tr>
						<td align="right" colspan="2">
							<label for="devolucion">Devoluci&oacute;n de Dep&oacute;sitos</label>
						</td>
						<td colspan="3"><input type="checkbox" name="devolucion" id="devolucion"/></td>
					</tr>
				</table>
			</td></tr>
			
			<tr><td align="center" colspan="2">
				<cfset varBotones = "Retirar">
				<cfif isdefined("rsTareaRS.TPid") and len(trim(rsTareaRS.TPid))>
					<cfset varBotones = varBotones & ",Eliminar">
				</cfif>
				<cf_botones names="#varBotones#" values="#varBotones#">
			</td></tr>
		</table>
	</form>

	<script language="javascript" language="javascript">
		var cantTarProgr = 0;
		<cfif isdefined('rsTareaRS') and len(trim(rsTareaRS.TPid))>
			cantTarProgr = new Number('#rsTareaRS.recordCount#');			
		</cfif>
	
		function funcEliminar(){	
			if (confirm("¿Desea Eliminar la Tarea Programada?")){
				document.form1.botonSel.value="Eliminar";
				return true;
			}else 
				return false;
		}
		function validar(formulario){			
			if (document.form1.botonSel.value != "Eliminar"){
				var error_input;
				var error_msg = '';
				
				if (document.form1.MRid.value =="") {
					error_msg += "\n - Debe seleccionar un motivo de retiro.";
					error_input = document.form1.MRid;
				}

				if (document.form1.fretiro.value =="") {
					error_msg += "\n - Debe seleccionar una fecha para la ejecución de la tarea.";
					error_input = document.form1.fretiro;
				}
				
				<!--- Validacion terminada --->
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
				else{
					<!--- Verificacion de si tiene o no tareas programadas --->
					if(cantTarProgr > 0 && document.form1.radio[1].checked){
						if(confirm("¿El paquete actual posee tareas programadas asociadas, aún así desea retirarlo ?"))
							return true;				
						else 
							return false;							
					}else{
						if(confirm("¿Esta seguro que desea retirar el paquete actual?"))
							return true;				
						else 
							return false;					
					}				
				}
			}else 
				return true;
		}
				
	</script>
</cfoutput>