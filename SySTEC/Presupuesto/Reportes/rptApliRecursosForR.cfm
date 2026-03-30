<cf_htmlReportsHeaders irA="rptApliRecursosFor.cfm" FileName="OriApliRecForm.xls" title="Origen y Aplicación de Recursos(Aplicado a la Formulación)">
<cfsetting enablecfoutputonly="no">
<cfflush interval="1000">
<cf_templatecss>
<cfinclude template="rptApliRecursosForQ.cfm">
	<cfset ncol = 4>
<cfif form.TipoCat EQ 'typeCol'>
	<cfset ncol += rsPCDCatalogo.RecordCount>
</cfif>
<cfif isdefined('form.chkColGO')>
	<cfset ncol += rsGO.Recordcount>
</cfif>

<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center" colspan="#ncol#"><font size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>Origen y Aplicación de Recursos(Aplicado a la Formulación)</strong></font></td></tr>
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
        <cfif form.TipoCat EQ 'typeCol'>
        	<td colspan="#rsPCDCatalogo.Recordcount + 1#" align="center"><strong>Origen de Recursos</strong> </td>
        </cfif>
    </tr>
	<tr><td colspan="#ncol#"><HR width=100% align="center"></td></tr>
    <tr>
				<td class="tituloListas">Cuenta</td>
				<td class="tituloListas">Descripción</td>
				<td class="tituloListas" align="right" style="border-right:groove">Total</td>
		<cfif isdefined('form.chkColGO')>
			<cfloop query="rsGO">
				<td class="tituloListas" align="center" <cfif rsGO.currentRow EQ rsGO.RecordCount>style="border-right:groove"</cfif>>#rsGO.GOnombre#</td>
			</cfloop>
		</cfif>
		<cfif form.TipoCat EQ 'typeCol'>
			<cfloop query="rsPCDCatalogo">
				<td class="tituloListas"  align="center"><cfoutput>#rsPCDCatalogo.PCDdescripcion#</cfoutput></td>
			</cfloop>
				<td class="tituloListas" align="center">Otros</td>
		</cfif>
	</tr>
	<cfif form.TipoCat EQ 'typeTot'>
    <tr>
    	<td colspan="1">&nbsp;</td>
        <td align="right"><strong>Origen de Recursos</strong></td>
   </tr>
		<cfloop query="DatosTotales">
				<tr>
					<td>&nbsp;</td>
					<td align="right"><cfoutput>#DatosTotales.Catalogo#</cfoutput></td>
					<td align="right" style="border-right:groove;">#numberFormat(DatosTotales.Total,",9.99")#</td>
					<cfif isdefined('form.chkColGO')>
						<cfloop query="rsGO">
							<td align="right" <cfif rsGO.currentRow EQ rsGO.RecordCount>style="border-right:groove"</cfif>>#numberFormat(evaluate('DatosTotales.GO'& rsGO.CurrentRow),",9.99")#</td>
						</cfloop>
					</cfif>
				</tr>
		</cfloop>
		<tr><td colspan="#ncol#"><HR width=100% align="center"> </td></tr>
	</cfif>
    
    
	<cfloop query="Datos">
		<cfset space= repeatstring("&nbsp;&nbsp;&nbsp;",Datos.nivel)>
		<tr <cfif datos.nivel eq 0>bgcolor="##f5f5f5"<cfelseif Datos.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
				<td nowrap="nowrap">#space# #Datos.CPformato#</td>
				<td nowrap="nowrap">&nbsp;&nbsp;&nbsp;#Datos.CPdescripcion#</td>
				<td nowrap="nowrap" align="right" style="border-right:groove">#numberFormat(Datos.TOTAL,",9.99")#</td>
		<cfif isdefined('form.chkColGO')>
			<cfloop query="rsGO">
				<td align="right" style="padding-left:40px;<cfif rsGO.currentRow EQ rsGO.RecordCount>border-right:groove;</cfif>">#numberFormat(evaluate('datos.GO'& rsGO.CurrentRow),",9.99")#</td>
			</cfloop>
		</cfif>
		<cfif form.TipoCat EQ 'typeCol'>
			<cfloop query="rsPCDCatalogo">
				<td align="right" style="padding-left:40px;">#numberFormat(evaluate('datos.MT'& rsPCDCatalogo.PCDvalor),",9.99")#	</td>
			</cfloop>
				<td align="right" style="padding-left:40px;">#numberFormat(datos.OTROS,",9.99")#</td>
		</cfif>
		</tr>
	</cfloop>
		<tr>
			<td align="center" nowrap="nowrap" colspan="#ncol#" class="tituloListas">---Fin de Consulta---</td>
		</tr>
	<cfif datos.recordcount EQ 0>
		<tr>
			<td colspan="#ncol#" align="center">--- No se encontraron registros ---</td>
		</tr>
	</cfif>
</table>
</cfoutput>	