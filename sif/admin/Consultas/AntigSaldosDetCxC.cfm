
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Detalle de Antiguedad de Antiguedad de Saldos CxC','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>
<cf_templateheader title="#LB_Titulo#">
<cfinclude template="Funciones.cfm">
<cfset venc1 = #Trim(get_val(310).Pvalor)#>
<cfset venc2 = #Trim(get_val(320).Pvalor)#>
<cfset venc3 = #Trim(get_val(330).Pvalor)#>
<cfset venc4 = #Trim(get_val(340).Pvalor)#>

<cfif not isdefined("url.SNcodigo")>
	<!--- Revisa la variable Session para ver si trae el SNcodigo como parámetro y valida quien le hace referencia --->
	<!--- De esta forma se evita que cambien el SNcodigo por el url. --->
	<cfif isdefined("cgi.QUERY_STRING") and isdefined("session.referencia") and  len(trim(session.referencia)) and find("analisisSocio.cfm",session.referencia,1)
	or find("MenuCC-iframe.cfm",session.referencia,1)>
		<cfloop list="#cgi.QUERY_STRING#" delimiters="&" index="Lvar">
			<cfif left(Lvar,8) eq "SNcodigo">
				<cfset LvarSNcodigo = mid(Lvar,10,Len(Lvar) -9)>
			</cfif>
		</cfloop>
		<cfparam name="url.SNcodigo" default="-1"> 
		<!--- <cfparam name="url.SNcodigo" default="#LvarSNcodigo#"> --->
	<cfelse>
		<cfif find("AntigSaldosCxC.cfm",session.referencia,1) or find("AntigSaldosDetCxC.cfm",session.referencia,1) or find("MenuCC.cfm",session.referencia,1)>
			<cfparam name="url.SNcodigo" default="-1">
		<cfelse>
			<cflocation url="../../../home/menu/empresa.cfm" addtoken="no">
		</cfif>
	</cfif>
</cfif>

<cfset session.referencia = ''>

<cfif not isdefined("url.Ocodigo")>
	<cfif isdefined("Url.Ocodigo")>
		<cfparam name="url.Ocodigo" default="#Url.Ocodigo#">
	<cfelse>
		<cfparam name="url.Ocodigo" default="-1">
	</cfif>
</cfif>
<cfif isdefined("Url.venc")>
	<cfif FindNoCase("Sin Vencer", Url.venc) GT 0>
		<cfset LvarVencCodigo = "1">
	<cfelseif FindNoCase("- " & venc1, Url.venc) GT 0>
		<cfset LvarVencCodigo = "2">
	<cfelseif FindNoCase("- " & venc2, Url.venc) GT 0>
		<cfset LvarVencCodigo = "3">
	<cfelseif FindNoCase("- " & venc3, Url.venc) GT 0>
		<cfset LvarVencCodigo = "4">
	<cfelseif FindNoCase("- " & venc4, Url.venc) GT 0>
		<cfset LvarVencCodigo = "5">
	<cfelseif FindNoCase(venc4, Url.venc)>
		<cfset LvarVencCodigo = "6">
	<cfelse>
		<cfset LvarVencCodigo = Url.venc>
	</cfif>
<cfelse>
	<cfset LvarVencCodigo = "-1">
</cfif>

