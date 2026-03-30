<cf_templatecss>
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.Periodo") and len(trim(url.Periodo)) and not isdefined("form.Periodo")>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes)) and not isdefined("form.Mes")>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.Cuenta") and len(trim(url.Cuenta)) and not isdefined("form.Cuenta")>
	<cfset form.Cuenta = url.Cuenta>
</cfif>
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("form.CFid")>
	<cfset form.CFid = url.CFid>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->	
</script>	
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsComponentes" datasource="#session.DSN#">
	select 	coalesce(sum(ctp.Monto),0)	as Monto,
			ctp.Periodo,
			ctp.Mes, 
			case ctp.Mes	when 1 then 'Enero' 
							when 2 then 'Febrero'
							when 3 then 'Marzo'
							when 4 then 'Abril'
							when 5 then 'Mayo'
							when 6 then 'Junio'
							when 7 then 'Julio'
							when 8 then 'Agosto'
							when 9 then 'Setiembre'
							when 10 then 'Octubre'
							when 11 then 'Noviembre'
							when 12 then 'Diciembre'
			end as MesTexto,					
			ctp.CSid,
			cmp.CScodigo,
			cmp.CSdescripcion,
			ltrim(rtrim(cmp.CScodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(cmp.CSdescripcion)) as  Componente
			
	from 	RHFormulacion fm
			inner join RHEscenarios es
				on fm.RHEid = es.RHEid
				and es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				
			inner join RHCFormulacion cfm
				on cfm.RHFid = fm.RHFid
				and cfm.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cuenta#">
			
			inner join RHCortesPeriodoF ctp
				on ctp.RHCFid = cfm.RHCFid
				and ctp.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#"> 
				and ctp.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			
			inner join ComponentesSalariales cmp
				on ctp.CSid = cmp.CSid
				and ctp.Ecodigo = cmp.Ecodigo

	where fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and fm.CFidnuevo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	group by ctp.Periodo, ctp.Mes, ctp.CSid, cmp.CScodigo,cmp.CSdescripcion				
</cfquery>
<cfset vn_total = 0>
<cfoutput>
<form name="form1" action="" method="post">	
    <table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Detalle de Componentes</strong></td>
		</tr>		
		<tr>
			<td colspan="5" align="center"><table width="100%" align="center">
				<tr>
				  <td><hr/></td>
				</tr>
			</table></td>
		</tr>
		<tr>
			<td width="1%">&nbsp;</td>
			<td width="9%" bgcolor="##CCCCCC" align="right"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">Cuenta:&nbsp;</strong></td>
			<td align="left" colspan="2" bgcolor="##CCCCCC"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">#form.Cuenta#</strong></td>
			<td width="1%">&nbsp;</td>
		</tr>
		<tr>
			<td width="1%">&nbsp;</td>
			<td bgcolor="##CCCCCC" align="right"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">Mes:&nbsp;</strong></td>
			<td align="left" colspan="2"  bgcolor="##CCCCCC"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">#rsComponentes.MesTexto#</strong></td>
			<td width="1%">&nbsp;</td>
		</tr>		
		<tr>
			<td width="1%">&nbsp;</td>
			<td bgcolor="##CCCCCC" align="right"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">Per&iacute;odo:&nbsp;</strong></td>
			<td align="left" colspan="2" bgcolor="##CCCCCC"><strong style=" font-family: Verdana, Arial, Helvetica, sans-serif; font-size:10px">#form.Periodo#</strong></td>
			<td width="1%">&nbsp;</td>
		</tr>
		<tr>
			<td width="1%">&nbsp;</td>
			<td colspan="3">
				<table width="100%" cellpadding="2" cellspacing="0">
					<cfloop query="rsComponentes">
						<cfset vn_total  = vn_total + rsComponentes.Monto>
						<tr>
							<td width="59%" bgcolor="##CDDFEB" style="border-left:1px solid black;border-right:1px solid black;border-top:1px solid black;">#rsComponentes.Componente#</td>
							<td width="41%" align="right" style="border-right:1px solid black;border-top:1px solid black;">#LSNumberFormat(rsComponentes.Monto,',9.00')#</td>
						</tr>
					</cfloop>
					<tr>
						<td  bgcolor="##99C2D6" style="border-right:1px solid black;border-left:1px solid black; border-bottom:1px solid black; border-top:1px solid black;"><strong>Total:</strong></td>
						<td  bgcolor="##99C2D6" align="right" style="border-right:1px solid black; border-bottom:1px solid black; border-top:1px solid black;"><strong>#LSNumberFormat(vn_total,',9.00')#</strong></td>
					</tr>
				</table>						
				<!-----
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="	coalesce(sum(ctp.Monto),0)	as Monto,
								ctp.Periodo,
								ctp.Mes, 	
								ctp.CSid,
								cmp.CScodigo,
								cmp.CSdescripcion"					
					tabla="RHFormulacion fm
							inner join RHCFormulacion cfm
								on cfm.RHFid = fm.RHFid
								and cfm.Ecodigo = fm.Ecodigo
								and cfm.CFformato = '#form.Cuenta#'
							
							inner join RHCortesPeriodoF ctp
								on ctp.RHCFid = cfm.RHCFid
								and ctp.Ecodigo = cfm.Ecodigo 
								and ctp.Periodo = #form.Periodo#
								and ctp.Mes = #form.Mes#
							
							inner join ComponentesSalariales cmp
								on ctp.CSid = cmp.CSid
								and ctp.Ecodigo = cmp.Ecodigo"
					keys="CSid"
					filtro="fm.Ecodigo=#Session.Ecodigo# 
							and fm.RHEid = #form.RHEid#
							group by ctp.Periodo, ctp.Mes, ctp.CSid, cmp.CScodigo,cmp.CSdescripcion"
					mostrar_filtro="false"
					filtrar_automatico="false"
					etiquetas="C&oacute;digo, Componente, Monto"
					desplegar="CScodigo, CSdescripcion, Monto"
					align="left,left,left"					
					formatos="S,S,M"
					ira=""					
					maxrows="10"
					checkboxes="n"
					showemptylistmsg="true"
					formname="form1"
					showLink="false"
					incluyeform="false"
					navegacion="RHEid=#form.RHEid#"				
				/>	
				------>		
			</td>
			<td width="1%">&nbsp;</td>		
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5" align="center"><input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();" /></td>
		</tr>
    </table>
</form>
</cfoutput>