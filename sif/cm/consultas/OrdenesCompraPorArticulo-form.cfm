<cfset idArticulo1  = "">
<cfset idArticulo2  = "">
<cfset codArt1  = "">
<cfset codArt2  = "">
<cfset fecha1 = "">
<cfset fecha2 = "">
<cfset Param  = "">
<cfset maxRows = 40>
<cfset contDetalle = 0>     
<cfset TRM  = "">
<cfset group = "">

<cfif isdefined('url.IDArt1') and len(trim(#url.IDArt1#))>
     <cfset form.IDArt1 = url.IDArt1>
</cfif>
<cfif isdefined('url.IDArt2') and len(trim(#url.IDArt2#))>
    <cfset form.IDArt2 = url.IDArt2>
</cfif>

<cfif isdefined('url.ACcodigo1') and len(trim(#url.ACcodigo1#))>
     <cfset form.ACcodigo1 = url.ACcodigo1>
</cfif>
<cfif isdefined('url.ACcodigo2') and len(trim(#url.ACcodigo2#))>
    <cfset form.ACcodigo2 = url.ACcodigo2>
</cfif>

<cfif isdefined('url.Cid') and len(trim(#url.Cid#))>
     <cfset form.Cid = url.Cid>
</cfif>
<cfif isdefined('url.Cid2') and len(trim(#url.Cid2#))>
    <cfset form.Cid2 = url.Cid2>
</cfif>

<cfif isdefined('url.CodigoArt1') and len(trim(#url.CodigoArt1#))>
     <cfset form.codigoArticulo1 = url.CodigoArt1>
</cfif>
<cfif isdefined('url.CodigoArt2') and len(trim(#url.CodigoArt2#))>
    <cfset form.codigoArticulo2 = url.CodigoArt2>
</cfif>

<cfif isdefined('url.EstadOrden') and len(trim(#url.EstadOrden#))>
    <cfset form.EstadOrden = url.EstadOrden>
</cfif>

<cfif isdefined("url.TRM") and len(trim(#url.TRM#))>
	<cfset form.TRM = url.TRM>
</cfif>

<!--- Definiciòn de numeros de órdenes de compra--->

<cfif isdefined('form.TRM') and len(trim(#form.TRM#))>
	<cfset TRM  = form.TRM>
   <cfset Param = Param & "&TRM="&#form.TRM#> 
</cfif>

<!---<cf_dump var="#TRM#">--->

<cfif isdefined('form.codigoArticulo1') and len(trim(#form.codigoArticulo1#))>
	<cfset codArt1  = form.codigoArticulo1>
   <cfset Param = Param & "&CodigoArt1="&#form.codigoArticulo1#> 
</cfif>
<cfif isdefined('form.codigoArticulo2') and len(#form.codigoArticulo2#)>
	<cfset codArt2  = form.codigoArticulo2>
   <cfset Param = Param & "&CodigoArt2="&#form.codigoArticulo2#> 
</cfif>

<cfif isdefined('form.IDArt1') and len(trim(#form.IDArt1#))>
	<cfset idArticulo1  = form.IDArt1>
   <cfset Param = Param & "&IDArt1="&#form.IDArt1#> 
</cfif>
<cfif isdefined('form.IDArt2') and len(#form.IDArt2#)>
	<cfset idArticulo2  = form.IDArt2>
   <cfset Param = Param & "&IDArt2="&#form.IDArt2#> 
</cfif>

<cfif isdefined('form.ACcodigo') and len(trim(#form.ACcodigo#))>
	<cfset ACcodigo  = form.ACcodigo>
   <cfset Param = Param & "&ACcodigo="&#form.ACcodigo#> 
</cfif>
<cfif isdefined('form.ACcodigo2') and len(#form.ACcodigo2#)>
	<cfset ACcodigo2  = form.ACcodigo2>
   <cfset Param = Param & "&ACcodigo2="&#form.ACcodigo2#> 
</cfif>

<cfif isdefined('form.Cid') and len(trim(#form.Cid#))>
	<cfset Cid  = form.Cid>
   <cfset Param = Param & "&Cid="&#form.Cid#>
<cfelse>
	<cfset Cid  = "">   
</cfif>
<cfif isdefined('form.Cid2') and len(#form.Cid2#)>
	<cfset Cid2  = form.Cid2>
   <cfset Param = Param & "&Cid2="&#form.Cid2#>
<cfelse>
	<cfset Cid2  = "">
</cfif>

<cfif isdefined('url.EstadOrden')  and len(trim(#url.EstadOrden#))>
    <cfset form.EstadOrden = #url.EstadOrden#>
	<cfset Param = Param & "&EstadOrden="&#form.EstadOrden#> 
</cfif>

<cfif isdefined('url.FechaInicial')  and len(trim(#url.FechaInicial#))>
    <cfset form.FechaInicial = #url.FechaInicial#>
	<cfset Param = Param & "&FechaInicial="&#form.FechaInicial#> 
</cfif>

<cfif isdefined('url.FechaFinal')  and len(trim(#url.FechaFinal#))>
    <cfset form.FechaFinal = #url.FechaFinal#>
	<cfset Param = Param & "&FechaFinal="&#form.FechaFinal#> 
</cfif>

<!--- Definición de forms --->
<cfif isdefined('form.EstadOrden') >
    <cfset Param = Param & "&EstadOrden="&#form.EstadOrden#> 
</cfif>

<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) >
	<cfset fecha1 = form.FechaInicial>
	<cfset form.FechaInicial = lsparseDateTime(form.FechaInicial) >
<cfelse>
	<cfset form.FechaInicial = createdate(1900, 01, 01) >
</cfif>
<cfset Param = Param & "&FechaInicial="&#fecha1#> 

<cfif isdefined("form.FechaFinal")  and len(trim(form.FechaFinal)) >
	<cfset fecha2 = form.FechaFinal>
	<cfset form.FechaFinal = lsparseDateTime(form.FechaFinal) >
<cfelse>
	<cfset form.FechaFinal = createdate(6100, 01, 01) >
</cfif>
<cfset Param = Param & "&FechaFinal="&#fecha2#> 
 
<!---<cfdump var="#Form#">--->
 
<cfif  isdefined("Url.imprimir")>
    <div style="width:1000px">
    &nbsp;
    </div>
<cfelse>
    <cf_templatecss>
    <cfif not  isdefined("form.toExcel")>
        <cf_templatecss>
        <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
          <tr align="left"> 
            <td><a href="/cfmx/sif/">SIF</a></td>
            <td>|</td>
            <td nowrap><a href="../MenuCM.cfm">Compras</a></td>
            <td>|</td>
            <td width="100%"><a href="../consultas/OrdenesCompraPorArticulo.cfm">Regresar</a></td>
          </tr>
        </table>
   	<cfelse>
    	<cfset oldlocale = SetLocale("French (Canadian)")>  
    </cfif>
</cfif> 
 
<cfif #TRM# EQ "1">
	<cfset group = "CodigoAR">
<cfelseif #TRM# EQ "2">
	<cfset group = "DescripcionConcepto">
<cfelse>
	<cfset group = "Categoria">     		       		
</cfif>
 
<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	Select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsDatos" datasource="#session.dsn#">
    Select 
        EOC.EOnumero As NumeroOrdenEOC,                         	<!-----Numero de orden de compra--->
        Case EOC.EOestado
            When -10 Then 'Pendiente de Aprobacion'
            When -8 Then 'Orden Rechazada'
            When -7 Then 'Requiere Reasignación'
            When 0 Then 'Pendiente'
            When 5 Then 'Pendiente Vía Proceso'
            When 7 Then 'Pendiente OC Directa'
            When 8 Then 'Pendiente Vía Contrato'
            When 9 Then 'Autorizada por jefe Compras'
            When 10 Then 'Aplicada'
            When 55 Then 'Orden Cancelada Parcialmente Surtida'
            When 60 Then 'Orden Cancelada'
            When 70 Then 'Orden Anulada'
            When 101 Then 'Aprobado Mutiperiodo'
            Else 'No tiene'
        End
        As Estado,                                              	<!-----Estado de la OC--->
        SNOC.SNnombre As Proveedor,                             	<!-----Nombre Proveedor--->
        EOC.EOfecha As FechaOC,                                	 	<!-----Fecha OC--->
        MOC.Mnombre As Moneda,                                  	<!-----Moneda     --->
        DOC.DOpreciou As CostoUnitario, 							<!-----Costo Unitario--->
        DOC.DOcantidad As Pedido,                               	<!-----Pedido--->
        DOC.DOcantidad * DOC.DOpreciou As CostoPedido,          	<!-----Costo Pedido--->
        DOC.DOcantsurtida As Surtido,                           	<!-----Surtido--->
        DOC.DOcantsurtida * DOC.DOpreciou As CostoSurtido,      	<!-----Costo Surtido          --->   
        DOC.DOtotal * (IDOC.Iporcentaje / 100) As MontoImpuesto, 	<!-----Monto Impuesto--->
        
        <cfif #TRM# EQ "1">
            AR.Acodigo As CodigoAR,                                	<!--- --Código del árticulo--->
            AR.Adescripcion As DescripcionAR,                      	<!-----Descripción del árticulo--->
       	<cfelseif #TRM# EQ "2">
        	CO.Cdescripcion As DescripcionConcepto, 				<!-----Descripcion del Concepto--->
   	 		CCO.CCdescripcion As Clasificacion,						<!-----Clasificacion del Concepto--->
            CCO.CCpath,												<!-----Nivel--->
        <cfelse>	
			AC.ACdescripcion As Categoria, 							<!-----Categoria del Activo--->
			ACC.ACdescripcion As Clasificacion,						<!-----Clasificación del Activo      --->		       		
        </cfif>
        
        (Select
            Sum(DO.DOcantidad)
        From
            EOrdenCM EO
                Inner Join DOrdenCM DO On
                    EO.EOidorden = DO.EOidorden
        Where
            EO.Ecodigo = EOC.Ecodigo And
            EO.EOnumero = EOC.EOnumero) As Cantidad, 

        (Select
            Sum(DO.DOcantsurtida)
        From
            EOrdenCM EO
                Inner Join DOrdenCM DO On
                    EO.EOidorden = DO.EOidorden
        Where
            EO.Ecodigo = EOC.Ecodigo And
            EO.EOnumero = EOC.EOnumero) As CantidadSurtida,
      	EM.Edescripcion As Empresa,
        DOC.DOconsecutivo As LineaOC
        
    From EOrdenCM EOC
        Inner Join DOrdenCM  DOC on
            DOC.Ecodigo = EOC.Ecodigo and
            DOC.EOidorden = EOC.EOidorden        
        
        Inner Join Monedas MOC on
            MOC.Ecodigo = EOC.Ecodigo and
            MOC.Mcodigo = EOC.Mcodigo
        
        Inner Join Impuestos IDOC on
            IDOC.Ecodigo = EOC.Ecodigo and
            IDOC.Icodigo = DOC.Icodigo
        
        Inner Join SNegocios SNOC on
            SNOC.Ecodigo = EOC.Ecodigo and
            SNOC.SNcodigo = EOC.SNcodigo

        <cfif #TRM# EQ "1">
       	Inner Join Articulos AR on
            AR.Ecodigo = EOC.Ecodigo and
            AR.Aid = DOC.Aid                
       	<cfelseif #TRM# EQ "2">
        Inner Join Conceptos CO On
            CO.Cid = DOC.Cid            
        Inner Join CConceptos CCO On
            CCO.CCid = CO.CCid					
        <cfelse>	
        Inner Join ACategoria AC On
        	AC.Ecodigo = EOC.Ecodigo And
            AC.ACcodigo = DOC.ACcodigo
            
       	Inner Join AClasificacion ACC On
            ACC.Ecodigo = EOC.Ecodigo And 
            ACC.ACid = DOC.ACid And
            ACC.ACcodigo = AC.ACcodigo									      		
        </cfif>
        inner join Empresas EM On
        	EM.Ecodigo = EOC.Ecodigo        
            
        
    Where  
      	<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
            EOC.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> And
         <cfelse>
            EOC.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">) And
         </cfif>    
<!---        EOC.Ecodigo = #session.Ecodigo# and--->
        <cfif isdefined('form.EstadOrden')>
			<cfif #form.EstadOrden# NEQ "T">
            	<cfif (#form.EstadOrden# EQ "APS") OR (#form.EstadOrden# EQ "ATS")>
                	EOC.EOestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="10"> and
                <cfelse>
                	EOC.EOestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EstadOrden#"> and
                </cfif>
            </cfif> 
       	</cfif>
        <!--- Búsqueda en el rango de articulos seleccionados--->
        <cfif #TRM# EQ "1">
			<cfif len(trim(#codArt1#)) gt 0 and  len(trim(#codArt2#)) gt 0> 
                 AR.Acodigo  between 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#codArt1#">  and 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#codArt2#"> and
            <cfelseif len(trim(#codArt1#)) gt 0 >  
                 AR.Acodigo >=  <cfqueryparam cfsqltype="cf_sql_char" value="#codArt1#"> and
            <cfelseif len(trim(#codArt2#)) gt 0>  
                 AR.Acodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#codArt2#"> and
            </cfif>
        <cfelseif #TRM# EQ "2">
        	<cfif len(trim(#Cid#)) gt 0 and  len(trim(#Cid2#)) gt 0> 
        	CO.Cdescripcion between
            	(Select X.Cdescripcion From Conceptos X Where X.Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Cid#">) And
				(Select X.Cdescripcion From Conceptos X Where X.Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Cid2#">) And               
         	</cfif>
        <cfelse>
        	<cfif len(trim(#form.ACcodigo1#)) gt 0 and  len(trim(#form.ACcodigo2#)) gt 0> 
        	AC.ACdescripcion between
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACcodigo1#"> And
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACcodigo2#"> And       
            </cfif>                	
       	</cfif>
        EOC.EOfecha Between
        	<cfqueryparam cfsqltype="cf_sql_date" value="#Form.FechaInicial#"> and
            <cfqueryparam cfsqltype="cf_sql_date" value="#Form.FechaFinal#"> 
    Order by 
    	Empresa,
      	<cfif #TRM# EQ "1">
        	CodigoAR,
       	<cfelseif #TRM# EQ "2">
        	DescripcionConcepto,
        <cfelse>	
        	Categoria,     		       		
        </cfif>
        NumeroOrdenEOC,
       	LineaOC,
        FechaOC
</cfquery>

<cfif #form.EstadOrden# EQ "APS">
    <cfquery name="rsDatos" dbtype="query">
        Select *
        From 
            rsDatos
        Where
            CantidadSurtida <> Cantidad
    </cfquery>
<cfelseif #form.EstadOrden# EQ "ATS">
    <cfquery name="rsDatos" dbtype="query">
        Select *
        From 
            rsDatos
        Where
            CantidadSurtida = Cantidad
    </cfquery>	
</cfif>

<!---<cf_dump var="#rsDatos#">--->

<cfif not isdefined("form.toExcel")>
	<cf_rhimprime datos="/sif/cm/consultas/OrdenesCompraPorArticulo-form.cfm" paramsuri="#Param#">     
</cfif>

<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=OrdenesCompraPorArticulo_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>

<cffunction name="Encabezado" output="yes">
	<cfoutput>
    <table width="98%" border="0" cellpadding="1" cellspacing="1"  align="center">     
   	<tr> 
      <td  align="center" bgcolor="BCBCBC" colspan="11"><strong style="font-size:16px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="12"><b>&Oacute;rdenes de Compra&nbsp;<cfoutput><cfif #TRM# EQ "1">Por &Aacute;rticulo<cfelseif #TRM# EQ "2">Por Servicio<cfelse>Por Activo Fijo</cfif></cfoutput></b></td>
    </tr>
   	<tr>
        <td colspan="12" align="center">
                <cfif len(trim(#fecha1#)) gt 0 and  len(trim(#fecha2#)) gt 0 and #fecha1# neq #fecha2#> 
                    <strong>Fecha desde el </strong> <cfoutput>#LSDateFormat(fecha1,'dd/mm/yyyy')#</cfoutput><strong>, hasta el </strong>  <cfoutput>#LSDateFormat(fecha2,'dd/mm/yyyy')#</cfoutput>
               <cfelseif len(trim(#fecha1#)) gt 0 and  len(trim(#fecha2#)) gt 0 and #fecha1# eq #fecha2#> 
                    <strong>Fecha </strong> <cfoutput>#LSDateFormat(fecha1,'dd/mm/yyyy')#</cfoutput>
               <cfelseif len(trim(#fecha1#)) gt 0  and len(trim(#fecha2#)) eq 0 >  
                    <strong>Desde el </strong> <cfoutput>#LSDateFormat(fecha1,'dd/mm/yyyy')#</cfoutput>
                <cfelseif len(trim(#fecha1#)) eq 0 and len(trim(#fecha2#)) gt 0 >  
                    <strong>Hasta el </strong> <cfoutput>#LSDateFormat(fecha2,'dd/mm/yyyy')#</cfoutput>
               </cfif>               
        </td>            
 	</tr>
    <cfif isdefined('form.EstadOrden')>
        <tr>
            <td  colspan="12" align="center" style="padding-right: 20px"><b>Estado de las &Oacute;rdenes:</b>
				<cfswitch expression="#Trim(form.EstadOrden)#">
                	<cfcase value="APS">
                    	<b>Aplicada Parcialmente Surtida</b>
                    </cfcase>
                	<cfcase value="ATS">
                    	<b>Aplicada Totalmente Surtida</b>
                    </cfcase>                    
                	<cfcase value="-10">
                    	<b>Pendiente de Aprobación Presupuestaria</b>
                    </cfcase>
                	<cfcase value="-8">
                    	<b>Orden Rechazada</b>
                    </cfcase>
                	<cfcase value="-7">
                    	<b>En Proceso de Aprobación</b>
                    </cfcase>
                	<cfcase value="0">
                    	<b>Pendiente</b>
                    </cfcase>
                	<cfcase value="5">
                    	<b>Pendiente Vía Proceso</b>
                    </cfcase>
                	<cfcase value="7">
                    	<b>Pendiente OC Directa</b>
                    </cfcase>
                	<cfcase value="8">
                    	<b>Pendiente Vía Contrato</b>
                    </cfcase>
                	<cfcase value="9">
                    	<b>Autorizada por jefe Compras</b>
                    </cfcase>  
                	<cfcase value="70">
                    	<b>Ordenes Anuladas</b>
                    </cfcase>
                	<cfcase value="55">
                    	<b>Ordenes Canceladas Parcialmente Surtida</b>
                    </cfcase> 
                	<cfcase value="60">
                    	<b>Ordenes Canceladas</b>
                    </cfcase>
                    <cfdefaultcase>
                    	<b>Todos los Estados</b>
                    </cfdefaultcase>                                                                                                                                                                                                  
                </cfswitch>
			</td>
        </tr>
    </cfif>
    <tr> 
	    <td class="bottomline" colspan="10">&nbsp;</td>
    </tr>
     </table>
  	</cfoutput>
</cffunction>

<form action="">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" >
   <cfset Encabezado()>
     <tr> 
     	<td>
        	<table width="98%" border="0" cellpadding="0" cellspacing="0"  align="center">             
				<cfif rsDatos.recordcount gt 0>
                <cfset totalPedidoGeneral = 0>
                <cfset totalCostoPedidoGeneral = 0>
                <cfset totalSurtidoGeneral = 0>
                <cfset totalCostoSurtidoGeneral = 0>
                <cfset totalMontoImpuestoGeneral = 0>
                <tr>
                    <td  width="6%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Orden de Compra</strong></td>
                    <td  width="4%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>L&iacute;nea</strong></td>                    				
                    <td  width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Estado Orden de Compra</strong></td>
                    <td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Proveedor</strong></td>
                    <cfif #TRM# EQ "2" Or #TRM# EQ "3">
						<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Clasificaci&oacute;n</strong></td>                    	                   	
                    </cfif>
                    <td width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Fecha</strong></td>
                    <td width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Moneda</strong></td>
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Costo Unitario</strong></td>                    
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Pedido</strong></td>
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Costo Pedido</strong></td>
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Surtido</strong></td>
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Costo Surtido</strong></td>                                             
                    <td width="12%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>Impuesto</strong></td>
                </tr>
                	<cfoutput query="rsDatos" group="Empresa">
                        <td colspan="13" align="center" bgcolor="66FFFF">
                        	<strong style="font-size:16px">#Empresa#</strong>   
                        </td>                      
						<cfoutput group="#group#">                 					
                        <cfset contDetalle = contDetalle + 2 >
                        <tr>
                                <cfif #TRM# EQ "1">
                                    <td colspan="12" align="center" bgcolor="BCBCBC">
                                    <strong style="font-size:16px">#CodigoAR#  --  #DescripcionAR# </strong>
                                <cfelseif #TRM# EQ "2">
                                    <td colspan="13" align="center" bgcolor="BCBCBC">
                                    <strong style="font-size:16px">#DescripcionConcepto# </strong>
                                <cfelse>
                                    <td colspan="13" align="center" bgcolor="BCBCBC">
                                    <strong style="font-size:16px">#Categoria# </strong>  		
                                </cfif>                    
                            </td>
                        </tr>
                            <cfset totalPedido = 0>
                            <cfset totalCostoPedido = 0>
                            <cfset totalSurtido = 0>
                            <cfset totalCostoSurtido = 0>
                            <cfset totalMontoImpuesto = 0>
                            
                            <cfoutput>
                            <cfset contDetalle = contDetalle + 2 >                                        
                            <tr>
                                <td align="center" width="6%" >
                                    <b>#NumeroOrdenEOC#</b>
                                </td>
                                <td align="center" width="4%" >
                                    <b>#LineaOC#</b>
                                </td>                                
                                <td width="15%" align="center">
                                <cfif (#Estado# EQ 'Aplicada')>
                                    <cfif #CantidadSurtida# EQ #Cantidad#>
                                        A. Totalmente Surtida
                                    <cfelse>
                                        A. Parcialmente Surtida
                                    </cfif>
                                <cfelse>
                                    #Estado# 
                                </cfif>
                                </td>
                                <td width="15%" align="center">
                                    #Proveedor#
                                </td>
                                <cfif #TRM# EQ "2" Or #TRM# EQ "3">
                                <td width="15%" align="center">
                                    #Clasificacion#
                                </td>								
                                </cfif>                                                            
                                <td width="8%" align="center">
                                    #DateFormat(FechaOC, "mm/dd/yyyy")#
                                </td>
                                <td width="8%" align="center">
                                    #Moneda#
                                </td>
                                <td width="8%" align="right">
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(CostoUnitario, ",.00")#
                                    <cfelse>
                                        #LSNumberFormat(CostoUnitario, "_________.___")#
                                    </cfif>                              
                                </td>                            
                                <td width="12%" align="right">
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(Pedido, ",.00")#
                                    <cfelse>
                                        #LSNumberFormat(Pedido, "_________.___")#
                                    </cfif>                            
                                </td>
                                <td width="12%" align="right">
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(CostoPedido, ",.00")#
                                    <cfelse>
                                        #LSNumberFormat(CostoPedido, "_________.___")#
                                    </cfif>                              
                                </td>
                                <td width="12%" align="right">
                                <cfif not isdefined("form.toExcel")>
                                    #LSNumberFormat(Surtido, ",.00")#
                                <cfelse>
                                    #LSNumberFormat(Surtido, "_________.___")#
                                </cfif>                                                          
                                </td>                            
                                <td width="12%" align="right">
                                <cfif not isdefined("form.toExcel")>
                                    #LSNumberFormat(CostoSurtido, ",.00")#
                                <cfelse>
                                    #LSNumberFormat(CostoSurtido, "_________.___")#
                                </cfif>                            
                                </td>
                                <td width="12%" align="right">
                                <cfif not isdefined("form.toExcel")>
                                    #LSNumberFormat(MontoImpuesto, ",.00")#
                                <cfelse>
                                    #LSNumberFormat(MontoImpuesto, "_________.___")#
                                </cfif>                            
                                </td>
                            </tr>                                                   
                            
                            <cfset totalPedido = totalPedido  + #Pedido#>
                            <cfset totalPedidoGeneral = totalPedidoGeneral  + #Pedido#>
                            <cfset totalCostoPedido = totalCostoPedido + #CostoPedido#>
                            <cfset totalCostoPedidoGeneral = totalCostoPedidoGeneral + #CostoPedido#>
                            <cfset totalSurtido = totalSurtido + #Surtido#>
                            <cfset totalSurtidoGeneral = totalSurtidoGeneral + #Surtido#>
                            <cfset totalCostoSurtido = totalCostoSurtido + #CostoSurtido# >
                            <cfset totalCostoSurtidoGeneral = totalCostoSurtidoGeneral + #CostoSurtido# >
                            <cfset totalMontoImpuesto = totalMontoImpuesto + #MontoImpuesto#>
                            <cfset totalMontoImpuestoGeneral = totalMontoImpuestoGeneral + #MontoImpuesto#>
                            </cfoutput>
                            <tr>
                                <tr>
                                    <!---<td colspan="<cfoutput><cfif #TRM# EQ "1">6<cfelse>7></cfif></cfoutput>" width="54" align="right">--->
                                        <cfif #TRM# EQ "1">
                                            <td colspan="7" width="54" align="right">                              	
                                            <strong style="font-size:16px">Total para #CodigoAR#  --  #DescripcionAR#:&nbsp;</strong>
                                        <cfelseif #TRM# EQ "2">
                                            <td colspan="8" width="54" align="right">
                                            <strong style="font-size:16px">Total para #DescripcionConcepto#:&nbsp;</strong>
                                        <cfelse>
                                            <td colspan="8" width="54" align="right">
                                            <strong style="font-size:16px">Total para #Categoria#:&nbsp;</strong>		       		
                                        </cfif>                                  
                                    </td>
                                    <td width="12%" align="right" style="border-top:1px solid black;">
                                        <cfif not isdefined("form.toExcel")>
                                             <strong>#LSNumberFormat(totalPedido, ",.00")#</strong>
                                        <cfelse>
                                            <strong>#LSNumberFormat(totalPedido, "_________.___")#</strong>
                                        </cfif>                                 
                                    </td>
                                    <td width="12%" align="right" style="border-top:1px solid black;">
                                        <cfif not isdefined("form.toExcel")>
                                             <strong>#LSNumberFormat(totalCostoPedido, ",.00")#</strong>
                                        <cfelse>
                                            <strong>#LSNumberFormat(totalCostoPedido, "_________.___")#</strong>
                                        </cfif>                                   
                                    </td>
                                    <td width="12%" align="right" style="border-top:1px solid black;">
                                        <cfif not isdefined("form.toExcel")>
                                             <strong>#LSNumberFormat(totalSurtido, ",.00")#</strong>
                                        <cfelse>
                                            <strong>#LSNumberFormat(totalSurtido, "_________.___")#</strong>
                                        </cfif>                                  
                                    </td>                            
                                    <td width="12%" align="right" style="border-top:1px solid black;">
                                        <cfif not isdefined("form.toExcel")>
                                             <strong>#LSNumberFormat(totalCostoSurtido, ",.00")#</strong>
                                        <cfelse>
                                            <strong>#LSNumberFormat(totalCostoSurtido, "_________.___")#</strong>
                                        </cfif>                                
                                    </td>
                                    <td width="12%" align="right" style="border-top:1px solid black;">
                                        <cfif not isdefined("form.toExcel")>
                                             <strong>#LSNumberFormat(totalMontoImpuesto, ",.00")#</strong>
                                        <cfelse>
                                            <strong>#LSNumberFormat(totalMontoImpuesto, "_________.___")#</strong>
                                        </cfif>                                 
                                    </td>
                                </tr>
                            </tr>
                        </cfoutput>
                  	 </cfoutput>
					<cfoutput>
                    <tr>
                        <tr>
                            <!---<td  colspan="<cfoutput><cfif #TRM# EQ "1">6<cfelse>7></cfif></cfoutput>" width="54" align="right"><strong>Total General:</strong></td>--->
                            <cfif #TRM# EQ "1">
                                <td  colspan="7" width="54" align="right"><strong>Total General:</strong></td>
                            <cfelseif #TRM# EQ "2">
                                <td  colspan="8" width="54" align="right"><strong>Total General:</strong></td>
                            <cfelse>
                                <td  colspan="8" width="54" align="right"><strong>Total General:</strong></td>    		
                            </cfif>                             
                            <td width="12%" align="right" style="border-top:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
                                     <strong>#LSNumberFormat(totalPedidoGeneral, ",.00")#</strong>
                                <cfelse>
                                    <strong>#LSNumberFormat(totalPedidoGeneral, "_________.___")#</strong>
                                </cfif>                               
                            </td>
                            <td width="12%" align="right" style="border-top:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
                                     <strong>#LSNumberFormat(totalCostoPedidoGeneral, ",.00")#</strong>
                                <cfelse>
                                    <strong>#LSNumberFormat(totalCostoPedidoGeneral, "_________.___")#</strong>
                                </cfif>                            
                            </td>
                            <td width="12%" align="right" style="border-top:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
                                     <strong>#LSNumberFormat(totalSurtidoGeneral, ",.00")#</strong>
                                <cfelse>
                                    <strong>#LSNumberFormat(totalSurtidoGeneral, "_________.___")#</strong>
                                </cfif>                               
                            </td>                            
                            <td width="12%" align="right" style="border-top:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
                                     <strong>#LSNumberFormat(totalCostoSurtidoGeneral, ",.00")#</strong>
                                <cfelse>
                                    <strong>#LSNumberFormat(totalCostoSurtidoGeneral, "_________.___")#</strong>
                                </cfif>                             
                            </td>
                            <td width="12%" align="right" style="border-top:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
                                     <strong>#LSNumberFormat(totalMontoImpuestoGeneral, ",.00")#</strong>
                                <cfelse>
                                    <strong>#LSNumberFormat(totalMontoImpuestoGeneral, "_________.___")#</strong>
                                </cfif>                                 
                            </td>
                        </tr>
                    </tr>  
                    </cfoutput>                 
                <cfelse>
                	<tr><td colspan="12" align="center">&nbsp;</td></tr>
                	<tr><td colspan="12" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>    
               </cfif>     
            </table>
        </td>
     </tr>
    </table>
</form>
