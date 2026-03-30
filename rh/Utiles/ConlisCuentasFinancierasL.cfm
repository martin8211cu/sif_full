<!--- Tag de Cuentas --->
<cfparam name="url.Ecodigo">
<cfparam name="url.Cmayor">
<cfparam name="url.CPVfecha">


<cfif isdefined("url.Reporte")>
	<cfcontent type="application/vnd.ms-excel">
	<cfheader name="Content-Disposition" value="attachment; filename=PlanCuentas_#url.Cmayor#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html	xmlns:o="urn:schemas-microsoft-com:office:office" 
		xmlns:x="urn:schemas-microsoft-com:office:excel"
		xmlns="http://www.w3.org/TR/REC-html40">
<head>
<title><cf_translate  key="LB_ListaDeCuentasFinancieras">Listado del Plan de Cuentas Financieras</cf_translate></title>
<cfif not isdefined("url.Reporte")>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cf_templatecss>
</cfif>
<cfquery name="rsMayor" datasource="#Session.DSN#">
	select 	m.Ecodigo, m.Cmayor, m.Cdescripcion, v.PCEMid, v.CPVformatoF as Cmascara, m.Ctipo,
			ms.PCEMplanCtas, ms.PCEMformato as PCEMformatoF, ms.PCEMformatoC, ms.PCEMformatoP
	  from CtasMayor m
		inner join CPVigencia v
			left outer join PCEMascaras ms
				 ON ms.PCEMid = v.PCEMid
			 on v.Ecodigo = m.Ecodigo
			and v.Cmayor  = m.Cmayor
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(LSparseDateTime(url.CPVfecha),'YYYYMM')#">
					between CPVdesdeAnoMes and coalesce(CPVhastaAnoMes,600000)
	 where m.Ecodigo=#url.Ecodigo# 
	   and m.Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#url.Cmayor#">
</cfquery>
<cfif rsMayor.PCEMid EQ "" OR rsMayor.PCEMplanCtas NEQ 1>
	<cfthrow message="La cuenta #url.Cmayor# no tiene plan de cuentas">
</cfif>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Oficodigo
	  from Oficinas
	 where Ecodigo = #rsMayor.Ecodigo#
	 order by Oficodigo
</cfquery>
</head>

