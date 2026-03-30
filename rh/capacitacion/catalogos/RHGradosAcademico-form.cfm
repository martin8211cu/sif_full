<cfparam name="url.GAcodigo" default="">
	<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
	<cfquery datasource="#session.dsn#" name="data">
		select Ecodigo,GAcodigo,#LvarGAnombre# as GAnombre,GAorden,ts_rversion,BMUsucodigo
		from  GradoAcademico
		where 
		GAcodigo =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GAcodigo#" null="#Len(url.GAcodigo) Is 0#">
	</cfquery>
<cfoutput>


	<form action="RHGradosAcademico-apply.cfm"  method="post" name="form1" id="form1">
		<table width="100%" summary="Tabla de entrada">
			<tr>
				<td valign="top" ><strong>#LB_Nombre#:</strong></td>
				<td valign="top">
				  <input name="GAnombre" id="GAnombre" type="text" value="#HTMLEditFormat(data.GAnombre)#" 
					maxlength="50" size=" 50"
					onFocus="this.select()"  >
			</td>
	 		<tr>
				<td width="17%" valign="top" ><strong>#LB_Orden#:</strong></td>
				<td width="83%" valign="top">
					<input 
						name="GAorden"  
						id="GAorden" 
						type="text" 
						value="#data.GAorden#" 
						maxlength="4" 
						size="4"
						onBlur="javascript: fm(this,0);"  
						onFocus="javascript:this.value=qf(this); this.select();"
						ONKEYUP="if(snumber(this,event,0)){ if(Key(event)=='13') {}}"
					>
				</td>
			</tr> 
			</tr>
				<td colspan="2" class="formButtons">
					<cfif data.RecordCount>
						<cf_botones modo='CAMBIO'>
					<cfelse>
						<cf_botones modo='ALTA'>
					</cfif>
				</td>
			</tr>
		</table>
		<input type="hidden" name="GAcodigo" value="#HTMLEditFormat(data.GAcodigo)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</form>
	<cf_qforms>
	<script type="text/javascript">
		objForm.GAnombre.required= true;
		objForm.GAnombre.description="#LB_Nombre#";	
		objForm.GAorden.required= true;
		objForm.GAorden.description="#LB_Orden#";	
		
		function habilitarValidacion(){
			objForm.GAnombre.required= true;
			objForm.GAorden.required= true;
		}
		
		function deshabilitarValidacion(){
			objForm.GAnombre.required= false;
			objForm.GAorden.required= false;
		}		
	</script>
</cfoutput>


