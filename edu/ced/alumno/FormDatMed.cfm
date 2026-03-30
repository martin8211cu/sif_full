
<cfif isdefined("Url.tab") and not isdefined("Form.tab")>
	<cfparam name="Form.tab" default="#Url.tab#">
</cfif>
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfset Form.persona = Url.persona>
</cfif>
<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsEstExpMet">
	select distinct convert(varchar,a.EEMcodigo) as EEMcodigo, a.EEMdescripcion, a.EEMvalores, 
	  a.EEMcardinalidad, b.EEDvalor, b.EEDcodigo , c.Ecodigo
	 from Alumnos c, EstudianteExpedienteDato b,EstudianteExpedienteMetadato a
	where c.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and c.Ecodigo *= b.Ecodigo
	  and c.CEcodigo *= b.CEcodigo
	  and b.EEMcodigo =* a.EEMcodigo
	  and a.EEMcardinalidad != 'N'
	order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden 
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsEstExpMetN">
	
	select convert(varchar,a.EEMcodigo) as EEMcodigo, a.EEMdescripcion, a.EEMvalores, 
	  a.EEMcardinalidad, b.EEDvalor, b.EEDcodigo 
	from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b , Alumnos c
	where c.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and b.Ecodigo =* c.Ecodigo 
	  and b.CEcodigo =* c.CEcodigo 
	  and a.EEMcodigo *= b.EEMcodigo   	  and a.EEMcardinalidad = 'N'
	order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden
	
</cfquery>

<cfif isdefined("Form.persona") and len(trim(form.persona)) neq 0>
	<cfinclude template="../../portlets/pAlumnoCED.cfm">
