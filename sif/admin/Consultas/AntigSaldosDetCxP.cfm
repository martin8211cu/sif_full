<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','An&aacute;lisis De Antig&uuml;edad de Saldos de Cuentas por Pagar')>
<cfset LB_TituloH = t.Translate('LB_TituloH','Consultas Administrativas','AntigSaldosCxC.xml')>

<cf_templateheader title="#LB_TituloH#">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area">
         <!--- <td width="220" rowspan="2" valign="middle">
			<cfinclude template="../../portlets/pEmpresas2.cfm"></td>
    	 	<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
		  		<td nowrap><div align="center"></div>
		      	<div align="center"><span class="superTitulo"><font size="5">Consultas Administrativas</font></span></div></td>
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
		  		<td nowrap><div align="center"></div>
		      	<div align="center"><span class="superTitulo"><font size="5">Cuentas
              	por Pagar</font></span></div></td>
			</cfif>
        </tr>--->
        <tr class="area">
          <td width="50%" valign="bottom" nowrap>
			<cfset regresar = "javascript:history.back();">
    	 	<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
				<cfinclude template="../jsMenuAdmin.cfm">
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
				<cfinclude template="../../cp/jsMenuCP.cfm">
			</cfif>
          </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
      </table>
	<cfinclude template="Funciones.cfm">
	<cfset venc1 = Trim(get_val(310).Pvalor)>
	<cfset venc2 = Trim(get_val(320).Pvalor)>
	<cfset venc3 = Trim(get_val(330).Pvalor)>
	<cfset venc4 = Trim(get_val(340).Pvalor)>

	<cfif not isdefined("Form.SNcodigo")>
		<cfif isdefined("Url.SNcodigo")>
			<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
		<cfelse>
			<cfparam name="Form.SNcodigo" default="-1">
		</cfif>
	</cfif>

	<cfif not isdefined("Form.Ocodigo")>
		<cfif isdefined("Url.Ocodigo")>
			<cfparam name="Form.Ocodigo" default="#Url.Ocodigo#">
		<cfelse>
			<cfparam name="Form.Ocodigo" default="-1">
		</cfif>
	</cfif>

	<cfif not isdefined('Form.venc')>
		<cfif isdefined('Url.venc')>
			<cfif FindNoCase("Sin Vencer", Url.venc) GT 0>
				<cfparam name="Form.venc" default="1">
			<cfelseif FindNoCase("- " & venc1, Url.venc) GT 0>
				<cfparam name="Form.venc" default="2">
			<cfelseif FindNoCase("- " & venc2, Url.venc) GT 0>
				<cfparam name="Form.venc" default="3">
			<cfelseif FindNoCase("- " & venc3, Url.venc) GT 0>
				<cfparam name="Form.venc" default="4">
			<cfelseif FindNoCase("- " & venc4, Url.venc) GT 0>
				<cfparam name="Form.venc" default="5">
			<cfelseif FindNoCase(venc4, Url.venc)>
				<cfparam name="Form.venc" default="6">
			<cfelseif FindNoCase('Corriente', Url.venc)>
				<cfparam name="Form.venc" default="7">
			</cfif>
		<cfelse>
			<cfparam name="Form.venc" default="-1">
		</cfif>
	</cfif>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>

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

		<cfquery name="rsSocios" datasource="#Session.DSN#">
			select * from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and SNtiposocio in ('A', 'P')
			order by SNnombre
		</cfquery>
		<cfset LB_Fisica = t.Translate('LB_Fisica','Física','AntigSaldosCxC.xml')>
        <cfset LB_Juridica = t.Translate('LB_Juridica','Jurídica','AntigSaldosCxC.xml')>
        <cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero','AntigSaldosCxC.xml')>
        <cfset LB_NoTiene = t.Translate('LB_NoTiene','No Tiene','AntigSaldosCxC.xml')>

		<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
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
				and SNtiposocio in ('A', 'P')
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				order by SNnombre
			</cfquery>
		</cfif>

		<cfquery name="rsOficinas" datasource="#Session.DSN#">
			select * from Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			order by Odescripcion
		</cfquery>

		<cfinvoke component="sif.Componentes.AD_AntigSaldosCxP" method="ReporteSaldosSocio" returnvariable="rsConsulta">
			<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
			<cfinvokeargument name="Ecodigo"  value="#session.Ecodigo#"/>
		<cfif isdefined('Form.venc') and len(trim(Form.venc))>
			<cfinvokeargument name="vencSel"  value="#Form.venc#"/>
		</cfif>
			<cfinvokeargument name="SNcodigo" value="#Form.SNcodigo#"/>
			<cfinvokeargument name="Ocodigo"  value="#Form.Ocodigo#"/>
			<cfinvokeargument name="venc1"    value="#venc1#"/>
			<cfinvokeargument name="venc2"    value="#venc2#"/>
			<cfinvokeargument name="venc3"    value="#venc3#"/>
			<cfinvokeargument name="venc4"    value="#venc4#"/>
		</cfinvoke>

		<cfquery name="rsSociosConsulta" dbtype="query">
			select distinct socio from rsConsulta
		</cfquery>

		<cfset regresar = "/cfmx/sif/admin/Consultas/AntigSaldosCxP.cfm">
		<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
		<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
			<cfinclude template="../../portlets/pNavegacionCP.cfm">
		</cfif>

		<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
        <cfset Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
        <cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
        <cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>

        <cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento','AntigSaldosCxC.xml')>
        <cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','AntigSaldosCxC.xml')>

		<form action="AntigSaldosDetCxP.cfm" method="post" name="form1">
		  <table width="100%" border="0">
			<tr>
			  <td colspan="5" nowrap>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="5" align="right" style="padding-right: 5px">&nbsp;</td>
				  </tr>
				  <tr>
          			<cfoutput>
					<td align="right" style="padding-right: 5px">#LB_PROVEEDOR#</td>
                    </cfoutput>
					<td>
					  <select name="SNcodigo" onChange="javascript: this.form.submit();">
						<option value="-1" <cfif Form.SNcodigo EQ -1>selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
						<cfoutput query="rsSocios">
						  <option value="#rsSocios.SNcodigo#" <cfif Form.SNcodigo EQ rsSocios.SNcodigo>selected</cfif>>#rsSocios.SNnombre#</option>
						</cfoutput>
					  </select>
					</td>
          			<cfoutput>
					<td align="right" style="padding-left: 5px; padding-right: 5px">#Oficina#</td>
                    </cfoutput>
					<td>
					  <select name="Ocodigo" onChange="javascript: this.form.submit();">
						<option value="-1" <cfif Form.Ocodigo EQ -1>selected</cfif>><cfoutput>#LB_Todas#</cfoutput></option>
						<cfoutput query="rsOficinas">
						  <option value="#rsOficinas.Ocodigo#" <cfif Form.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
						</cfoutput>
					  </select>
					</td>
					<td width="50%">&nbsp;</td>
				  </tr>
				</table>
			  </td>
			</tr>
			<tr>
			  <td colspan="5">&nbsp;</td>
			</tr>
			<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
            <cfset LB_Persona = t.Translate('LB_Persona','Persona','AntigSaldosCxC.xml')>
			<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
            <cfset LB_Telefono = t.Translate('LB_Telefono','Tel&eacute;fono','/sif/generales.xml')>

			<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
			  <tr>
				<td colspan="5">
				  <cfoutput query="rsSocioDatos">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr align="center">
						<td class="tituloAlterno" colspan="6">#SNnombre#</td>
					  </tr>
					  <tr>
						<td style="padding-left: 5px; font-weight: bold;">Identificaci&oacute;n:</td>
						<td style="padding-left: 5px;">#SNidentificacion#</td>
						<td style="padding-left: 5px; font-weight: bold;">Persona:</td>
						<td style="padding-left: 5px;">#SNtipo#</td>
						<td style="padding-left: 5px; font-weight: bold;">Email:</td>
						<td style="padding-left: 5px;">#SNemail#</td>
					  </tr>
					  <tr>
						<td style="padding-left: 5px; font-weight: bold;">Direcci&oacute;n:</td>
						<td style="padding-left: 5px;">#SNdireccion#</td>
						<td style="padding-left: 5px; font-weight: bold;">Tel&eacute;fono:</td>
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
              	<cfset LB_VencimientoenDias = t.Translate('LB_Vencimiento','Vencimiento en d&iacute;as','AntigSaldosDetCxC.xml')>
				<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente','AntigSaldosDetCxC.xml')>
                <cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer','AntigSaldosCxC.xml')>
				<cfset LB_Masde = t.Translate('LB_Masde','Más de','AntigSaldosCxC.xml')>
			  <tr>
				<td colspan="5" style="padding-left: 10px">
                	<cfoutput>#LB_VencimientoenDias#</cfoutput>
					<select name="venc" onChange="javascript: this.form.submit();">
						<option value="-1" <cfif Form.venc EQ -1>selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
						<option value="7" <cfif Form.venc EQ 7>selected</cfif>><cfoutput>#LB_Corriente#</cfoutput></option>
						<option value="1" <cfif Form.venc EQ 1>selected</cfif>><cfoutput>#LB_SinVencer#</cfoutput></option>
						<option value="2" <cfif Form.venc EQ 2>selected</cfif>>1 - <cfoutput>#venc1#</cfoutput></option>
						<option value="3" <cfif Form.venc EQ 3>selected</cfif>><cfoutput>#venc1 + 1# - #venc2#</cfoutput></option>
						<option value="4" <cfif Form.venc EQ 4>selected</cfif>><cfoutput>#venc2 + 1# - #venc3#</cfoutput></option>
						<option value="5" <cfif Form.venc EQ 5>selected</cfif>><cfoutput>#venc3 + 1# - #venc4#</cfoutput></option>
						<option value="6" <cfif Form.venc EQ 6>selected</cfif>><cfoutput>#LB_Masde# #venc4#</cfoutput></option>
					</select>
				</td>
			  </tr>
			<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
            <cfset LB_Documento = t.Translate('LB_Documento','Documento','AntigSaldosDetCxC.xml')>
            <cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
            <cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento')>
            <cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
            <cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','AntigSaldosCxC.xml')>
            <cfset LB_Vencidoshace = t.Translate('LB_Vencidoshace','Vencidos hace','AntigSaldosDetCxC.xml')>
            <cfset LB_SaldoMonedaLocal = t.Translate('LB_SaldoMonedaLocal','Saldo Moneda Local','AntigSaldosDetCxC.xml')>
            <cfset LB_SaldoTotalMonedaLocal = t.Translate('LB_SaldoTotalMonedaLocal','Saldo Total en Moneda Local','AntigSaldosDetCxC.xml')>
            <cfset LB_SinDocumentos = t.Translate('LB_SinDocumentos','No se encontraron documentos que cumplan con el criterio de la consulta','AntigSaldosDetCxC.xml')>
			<cfset LB_SaldoTotalMonedaLocal = t.Translate('LB_SaldoTotalMonedaLocal','Saldo Total en Moneda Local')>
            <cfset LB_SinDocumentos = t.Translate('LB_SinDocumentos','No se encontraron documentos que cumplan con el criterio de la consulta')>

			  <tr>
				<td colspan="5">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<cfoutput>
						<cfloop query="rsSociosConsulta">
							<cfset socioL = rsSociosConsulta.socio>
							<cfif Form.SNcodigo EQ -1>
							<tr>
								<td class="tituloAlterno" colspan="8">#socioL#</td>
							</tr>
							</cfif>
							<tr >
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
									select rsConsulta.*
									from rsConsulta
									where rsConsulta.socio = <cfqueryparam cfsqltype="cf_sql_char" value="#socioL#">
									and rsConsulta.moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#monedaL#">
								</cfquery>
								<cfquery name="rsMonedasTotales" dbtype="query">
									select sum(monto) as totalmonto, sum(saldo) as totalsaldo, sum(saldolocal) as totalsaldolocal
									from rsFechasVencConsulta
								</cfquery>
								<cfset fechavencL = "">
								  <!------>
								<cfset IDDOCUMENTO = "">
								<cfloop query="rsFechasVencConsulta">
									<cfset IDDOCUMENTO = rsFechasVencConsulta.IDDOCUMENTO>
									<tr onclick="javascript:verdocumentos(#rsFechasVencConsulta.SNcodigo#,'#trim(rsFechasVencConsulta.documento)#','#trim(rsFechasVencConsulta.transaccion)#',#IDDOCUMENTO#);" style="cursor:pointer">
										<td align="center" <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsFechasVencConsulta.transaccion#</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsFechasVencConsulta.documento#</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">#DateFormat(rsFechasVencConsulta.fecha,'dd/mm/yyyy')#</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center">#DateFormat(rsFechasVencConsulta.fechavenc,'dd/mm/yyyy')#
										</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="right">#LSCurrencyFormat(rsFechasVencConsulta.monto, 'none')#</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="right">#LSCurrencyFormat(rsFechasVencConsulta.saldo, 'none')#</td>
										<td <cfif #rsFechasVencConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> align="center"><cfif #rsFechasVencConsulta.diasvenc# LTE 0>Sin vencer<cfelse>#rsFechasVencConsulta.diasvenc#</cfif></td>
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
	function verdocumentos(SNcodigo,Ddocumento,CPTcodigo,IDdocumento){
		var PARAM  = "../../cp/consultas/RFacturasCP2-DetalleDoc.cfm?pop=true&SNcodigo="+ SNcodigo +"&Ddocumento="+Ddocumento+"&CPTcodigo="+CPTcodigo+"&IDdocumento="+IDdocumento;
		open(PARAM,'V1','left=110,top=150,scrollbars=yes,resizable=yes,width=1000,height=500')
	}
	</script>
<cf_templatefooter>