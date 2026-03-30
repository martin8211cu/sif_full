<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif>
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfset Form.persona = Url.persona>
</cfif>
<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif>
<cfif isdefined("Url.fRHnombre") and not isdefined("Form.fRHnombre")>
	<cfparam name="Form.fRHnombre" default="#Url.fRHnombre#">
</cfif> 
<cfif isdefined("Url.filtroRhPid") and not isdefined("Form.filtroRhPid")>
	<cfparam name="Form.filtroRhPid" default="#Url.filtroRhPid#">
</cfif> 
<cfif isdefined("Url.FAretirado") and not isdefined("Form.FAretirado")>
	<cfparam name="Form.FAretirado" default="#Url.FAretirado#">
</cfif> 
<cfif isdefined("Url.NoMatr") and not isdefined("Form.NoMatr")>
	<cfparam name="Form.NoMatr" default="#Url.NoMatr#">
</cfif> 
<cfif isdefined("Url.FNcodigo") and not isdefined("Form.FNcodigo")>
	<cfparam name="Form.FNcodigo" default="#Url.FNcodigo#">
</cfif> 
<cfif isdefined("Url.FGcodigo") and not isdefined("Form.FGcodigo")>
	<cfparam name="Form.FGcodigo" default="#Url.FGcodigo#">
</cfif> 

<cfquery datasource="#Session.DSN#" name="rsEstExpMet">
	
	select distinct convert(varchar,a.EEMcodigo) as EEMcodigo, a.EEMdescripcion, a.EEMvalores, 
	  a.EEMcardinalidad, b.EEDvalor, b.EEDcodigo , c.Ecodigo
	from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b , Alumnos c
	where c.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and b.Ecodigo =* c.Ecodigo 
	  and b.CEcodigo =* c.CEcodigo 
	  and a.EEMcodigo *= b.EEMcodigo 
	  and a.EEMcardinalidad != 'N'
	order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden 

</cfquery>

<cfquery datasource="#Session.DSN#" name="rsEstExpMetN">
	
	select convert(varchar,a.EEMcodigo) as EEMcodigo, a.EEMdescripcion, a.EEMvalores, 
	  a.EEMcardinalidad, b.EEDvalor, b.EEDcodigo 
	from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b , Alumnos c
	where c.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and b.Ecodigo =* c.Ecodigo 
	  and b.CEcodigo =* c.CEcodigo 
	  and a.EEMcodigo *= b.EEMcodigo   	  and a.EEMcardinalidad = 'N'
	order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden 

</cfquery>
<link href="file:///D|/css/edu.css" rel="stylesheet" type="text/css">
<cfinclude template="file:///D|/portlets/pNavegacionCED.cfm">
<cfif isdefined("Form.persona") and len(trim(form.persona)) neq 0>
	<cfinclude template="file:///D|/portlets/pAlumnoCED.cfm">
