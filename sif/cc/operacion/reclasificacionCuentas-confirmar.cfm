<cfset params = '?SNcodigo=#url.SNcodigo#&Ccuenta=#url.Ccuenta#' >
<cfif isdefined("url.Ccuenta2") and len(trim(url.Ccuenta2))>
	<cfset params = params & '&Ccuenta2=#url.ccuenta2#'>
</cfif>

<cfif isdefined("url.filtrar_por") and url.filtrar_por eq "D" and isdefined("url.Ddocumento") and len(trim(url.Ddocumento))>
	<cfset params = params & '&filtrar_por=D&Ddocumento=#url.Ddocumento#'>
<cfelse>
	<cfset params = params & '&filtrar_por=T'>
	<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
		<cfset params = params & '&id_direccion=#url.id_direccion#'>
	</cfif>
	
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfset params = params & '&Ocodigo=#url.Ocodigo#'>
	</cfif>
	
	<cfif isdefined("url.antiguedad") and len(trim(url.antiguedad))>
		<cfset params = params & '&antiguedad=#url.antiguedad#'>
	</cfif>
	
	<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
		<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
	</cfif>	
</cfif>

<cf_templateheader template="#session.sitio.template#" title="Reclasificaci&oacute;n de Cuentas">

<cfquery name="socio" datasource="#session.DSN#">
	select SNnumero, SNnombre
	from SNegocios
	where Ecodigo = #session.Ecodigo#
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 then <cf_dbfunction name="sPart"	args="a.CCTdescripcion,1,10"> #_Cat# ' (contado)' else <cf_dbfunction name="sPart"	args="a.CCTdescripcion,1,20"> end as CCTdescripcion,
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
	 from CCTransacciones a
	 where a.Ecodigo = #session.Ecodigo#
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1
	   and NOT upper(a.CCTdescripcion) like '%TESORER_A%'
	   and CCTtranneteo = 0
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, CCTcodigo
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select a.Ecodigo, 
		  a.SNcodigo, 
		  a.Cuenta_Anterior, 
		   ( select min(cc1.Cformato)
			 from CContables cc1
			 where cc1.Ecodigo=a.Ecodigo
				 and cc1.Ccuenta=a.Cuenta_Anterior ) as cuentaantformato,
		   ( select min(cc2.Cformato)
			 from CContables cc2
			 where cc2.Ecodigo=a.Ecodigo
				 and cc2.Ccuenta=a.Cuenta_Nueva ) as cuentanuevaformato,
		  a.Cuenta_Nueva, count(1) as total
	from RCBitacora a
	where a.Ecodigo=#session.Ecodigo#
	and a.RCBestado=0
	and a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	group by a.Ecodigo,a.SNcodigo, a.Cuenta_Anterior, a.Cuenta_Nueva
</cfquery>

<table width="100%" align="center" cellpadding="3" cellspacing="0" >
	<cfoutput>
	<tr><td align="center" class="menutitulo"><strong>Proceso de Reclasificaci&oacute;n de Cuentas</strong></td></tr>
	<tr><td align="center" class="menutitulo"><strong>Socio de Negocios:&nbsp;</strong>#socio.SNnumero#-#socio.SNnombre#</td></tr>
	<tr><td align="center" class="menutitulo"><strong>Consultar todos los documentos&nbsp;</strong><img title="Consultar documentos" src="../../imagenes/find.small.png" border="0" onclick="javascript: consultar('#url.SNcodigo#','0', '0');" /></td></tr>	
	</cfoutput>
</table>

