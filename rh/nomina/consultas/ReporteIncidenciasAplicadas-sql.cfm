


<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_Codigo_de_Calendario = t.translate('LB_Codigo_de_Calendario','Código de Calendario')/>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina')/>
<cfset LB_Desde = t.translate('LB_Desde','Desde','/rh/generales.xml')/>
<cfset LB_Hasta = t.translate('LB_Hasta','Hasta','/rh/generales.xml')/>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de Cambio','/rh/generales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_ResumenGeneral = t.translate('LB_ResumenGeneral','Resumen General')/>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')/>
<cfset LB_Valor = t.translate('LB_Valor','Valor')/>
<cfset LB_IncidenciaCod = t.translate('LB_IncidenciaCod','Cod. Incid.')/>
<cfset LB_Incidencia = t.translate('LB_Incidencia','Incidencia')/>
<cfset LB_MontoTotal = t.translate('LB_MontoTotal','Monto Total')/>
<cfset LB_Liquido = t.translate('LB_Liquido','Liquido')/>
<cfset LB_CFcodigo = t.translate('LB_CFcodigo','Código CF')/>
<cfset LB_CFdescripcion = t.translate('LB_CFdescripcion','CF. Descripción')/>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Id','/rh/generales.xml')/>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')/>
<cfset LB_FechasRango = t.translate('LB_FechasRango','Fechas del Reporte')/>
<cfset LB_TotalDevengado = t.translate('LB_TotalDevengado','Total Devengado')/>
<cfset LB_TotalCentroFuncional = t.translate('LB_TotalCentroFuncional','Total Centro Funcional')/>
<cfset LB_TotalNomina = t.translate('LB_TotalNomina','Total Nómina')/>

<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')/>

	<cf_importLibs>

<!---- mostrar los montos segun tipo de cambio de dolar en los reportes----->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2696" default="0" returnvariable="LvarMostrarColDolar">

