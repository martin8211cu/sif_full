<cfif not isdefined("Form.FORMATO")>
	<cfset 	Form.FORMATO = '1'>
</cfif> 

<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>

<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
	select coalesce(SNnombre,'') as SNnombre,
		   coalesce(SNidentificacion, '') as SNidentificacion,
		   coalesce(SNdireccion, 'No Tiene') as SNdireccion,
		   coalesce(SNtelefono, 'No Tiene') as SNtelefono,
		   coalesce(SNFax, 'No Tiene') as SNFax,
		   coalesce(SNemail, 'No Tiene') as SNemail,
		   (case SNtipo when 'F' then 'Física' when 'J' then 'Jurídica' when 'E' then 'Extranjero' else '???' end) as SNtipo
	from SNegocios 
	where Ecodigo =  #Session.Ecodigo# 
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.B2B.SNcodigo#">
	  and SNtiposocio in ('A', 'P')
</cfquery>

<cf_dbfunction name="now" returnvariable="now">
<cf_dbfunction name="datediff" args="a.Dfechavenc, #now#" returnvariable="DiasVencimiento">
<cfquery name="rsGraficoBar" datasource="#session.dsn#">
	select 
 		coalesce(sum(case when #PreserveSingleQuotes(DiasVencimiento)# < 0
			 		 then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end) else 0.00 end * coalesce(Dtipocambio,1)),00)   as SinVencer,
 		coalesce(sum(case when #PreserveSingleQuotes(DiasVencimiento)#  =0
			 		 then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end) else 0.00 end * coalesce(Dtipocambio,1)),00) as Hoy,
		coalesce(sum(case when
			  #PreserveSingleQuotes(DiasVencimiento)#  between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1#">
		  then (EDsaldo* case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00 )  caso01,
		coalesce(sum(case when
			  #PreserveSingleQuotes(DiasVencimiento)#  between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2#">
		  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)  else 0.00 end  * coalesce(Dtipocambio,1) ),00)  as caso02,
		coalesce(sum(case when
			  #PreserveSingleQuotes(DiasVencimiento)# between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3#">
		  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00 )   as caso03,
		coalesce(sum(case when
			 #PreserveSingleQuotes(DiasVencimiento)#  between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
		  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)  else 0.00 end * coalesce(Dtipocambio,1)),00) as caso04,	
		coalesce(sum(case when
			  #PreserveSingleQuotes(DiasVencimiento)#  > <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
		  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00) as mayores,
	  round(sum(a.EDsaldo  * a.EDtcultrev * case when c.CPTtipo = 'C' then 1.00 else -1.00 end), 2) as Saldo
	from EDocumentosCP a
		inner join CPTransacciones c
			on c.Ecodigo = a.Ecodigo
			and c.CPTcodigo = a.CPTcodigo
	where a.Ecodigo = #session.Ecodigo#
	  and a.EDsaldo > 0
	<cfif isdefined("session.B2B.SNcodigo")  and len(trim(session.B2B.SNcodigo)) and session.B2B.SNcodigo neq '-1'>
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.B2B.SNcodigo#">
	</cfif>
	<cfif isdefined("Form.Ocodigo")  and len(trim(form.Ocodigo)) and form.Ocodigo neq '-1'>
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
	</cfif>			
</cfquery>

<cfif not isdefined("Form.Ocodigo") OR len(trim(form.Ocodigo)) EQ 0>
	<cfparam name="Form.Ocodigo" default="-1">
</cfif>

<cfset rsGrafico = QueryNew("Monto, Venc,Inicio,Fin")>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.SinVencer,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Sin Vencer',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','-1',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','-1',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.Hoy,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Hoy',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','0',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','0',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso01,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','1 - #Venc1#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','1',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc1#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso02,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc1+1# - #Venc2#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','#Venc1+1#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc2#',rsGrafico.RECORDCOUNT)>

<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso03,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc2+1# - #Venc3#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','#Venc2+1#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc3#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso04,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc3+1# - #Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','#Venc3+1#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.mayores,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Mas de #Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','-2',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc4#',rsGrafico.RECORDCOUNT)>

<cfif rsGrafico.recordcount>
	<cfquery name="rsValores" dbtype="query">
	  select min(monto) as minimo, max(monto) as maximo from rsGrafico 
	</cfquery>
	
	<cfset minimo = rsValores.minimo>
	<cfset maximo = rsValores.maximo>
	<table width="100%" border="0">
    
	<cfif isdefined("session.B2B.SNcodigo") and session.B2B.SNcodigo NEQ -1>
	  <tr>
		<td colspan="2">
			<cfoutput query="rsSocioDatos">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr align="center"> 
					<td class="tituloAlterno" colspan="6">#SNnombre#</td>
				  </tr>
				  <tr> 
					<td style="padding-left: 5px; font-weight: bold;">Identificaci&oacute;n: </td>
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
			</cfoutput>
		</td>
	  </tr>
	  </cfif>
	  <tr>
		<td valign="top">
			<form action="MenuCP.cfm" method="post" name="form1">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					  <td colspan="2">
						<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
						  <tr> 
							<td class="listaCorte" align="left">Vencimiento</td>
							<td class="listaCorte" align="right">Saldo</td>
						  </tr>
						  <cfloop query="rsGrafico">
							<cfoutput> 
							  <tr> 
								<td align="left" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="javascript: consultavencimiento('#trim(Inicio)#','#trim(Fin)#');">#venc#</a></td>
								<td align="right" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="javascript: consultavencimiento('#trim(Inicio)#','#trim(Fin)#');">#LSCurrencyFormat(monto,'none')#</a></td>
							  </tr>
							</cfoutput> 
						  </cfloop>
						   <tr> 
								<td colspan="2" class="listaCorte" align="left">&nbsp;</td>
						  </tr>
						</table>
					  </td>
				  </tr>
				</table>		
			<cfoutput>
			<input name="FORMATO" value="1" type="hidden">
			<cfif  isdefined("url.ANALISIS")>
				<input type="hidden" name="ANALISIS" value="#url.ANALISIS#">
			</cfif> 	
			<cfif  isdefined("url.NIVEL")>
				<input type="hidden" name="NIVEL" value="#url.NIVEL#">
			</cfif> 
			<cfif  isdefined("url.ORDER_BY")>
				<input type="hidden" name="ORDER_BY" value="#url.ORDER_BY#">
			</cfif> 
			<cfif  isdefined("url.PAGENUM_LISTA")>
				<input type="hidden" name="PAGENUM_LISTA" value="#url.PAGENUM_LISTA#">
			</cfif>			
			</cfoutput>	
			</form>
		</td>
		<td  valign="top" align="center">
			<cfchart  chartheight="200"
				format = "Jpg"
				chartWidth = "500"
				scaleFrom = "0" 
				scaleTo = "0"
				showXGridlines = "yes"
				showYGridlines = "yes"
				gridlines = "5"
				seriesPlacement = "stacked"
				showBorder = "no"
				font = "Arial"
				fontSize = "10"
				fontBold = "no"
				fontItalic = "no"
				xAxisTitle = "Vencimiento en Días"
				yAxisTitle = "Monto Vencimiento"
				sortXAxis = "no"
				show3D = "yes"
				rotated = "no"
				showLegend = "yes"
				tipStyle = "MouseOver"
				showMarkers = "yes"
				markerSize = "50"
				> 
				<cfchartseries 
					type="bar" 
					query="rsGrafico" 
					valuecolumn="monto" 
					itemcolumn="venc"
					colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
		</td>
	  </tr>
	</table>


<cfelse>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<th scope="col"> *** No se encontraron datos para realizar el Gr&aacute;fico *** </th>
	  </tr>
	</table>
</cfif>
 
<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="">
		<cfquery datasource="#Session.DSN#" name="rsget_val">
			select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
			where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = #valor#
		</cfquery>
	<cfreturn #rsget_val#>
</cffunction>

<script language="javascript" type="text/javascript">
	
	function consultavencimiento(inicio,fin){
		var PARAM  = "consultas/AntigSaldosDetCxP.cfm?SNcodigo=<cfoutput>#session.B2B.SNcodigo#</cfoutput>&Ocodigo=<cfoutput>#Form.Ocodigo#</cfoutput>&FORMATO=<cfoutput>#Form.FORMATO#</cfoutput>&inicio="+ inicio +"&fin="+ fin;
		open(PARAM,'Detalle','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}	
</script>