</cfif>
<form action="SQLDatosMedicos.cfm" method="post" name="FiltroDocumentos">
	<cfoutput>
	<input name="persona" type="hidden" value="<cfif isdefined("form.persona")>#form.persona#</cfif>"> 
	<input name="tab" type="hidden" value="<cfif isdefined("Form.tab")>#form.tab#</cfif>"> 
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.Filtro_Estado")>
		<input type="hidden" name="Filtro_Estado" value="#Form.Filtro_Estado#">
	</cfif>		   
	<cfif isdefined("Form.Filtro_Grado")>
		<input type="hidden" name="Filtro_Grado" value="#Form.Filtro_Grado#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Ndescripcion")>
		<input type="hidden" name="Filtro_Ndescripcion" value="#Form.Filtro_Ndescripcion#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Nombre")>
		<input type="hidden" name="Filtro_Nombre" value="#Form.Filtro_Nombre#">
	</cfif>
	<cfif isdefined("Form.Filtro_Pid")>
		<input type="hidden" name="Filtro_Pid" value="#Form.Filtro_Pid#">
	</cfif>
	<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
	</cfoutput>
	<table width="100%" border="0">
		<tr>
			<td  valign="top">
				<input type="hidden" value="<cfif rsEstExpMet.RecordCount NEQ 0><cfoutput>#rsEstExpMet.Ecodigo#</cfoutput></cfif>"  name="Ecodigo"> 
				<table width="100%" border="0">
					<cfoutput query="rsEstExpMet"> 
						<tr > 
							<td align="right" nowrap>
								<cfif not (rsEstExpMet.EEMvalores EQ "0,1")>
									<strong>#Trim(rsEstExpMet.EEMdescripcion)#:&nbsp;</strong>
								</cfif>
							</td>
							<td> 
								<cfif len(trim(rsEstExpMet.EEMvalores)) EQ 0 >
									<input name="campo_#rsEstExpMet.EEMcodigo#" size="40" maxlength="255" type="text" 
										id="campo_#rsEstExpMet.EEMcodigo#" 
										value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDvalor#</cfif>"  
										onFocus="this.select()">
									<input name="id_campo_#rsEstExpMet.EEMcodigo#" type="hidden"  
										value="<cfif len(trim(rsEstExpMet.EEDcodigo)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>"  >  
								<cfelseif (rsEstExpMet.EEMvalores EQ "0,1")>
									<input name="campo_#rsEstExpMet.EEMcodigo#" type="checkbox" id="campo_#rsEstExpMet.EEMcodigo#" 
										value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDvalor#<cfelse>0</cfif>" <cfif rsEstExpMet.EEDvalor EQ '1'> checked</cfif>>
									<label for="campo_#rsEstExpMet.EEMcodigo#">#Trim(rsEstExpMet.EEMdescripcion)#</label>
									<input  name="id_campo_#rsEstExpMet.EEMcodigo#" type="hidden"  value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>"> 
								<cfelse>
									<cfset temp=ListToArray(#rsEstExpMet.EEMvalores#,",")>
									<select name="campo_#rsEstExpMet.EEMcodigo#" id="campo_#rsEstExpMet.EEMcodigo#">
										<cfloop index="i" list="#rsEstExpMet.EEMvalores#" >
											<cfif #i# EQ #rsEstExpMet.EEDvalor#>
												<option value="#i#" selected><cfif i eq "1">SI<cfelseif i eq "0">NO<cfelse>#i#</cfif></option>
											<cfelse>
												<option value="#i#"><cfif i eq "1">SI<cfelseif i eq "0">NO<cfelse>#i#</cfif></option>
											</cfif>
										</cfloop>
									</select>
									<input name="id_campo_#rsEstExpMet.EEMcodigo#" type="hidden" value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>" > 
								</cfif> 
							</td>
						</tr>
					</cfoutput> 
					
				</table>
				
			</td>
			<td  valign="top" >
				<table width="100%" border="0">
					<cfset  Descrip_ant = "">
					<cfset NuevaBan = 1>
					<cfset cont = 1>
					<cfset contRow = 0>
					<cfoutput query="rsEstExpMetN"> 
						<cfset contRow = contRow + 1>
						<strong>
							<cfif Descrip_ant  NEQ Trim(rsEstExpMetN.EEMdescripcion)>
								<cfif rsEstExpMetN.CurrentRow neq 1 >
									<tr>
										<td align="right" nowrap><strong>Nuevo:&nbsp;</strong></td>
										<td>
											<input name="campo_#EEMcodigo_ant#" id="Campo_#EEMcodigo_ant#" size="40" maxlength="255" 
												type="text"  onFocus="this.select()" >
										</td>
									</tr>
								</cfif>
								<cfset NuevaBan = 0>
								<cfset cont = 1>
								<tr> 
									<td class="area" colspan="2" nowrap><strong>#Trim(rsEstExpMetN.EEMdescripcion)#</strong></td>
								</tr>
								<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>
									<tr> 
										<td nowrap>&nbsp;</td>
										<td> 
											<input name="campo_#rsEstExpMetN.EEMcodigo#_#cont#" id="campo_#rsEstExpMetN.EEMcodigo#_#cont#" 
												size="40" maxlength="255" type="text" onFocus="this.select()" 
												value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDvalor#</cfif>">
											<input  name="id_campo_#rsEstExpMetN.EEMcodigo#_#cont#" type="hidden"  
												value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDcodigo#</cfif>">  
										</td>
									</tr>
								</cfif>										
							<cfelse>
								<cfset NuevaBan = 1>
								<tr> 
									<td nowrap >&nbsp;</td>
									<td> 
										<input name="campo_#rsEstExpMetN.EEMcodigo#_#cont#" id="campo_#rsEstExpMetN.EEMcodigo#_#cont#" 
											size="40" maxlength="255" type="text" onFocus="this.select()" 
											value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDvalor#</cfif>">
										<input name="id_campo_#rsEstExpMetN.EEMcodigo#_#cont#" type="hidden" 
											value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDcodigo#</cfif>" >  
									</td>
								</tr>
							</cfif>
						</strong>
						<cfset  Descrip_ant = Trim(rsEstExpMetN.EEMdescripcion)>
						<cfset  EEMcodigo_ant = Trim(rsEstExpMetN.EEMcodigo)>
						<cfset cont = cont + 1>
						<cfif contRow eq rsEstExpMetN.RecordCount>
							<tr>
								<td align="right" nowrap><strong>Nuevo:&nbsp;</strong></td>
								<td>
									<input name="Campo_#rsEstExpMetN.EEMcodigo#" id="Campo_#rsEstExpMetN.EEMcodigo#"
										size="40" maxlength="255" type="text"  onFocus="this.select()" >
								</td>
							</tr>
						</cfif>
					</cfoutput> 
				</table>
			</td>
		</tr>
		<tr><td colspan="2" align="center"><cf_botones names="Aceptar" values="Aceptar"></td></tr>
	</table>
</form>