<cf_htmlReportsHeaders title="Reporte de Nominas" filename="ReporteDeNominas.xls" irA="ReporteIncidenciasAplicadas.cfm" download="false">

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" returnvariable="LvarCEnombre" conexion="asp">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset archivo = "ReporteIncidenciasAplicadas(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">
<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset Lvar_TipoCambio = 1>
<cfset form.RCNid = 0 >
<cfset lvarCols = 7 >
<cfset lvarColsEnc = lvarCols - 2>
<!---
<cfif ndetalle eq 'det'> Detallado
	<cfset lvarCols += 4 >
	<cfset lvarColsEnc = lvarCols + 1>
</cfif>
--->
<cfset pre = ''>
<cfif isdefined("isHistorico")>
	<cfset pre = 'H'>
</cfif>

<!--- Verifica si se selecciono alguna nomina para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaNomina") and len(trim(form.ListaNomina))>
	<cfset form.RCNid = listAppend(form.RCNid, form.ListaNomina)>
</cfif>

<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, VSvalor
	from VSidioma
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery>


<!--- Obtiene el resulset con el detalle de las nominas seleccionadas --->
<cfset rsdatos = getQuery() >

<cfif rsdatos.recordcount>


	<cfsetting requesttimeout="36000">

	<cfif isdefined("ExportarExcel")>
		<cfcontent type="application/vnd.ms-excel; charset=windows-1252">
		<cfheader name="Content-Disposition" value="attachment; filename=#archivo#">
		<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_TipoDeCambio#: #Lvar_TipoCambio#</b>" cols="#lvarColsEnc#">
		<cfoutput>#ReporteHTML(rsdatos)#</cfoutput>
	<cfelse>
		<cfflush interval="512">
		<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_TipoDeCambio#: #Lvar_TipoCambio#</b>" cols="#lvarColsEnc#">
		<cfoutput>#ReporteHTML(rsdatos)#</cfoutput>
	</cfif>
<cfelse>
	<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_TipoDeCambio#: #Lvar_TipoCambio#</b>">
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>


<cffunction name="getQuery" returntype="query">

	<!--- Verifica si se selecciono alguna incidencia para aplicar al filtro de la consulta --->
<cfif isDefined("form.ListaTipoIncidencia") and len(trim(form.ListaTipoIncidencia))>
	<cfset form.CIid = listAppend(form.CIid, form.ListaTipoIncidencia)>
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
	<cfif form.ndetalle eq 'res'> <!--- en el caso que el reporte sea resumido --->
		<cfquery datasource="#session.dsn#" name="rsdatos">
			Select
				  coalesce(CFcodigo,'-') as CFcodigo, coalesce(CFdescripcion,'No Indicado') as CFdescripcion,
			      CIcodigo, CIdescripcion,  Case when coalesce(ICmontoant,0) = 0 then ' ' else 'Cálculo Retroactivo' end as TipoCalculo, sum(ICvalor) as Valor, sum(ICmontores)  as Monto
			from #pre#RCalculoNomina hrc
			    inner join   #pre#IncidenciasCalculo a
			        on hrc.RCNid = a.RCNid
			    left join CFuncional b
			        on a.CFid = b.CFid
			    inner join DatosEmpleado c
			        on a.DEid=c.DEid
			    inner join CIncidentes d
			        on  a.CIid=d.CIid
			Where  1= 1

			   <cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde))>
					and hrc.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(form.FechaDesde)#">
			    </cfif>
			    <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta))>
			  		and hrc.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(form.FechaHasta)#">
			    </cfif>

                <cfif isdefined('form.ListaTipoIncidencia') and len(trim(form.ListaTipoIncidencia)) GT 0>
					and a.CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaTipoIncidencia#" list="true">)
				</cfif>

				<cfif isdefined('form.ListaEmpleado') and len(trim(form.ListaEmpleado)) GT 0>
					and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaEmpleado#" list="true">)
				</cfif>
				<cfif isdefined("form.CFcodigo") and #form.CFcodigo# NEQ ''  >
				<cfif isdefined("form.dependencias") and #form.dependencias# NEQ ''>
					and (upper(b.CFpath) like '#ucase(vRuta)#/%' or b.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">)
					<cfelse>
						and b.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">
					</cfif>
				</cfif>
				group by coalesce(CFcodigo,'-'), coalesce(CFdescripcion,'No Indicado'),
						 CIcodigo, CIdescripcion, Case when coalesce(ICmontoant,0) = 0 then ' ' else 'Cálculo Retroactivo' end
				order by CFcodigo, CIcodigo
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsdatos">
			Select  tn.Tcodigo, tn.Tdescripcion,
			      hrc.RCdesde, hrc.RChasta,
			      coalesce(CFcodigo,'') as CFcodigo, coalesce(CFdescripcion,'No Indicado') as CFdescripcion,
			      coalesce(DEidentificacion,'') as DEidentificacion, coalesce(DEapellido1,'') as DEapellido1, Coalesce(DEapellido2,'') as DEapellido2,
			      coalesce(DEnombre,'') as Nombre,
			      d.CIcodigo, d.CIdescripcion, Case when coalesce(ICmontoant,0) = 0 then ' ' else 'Cálculo Retroactivo' end as TipoCalculo,
			      sum(ICvalor) as Valor, sum(ICmontores)  as Monto
			from #pre#RCalculoNomina hrc
			     inner join TiposNomina tn
			        on hrc.Tcodigo=tn.Tcodigo
			        and hrc.Ecodigo=tn.Ecodigo
			    inner join  #pre#IncidenciasCalculo a
			        on hrc.RCNid = a.RCNid
			    left join CFuncional b
			        on a.CFid = b.CFid
			    inner join DatosEmpleado c
			        on a.DEid=c.DEid
			    inner join CIncidentes d
			        on  a.CIid=d.CIid
			Where  1= 1

			   <cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde))>
					and hrc.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(form.FechaDesde)#">
			    </cfif>
			    <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta))>
			  		and hrc.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(form.FechaHasta)#">
			    </cfif>

                <cfif isdefined('form.ListaTipoIncidencia') and len(trim(form.ListaTipoIncidencia)) GT 0>
					and a.CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaTipoIncidencia#" list="true">)
				</cfif>

				<cfif isdefined('form.ListaEmpleado') and len(trim(form.ListaEmpleado)) GT 0>
					and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ListaEmpleado#" list="true">)
				</cfif>
				<cfif isdefined("form.CFcodigo") and #form.CFcodigo# NEQ ''  >
					<cfif  isdefined("form.dependencias") and #form.dependencias# NEQ ''>
						and (upper(b.CFpath) like '#ucase(vRuta)#/%' or b.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">)
					<cfelse>
							and b.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo#">
					</cfif>
				</cfif>
				group by tn.Tcodigo,tn.Tdescripcion, hrc.RCdesde,  hrc.RChasta, coalesce(CFcodigo,''), coalesce(CFdescripcion,'No Indicado'),
				 coalesce(DEidentificacion,''), coalesce(DEapellido1,''), Coalesce(DEapellido2,''), coalesce(DEnombre,''), d.CIcodigo,
				  d.CIdescripcion, Case when coalesce(ICmontoant,0) = 0 then ' ' else 'Cálculo Retroactivo' end
				<cfif isdefined("form.CFcodigo") and #form.CFcodigo# NEQ ''>
					,b.CFcodigo
				</cfif>
				order by tn.Tcodigo, hrc.RCdesde, b.CFcodigo, coalesce(DEidentificacion,''), d.CIcodigo
		</cfquery>
	</cfif>

	<cfreturn rsdatos>
</cffunction>

<cffunction name="ReporteHTML" output="true">
	<cfargument name="rsdatos" type="query" required="true">


	<cfif form.ndetalle eq 'res'> <!--- en el caso que el reporte sea resumido --->
		#getHTMLResumido(Arguments.rsdatos)#
	<cfelse>  <!--- en el caso que el reporte sea detallado --->
			#getHTMLDetallado(Arguments.rsdatos)#
	</cfif>
</cffunction>

<cffunction name="getHTMLResumido" output="true">
	<cfargument name="rsdatos" type="query" required="true">
     <cfset cfCodActual=''>

 	 <cfset bcolor='##fff'>
 	 <cfset bcolor2='##78B1C4'>
 	 <cfset arow=0>


     <div class = "container">
     	  <div class="row justify-content-md-center" style="background-color: #bcolor2#; color:white;">
		  	<strong> #LB_FechasRango#</strong>: #form.FechaDesde# - #form.FechaHasta#
		  </div>
		  	<div class="row justify-content-md-center" style="background-color: ##0088A6; color:white;">
		  	 <div class="col-sm-2 bg-inverse text-white">
		    <strong> #LB_CFcodigo#</strong>
		    </div>
		    <div class="col-sm-3">
		     <strong>#LB_CFdescripcion#</strong>
		    </div>
		    <div class="col-sm-1">
		     <strong>#LB_IncidenciaCod#</strong>
		    </div>
		    <div class="col col-sm-2">
		     <strong>#LB_Incidencia#</strong>
		    </div>
		    <div class="col col-sm-2 text-right">
		     <strong>#LB_Valor#</strong>
		    </div>
		    <div class="col col-sm-2 text-right">
		     <strong>#LB_MontoTotal#</strong>
		    </div>
		  </div>

     	    <cfloop query="rsDatos">
     	    	<cfif (arow%2) eq 0>
     	    	 	<cfset bcolor='##fff'>
     	    	 <cfelse>
     	    	 	<cfset bcolor='##D7DCE0'>
     	    	</cfif>
     	    	<cfset arow++>
     	    	<cfset cfPinta=false>
     	        <cfif  cfCodActual eq '' OR cfCodActual neq rsDatos.CFcodigo   >
			     	<cfset cfCodActual=rsDatos.CFcodigo>
			     	<cfset cfPinta=true>
			    </cfif>

 			 <div class="row" style="background-color: #bcolor#;">
	     		<cfif cfPinta>
		     		 <div class="col col-sm-2">
				      #CFcodigo#
				    </div>
				    <div class="col col-sm-3">
				     #CFdescripcion#
				    </div>
				<cfelse>
				    <div class="col col-sm-2">

				    </div>
				    <div class="col col-sm-3">

				    </div>
				</cfif>
			    <div class="col col-sm-1">
			     #CIcodigo#
			    </div>
			    <div class="col col-sm-2">
			     #CIdescripcion# #TipoCalculo#
			    </div>
			      <div class="col col-sm-2 text-right">
			    #LSNumberFormat(Valor,',.00')#
			    </div>
			    <div class="col col-sm-2 text-right">
			    #LSNumberFormat(Monto,',.00')#
			    </div>
		    </div>
     		</cfloop>



	</div>




</cffunction>

<cffunction name="getHTMLDetallado" output="true">
	<cfargument name="rsdatos" type="query" required="true">
     <cfset cfCodActual=''>
     <cfset eActual=''>
     <cfset totalporCentro=0>
 	 <cfset bcolor='##fff'>
 	 <cfset bcolor2='##78B1C4'>
 	 <cfset arow=0>


     <div class = "container" style="font-size: 70%;">
     	  <div class="row justify-content-md-center" style="background-color: #bcolor2#; color:white;">
		  	<strong> #LB_FechasRango#</strong>: #form.FechaDesde# - #form.FechaHasta#
		  </div>
		  	<div class="row justify-content-md-center" style="background-color: ##0088A6; color:white;">
		  	 <div class="col-sm-1 bg-inverse text-white">
		    <strong> #LB_CFcodigo#</strong>
		    </div>
		    <div class="col-sm-2">
		     <strong>#LB_CFdescripcion#</strong>
		    </div>

		     <div class="col-sm-1">
		    <strong> #LB_Identificacion#</strong>
		    </div>
		    <div class="col-sm-2">
		     <strong>#LB_Nombre#</strong>
		    </div>
		    <div class="col-sm-1">
		     <strong>#LB_IncidenciaCod#</strong>
		    </div>
		    <div class="col col-sm-2">
		     <strong>#LB_Incidencia#</strong>
		    </div>
		    <div class="col col-sm-1 text-right">
		     <strong>#LB_Valor#</strong>
		    </div>
		    <div class="col col-sm-2 text-right">
		     <strong>#LB_MontoTotal#</strong>
		    </div>
		  </div>

     	    <cfloop query="rsDatos">
     	    	<cfif (arow%2) eq 0>
     	    	 	<cfset bcolor='##fff'>
     	    	 <cfelse>
     	    	 	<cfset bcolor='##D7DCE0'>
     	    	</cfif>
     	    	<cfset arow++>
     	    	<cfset cfPinta=false>
     	        <cfif  cfCodActual eq '' OR cfCodActual neq rsDatos.CFcodigo   >
			     	<cfset cfCodActual=rsDatos.CFcodigo>
			     	<cfset cfPinta=true>
			    </cfif>
			    <cfset ePinta=false>
     	        <cfif  eActual eq '' OR eActual neq rsDatos.DEidentificacion>
			     	<cfset eActual=rsDatos.DEidentificacion>
			     	<cfset ePinta=true>
			    </cfif>
			   <cfif cfPinta and totalporCentro GT 0>
		     		  <div class="col col-sm-12 text-right" style="color:##fff; background-color:##0088A6;">
				       Total por centro:#LSNumberFormat(totalporCentro,',.00')#
				      <cfset totalporCentro=0>
				    </div>
		    	</cfif>
	    	<cfset totalporCentro+=monto>
 			 <div class="row" style="background-color: #bcolor#;">
	     		<cfif cfPinta>
		     		 <div class="col col-sm-1">
				      #CFcodigo#
				    </div>
				    <div class="col col-sm-2">
				     #CFdescripcion#
				    </div>
				<cfelse>
				    <div class="col col-sm-1">

				    </div>
				    <div class="col col-sm-2">

				    </div>
				</cfif>
				<cfif ePinta>
	     		 <div class="col col-sm-1">
			     #DEidentificacion#
			    </div>
			    <div class="col col-sm-2">
			     #DEApellido1# #DEApellido2# #Nombre#
			    </div>
				<cfelse>
				    <div class="col col-sm-1">

				    </div>
				    <div class="col col-sm-2">

				    </div>
				</cfif>

			    <div class="col col-sm-1">
			     #CIcodigo#
			    </div>
			    <div class="col col-sm-2">
			     #CIdescripcion# #TipoCalculo#
			    </div>




			    <div class="col col-sm-1 text-right">
			    #LSNumberFormat(Valor,',.00')#
			    </div>
			    <div class="col col-sm-2 text-right">
			    #LSNumberFormat(Monto,',.00')#
			    </div>
		    </div>
     		</cfloop>
		     <div class="col col-sm-12 text-right" style="color:##fff; background-color:##0088A6;">
				       Total por centro:#LSNumberFormat(totalporCentro,',.00')#
		      <cfset totalporCentro=0>
		    </div>


	</div>




</cffunction>