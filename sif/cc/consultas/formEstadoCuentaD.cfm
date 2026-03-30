<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 6-9-2005.
		Motivo: Se corrige el query pues filtraba por el SNnombre y debe filtrar por el SNnumero que es el número que se ve en la pantalla, 
		además se prevee si por alguna razón falla la validacion de los rangos del socio en el fuente EstadoCuenta.cfm para que actue como se espera.
	Modificado por Gustavo Fonseca H.
		Fecha: 23-11-2005.
		Motivo: Se corrige la condición de la fecha por que no estaba filtrando bien.
 --->
 
<!--- Las Fechas Son Requeridas --->
<cfif isdefined("url.fecha1") and not isdefined("Form.fecha1")>
	<cfparam name="Form.fecha1" default="#url.fecha1#">
</cfif>
<cfif isdefined("url.fecha2") and not isdefined("Form.fecha2")>
	<cfparam name="Form.fecha2" default="#url.fecha2#">
</cfif>
<!--- Los Nombres No Son Requeridos --->
<cfif isdefined("url.SNnombre1") and not isdefined("Form.SNnombre1")>
	<cfparam name="Form.SNnombre1" default="#url.SNnombre1#">
</cfif>
<cfif isdefined("url.SNnombre2") and not isdefined("Form.SNnombre2")>
	<cfparam name="Form.SNnombre2" default="#url.SNnombre2#">
</cfif>
<cfif isdefined("url.SNnumero1") and not isdefined("Form.SNnumero1")>
	<cfparam name="Form.SNnumero1" default="#url.SNnumero1#">
</cfif>
<cfif isdefined("url.SNnumero2") and not isdefined("Form.SNnumero2")>
	<cfparam name="Form.SNnumero2" default="#url.SNnumero2#">
</cfif>

<!--- Consulta --->
<cfquery name="rsData" datasource="#Session.DSN#">
	select sn.SNnombre, a.CCTcodigo, t1.CCTdescripcion, a.Ddocumento, a.Dtotal as Dtotal, a.Mcodigo as Mcodigo, a.Dfecha, '1. creacion' , t1.CCTtipo, a.CCTRcodigo, a.DRdocumento
	from BMovimientos a, CCTransacciones t1, SNegocios sn
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and a.CCTcodigo = a.CCTRcodigo
		and a.Ddocumento = a.DRdocumento
		and t1.CCTcodigo = a.CCTcodigo
		and t1.Ecodigo = a.Ecodigo
		and sn.Ecodigo = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) 
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>
		
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq -1> 
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif> 
		
		and convert(datetime,convert(varchar,a.Dfecha,112)) <= convert(datetime,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecha2)#">)
	
	union all
	
	select sn.SNnombre, a.CCTcodigo, t1.CCTdescripcion, a.Ddocumento, a.Dtotal as Dtotal, a.Mcodigo as Mcodigo, a.Dfecha, '2. creacion Credito' , t1.CCTtipo, a.CCTRcodigo, a.DRdocumento
	from BMovimientos a, CCTransacciones t1, CCTransacciones t2, SNegocios sn
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and (a.CCTcodigo <> a.CCTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CCTcodigo = a.CCTcodigo
		and t1.Ecodigo = a.Ecodigo
		and t2.CCTcodigo = a.CCTRcodigo
		and t2.Ecodigo = a.Ecodigo
		and t2.CCTpago = 1
		and t1.CCTtipo = 'C'
		and sn.Ecodigo = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) 
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>
		
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq -1> 
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 1>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 0>
				and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif> 
		
		and convert(datetime,convert(varchar,a.Dfecha,112)) <= convert(datetime,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecha2)#">)
	
	union all
	
	select sn.SNnombre, a.CCTRcodigo, t2.CCTdescripcion, a.DRdocumento, coalesce(a.BMmontoref,a.Dtotal) as Dtotal, 
			coalesce(a.Mcodigoref,a.Mcodigo) as Mcodigo, a.BMfecha, '3. Aplicacion' , 
			'D', a.CCTcodigo, a.Ddocumento
	from BMovimientos a, CCTransacciones t1, CCTransacciones t2, SNegocios sn
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and (a.CCTcodigo <> a.CCTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CCTcodigo = a.CCTcodigo
		and t1.Ecodigo = a.Ecodigo
		and t2.CCTcodigo = a.CCTRcodigo
		and t2.Ecodigo = a.Ecodigo
		and t2.CCTpago = 0
		and sn.Ecodigo = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) 
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>
		
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq -1> 
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 1>
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 0>
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.BMfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.BMfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif> 
		
		and convert(datetime,convert(varchar,a.BMfecha,112)) <= convert(datetime,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecha2)#">)
	
	union all
	
	select sn.SNnombre, a.CCTcodigo, t1.CCTdescripcion, a.Ddocumento, coalesce(a.BMmontoref,a.Dtotal) as Dtotal, 
			coalesce(a.Mcodigoref,a.Mcodigo) as Mcodigo, a.BMfecha, '4. Aplicacion a NC' , 
			'C', a.CCTRcodigo, DRdocumento
	from BMovimientos a, CCTransacciones t1, CCTransacciones t2, SNegocios sn
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and (a.CCTcodigo <> a.CCTRcodigo or a.Ddocumento <> a.DRdocumento)
		and t1.CCTcodigo = a.CCTcodigo
		and t1.Ecodigo = a.Ecodigo
		and t2.CCTcodigo = a.CCTRcodigo
		and t2.Ecodigo = a.Ecodigo
		and t1.CCTtipo = 'C'
		and t1.CCTpago = 0
		and t2.CCTpago = 0
		and t1.CCTtranneteo = 0
		and sn.Ecodigo = a.Ecodigo
		and sn.SNcodigo = a.SNcodigo
		and upper(sn.SNnumero)
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) 
			and  form.SNnumero2 GTE SNnumero1 >
			 between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2))
		    and form.SNnumero2 LT SNnumero1 >
			between upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
					and upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero1") and Len(Trim(Form.SNnumero1)) and isdefined("Form.SNnumero2") and len(trim(form.SNnumero2)) eq 0>
			>= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero1#">)
		</cfif>
		<cfif isdefined("Form.SNnumero2") and Len(Trim(Form.SNnumero2)) and  isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0>
			<= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SNnumero2#">)
		</cfif>
		
		<cfif isdefined("Form.SNnumero1") and len(trim(Form.SNnumero1)) eq 0 and isdefined("Form.SNnumero2") and len(trim(Form.SNnumero2)) eq 0>
			> 0
		</cfif>
		
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq -1> 
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 1>
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(lsparsedatetime(form.fecha1), lsparsedatetime(form.fecha2)) eq 0>
				and a.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and a.BMfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and a.BMfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif> 
		
		and convert(datetime,convert(varchar,a.BMfecha,112)) <= convert(datetime,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecha2)#">)
	
	order by 6,1,4,8
