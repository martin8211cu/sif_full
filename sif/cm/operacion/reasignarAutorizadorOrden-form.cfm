
<!--- caso en que viene de asignar un autorizador a una o varias ordenes (sql)--->
<cfif isdefined("url.comprador") and len(trim(url.comprador)) neq 0 and not isdefined("form.comprador")>
	<cfset form.comprador = url.Comprador >
</cfif>
<!--- caso en llega por primera vez --->
<cfif not isdefined("form.comprador")>
	<cfset form.comprador = session.compras.Comprador >
</cfif>
<!--- <cfdump var="#form.comprador#">
<cfdump var="#form.CDid#"> --->
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
<!--- Query para la lista de Ordenes de compra que cuyo EOestado --->
<cfquery name="dataOrden" datasource="#session.DSN#">
	select eo.EOidorden, eo.EOnumero, eo.Observaciones, eo.CMTOcodigo, eo.EOfecha, eo.CMCid
	from EOrdenCM eo
	where eo.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and eo.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comprador#">
	and eo.EOestado=-7
	and exists (
			select  cm.EOidorden
			from CMAutorizaOrdenes cm
			where cm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and cm.EOidorden=eo.EOidorden 
			and cm.CMAestado=0
			)
	order by eo.EOnumero
</cfquery>

<!--- Compradores Autorizados --->
<cfquery name="dataComprador" datasource="#session.DSN#">
	select CMCid, CMCnombre 
	from CMCompradores 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and CMCestado=1
	and CMCparticipa = 1
</cfquery>

<script type="text/javascript" language="javascript1.2">
	
	function asignar(value){
		
		document.form1.EOidorden.value =  value;
		document.getElementById("fr").src = 'reasignarCompradorOrdenAutorizado.cfm?EOidorden='+value;
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
			msg += " - Debe seleccionar el Autorizador al que se le reasignará la Orden de Compra.\n"
			error = true;
		}

		if ( error ){
			alert(msg);
			return !error;
		}
		
	}
	function seguimiento(id){
		window.open('autorizaSeguimiento.cfm?EOidorden='+id, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=300,left=300,top=225,screenX=150,screenY=150');
	}
</script>

<cfoutput>
<form name="form1" method="post" action="reasignarAutorizadorOrden-email.cfm" onSubmit="javascript: return validar();" >
	<input type="hidden" name="CMCid" value="">
	<input type="hidden" name="EOidorden" value="">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> Reasignaci&oacute;n Autorizador de Ordenes de Compra</strong></td>
		</tr>
		
		<tr>
			<td colspan="3">
				<table width="98%">
					<tr>
						<td width="1%" nowrap><strong>Comprador:&nbsp;</strong></td>
						<td colspan="2">
							<select name="comprador" onChange="document.form1.action='reasignarAutorizadorOrden.cfm'; document.form1.submit();">
								<cfloop query="dataComprador">
									<option value="<cfoutput>#dataComprador.CMCid#</cfoutput>" <cfif form.comprador eq dataComprador.CMCid>selected</cfif>><cfoutput>#dataComprador.CMCnombre#</cfoutput></option>
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
			<td class="bottomline"><font size="2"><strong>Reasignar Autorizador de Orden de Compra a:</strong></font></td>
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
						<td nowrap align="center">&nbsp;</strong></td>
					</tr>
					<cfif dataOrden.RecordCount gt 0>
						<cfloop query="dataOrden">
							<cfset id= dataOrden.EOidorden>
							<tr class="<cfif dataOrden.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td valign="middle" width="1%"><input type="checkbox" name="rb" value="#dataOrden.EOidorden#"  onClick="javascript:asignar(this.value);"></td>
								<td valign="middle">#dataOrden.EOnumero#</td>
								<td valign="middle" align="center">#LSDateFormat(dataOrden.EOfecha, 'dd/mm/yyyy')#</td>
								<td valign="middle">#dataOrden.Observaciones#</td>
								<td valign="middle" align="center">#dataOrden.CMTOcodigo#</td>
								<td valign="middle" align="center"><a href="javascript:seguimiento('#id#')" style="border-bottom-color:##000099; color:##000099" title="Mostrar seguimiento seg&uacute;n la jerarqu&iacute;a">&nbsp;Ver</a> </td>
							</tr>
						</cfloop>
					<cfelse>
						<tr><td colspan="5" align="center"><strong> - No existen Ordenes de Compra asignadas a este comprador - </strong></td></tr>
					</cfif>
				</table> 
			</td>
			<td>&nbsp;</td>
			<td width="40%" valign="top" align="center">
				<iframe name="fr" id="fr" src="reasignarCompradorOrdenAutorizado.cfm" width="100%" frameborder="0" scrolling="yes"></iframe>
			</td>
		</tr>
		<tr><td colspan="3" align="center">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><input type="submit" name="Procesar" value="Reasignar"> <input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href='/cfmx/sif/cm/MenuCM.cfm';"></td></tr>
		<tr><td colspan="3" align="center">&nbsp;</td></tr>
	</table>
</form>


</cfoutput>

	 
	 