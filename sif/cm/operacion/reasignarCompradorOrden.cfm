<cf_templatecss>

<script language="javascript" type="text/javascript">
	window.parent.document.form1.CMCid.value = '';
</script>

<cfif isdefined("url.EOidorden")>
	<script language="javascript" type="text/javascript">
		function asignar(value){
			window.parent.document.form1.CMCid.value = value;
		}
	</script>
	
	<cfquery name="dataCompradores" datasource="#session.DSN#">
		select a.CMCid, a.CMCnombre
		from CMCompradores a
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.CMCestado=1
			and a.CMCparticipa = 1
			<!---and a.CMCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.Comprador#">--->
	</cfquery>
	
	<cfoutput>
	<cfif dataCompradores.recordCount gt 0>
		<form name="form2" method="post" style="margin:0; ">
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr class="tituloListas">
					<td width="1%">&nbsp;</td>
					<td nowrap><strong>Comprador</strong></td>
				</tr>
				<cfloop query="dataCompradores">
					<tr class="<cfif dataCompradores.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td width="1%"><input type="radio" name="rb" value="#dataCompradores.CMCid#"  onClick="javascript:asignar(this.value);"></td>
						<td nowrap>#dataCompradores.CMCnombre#</td>
					</tr>
				</cfloop>
			</table> 
		</form>
	<cfelse>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td align="center">No se encontraron registros</td></tr>
		</table>
	</cfif>	
	</cfoutput>

<cfelse>	
	<table width="98%" align="center">
		<tr><td align="center">Para desplegar el listado de Compradores, debe seleccionar una Orden de Compra</td></tr>
	</table>
</cfif>