</cfquery>

<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mcodigo, Mnombre
	from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
</style>
<br>
<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">Integración de Saldos por Documento en Cuentas por Cobrar</td>
		</tr>
		<tr>
			<td class="style2">
				<cfif isdefined("Form.fecha1") and Len(Trim(Form.fecha1)) NEQ 0>
					Desde: #LSDateFormat(Form.fecha1, 'dd/mm/yyyy')# &nbsp; 
				<cfelse>
					Desde: Inicio &nbsp; 
				</cfif>
				<cfif isdefined("Form.fecha2") and Len(Trim(Form.fecha2)) NEQ 0>
					Hasta: #LSDateFormat(Form.fecha2, 'dd/mm/yyyy')# 
				<cfelse>
					Hasta: #LSdateFormat(Now(),'dd/mm/yyyy')# 
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="style3">
				Clientes:
				<cfif Len(Trim(Form.SNnombre1)) EQ 0 and Len(Trim(Form.SNnombre2)) EQ 0>
					Todos
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0 and Len(Trim(Form.SNnombre2)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i> Hasta <i>#Form.SNnombre2#</i>
				<cfelseif Len(Trim(Form.SNnombre1)) NEQ 0>
					Desde <i>#Form.SNnombre1#</i>
				<cfelseif Len(Trim(Form.SNnombre2)) NEQ 0>
					Hasta <i>#Form.SNnombre2#</i>
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">Moneda</td>
	<td class="tituloListas">Fecha</td>
    <td class="tituloListas" align="right">Saldo Inicial</td>
	<td class="tituloListas" align="right">Débitos</td>
    <td class="tituloListas" align="right">Créditos</td>
    <td class="tituloListas" align="right">Saldo Final</td>
  </tr>
<cfoutput query="rsData" group="Mcodigo">
  <cfset Lvar_msaldoinicial = 0.00>
  <cfset Lvar_mdocumentos = 0.00>
  <cfset Lvar_mpagos = 0.00>
  <cfset Lvar_msaldo = 0.00>
  <cfquery dbtype="query" name="rsMoneda">
	select Mnombre from rsMonedas where Mcodigo = <cfif len(Mcodigo)>#Mcodigo#<cfelse>-1</cfif>
  </cfquery>
  
  <tr>
	<td style="border-bottom: 1px solid black; border-top:1px solid black;  " class="listaCorte" align="left" colspan="6" nowrap >
		<cfif rsMoneda.recordcount and len(rsMoneda.Mnombre)>#rsMoneda.Mnombre#<cfelse>Desconocida</cfif>
	 </td>
  </tr>
  <cfoutput group="SNnombre">
	<cfset LvarListaNon = false>
	  <tr>
		<td class="tituloListas" align="left" colspan="6" nowrap >
			#SNnombre#
		</td>
	  </tr>
	<cfset Lvar_ssaldoinicial = 0.00>
	<cfset Lvar_sdocumentos = 0.00>
	<cfset Lvar_spagos = 0.00>
	<cfset Lvar_ssaldo = 0.00>
	<cfoutput group="Ddocumento">
		<cfset Lvar_saldoinicial = 0.00>
		<cfset Lvar_documentos = 0.00>
		<cfset Lvar_pagos = 0.00>
		<cfset Lvar_saldo = 0.00>
		<cfoutput>
			<cfif len(rsData.Dtotal) and IsNumeric(rsData.Dtotal) and rsData.Dtotal gt 0.00>
				<cfif DateCompare(rsData.Dfecha,LSParseDateTime(form.fecha1)) lte 0>
					<cfif rsData.CCTtipo eq 'D'>
						<cfset Lvar_saldoinicial = Lvar_saldoinicial + rsData.Dtotal>
					<cfelse>
						<cfset Lvar_saldoinicial = Lvar_saldoinicial - rsData.Dtotal>
					</cfif>
				<cfelse>
					<cfif rsData.CCTtipo eq 'D'>
						<cfset Lvar_documentos = Lvar_documentos + rsData.Dtotal>
					<cfelse>
						<cfset Lvar_pagos = Lvar_pagos + rsData.Dtotal>
					</cfif>
				</cfif>
				<cfif rsData.CCTtipo eq 'D'>
					<cfset Lvar_saldo = Lvar_saldo + rsData.Dtotal>
				<cfelse>
					<cfset Lvar_saldo = Lvar_saldo - rsData.Dtotal>
				</cfif>
			</cfif>
		</cfoutput>
		<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>><cfloop from="1" to="10" index="i">&nbsp;</cfloop>#Ddocumento#</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>#LSDateFormat(Dfecha,'dd/mm/yyyy')#</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(Lvar_saldoinicial,'none')#</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(Lvar_documentos,'none')#</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(Lvar_pagos,'none')#</td>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(Lvar_saldo,'none')#</td>
		</tr>
		<cfset LvarListaNon = not LvarListaNon>
		<!--- Saldos de Monedas --->
		<cfset Lvar_msaldoinicial = Lvar_msaldoinicial + Lvar_saldoinicial>
		<cfset Lvar_mdocumentos = Lvar_mdocumentos + Lvar_documentos>
		<cfset Lvar_mpagos = Lvar_mpagos + Lvar_pagos>
		<cfset Lvar_msaldo = Lvar_msaldo + Lvar_saldo>
		<!--- Saldos de Socios --->
		<cfset Lvar_ssaldoinicial = Lvar_ssaldoinicial + Lvar_saldoinicial>
		<cfset Lvar_sdocumentos = Lvar_sdocumentos + Lvar_documentos>
		<cfset Lvar_spagos = Lvar_spagos + Lvar_pagos>
		<cfset Lvar_ssaldo = Lvar_ssaldo + Lvar_saldo>
	</cfoutput>
	  <tr>
		<td style="border-bottom: 1px solid black; "  class="tituloListas" nowrap><strong>Total #SNnombre#</strong></td>
		<td style="border-bottom: 1px solid black; "  class="tituloListas" nowrap><strong>&nbsp;</strong></td>
		<td style="border-bottom: 1px solid black; " class="tituloListas" nowrap align="right"><strong>#LSCurrencyFormat(Lvar_ssaldoinicial,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " class="tituloListas" nowrap align="right"><strong>#LSCurrencyFormat(Lvar_sdocumentos,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " class="tituloListas" nowrap align="right"><strong>#LSCurrencyFormat(Lvar_spagos,'none')#</strong></td>
		<td style="border-bottom: 1px solid black; " class="tituloListas" nowrap align="right"><strong>#LSCurrencyFormat(Lvar_ssaldo,'none')#</strong></td>
	</tr>
  </cfoutput>
  <tr class="listaCorte">
	<td nowrap><strong>Total <cfif rsMoneda.recordcount and len(rsMoneda.Mnombre)>#rsMoneda.Mnombre#<cfelse>Desconocida</cfif></strong></td>
	<td nowrap><strong>&nbsp;</strong></td>
	<td nowrap align="right"><strong>#LSCurrencyFormat(Lvar_msaldoinicial,'none')#</strong></td>
	<td nowrap align="right"><strong>#LSCurrencyFormat(Lvar_mdocumentos,'none')#</strong></td>
	<td nowrap align="right"><strong>#LSCurrencyFormat(Lvar_mpagos,'none')#</strong></td>
	<td nowrap align="right"><strong>#LSCurrencyFormat(Lvar_msaldo,'none')#</strong></td>
  </tr>
  <tr><td colspan="6">&nbsp;</td></tr>
</cfoutput>
</table>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>