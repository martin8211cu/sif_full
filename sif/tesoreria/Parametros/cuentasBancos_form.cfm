<cfinclude template="../../Utiles/sifConcat.cfm">

<form name="frmTES" style="margin:0;" method="post">
	<table cellpadding="0" cellspacing="6" background="0" width="80%" align="center">
	<tr>
		<td colspan="2">
			<strong>Tesorería:</strong>
			<cf_cboTESid tipo="" onChange="document.frmTES.submit();" tabindex="1">
		</td>
	</tr>
</table>
</form>

<form name="frmTESCB" style="margin:0;" method="post" action="cuentasBancos_sql.cfm">
	<cfquery datasource="#session.dsn#" name="lista1">
		select -1 as Orden, ep.Ecodigo, ep.Edescripcion, cp.CBid, tcb.CBid as TESCBid, TESCBactiva,TESCBreintegrable, mp.Miso4217, bp.Bdescripcion  #_Cat# ' - ' #_Cat# cp.CBcodigo as CBdescripcion
		 from Tesoreria t
			inner join CuentasBancos cp
				left join TEScuentasBancos tcb
					 on tcb.TESid = #session.Tesoreria.TESid#
					and tcb.CBid  = cp.CBid
				inner join Empresas ep
					 on ep.Ecodigo = cp.Ecodigo
				inner join Bancos bp
					 on bp.Bid = cp.Bid
				inner join Monedas mp
					 on mp.Ecodigo = cp.Ecodigo
					and mp.Mcodigo = cp.Mcodigo
				on cp.Ecodigo = t.EcodigoAdm
		where t.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
		  and t.EcodigoAdm = #session.Ecodigo#
          and cp.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="lista2">
		select ep.Ecodigo as Orden, ep.Ecodigo, ep.Edescripcion, cp.CBid, tcb.CBid as TESCBid, TESCBactiva, TESCBreintegrable,mp.Miso4217, bp.Bdescripcion  #_Cat# ' - ' #_Cat# cp.CBcodigo as CBdescripcion
		 from TESempresas t
			inner join TESempresas te
				 on te.Ecodigo = t.Ecodigo
				and te.TESid	= #session.Tesoreria.TESid#
			inner join CuentasBancos cp
				left join TEScuentasBancos tcb
					 on tcb.TESid = #session.Tesoreria.TESid#
					and tcb.CBid  = cp.CBid
				inner join Empresas ep
					 on ep.Ecodigo = cp.Ecodigo
				inner join Bancos bp
					 on bp.Bid = cp.Bid
				inner join Monedas mp
					 on mp.Ecodigo = cp.Ecodigo
					and mp.Mcodigo = cp.Mcodigo
				on cp.Ecodigo = t.Ecodigo
		where t.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		  and t.Ecodigo <> #session.Ecodigo#
          and cp.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfquery dbtype="query" name="lista">
		select * from lista1
		UNION
		select * from lista2
		order by Orden, Miso4217
	</cfquery>
	
	<table cellpadding="0" cellspacing="0" background="0" width="80%" align="center">
		<tr class="tituloListas" >
			<td width="10" align="center">&nbsp;<strong>Activar</strong></td>
			<td>&nbsp;&nbsp;<strong>Empresa de Pago</strong></td>
			<td ><strong>Cuenta Bancaria de Pago</strong></td>
			<td width="10" align="center">&nbsp;<strong>Reintegrable</strong></td>
		</tr>
		<cfset LvarEcodigoAnterior = "">
		<cfoutput query="Lista">
			<cfif Lista.currentRow mod 2 EQ 0>
				<cfset LvarClass = "listaPar">
			<cfelse>
				<cfset LvarClass = "listaNon">
			</cfif>
			<cfif LvarEcodigoAnterior NEQ Ecodigo>
				<tr class="TituloCorte">
					<td>&nbsp;</td>
					<td colspan="3">
						<cfset LvarEcodigoAnterior = Ecodigo>
						<strong>&nbsp;&nbsp;#Edescripcion#</strong>
					</td>
				</tr>
			</cfif>

			<tr class="#LvarClass#">
				<td align="center">
					<input type="checkbox" name="CBid" value="#CBid#" <cfif TESCBid neq "" and TESCBactiva EQ "1">checked</cfif> tabindex="1">
					<cfif TESCBid neq "">
					<input type="hidden" name="TESCBid" value="#TESCBid#">
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td>
					#Miso4217#&nbsp;&nbsp;
					#CBdescripcion#
				</td>
				<td align="center">
					<input type="checkbox" name="CBidReintegrable" value="#CBid#" <cfif TESCBid neq "" and TESCBreintegrable EQ "1">checked</cfif> tabindex="1">
				</td>
			</tr>
		</cfoutput>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="4">
				<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="btnCambiar"  includevalues="Cambiar" tabindex="1" >
			</td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>
</form>
<script language="javascript" type="text/javascript">
	document.frmTES.TESid.focus();
</script>