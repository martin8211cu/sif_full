<cf_htmlReportsHeaders irA="rptAumDismFor.cfm" FileName="rptAumDismFor.xls" title="Aumentos y Disminuciones para una Versión de Formulación">
<cfsetting enablecfoutputonly="no">
<cfflush interval="1000">
<cf_templatecss>
<cfinclude template="rptAumDismForQ.cfm">
	<cfset ncol = 5>
<cfif isdefined('rsGO')>
	<cfset ncol += rsGO.Recordcount * 3>
</cfif>
<cfif isdefined('rsOficinas')>
	<cfset ncol += rsOficinas.Recordcount * 3>
</cfif>

<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>Aumentos y Disminuciones para una Versión de Formulación</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>#Agrupador#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>#FormatoCurrent#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>Nivel: #form.nivelDet#</strong></font></td></tr>
   
    <tr>
		    	<td class="tituloListas" nowrap="nowrap">Cuenta</td>
		    	<td class="tituloListas" nowrap="nowrap" style="border-right:groove">Descripción</td>
				<td class="tituloListas" colspan="3" align="center" style="border-right:groove">Resumen</td>
		<cfif isdefined('rsGO')>
			<cfloop query="rsGO">
				<td class="tituloListas" colspan="3" align="center" style="border-right:groove">#rsGO.GOnombre#</td>
			</cfloop>
		</cfif>
		<cfif isdefined('rsOficinas')>
			<cfloop query="rsOficinas">
				<td class="tituloListas" colspan="3" align="center" style="border-right:groove"><cfoutput>#rsOficinas.Odescripcion#</cfoutput></td>
			</cfloop>
		</cfif>
	</tr>
	<tr>
				<td>&nbsp;</td>
				<td style="border-right:groove">&nbsp;</td>
				<td align="center"><font color="##0000CC">(+)</font></td>
				<td align="center"><font color="##FF0000">(-)</font></td>
				<td align="center" style="border-right:groove">Efectivo Neto</td>
		<cfif isdefined('rsGO')>
			<cfloop query="rsGO">
				<td align="center"><font color="##0000CC">(+)</font></td>
				<td align="center"><font color="##FF0000">(-)</font></td>
				<td align="center" style="border-right:groove">Efectivo Neto</td>
			</cfloop>
		</cfif>
		<cfif isdefined('rsOficinas')>
			<cfloop query="rsOficinas">
				<td align="center"><font color="##0000CC">(+)</font></td>
				<td align="center"><font color="##FF0000">(-)</font></td>
				<td align="center" style="border-right:groove">Efectivo Neto</td>
			</cfloop>
		</cfif>	
	</tr>
	<cfloop query="Datos">
		<cfset space= repeatstring("&nbsp;",Datos.nivel)>
	<tr <cfif datos.nivel eq 0>bgcolor="##f5f5f5"<cfelseif Datos.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
				<td nowrap="nowrap">#space# #Datos.CPformato#</td>
				<td nowrap="nowrap" style="border-right:groove">#Datos.CPdescripcion#</td>
				<td nowrap="nowrap" align="right">#numberFormat(Datos.ResumenA,",9.99")#</td>
				<td nowrap="nowrap" align="right">#numberFormat(Datos.ResumenD,",9.99")#</td>
				<td nowrap="nowrap" align="right" style="border-right:groove">#numberFormat(Datos.ResumenN,",9.99")#</td>
			<cfif isdefined('rsGO')>
				<cfloop query="rsGO">
				<td align="right">#numberFormat(evaluate('datos.GO'& rsGO.CurrentRow &'A'),",9.99")#</td>
				<td align="right">#numberFormat(evaluate('datos.GO'& rsGO.CurrentRow &'D'),",9.99")#</td>
				<td align="right" style="border-right:groove">#numberFormat(evaluate('datos.GO'& rsGO.CurrentRow &'N'),",9.99")#</td>
				</cfloop>
			</cfif>
		<cfif isdefined('rsOficinas')>
			<cfloop query="rsOficinas">
				<td align="right">#numberFormat(evaluate('datos.Ofi'& rsOficinas.CurrentRow &'A'),",9.99")#	</td>
				<td align="right">#numberFormat(evaluate('datos.Ofi'& rsOficinas.CurrentRow &'D'),",9.99")#	</td>
				<td align="right" style="border-right:groove">#numberFormat(evaluate('datos.Ofi'& rsOficinas.CurrentRow &'N'),",9.99")#	</td>
			</cfloop>
		</cfif>			
	</tr>
	</cfloop>
	<tr>
				<td align="center" nowrap="nowrap" colspan="#ncol#" class="tituloListas">---Fin de Consulta---</td>
	</tr>

<cfif datos.recordcount gt 0>
<cfelse>
	<tr>
				<td colspan="#ncol#" align="center">--- No se encontraron registros ---</td>
	</tr>
</cfif>
</table>
</cfoutput>	