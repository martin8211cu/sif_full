<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("Form.RHOSid") and Len(Trim(Form.RHOSid))>
	<cfset modo = "CAMBIO">
</cfif>
<!--- Consultas --->
<cfquery name="rsTipo" datasource="#session.DSN#">
	select RHTOid,RHTOcodigo,RHTOdescripcion from  RHTipoObjetivo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by RHTOcodigo
</cfquery>

<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 
			RHOSid,RHOScodigo,RHOStexto,RHTOid,RHOSporcentaje,RHOSpeso,ts_rversion
		from RHObjetivosSeguimiento
		where RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOSid#">
		and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>


<cfoutput>	
	<form action="SQLObjetivos.cfm"  method="post" name="form1" >
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" class="tituloAlterno" align="center">
					<cfif modo NEQ 'ALTA'>
						<cf_translate key="LB_ModificacionDelTipoDeObjetivo">Modificaci&oacute;n del  Objetivo</cf_translate>
					<cfelse>
						<cf_translate key="LB_NuevoTipoDeObjetivo">Nuevo Objetivo</cf_translate>
					</cfif>
				</td>
			</tr>
			<tr>
				<td width="31%" align="right">
					<cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:
				</td>
				<td width="69%">
					<input type="text" name="RHOScodigo" <cfif modo NEQ 'ALTA'> readonly </cfif>  
					size="11" maxlength="10" tabindex="1"
					value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.RHOScodigo#</cfoutput></cfif>" 
					onfocus="javascript:this.select();">
					<input type="hidden" name="RHOSid" value="<cfif modo NEQ 'ALTA'>#rsForm.RHOSid#</cfif>" >
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="top">
					<cf_translate key="LB_Objetivo" XmlFile="/rh/generales.xml">Objetivo</cf_translate>:
				</td>
				<td>
					<textarea name="RHOStexto" id="RHOStexto" tabindex="1" rows="4" style="width: 100%"><cfif modo NEQ 'ALTA'>#rsForm.RHOStexto#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="top">
					<cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:
				</td>
				<td>
					<select name="RHTOid"  tabindex="1">
						<cfloop query="rsTipo">
							<option value="#rsTipo.RHTOid#"
							<cfif  isdefined("rsForm.RHTOid") and len(trim(rsForm.RHTOid)) and rsTipo.RHTOid EQ rsForm.RHTOid> 
								selected
							</cfif>
							>#rsTipo.RHTOcodigo#-#rsTipo.RHTOdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="top">
					<cf_translate key="LB_Porcentaje" XmlFile="/rh/generales.xml">Porcentaje</cf_translate>:
				</td>
				<td>
					<input  style="text-align: right;" 
						name="RHOSporcentaje" 
						type="text" 
						id="RHOSporcentaje"  
						tabindex="1"
						onBlur="javascript: fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						size="6" maxlength="6"
						value="<cfif isdefined("rsForm.RHOSporcentaje") and len(trim(rsForm.RHOSporcentaje))>#LSNumberFormat(rsForm.RHOSporcentaje,',.00')#<cfelse>0.00</cfif>">%
					
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="top">
					<cf_translate key="LB_Porcentaje" XmlFile="/rh/generales.xml">Peso</cf_translate>:
				</td>
				<td>
					<input  style="text-align: right;" 
						name="RHOSpeso" 
						type="text" 
						id="RHOSpeso"  
						tabindex="1"
						onBlur="javascript: fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						size="6" maxlength="6"
						value="<cfif isdefined("rsForm.RHOSpeso") and len(trim(rsForm.RHOSpeso))>#LSNumberFormat(rsForm.RHOSpeso,',.00')#<cfelse>0.00</cfif>">
				</td>
			</tr>
			
			</tr>
				<td colspan="2" class="formButtons">
					<cfif isdefined("rsForm") and rsForm.RecordCount>
						<cf_botones modo='CAMBIO'>
					<cfelse>
						<cf_botones modo='ALTA'>
					</cfif>
				</td>
			</tr>			
		</table> 
		<cfset ts = "">
		<cfif isdefined("rsForm") and rsForm.RecordCount>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</form>
	<cf_qforms>
	
	<script type="text/javascript">
	  function Porcentaje_valida(){
			var Cantidad = new Number(this.value)	
			if ( Cantidad <= 0){
				this.error = "El porcentaje debe ser mayor a cero";
			}
			if ( Cantidad > 100){
				this.error = "El porcentaje debe ser menor a cien";
			}		
		}
		function Peso_valida(){
			var Cantidad = new Number(this.value)	
			if ( Cantidad <= 0){
				this.error = "El peso debe ser mayor a cero";
			}
			if ( Cantidad > 100){
				this.error = "El peso debe ser menor a cien";
			}		
		}
		
		
		objForm.RHOScodigo.required        	= true;
		objForm.RHOScodigo.description     	= "#LB_Codigo2#";	
		objForm.RHOStexto.required   		= true;
		objForm.RHOStexto.description		="#LB_Objetivo#";
		objForm.RHTOid.required   			= true;
		objForm.RHTOid.description			="#LB_Tipo#";
		objForm.RHOSporcentaje.required   	= true;
		objForm.RHOSporcentaje.description	="#LB_Porcentaje#";	
		objForm.RHOSpeso.required   		= true;
		objForm.RHOSpeso.description		="#LB_Peso#";
		_addValidator("isPeso", Peso_valida);
		objForm.RHOSpeso.validatePeso();		
		_addValidator("isPorcentaje", Porcentaje_valida);
		objForm.RHOSporcentaje.validatePorcentaje();	
				
		function habilitarValidacion(){
			objForm.RHOScodigo.required    		= true;
			objForm.RHOStexto.required			= true;
			objForm.RHTOid.required   			= true;
			objForm.RHOSporcentaje.required   	= true;
			objForm.RHOSpeso.required   		= true;
		}
		function deshabilitarValidacion(){
			objForm.RHOScodigo.required    		= false;
			objForm.RHOStexto.required			= false;
			objForm.RHTOid.required   			= false;
			objForm.RHOSporcentaje.required   	= false;
			objForm.RHOSpeso.required   		= false;
		}	
		
			
	</script>
</cfoutput>