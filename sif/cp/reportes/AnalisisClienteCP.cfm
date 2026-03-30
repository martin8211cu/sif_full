<cf_templateheader title="SIF - Cuentas por Pagar">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='An&aacute;lisis&nbsp;de&nbsp;Cliente'>

<form name="form1" action="AnalisisClienteCP.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;de&nbsp;Corte:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>

					<select name="Formato" id="Formato" tabindex="1">
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		  	<cf_web_portlet_end>
		</td>
	</tr>
</table>
</form>

<cf_templatefooter>
<cfif isdefined("url.Generar")>
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
		<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
	</cfif>

	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 320
	</cfquery>

	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
		<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
	</cfif>

	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
		<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
	</cfif>

	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
		<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
	</cfif>

	<cf_dbtemp name="transaccionCP" returnvariable="transaccionCP" datasource="#session.dsn#">
		<cf_dbtempcol name="Tid"  				type="numeric" 		identity="yes">
		<cf_dbtempcol name="tipo"  				type="char(3)" 		mandatory="no">
		<cf_dbtempcol name="documento"  		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="fecha"  			type="datetime" 	mandatory="no">
		<cf_dbtempcol name="fechavencimiento"  	type="datetime" 	mandatory="no">
		<cf_dbtempcol name="monto"   			type="money"  		mandatory="no">
		<cf_dbtempcol name="montooriginal"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="moneda"  			type="numeric"  	mandatory="no">
		<cf_dbtempcol name="transaccion"  		type="varchar(30)" 	mandatory="no">
		<cf_dbtempcol name="debcred" 			type="char(1)" 		mandatory="no">
		<cf_dbtempcol name="tiporef"   			type="char(2)"  	mandatory="no">
		<cf_dbtempcol name="documentoref" 		type="char(20)"  	mandatory="no">
		<cf_dbtempcol name="Mnombre" 			type="varchar(80)" 	mandatory="no">
		<cf_dbtempkey cols="Tid">
	</cf_dbtemp>

	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into #transaccionCP# (tipo, documento, fecha, fechavencimiento, monto, montooriginal, moneda, transaccion, debcred, tiporef, documentoref, Mnombre)
		select a.CPTcodigo Codigo, a.Ddocumento Documento, Dfecha, Dvencimiento, a.Dtotal, a.Dtotal, a.Mcodigo, '1. creacion', t1.CPTtipo, a.CPTRcodigo, DRdocumento,
		m.Mnombre
		from BMovimientosCxP a
		  inner join CPTransacciones t1
		     on t1.Ecodigo   = a.Ecodigo
			and t1.CPTcodigo = a.CPTcodigo
		  inner join Monedas m
		  	 on m.Mcodigo = a.Mcodigo
			and m.Ecodigo = a.Ecodigo
		where a.Ecodigo =   #session.Ecodigo#
			and a.SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			and a.CPTcodigo  = a.CPTRcodigo
			and a.Ddocumento = a.DRdocumento
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">

		union all

		select a.CPTcodigo Codigo, a.Ddocumento Documento, Dfecha, Dvencimiento, a.Dtotal, a.Dtotal, a.Mcodigo, '2. creacion Credito' , t1.CPTtipo, a.CPTRcodigo, DRdocumento,
		m.Mnombre
		from BMovimientosCxP a
			inner join CPTransacciones t1
				on t1.Ecodigo   = a.Ecodigo
			   and t1.CPTcodigo = a.CPTcodigo
			inner join CPTransacciones t2
				on t2.Ecodigo = a.Ecodigo
			   and t2.CPTcodigo = a.CPTRcodigo
			inner join Monedas m
				on m.Ecodigo = a.Ecodigo
			   and m.Mcodigo = a.Mcodigo
		where a.Ecodigo =   #session.Ecodigo#
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
			and t2.CPTpago = 1
			and t1.CPTtipo = 'C'
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">

		union all

		select a.CPTRcodigo Codigo, a.DRdocumento Documento, Dfecha, #lsparsedatetime('01/01/6100')#, BMmontoref as Dtotal, 0.00, a.Mcodigoref as Mcodigo, '3. Aplicacion' , case t2.CPTtipo when 'D' then 'C' else 'D' end, a.CPTcodigo, Ddocumento,
		m.Mnombre
		from BMovimientosCxP a
			inner join CPTransacciones t1
				on t1.Ecodigo = a.Ecodigo
			   and t1.CPTcodigo = a.CPTcodigo
			inner join CPTransacciones t2
				on t2.Ecodigo = a.Ecodigo
			   and t2.CPTcodigo = a.CPTRcodigo
			inner join Monedas m
				 on m.Ecodigo = a.Ecodigo
			    and m.Mcodigo = a.Mcodigoref
		where a.Ecodigo =   #session.Ecodigo#
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
			and t2.CPTpago = 0
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">

		union all

		select a.CPTcodigo Codigo, a.Ddocumento Documento, Dfecha, #lsparsedatetime('01/01/6100')#, BMmontoref as Dtotal, 0.00, a.Mcodigoref as Mcodigo, '4. Aplicacion a NC' , case t1.CPTtipo when 'D' then 'C' else 'D' end, a.CPTRcodigo, DRdocumento,
		m.Mnombre
		from BMovimientosCxP a
			inner join CPTransacciones t1
				on t1.Ecodigo = a.Ecodigo
			   and t1.CPTcodigo = a.CPTcodigo
			inner join CPTransacciones t2
				on t2.Ecodigo = a.Ecodigo
			   and t2.CPTcodigo = a.CPTRcodigo
			inner join Monedas m
				on m.Ecodigo = a.Ecodigo
			   and m.Mcodigo = Mcodigoref
		where a.Ecodigo =   #session.Ecodigo#
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			and (a.CPTcodigo <> a.CPTRcodigo or a.Ddocumento <> a.DRdocumento)
			and t1.CPTtipo = 'C'
			and t1.CPTpago = 0
			and t2.CPTpago = 0
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
	</cfquery>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select
			tipo,
			coalesce(documento, '*') as documento,
			moneda,
			min(fecha) as Fecha,
			min(fechavencimiento) as FechaVencimiento,
			sum(round(montooriginal * case when debcred = 'D' then 1.00 else -1.00 end,2)) as monto_original,
			sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2)) Saldo,
			<cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> as dias  ,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> < 0
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as SinVencer,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> >= 0
				       and <cf_dbfunction name="date_part"	args="mm, min(fechavencimiento)"> = <cf_dbfunction name="date_part"	args="mm, #lsparsedatetime(url.fechaDes)#">
					   and <cf_dbfunction name="date_part"	args="yy, min(fechavencimiento)"> = <cf_dbfunction name="date_part"	args="yy, #lsparsedatetime(url.fechaDes)#">
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as Corriente,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#p1#">
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as P1,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p1 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p2#"> <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">) --->
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as P2,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p2 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p3#">   <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">) --->
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as P3,
			case
			when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> between <cfqueryparam cfsqltype="cf_sql_integer" value="#p3 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#">   <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">) --->
				then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
				else 0.00
			end as P4,
			case
				when <cf_dbfunction name="datediff"	args="min(fechavencimiento), #lsparsedatetime(url.fechaDes)#"> > <cfqueryparam cfsqltype="cf_sql_integer" value="#p4 +1#"> <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">) --->
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as P5Plus,
			case
				when
					min(fechavencimiento) < <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
					then sum(round(monto * case when debcred = 'D' then 1.00 else -1.00 end,2))
					else 0.00
				end as Morosidad,
			Mnombre
		from #transaccionCP#
		group by moneda, tipo, documento, Mnombre
		having sum(monto * case when debcred = 'D' then 1.00 else -1.00 end) <> 0.00
		order by moneda, tipo, documento
	</cfquery>

	<cfquery name="drop" datasource="#session.DSN#">
		delete from #transaccionCP#
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>

	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre, SNnumero, SNidentificacion, SNmontoLimiteCC, b.Mnombre
			from SNegocios a
				inner join Monedas b
					on b.Ecodigo = a.Ecodigo
					and b.Mcodigo = a.Mcodigo
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and a.Ecodigo =   #session.Ecodigo#
		</cfquery>
	</cfif>

	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  #session.Ecodigo#
	</cfquery>

	 <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	<!--- Invocación del reporte --->
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and ( formatos neq "flashpaper" and formatos neq "pdf" )>
	  <cfset typeRep = 1>
	<!---   <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif> --->
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.AnalisisClienteCP"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#formatos#" template= "AnalisisClienteCP.cfr" query="rsReporte">
			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif>

			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#url.fechaDes#">
			</cfif>
			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			</cfif>

			<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
				<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
			</cfif>

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="Numero" value="#rsSNcodigo.SNnumero#">
				<cfreportparam name="Identificacion" value="#rsSNcodigo.SNidentificacion#">
				<cfreportparam name="Nombre" value="#rsSNcodigo.SNnombre#">
				<cfif len(trim(rsSNcodigo.SNmontolimiteCC))>
					<cfreportparam name="LimiteCredito" value="#rsSNcodigo.SNmontoLimiteCC#">
				<cfelse>
					<cfreportparam name="LimiteCredito" value="0">
				</cfif>
				<cfif len(trim(rsSNcodigo.Mnombre))>
					<cfreportparam name="Mnombre" value="#rsSNcodigo.Mnombre#">
				<cfelse>
					<cfreportparam name="Mnombre" value="Sin Definir">
				</cfif>
			</cfif>
			<cfif isdefined("P1")>
				<cfreportparam name="P1" value="#P1#">
			</cfif>
			<cfif isdefined("P2")>
				<cfreportparam name="P2" value="#P2#">
			</cfif>
			<cfif isdefined("P3")>
				<cfreportparam name="P3" value="#P3#">
			</cfif>
			<cfif isdefined("P4")>
				<cfreportparam name="P4" value="#P4#">
			</cfif>

		</cfreport>
	</cfif>
</cfif>
<cf_qforms>
       <cf_qformsRequiredField name="SNcodigo" description="Socio de Negocios">
</cf_qforms>

