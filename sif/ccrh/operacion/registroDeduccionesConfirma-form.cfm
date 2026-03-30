<cfoutput>
<form name="form1" action="registroDeduccionesConfirma-sql.cfm" method="post" style="margin:0;">
<table width="100%" cellpadding="2" cellspacing="0">
	
	<cfif session.deduccion_empleado.Dnumcuotas gt 15 >
		<tr><td align="center" colspan="2">
				<input type="submit" name="CRegresar" value="<< Regresar" onclick="javascript:regresar();">
				<!--- <input type="submit" name="Aceptar" value="Aceptar Plan de Pagos" onClick="return valida();"> --->
		</td></tr>
	</cfif>

	<tr>
		<td valign="top" width="40%">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Informaci&oacute;n del Financiamiento'>
				<cfquery name="dataTDeduccion" datasource="#session.DSN#" >
					select TDid, TDcodigo, TDdescripcion
					from TDeduccion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.TDid#">
				</cfquery>
				<cfquery name="dataSocio" datasource="#session.DSN#" >
					select SNnumero, SNnombre
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.deduccion_empleado.SNcodigo#">
				</cfquery>
				
				
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td nowrap><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td><td>#dataTDeduccion.TDcodigo# - #dataTDeduccion.TDdescripcion#</td></tr>
					<tr><td><strong>Referencia:&nbsp;</strong></td><td>#session.deduccion_empleado.Dreferencia#</td></tr>
					<tr><td><strong>Descripci&oacute;n:&nbsp;</strong></td><td>#session.deduccion_empleado.Ddescripcion#</td></tr>
					<tr><td><strong>Socio:&nbsp;</strong></td><td>#dataSocio.SNnumero# - #dataSocio.SNnombre#</td></tr>
					<tr><td><strong>Monto:&nbsp;</strong></td><td><cfoutput>#session.deduccion_empleado.Dmonto#</cfoutput></td></tr>
					<tr><td><strong>Inter&eacute;s:&nbsp;</strong></td><td>#LSNumberFormat(session.deduccion_empleado.Dtasa ,',9.00')#%</td></tr>
					<tr><td nowrap><strong>Inter&eacute;s Moratorio:&nbsp;</strong></td><td># LSNumberFormat(session.deduccion_empleado.Dtasainteresmora,',9.00')#%</td></tr>
					<tr><td nowrap><strong>Fecha Documento:&nbsp;</strong></td><td>#session.deduccion_empleado.Dfechadoc#</td></tr>
					<tr><td nowrap><strong>Fecha Inicial:&nbsp;</strong></td><td>#session.deduccion_empleado.Dfechaini#</td></tr>
					<tr><td nowrap><strong>N&uacute;mero de Cuotas:&nbsp;</strong></td><td>#LSNumberFormat(session.deduccion_empleado.Dnumcuotas,',9')#</td></tr>
					<tr><td valign="top"><strong>Observaciones:&nbsp;</strong></td><td>#session.deduccion_empleado.Dobservacion#</td></tr>
				</table>
			<cf_web_portlet_end>
		</td>
		
		<td valign="top">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Plan de Financiamiento'>
				<!--- genera query con datos del financiamiento --->
				<cfinclude template="plan-financiamiento.cfm">

				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#calculo#"
					desplegar="PPnumero,img,fecha,principal,intereses,total,saldofinal"
					etiquetas="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo"
					formatos="S,S,D,M,M,M,M"
					align="right,left,left,right,right,right,right"
					checkboxes="N"
					checkedcol="pagado"
					funcion="void(0)"
					MaxRows="0"
					totales="total" keys="PPnumero"
					incluyeForm="false"	>
				</cfinvoke>				
				
				<cfquery dbtype="query" name="dataCuota" maxrows="1">
					select total
					from calculo
				</cfquery>
				
				<input type="hidden" name="Dmontocuota" value="#dataCuota.total#">
				
			<cf_web_portlet_end>
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center" colspan="2">
			<input type="submit" name="CRegresar" value="<< Regresar" onclick="javascript:regresar();">
			<!--- <input type="submit" name="Aceptar" value="Aceptar Plan de Pagos" onClick="return valida();"> --->
	</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
	function regresar(){
		document.form1.action = 'javascript:history.back()';	
	}

	function valida(){
		if ( confirm('Desea aceptar el Plan de Financiamiento?') ){
			return true;
		}
		return false;
	}

</script>