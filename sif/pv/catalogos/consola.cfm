<cfif isdefined("url.FAM09MAQ") and len(trim(url.FAM09MAQ)) and not isdefined("form.FAM09MAQ")>
	<cfset form.FAM09MAQ = url.FAM09MAQ>
</cfif>

<!--- Consulta todas las máquinas --->
<cfparam name="filtromaq" default="">
<cfquery name="rsMaquinas" datasource="#session.DSN#">
	select a.FAM09MAQ, a.FAM09DES
	from FAM009 a
	<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
		inner join FAM001 b
		on a.FAM09MAQ = b.FAM09MAQ
		and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
	</cfif>
	where a.Ecodigo = #session.Ecodigo#
	group by a.FAM09MAQ, a.FAM09DES
	order by a.FAM09MAQ, a.FAM09DES
</cfquery>

<!--- Consulta todas las impresoras --->
<cfparam name="filtroimp" default="">
<cfquery name="rsImpresoras" datasource="#session.DSN#"> 
	select a.FAM12COD, b.FAX01ORIGEN , a.FAM12CODD, a.FAM12DES, b.CCTcodigo, b.FAM09MAQ
	from FAM012 a
		inner join FAM014 b
		on a.FAM12COD = b.FAM12COD
		and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
	order by a.FAM12COD, a.FAM12CODD, a.FAM12DES
</cfquery>

<!--- Consulta todas las cajas --->
<cfparam name="filtrocaj" default="">
<cfquery name="rsCajas" datasource="#session.DSN#"> 
	select FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAX01ORIGEN
	from FAM001
	where Ecodigo = #session.Ecodigo#
	<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
		and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
	</cfif>
	order by FAM01COD, FAM01CODD, FAM01DES
</cfquery>

