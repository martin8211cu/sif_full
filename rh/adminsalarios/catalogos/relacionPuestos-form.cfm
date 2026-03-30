<cfif isdefined("Form.RHPcodigo") and len(trim(form.RHPcodigo))>  
  <cfset modoRelP="CAMBIO">
<cfelse>  
  <cfset modoRelP="ALTA">  
</cfif>

<cfif modoRelP neq "ALTA">
	<cfquery datasource="#session.dsn#" name="data">
		select EPid, ts_rversion
		from  RHEncuestaPuesto
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="rhp">
	select *
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif modoRelP neq "ALTA">
			and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		</cfif>
</cfquery>	

<cfquery datasource="#session.dsn#" name="ep">
	select ep.EPid, ep.EPcodigo, ep.EPdescripcion, ea.EAdescripcion, ea.EAid
	from EncuestaPuesto ep
		join EmpresaArea ea
			on ep.EAid = ea.EAid
	where ep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	order by ea.EAid, ea.EAdescripcion, ep.EPcodigo, ep.EPdescripcion
</cfquery>

<form action="RHEncuestaPuesto-apply.cfm" onsubmit="return validarRelPuestos(this);" method="post" name="formRelPuestos" id="formRelPuestos">
	<input type="hidden" name="EEid" value="<cfoutput>#HTMLEditFormat(form.EEid)#</cfoutput>">
	<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="0">	
	<tr>
		<td colspan="2" valign="top" align="center" style=" font-size:12px" class="titulolistas"><strong>Seleccione el puesto que desea asociar</strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	  <td valign="top" align="right"><strong>Puesto:&nbsp;</strong></td>
	  <td valign="top">
	  		<strong>
				<cfif  modoRelP neq "ALTA" and isdefined('rhp') and rhp.RecordCount GT 0>
					<cfoutput>
						<input type="hidden" name="RHPcodigo" value="#HTMLEditFormat(rhp.RHPcodigo)#">
						#HTMLEditFormat(rhp.RHPcodigo)# #HTMLEditFormat(rhp.RHPdescpuesto)#
					</cfoutput>
				<cfelse>
				  <cf_rhpuesto form="formRelPuestos">	
				</cfif>
			</strong>			
		</td>
	</tr>
	<td colspan="2" valign="top">
		</td>
	    </tr>
		<tr>
		  	<td align="right" nowrap><strong>Puesto Encuestadora</strong>:&nbsp;</td>
			<td>
			  <cfif modoRelP EQ "ALTA">
					<cf_rhpuestoEnc form="formRelPuestos" EEid="#HTMLEditFormat(form.EEid)#">		 
			  <cfelse>
					<cfquery datasource="#session.dsn#" name="rsPuestoEnc">
						select EPid,a.EPcodigo,a.EPdescripcion
						from EncuestaPuesto a 
							inner join EncuestaEmpresa b
								on a.EEid = b.EEid		
							inner join EmpresaArea ea
								on ea.EAid = a.EAid
						where a.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
							and EPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EPid#">			  
					</cfquery>

				  	<cf_rhpuestoEnc form="formRelPuestos" EEid="#HTMLEditFormat(form.EEid)#" query="#rsPuestoEnc#">	
			  </cfif>
			</td>
	  </tr>
		<tr><td valign="top">&nbsp;</td>
		  
	    </tr>
	<tr><td colspan="3" class="formButtons">
			<cf_botones modo='#modoRelP#'>
	</td></tr>
	</table>
		<cfif modoRelP neq "ALTA">
			<cfoutput>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#data.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfoutput>
		</cfif>
</form>

<script type="text/javascript">
<!--
	function validarRelPuestos(formulario){		
		var error_input;
		var error_msg = '';
		// Validando tabla: RHEncuestaPuesto - RHEncuestaPuesto
			if(!btnSelected('Nuevo', formulario) && !btnSelected('Baja', formulario)){
				// Columna: RHPcodigo Código de Puesto char(10)
				if (formulario.RHPcodigo.value == "") {
					error_msg += "\n - Código de Puesto no puede quedar en blanco.";
					error_input = formulario.RHPcodigo;
				}
				// Columna: EPid Puesto Encuesta numeric
				if (formulario.EPid.value == "") {
					error_msg += "\n - Puesto Encuesta no puede quedar en blanco.";
					error_input = formulario.EPcodigo;
				}				
			}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>