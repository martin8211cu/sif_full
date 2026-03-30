<html>
<head>
<title>Seleccione el Componente Salarial que desea Agregar</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<cf_templatecss>
</head>

<cf_templatecss >

<body>

<cfif isdefined("url.btnAgregar")>
	<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarComponente" > 			
		<cfinvokeargument name="RHMPid" value="#url.RHMPid#" > 
		<cfinvokeargument name="CSid" value="#url.CSid#"	> 
		<cfinvokeargument name="Cantidad" value="" > 
		<cfinvokeargument name="Monto" value="#url.monto#" > 
		<cfinvokeargument name="CFormato" value="" > 
	</cfinvoke>

	<script language="JavaScript" type="text/javascript">
		window.opener.document.form1.action='registro-movimientos.cfm';
		window.opener.document.form1.submit();
		window.close();
	</script>

<cfelseif isdefined("url.mod")>
	<!--- Modifica el movimiento, esto para no perder los cambios en caso de haber digitado algo --->
	<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" > 
		<cfinvokeargument name="RHMPid"  			value="#url.RHMPid#" > 
		<cfinvokeargument name="RHMPPid"  			value="#url.puesto#" > 
		<cfinvokeargument name="RHCid"  			value="#url.cat#" > 
		<cfinvokeargument name="RHTTid"  			value="#url.tabla#" > 
		<cfinvokeargument name="RHMPnegociado"  	value="#url.neg#" >
		<cfinvokeargument name="RHMPestadoplaza"  	value="#url.estado#" >
		<cfinvokeargument name="CFidnuevo"  		value="#url.cf#" > 
		<cfinvokeargument name="CFidcostonuevo"  	value="#url.cc#" > 
	</cfinvoke>
</cfif>

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
	function validaForm(f) {
		if ( f.monto.value == '' ) {
			f.monto.value = 0;
		}	
		return true;
	}
</script>

<cfquery name="rsComponentes" datasource="#Session.DSN#">
	select a.CSid, a.CSdescripcion, a.CSusatabla
	from ComponentesSalariales a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and not exists(	select 1 
				from RHCMovPlaza 
				where CSid =a.CSid 
				and RHMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPid#"> ) 
	order by a.CScodigo, a.CSdescripcion, a.CSid
</cfquery>

<!---<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Agregar Componente Salarial" tituloalign="center">--->
<cfif rsComponentes.recordCount GT 0>
	<form name="form1" action="rm-agregarcs.cfm" method="get" onSubmit="javascript: return validaForm(this);">
		<input type="hidden" name="RHMPid" value="<cfoutput>#url.RHMPid#</cfoutput>">
		<table width="100%" border="0" cellspacing="0" cellpadding="3">
			<tr>
				<td class="tituloListas" nowrap>Componente Salarial</td>
				<td class="tituloListas" align="right" nowrap>Monto</td>
			</tr>
			
			<tr>
				<td>
					<select name="CSid">
						<cfoutput query="rsComponentes">
							<option value="#rsComponentes.CSid#">#rsComponentes.CSdescripcion#</option>
						</cfoutput>
					</select>
				</td>

				<td height="25" align="right" nowrap><input name="monto" type="text" size="18" maxlength="15"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00"></td>
			</tr>
		
			<tr align="center">
				<td height="25" colspan="3"><br><input name="btnAgregar" type="submit" id="btnAgregar" value="Agregar"></td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
<cfelse>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="center" class="sectionTitle"><b><font size="2">No quedan ning&uacute;n componente por agregar</font></b></td>
	</tr>
	<tr>
	<td align="center"><br><input name="btnCerrar" type="button" id="btnCerrar" value="Cerrar" onClick="javascript: window.close();"></td>
	</tr>
			<tr><td>&nbsp;</td></tr>	
	</table>
</cfif>
<!---<cf_web_portlet_end>--->

</body>
</html>