<cfoutput>
<body>
	<cfquery name="rsNiveles" datasource="#Session.DSN#">
		select PCNid, PCEcatid, PCNlongitud, coalesce(PCNdep,0) as PCNdep, PCNdescripcion
		  from PCNivelMascara
		 where PCEMid = #rsMayor.PCEMid#
		 order by PCNid
	</cfquery>

	<table border="0" width="100%">
		<tr>
			<cfif not isdefined("url.Reporte")>
			<td>
				<strong style="font-size:18px">
				Estructura de la Máscara para la Cuenta #url.Cmayor#
				</strong>
			<cfelse>
			<td colspan="10">
				<strong style="font-size:24px">
				Detalle del Plan de Cuenta #url.Cmayor#
				</strong>
			</td></cfif>
			
		</tr>
	</table>
	<table border="0">
		<tr>
			<td style="border:solid 1px ##CCCCCC;" colspan="#rsNiveles.recordCount+2#" align="center"><strong>Formatos, Catálogos y Valores</strong></td>
			<td style="border:solid 1px ##CCCCCC;" rowspan="2" colspan="2"><strong>Descripción</strong></td>
		<cfif isdefined("url.Reporte")>
			<td style="border:solid 1px ##CCCCCC;" colspan="#rsOficinas.recordCount+1#" align="center"><strong>Oficinas</strong></td>
		</cfif>
		</tr>

		<tr>
			<td style="border:solid 1px ##CCCCCC;"><strong>Mayor</strong></td>
		<cfloop query="rsNiveles">
			<td align="center" style="border:solid 1px ##CCCCCC;" <cfif rsNiveles.currentRow EQ rsNiveles.recordCount>colspan="2"</cfif> nowrap><strong>Nivel #rsNiveles.currentRow#</strong></td>
		</cfloop>
		<cfif isdefined("url.Reporte")>
			<td style="border:solid 1px ##CCCCCC;"><strong>TODAS</strong></td>
			<cfloop query="rsOficinas">
				<td style="border:solid 1px ##CCCCCC;" x:str align="center"><strong>#rsOficinas.Oficodigo#</strong></td>
			</cfloop>
		</cfif>
	<cfset LvarPCEcatids		= arraynew(1)>
	<cfset LvarPCNdeps			= arraynew(1)>
	<cfset LvarHijos			= arraynew(1)>
	<cfset LvarMascara 			= listtoarray(rsMayor.Cmascara,"-")>
	<cfset LvarMascaraN 		= arrayLen(LvarMascara)>
		</tr>

		<tr>
			<td align="center"><strong>XXXX</strong></td>
			<td colspan="#LvarMascaraN#">&nbsp;</td>
			<td>Cuenta Mayor</td>
			<td>&nbsp;</td>
		</tr>
	<cfloop query="rsNiveles">
		<cfset i=rsNiveles.currentRow>
		<cfset m=rsNiveles.currentRow + 1>
		<cfset LvarPCEcatids[i]		= rsNiveles.PCEcatid>
		<cfset LvarPCNdeps[i]		= rsNiveles.PCNdep>
		<cfset LvarHijos[i]			= 0>
		<tr>
			<td colspan="#i#">&nbsp;</td>
			<td  align="center"><strong>#LvarMascara[m]#</strong></td>
			<td colspan="#LvarMascaraN-i#">&nbsp;</td>
			<td nowrap>#rsNiveles.PCNdescripcion#</td>
			<td>&nbsp;</td>
		</tr>
	</cfloop>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td x:str><strong>#url.Cmayor#</strong></td>
			<td colspan="#LvarMascaraN-1#">&nbsp;</td>
			<td width="1">.</td>
			<td x:str><strong>#rsMayor.Cdescripcion#</strong></td>
			<td>&nbsp;</td>
		</tr>

	<cfif not isdefined("url.Reporte")>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		<cfloop query="rsNiveles">
			<td align="center">
				<input type="checkbox" id="chkNivel#rsNiveles.currentRow#" name="chkNivel#rsNiveles.currentRow#" checked="checked">
			</td>
		</cfloop>
			<td>&nbsp;</td>
			<td nowrap>(Indique los niveles a detallar sus Valores)</td>
			<td>&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td colspan="5"><cfset fnCboOficina()></td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>		
		<tr>
			<td colspan="#LvarMascaraN+2#" align="center">
				<input type="button" name="btnReporte" value="Detalle del Plan de Cuenta" onClick="sbEjecutar();">
			</td>
		</tr>
	</table>
	<script language="javascript">
		function sbEjecutar()
		{		
			var cboOficina = document.getElementById("Ocodigo")
			LvarValOficina = cboOficina.options[cboOficina.selectedIndex].value
				LvarParam = "ConlisCuentasFinancierasL.cfm?Ecodigo=#URLEncodedFormat(url.Ecodigo)#&Cmayor=#URLEncodedFormat(url.Cmayor)#&CPVfecha=#URLEncodedFormat(url.CPVfecha)#&Reporte&Ocodigo="+LvarValOficina;
		<cfloop query="rsNiveles">
			if (document.getElementById("chkNivel#rsNiveles.currentRow#").checked)
			{
				LvarParam += "&chkNivel#rsNiveles.currentRow#";
			}
		</cfloop>			
			location.href = LvarParam;
		}
	</script>
	</body>
</html>
<cfabort>
	</cfif>
		
	<CFSCRIPT>
		for (i=1; i LTE LvarMascaraN-2; i = i+1)
		{
			if (LvarPCEcatids[i] NEQ "")
			{
				k = i;
				m = "";
				for (j=i+1; j LTE LvarMascaraN-1; j=j+1)
				{
					if (LvarPCNdeps[j] EQ k)
					{
						m = m & "," & j;
						k = j;
					}
				}
				if (m NEQ "")
				{
					LvarHijos[i] = mid(m,2,100);
				}
			}
		}
	</CFSCRIPT>

	<cfloop index="i" from="1" to="#LvarMascaraN-1#">
		<cfif LvarPCEcatids[i] NEQ "">
		<tr><td>&nbsp;</td></tr>
			<cfset sbImprimeCatalogo(i, LvarPCEcatids[i], LvarHijos[i])>
		</cfif>
	</cfloop>
		<tr><td colspan="10">**** FIN DE REPORTE ****</td></tr>
		</table>
	</body>
