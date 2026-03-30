<cfif modo EQ 'cambio'>
	<cfquery name="Concep" datasource="#Session.DSN#">
		select FPCid,FPCCid,FPCcodigo,FPCdescripcion,ts_rversion
			from FPConcepto
		where FPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.FPCid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#Concep.ts_rversion#" returnvariable="ts"></cfinvoke>
</cfif>
<cfoutput>
<form action="ConceptoGI-sql.cfm" method="post" name="form1">
	<input type="hidden" name="FPCid" 		value="#Concep.FPCid#" />
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="idTree" 		value="#idTree#">
	<input type="hidden" name="IrCla"		value="">
	<table border="0" cellspacing="1" cellpadding="1">
		<tr><td>Clasificacion:</td>
			<cfif len(trim(Concep.FPCCid))>
			<td><cf_ConceptoGatosIngresos name="FPCCid" popup="true" value="#Concep.FPCCid#" ultimoNivel="true"></td>
			<cfelse>
			<td><cf_ConceptoGatosIngresos name="FPCCid" popup="true" ultimoNivel="true"></td>
			</cfif>
			<td><cfif modo EQ 'cambio'><img src="../../imagenes/Bullet01.gif" title="Ir a la clasificación" onclick="fnIrClasificacion()" style="cursor:pointer"/><cfelse>&nbsp;</cfif></td>
		</tr>
		<tr><td>Codigo:</td>
			<td colspan="2"><input name="FPCcodigo" type="text" value="#Concep.FPCcodigo#"  size="20" maxlength="20" tabindex="1"></td>
		</tr>
		<tr><td>Descripcion:</td>
			<td colspan="2"><input name="FPCdescripcion" type="text" value="#Concep.FPCdescripcion#"  size="20" maxlength="100" tabindex="1"></td>
		</tr>
		<tr><td colspan="3">
				<cf_botones modo='#MODO#'>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<cf_qforms>
	<cf_qformsRequiredField name="FPCCid" 	 		description="Categoría">
	<cf_qformsRequiredField name="FPCcodigo" 	 	description="Codigo">
	<cf_qformsRequiredField name="FPCdescripcion"   description="Descripción">
</cf_qforms>
<cfif modo EQ 'cambio'>
<script language="javascript1.2" type="text/javascript">
	
	function fnIrClasificacion(){
		document.form1.IrCla.value = "ClasificacionConcepto.cfm?FPCCid=<cfoutput>#Concep.FPCCid#</cfoutput>";
		document.form1.submit();
	}
	
</script>
</cfif>