<cfoutput>
<form name="consola" action="cajasProceso.cfm" method="post">
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<input type="hidden" name="FAM09MAQ" value="<cfif isdefined("form.FAM09MAQ") and len(trim(form.FAM09MAQ))>#form.FAM09MAQ#</cfif>">
	<input type="hidden" name="PASO" value="">
	<input type="hidden" name="FAM12COD" value="">
	<input type="hidden" name="CCTcodigo" value="">
    <input type="hidden" name="FAM01COD" value="">
	 <input type="hidden" name="FAX01ORIGEN" value="">
	
	<!---PINTA LA LISTA de Máquinas--->
	<cfloop query="rsMaquinas">
		<cfset LvarListaNon = (CurrentRow MOD 2)>
		<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> style="cursor:pointer;" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			<td colspan="2" style="background-color:##E4E7ED; font-size:14px" class="tituloListas" align="left" nowrap onclick="javascript: ProcesarMaquina('#rsMaquinas.FAM09MAQ#');">#rsMaquinas.FAM09MAQ# - #rsMaquinas.FAM09DES#</td>
			
		</tr>
		<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> style="cursor:default" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			<td class="tituloListas" align="center" nowrap><font size="2">Impresoras</font></td>
			<td class="tituloListas" align="left" nowrap><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cajas</font></td>
		</tr>
		<tr>
			<td width="50%" valign="top">
				<!--- *************************************** IMPRESORAS *************************************** --->
				<!--- Consulta las impresoras de la máquina Actual (CurrentRow) --->
				<cfquery name="rsImpresorasMaquina" dbtype="query">
					select FAM12COD, FAM12CODD,FAX01ORIGEN , FAM12DES, CCTcodigo, FAM09MAQ
					from rsImpresoras
					where FAM09MAQ = #rsMaquinas.FAM09MAQ#
				</cfquery>
				<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="tituloListas">C&oacute;digo</td>
						<td class="tituloListas">Descripci&oacute;n</td>
						<td class="tituloListas">Transacci&oacute;n</td>
						<td class="tituloListas">Origen</td>
					</tr>
					<!---PINTA LA LISTA DE IMPRESORAS--->
					<cfloop query="rsImpresorasMaquina">
						<cfset LvarListaNonImpr = (CurrentRow MOD 2)>
						<tr class=<cfif LvarListaNonImpr>"listaNon"<cfelse>"listaPar"</cfif> style="cursor:pointer;" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNonImpr>listaNon<cfelse>listaPar</cfif>';">
							<td align="left" nowrap onclick="javascript: ProcesarImpresora('#rsImpresorasMaquina.FAM09MAQ#','#rsImpresorasMaquina.FAM12COD#','#rsImpresorasMaquina.CCTcodigo#','#rsImpresorasMaquina.FAX01ORIGEN #');">#rsImpresorasMaquina.FAM12CODD#</td>
							<td align="left" nowrap onclick="javascript: ProcesarImpresora('#rsImpresorasMaquina.FAM09MAQ#','#rsImpresorasMaquina.FAM12COD#','#rsImpresorasMaquina.CCTcodigo#','#rsImpresorasMaquina.FAX01ORIGEN #');">#rsImpresorasMaquina.FAM12DES#</td>
							<td align="left" nowrap onclick="javascript: ProcesarImpresora('#rsImpresorasMaquina.FAM09MAQ#','#rsImpresorasMaquina.FAM12COD#','#rsImpresorasMaquina.CCTcodigo#','#rsImpresorasMaquina.FAX01ORIGEN #');">#rsImpresorasMaquina.CCTcodigo#</td>
							<td align="left" nowrap onclick="javascript: ProcesarImpresora('#rsImpresorasMaquina.FAM09MAQ#','#rsImpresorasMaquina.FAM12COD#','#rsImpresorasMaquina.CCTcodigo#','#rsImpresorasMaquina.FAX01ORIGEN #');">#rsImpresorasMaquina.FAX01ORIGEN#</td>
						</tr>
					</cfloop>
				</table>
				<br>
				<!--- <cf_botones values="Nueva Impresora" names="NuevaImpresora" functions="NuevaImpresora" params="#rsImpresorasMaquina.FAM09MAQ#">  --->
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center"><input type="submit" value="Nueva Impresora" name="NuevaImpresora" class="btnnuevo"
										onClick="JavaScript: document.consola.FAM09MAQ.value='#rsMaquinas.FAM09MAQ#';
															document.consola.PASO.value=2;NuevaImpresora(#rsMaquinas.FAM09MAQ#);
										"></td>
				  </tr>
				</table>
				
				<br>
				<!--- *************************************** IMPRESORAS *************************************** --->
			</td>
			<td width="50%" valign="top">
				<!--- *************************************** CAJAS *************************************** --->
				<!--- Consulta las cajas de la máquina Actual (CurrentRow) --->
				<cfquery name="rsCajasMaquina" dbtype="query">
					select FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAX01ORIGEN
					from rsCajas
					where FAM09MAQ = #rsMaquinas.FAM09MAQ#
				</cfquery>
				<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="tituloListas">C&oacute;digo</td>
						<td class="tituloListas">Descripci&oacute;n</td>
						<td class="tituloListas">Origen</td>
					</tr>
					<!---PINTA LA LISTA de CAJAS--->
					<cfloop query="rsCajasMaquina">
						<cfset LvarListaNonImpr = (CurrentRow MOD 2)>
						<tr class=<cfif LvarListaNonImpr>"listaNon"<cfelse>"listaPar"</cfif> style="cursor:pointer;" onmouseover="this.className='listaParSel';"  onmouseout="this.className='<cfif LvarListaNonImpr>listaNon<cfelse>listaPar</cfif>';">
							<td align="left" nowrap onclick="javascript: ProcesarCaja('#rsCajasMaquina.FAM01COD#','#rsCajasMaquina.FAM09MAQ#');">#rsCajasMaquina.FAM01CODD#</td>
							<td align="left" nowrap onclick="javascript: ProcesarCaja('#rsCajasMaquina.FAM01COD#','#rsCajasMaquina.FAM09MAQ#');">#rsCajasMaquina.FAM01DES#</td>
							<td align="left" nowrap onclick="javascript: ProcesarCaja('#rsCajasMaquina.FAM01COD#','#rsCajasMaquina.FAM09MAQ#');">#rsCajasMaquina.FAX01ORIGEN#</td>
						</tr>
					</cfloop>
				</table>
				<br>
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center">
						<input type="submit" value="Nueva Caja" name="NuevaCaja" class="btnnuevo"
											onclick="javascript: document.consola.FAM09MAQ.value='#rsMaquinas.FAM09MAQ#';
																document.consola.PASO.value=3;">
					</td>
				  </tr>
				</table>
				<br>
				<!--- *************************************** CAJAS ****************************************** --->
			</td>
		</tr>
		<tr></tr>
		
	</cfloop>
</table>
<br>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td align="center">
		<input type="submit" value="Nueva Máquina" name="NuevaMaquina" class="btnnuevo" onclick="javascript: document.consola.PASO.value=1;">
	</td>
  </tr>
</table>
<br>
</form>
<script language="javascript" type="text/javascript">
<!--//
	function ProcesarMaquina(FAM09MAQ){
		document.consola.FAM09MAQ.value=FAM09MAQ;
		document.consola.PASO.value=1;
		document.consola.submit();
	}
	function NuevaMaquina(){
		document.consola.PASO.value=1;
	}
	function ProcesarImpresora(FAM09MAQ,FAM12COD,CCTcodigo,FAX01ORIGEN){
		document.consola.FAM09MAQ.value=FAM09MAQ;
		document.consola.FAM12COD.value=FAM12COD;
		document.consola.CCTcodigo.value=CCTcodigo;
		document.consola.FAX01ORIGEN.value=FAX01ORIGEN;
		document.consola.PASO.value=2;
		document.consola.submit();
	}
	function NuevaImpresora(FAM09MAQ){
		document.consola.FAM09MAQ.value=FAM09MAQ;
		document.consola.PASO.value=2;
	}
	function ProcesarCaja(FAM01COD,FAM09MAQ){
		document.consola.FAM01COD.value=FAM01COD;
		document.consola.FAM09MAQ.value=FAM09MAQ;
		document.consola.PASO.value=3;
		document.consola.submit();
	}
	function NuevaCaja(FAM09MAQ){
		document.consola.FAM09MAQ.value=FAM09MAQ;
		document.consola.PASO.value=3;
	}
	//-->
</script>
</cfoutput>