<!---<cfparam name="url.CFid" default="">---->
<cfparam name="url.RHGMid" default="">
<cfparam name="url.CFpk" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHGrupoMateriaCF
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#" null="#Len(url.CFpk) Is 0#">
	  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHGMid#" null="#Len(url.RHGMid) Is 0#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
<script type="text/javascript">
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: RHGrupoMateriaCF - RHGrupoMateriaCF
		// Columna: RHGMid RHGMid numeric
		if (formulario.RHGMid.value == "") {
			error_msg += "\n - El campo Programa es requerido.";
			error_input = formulario.RHGMcodigo;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Se presentaron los siguientes errores:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
</script>

<form action="programas-cf-sql.cfm" onsubmit="return validar(this);" method="post" name="formgm" id="form1">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="top" align="right"><strong>Centro Funcional:&nbsp;</strong></td>
			<td valign="top">
				<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
					<cfquery name="datacf" datasource="#session.DSN#">
						select CFcodigo, CFdescripcion
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
					</cfquery>
					#trim(datacf.CFcodigo)# - #datacf.CFdescripcion#
				</cfif>
			</td>
		</tr>
		<tr>
			<td valign="middle" align="right"><strong>Programa:&nbsp;</strong></td>
			<td >
				<input type="hidden" name="_RHGMid" value="#data.RHGMid#">
				<cf_rhprogramas form="formgm" idquery="#data.RHGMid#" quitar="#tiene#">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="CFpk" value="#HTMLEditFormat(url.CFpk)#">
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
	<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>
</cfoutput>