<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Fisica = t.Translate('LB_Fisica','Física')>
<cfset LB_Juridica = t.Translate('LB_Juridica','Jurídica')>
<cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero')>
<cfset LB_NoTiene = t.Translate('LB_NoTiene','No Tiene')>

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

<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
	<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
		select coalesce(SNnombre,'') as SNnombre,
			   coalesce(SNidentificacion, '') as  ;SNidentificacion,
			   coalesce(SNdireccion, '#LB_NoTiene#') as SNdireccion,
			   coalesce(SNtelefono, '#LB_NoTiene#') as SNtelefono,
			   coalesce(SNFax, '#LB_NoTiene#') as SNFax,
			   coalesce(SNemail, '#LB_NoTiene#') as SNemail,
			   (case SNtipo when 'F' then '#LB_Fisica#' when 'J' then '#LB_Juridica#' when 'E' then '#LB_Extranjero#' else '???' end) as SNtipo
		from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		  and SNtiposocio in ('A', 'C')
	</cfquery>
</cfif>


<cfset LvarFechaHoy = dateformat(now(),"YYYY/MM/DD")>

<cfset LvarVenc1a   = dateadd('n', -1, LvarFechaHoy)>
<cfset LvarVenc1b   = dateadd('d', -venc1, LvarFechaHoy)>

<cfset LvarVenc2a   = dateadd('n', -1, LvarVenc1b)>
<cfset LvarVenc2b   = dateadd('d', -venc2, LvarFechaHoy)>

<cfset LvarVenc3a   = dateadd('n', -1, LvarVenc2b)>
<cfset LvarVenc3b   = dateadd('d', -venc3, LvarFechaHoy)>

<cfset LvarVenc4a   = dateadd('n', -1, LvarVenc3b)>
<cfset LvarVenc4b   = dateadd('d', -venc4, LvarFechaHoy)>


