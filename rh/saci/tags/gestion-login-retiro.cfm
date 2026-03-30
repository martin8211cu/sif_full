<cfquery name="rsTareaRL" datasource="#Attributes.Conexion#">
	select TPid,TPxml,TPfecha
	from ISBtareaProgramada 
	where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
			and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcuenta#">
			and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
			and TPestado = 'P'
			and TPtipo = 'RL'
</cfquery>

<cfquery name="rsMotivo" datasource="#Attributes.Conexion#">
	select 	MRid,MRcodigo,MRnombre
	from 	ISBmotivoRetiro 
	where 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#">
</cfquery>

<cfoutput>
	
<!--- 	<cfif LoginBloqueado>
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td align="center"><label style="color:##660000">--- #mensArr[5]# ---</label></td></tr>
			</table>
	<cfelse> --->
	
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	  	
			<!-------------------------------------Pintado del XSL de RETIRO DE LOGIN si existe la Tarea Programada--------------------------------------->
			<tr valign="top"><td class="tituloAlterno" align="center"colspan="2">Tarea Programada</td></tr>	
			<cfif isdefined("rsTareaRL.TPid") and len(trim(rsTareaRL.TPid))>
				<tr><td colspan="2" align="center">
					<table border="0" cellpadding="3" cellspacing="0">
						<tr>
							<td align="right"><label>Fecha Programada</label></td>
							<td>#LSDateFormat(rsTareaRL.TPfecha,'dd/mm/yyyy')#</td>
						</tr>
						
						<cfsavecontent variable="Lvarxsl"><cfinclude template="/saci/xsd/retiroLogin.xsl"></cfsavecontent>
						<cfoutput>#XmlTransform(rsTareaRL.TPxml, Lvarxsl)#</cfoutput>
							
					</table>
				</td></tr>
				<tr><td colspan="2"><hr /></td></tr>
			<cfelse>
			<tr><td align="center"colspan="2"><strong>--- Actualmente no existen tareas programadas ---</strong></td></tr>		
			</cfif>
			
			<!-------------------------------------Pintado del para el RETIRO DE LOGIN--------------------------------------->
			<tr valign="top"><td class="tituloAlterno" align="center" colspan="2">Retiro de Login</td></tr>	
			
			<tr><td colspan="2" align="center">
				<table border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td align="right"><input name="radio" type="radio" value="1" checked/></td>
							<td align="right"><label>Retirar en la fecha</label></td>
							<td><cf_sifcalendario  name="fretiro#Attributes.sufijo#" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
						<td align="right"><input name="radio" type="radio" value="2" /></td>
						<td><label>Retirar en este momento</label></td>
					</tr>
					<tr>	
						<td  colspan="2"align="right"><label>Motivo de Retiro</label></td>
						<td colspan="3">
							<select name="MRid#Attributes.sufijo#" id="MRid#Attributes.sufijo#" tabindex="1">
								<cfloop query="rsMotivo">
								<option value="#rsMotivo.MRid#">#rsMotivo.MRnombre#</option>
								</cfloop>
							</select>
						</td>
					</tr>	
				</table>
			</td></tr>	
		</table>
	<!--- </cfif> --->

</cfoutput>