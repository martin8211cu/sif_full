<!--- Definición del modo --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select a.Ccuenta, a.Cdescripcion, b.Ctipo
	from CContables a, CtasMayor b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Cmovimiento = <cfqueryparam cfsqltype="cf_sql_char" value="S">
	  and a.Ecodigo = b.Ecodigo
	  and a.Cmayor = b.Cmayor
	order by a.Cdescripcion
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="rsAFCuentasRet" datasource="#Session.DSN#">
		select Ecodigo, AFRmotivo, AFRdescripcion, AFRgasto as Ccuenta1, AFRingreso as Ccuenta2, AFRtransito as Ccuenta0, AFResventa, ts_rversion
		  from AFRetiroCuentas
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and AFRmotivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFRmotivo#">
	</cfquery>
</cfif>

<cfif modo EQ "ALTA">
	<cfset rsAFCuentasRet = QueryNew("dato") >
</cfif>

<cfoutput>
<form action="SQLAFCuentasRet.cfm" method="post" name="form1" >
	<table width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Motivo:&nbsp;</strong></td>
			<td>
				<input name="AFRmotivo" type="text" 
					<cfif modo neq 'ALTA'>tabindex="1" disabled<cfelse>tabindex="1"</cfif>
					value="<cfif modo neq 'ALTA'>#rsAFCuentasRet.AFRmotivo#</cfif>" 
					size="10" maxlength="10" alt="El campo motivo" onfocus="this.select();"
					onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				<input name="AFRmotivoL" type="hidden" tabindex="-1" value="<cfif modo neq 'ALTA'>#rsAFCuentasRet.AFRmotivo#</cfif>" size="10" maxlength="10" alt="El campo motivo">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="AFRdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsAFCuentasRet.AFRdescripcion#</cfif>" size="50" maxlength="80" alt="El campo Descripción" onfocus="this.select();">
			</td>
			<cfif modo eq "CAMBIO">
				<td>
					<input type="hidden" name="AFRdescripcionL" id="AFRdescripcionL" tabindex="-1"
					value="#trim(rsAFCuentasRet.AFRdescripcion)#"></td>			
			</cfif>									  			
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><strong>Dinero en Tr&aacute;nsito:&nbsp;</strong></td>
			<td>
				<cf_cuentas Ccuenta="Ccuenta0" query="#rsAFCuentasRet#" auxiliares="N" movimiento="S" descwidth="30" Ctipo="A" tabindex="1">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><strong>Cuenta de Gasto:&nbsp;</strong></td>
			<td>			
				<cf_cuentas Ccuenta="Ccuenta1" query="#rsAFCuentasRet#" auxiliares="N" movimiento="S" descwidth="30" Ctipo="G" tabindex="2">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><strong>Cuenta de Ingreso:&nbsp;</strong></td>
			<td>
				<cf_cuentas Ccuenta="Ccuenta2" query="#rsAFCuentasRet#" auxiliares="N" movimiento="S" descwidth="30" Ctipo="I" tabindex="3">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap>&nbsp;</td>
			<td>
				<input type="checkbox" name="AFResventa" tabindex="4" value="<cfif modo neq 'ALTA' >#rsAFCuentasRet.AFResventa#</cfif>" <cfif modo neq 'ALTA' and rsAFCuentasRet.AFResventa EQ "S">checked</cfif>>
				<strong>Es Venta</strong>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap> 
				<cf_botones modo="#modo#" tabindex="4">
			</td>
		</tr>
		<tr>
			<td>
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsAFCuentasRet.ts_rversion#"/></cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="#ts#">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<cf_qforms>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.AFRdescripcion.description = "Descripción";
	objForm.Ccuenta0.description = "Dinero en Tránsito";
	objForm.Ccuenta1.description = "Cuenta de Gasto";
	objForm.Ccuenta2.description = "Cuenta de Ingreso";

	function habilitarValidacion(){
		deshabilitarValidacion()
		objForm.AFRdescripcion.required = true;
		objForm.Ccuenta0.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.AFRdescripcion.required = false;
		objForm.Ccuenta0.required = false;
	}	
	//-->
</script>