
<cfif isdefined("form.Exportar")>
    <cfset form.btnDownload = true>
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")>
<!--- Etiquetas de traduccion --->
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')/>
<cfset LB_Concepto = t.translate('LB_Concepto','Concepto','/rh/generales.xml')/>
<cfset LB_Salario = t.translate('LB_Salario','Salario','/rh/generales.xml')/>
<cfset LB_Costo = t.translate('LB_Costo','Costo','/rh/generales.xml')/>
<cfset LB_Moneda = t.translate('LB_Moneda','Moneda','/rh/generales.xml')/>
<cfset LB_Empresas = t.translate('LB_Empresas','Empresa','/rh/generales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')/> 


<cfset archivo = "CostosTotalesPorEmpleado(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="CostoPorFuncionario.cfm">
<cf_templatecss/>


<cfif not isDefined("Form.periodoDesde")>
	<cfset form.periodoDesde = DateFormat(Now(),'yyyy') >
</cfif>	

<cfif not isDefined("Form.mesDesde")>
	<cfset form.mesDesde = DateFormat(Now(),'mm') >
</cfif>	

<cfif not isDefined("Form.periodoHasta")>
	<cfset form.periodoHasta = DateFormat(Now(),'yyyy') >
</cfif>	

<cfif not isDefined("Form.mesHasta")>
	<cfset form.mesHasta = DateFormat(Now(),'mm') >
</cfif>	

<cfif not isDefined("Form.tipo")>
	<cfset form.tipo = 1 >
</cfif>	

<cfif not isDefined("Form.Moneda")>
	<cfset form.Moneda = "CRC" >
</cfif>	

<cfset cortes = arrayNew(1)>
<cfset desde = createDate(form.periodoDesde, form.mesDesde, 1)>
<cfset hasta = createDate(form.periodoHasta, form.mesHasta, 1)>
<cfset detallado = form.tipo eq 1>

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresas">
	select Edescripcion 
	from Empresas 
	where Ecodigo in (
				<cfif !isDefined("esCorporativo")>
                    #session.Ecodigo#
                <cfelse>    
                    <cfif form.jtreeListaItem neq 0>
                        #form.jtreeListaItem#
                    <cfelse>
                        #EmpresaLista#
                    </cfif>
                </cfif>
                )
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset filtro1 = ''>
<cfset filtro2 = '#LB_Moneda#: '&form.Moneda>
<cfset Empresas = '#LB_Empresas#: ' & valuelist(rsEmpresas.Edescripcion,', ')>

<cfset titulocentrado2 = ''>
<cfset lvarCols = 1 >

<cfif detallado>
	<cfset lvarCols += 1 >
</cfif>

<cfset showEmpresa = true>
<cfif isDefined("form.esCorporativo")>
	<cfset showEmpresa = false>
</cfif>


<!--- obtiene meses para el idioma --->
<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, ltrim(rtrim(VSvalor)) as VSvalor  
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.Idioma#')
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>

<cfset meses = arrayNew(1)>
<cfloop query="rsMeses">
	<cfset arrayAppend(meses, VSdesc)>
</cfloop>

<cfloop condition="desde LTE hasta">
    <cfset x = structNew()>
    <cfset x.m = month(desde)>
    <cfset x.y = year(desde)>
    <cfset x.total = 0>
    <cfset x.totalEmp = 0>
    <cfset arrayAppend(cortes, x)>
    <cfset desde = DateAdd("m",1,desde)>
</cfloop>

<cfset lvarCols += ArrayLen(cortes) >


<!--- se crean las columnas del subquery segun los meses --->
<cfsavecontent variable="LvarCortes">
	<cfoutput>
		<cfloop array="#cortes#" index="i">
			, sum(case when b.CPperiodo = #i.y# and b.CPmes = #i.m# then 
					case when cm.RCMregla = 1 then 
						XXXX * coalesce(h.RCtc,1) 
					when cm.RCMregla = 2 then  
						XXXX / coalesce(h.RCtc,1)  
					else XXXX end 	 
				else 0 end
			) as m#i.m#y#i.y#
		</cfloop>
	</cfoutput>
</cfsavecontent>
 

