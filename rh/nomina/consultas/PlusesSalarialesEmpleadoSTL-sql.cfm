<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->

	

<cfset local.listaEmpleado=0>

<cfif len(trim(form.DEid))>
	<cfset local.listaEmpleado = listAppend(local.listaEmpleado, form.DEid)>
</cfif>

<cfif isDefined("form.ListaDeIdEMpleado") and len(trim(form.ListaDeIdEMpleado))>
	<cfset local.listaEmpleado = listAppend(local.listaEmpleado, form.ListaDeIdEMpleado)>
</cfif>

<cfparam name="form.listaCSid" default="0">
<cfif len(trim(form.CSid))>
	<cfset form.listaCSid = listAppend(form.listaCSid, form.CSid)>
</cfif>

<cfif form.listaCSid eq 0>
	<cfthrow message="Debe indicar los componentes salariales para anualidad">
</cfif>
 
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Cedula = t.translate('LB_Cedula ','Cedula')/> 
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_Puesto = t.translate('LB_Puesto','Puesto','/rh/generales.xml')>
<cfset MSG_Salario = t.translate('MSG_Salario','Salario Base')>
<cfset LB_FechaCorte = t.translate('LB_FechaCorte','Fecha de Corte','/rh/generales.xml')/> 	
<cfset LB_Conceptos = t.translate('LB_Conceptos','Conceptos')/> 
<cfset LB_Periodo = t.translate('LB_Periodo','Periodo')/> 
<cfset LB_Total= t.translate('LB_Total','Total')/> 
<cfset LB_CF = t.translate('LB_CF','CF')/> 
<cfset LB_NoExistenRegistrosQueMostrar = t.translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar')/>
<cfset LB_Codigo = t.translate('LB_Codigo','Código')/> 
<cfset LB_Desde = t.translate('LB_Desde','Desde')/> 
<cfset LB_Hasta = t.translate('LB_Hasta','Hasta')/> 
<cfset LB_Cant = t.translate('LB_Cant','Cant')/> 
<cfset LB_Monto = t.translate('LB_Monto','Monto')/>  

<cf_importLibs>
 
<!---- mostrar los montos segun tipo de cambio de dolar en los reportes----->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar">
<cfif isdefined("ExportarExcel")>
	<cfset form.btnDownload=1>
</cfif>
<cf_htmlReportsHeaders title="Reporte de Nominas" filename="ReporteDePluses.xls" irA="PlusesSalarialesEmpleadoSTL.cfm" download="true">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" returnvariable="LvarCEnombre" conexion="asp">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery name="rsParprope" datasource="#Session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = 2506
</cfquery>
<cfset archivo = "PlusesSalarialesEmpleado(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">
<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset Lvar_TipoCambio = 1>
<cfset form.RCNid = 0 > 	
<cfset lvarCols = 7 >
<cfset lvarColsEnc = lvarCols - 2>

<!--- Verifica si se selecciono alguna nomina para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaNomina") and len(trim(form.ListaNomina))>
	<cfset form.RCNid = listAppend(form.RCNid, form.ListaNomina)>
</cfif> 
 
 

<!--- Verifica si se selecciono algun empleado para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaEmpleado") and len(trim(form.ListaEmpleado))>
	<cfset form.DEid = listAppend(form.DEid, form.ListaEmpleado)>
</cfif>
	<cfif isdefined("form.CFcodigo") and #form.CFcodigo# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>	

 <cf_dbfunction name="OP_Concat" returnvariable="concat">

<cfquery datasource="#session.dsn#" name="rsdatos">

