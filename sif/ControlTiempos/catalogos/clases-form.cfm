<!--- Modo --->
<cfset modo = "ALTA">
<cfif isdefined("Form.CTCAcodigo") and len(trim(Form.CTCAcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select CTCAcodigo, CTCAdescripcion, CTCAorden, ts_rversion
		from CTClaseActividad
		Where CTCAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTCAcodigo#">
	</cfquery>
</cfif>
<!--- Form --->

<cfoutput>
<form name="form1" action="clases-sql.cfm" method="post" style="margin:0; ">
	<table align="center">
		<tr > 
			<td nowrap align="right"><strong>Descripci&oacute;n</strong>:&nbsp;</td>
			<td><input name="CTCAdescripcion" type="text" value="<cfif modo NEQ "ALTA">#Trim(rsForm.CTCAdescripcion)#</cfif>" size="50" maxlength="255" alt="El campo Descripción" onFocus="this.select();" ></td>  
		</tr>
		<tr >
			<td nowrap align="right"><strong>Orden</strong>:&nbsp;</td>
			<td>
				<input type="text" name="CTCAorden" size="4" maxlength="4" style="text-align:right;" value="<cfif modo neq 'ALTA'>#trim(rsForm.CTCAorden)#</cfif>" onBlur="javascript:fm(this,0); " onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  >
			</td>
		</tr> 	
	</table>

	<cf_botones modo="#modo#">

	<cfset ts = ""> 
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="CTCAcodigo" value="#rsForm.CTCAcodigo#">
	</cfif>
</form>

<cf_qforms>


<script language="javascript">
	<!--//
		objForm.CTCAdescripcion.description = "Descripci#JSStringFormat('ó')#n";
		objForm.required("CTCAdescripcion");

		function deshabilitarValidacion(){
			objForm.required("CTCAdescripcion",false);
		}

	//-->
</script>
</cfoutput>