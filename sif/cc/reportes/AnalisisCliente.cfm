<cf_templateheader title="SIF - Cuentas por Cobrar">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='An&aacute;lisis&nbsp;de&nbsp;Cliente'>

<form name="form1" action="AnalisisCliente.cfm" method="post">
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
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
					<td colspan="4">&nbsp;</td>					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>
					
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
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
					<cf_botones values="Generar" names="Generar">
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
<cfif isdefined("form.Generar")>
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
		<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
	</cfif>

	<cftransaction>
	<cf_dbtemp name="transaccion" returnvariable="transaccion" datasource="#session.dsn#">
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
		insert into #transaccion# (tipo, documento, fecha, fechavencimiento, monto, montooriginal, moneda, transaccion, debcred, tiporef, documentoref,  Mnombre <!--- --->)
		select  distinct<!--- --->
			a.CCTcodigo Codigo, a.Ddocumento Documento, Dfecha, Dvencimiento, a.Dtotal, <!--- a.Dtotal --->case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal2, a.Mcodigo, '1. creacion', t1.CCTtipo, a.CCTRcodigo, DRdocumento , 
			m.Mnombre <!--- --->
		from BMovimientos a, CCTransacciones t1, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
			and a.CCTcodigo = a.CCTRcodigo
			and a.Ddocumento = a.DRdocumento
			and t1.CCTcodigo = a.CCTcodigo
			and t1.Ecodigo = a.Ecodigo
			and t1.CCTpago = 0
			and m.Mcodigo = a.Mcodigo
			and m.Ecodigo =a.Ecodigo
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
		
		union all
		
		select   distinct<!--- --->
			a.CCTcodigo Codigo, a.Ddocumento Documento, Dfecha, Dvencimiento, a.Dtotal, <!--- a.Dtotal --->case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal2, a.Mcodigo, '2. creacion Credito' , t1.CCTtipo, a.CCTRcodigo, DRdocumento, 
		m.Mnombre <!--- --->
		from BMovimientos a, CCTransacciones t1, CCTransacciones t2, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and (a.CCTcodigo <> a.CCTRcodigo or a.Ddocumento <> a.DRdocumento)
			and t1.CCTcodigo = a.CCTcodigo
			and t1.Ecodigo = a.Ecodigo
			and t2.CCTcodigo = a.CCTRcodigo
			and t2.Ecodigo = a.Ecodigo
			and t2.CCTpago = 1
			and t1.CCTtipo = 'C'
			and m.Mcodigo = a.Mcodigo
			and m.Ecodigo =a.Ecodigo
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
		
		union all
		
		 select  distinct<!--- --->
			a.CCTRcodigo, a.DRdocumento, Dfecha, '61000101', BMmontoref as Dtotal, 0.00, a.Mcodigoref as Mcodigo, '3. Aplicacion' , case t2.CCTtipo when 'D' then 'C' else 'D' end, a.CCTcodigo, Ddocumento<!--- --->,
		m.Mnombre 
		from BMovimientos a, CCTransacciones t1, CCTransacciones t2, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and (a.CCTcodigo <> a.CCTRcodigo or a.Ddocumento <> a.DRdocumento)
			and t1.CCTcodigo = a.CCTcodigo
			and t1.Ecodigo = a.Ecodigo
			and t2.CCTcodigo = a.CCTRcodigo
			and t2.Ecodigo = a.Ecodigo
			and t2.CCTpago = 0
			and m.Mcodigo = a.Mcodigoref 
			and m.Ecodigo = a.Ecodigo
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"> 
		
		 union all 
		
		select  distinct <!------>
			a.CCTcodigo, a.Ddocumento, Dfecha, '61000101', BMmontoref as Dtotal, 0.00, a.Mcodigoref as Mcodigo, '4. Aplicacion a NC' , case t1.CCTtipo when 'D' then 'C' else 'D' end, a.CCTRcodigo, DRdocumento,
		m.Mnombre 
		from BMovimientos a, CCTransacciones t1, CCTransacciones t2, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and a.CCTcodigo = a.CCTRcodigo 
			and a.Ddocumento = a.DRdocumento
			and t1.CCTcodigo = a.CCTcodigo
			and t1.Ecodigo = a.Ecodigo
			and t2.CCTcodigo = a.CCTRcodigo
			and t2.Ecodigo = a.Ecodigo 
			and t1.CCTtipo = 'D'
			and t1.CCTpago = 0
			and t2.CCTpago = 0
			and t1.CCTtranneteo = 0
			and m.Mcodigo = a.Mcodigo
			and m.Ecodigo = a.Ecodigo
			and Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"><!--- --->
			
		 union all
		 <!--- Recibos de Dinero --->
  		select  distinct<!--- --->
			a.CCTcodigo, a.Ddocumento, a.Dfecha, a.Dvencimiento, case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal, case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal2, a.Mcodigo, '5. Recibos de Dinero', case t1.CCTtipo when 'D' then 'C' else 'D' end, a.CCTRcodigo, DRdocumento,
			 m.Mnombre
			from BMovimientos a, CCTransacciones t1, CCTransacciones t2, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and t1.CCTcodigo = a.CCTcodigo
			and t1.Ecodigo = a.Ecodigo
			and t1.CCTcodigo = a.CCTcodigo
			and t2.Ecodigo = a.Ecodigo
			and t1.CCTpago = 1
			 and t1.CCTtranneteo = 0 <!------>
			and m.Ecodigo = a.Ecodigo
			and m.Mcodigo = a.Mcodigo
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"><!--- --->

