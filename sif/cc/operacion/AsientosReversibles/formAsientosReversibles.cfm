<!--- DÃ­as--->
<cfquery name="rsParamDias" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 330
</cfquery>

<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as Periodo 
		from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	and Pcodigo = 50
</cfquery>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select <cf_dbfunction name="to_integer" args="p1.Pvalor">  + 1 as mes 
		from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	and Pcodigo = 60
</cfquery>

<cfset LvarMes=rsMes.mes>
<cfset LvarPeriodo=rsPeriodo.Periodo>

<cfif LvarMes GT 12>
	<cfset LvarMes=1>
	<cfset LvarPeriodo=LvarPeriodo + 1>
	<cfset fecha = CreateDateTime(LvarPeriodo,LvarMes, 1, 00, 00, 0) >
<cfelse>
	<cfset fecha = CreateDateTime(LvarPeriodo,LvarMes, 1, 00, 00, 0) >
</cfif>

<cfset fecha = DateAdd("s", -1, fecha)>


<cfset dias = "">
<cfif isdefined("rsParamDias") and  rsParamDias.recordCount GT 0>
	<cfset dias = rsParamDias.Pvalor>
</cfif>


<form name="form1" action="SQLAsientosReversibles.cfm" method="post">
	<cfoutput>
	<table width="100%" border="0">
		<tr>
			<td  align="right" nowrap><strong>Cantidad de d&iacute;as de vencimiento:</strong></td>
			<td>
				<input 
					type="text" 
					name="CantDias" 
					size="8" 
					maxlength="8" 
					value="#dias#" 
					style="text-align:right;" 
					onBlur="javascript:fm(this,-1);" 
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Fecha de c&aacute;lculo de incobrables:</strong> </td>
			<td><cf_sifcalendario name="fecha" value="#LSDateFormat(fecha,'dd/mm/yyyy')#"  tabindex="1"></td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Cuenta contable de incobrables: </strong></td>
			<td><cf_cuentas></td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Clasificaci&oacute;n de CXC:</strong></td>
			<td><cf_sifSNClasificacion form="form1" tabindex="1"></td>
		</tr>	
		<tr>
			<td  align="right" nowrap><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde:</strong></td>
			<td><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta:</strong></td>
			<td><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
		</tr>
		<tr>
			<td colspan="2" nowrap>
				<cf_botones values="Generar,Limpiar" names="Generar,Limpiar"  tabindex="1">
			</td>
		</tr>		
	</table>
	</cfoutput>
</form>	
<cf_qforms>
		<cf_qformsRequiredField name="CantDias" description="Cantidad de dÃ­as">
		<cf_qformsRequiredField name="fecha" description="Fecha de CÃ¡lculo">
		<cf_qformsRequiredField name="Ccuenta" description="Cuenta Contable">
</cf_qforms>