<br>
<table width="100%" align="center" cellpadding="2" cellspacing="0" >
<form name="form1" method="get" action="" style="margin:0;">

	<cfif data.recordcount gt 25>
		<tr>
			<td colspan="5" align="center">
				<input type="button" class="btnAnterior" name="btnAnterior" value="Anterior" onclick="javascript:funcAnterior();" />
				<cfif data.recordcount gt 0>
					<input type="submit" class="btnAplicar" name="btnAplicar" value="Aplicar" onclick="javascript: return funcAplicar();" />
				</cfif>
			</td>
		</tr>
	</cfif>

	<tr>
		<td class="tituloListas"><strong>Cuenta Anterior</strong></td>
		<td class="tituloListas"><strong>Cuenta Nueva</strong></td>
		<td class="tituloListas" align="center"><strong>Cantidad de Documentos</strong></td>
		<td class="tituloListas">&nbsp;</td>
	</tr>

	<cfif data.recordcount gt 0>
		<cfoutput query="data">
			<cfquery name="rsCuentaAnt" datasource="#session.DSN#">
				select Cdescripcion
				from CContables
				where Ecodigo = #session.Ecodigo#
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Cuenta_Anterior#">
			</cfquery>
			<cfquery name="rsCuentaNueva" datasource="#session.DSN#">
				select Cdescripcion
				from CContables
				where Ecodigo = #session.Ecodigo#
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Cuenta_Nueva#">
			</cfquery>
			<tr <cfif data.currentrow mod 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
				<td>#trim(data.CuentaAntFormato)#, #rsCuentaAnt.Cdescripcion#</td>
				<td>#trim(data.CuentaNuevaFormato)#, #rsCuentaNueva.Cdescripcion#</td>
				<td align="center">#data.total#</td>
				<td align="center" width="20%"><img title="Consultar documentos" src="../../imagenes/find.small.png" border="0" onclick="javascript: consultar('#url.SNcodigo#','#data.Cuenta_Nueva#', '#data.Cuenta_Anterior#');" /></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr >
			<td colspan="4" align="center">No hay registros para reclasificar</td>
		</tr>
		<tr >
			<td colspan="4" align="center">&nbsp;</td>
		</tr>
	</cfif>

	<tr>
		<td colspan="5" align="center">
			<input type="button" class="btnAnterior" name="btnAnterior" value="Anterior" onclick="javascript:funcAnterior();" />
			<cfif data.recordcount gt 0>
					<input type="submit" class="btnAplicar" name="btnAplicar" value="Aplicar" onclick="javascript:return funcAplicar();" />
			</cfif>	
		</td>
	</tr>

	<cfoutput>
	<input type="hidden" name="SNcodigo" value="#url.SNcodigo#" />
	<input type="hidden" name="Ccuenta" value="#url.Ccuenta#" />

	<cfif isdefined("url.Ccuenta2") and len(trim(url.Ccuenta2))>
		<input type="hidden" name="Ccuenta2" value="#url.Ccuenta2#" />
	</cfif>	

	<cfif isdefined("url.Ddocumento") and len(trim(url.Ddocumento))>
		<input type="hidden" name="Ddocumento" value="#url.Ddocumento#" />
	</cfif>

	<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
		<input type="hidden" name="id_direccion" value="#url.id_direccion#" />		
	</cfif>
	
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<input type="hidden" name="Ocodigo" value="#url.Ocodigo#" />
	</cfif>
	
	<cfif isdefined("url.antiguedad") and len(trim(url.antiguedad))>
		<input type="hidden" name="antiguedad" value="#url.antiguedad#" />
	</cfif>
	
	<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
		<input type="hidden" name="CCTcodigo" value="#url.CCTcodigo#" />
	</cfif>
	<cfif isdefined("url.filtrar_por") and len(trim(url.filtrar_por))>
		<input type="hidden" name="filtrar_por" value="#url.filtrar_por#" />
	</cfif>
	</cfoutput>
</form>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcSiguiente(){
		document.form1.action = 'reclasificacionCuentas-confirmar.cfm';
		return true;
	}
	
	function funcAnterior(){
		location.href = 'reclasificacionCuentas-documentos.cfm<cfoutput>#params#</cfoutput>';
		return true;
	}
	
	function funcAplicar(){
		if (confirm('Desea ejecutar el proceso de Reclasificación de Cuentas?')){
			document.form1.action = 'reclasificacionCuentas-aplicar-sql.cfm';
			return true
		}
		return false;
	}

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function consultar(socio, cuentaNueva, cuentaAnt){
		popUpWindow("/cfmx/sif/cc/operacion/reclasificacionCuentas-consulta.cfm?SNcodigo="+socio+"&CcuentaNueva="+cuentaNueva+"&CcuentaAnt="+cuentaAnt,100,50,1100,750);
		return false;
	}
</script>

<cf_templatefooter template="#session.sitio.template#">