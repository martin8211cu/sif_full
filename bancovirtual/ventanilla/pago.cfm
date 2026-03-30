
<cfquery name="tramite" datasource="tramites_cr">
	select nombre_tramite
	from TPTramite
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
</cfquery>
<cfquery name="requisito" datasource="tramites_cr">
	select nombre_requisito, coalesce(costo_requisito, 100) as costo, coalesce(moneda, 'USD') as moneda
	from TPRequisito
	where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
</cfquery>

<cfset cuentas = querynew('persona,cuenta')>

<cfset temp = QueryAddRow(cuentas)>
<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CH-012548955')>
<cfset temp = QueryAddRow(cuentas)>
<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CH-8524563')>
<cfset temp = QueryAddRow(cuentas)>
<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CC-2214785')>


<cfoutput>
<input type="hidden" name="id_tramite" value="#url.id_tramite#">
<input type="hidden" name="id_requisito" value="#url.id_requisito#">
<input type="hidden" name="monto" value="#requisito.costo#">
</cfoutput>

<table width="100%" align="center" cellpadding="3"  style=" border:1px solid #595959 " bgcolor="#F4F4F4">
	<TR>
	<td colspan="2">
		<SPAN class="titulo" id="var4"><B>Confirmar Pago de Tr&aacute;mite</B></SPAN><BR>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">Referencia: #url.id_tramite#</font></B></SPAN><BR>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">Tr&aacute;mite: #tramite.nombre_tramite#<br>Requisito: #requisito.nombre_requisito#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
	</TR>
	<tr><td colspan="2"><hr size="1" color="#595959"></td></tr>
	<tr>
		<td width="1%" nowrap><SPAN class="bajadaprod" id="color6"><strong><font color="#595959">Cancelar con la cuenta:&nbsp;</font></strong></SPAN></td>
		<td>
			<select name="cuenta">
				<cfoutput query="cuentas">
					<option value="#cuentas.cuenta#">#cuentas.cuenta#</option>
				</cfoutput>
			</select>
		</td>
	</tr>

<!---
	<cfoutput>
	<tr>
		<td nowrap><SPAN class="bajadaprod" id="color6">El servicio:&nbsp;</SPAN></td>
		<td><SPAN class="bajadaprod" id="color6">Tr&aacute;mite: #tramite.nombre_tramite# / Requisito: #requisito.nombre_requisito#</SPAN></td>
	</tr>
	</cfoutput>
--->	
	
	<tr>
		<td><SPAN class="bajadaprod" id="color6"><strong><font color="#595959">Monto:&nbsp;</font></strong></SPAN></td>
		<td><SPAN class="bajadaprod" id="color6"><strong><font color="#595959"><cfoutput>#LSNumberFormat(requisito.costo,',9.00')#, #requisito.moneda#</cfoutput></font></strong></SPAN></td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	
</table>



<br>
<table align="center">
	<tr>
		<td><img style="cursor:hand; " src="../images/aceptar.gif" onClick="document.form1.submit();"></td>
		<td><img style="cursor:hand; " src="../images/regresar.gif" onClick="location.href='tramites_detalle.cfm?id_tramite=<cfoutput>#url.id_tramite#</cfoutput>'"></td>
	</tr>
</table>