Select dlt.CSid, lt.LTid, lt.LTdesde, lt.LThasta, de.DEid,de.DEidentificacion as Identificacion, 
       de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre   as NombreCompleto,  
       CASE   
          WHEN ta.RHTcomportam =3 THEN 'Vacaciones'
          WHEN ta.RHTcomportam=4 and ta.RHTpaga=1 THEN 'Permiso con Goce'
          WHEN ta.RHTcomportam =4 and ta.RHTpaga=0 THEN 'Permiso Sin Goce'
          WHEN ta.RHTcomportam =5  THEN 'Incapacidad'
           Else'Normal'
       END     SituacionLaboral,
       cs.CScodigo CodConcepto,
       cs.CSdescripcion DescConcepto,
       dlt.DLTunidades Unidades, 
       dlt.DLTmonto Monto,
       coalesce(lt.LTporcplaza,100) as Porcentaje,
       cs.CSorden,
       cf.CFcodigo,
       cf.CFdescripcion,
       p.RHPdescpuesto as Puesto,de.Tcodigo,
       coalesce(e.RHCcodigo,'0') as RHCcodigo
from LineaTiempo lt
inner join DLineaTiempo dlt
    inner join ComponentesSalariales cs
    on dlt.CSid= cs.CSid
    and coalesce(cs.CSRecargoFunciones,0)=0 
on  lt.LTid=dlt.LTid
     and cs.CSid=dlt.CSid
inner join DatosEmpleado de
    on lt.DEid = de.DEid
inner join RHTipoAccion ta
    on ta.RHTid =lt.RHTid
inner join RHPlazas rhp
    on lt.RHPid= rhp.RHPid
inner join RHPuestos p
	on p.RHPcodigo = rhp.RHPpuesto and p.Ecodigo = rhp.Ecodigo 
inner join CFuncional cf
    on cf.CFid= rhp.CFid

      left join RHCategoriasPuesto c
            inner join RHCategoria e
            on e.RHCid=c.RHCid
        on c.RHCPlinea=lt.RHCPlinea


