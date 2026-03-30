<!--- Modo --->
<cfset modo = "ALTA">
<cfif isdefined("Form.CTPcodigo") and len(trim(Form.CTPcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select CTPcodigo, SNcodigo, CTPdescripcion, CTPcobrable, ts_rversion
		from CTProyectos
		Where CTPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTPcodigo#">
	</cfquery>
</cfif>
<!--- Form --->

<cfoutput>
<form name="form1" action="SQLProyectos.cfm" method="post" style="margin:0; ">
	<table align="center">
		<tr > 
			<td nowrap align="right"><strong>Descripci&oacute;n</strong>:&nbsp;</td>
			<td><input name="CTPdescripcion" type="text" value="<cfif modo NEQ "ALTA">#Trim(rsForm.CTPdescripcion)#</cfif>" size="50" maxlength="255" alt="El campo Descripción" onFocus="this.select();" ></td>  
		</tr>
		<tr >
			<td nowrap align="right"><strong>Socio de Negocios</strong>:&nbsp;</td>
			<td><cfif modo neq 'ALTA'><cf_sifsociosnegocios2 idquery="#rsForm.SNcodigo#"><cfelse><cf_sifsociosnegocios2></cfif></td>
		</tr> 	
	</table>

	<cf_botones modo="#modo#">


	<cfset ts = ""> 
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="CTPcodigo" value="#rsForm.CTPcodigo#">
	</cfif>
</form>

<cf_qforms>


<script language="javascript">
	<!--//
		objForm.CTPdescripcion.description = "Descripci#JSStringFormat('ó')#n";
		objForm.required("CTPdescripcion");
		objForm.SNcodigo.description = "Socio de Negocios";
		objForm.required("SNcodigo");
		function deshabilitarValidacion(){
			objForm.required("CTPdescripcion",false);
		}
	//-->
</script>
</cfoutput>