<cfset LB_Titulo_I = t.Translate('LB_Titulo_I','An&aacute;lisis de Antig&uuml;edad de Saldos de Cuentas por Cobrar','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo_I#'>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 5px;
		padding-bottom: 5px;
		padding-left: 5px;
		padding-right: 5px;
	}
	.tbline {
		border-width: 1px;
		border-style: solid;
		border-color: #CCCCCC;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
</style>
			<!--- <cfquery name="rsSocios" datasource="#Session.DSN#">
				select * from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and SNtiposocio in ('A', 'C')
				order by SNnombre
			</cfquery> --->

<cfset LB_Fisica = t.Translate('LB_Fisica','Física','AntigSaldosCxC.xml')>
<cfset LB_Juridica = t.Translate('LB_Juridica','Jurídica','AntigSaldosCxC.xml')>
<cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero','AntigSaldosCxC.xml')>
<cfset LB_NoTiene = t.Translate('LB_NoTiene','No Tiene','AntigSaldosCxC.xml')>


			<cfif isdefined("url.SNcodigo") and url.SNcodigo NEQ -1>
				<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
					select coalesce(SNnombre,'') as SNnombre,
					       coalesce(SNidentificacion, '') as SNidentificacion,
						   coalesce(SNdireccion, '#LB_NoTiene#') as SNdireccion,
						   coalesce(SNtelefono, '#LB_NoTiene#') as SNtelefono,
						   coalesce(SNFax, '#LB_NoTiene#') as SNFax,
						   coalesce(SNemail, '#LB_NoTiene#') as SNemail,
                           (case SNtipo when 'F' then '#LB_Fisica#' when 'J' then '#LB_Juridica#' when 'E' then '#LB_Extranjero#' else '???' end) as SNtipo
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and SNtiposocio in ('A', 'C')
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
					order by SNnombre
				</cfquery>
			</cfif>

			<cfinclude template="AD_AntigSaldosDetCxC.cfm">
			<cfquery name="rsSociosConsulta" dbtype="query">
				select distinct socio from rsConsulta
			</cfquery>

			<cfset regresar = "/cfmx/sif/admin/Consultas/AntigSaldosCxC.cfm">
			<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CC">
				<cfinclude template="../../portlets/pNavegacionCC.cfm">
			</cfif>
			<form action="AntigSaldosDetCxC.cfm" method="get" name="form1">
			<!--- <input name="Valida" type="hidden" value="AntigSaldosDetCxC.cfm"> --->
			<input name="SNcodigo" type="hidden" value="<cfoutput>#url.SNcodigo#</cfoutput>">
			<cfset BTN_Regresar = t.Translate('BTN_Regresar','Buscar','/sif/generales.xml')>
			<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
            <cfset LB_Persona = t.Translate('LB_Persona','Persona','AntigSaldosCxC.xml')>
			<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
            <cfset LB_Telefono = t.Translate('LB_Telefono','Tel&eacute;fono','/sif/generales.xml')>

              <table width="100%" border="0">
                <tr>
                  <td colspan="5">&nbsp;</td>
                </tr>
                <cfif isdefined("url.SNcodigo") and url.SNcodigo NEQ -1>
                  <tr>
                    <td colspan="5">
                      <cfoutput query="rsSocioDatos">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr align="center">
						  	<td class="tituloAlterno"  align="right" nowrap="nowrap" colspan="4">&nbsp;</td>
                            <td class="tituloAlterno"  nowrap="nowrap"colspan="8">
							   <cfset LvarRegresar="../../cc/consultas/analisisSocio.cfm">
								<input type="button" name="lista" 	    value="#BTN_Regresar#" onClick="javascript: location.href = '#LvarRegresar#';">					
							</td>

                          </tr>
						  <tr align="center">
                            <td class="tituloAlterno" colspan="6">#SNnombre#</td>
                          </tr>
                          <tr>
                            <td style="padding-left: 5px; font-weight: bold;">#LB_Identificacion#:</td>
                            <td style="padding-left: 5px;">#SNidentificacion#</td>
                            <td style="padding-left: 5px; font-weight: bold;">#LB_Persona#:</td>
                            <td style="padding-left: 5px;">#SNtipo#</td>
                            <td style="padding-left: 5px; font-weight: bold;">Email:</td>
                            <td style="padding-left: 5px;">#SNemail#</td>
                          </tr>
                          <tr>
                            <td style="padding-left: 5px; font-weight: bold;">#LB_Direccion#:</td>
                            <td style="padding-left: 5px;">#SNdireccion#</td>
                            <td style="padding-left: 5px; font-weight: bold;">#LB_Telefono#:</td>
                            <td style="padding-left: 5px;">#SNtelefono#</td>
                            <td style="padding-left: 5px; font-weight: bold;">Fax:</td>
                            <td style="padding-left: 5px;">#SNfax#</td>
                          </tr>
                        </table>
                      </cfoutput> </td>
                  </tr>
                  <tr>
                    <td colspan="5">&nbsp;</td>
                  </tr>
                </cfif>
				  <tr>
				  	<td colspan="5" style="padding-left: 10px">
                    <cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento en d&iacute;as'
                    ,'/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
        			<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
                    <cfset LB_Corriente = t.Translate('LB_Corriente','Corriente','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
                    <cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
					<cfset LB_Masde = t.Translate('LB_Masde','M&aacute;s de','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>

						<cfoutput>#LB_Vencimiento#</cfoutput>
						<select name="venc" onChange="javascript: this.form.submit();">
							<option value="-1" <cfif LvarVencCodigo EQ -1>selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
							<option value="Corriente" <cfif LvarVencCodigo EQ 'Corriente'>selected</cfif>><cfoutput>#LB_Corriente#</cfoutput></option>
							<option value="1" <cfif LvarVencCodigo EQ 1>selected</cfif>><cfoutput>#LB_SinVencer#</cfoutput></option>
							<option value="2" <cfif LvarVencCodigo EQ 2>selected</cfif>>1 - <cfoutput>#venc1#</cfoutput></option>
							<option value="3" <cfif LvarVencCodigo EQ 3>selected</cfif>><cfoutput>#venc1 + 1# - #venc2#</cfoutput></option>
							<option value="4" <cfif LvarVencCodigo EQ 4>selected</cfif>><cfoutput>#venc2 + 1# - #venc3#</cfoutput></option>
							<option value="5" <cfif LvarVencCodigo EQ 5>selected</cfif>><cfoutput>#venc3 + 1# - #venc4#</cfoutput></option>
							<option value="6" <cfif LvarVencCodigo EQ 6>selected</cfif>><cfoutput>#LB_Masde# #venc4#</cfoutput></option>
						</select>
					</td>
				  </tr>
                  <tr>
                    <td colspan="5">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
                        <cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
                        <cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
                        <cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
                        <cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
						<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','AntigSaldosCxC.xml')>
                        <cfset LB_Vencidoshace = t.Translate('LB_Vencidoshace','Vencidos hace','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
                        <cfset LB_SaldoMonedaLocal = t.Translate('LB_SaldoMonedaLocal','Saldo Moneda Local','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
						<cfset LB_SaldoTotalMonedaLocal = t.Translate('LB_SaldoTotalMonedaLocal','Saldo Total en Moneda Local','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>
                        <cfset LB_SinDocumentos = t.Translate('LB_SinDocumentos','No se encontraron documentos que cumplan con el criterio de la consulta','/sif/admin/Consultas/AntigSaldosDetCxC.xml')>

						<cfflush interval="128">
						<cfoutput>
							<cfloop query="rsSociosConsulta">
								<cfset socioL = rsSociosConsulta.socio>
								<cfif url.SNcodigo EQ -1>
								<tr>
									<td class="tituloAlterno" colspan="8">#socioL#</td>
								</tr>
								</cfif>
								<tr>
									<td class="encabReporte" align="center">#LB_Transaccion#</td>
									<td class="encabReporte">#LB_Documento#</td>
									<td class="encabReporte" align="center">#LB_Fecha#</td>
									<td class="encabReporte" align="center">#LB_FechaVencimiento#</td>
									<td class="encabReporte" align="right">#LB_Monto#</td>
									<td class="encabReporte" align="right">#LB_Saldo#</td>
									<td class="encabReporte" align="center">#LB_Vencidoshace#</td>
									<td class="encabReporte" align="right">#LB_SaldoMonedaLocal#</td>
								</tr>
								<cfquery name="rsMonedasConsulta" dbtype="query">
									select distinct moneda
									from rsConsulta
									where socio = <cfqueryparam cfsqltype="cf_sql_char" value="#socioL#">
								</cfquery>
								<cfloop query="rsMonedasConsulta">
									<cfset monedaL = rsMonedasConsulta.moneda>
									<tr>
										<td colspan="8" class="tbline" style="background-color: ##F5F5F5; font-weight: bold">#rsMonedasConsulta.moneda#</td>
									</tr>
									<cfquery name="rsFechasVencConsulta" dbtype="query">
										select documento, fecha, fechavenc, monto, saldo, saldolocal, HDid, transaccion
										from rsConsulta
										where socio = <cfqueryparam cfsqltype="cf_sql_char" value="#socioL#">
										and moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#monedaL#">
										order by fecha
									</cfquery>
									<cfquery name="rsMonedasTotales" dbtype="query">
										select sum(monto) as totalmonto, sum(saldo) as totalsaldo, sum(saldolocal) as totalsaldolocal
										from rsFechasVencConsulta
									</cfquery>
									<cfset fechavencL = "">
									<cfloop query="rsFechasVencConsulta">
										<tr onclick="javascript:verdocumentos(#rsFechasVencConsulta.HDid#);" style="cursor:pointer">
											<td align="center" <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsFechasVencConsulta.transaccion#</td>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsFechasVencConsulta.documento#</td>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">#Dateformat(rsFechasVencConsulta.fecha, "DD/MM/YYYY")#</td>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">#DateFormat(rsFechasVencConsulta.fechavenc, "DD/MM/YYYY")#</td>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="right">#LSCurrencyFormat(rsFechasVencConsulta.monto, 'none')#</td>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="right">#LSCurrencyFormat(rsFechasVencConsulta.saldo, 'none')#</td>
											<cfif rsFechasVencConsulta.fechavenc GT now()>
												<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">Sin Vencer</td>
											<cfelse>
												<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">#datediff('d', rsFechasVencConsulta.fechavenc, now())#</td>
											</cfif>
											<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="right">#LSCurrencyFormat(rsFechasVencConsulta.saldolocal, 'none')#</td>
										</tr>
									</cfloop>
									<tr>
										<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="4">Total #monedaL#</td>
									    <td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#LSCurrencyFormat(rsMonedasTotales.totalmonto, 'none')#</td>
									    <td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#LSCurrencyFormat(rsMonedasTotales.totalsaldo, 'none')#</td>
									    <td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="center">&nbsp;</td>
									    <td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#LSCurrencyFormat(rsMonedasTotales.totalsaldolocal, 'none')#</td>
									</tr>
									<tr>
										<td colspan="8">&nbsp;</td>
									</tr>
								</cfloop>
							</cfloop>
							<cfquery name="rsSuma" dbtype="query">
								select sum(saldolocal) as SaldoFinalLocal
								from rsConsulta
							</cfquery>
							<cfif rsConsulta.recordCount GT 0>

								<tr>
									<td class="tituloAlterno" colspan="4" nowrap>#LB_SaldoTotalMonedaLocal#</td>
									<td colspan="4" align="right" class="tituloAlterno" nowrap>#LSCurrencyFormat(rsSuma.SaldoFinalLocal,'none')#</td>
								</tr>
							</cfif>
						<cfif rsSociosConsulta.recordCount EQ 0>
							<tr>
								<td align="center" style="background-color: ##F5F5F5; font-weight: bold">#LB_SinDocumentos#</td>
							</tr>
						</cfif>
                        </cfoutput>
						</table>
					</td>
                  </tr>
              </table>
             </form>

		<cf_web_portlet_end>
		<script type="text/javascript">
		function verdocumentos(HDid){
		var PARAM  = "../../cc/consultas/RFacturasCC2-DetalleDoc.cfm?pop=true&HDid="+ HDid;
		open(PARAM,'V1','left=110,top=150,scrollbars=yes,resizable=yes,width=1000,height=500')
		}
		</script>

<cf_templatefooter>
