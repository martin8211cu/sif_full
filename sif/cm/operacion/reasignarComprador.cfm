<cf_templatecss>

<script language="javascript" type="text/javascript">
	window.parent.document.form1.CMCid.value = '';
</script>

<cfif isdefined("url.ESidsolicitud")>
	<script language="javascript" type="text/javascript">
		function asignar(value){
			window.parent.document.form1.CMCid.value = value;
		}
	</script>
	
	<cfquery name="dataTipo" datasource="#session.DSN#">
		select CMTScodigo
		from ESolicitudCompraCM
		where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
	</cfquery>

	<cfquery name="dataCompradores" datasource="#session.DSN#">
		select a.CMCid, b.CMCnombre, (  select count(1) 
										from ESolicitudCompraCM c 
										where a.CMCid=c.CMCid 
										and a.Ecodigo=b.Ecodigo
										and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as carga
		from CMEspecializacionComprador a
		inner join CMCompradores b
		on a.Ecodigo=b.Ecodigo
		   and a.CMCid=b.CMCid
		   and b.CMCestado=1
  		   and b.CMCdefault!=1
		   and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		where CMTScodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataTipo.CMTScodigo#">
		and a.CMCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.comprador#">
		
		union

		select a.CMCid, a.CMCnombre, (  select count(1) 
										from ESolicitudCompraCM c 
										where a.CMCid=c.CMCid 
										and a.Ecodigo=c.Ecodigo
										and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as carga
		from CMCompradores a
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.CMCestado=1
			and a.CMCdefault!=1
			and a.CMCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Comprador#">
			and a.CMCid not in ( select CMCid from CMEspecializacionComprador where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		
		union

		select a.CMCid, a.CMCnombre, (  select count(1) 
										from ESolicitudCompraCM c 
										where a.CMCid=c.CMCid 
										and a.Ecodigo=c.Ecodigo
										and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) as carga
		from CMCompradores a
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.CMCestado=1
			and a.CMCdefault=1
			and a.CMCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Comprador#">
		
	</cfquery>
	
	<cfoutput>
	<cfif dataCompradores.recordCount gt 0>
		<form name="form2" method="post" style="margin:0; ">
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr class="tituloListas">
					<td width="1%">&nbsp;</td>
					<td nowrap><strong>Comprador</strong></td>
					<td nowrap align="right"><strong>Carga de Trabajo actual</strong></td>
				</tr>
				<cfloop query="dataCompradores">
					<tr class="<cfif dataCompradores.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td width="1%"><input type="radio" name="rb" value="#dataCompradores.CMCid#"  onClick="javascript:asignar(this.value);"></td>
						<td nowrap>#dataCompradores.CMCnombre#</td>
						<td nowrap align="right">#dataCompradores.carga#</td>
					</tr>
				</cfloop>
			</table> 
		</form>
	<cfelse>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td align="center">No existen Compradores para atender la solicitud</td></tr>
		</table>
	</cfif>	
	</cfoutput>

<cfelse>	
	<table width="98%" align="center">
		<tr><td align="center">Para desplegar el listado de Compradores, debe seleccionar una Solicitud de Compra</td></tr>
	</table>
</cfif>