<!--- se crean los filtros de los datos segun meses --->
<cfsavecontent variable="LvarWhere">
	<cfoutput>
	(	
		1=2
		<cfloop array="#cortes#" index="i">
			or (b.CPperiodo = #i.y# and  b.CPmes =#i.m#)
		</cfloop>
	)
		and b.Ecodigo in (
						<cfif !isDefined("esCorporativo")>
				            #session.Ecodigo#
				        <cfelse>    
				            <cfif form.jtreeListaItem neq 0>
				                #form.jtreeListaItem#
				            <cfelse>
				            	#EmpresaLista#
				            </cfif>
				        </cfif>
						)
	</cfoutput>
</cfsavecontent>

<!--- se crea join para validar el tipo de regla a aplicar para conversion de moneda --->
<cfsavecontent variable="LvarRegla">
	<cfoutput>
		left join RHReglaConvMoneda cm
        	on cm.McodigoOrig = h.Mcodigo
        	and cm.McodigoDest = (select Mcodigo 
									from Monedas 
									where Ecodigo = h.Ecodigo 
									and Miso4217 =
	</cfoutput>							
</cfsavecontent>


<!--- Consulta si empresa(session) tiene indicado el Concepto de Pago para Anticipo de Salario --->
<cfquery name="rsCPagoAnticipos" datasource="#Session.DSN#">
	select convert(numeric,coalesce(Pvalor,'0')) as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 730
</cfquery> 

<!--- Obtiene el resulset con el detalle de los costos totales por funcionario --->
<cfset rsCostoFunc = getQuery() >  

<cfif rsCostoFunc.recordcount> 
	<cfif isdefined('form.periodoDesde') and isdefined('form.mesDesde') and isdefined('form.periodoHasta') and isdefined('form.mesHasta')>
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#form.mesDesde#'		
		</cfquery>

		<cfif form.mesDesde neq form.mesHasta >
			<cfquery dbtype="query" name="rs2">
				select VSdesc 
				from rsMeses 
				where VSvalor = '#form.mesHasta#'
			</cfquery>

			<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #form.periodoDesde# - #rs2.VSdesc# #form.periodoHasta#'>
			<cfset filtro1 = "#meses[form.mesDesde]# #form.periodoDesde# - #meses[form.mesHasta]# #form.periodoHasta#">
		<cfelse>
			<cfif form.periodoDesde neq form.periodoHasta >
				<cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #form.periodoDesde# - #rs1.VSdesc# #form.periodoHasta#'>
				<cfset filtro1 = "#meses[form.mesDesde]# #form.periodoDesde# - #meses[form.mesHasta]# #form.periodoHasta#">
			<cfelse>
				<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #form.periodoDesde#'>
				<cfset filtro1 = "#meses[form.mesDesde]# #form.periodoDesde#">
			</cfif>	
		</cfif>	
	</cfif>	


	<cfif lvarCols lt 6>
		<cfset lvCols = 5>
	<cfelseif lvarCols gt 10>
		<cfset lvCols = 10>	
	<cfelse>
		<cfset lvCols = lvarCols>	
	</cfif>

	<cfif isdefined("form.Exportar") or isdefined("form.Consultar")>
		
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <style>
            thead { display: table-header-group; }
            tfoot { display: table-footer-group; }
            
            @media print {
            thead { display: table-header-group; }
            tfoot { display: table-footer-group; }
            }
            @media screen {
                thead { display: none; }
                tfoot { display: none; }
            }
            table { page-break-inside:auto }
            tr { page-break-inside:avoid; page-break-after:auto }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>#LB_Corp#</title>
        </head>
        <body>
        
            <cf_HeadReport 
                addTitulo1='#LB_Corp#' 
                filtro1='#titulocentrado2# <br> #Empresas#' 
                filtro2="#filtro1#" 
                filtro3="#filtro2#"
                showEmpresa="false" 
                cols="#lvCols-2#" 
                showline="false">
            <cfoutput>#getHTML(rsCostoFunc,cortes,meses)#</cfoutput>
        </body>
		</html>
        
	</cfif>	
<cfelse>
	<cf_HeadReport 
    		addTitulo1='#LB_Corp#' 
            filtro1='#titulocentrado2#'
    		showEmpresa="false" 
            showline="false">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>		
	

<cffunction name="getQuery" returntype="query">
	<cf_dbfunction name="op_concat" returnvariable="concat">

	<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">
	<cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion " returnvariable="LvarDCdescripcion">
	<cf_translatedata name="get" tabla="TDeduccion" col="td.TDdescripcion" returnvariable="LvarTDdescripcion">
	<cf_translatedata name="get" tabla="CIncidentes" col="ci.CIdescripcion" returnvariable="LvarCIdescripcion">

	<cfquery name="rsCostoFunc" datasource="#session.dsn#">
		select <cfif detallado> x.DEid, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as empleado,<cfelse>0 as DEid,</cfif> x.tipo, x.descripcion
		<cfloop array="#cortes#" index="i">
		,x.m#i.m#y#i.y#
		</cfloop>
		from (
				<!--- se pintan  los salario segun meses --->
				select <cfif detallado>DEid,</cfif> '#LB_Salario#' as descripcion, 1 as tipo
				#replace(LvarCortes,'XXXX','a.SEsalariobruto','all')#
				from HSalarioEmpleado a
			    inner join CalendarioPagos b 
			        on a.RCNid = b.CPid
			    inner join HRCalculoNomina h
			        on a.RCNid = h.RCNid   
			        #LvarRegla# <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#"/>)
				where #preserveSingleQuotes(LvarWhere)# and b.CPtipo <> 2
					<cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
                    and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
                    </cfif>
				<cfif detallado>
					group by DEid	
				</cfif>
				
				union

				<!--- se pintan  las incidencias salario segun meses --->
				select <cfif detallado>DEid,</cfif> #LvarCIdescripcion# as descripcion, 2 as tipo
				#replace(LvarCortes,'XXXX','a.ICmontores','all')#
				from HIncidenciasCalculo a
					inner join CIncidentes ci
						on a.CIid = ci.CIid
				    inner join CalendarioPagos b 
				        on a.RCNid = b.CPid
				    inner join HRCalculoNomina h
				        on a.RCNid = h.RCNid    
				        #LvarRegla# <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#"/>)
				where #preserveSingleQuotes(LvarWhere)# and b.CPtipo <> 2
				<cfif rsCPagoAnticipos.recordCount gt 0>
					and a.CIid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPagoAnticipos.Pvalor#">
				</cfif>
                <cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
                	and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
                </cfif>
				group by <cfif detallado>DEid,</cfif> #LvarCIdescripcion#

				union

				<!--- se pintan  las cargas salario segun meses --->
				select <cfif detallado>DEid,</cfif> #LvarDCdescripcion# as descripcion, 3 as tipo
				#replace(LvarCortes,'XXXX','a.CCvalorpat','all')#
				from HCargasCalculo a
				inner join DCargas dc
					on a.DClinea = dc.DClinea
			    inner join CalendarioPagos b 
			        on a.RCNid = b.CPid
			    inner join HRCalculoNomina h
			        on a.RCNid = h.RCNid    
			        #LvarRegla# <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#"/>)
				where #preserveSingleQuotes(LvarWhere)# and a.CCvalorpat > 0 and b.CPtipo <> 2
				<cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
                	and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
                </cfif>
                group by <cfif detallado>DEid,</cfif> #LvarDCdescripcion#

				union

				<!--- se pintan  las deducciones salario segun meses --->
				select <cfif detallado>a.DEid,</cfif> #LvarTDdescripcion# as descripcion, 4 as tipo
				#replace(LvarCortes,'XXXX','a.Dvalor','all')#
				from HDeduccionesCalculo hd
				inner join DeduccionesEmpleado a
					on hd.Did = a.Did
				inner join TDeduccion td
					on a.TDid = td.TDid
			    inner join CalendarioPagos b 
			        on a.RCNid = b.CPid
			    inner join HRCalculoNomina h
			        on a.RCNid = h.RCNid    
			        #LvarRegla# <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda#"/>)
				where #preserveSingleQuotes(LvarWhere)# and b.CPtipo <> 2
                <cfif isdefined("form.LISTADEIDEMPLEADO") and len(trim(form.LISTADEIDEMPLEADO))>
                	and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LISTADEIDEMPLEADO#" list="true" />) 
                </cfif>
				group by <cfif detallado>a.DEid,</cfif> #LvarTDdescripcion#
		) x
		<cfif detallado>
		inner join DatosEmpleado de
			on x.DEid = de.DEid
		order by x.DEid, x.tipo 
		<cfelse> 
		order by x.tipo 
		</cfif>
	</cfquery>
	

	<cfreturn rsCostoFunc>
</cffunction>


<cffunction name="getHTML" output="true">
	<cfargument name="rsCostoFunc" type="query" required="true">
	<cfargument name="cortes" type="array" required="true">
	<cfargument name="meses" type="array" required="true">

	
			<cfoutput query="Arguments.rsCostoFunc" group="DEid">
				<table class="reporte" width="100%" cellpadding="0" cellspacing="0">
                 <thead style="display: table-header-group">
					<cfif detallado>
                        <tr>
                            <th colspan="#arraylen(Arguments.cortes)+ 1#" style="text-align:left"><strong>#DEidentificacion# - #empleado#</strong></th>
                            <!---<th  nowrap="nowrap"><strong></strong></th>--->
                            <!---<cfloop from="1" to="#arraylen(Arguments.cortes)#" index="i">
                                <td>&nbsp;</td>
                            </cfloop>--->	
                        </tr>
                    </cfif>	
               
                    <tr>
                         <th>#LB_Costo#</th>
						<cfif not detallado>
                            <!---<th>#LB_Codigo#</th>
                            <th>#LB_Empleado#</th>
                        <cfelse>
                            <th>#LB_Costo#</th>--->
                        </cfif>
                        <cfloop array="#Arguments.cortes#" index="i">
                            <th width="#90/ ArrayLen(Arguments.meses)#%">#Arguments.meses[i.m]# <br> #i.y#</th>
                        </cfloop>
                    </tr>
                </thead>	
                <tbody>
				<!--- se reinician los cortes por empleado para el total --->		
				<cfoutput>
					<tr>
						<!---<cfif detallado>
							<td>&nbsp;</td>
						</cfif>	--->
						<td width="10%">#mid(trim(descripcion),1,100)#</td>
						<cfloop from="1" to="#arraylen(Arguments.cortes)#" index="i">
							<cfset valor = evaluate('Arguments.rsCostoFunc.m'&Arguments.cortes[i].m&'y'&Arguments.cortes[i].y)>	
							<cfif not Len(valor)>
								<cfset valor = 0 >
							</cfif>		
							<cfset Arguments.cortes[i].totalEmp += valor>
							<cfset Arguments.cortes[i].total += valor>
							<td nowrap="nowrap" style="text-align:right"><cf_locale name="number" value="#valor#"/></td>
						</cfloop>
					</tr>
				</cfoutput>
				<cfif detallado>
					<tr>
						<td>&nbsp;</td>
						<cfloop from="1" to="#arraylen(Arguments.cortes)#" index="i">
							<td align="right">
								<strong><cf_locale name="number" value="#Arguments.cortes[i].totalEmp#"/></strong>
							</td>
							<cfset Arguments.cortes[i].totalEmp = 0>
						</cfloop>
					</tr>	
				</cfif>
                 </tbody>
				</table>	
			</cfoutput>
			<table class="reporte" width="100%" cellpadding="0" cellspacing="0">
            <tr><td colspan="#lvarCols#">&nbsp;</td></tr>
			<tr>
				<!---<td style="text-align:center" colspan="<cfif detallado>2<cfelse>1</cfif>"><strong>#LB_Total#</strong></td>--->
                <td style="text-align:center" colspan="1"><strong>#LB_Total#</strong></td>
				<cfloop from="1" to="#arraylen(Arguments.cortes)#" index="i">
					<td align="right"><strong><cf_locale name="number" value="#Arguments.cortes[i].total#"/></strong></td>
				</cfloop>
			</tr>	
            <tr><td colspan="#lvarCols#">&nbsp;</td></tr>
        </table>
</cffunction>	

 