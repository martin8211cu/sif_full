<cf_htmlReportsHeaders irA="rptApliRecursosEjec.cfm" FileName="OriApliRecEjec.xls" title="Origen y Aplicación de Recursos(Aplicado a la Ejecución)">
<cfsetting enablecfoutputonly="no">
<cfflush interval="1000">
<cf_templatecss>
<cfinclude template="rptApliRecursosEjecQ.cfm">
<cfset ncol = 4 + rsPCDCatalogo.RecordCount>
<cfif isdefined('form.chkColGO')>
	<cfset ncol += rsGO.Recordcount>
</cfif>

<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>Origen y Aplicación de Recursos(Aplicado a la Ejecución)</strong></font></td></tr>
    <tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>#LvarPCECatalogo#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>#Agrupador#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>#TipoReporte#</strong></font></td></tr>
    <cfloop array="#ArregloCuentas#" index="cuenta">
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>#cuenta#</strong></font></td></tr>
    </cfloop>
    <tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>#FormatoCurrent#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Times New Roman, Times, serif"><strong>Nivel: #form.nivelDet#</strong></font></td></tr>
    <tr>
    		<td colspan="3">&nbsp;</td>
        <cfif isdefined('form.chkColGO')>
        	<td colspan="#rsGO.recordcount#" align="center"><strong>Aplicación de Recursos</strong></td>
        </cfif>
        	<td colspan="#rsPCDCatalogo.Recordcount + 1#" align="center"><strong>Origen de Recursos</strong></td>
    </tr>
     <tr><td colspan="#ncol#"><HR width=100% align="center"> </td></tr>
    <tr>
		    <td class="tituloListas">Cuenta</td>
		    <td class="tituloListas">Descripción</td>
			<td class="tituloListas" align="right" style="border-right:groove">Total</td>
		<cfif isdefined('form.chkColGO')>
			<cfloop query="rsGO">
				<td class="tituloListas" align="center" <cfif rsGO.currentRow EQ rsGO.RecordCount>style="border-right:groove"</cfif>>#rsGO.GOnombre#</td>
			</cfloop>
		</cfif>
		<cfloop query="rsPCDCatalogo">
			<td class="tituloListas" align="center"><cfoutput>#rsPCDCatalogo.PCDdescripcion#</cfoutput></td>
		</cfloop>
			<td class="tituloListas" align="center">Otros</td>
	</tr>

	<cfloop query="Datos">
		<cfset space= repeatstring("&nbsp;&nbsp;&nbsp;",Datos.nivel)>
		<tr <cfif datos.nivel eq 0>bgcolor="##f5f5f5"<cfelseif Datos.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
					<td nowrap="nowrap">#space# #Datos.CPformato#</td>
					<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#Datos.CPdescripcion#</td>
					<td nowrap="nowrap" align="right" style="border-right:groove">#numberFormat(Datos.TOTAL,",9.99")#</td>
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
                    <td align="right" <cfif rsGO.currentRow EQ rsGO.RecordCount>style="padding-left:40px;border-right:groove"<cfelse>style="padding-left:40px;"</cfif>>#numberFormat(evaluate('datos.GO'& rsGO.CurrentRow),",9.99")#</td>
				</cfloop>
			</cfif>
			<cfloop query="rsPCDCatalogo">
					<td align="right" style="padding-left:40px;">#numberFormat(evaluate('datos.MT'& rsPCDCatalogo.PCDvalor),",9.99")#</td>
		  	</cfloop>
					<td align="right" style="padding-left:40px;">#numberFormat(datos.OTROS,",9.99")#</td>
		</tr>
	</cfloop>
		<tr><td align="center" nowrap="nowrap" colspan="#ncol#" class="tituloListas">---Fin de Consulta---</td></tr>

<cfif datos.recordcount gt 0>
<cfelse>
	<tr><td colspan="#ncol#" align="center">--- No se encontraron registros ---</td></tr>
</cfif>
</table>
</cfoutput>	