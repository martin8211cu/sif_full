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

<cffunction name="numero" returntype="string">
	<cfset numerito = ''>
	
	<cfloop from="1" to="10" index="i">
		<cfset numerito = numerito & RandRange(0, 9) >
	</cfloop>
	<cfreturn numerito>
</cffunction>







<form method="get" action="pagar-sql.cfm" style="margin:0;">
<cfoutput>
<input type="hidden" name="id_tramite" value="#url.id_tramite#">
<input type="hidden" name="id_requisito" value="#url.id_requisito#">
</cfoutput>

<table width="530" align="center" cellpadding="3"  style=" border:1px solid #595959 " bgcolor="#F4F4F4">
	<TR>
	<td colspan="2">
		<SPAN class="titulo" id="var4"><B>Pago de Tr&aacute;mite Finalizado</B></SPAN>
	</td>	

	<tr>
		<td>
		<cfoutput>
			<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">Referencia:&nbsp;</font></B></SPAN><BR>
		</cfoutput>
		</td>	

		<td>
		<cfoutput>
			<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">#url.id_tramite#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
	</TR>
	
	<tr>
		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">Tr&aacute;mite:</font></B></SPAN><BR>
		</cfoutput>
		</td>	
		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">#tramite.nombre_tramite#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
</tr>		

<tr>
		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">Requisito:</font></B></SPAN><BR>
		</cfoutput>
		</td>	

		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">#requisito.nombre_requisito#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
</tr>		

<tr>
		<td>
		<SPAN class="titulo" id="var4"><B><font size="2" color="#595959">No. Autorizacion:</font></B></SPAN><BR>
		</td>	

		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">#numero()#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
</tr>		

<tr>
		<td>
		<SPAN class="titulo" id="var4"><B><font size="2" color="#595959">No. Transacci&oacute;n:</font></B></SPAN><BR>
		</td>	

		<td>
		<cfoutput>
		<SPAN class="titulo" id="var4"><B><font size="2" color="##595959">#numero()#</font></B></SPAN><BR>
		</cfoutput>
		</td>	
</tr>		


	
	<cfoutput>
	<tr>
		<td width="1%" nowrap><SPAN class="titulo" id="color6"><strong><font size="2" color="##595959">Se d&eacute;bito de la cuenta:&nbsp;</font></strong></SPAN></td>
		<td width="1%" nowrap><SPAN class="titulo" id="color6"><strong><font size="2" color="##595959">#url.cuenta#</font></strong></SPAN></td>
	</tr>
	<tr>
		<td><SPAN class="titulo" id="color6"><strong><font size="2" color="##595959">Monto:&nbsp;</font></strong></SPAN></td>
		<td><SPAN class="titulo" id="color6"><strong><font size="2" color="##595959"><cfoutput>#LSNumberFormat(requisito.costo,',9.00')#, #requisito.moneda#</cfoutput></font></strong></SPAN></td>
	</tr>
	</cfoutput>

</table>
</form>

<table align="center">
	<tr>
		<td><img style="cursor:hand; " src="../images/regresar.gif" onClick="location.href='/cfmx/bancovirtual/paginas/tramites.cfm'"></td>
	</tr>
</table>