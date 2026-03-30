<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->

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
<cf_htmlReportsHeaders title="Reporte de Nominas" filename="ReporteDePluses.xls" irA="PlusesSalarialesEmpleado.cfm" download="true">

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
       p.RHPdescpuesto as Puesto,de.Tcodigo
from LineaTiempo lt
inner join DLineaTiempo dlt
    inner join ComponentesSalariales cs
    on dlt.CSid= cs.CSid
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
	<cfif isDefined("ListaDeIdEMpleado")>
		and de.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaDeIdEMpleado#" list="true">)
	</cfif>
	<cfif isdefined('form.radOrd') and form.radOrd EQ 1>
		order by cf.CFcodigo, NombreCompleto asc
		<cfelse>
		order by NombreCompleto asc
	</cfif>	


</cfquery>  

<cfquery datasource="#session.dsn#" name="rsCS">
	select CSid, CScodigo , CSdescripcion,  CSorden
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by CSorden
</cfquery>

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
					  			<th colspan="2">
									<strong> #CScodigo#</strong> <br/>
								    #CSdescripcion# 
								</th>						
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
			    		    	<th>#LB_Cant#</th> 
			    		    	<th>#LB_Monto#</th>
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
				    		<td nowrap="nowrap"><strong>#NombreCompleto#</strong></td>
				    		
							<td  style="text-align: left;">#Puesto#</td>
 

						 	<cfset totalCS=0>
						 			<cfloop query="rsCS">
						 				<cfset local.CSidEncontrado=false>
										<cfoutput><!--- looop en busqueda del CSid--->											
												<cfif rsDatos.CSid eq rsCS.CSid>
													<!--- PINTADO DEL DETALLE---->
												    <td style="text-align: right;"> 
											    		 #Round(rsDatos.Unidades)#
											  	    </td>
											  	    <td style="text-align: right;">
											  	    	<cfif rsDatos.Porcentaje EQ 0 or rsDatos.Porcentaje EQ 100 >
											  	    		<cfset calcMonto = rsDatos.Monto >
											  	    	<cfelse>
												  	    	<cfset calcMonto = (rsDatos.Monto * 100) / rsDatos.Porcentaje>
											  	    	</cfif>
											    		 #LSNumberFormat( calcMonto, ",9.00" )#
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
									</cfloop>						 		
						 
							<td   style="text-align: right; width:80px;">
								#LSNumberFormat( totalCS, ",9.00" )#	
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


	




     
		   
		
		  

     
 

