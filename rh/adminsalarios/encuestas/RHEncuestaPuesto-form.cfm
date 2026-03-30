<cfparam name="url.RHPcodigo" default="">
<cfparam name="url.Ecodigo" default="">
<cfparam name="url.EEid" default="">

<cfquery datasource="#session.dsn#" name="data">
	select rhep.ts_rversion, rhep.EPid
	from  RHEncuestaPuesto rhep
	where rhep.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#" null="#Len(url.RHPcodigo) Is 0#">
	  and rhep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	  and rhep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#" null="#Len(url.EEid) Is 0#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rhp">
	select *
	from RHPuestos
	where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#" null="#Len(url.RHPcodigo) Is 0#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="ep">
	select ep.EPid, ep.EPcodigo, ep.EPdescripcion, ea.EAdescripcion, ea.EAid
	from EncuestaPuesto ep
		join EmpresaArea ea
			on ep.EAid = ea.EAid
	where ep.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#" null="#Len(url.EEid) Is 0#">
	order by ea.EAdescripcion, ea.EAid, ep.EPcodigo, ep.EPdescripcion
</cfquery>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHEncuestaPuesto - RHEncuestaPuesto
				// Columna: RHPcodigo Código de Puesto char(10)
				if (formulario.RHPcodigo.value == "") {
					error_msg += "\n - Código de Puesto no puede quedar en blanco.";
					error_input = formulario.RHPcodigo;
				}
				// Columna: EEid Empresa Encuestadora numeric
				if (formulario.EEid.value == "") {
					error_msg += "\n - Empresa Encuestadora no puede quedar en blanco.";
					error_input = formulario.EEid;
				}
				// Columna: EPid Puesto Encuesta numeric
				if (formulario.EPid.value == "") {
					error_msg += "\n - Puesto Encuesta no puede quedar en blanco.";
					error_input = formulario.EPid;
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

<form action="RHEncuestaPuesto-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="0">	
	<!----
	<tr>
	  <td colspan="3" class="subTitulo">
		Asignaci&oacute;n de c&oacute;digos de puesto </td>
	</tr>
	----->
	<tr>
		<td colspan="2" valign="top" align="center" style=" font-size:12px" class="titulolistas"><strong>Seleccione el puesto que desea asociar</strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	  <td valign="top" align="right"><strong>Puesto:&nbsp;</strong></td>
	  <td valign="top"><strong>
		  <cfif rhp.RecordCount>
			  <cfoutput>
				<input type="hidden" name="RHPcodigo" value="#HTMLEditFormat(rhp.RHPcodigo)#">
				#HTMLEditFormat(rhp.RHPcodigo)# #HTMLEditFormat(rhp.RHPdescpuesto)#
				</cfoutput>
			<cfelse>
			  <cf_rhpuesto query="#rhp#">	
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
              <select name="EPid" id="EPid">
                <cfif Len(data.EPid) Is 0>
                  <option value="" selected>- seleccione -</option>
                </cfif>
                <cfoutput query="ep" group="EAid">
                  <optgroup label="#HTMLEditFormat(EAdescripcion)#"> <cfoutput>
                    <option value="#HTMLEditFormat(ep.EPid)#" <cfif ep.EPid eq data.EPid>selected</cfif> >#HTMLEditFormat(EPcodigo & ' ' & EPdescripcion)#</option>
                  </cfoutput> </optgroup>
                </cfoutput>
              </select>
</td>
	  </tr>
		<tr><td valign="top">&nbsp;</td>
		  
	    </tr>
	<tr><td colspan="3" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
		<cfoutput>
			<input type="hidden" name="EEid" value="#HTMLEditFormat(url.EEid)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
	</cfoutput>
</form>
