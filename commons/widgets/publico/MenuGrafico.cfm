 <cfif not isdefined('Form.SNcodigo') OR len(trim(form.SNcodigo)) EQ 0>
	<cfset 	Form.SNcodigo = '-1'>
</cfif>
<cfif not isdefined("Form.FORMATO")>
	<cfset 	Form.FORMATO = '1'>
</cfif>

<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Fisica 	= t.Translate('LB_Fisica','Física','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Juridica 	= t.Translate('LB_Juridica','Jurídica','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Hoy = t.Translate('LB_Hoy','Hoy','/commons/widgets/publico/MenuDocumentos.xml')>


<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
	select coalesce(SNnombre,'') as SNnombre,
		   coalesce(SNidentificacion, '') as SNidentificacion,
		   coalesce(SNdireccion, 'No Tiene') as SNdireccion,
		   coalesce(SNtelefono, 'No Tiene') as SNtelefono,
		   coalesce(SNFax, 'No Tiene') as SNFax,
		   coalesce(SNemail, 'No Tiene') as SNemail,
		   (case SNtipo when 'F' then '#LB_Fisica#' when 'J' then '#LB_Juridica#' when 'E' then '#LB_Extranjero#' else '???' end) as SNtipo
	from SNegocios
	where Ecodigo =  #Session.Ecodigo#
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
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
	<cfif isdefined("Form.SNcodigo")  and len(trim(form.SNcodigo)) and form.SNcodigo neq '-1'>
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	</cfif>
	<cfif isdefined("Form.Ocodigo")  and len(trim(form.Ocodigo)) and form.Ocodigo neq '-1'>
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
	</cfif>
</cfquery>

<cfif not isdefined("Form.Ocodigo") OR len(trim(form.Ocodigo)) EQ 0>
	<cfparam name="Form.Ocodigo" default="-1">
</cfif>

<cfset LB_SinVenc = t.Translate('LB_SinVenc','Sin Vencer','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Masde = t.Translate('LB_Masde','Mas de','/commons/widgets/publico/MenuDocumentos.xml')>

<cfset rsGrafico = QueryNew("Monto, Venc,Inicio,Fin")>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.SinVencer,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#LB_SinVenc#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','-1',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','-1',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.Hoy,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#LB_Hoy#',rsGrafico.RECORDCOUNT)>
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
<cfset QuerySetCell(rsGrafico,'Venc','#LB_Masde# #Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Inicio','-2',rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Fin','#Venc4#',rsGrafico.RECORDCOUNT)>

<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_Persona 	= t.Translate('LB_Persona','Persona','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Telefono 	= t.Translate('LB_Telefono','Tel&eacute;fono','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Saldo		= t.Translate('LB_Saldo','Saldo','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Vencimiento	= t.Translate('LB_Vencimiento','Vencimiento','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_VencDias = t.Translate('LB_VencDias','Vencimiento en Días','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_MontoVenc = t.Translate('LB_MontoVenc','Monto Vencimiento','/commons/widgets/publico/MenuDocumentos.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/commons/widgets/publico/MenuDocumentos.xml')>

<cfif rsGrafico.recordcount>
	<cfquery name="rsValores" dbtype="query">
	  select min(monto) as minimo, max(monto) as maximo from rsGrafico
	</cfquery>

	<cfset minimo = rsValores.minimo>
	<cfset maximo = rsValores.maximo>
	<div>
	<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
	  <div class="row">
		<div class="col co-md-6">
			<cfoutput query="rsSocioDatos">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr align="center">
					<td class="tituloAlterno" colspan="6">#SNnombre#</td>
				  </tr>
				  <tr>
					<td style="padding-left: 5px; font-weight: bold;">#LB_Identificacion#: </td>
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
		</div>
	  </div>
	  </cfif>
	  <div class="row">
		<div class="col col-md-6">
			<form action="MenuCP-iframe.cfm" method="post" name="form1">
				<cfoutput>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfif not isdefined("LvarAnalisis")>
					  <tr>
						<td width="50%" align="left" style="padding-left: 5px; padding-right: 5px">#LB_PROVEEDOR#</td>
						<td  align="right" width="50%">
							<cfif isdefined("Form.SNcodigo")>
								<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" idquery="#Form.SNcodigo#">
							<cfelse>
								<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P">
							</cfif>
						</td>
					  </tr>
					  <tr>
						<td width="50%" align="left" style="padding-left: 5px; padding-right: 5px">#LB_Oficina#</td>
						<td  align="right" width="50%">
						<cfif Form.Ocodigo NEQ -1>
							<cf_sifoficinas id="#form.Ocodigo#">
						<cfelse>
							<cf_sifoficinas>
						</cfif>
						</td>
					  </tr>
				  </cfif>
				  <tr>
					  <td colspan="2">
						<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
						  <tr>
							<td class="listaCorte" align="left">#LB_Vencimiento#</td>
							<td class="listaCorte" align="right">#LB_Saldo#</td>
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
				</cfoutput>
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
		</div>
		<div class="col col-md-6">

			<script src="/cfmx/jquery/librerias/Highcharts/js/highcharts.js"></script>
			<script src="/cfmx/jquery/librerias/Highcharts/js/modules/data.js"></script>

			<script>
				$(function () {
					$(document).ready(function () {

					    $('#containerTable').highcharts({
					        chart: {
					            type: 'column'
					        },
					        title: {
					            text: ''
					        },
					         xAxis: {
					            type: 'category',
					             title: {
					                text: "<cfoutput>#LB_VencDias#</cfoutput>"
					            }
					        },
					        yAxis: {
					            labels: {
					            	format:'{value}'
					            }
					        },
					        data: {
					            table: 'datatable'
					        }

					    });
				    });
				});
		    </script>

		    <div id="containerTable" style="min-width:420px; height:275px; margin: 0 auto"></div>

		    <table id="datatable" style="display: none;">
		    	
		    	<thead>
			        <tr>
			            <th></th>
			            <th><cfoutput>#LB_Monto#</cfoutput></th>
			        </tr>
			    </thead>

				<cfloop query="rsGrafico">
					<cfoutput>
						<tr>
							<th>#venc#</th>
							<td>#monto#</td>
						</tr>
					</cfoutput>
				</cfloop>
			</table> 

		</div>
	  </div>
	</div>

<cfelse>
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda" >
	  <tr>
		<cfset MSG_SinDat 	= t.Translate('MSG_SinDat','No se encontraron datos para realizar el Gr&aacute;fico','/commons/widgets/publico/MenuDocumentos.xml')>
		<th scope="col"> *** #MSG_SinDat# *** </th>
	  </tr>
	</table>
	</cfoutput>
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
	function funcSNnumero(){document.form1.submit();}

	function funcOficodigo(){document.form1.submit();}

	function consultavencimiento(inicio,fin){
		var PARAM  = "/cfmx/sif/cp/consultas/AntigSaldosDetCxP.cfm?SNcodigo=<cfoutput>#Form.SNcodigo#</cfoutput>&Ocodigo=<cfoutput>#Form.Ocodigo#</cfoutput>&FORMATO=<cfoutput>#Form.FORMATO#</cfoutput>&inicio="+ inicio +"&fin="+ fin;
		open(PARAM,'Detalle','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
</script>