where 
	lt.Ecodigo =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<cfif isdefined('form.FechaCorte') and form.FechaCorte NEQ ''>
			and <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaCorte#"> between lt.LTdesde and lt.LThasta
	</cfif>		
    <cfif isdefined("form.CFcodigo") and form.CFcodigo NEQ ''  >
		<cfif isdefined("form.dependencias") and #form.dependencias# NEQ ''>
			and (upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">)
		<cfelse>
			and cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">				
		</cfif>
	</cfif>	
	<cfif isDefined("ListaTipoNomina1")>
		and lt.Tcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ListaTipoNomina1#" list="yes">)
	</cfif>
	<cfif local.listaEmpleado neq 0>
		and de.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#local.listaEmpleado#" list="true">)
	</cfif>
	<cfif isdefined('form.radOrd') and form.radOrd EQ 1>
		order by cf.CFcodigo, NombreCompleto asc
	<cfelse>
		order by NombreCompleto asc
	</cfif>	


</cfquery>  

<cfquery datasource="#session.dsn#" name="rsCS">
	select CSid, CScodigo , CSdescripcion,  CSorden, CSsalariobase
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and coalesce(CSRecargoFunciones ,0)=0
	order by CSorden
</cfquery>


<cfquery datasource="#session.dsn#" name="rsCAnualidad">
	select max(CSorden) as CSorden
	from ComponentesSalariales
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CSid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.listaCSid#" list="true">)
		and coalesce(CSRecargoFunciones ,0)=0
		and CSorden < coalesce( (select min(CSorden) from ComponentesSalariales where CSid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.listaCSid#" list="true">) )   , 99999)
</cfquery> 




<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>


<cfif rsdatos.recordcount>	

	<cfflush interval="512">
		
    <style type="text/css">
		.SubTitulo{
				text-align: left !Important;
		}
		.reporte{
			border-collapse:collapse;
			background-color:#f1f2f3
		}
		.reporte table,.reporte td,.reporte th{
			border:1px solid #D4E0EE;
			border-collapse:collapse;
			font-family:helvetica,sans-serif;
			font-size:12px;
			color:#696969
		}
		.reporte td, .reporte th{
			padding: 0 0.5em;
		}
		.reporte thead th{
			text-align:center;
			background:#b0c8d3;
			color:#4c4c4c;
			font-size:13px!important
		}
		.reporte tr:hover td{
			background:#DDE8EE!important;
			color:#000
		}
    </style>
	<cfsavecontent variable="rsPintado">
		<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_FechaCorte#: #form.FechaCorte#</b>" cols="#lvarColsEnc#">
	
 

		<div class="row">
		  	<table class="reporte" width="100%" cellspacing="1" cellpadding="1" style="margin-left:15px;">
		  		<cfoutput>	 		
			  		<thead>
				  		<tr>
				  			<th colspan="2">Centro Funcional</th>
				  			<th colspan="3">Empleado</th>
				  			<cfloop query="rsCS" >
				  				<cfif !listFind(form.listaCSid, rsCS.CSid)>
				  					<cfif rsCS.CSsalariobase eq 1>
				  						<th nowrap="nowrap">Salario base</th>
				  					<cfelse>
				  						<th colspan="2">#CSdescripcion#</th>
				  					</cfif>
								</cfif>
								<cfif !structKeyExists(request, "tituloAnualidad") and rsCAnualidad.CSorden eq rsCS.CSorden>
							  		<th colspan="3">Anualidad</th>
									<cfset request.tituloAnualidad=true>
								</cfif>							
							</cfloop>
							<th>#LB_Total#</th>
				  		</tr>

				  		<tr>
				  			<!---- CEntro Funcional--->
						    <th>#LB_Codigo#</th>
						    <th>#LB_Nombre#</th>
						    <!--- Empleado----->
							<th>
								<strong>#LB_Cedula#</strong>
							</th> 
							<th>
								<strong>#LB_Nombre#</strong>
							</th>
						    <th>
			    		   		<strong>#LB_Puesto#</strong>
						    </th> 
						    <!--- Componentes---->
							<cfloop query="rsCS" >
								<cfif !listFind(form.listaCSid, rsCS.CSid)>
									<cfif rsCS.CSsalariobase eq 1>
										<th>#LB_Monto#</th>

									<cfelseif rsCS.CScodigo eq '03'><!---- se quema por insistencia del usuario y por el tiempo invertido--->
				    		    		<th>Porcentaje</th> 
				    		    		<th>#LB_Monto#</th>
				    		    	<cfelse>	
				    		    		<th>#LB_Cant#</th>
				    		    		<th>#LB_Monto#</th>
									</cfif>	

			    		    	</cfif>

								<cfif !structKeyExists(request, "SubtituloAnualidad") and rsCAnualidad.CSorden eq rsCS.CSorden>
							  		<th>Porcentaje</th> 
							  		<th>Cantidad</th> 
							  		<th>Monto</th> 
									<cfset request.SubtituloAnualidad=true>
								</cfif>	

							</cfloop>
							<th>#LB_Monto#</th>
						</tr>
			  		</thead>
			  	</cfoutput>	
		  		<tbody>  
		     	    <cfoutput query="rsDatos" group="DEid">
					    <tr>
							<td>#CFcodigo#</td>
							<td>#CFdescripcion#</td>
				    		<td><strong>#Identificacion#</strong></td> 
				    		<td><strong>#NombreCompleto#</strong></td>
				    		
							<td  style="text-align: left;">#Puesto#</td>
 

						 	<cfset totalCS=0>
						 			<cfloop query="rsCS">

						 				<cfif !listFind(form.listaCSid, rsCS.CSid)>					 				 	
							 				 
							 				<cfset local.CSidEncontrado=false>
											<cfoutput><!--- looop en busqueda del CSid--->											
													<cfif rsDatos.CSid eq rsCS.CSid>
														<!--- PINTADO DEL DETALLE---->
														<cfif rsCS.CSsalariobase eq 0>
														    <td style="text-align: right;"> 
												    		 #LSNumberFormat( rsDatos.Unidades,'999,999,999.99')#
													  	    </td>														
														</cfif>

												  	    <td style="text-align: right;">
												  	    	<cfif rsDatos.Porcentaje EQ 0 or rsDatos.Porcentaje EQ 100 >
												  	    		<cfset calcMonto = rsDatos.Monto >
												  	    	<cfelse>
													  	    	<cfset calcMonto = (rsDatos.Monto * 100) / rsDatos.Porcentaje>
												  	    	</cfif>
												    		 #LSNumberFormat( calcMonto,'999,999,999.99')#
												    		 <cfset totalCS+=calcMonto>
												  	    </td>  
														<cfset local.CSidEncontrado=true>
													</cfif>
											</cfoutput>

											<!--- Si el valor no se encuentra se ponen ceros--->
											<cfif !local.CSidEncontrado>
												<td style="text-align: right;">0</td>
												<td style="text-align: right;">0</td>
											</cfif>
										</cfif>

										<!---- despues de cada componente salarial se verifica si sigue el componente de anualidad segun el orden---->
										<cfif !structKeyExists(request, "DetalleAnualidad#rsDatos.DEId#") and rsCAnualidad.CSorden eq rsCS.CSorden>
											<cfset local.detalleEncontrado=false>
												
											<cfoutput><!--- looop en busqueda del CSid--->	 


												<cfif !local.detalleEncontrado and listFind(form.listaCSid, rsDatos.CSid)> 

													<!---- busca la formula para la lista de conceptos del empleado--->
	
														<cfquery datasource="#session.dsn#" name="local.rsFormula">
															select CIcalculo, d.CIid, CIcantidad,CIrango,d.CItipo,ci.Ecodigo,CIdia,CImes,CIsprango,coalesce(CIspcantidad,0) as CIspcantidad,coalesce(CImescompleto,0) as CImescompleto
															from  CIncidentesD d
																inner join ComponentesSalariales cs
																	on cs.CIid=d.CIid
																	and coalesce(cs.CSRecargoFunciones,0)=0
																inner join CIncidentes ci
																	on d.CIid=ci.CIid	
															where (CIcalculo like '%Porcentaje%' or CIcalculo like '%PORCENTAJE%' or CIcalculo like '%porcentaje%')
														 		and cs.CSid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.CSid#">
														</cfquery> 

														<cfif !len(trim(local.rsFormula.CIcalculo))>
															<cfthrow message="Los componentes salariales de anualidad No tienen configurado un Porcentaje." detail="Favor configure un porcentaje en la fórmula del concepto de pago de anualidad.">
														</cfif>

														<!----- llamado a la calculadora para obtener el porcentaje utilizados---->

														<cfset FVigencia = LSDateFormat(LSParseDateTime(form.FechaCorte), 'DD/MM/YYYY')>
														<cfset FFin = LSDateFormat(LSParseDateTime(form.FechaCorte), 'DD/MM/YYYY')>
														
														<cfset current_formulas = local.rsFormula.CIcalculo>

 

														<cfset presets_text = RH_Calculadora.get_presets(
																						fecha1_accion=CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
																					   fecha2_accion=CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
																					   CIcantidad=local.rsFormula.CIcantidad,
																					   CIrango=local.rsFormula.CIrango,
																					   CItipo=local.rsFormula.CItipo,
																					   DEid=rsDatos.DEid,
																					   CampoLlaveTC ='LTid',
																					   Ecodigo=local.rsFormula.Ecodigo,												   
																					   CIdia=local.rsFormula.CIdia,
																					   CImes=local.rsFormula.CImes,
																					   Tcodigo="", <!--- Tcodigo solo se requiere si no va RHAlinea--->
																					   calc_promedio=FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
																					   masivo='false',
																					   tabla_temporal='',
																					   calc_diasnomina=FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
																					   , Cantidad=0
																					   , Origen='' 
																					   ,CIsprango=local.rsFormula.CIsprango
																					   ,CIspcantidad=local.rsFormula.CIspcantidad
																					   ,CImescompleto=local.rsFormula.CImescompleto
																					   ,MontoIncidencia=javaCast("null", "")
																					   ,FijarVariable=javaCast("null", "")
																					   ,Conexion=javaCast("null", "")
																					   ,CIid=local.rsFormula.CIid
																					   
																						)>   
																						
														<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
														<cfset calc_error = RH_Calculadora.getCalc_error()>
														<cfif Not IsDefined("values")>
															<cfif isdefined("presets_text")>
																<cf_errorCode	code="52014" msg="@errorDat_1@ & '----' & @errorDat_2@ & '-----' & @errorDat_3@"
																				errorDat_1="#presets_text#"
																				errorDat_2="#current_formulas#"
																				errorDat_3="#calc_error#"
																>
															<cfelse>
																<cf_throw message="#calc_error#" >
															</cfif>
														</cfif>

													<!--- PINTADO DEL DETALLE---->
												    <td style="text-align: right;"> 
											    		  #LSNumberFormat(values.get('porcentaje').toString(),'999,999,999.99')#
											  	    </td>
												    <td style="text-align: right;"> 
											    		 #LSNumberFormat( rsDatos.Unidades,'999,999,999.99')#
											  	    </td>
											  	    <td style="text-align: right;">
											  	    	<cfif rsDatos.Porcentaje EQ 0 or rsDatos.Porcentaje EQ 100 >
											  	    		<cfset local.calcMonto = rsDatos.Monto >
											  	    	<cfelse>
												  	    	<cfset local.calcMonto = (rsDatos.Monto * 100) / rsDatos.Porcentaje>
											  	    	</cfif>
											    		 #LSNumberFormat(local.calcMonto,'999,999,999.99')#
											    		 <cfset totalCS+=local.calcMonto>
											  	    </td>  
													<cfset local.detalleEncontrado=true>
												</cfif>
											</cfoutput>

											<cfif !local.detalleEncontrado>
										  		<td style="text-align: right;">0.00</td>
										  		<td style="text-align: right;">0.00</td>
										  		<td style="text-align: right;">0.00</td>					
											</cfif>

											<cfset request['DetalleAnualidad#rsDatos.DEId#']=true>
										</cfif>

									</cfloop>						 		
						 
							<td   style="text-align: right; width:80px;">
								#LSNumberFormat( totalCS,'999,999,999.99' )#	
							</td> 
						</tr>
			 		</cfoutput>
		 		</tbody>
			</table>
		</div>			
		<br/>	
	 	<hr style="height: 10px;border: 0;	box-shadow: 0 10px 10px -10px ##8c8b8b inset;">

	</cfsavecontent>

	<cfif isDefined("form.BtnPDF")>
		<cfdocument overwrite="true" filename="reportePluses.pdf" format="PDF" orientation="landscape">
			<cfoutput>#rsPintado#</cfoutput>
		</cfdocument>
		<div>
			<object data="reportePluses.pdf" type="application/pdf" style="width:100%; height:100%"></object>
		</div>
		<!--- <cf_importlibs/> --->
		
		<script type="text/javascript">
			$("object").css("height",(screen.height) );
		</script> 

	<cfelse>
		<cfoutput>#rsPintado#</cfoutput>
			<!---<script type="text/javascript">
				fnImgDownload();
			</script>--->
	</cfif>

<cfelse>
	<style type="text/css">

        .table>thead>tr>th,.table>tbody>tr>th,.table>tfoot>tr>th,.table>thead>tr>td,.table>tbody>tr>td,.table>tfoot>tr>td {
		padding:1px;
		vertical-align:middle;
		}
		.table {
		 width:100%;
		 max-width:100%;
		 margin-bottom:0px;
		
		}
		.SubTitulo{
				text-align: left !Important;
		}
    </style>
	<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_FechaCorte#: #form.FechaCorte#</b>" cols="#lvarColsEnc#">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>	


	




     
		   
		
		  

     
 

