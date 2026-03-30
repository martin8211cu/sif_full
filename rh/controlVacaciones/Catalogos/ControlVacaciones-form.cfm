<cfset modo = 'ALTA'>
<cfif isdefined("form.DEid") and len(trim(form.DEid))and isdefined("form.DVAperiodo") and len(trim(form.DVAperiodo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rs_data" datasource="#session.DSN#">
		select DEid, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, ts_rversion, DVAid
		from DVacacionesAcum
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and DVAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAperiodo#">	
		  and (DVASalarioPdiario<>0 or DVASalarioProm<>0)
	</cfquery>	
</cfif>

<cfquery name="rsPeriodosDisponibles" datasource="#session.DSN#">									
	select distinct DVAperiodo as DVEperiodo
	from DVacacionesAcum
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>
	<form name="form1" method="post" action="ControlVacaciones-sql.cfm" style="margin:0;" onsubmit="javascript:document.form1.DVAperiodo.disabled=false;">
	<input type="HIDDEN" name="DVAid" value="<cfif modo NEQ "ALTA">#rs_data.DVAid#</cfif>">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td width="35%" align="right"><cf_translate key="LB_Periodo">Periodo:</cf_translate></td>
				<td width="65%">
					<input name="DVAperiodo" value="<cfif modo NEQ "ALTA">#rs_data.DVAperiodo#</cfif>" type="text" id="DVAperiodo" size="5" maxlength="4"  
					onfocus="javascript:this.value=qf(this,0); this.select();"  onkeyup="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
					onblur="javascript: fm(this,0);" <cfif modo neq 'ALTA'>disabled</cfif>>					 
					<!----<select name="DVAperiodo" <cfif modo neq 'ALTA'>disabled</cfif>>
						<cfloop query="rsPeriodosDisponibles">
							<option id="#rsPeriodosDisponibles.DVEperiodo#" value="#rsPeriodosDisponibles.DVEperiodo#" 
								<cfif modo neq 'ALTA' and rs_data.DVAperiodo EQ rsPeriodosDisponibles.DVEperiodo>selected</cfif> >
									#rsPeriodosDisponibles.DVEperiodo#
							</option>
						</cfloop>				
					</select>---->				
			  </td>
			</tr>
			<tr>
				<td align="right"><cf_translate key="LB_Saldodias">Saldo:</cf_translate></td>
				<td>
					<input name="DVAsaldodias" value="<cfif modo NEQ "ALTA">#rs_data.DVAsaldodias#</cfif>" type="text" id="DVEsaldodias" size="10" maxlength="10"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onblur="javascript: fm(this,0);"> 
				</td>
			</tr>		
			<tr>
				<td align="right"><cf_translate key="LB_SalarioProm">Salario Promedio:</cf_translate></td>
				<td>
					<input name="DVASalarioProm" style="text-align:right" value="<cfif modo NEQ "ALTA">#lscurrencyformat(rs_data.DVASalarioProm,'none')#</cfif>" type="text" id="DVASalrioProm" size="20" onfocus="javascript:this.value=qf(this,2); this.select();" onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onblur="javascript: fm(this,2);"> 
				</td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap"><cf_translate key="LB_SalarioPdiario">Salario Promedio Diario:</cf_translate></td>
				<td>
					<input name="DVASalarioPdiario" style="text-align:right" value="<cfif modo NEQ "ALTA">#lscurrencyformat(rs_data.DVASalarioPdiario,'none')#</cfif>" type="text" id="DVASalrioPdiario" size="20" onfocus="javascript:this.value=qf(this,2); this.select();"  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onblur="javascript: fm(this,2);"> 
				</td>
			</tr>
			<tr>
				<td align="right"><cf_translate key="LB_Fecha">Fecha:</cf_translate></td>
				<td>
					<cfif modo neq "ALTA">
						<cf_sifcalendario form="form1" name="DVAfecha" value="#LSDateFormat(rs_data.DVAfecha,'DD/MM/YYYY')#">
					<cfelse>
						<cf_sifcalendario form="form1" name="DVAfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
					</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2"><cf_botones modo="#modo#" exclude="baja"></td>
			</tr>
			<input type="hidden" name="DEid" value="#form.DEid#" />
			<cfif modo neq 'ALTA'>
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rs_data.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
		</table>
	
	</form>
</cfoutput>

<cf_qforms>

<cfoutput>
	<script>
		objForm.DVAfecha.description = '#LB_Fecha#';
		objForm.DVAperiodo.description = '#LB_Periodo#';
		function habilitarValidacion(){
			objForm.DVAfecha.required = true;
			objForm.DVAperiodo.required = true;
		}
		function deshabilitarValidacion(){
			objForm.DVAfecha.required = false;
			objForm.DVAperiodo.required = false;
		}
	</script>
</cfoutput>

