<cfquery name="rsActivo" datasource="#session.DSN#">
	select Adescripcion, Aplaca
	from Activos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DSplaca#">
</cfquery>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td  align="center" colspan="2">
				<font size="2"><strong>#session.Enombre#</strong></font>
			</td>
		</tr>
		<tr> 
			<td align="center" colspan="2">
				<font style="font-size: 16px; font-weight: bold; " >#rsActivo.Aplaca# - #rsActivo.Adescripcion#</font>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<font style="font-size: 14px; font-weight: bold; " >
					Fecha de la Consulta:&nbsp;#LSDateFormat(Now(),'dd/mm/yyyy')# &nbsp;
					Hora:&nbsp;#TimeFormat(Now(),'medium')#
				</font>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2" class="subTitulo" >
				<font style="font-size: 14px; " >
					Periodo Inicial:&nbsp;#form.Periodoini# &nbsp;
					Mes inicial:&nbsp;#fncualmes(form.Mesini)# &nbsp;
					Periodo Final:&nbsp;#form.Periodo# &nbsp;
					Mes Final:&nbsp;#fncualmes(form.Mes)# &nbsp;
				</font>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
</cfoutput>
