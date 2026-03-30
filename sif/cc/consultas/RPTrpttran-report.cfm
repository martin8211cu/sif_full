
<cfinclude template="RPTrpttran-queries.cfm">
<cf_templatecss>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<cfoutput>
				<font size="+1"><strong>Reporte de Transacciones Aplicadas al Auxiliar <br />
				#Session.Enombre#<br />
				Moneda: #rsMonedas.Mnombre#<br />
				Clasificaci&oacute;n General<br />
				</strong>
				</font>
			</cfoutput>
			<cfif isdefined("rsClas")>
				<cfoutput query="rsClas" group="SNCEcodigo">
					Clasificaci&oacute;n #rsClas.SNCEcodigo# - #rsClas.SNCEdescripcion#<br />
					<cfoutput>
						<cfif rsClas.RecordCount GT 0 and rsClas.CurrentRow eq 1>Desde<cfelse>Hasta</cfif>: #rsClas.SNCDvalor# - #rsClas.SNCDdescripcion#
					</cfoutput>
				</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr
></table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td class="tituloListas">Fecha</td>
		<td valign="top" class="tituloListas">Saldo Inicial Auxiliar</td>
		<cfloop query="rsEtiquetas">
			<td valign="top" class="tituloListas">#rsEtiquetas.CCTcolrpttranapldesc#</td>
		</cfloop>
		<td valign="top" class="tituloListas">Movimientos</td>
		<td valign="top" class="tituloListas">Saldo Final Auxiliar</td>
	</tr>
	</cfoutput>
	<cfset NoN = false>
	<cfoutput query="rsConsulta" group="Fecha">
	<tr class="<cfif NoN>listaNon<cfelse>listaPar</cfif>">
		<td align="center">
			#LSDateFormat(rsConsulta.Fecha,'dd/mm/yyyy')#
		</td>
		<cfoutput>
			<cfscript>
				if (not isdefined("varsumcol#rsConsulta.col#"))
					Evaluate("varsumcol#rsConsulta.col#=0.00");	
				Evaluate("varsumcol#rsConsulta.col#=varsumcol#rsConsulta.col#+rsConsulta.Monto");
			</cfscript>
			<td align="right" nowrap>
				#LSCurrencyFormat(rsConsulta.Monto,'none')#
			</td>
		</cfoutput>
	</tr>
	<cfset NoN = Not NoN>
	</cfoutput>
	<!--- Fila de Totales --->
	<tr class="tituloListas">
		<td colspan="2" class="tituloListas">Totales</td>
		<cfloop from="1" to="#Lvar_Col+1#" index="col">
			<td class="tituloListas" align="right" nowrap>
				<cfif IsDefined("varsumcol#col#")>
					<strong><cfoutput>#LSCurrencyFormat(Evaluate("varsumcol#col#"),'none')#</cfoutput></strong>
				</cfif>
			</td>
		</cfloop>
		<td colspan="2" class="tituloListas">&nbsp;</td>
	</tr>
</table>
<br />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center">--- Fin del Reporte ---</td>
	</tr>
</table>
<br />
</td>
</tr>
	<tr>
		<td align="center">
			<form action="RPTrpttran.cfm" method="post" name="form1">
				<cf_botones values="Regresar">
			</form>
		</td>
	</tr>

</table>
