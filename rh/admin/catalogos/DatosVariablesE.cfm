<cfif modo EQ "CAMBIO">
	<!--- Consulta del encabezado del dato variable  ---> 
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select	RHEDVid,
				RHEDVcodigo,
				RHEDVdescripcion,
				RHDEorden,
				RHEDVtipo as tipo, 				
				ts_rversion
		from RHEDatosVariables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHEDVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEDVid#">
	</cfquery>
	
	<cfif modo neq "ALTA">
		<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsEncabezado.ts_rversion#"/>
		</cfinvoke>
	</cfif>
</cfif>
<!---Pintado del form--->
<cfoutput>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0" >
 <cfif modo neq 'ALTA'> 
  <input type="hidden" name="ts_rversionE" value="#ts#">
 </cfif> 
	<tr> 
		<td width="17%" align="right" nowrap><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
	    <td width="88%" nowrap>
			<table width="50%" border="0" cellpadding="0" cellspacing="2">
				<tr>
					<td width="50%">
						<input type="hidden" name="RHEDVid" value="<cfif (modo EQ "CAMBIO")>#trim(rsEncabezado.RHEDVid)#<cfelse></cfif>">
						<input type="text" name="RHEDVcodigo" tabindex="1" size="15" maxlength="10" value="<cfif (modo EQ "CAMBIO")>#trim(rsEncabezado.RHEDVcodigo)#<cfelse></cfif>">
						<cfif modo neq 'ALTA'><input type="hidden" name="_RHEDVcodigo" value="#trim(rsEncabezado.RHEDVcodigo)#"></cfif>
					</td>
					<td width="1%" nowrap="nowrap"><strong><cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="RHEDVtipo" >
							<option value="0" <cfif modo neq 'ALTA' and rsEncabezado.tipo eq 0 >selected</cfif> ><cf_translate key="LB_Normal">Normal</cf_translate></option>
							<option value="1" <cfif modo neq 'ALTA' and rsEncabezado.tipo eq 1 >selected</cfif> ><cf_translate key="LB_PolizaRiesgos">P&oacute;liza Riesgos</cf_translate></option>
							<option value="2" <cfif modo neq 'ALTA' and rsEncabezado.tipo eq 2 >selected</cfif> ><cf_translate key="LB_PolizaFidelidad">P&oacute;liza Fidelidad</cf_translate></option>
						</select>
					
					</td>
				</tr>
			</table>
		</td>
	</tr>
  	<tr>
		<td>&nbsp;</td>
	  	<td nowrap colspan="3">
			<textarea name="RHEDVdescripcion" id="RHEDVdescripcion" tabindex="1" rows="5" style="width: 100%"><cfoutput><cfif modo EQ 'CAMBIO'>#rsEncabezado.RHEDVdescripcion#</cfif></cfoutput></textarea>
	   </td>
	</tr>
  	<tr><td nowrap colspan="4">&nbsp;</td></tr>
</table>
</cfoutput>