</html>
</cfoutput>

<cffunction name="sbImprimeCatalogo" output="true">
	<cfargument name="Nivel"	type="numeric"	required="yes">
	<cfargument name="PCEcatid"	type="numeric"	required="yes">
	<cfargument name="Hijos"	type="string"	required="yes">
	<cfargument name="OfisIdx"	type="string"	required="no" default="0">

	<cfset var rsCat = queryNew("X")>
	<cfset var rsDet = queryNew("X")>
	<cfset var rsOfi = queryNew("X")>
	<cfset var LvarConOficina	= false>

	<cfif not isdefined("chkNivel#Arguments.Nivel#")>
		<cfreturn>
	</cfif>

	<cfquery name="rsCat" datasource="#Session.DSN#">
		select PCEcodigo, PCEdescripcion, PCEempresa, PCEoficina, PCEvaloresxmayor
		  from PCECatalogo
		 where PCEcatid = #Arguments.PCEcatid#
	</cfquery>
	<tr>
		<td colspan="#Arguments.Nivel#">&nbsp;</td>
		<td nowrap x:str><strong>#rsCat.PCEcodigo#</strong></td>
		<td colspan="#LvarMascaraN-Arguments.Nivel#">&nbsp;</td>
		<td nowrap x:str><strong>#rsCat.PCEdescripcion#</strong></td>
		<td>&nbsp;</td>
	</tr>
	<cfif rsCat.PCEempresa EQ 1>
		
		<cfquery name="rsDet" datasource="#Session.DSN#">
			select d.PCDcatid, d.PCDvalor, d.PCDdescripcion, coalesce(m.PCEcatidref, d.PCEcatidref) as PCEcatidref
			  from PCDCatalogo d
				left join PCDCatalogoRefMayor m
					 on m.PCDcatid	= d.PCDcatid
					and m.Ecodigo	= d.Ecodigo
					and m.Cmayor	= '#url.Cmayor#'
				
				<cfif isdefined("url.Ocodigo") and url.Ocodigo neq "" and url.Ocodigo neq -1 and rsCat.PCEoficina eq 1>
				
					inner join PCDCatalogoValOficina p
						 on p.PCDcatid	= d.PCDcatid
						and p.Ecodigo	= d.Ecodigo
						and p.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
						
				</cfif>
					
			   <cfif rsCat.PCEvaloresxmayor EQ 1>
			   	
					inner join PCDCatalogoPorMayor cxm
						 on cxm.Ecodigo	 = #session.ecodigo#
						and cxm.PCEcatid = d.PCEcatid
						and cxm.PCDcatid = d.PCDcatid
						and cxm.Cmayor   = '#url.Cmayor#'
				
			   </cfif>
					
			 where d.PCEcatid	= #Arguments.PCEcatid#
			   and d.Ecodigo	= #url.Ecodigo#
			   and d.PCDactivo	= 1			   
			order by d.PCDvalor
		</cfquery>
		<cfset ListaValoresCat = valuelist(rsDet.PCDcatid,",")>
		
		<cfset LvarConOficina = rsCat.PCEoficina EQ 1>
		<cfif LvarConOficina>
			<cfquery name="rsOfi" datasource="#Session.DSN#">
				select d.PCDvalor, o.Oficodigo, coalesce(x.PCDcatid,0) as X
				  from PCDCatalogo d
				  	inner join Oficinas o
						 on o.Ecodigo = d.Ecodigo					
					left join PCDCatalogoValOficina x
						 on x.PCDcatid	= d.PCDcatid
						and x.Ecodigo	= d.Ecodigo
						and x.Ocodigo	= o.Ocodigo					
				 where d.PCEcatid	= #Arguments.PCEcatid#
				   and d.Ecodigo	= #url.Ecodigo#
				   and d.PCDactivo	= 1		
				   <cfif (isdefined("url.Ocodigo") and url.Ocodigo neq "" and url.Ocodigo neq -1 and ListaValoresCat neq "")
				      or (isdefined("rsCat.PCEvaloresxmayor") and rsCat.PCEvaloresxmayor eq 1 and ListaValoresCat neq "")>
					   and d.PCDcatid in (#ListaValoresCat#)
				   </cfif>  
				order by d.PCDvalor, o.Oficodigo
			</cfquery>
		</cfif>		
	<cfelse>
		
		<cfset LvarConOficina = false>
		<cfquery name="rsDet" datasource="#Session.DSN#">
			select d.PCDvalor, d.PCDdescripcion, d.PCEcatidref
			  from PCDCatalogo d
			 where d.PCEcatid	= #Arguments.PCEcatid#
			   and d.Ecodigo	is null
			   and d.PCDactivo	= 1
			order by d.PCDvalor
		</cfquery>
		
	</cfif>

	<!--- <cfset LvarOfisIdx = 0> --->
	<cfset LvarOfisIdx = Arguments.OfisIdx>
	<cfset PrimerValor = rsDet.PCDvalor>
	<cfloop query="rsDet">
	
		<cfif PrimerValor eq rsDet.PCDvalor>
			<cfset LvarOfisIdx = 0>
		<cfelse>
			<cfif isdefined("ListaNiveles")>
				<cfset ArrayNiveles = Listtoarray(ListaNiveles,",")>
				<cfloop from="1" to="#ArrayLen(ArrayNiveles)#" step="1" index="ind">
					<cfset ValNiveles = Listtoarray(ArrayNiveles[ind],"-")>
					<cfif ValNiveles[1] eq Arguments.Nivel>
						<cfset LvarOfisIdx = ValNiveles[2]>
					</cfif>
				</cfloop>
			</cfif>
		</cfif> 
	
		<tr>
			<td colspan="#Arguments.Nivel#">&nbsp;</td>
			<td nowrap x:str>#rsDet.PCDvalor#</td>
			<td colspan="#LvarMascaraN-Arguments.Nivel#">&nbsp;</td>
			<td nowrap x:str>#rsDet.PCDdescripcion#</td>
			<td>&nbsp;</td>
			<cfif NOT LvarConOficina>
				<td align="center"><strong>X</strong></td>
			<cfelse>
				<td>Sólo en:</td>
				<cfloop index="i" from="1" to="#rsOficinas.recordCount#">
					<cfset LvarOfisIdx = LvarOfisIdx + 1>
					<cfif rsOfi.X[LvarOfisIdx] EQ 0>
						<td></td>
					<cfelse>
						<td align="center">X</td>
					</cfif>
				</cfloop>
			</cfif>
		</tr>
		
		<cfif Arguments.Hijos NEQ 0 and Arguments.Hijos NEQ "">
			<cfif rsDet.PCEcatidref EQ "">
			
				<cfset ListaNiveles = fnMantieneCSC(Arguments.Nivel,LvarNivel,LvarOfisIdx)>		
			
			<cfelse>
				<cfset LvarNivel = listGetAt(Arguments.Hijos, 1)>
				<cfset ListaNiveles = fnMantieneCSC(Arguments.Nivel,LvarNivel,LvarOfisIdx)> 
				<!--- 
				<cfif not isdefined("ListaNiveles")>
					<cfset ListaNiveles = Arguments.Nivel & "-" & LvarOfisIdx>					
				<cfelse>
					<cfset LvarTemp = listtoarray(ListaNiveles,",")>
					<cfset ListaNivelesTemp = "">	
					<cfloop from="1" to="#arraylen(LvarTemp)#" step="1" index="ind">
						<cfset Lvalores = listtoarray(LvarTemp[ind],"-")>
						<cfif Lvalores[1] eq Arguments.Nivel>
							<cfif ListaNivelesTemp eq "">
								<cfset ListaNivelesTemp = Arguments.Nivel & "-" & LvarOfisIdx>	
							<cfelse>
								<cfset ListaNivelesTemp = ListaNivelesTemp & "," & LvarNivel & "-" & LvarOfisIdx>	
							</cfif>
						<cfelse>
							<cfif ListaNivelesTemp eq "">
								<cfset ListaNivelesTemp = Lvalores[1] & "-" & Lvalores[2]>	
							<cfelse>
								<cfset ListaNivelesTemp = ListaNivelesTemp & "," &  Lvalores[1] & "-" & Lvalores[2]>	
							</cfif>	
						</cfif>
					</cfloop>
					<cfset ListaNiveles = ListaNivelesTemp>
					
				</cfif>--->
				
				<cfset sbImprimeCatalogo(LvarNivel, rsDet.PCEcatidref, listDeleteAt(Arguments.Hijos, 1), LvarOfisIdx)>				
			</cfif>		
		<cfelse>
			
			<cfset ListaNiveles = fnMantieneCSC(Arguments.Nivel,LvarNivel,LvarOfisIdx)>
							<!---	
			<cfif not isdefined("ListaNiveles")>
				<cfset ListaNiveles = Arguments.Nivel & "-" & LvarOfisIdx>					
			<cfelse>
				<cfset LvarTemp = listtoarray(ListaNiveles,",")>
				<cfset ListaNivelesTemp = "">	
				<cfloop from="1" to="#arraylen(LvarTemp)#" step="1" index="ind">
					<cfset Lvalores = listtoarray(LvarTemp[ind],"-")>
					<cfif Lvalores[1] eq Arguments.Nivel>
						<cfif ListaNivelesTemp eq "">
							<cfset ListaNivelesTemp = Arguments.Nivel & "-" & LvarOfisIdx>	
						<cfelse>
							<cfset ListaNivelesTemp = ListaNivelesTemp & "," & LvarNivel & "-" & LvarOfisIdx>	
						</cfif>
					<cfelse>
						<cfif ListaNivelesTemp eq "">
							<cfset ListaNivelesTemp = Lvalores[1] & "-" & Lvalores[2]>	
						<cfelse>
							<cfset ListaNivelesTemp = ListaNivelesTemp & "," &  Lvalores[1] & "-" & Lvalores[2]>	
						</cfif>	
					</cfif>
				</cfloop>
				<cfset ListaNiveles = ListaNivelesTemp>				
				
			</cfif>		--->	
		
		</cfif>			
	</cfloop>
</cffunction>

<cffunction name="fnMantieneCSC" output="true" returntype="string">
	<cfargument name="Nivel"	type="numeric"	required="yes">
	<cfargument name="LvarNivel"	type="numeric"	required="yes">	
	<cfargument name="LvarOfisIdx" type="numeric"	required="yes">	
	
	<cfset LvarNivel = Arguments.LvarNivel>
	<cfset LvarOfisIdx = Arguments.LvarOfisIdx>
		
	<cfif not isdefined("ListaNiveles")>
		<cfset ListaNiveles = Arguments.Nivel & "-" & LvarOfisIdx>					
	<cfelse>
		<cfset LvarTemp = listtoarray(ListaNiveles,",")>
		<cfset ListaNivelesTemp = "">	
		<cfloop from="1" to="#arraylen(LvarTemp)#" step="1" index="ind">
			<cfset Lvalores = listtoarray(LvarTemp[ind],"-")>
			<cfif Lvalores[1] eq Arguments.Nivel>
				<cfif ListaNivelesTemp eq "">
					<cfset ListaNivelesTemp = Arguments.Nivel & "-" & LvarOfisIdx>	
				<cfelse>
					<cfset ListaNivelesTemp = ListaNivelesTemp & "," & LvarNivel & "-" & LvarOfisIdx>	
				</cfif>
			<cfelse>
				<cfif ListaNivelesTemp eq "">
					<cfset ListaNivelesTemp = Lvalores[1] & "-" & Lvalores[2]>	
				<cfelse>
					<cfset ListaNivelesTemp = ListaNivelesTemp & "," &  Lvalores[1] & "-" & Lvalores[2]>	
				</cfif>	
			</cfif>
		</cfloop>
		<cfset ListaNiveles = ListaNivelesTemp>

	</cfif>	
	<cfreturn ListaNiveles>
</cffunction>

<cffunction name="fnCboOficina" output="true">

	<cf_translate  key="LB_Oficina">Oficina</cf_translate>:
	<cfquery name="rsOficinas" datasource="#session.DSN#">
		select Ocodigo, Oficodigo, Odescripcion
	    from Oficinas
		where Ecodigo = #session.Ecodigo#
		order by Odescripcion
	</cfquery>
	<select name="Ocodigo" id="Ocodigo">		 
		<option value="-1">(Todas las Oficinas)</option>		
		<cfloop query="rsOficinas">
			<option value="#rsOficinas.Ocodigo#" <cfif isdefined("url.Ocodigo") AND url.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#Odescripcion#</option>
		</cfloop>
	</select>
</cffunction>