<cfquery name="rsGrafico1" datasource="#session.dsn#">
	select 
		coalesce(
			sum(
				case when d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as SinVencer

		,coalesce(
			sum(
				case when d.Dvencimiento between <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1b#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1a#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as Venc1

		,coalesce(
			sum(
				case when d.Dvencimiento between <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2b#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2a#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as Venc2

		,coalesce(
			sum(
				case when d.Dvencimiento between <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3b#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3a#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as Venc3

		,coalesce(
			sum(
				case when d.Dvencimiento between <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4b#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4a#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as Venc4

		,coalesce(
			sum(
				case when d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4b#">
				then 
					case t.CCTtipo when 'D' then (d.Dsaldo*d.Dtcultrev) else -(d.Dsaldo*d.Dtcultrev) end
				else
					0.00
				end
			),0.00) as Venc5

	from Documentos d
		inner join CCTransacciones t
		on  t.Ecodigo   = d.Ecodigo
		and t.CCTcodigo = d.CCTcodigo
	where d.Ecodigo = #session.Ecodigo#
	<cfif isdefined("Form.Ocodigo") and len(Form.Ocodigo) and Form.SNcodigo NEQ -1>
	  and d.Ocodigo = #Form.Ocodigo#
	</cfif>
	<cfif isdefined("Form.SNcodigo") and len(Form.SNcodigo) and Form.SNcodigo NEQ -1>
	  and d.SNcodigo = #Form.SNcodigo#
	</cfif>
</cfquery>

<cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer')>
<cfset LB_Masde = t.Translate('LB_Masde','Más de')>

<cfset rsGrafico = QueryNew("venc, monto", "VarChar, Double")>
<cfset newRow = QueryAddRow(rsGrafico, 6)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "#LB_SinVencer#", 1)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.SinVencer, "9.00")#", 1)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "1 - #venc1#", 2)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.Venc1, "9.00")#", 2)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "#venc1 + 1# - #venc2#", 3)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.Venc2, "9.00")#", 3)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "#venc2 + 1# - #venc3#", 4)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.Venc3, "9.00")#", 4)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "#venc3 + 1# - #venc4#", 5)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.Venc4, "9.00")#", 5)>

<cfset temp = QuerySetCell(rsGrafico, "venc", "#LB_Masde# #venc4#", 6)>
<cfset temp = QuerySetCell(rsGrafico, "monto", "#numberformat(rsGrafico1.Venc5, "9.00")#", 6)>

<cfquery name="rsValores" dbtype="query">
	select 
		min(monto) as minimo, 
		max(monto) as maximo 
	from rsGrafico 
</cfquery>

<cfset minimo = 0>
<cfset maximo = #rsValores.maximo#>

<cfset LB_TituloH = t.Translate('LB_TituloH','Consultas Administrativas')>
<cfset LB_Titulo = t.Translate('LB_Titulo','An&aacute;lisis de Antig&uuml;edad de Saldos de Cuentas por Cobrar')>

<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Persona = t.Translate('LB_Persona','Persona')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_Telefono = t.Translate('LB_Telefono','Tel&eacute;fono','/sif/generales.xml')>
<cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>

<cf_templateheader title="#LB_TituloH#">

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
</style>
			<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CC">
				<cfinclude template="../../portlets/pNavegacionCC.cfm">
			</cfif>
			<form action="AntigSaldosCxC.cfm" method="get" name="form1">
              <table width="100%" border="0">
                <tr>
                  <td colspan="5">&nbsp;</td>
                </tr>
				<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
					<tr> 
					  <td colspan="5">
						<cfoutput query="rsSocioDatos">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
						</cfoutput>
						</td>
					</tr>
					<tr>
						<td colspan="5">&nbsp;</td>
					</tr>
				</cfif>
                <tr valign="top"> 
                  <td width="5%">&nbsp; </td>
                  <td align="center"> 
                    <table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
                      <cfoutput>                     
                      <tr> 
                        <td class="encabReporte" align="center">#LB_Vencimiento#</td>
                        <td class="encabReporte" align="right">#LB_Saldo#</td>
                      </tr>
                      </cfoutput>
                      <cfloop query="rsGrafico">
                        <cfoutput> 
                          <tr> 
                            <td align="center" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="AntigSaldosDetCxC.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=#venc#">#venc#</a></td>
                            <td align="right" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="AntigSaldosDetCxC.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=#venc#">#LSCurrencyFormat(monto,'none')#</a></td>
                          </tr>
                        </cfoutput> 
                      </cfloop>
                    </table>
                  </td>
                  <td width="5%">&nbsp;</td>
                  <td align="center"> 
                    <table width="100%" border="0" dwcopytype="CopyTableCell">
                      <tr> 
                        <td valign="top" nowrap> 
                          <!--- Gráfico Aqui --->
							<!--- El valor maximo para el parametro sacaleto es aproximadamente este, si es mayor el cfchart se cae. 
								  Asi que si este valor se excede, por defecto se asigna el valo maxino aproximado que aguantaria...
							--->
							<cfif maximo gt 2147000000>
								<cfset maximo = 2147000000  >
							</cfif>
							<cfset session.referencia = 'AntigSaldosCxC.cfm'>
							<cfset LB_xaxistitle = t.Translate('LB_xaxistitle','Vencimiento en días')>
                            <cfset LB_yaxistitle = t.Translate('LB_yaxistitle','Total por Vencimiento')>
                           <cfchart gridlines="5"
					  				 xaxistitle="#LB_xaxistitle#" 
									 yaxistitle="#LB_yaxistitle#" 
									 scalefrom="#minimo#" 
									 scaleto="#maximo#" 
									 show3d="yes" 
									 showborder="no" 
									 showlegend="yes"
						 			 chartwidth="450"
									 url="AntigSaldosDetCxC.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=$ITEMLABEL$"> 
                          <cfchartseries 
								type="bar" 
								query="rsGrafico" 
								valuecolumn="monto" 
								serieslabel="" 
								itemcolumn="venc">
                          </cfchart>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form>
 <cf_web_portlet_end>
<cf_templatefooter>
