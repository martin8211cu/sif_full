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


<form method="get" name="form1" action="pagar-sql.cfm" style="margin:0;">
<cfoutput>
<input type="hidden" name="id_tramite" value="#url.id_tramite#">
<input type="hidden" name="id_requisito" value="#url.id_requisito#">
<input type="hidden" name="cuenta" value="#url.cuenta#">
<input type="hidden" name="monto" value="#url.monto#">
</cfoutput>

<table width="530" align="center" cellpadding="6"  style=" border:1px solid #595959 " bgcolor="#F4F4F4">
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

	<cfoutput>
	<tr>
		<td width="1%" nowrap><SPAN class="bajadaprod" id="color6"><strong><font color="##595959">Cancelar con la cuenta:&nbsp;</font></strong></SPAN></td>
		<td width="1%" nowrap><SPAN class="bajadaprod" id="color6"><strong><font color="##595959">#url.cuenta#</font></strong></SPAN></td>
	</tr>
	<tr>
		<td><SPAN class="bajadaprod" id="color6"><strong><font color="##595959">Monto:&nbsp;</font></strong></SPAN></td>
		<td><SPAN class="bajadaprod" id="color6"><strong><font color="##595959"><cfoutput>#LSNumberFormat(requisito.costo,',9.00')#, #requisito.moneda#</cfoutput></font></strong></SPAN></td>
	</tr>
	</cfoutput>

<!---
	<tr>
		<td><input type="submit" value="Aceptar" name="Aceptar" ></td>
	</tr>
--->	
</table>
</form>

<br>
<table align="center">
	<tr>
		<td><img style="cursor:hand; " src="../images/aceptar.gif" onClick="document.form1.submit();"></td>
		<td><img style="cursor:hand; " src="../images/regresar.gif" onClick="location.href='pagar.cfm?id_tramite=<cfoutput>#url.id_tramite#</cfoutput>&id_requisito=<cfoutput>#url.id_requisito#</cfoutput>'"></td>
	</tr>
</table>