<!---union all

<!---Recibos de Dinero Aplicados que generaron Notas de Credito --->
	  	select 
			<!--- distinct --->
			a.CCTcodigo, a.Ddocumento, a.Dfecha, a.Dvencimiento, case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal, case when t1.CCTtipo = 'C' then a.Dtotal * -1 else a.Dtotal end as Dtotal2, a.Mcodigo, '6. Recibos de Dinero aplicados a NC', case t1.CCTtipo when 'D' then 'C' else 'D' end, a.CCTRcodigo, DRdocumento,
			m.Mnombre
			from BMovimientos a, CCTransacciones t1, CCTransacciones t2, Monedas m
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
			and t1.CCTcodigo = a.CCTRcodigo
			 and a.CCTRcodigo <> a.CCTcodigo	
			and t2.Ecodigo = a.Ecodigo
			and t1.Ecodigo = a.Ecodigo	
			and t1.CCTpago = 1

			and t1.CCTtranneteo = 0 
			and m.Ecodigo = a.Ecodigo
			and m.Mcodigo = a.Mcodigo
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">   --->
<!--- 			group by a.Mcodigo, a.CCTcodigo, a.Ddocumento, a.Dfecha, a.Dvencimiento, 
				a.CCTRcodigo, DRdocumento, m.Mnombre --->
	</cfquery>	
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select distinct
			tipo, 
			coalesce(documento, '*') as documento, 
			moneda, 
			min(fecha) as Fecha, 
			min(fechavencimiento) as FechaVencimiento, 
			<!--- sum(<!--- convert(money, montooriginal * case when debcred = 'D' then 1.00 else -1.00 end) --->montooriginal) as monto_original,  --->
			montooriginal as monto_original,
			<!--- sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) Saldo,  --->
			convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end) as Saldo,
			dias = datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) ,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) < 0 
					and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) 
					<!--- and datepart(yy, min(fechavencimiento)) = datepart(yy, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as SinVencer,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) < 0 and datepart(mm, min(fechavencimiento)) = datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) and datepart(yy, min(fechavencimiento)) = datepart(yy, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) 
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as Corriente,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#p1#"> <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as P1,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) between <cfqueryparam cfsqltype="cf_sql_integer" value="#p1 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p2#"> <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as P2,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) between <cfqueryparam cfsqltype="cf_sql_integer" value="#p2 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p3#">   <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as P3,
			case 
			when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) between <cfqueryparam cfsqltype="cf_sql_integer" value="#p3 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#">   <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
				then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
				else $0.00 
			end as P4,
			case 
				when datediff(dd, min(fechavencimiento), <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) > <cfqueryparam cfsqltype="cf_sql_integer" value="#p4 +1#"> <!--- and datepart(mm, min(fechavencimiento)) <> datepart(mm, <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">) --->
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as P5Plus,
			case
				when 
				min(fechavencimiento) < <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"> 
					then convert(money, sum(convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)) )
					else $0.00 
				end as Morosidad, 
			Mnombre
		from #transaccion#
		 group by moneda, Mnombre, tipo, documento, montooriginal,
		 convert(money, monto * case when debcred = 'D' then 1.00 else -1.00 end)<!------>
		<!--- having sum(monto * case when debcred = 'D' then 1.00 else -1.00 end) <> 0.00  --->
		having montooriginal <> 0.00
		order by moneda, Mnombre, tipo, documento
	</cfquery>		
	</cftransaction>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>

 	<!---<cf_dump var="#rsReporte#"> --->
	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre, SNnumero, SNidentificacion, SNmontoLimiteCC, b.Mnombre
			from SNegocios a
				inner join Monedas b
					on b.Ecodigo = a.Ecodigo
					and b.Mcodigo = a.Mcodigo
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>


	
	 <cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
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
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.AnalisisCliente"/>
	<cfelse>
		<cfreport format="#formatos#" template= "AnalisisCliente.cfr" query="rsReporte">	
			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif> 
			
			<cfif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
				<cfreportparam name="fechaDes" value="#form.fechaDes#">
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

 
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="Socio de Negocios";
	
//-->	
</script>

