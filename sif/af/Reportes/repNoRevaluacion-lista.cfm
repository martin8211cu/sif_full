<cfif isdefined('url.FAGTPperiodo') and not isdefined('form.FAGTPperiodo')>
	<cfset form.FAGTPperiodo = url.FAGTPperiodo>
</cfif>
<cfif isdefined('url.FAGTPmes') and not isdefined('form.FAGTPmes')>
	<cfset form.FAGTPmes = url.FAGTPmes>
</cfif>
<cfif isdefined('url.ACcodigo') and not isdefined('form.ACcodigo')>
	<cfset form.ACcodigo = url.ACcodigo>
</cfif>
<cfif isdefined('url.ACid') and not isdefined('form.ACid')>
	<cfset form.ACid = url.ACid>
</cfif>
<cfif isdefined('url.FAGTPformato') and not isdefined('form.FAGTPformato')>
	<cfset form.FAGTPformato = url.FAGTPformato>
</cfif>

<cfif form.FAGTPformato EQ "1">
	<!---<cfif form.FAGTPperiodo GT 0 and form.FAGTPmes GT 0 and form.ACcodigo GT 0>--->
	<cfif form.FAGTPperiodo GT 0 and form.FAGTPmes GT 0>

		<!--- Asignación de valores de la tabla de Procesos --->
		<cfset HoraReporte = Now()> 
		
		<!--- Query para solo Revaluaciones --->
		<cfquery name="lista" datasource="#session.DSN#">
			select distinct
				a.Aid,
				a.Aplaca,
				a.Adescripcion,
				e.AFSvaladq,
				e.AFSvalmej,
				e.AFSvalrev,
				e.AFSdepacumadq,
				e.AFSdepacummej,
				e.AFSdepacumrev,
				e.AFSsaldovutiladq,
				b.ACcodigodesc as ACATcodigo,
				b.ACdescripcion as ACATdescripcion,
				c.ACcodigodesc as ACLASIFcodigo,
				c.ACdescripcion as ACLASIFdescripcion,
				f.CFcodigo,
				f.CFdescripcion,
				d.Oficodigo,
				d.Odescripcion
				
				from Activos a
					inner join ACategoria b     	<!---PK_ACATEGORIA--->  
						on a.Ecodigo = b.Ecodigo
					   and a.ACcodigo = b.ACcodigo
					   
					inner join AClasificacion c 	<!---PK_ACLASIFICACION--->
						on  a.Ecodigo = c.Ecodigo
						and a.ACid = c.ACid
						and a.ACcodigo = c.ACcodigo
					
					inner join AFSaldos e 			<!---AFSaldos_FK1--->
						on  a.Aid = e.Aid 
						and a.Ecodigo = e.Ecodigo 
						
					inner join Oficinas d			 <!---PK_OFICINAS--->
						on  e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo 
					
					inner join CFuncional f 		 <!---AK_KEY_2_CFUNCION---> 
						on e.Ecodigo = f.Ecodigo 
						and e.CFid = f.CFid
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and c.ACrevalua = 'S'
			<cfif isdefined('form.ACcodigo') and len(trim(form.ACcodigo)) and form.ACcodigo GT 0>
				   and a.ACcodigo = #form.ACcodigo#
			</cfif>
			<cfif isdefined('form.Oficodigo') and len(trim(form.Oficodigo)) and form.Oficodigo GT 0>
				   and e.Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Oficodigo#">
			</cfif>
			<cfif isdefined('form.ACid') and len(trim(form.ACid)) and form.ACid GT 0>
				   and a.ACid = #form.ACid#
			</cfif>
					and not exists (select 1 
									 from AFSaldos f 
										where a.Ecodigo = f.Ecodigo 
										and a.Aid = f.Aid
									<cfif isdefined('form.FAGTPperiodo') and len(trim(form.FAGTPperiodo)) and form.FAGTPperiodo GT 0>
										and f.AFSperiodo = #form.FAGTPperiodo#
									</cfif>
									<cfif isdefined('form.FAGTPmes') and len(trim(form.FAGTPmes)) and form.FAGTPmes GT 0>
										and f.AFSmes = #form.FAGTPmes#
									</cfif>
										and AFSsaldovutiladq > 0)
				    and not exists (select 1 
									  from TransaccionesActivos g 
									  	where a.Ecodigo = g.Ecodigo 
										and a.Aid = g.Aid 
										and g.IDtrans = 5)
					and <cf_dbfunction name="date_part"   args="yy,a.Afechainidep"> <= #form.FAGTPperiodo# 
					and <cf_dbfunction name="date_part"   args="mm,a.Afechainidep"> <= #form.FAGTPmes#
			group by a.Aid, a.Aplaca, a.Adescripcion, e.AFSvaladq, e.AFSvalmej, e.AFSvalrev, e.AFSdepacumadq, e.AFSdepacummej, e.AFSdepacumrev, e.AFSsaldovutiladq, b.ACcodigodesc, b.ACdescripcion, c.ACcodigodesc, c.ACdescripcion, f.CFcodigo, f.CFdescripcion, d.Oficodigo,   d.Odescripcion
			order by b.ACdescripcion, c.ACdescripcion, f.CFdescripcion, a.Adescripcion
		</cfquery>
		
		<style type="text/css">
		<!--
		.style1 {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 14px;
			font-weight: bold;
		}
		.style2 {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 10px;
		}
		.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
		
		.style4 {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 10px;
			font-weight: bold;
		}
		.style5 {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 11px;
			font-weight: bold;
		}
		.style6 {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 7px;
			font-weight: bold;
		}
		-->
		</style>
		
		<cf_htmlReportsHeaders 
				title="Impresion de No Revaluaci&oacute;n" 
				filename="RepNoRevaluacion.xls"
				irA="repNoRevaluacion.cfm?AGTPid="
				download="no"
				preview="no">
				
		<!--- Cambio el número de mes al nombre (Etiqueta) --->
		<cfquery name="GetMonthNames" datasource="#session.dsn#">
			select VSdesc as MonthName
			from VSidioma v
				inner join Idiomas i
					on i.Iid = v.Iid
					and i.Icodigo = '#session.Idioma#'
			where v.VSgrupo = 1
			order by <cf_dbfunction name="to_number" args="VSvalor">
		</cfquery>
		<cfset listMeses = ValueList(GetMonthNames.MonthName)>
		
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
		</tr>			
		<tr>
			<td colspan="2" align="center"><span class="style1">Lista de Transacciones de No Revaluaci&oacute;n</span></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><cfoutput><strong>Periodo</strong> #form.FAGTPperiodo# / <strong>Mes</strong> #ListGetAt(listMeses,form.FAGTPmes)#</cfoutput></td>
		</tr>
		<cfif isdefined('form.Oficodigo') and len(trim(form.Oficodigo)) and form.Oficodigo GT 0>
			<cfquery name="rsOficina" datasource="#session.DSN#">
				select Odescripcion
				from Oficinas
				where Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfoutput query="rsOficina">
		<tr>
			<td colspan="2" align="center"><strong>Oficina</strong> #form.Oficodigo# - #rsOficina.Odescripcion#</td>
		</tr>
			</cfoutput>
		</cfif>
		
		<tr class="style6"><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
				<tr style="padding:10px;">
					<td style="padding:3px; padding-left:15px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Placa</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Descripci&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Adquisici&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Mejora</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Revaluaci&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Adq</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Mej</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Rev</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Saldo Vida Util</strong></td>
					<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" width="10%"><strong>Oficina</strong></td>
				</tr>
		<cfset vCFdescripcion = "" >
		<cfset vACATdescripcion = "" >
		<cfset vACLASIFdescripcion = "" >
		<cfset registros = 0 >
		<cfset Contadorlineas = 0>
		<cfoutput query="lista">
				<cfset registros = registros + 1 >
				<cfset Contadorlineas = Contadorlineas+1>
				<cfif Contadorlineas gte 49>
					<cfset Contadorlineas = 1>
					<!--- hace un corte de página y pinta los encabezados --->
				</table>
			</td>
		</tr>
		</table>
		<br />
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2" align="center" bgcolor="E4E4E4"><span class="style3">#Session.Enombre#</span></td>
		</tr>			
		<tr>
			<td colspan="2" align="center"><span class="style1">Lista de Transacciones de No Revaluaci&oacute;n</span></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><strong>Periodo</strong> #form.FAGTPperiodo# / <strong>Mes</strong> #ListGetAt(listMeses,form.FAGTPmes)#</td>
		</tr>				
		
		<tr class="style6"><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
				<tr style="padding:10px;">
					<td style="padding:3px; padding-left:15px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Placa</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Descripci&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Adquisici&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Mejora</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Revaluaci&oacute;n</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Adq</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Mej</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Dep Acum Rev</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Saldo Vida Util</strong></td>
					<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap" width="10%"><strong>Oficina</strong></td>
				</tr>

				<tr style="padding:10px;"><td colspan="10" bgcolor="E4E4E4" style="padding:3px; font-size:13px">
					<strong>

					Categor&iacute;a: #ACATcodigo# - #ACATdescripcion#<br />
					Clasificaci&oacute;n: #ACLASIFcodigo# - #ACLASIFdescripcion#<br />
					Centro Funcional: #CFcodigo# - #CFdescripcion#

					</strong>
				</td></tr>

					<cfset Contadorlineas = Contadorlineas + 3>
				</cfif>

				<cfif (vCFdescripcion NEQ CFdescripcion) or (vACATdescripcion NEQ ACATdescripcion) or (vACLASIFdescripcion NEQ ACLASIFdescripcion)>
				<tr style="padding:10px;"><td colspan="10" bgcolor="E4E4E4" style="padding:3px; font-size:13px">
					<strong>
				</cfif>

				<cfif (vACATdescripcion NEQ ACATdescripcion) or (vACLASIFdescripcion NEQ ACLASIFdescripcion)>
					Categor&iacute;a: #ACATcodigo# - #ACATdescripcion#<br />
					Clasificaci&oacute;n: #ACLASIFcodigo# - #ACLASIFdescripcion#<br />
					Centro Funcional: #CFcodigo# - #CFdescripcion#
					<cfset Contadorlineas = Contadorlineas+3>
					<cfset vACATdescripcion = ACATdescripcion >
					<cfset vACLASIFdescripcion = ACLASIFdescripcion >
					<cfset vCFdescripcion = CFdescripcion >
				</cfif>

				<cfif vCFdescripcion NEQ CFdescripcion>
					Centro Funcional: #CFcodigo# - #CFdescripcion#
					<cfset Contadorlineas = Contadorlineas+1>
					<cfset vCFdescripcion = CFdescripcion >
				</cfif>

				<cfif (vCFdescripcion NEQ CFdescripcion) or (vACATdescripcion NEQ ACATdescripcion) or (vACLASIFdescripcion NEQ ACLASIFdescripcion)>
					</strong>
				</td></tr>
				</cfif>

				<tr>
					<td nowrap="nowrap" style=" padding-left:15px;  font-size:13px" >#APlaca#</td>
					<td style="font-size:13px">#Adescripcion#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSvaladq,',0.00')#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSvalmej,',0.00')#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSvalrev,',0.00')#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSdepacumadq,',0.00')#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSdepacummej,',0.00')#</td>
					<td style="font-size:13px">#LSNumberFormat(AFSdepacumrev,',0.00')#</td>
					<td style="font-size:13px">#AFSsaldovutiladq#</td>
					<td style="font-size:13px">#Oficodigo#<cfif Oficodigo NEQ "">- #Odescripcion#</cfif></td>
				</tr>
		</cfoutput>
				</table>
			</td>
		</tr>
		<cfif registros eq 0 >
		<tr><td colspan="2" align="center">--- No se encontraron registros ---</td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="2" align="center">--- Fin del Reporte ---</td></tr>
		<tr><td>&nbsp;</td></tr>	
		</table>
	<cfelse>
		<script>history.go(-1);</script>
	</cfif>
</cfif>