<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Asiento_Contable_Importadora"
Default="Exportar Asiento Contable "
returnvariable="LB_Asiento_Contable_Importadora"/> 
<cfset LvarFileName = "Exportar-Asiento-Contable#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
title="#LB_Asiento_Contable_Importadora#" 
filename="#LvarFileName#"
irA="ExportarAsientoIM.cfm">

<cfif not isdefined("form.btnDownload")>
	<cf_templatecss>
</cfif>	
<cfquery name="ERR" datasource="#session.DSN#">
		select 'CR01' as codigofijo, 
		substring(a.Cformato,17,8) as centrocosto, 
		substring(a.Cformato,6,1) + substring(a.Cformato,8,2) + substring(a.Cformato,11,2) + substring(a.Cformato,14,2) as cuenta,
		b.RCDescripcion, 
		case when (a.montores < 0) then
			a.montores * -1
		else
			a.montores
		end as 	montores,
		case when (a.montores < 0 and tipo = 'C' ) then
			'D'	
		when (a.montores < 0 and tipo = 'D') then
			'C'
		else
			tipo 
		end as 	tipo		
		from RCuentasTipo a
		inner join HRCalculoNomina b
		  on  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and b.RCNid = a.RCNid
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">	
	   order by 2,3
</cfquery>
<cfquery name="encabezado" datasource="#session.DSN#">
	select RCDescripcion  ,RCdesde  ,RChasta from HRCalculoNomina
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">	
</cfquery>
<cfoutput>
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: ##000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: ##000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: ##000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: ##000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: ##000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: ##000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: ##000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: ##000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##000000			
	}		
</style>



<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
	<cfif not isdefined("form.btnDownload")>
		<tr>
			<td  colspan="6" align="center">
				#Session.enombre#	
			</td>
		</tr>
		<tr>
			<td  colspan="6" align="center">
				#LB_Asiento_Contable_Importadora#	
			</td>
		</tr>
		<tr>
			<td  colspan="6" align="center">
				#encabezado.RCDescripcion#	
			</td>
		</tr>
		<tr>
			<td  colspan="2" align="center">
			 &nbsp;
			</td>
			<td  colspan="2" align="center">
				<cf_translate  key="LB_Del">Del</cf_translate>&nbsp;#LSDateFormat(encabezado.RCdesde, "dd/mm/yyyy")# &nbsp;<cf_translate  key="LB_al">al</cf_translate>&nbsp;#LSDateFormat(encabezado.RChasta, "dd/mm/yyyy")#
			</td>
			<td  colspan="2" align="center">
			 &nbsp;
			</td>
		</tr>
		<tr>
			<td  colspan="6" align="center">
				&nbsp;	
			</td>
		</tr>
		
		<tr bgcolor="##CCCCCC"> 
			<td  class="LTtopline" align="left" width="5%" nowrap="nowrap">
				<cf_translate  key="LB_Codigo_fijo">C&oacute;digo fijo</cf_translate>&nbsp;&nbsp;
			</td>
			<td class="LTtopline" align="left" width="20%" nowrap="nowrap">
				<cf_translate  key="LB_Centro_de_Costo">Centro de Costo</cf_translate>
			</td>
			<td class="LTtopline" align="left" width="20%" nowrap="nowrap">
				<cf_translate  key="LB_Cuenta">Cuenta</cf_translate>
			</td>
			<td class="LTtopline" align="left" width="30%" nowrap="nowrap">
				<cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>
			</td>
			<td class="LTtopline" align="right" width="20%" nowrap="nowrap">
				<cf_translate  key="LB_Monto">Monto</cf_translate>
			</td>
			<td class="RLTtopline" align="center" width="5%" nowrap="nowrap">
				<cf_translate  key="LB_Tipo">Tipo</cf_translate>
			</td>
		</tr>
	</cfif>
	<cfif ERR.recordCount GT 0>
		<cfloop query="ERR">
			<tr>
				<td <cfif not isdefined("form.btnDownload")>class="LTtopline"</cfif> align="left" width="5%">
					#ERR.codigofijo#
				</td>
				<td <cfif not isdefined("form.btnDownload")>class="LTtopline"</cfif> align="left" width="20%">
					<cfif isdefined("ERR.centrocosto") and len(trim(ERR.centrocosto))>
						#ERR.centrocosto#
					<cfelse>
						&nbsp;	
					</cfif>
				</td>
				<td <cfif not isdefined("form.btnDownload")>class="LTtopline"</cfif> align="left" width="20%">
					#ERR.cuenta#
				</td>
				<td <cfif not isdefined("form.btnDownload")>class="LTtopline"</cfif> align="left" width="30%">
					#ERR.RCDescripcion#
				</td>
				<td <cfif not isdefined("form.btnDownload")>class="LTtopline"</cfif> align="right" width="20%">
					<cfif not isdefined("form.btnDownload")>#LSNumberFormat(ERR.montores,',.00')#<cfelse>#ERR.montores#</cfif>
				</td>
				<td <cfif not isdefined("form.btnDownload")>class="RLTtopline"</cfif> align="center" width="5%">
					#ERR.tipo#
				</td>
			</tr>
		</cfloop>
	</cfif>	
	<tr>
		<td   <cfif not isdefined("form.btnDownload")>class="Completoline"bgcolor="##CCCCCC" </cfif>   colspan="6" align="center">
			<cf_translate  key="LB_FIN_DE_ARCHIVO">***** FIN DE ARCHIVO *****</cf_translate>
		</td>
	</tr>

</table>
</cfoutput>

