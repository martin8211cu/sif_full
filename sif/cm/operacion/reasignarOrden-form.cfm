<cfif not isdefined("form.comprador")>
	<cfset form.comprador = session.compras.Comprador >
</cfif>

<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	
	.iframe {
		border-bottom-style: nome;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
	}
</style>

<cfquery name="dataOrden" datasource="#session.DSN#">
	select EOidorden, EOnumero, Observaciones, CMTOcodigo, EOfecha
	from EOrdenCM
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and CMCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comprador#">
	and EOestado in (0, 5, 7, 8)
	order by EOnumero
</cfquery>

<cfquery name="dataComprador" datasource="#session.DSN#">
	select CMCid, CMCnombre 
	from CMCompradores 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and CMCestado=1
</cfquery>

<script type="text/javascript" language="javascript1.2">
	function asignar(value){
		
		document.form1.EOidorden.value =  value;
		document.getElementById("fr").src = 'reasignarCompradorOrden.cfm?EOidorden='+value;
		return false;
	}
	function validar() {
		var error = false;
		var msg   = "Se presentaron los siguientes errores:\n"
		if ( document.form1.EOidorden.value == '' ){
			msg += " - Debe seleccionar la Orden de Compra que desea reasignar.\n"
			error = true;
		}

		if ( document.form1.CMCid.value == ''){
			msg += " - Debe seleccionar el comprador al que se le reasignará la Orden de Compra.\n"
			error = true;
		}

		if ( error ){
			alert(msg);
			return !error;
		}
		/*
		if (confirm('Desea reasignar un comprador a la Orden de Compra seleccionada?')) {
			return true;
		} else {
			return false;
		}*/
		
	}
</script>

<cfoutput>
<form name="form1" method="post" action="reasignarOrden-email.cfm" onSubmit="javascript: return validar();" >
	<input type="hidden" name="CMCid" value="">
	<input type="hidden" name="EOidorden" value="">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> Reasignaci&oacute;n de Ordenes de Compra</strong></td>
		</tr>
		
		<!---
		<tr>
			<td colspan="3" align="center">
				<table width="98%" class="areaFiltro">
					<tr><td>Para reasignar cargas de trabajo, debe hacer lo siguiente:</td></tr>
					<tr><td><ul><li>Seleccione el comprador al que va a eliminarle carga de trabajo, por defecto aparece seleccionado el comprador que actualmente esta conectado al sistema.</li></ul></td></tr>
					<tr><td><ul><li>De la lista de &oacute;rdenes asignadas al comprador seleccionado, escoja la orden que quiere eliminarle.</li></ul></td></tr>
				</table>
			</td>
		</tr>
		--->

		<tr>
			<td colspan="3">
				<table width="98%">
					<tr>
						<td width="1%" nowrap><strong>Comprador:&nbsp;</strong></td>
						<td colspan="2">
							<select name="comprador" onChange="document.form1.action='reasignarOrden.cfm'; document.form1.submit();">
								<cfloop query="dataComprador">
									<option value="#dataComprador.CMCid#" <cfif form.comprador eq dataComprador.CMCid>selected</cfif> >#dataComprador.CMCnombre#</option>
								</cfloop>
							</select>
						</td>
					</tr>
				</table> 
			</td>
		</tr>

		<tr><td colspan="3">&nbsp;</td></tr>

		<tr>
			<td class="bottomline"><font size="2"><strong>Lista de Ordenes de Compra asignadas actualmente:</strong></font></td>
			<td>&nbsp;</td>
			<td class="bottomline"><font size="2"><strong>Reasignar Orden de Compra a:</strong></font></td>
		</tr>
		
		<tr>
			<td width="60%" valign="top">
				<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<tr class="tituloListas">
						<td width="1%">&nbsp;</td>
						<td nowrap><strong>N&uacute;mero</strong></td>
						<td nowrap align="center"><strong>Fecha</strong></td>
						<td nowrap><strong>Descripci&oacute;n</strong></td>
						<td nowrap align="center"><strong>Tipo de Orden</strong></td>
					</tr>
					<cfif dataOrden.RecordCount gt 0>
						<cfloop query="dataOrden">
							<tr class="<cfif dataOrden.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td valign="middle" width="1%"><input type="checkbox" name="rb" value="#dataOrden.EOidorden#"  onClick="javascript:asignar(this.value);"></td>
								<td valign="middle">#dataOrden.EOnumero#</td>
								<td valign="middle" align="center">#LSDateFormat(dataOrden.EOfecha, 'dd/mm/yyyy')#</td>
								<td valign="middle">#dataOrden.Observaciones#</td>
								<td valign="middle" align="center">#dataOrden.CMTOcodigo#</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr><td colspan="5" align="center"><strong> - No existen Ordenes de Compra asignadas a este comprador - </strong></td></tr>
					</cfif>
				</table> 
			</td>
			<td>&nbsp;</td>
			<td width="40%" valign="top" align="center">
				<iframe name="fr" id="fr" src="reasignarCompradorOrden.cfm" width="100%" frameborder="0" scrolling="yes"></iframe>
			</td>
		</tr>
		<tr><td colspan="3" align="center">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><input type="submit" name="Procesar" value="Reasignar"></td></tr>
		<tr><td colspan="3" align="center">&nbsp;</td></tr>
	</table>
</form>
</cfoutput>

