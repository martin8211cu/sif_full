


<cfparam name="url.CFid" default="">

<cfparam name="url.RHGMid" default="">


<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHGrupoMateriaCF
	
		where 
		CFid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#" null="#Len(url.CFid) Is 0#">
	
		and 
		RHGMid =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHGMid#" null="#Len(url.RHGMid) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHGrupoMateriaCF - RHGrupoMateriaCF
		
			
			
				// Columna: CFid CFid numeric
				if (formulario.CFid.value == "") {
					error_msg += "\n - CFid no puede quedar en blanco.";
					error_input = formulario.CFid;
				}
			
		
			
			
				// Columna: RHGMid RHGMid numeric
				if (formulario.RHGMid.value == "") {
					error_msg += "\n - RHGMid no puede quedar en blanco.";
					error_input = formulario.RHGMid;
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

<form action="RHGrupoMateriaCF-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	RHGrupoMateriaCF
	</td></tr>
	
	
		
		
		<tr><td valign="top">CFid
		</td><td valign="top">
		
			<input name="CFid" id="CFid" type="text" value="#HTMLEditFormat(data.CFid)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">RHGMid
		</td><td valign="top">
		
			<input name="RHGMid" id="RHGMid" type="text" value="#HTMLEditFormat(data.RHGMid)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
			
		
	
		
		
			
		
	
		
		
			
		
	
		
		
			
		
	
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
	
	
		
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