</cfif>
<form action="file:///D|/Temp/SQLDatosMedicos.cfm" method="post" name="FiltroDocumentos">
<table width="100%" border="0">
  <tr>
    <td  valign="top">
		<input type="hidden" value="<cfif rsEstExpMet.RecordCount NEQ 0><cfoutput>#rsEstExpMet.Ecodigo#</cfoutput></cfif>"  name="Ecodigo"> 
		<table width="100%" border="0">
			<cfoutput query="rsEstExpMet"> 
				<tr > 
					<td nowrap>
						<strong>
							#Trim(rsEstExpMet.EEMdescripcion)#
						</strong>
					</td>
					<td> 
					<cfif len(trim(rsEstExpMet.EEMvalores)) EQ 0 >
						<!--- <input name="EEDvalor"   size="40" maxlength="255" type="text" id="EEDvalor" onFocus="this.select()" value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDvalor#</cfif>"> --->
						<input size="40" maxlength="255" type="text" name="campo_#rsEstExpMet.EEMcodigo#" id="campo_#rsEstExpMet.EEMcodigo#" value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDvalor#</cfif>"  onFocus="this.select()"> 
						<input type="hidden"  value="<cfif len(trim(rsEstExpMet.EEDcodigo)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>"  name="id_campo_#rsEstExpMet.EEMcodigo#">  
					<cfelseif (rsEstExpMet.EEMvalores EQ "0,1")>
						<input type="checkbox" name="campo_#rsEstExpMet.EEMcodigo#" id="campo_#rsEstExpMet.EEMcodigo#" value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDvalor#<cfelse>0</cfif>" <cfif rsEstExpMet.EEDvalor EQ '1'> checked</cfif>>
						<input type="hidden"  value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>"  name="id_campo_#rsEstExpMet.EEMcodigo#"> 
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
						<input type="hidden" value="<cfif len(trim(rsEstExpMet.EEDvalor)) NEQ 0>#rsEstExpMet.EEDcodigo#</cfif>"  name="id_campo_#rsEstExpMet.EEMcodigo#"> 
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
										<td nowrap>
											<strong>Nuevo:</strong>
										</td>
										<td>
											<input name="campo_#EEMcodigo_ant#" id="Campo_#EEMcodigo_ant#"   size="40" maxlength="255" type="text"  onFocus="this.select()" >
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
										<input name="campo_#rsEstExpMetN.EEMcodigo#_#cont#" id="campo_#rsEstExpMetN.EEMcodigo#_#cont#"   size="40" maxlength="255" type="text" onFocus="this.select()" value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDvalor#</cfif>">
										<input type="hidden"  value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDcodigo#</cfif>"  name="id_campo_#rsEstExpMetN.EEMcodigo#_#cont#">  
										</td>
									</tr>
								</cfif>										
								
							<cfelse>
								<cfset NuevaBan = 1>
								
								<tr> 
									<td nowrap >&nbsp;</td>
								<!--- <cfset  Descrip_ant = Trim(rsEstExpMetN.EEMdescripcion)> --->
									<td> 
										<input name="campo_#rsEstExpMetN.EEMcodigo#_#cont#" id="campo_#rsEstExpMetN.EEMcodigo#_#cont#"   size="40" maxlength="255" type="text" onFocus="this.select()" value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDvalor#</cfif>">
										<input type="hidden"  value="<cfif len(trim(rsEstExpMetN.EEDvalor)) NEQ 0>#rsEstExpMetN.EEDcodigo#</cfif>"  name="id_campo_#rsEstExpMetN.EEMcodigo#_#cont#">  
									</td>
								</tr>
															
							</cfif>
						</strong>
					
					
				<!--- <cfif NuevaBan eq 1 and rsEstExpMetN.CurrentRow neq 1>
					<tr>
						<td nowrap>
							<strong>Nuevo:</strong>
						</td>
						<td>
							<input name="Campo_#rsEstExpMetN.EEMcodigo#" id="Campo_#rsEstExpMetN.EEMcodigo#"   size="40" maxlength="255" type="text"  onFocus="this.select()" >
						</td>
					</tr>
				</cfif>  --->
				<cfset  Descrip_ant = Trim(rsEstExpMetN.EEMdescripcion)>
				<cfset  EEMcodigo_ant = Trim(rsEstExpMetN.EEMcodigo)>
				<cfset cont = cont + 1>
				<cfif contRow eq rsEstExpMetN.RecordCount>
					<tr>
						<td nowrap>
							<strong>Nuevo:</strong>
						</td>
						<td>
							<input name="Campo_#rsEstExpMetN.EEMcodigo#" id="Campo_#rsEstExpMetN.EEMcodigo#"   size="40" maxlength="255" type="text"  onFocus="this.select()" >
						</td>
					</tr>
				</cfif>
			</cfoutput> 
		</table>
	</td>
  </tr>
  <tr>
  	<td colspan="2" align="center">
	<input type="submit" name="btnFiltrar" tabindex="5" value="Aceptar"> 
	<input name="persona" type="hidden" value="<cfif isdefined("form.persona")><cfoutput>#form.persona#</cfoutput></cfif>"> 
	<input name="o" type="hidden" value="<cfif isdefined("Form.o")><cfoutput>#form.o#</cfoutput></cfif>"> 
	<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.fRHnombre")>
		<input type="hidden" name="fRHnombre" value="<cfoutput>#Form.fRHnombre#</cfoutput>">
	</cfif>		   
	<cfif isdefined("Form.FNcodigo")>
		 <input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.filtroRhPid")>
		 <input type="hidden" name="filtroRhPid" value="<cfoutput>#Form.filtroRhPid#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.FGcodigo")>
		<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.NoMatr")>
		<input type="hidden" name="NoMatr" value="<cfoutput>#Form.NoMatr#</cfoutput>">
	</cfif>		  		  
	<cfif isdefined("Form.FAretirado")>
		<input type="hidden" name="FAretirado" value="<cfoutput>#Form.FAretirado#</cfoutput>">
	</cfif>		
	</td>
  </tr>
</table>
</form>



