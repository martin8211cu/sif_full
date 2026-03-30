<cfif isdefined('url.FAM09MAQ') and not isdefined('form.FAM09MAQ')>
	<cfparam name="form.FAM09MAQ" default="#url.FAM09MAQ#">
</cfif>


<cfset modo = 'ALTA'>
<cfif isdefined('form.FAM09MAQ') and len(trim(form.FAM09MAQ))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM09MAQ, FAM09DES,  ts_rversion
		from FAM009
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM09MAQ#">
	</cfquery>
</cfif>
	
<!--- TERMINAR DE BORRAR--->


<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="maquinas-sql.cfm">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="FAM09MAQ" value="#data.FAM09MAQ#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<tr>
			<!-- dibuja  CODIGO--->
			<td align="right"><strong>C&oacute;digo</strong></td>
			<!-- dibuja el filtro-->
			<td>
				<cfif modo neq 'ALTA'>
					#data.FAM09MAQ#
				<cfelse>
					<input type="text" name="FAM09MAQ" size="10" maxlength="3" value="">
				</cfif> 
			</td>
		</tr>
		<tr>
			<!-- dibuja descripcion--->
			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<!-- dibuja el filtro-->
			<td><input type="text" name="FAM09DES" size="50" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM09DES#</cfif>"></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>

	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>



<!-- MANEJA LOS ERRORES--->

<cf_qforms>
<script language="javascript">
<!--//
	
	objForm.FAM09MAQ.description = "Código";
	objForm.FAM09DES.description = "Descripción";
	
	objForm.FAM09MAQ.required = true;
	objForm.FAM09MAQ.description = "Codigo";
	objForm.FAM09DES.required = true;
	objForm.FAM09DES.description = "Descripcion";
//-->
</script>

</cfoutput>