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
            <td width="100%"><a href="../consultas/ListadoConsecutivoOrdenes.cfm">Regresar</a></td>
          </tr>
        </table>
    </cfif>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset codigoOC1  = "">
<cfset codigoOC2  = "">
<cfset fecha1 = "">
<cfset fecha2 = "">
<cfset Param  = "">
<cfset contDetalle = 0>   
<cfset maxRows = 30>

<cfif isdefined('url.NumeroOC1') and len(trim(#url.NumeroOC1#))>
     <cfset form.NumeroOC1 = url.NumeroOC1>
</cfif>
<cfif isdefined('url.NumeroOC2') and len(trim(#url.NumeroOC2#))>
    <cfset form.NumeroOC2 = url.NumeroOC2>
</cfif>

<!--- Definiciòn de numeros de órdenes de compra--->
<cfif isdefined('form.NumeroOC1') and len(trim(#form.NumeroOC1#))>
	<cfset codigoOC1  = form.NumeroOC1>
   <cfset numeroOC1 = form.NumeroOC1>
   <cfset Param = Param & "&NumeroOC1="&#form.NumeroOC1#> 
</cfif>
<cfif isdefined('form.NumeroOC2') and len(#form.NumeroOC2#)>
	<cfset codigoOC2  = form.NumeroOC2>
   <cfset numeroOC2 = form.NumeroOC2> 
   <cfset Param = Param & "&NumeroOC2="&#form.NumeroOC2#> 
</cfif>

<cfif isdefined('url.TipoOrden')  and len(trim(#url.TipoOrden#))>
    <cfset form.TipoOrden = #url.TipoOrden#>
	<cfset Param = Param & "&TipoOrden="&#form.TipoOrden#> 
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
<cfif isdefined('form.TipoOrden') >
    <cfset Param = Param & "&TipoOrden="&#form.TipoOrden#> 
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
 
<!--- Empresas --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	Select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsDatos" datasource="#session.dsn#">	
	Select
    	OC.EOidorden,
        OC.EOnumero As NumeroOrden,
        Case CM.CMTOimportacion
            When 1 Then 'Exterior'
            When 0 Then 'Local'
            Else ''
        End
        As Tipo,
        SN.SNcodigo As CodigoProveedor,
        SN.SNnombre As NombreProveedor,
        CC.CMCcodigo As CodigoComprador,
        CC.CMCnombre As NombreComprador,
        MOC.Mnombre As Moneda,
        OC.EOtotal As MontoTotal,
        
        (Select
            Sum(DO.DOcantidad)
        From
            EOrdenCM EO
                Inner Join DOrdenCM DO On
                    EO.EOidorden = DO.EOidorden And
                    EO.Ecodigo = OC.Ecodigo
        Where
            EO.Ecodigo = OC.Ecodigo And
            EO.EOnumero = OC.EOnumero) As Cantidad, 

        (Select
            Sum(DO.DOcantsurtida)
        From
            EOrdenCM EO
                Inner Join DOrdenCM DO On
                    EO.EOidorden = DO.EOidorden And
                    EO.Ecodigo = OC.Ecodigo
        Where
            EO.Ecodigo = OC.Ecodigo And
            EO.EOnumero = OC.EOnumero) As CantidadSurtida,          
        
        Case OC.EOestado
            When -10 Then 'Pendiente de Aprobacion'
            When -8 Then 'Orden Rechazada'
            When -7 Then 'Requiere Reasignación'
            When 0 Then 'Pendiente'
            When 5 Then 'Pendiente Vía Proceso'
            When 7 Then 'Pendiente OC Directa'
            When 8 Then 'Pendiente Vía Contrato'
            When 9 Then 'Autorizada por jefe Compras'
            When 10 Then 'A'
            When 55 Then 'Orden Cancelada Parcialmente Surtida'
            When 60 Then 'Orden Cancelada'
            When 70 Then 'Orden Anulada'
            When 101 Then 'Aprobado Mutiperiodo'
            Else 'No tiene'
        End
        As Estado,
        OC.EOfecha As FechaOC,
        EM.Edescripcion As Empresa
	From 
        EOrdenCM OC
        inner join SNegocios SN on 
            SN.Ecodigo = OC.Ecodigo and
            OC.SNcodigo = SN.SNcodigo
        inner join CMTipoOrden CM on
            CM.Ecodigo = OC.Ecodigo and
            OC.CMTOcodigo = CM.CMTOcodigo
        left outer join CMCompradores CC on
            <!---CC.Ecodigo = OC.Ecodigo and--->
            OC.CMCid = CC.CMCid
     	inner join Monedas MOC on
            MOC.Ecodigo = OC.Ecodigo and
            MOC.Mcodigo = OC.Mcodigo
        inner join Empresas EM On
        	EM.Ecodigo = OC.Ecodigo
        	
	Where 
    
      	<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
            OC.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
         <cfelse>
            OC.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
         </cfif>
    	<!---OC.Ecodigo = #session.Ecodigo#--->
        <!--- Verificar el tipo de orden: (T - Todos) (L - Locales) (I - Internacionales)--->
		<cfif #Form.TipoOrden# neq "T">
			<cfif 	#Form.TipoOrden# eq "L">
                AND CM.CMTOimportacion = 0
            </cfif>
            <cfif 	#Form.TipoOrden# eq "I">
                AND CM.CMTOimportacion = 1
            </cfif>
   		</cfif>
        <!--- Búsqueda en el rango de las ordenes seleccionadas por el usuario--->
		<cfif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0> 
			<cfif #codigoOC1# lt #codigoOC2#>
             and OC.EOnumero  between 
             	<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#"> and 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#">
            <cfelse>
             and OC.EOnumero  between
               	<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#"> and 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#">
            </cfif> 
       	<cfelseif len(trim(#codigoOC1#)) gt 0 >  
             and OC.EOnumero >=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC1#">
     	<cfelseif len(trim(#codigoOC2#)) gt 0>  
             and OC.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoOC2#"> 
      	</cfif>
        	and OC.EOfecha Between 
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaInicial#"> and
            	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaFinal#">
	Order By
    	<cfif #Form.TipoOrden# neq "T">
    		Empresa, Tipo, NumeroOrden, FechaOC
       	<cfelse>
        	Empresa, NumeroOrden
        </cfif>
</cfquery> 

<!---<cf_dump var="#rsDatos#">--->

<cfif not isdefined("form.toExcel")>
	<cf_rhimprime datos="/sif/cm/consultas/ListadoConsecutivoOrdenes-form.cfm" paramsuri="#Param#">     
</cfif>

<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=ListadoConsecutivoOrdenes_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>

<cffunction name="Encabezado" output="yes">
	<cfoutput>
    <table width="98%" border="0" cellpadding="1" cellspacing="1"  align="center">
        <tr> 
          <td  align="center" bgcolor="BCBCBC" colspan="10"><strong style="font-size:16px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="center" colspan="10"><b>Consecutivo de &Oacute;rdenes de Compra</b></td>
        </tr>
            <tr> 
               <td colspan="10" align="center">
                    <cfif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0 and #codigoOC1# neq #codigoOC2#> 
                        <strong>Orden de Compra desde la </strong> <cfoutput>#numeroOC1#</cfoutput><strong>, hasta la </strong>  <cfoutput>#numeroOC2#</cfoutput>
                   <cfelseif len(trim(#codigoOC1#)) gt 0 and  len(trim(#codigoOC2#)) gt 0 and #codigoOC1# eq #codigoOC2#> 
                        <strong>Orden de Compra: </strong> <cfoutput>#numeroOC1#</cfoutput>
                   <cfelseif len(trim(#codigoOC1#)) gt 0  and len(trim(#codigoOC2#)) eq 0 >  
                        <strong>Desde &oacute;rden de Compra: </strong> <cfoutput>#numeroOC1#</cfoutput>
                    <cfelseif len(trim(#codigoOC1#)) eq 0 and len(trim(#codigoOC2#)) gt 0 >  
                        <strong>Hasta &oacute;rden de Compra: </strong> <cfoutput>#numeroOC2#</cfoutput>
                   </cfif>               
                </td>            
            </tr>
            <tr>
               <td colspan="10" align="center">
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
        <cfif isdefined('form.TipoOrden') and #form.TipoOrden# neq 'T'>
            <tr>
                <td  colspan="10" align="center" style="padding-right: 20px"><b>Tipo Orden:</b>
                    <cfif  #form.TipoOrden# eq 'L'>Local<cfelseif #form.TipoOrden# eq 'I'>Exterior</cfif>
                </td>
            </tr>
        </cfif>
        <tr> 
            <td class="bottomline" colspan="10">&nbsp;</td>
        </tr>
   	</table>
    </cfoutput>
</cffunction>

<!--- Funcion para obtener el centro Funcional, si solo existe uno en el detalle de la orden de compra--->
<cffunction name="centroFuncional" access="private" returntype="string">
	<cfargument name="EOidorden" type="numeric" required="yes">
    <cfset centro = "">
    <cfquery name="rsObtenerCentros" datasource="#session.DSN#">
        Select 
            DO.EOidorden, 
            DO.DOlinea,
            CF.CFdescripcion
        From DOrdenCM DO
            Inner Join EOrdenCM EO On
                EO.Ecodigo = DO.Ecodigo And
                EO.EOnumero = DO.EOnumero
            Inner Join CFuncional CF On
                CF.Ecodigo = DO.Ecodigo And
                CF.CFid = DO.CFid
        Where
			<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
                DO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
             <cfelse>
                DO.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
             </cfif>         
            <!---DO.Ecodigo = #session.Ecodigo# And--->
             And DO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
        Order By 
            DO.EOidorden, CF.CFdescripcion 	
    </cfquery>
    
    <cfloop query="rsObtenerCentros">
    	<cfif #centro# NEQ ''>
			<cfif rsObtenerCentros.CFdescripcion NEQ #centro#>
                <cfreturn 'No Aplica'>
                <cfbreak>
            </cfif>        	
        </cfif>
       	<cfset centro = rsObtenerCentros.CFdescripcion>
    </cfloop>
    <cfreturn centro>
</cffunction>

<cffunction name="obtenerUsuarios" returntype="array" access="private">
	<cfargument name="EOidorden" type="string" required="yes">
    <cfset var1 = ArrayNew(1)>
    <cfset bandera = 1>
    <cfset idSol = -1>
    <cfquery name="rsUsuarios" datasource="#session.DSN#">
    Select 
        DO.EOidorden, 
        DO.DOlinea,
        ESCM.ESidsolicitud,
        ESCM.Usucodigo,
        ESCM.ProcessInstanceid
        
    From 
        DOrdenCM DO
            Inner Join EOrdenCM EO On
                EO.Ecodigo = DO.Ecodigo And
                EO.EOnumero = DO.EOnumero
            Left Outer Join ESolicitudCompraCM ESCM On
                ESCM.Ecodigo = DO.Ecodigo And
                ESCM.ESidsolicitud = DO.ESidsolicitud
    Where
      	<cfif isdefined('form.EcodigoE') and form.EcodigoE eq -2>
            DO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
         <cfelse>
            DO.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoE#" list="yes">)
         </cfif>    
        <!---DO.Ecodigo = #session.Ecodigo# And--->
        And DO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
    Order By 
        DO.EOidorden
    </cfquery>

    <cfloop query="rsUsuarios">
    	<cfif #idSol# NEQ '-1'>
			<cfif rsUsuarios.ESidsolicitud NEQ #idSol#>
            	<cfset bandera = -1>
               <!--- <cfreturn 'No Aplica'>--->
                <cfbreak>
            </cfif>        	
        </cfif>
        <cfset idSol = rsUsuarios.ESidsolicitud>
    </cfloop>
    
    <cfif len(trim(rsUsuarios.Usucodigo)) GT 0>
		<cfif #bandera# EQ 1>
            <cfquery name="rsLogin" datasource="#session.DSN#">
                select a.Usulogin, b.Pnombre #_Cat#' '#_Cat# b.Papellido1 #_Cat#' '#_Cat# b.Papellido2 as nombre
                from Usuario a
                    left outer join DatosPersonales b
                        on a.datos_personales = b.datos_personales	
                where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuarios.Usucodigo#">
            </cfquery> 
        <cfset ArrayAppend(var1, rsLogin.nombre)>            
       	<cfelse>
      		<cfset ArrayAppend(var1, "")>	
        </cfif>
        <cfif len(trim(rsUsuarios.ProcessInstanceid)) EQ 0 >
        	<cfset ArrayAppend(var1, rsLogin.nombre)>
            <cfreturn var1>
        </cfif>
    <cfelse>
    	<cfset ArrayAppend(var1, "")>
        <cfif len(trim(rsUsuarios.ProcessInstanceid)) EQ 0 >
        	<cfset ArrayAppend(var1, "")>
            <cfreturn var1>
        </cfif>        
   	</cfif>
    
    <cfquery name="rsParticipante" datasource="#Session.DSN#">
        select b.Description
        from WfxActivity a, WfxActivityParticipant b
        where a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuarios.ProcessInstanceid#">
        and a.ActivityInstanceId = b.ActivityInstanceId
        and b.HasTransition = 1
    </cfquery>
    
	<cfif rsParticipante.recordCount>
        <cfloop query = "rsParticipante">
            <cfset ArrayAppend(var1, rsParticipante.Description)>
        </cfloop>
    <cfelse>
        <cfif rsLogin.RecordCount NEQ 0>
            <cfset ArrayAppend(var1, rsLogin.nombre)>
        </cfif>
    </cfif>        
    
    <cfreturn var1>
</cffunction>

<cfif isdefined("form.toExcel")>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>

<form action="">
    <table width="100%" border="0" cellpadding="1" cellspacing="1" >
    <cfset Encabezado()>
    <tr> 
    	<td>
        	<table width="98%" border="0" cellpadding="0" cellspacing="0"  align="center">             
				<cfif rsDatos.recordcount gt 0>
                <cfset totalGeneral = 0>
                <tr>
                    <td  width="6%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Orden de Compra</strong></td>				
                    <td  width="5%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Tipo</strong></td>
                    <td  width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Fecha</strong></td>
                    <td width="20%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Proveedor</strong></td>
                    <td width="20%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Comprador</strong></td>
            		<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Centro Funcional</strong></td>
            		<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Solicitado por:</strong></td> 
            		<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Aprobador por:</strong></td>                                                           
                    <td width="6%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Moneda</strong></td>
                    <td width="10%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Monto</strong></td>                                
                    <td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>Estado </strong></td>
                <tr> 
                	<cfoutput query="rsDatos" group="Empresa">
                    	<tr>
                 			<td colspan="11" align="center" bgcolor="66FFFF">
                        		<strong style="font-size:16px">#Empresa# </strong>
                      		</td>
                       	</tr>                                           
						<cfoutput group="NumeroOrden">   
							<cfset contDetalle = contDetalle + 2 >                           
							<cfif contDetalle GTE maxRows and isdefined("Url.imprimir")>
								</table>
								<cfset contDetalle = 0>                       
								<BR style="page-break-after:always;">
								<cfset Encabezado()>
								<table width="98%" border="0" cellpadding="1" cellspacing="1"  align="center">   
								<tr>
									<td  width="6%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Orden de Compra</strong></td>				
									<td  width="5%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Tipo</strong></td>
									<td  width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Fecha</strong></td>
									<td width="20%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>Proveedor</strong></td>
									<td width="20%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Comprador</strong></td>
									<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Centro Funcional</strong></td>
									<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Solicitado por:</strong></td> 
									<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Aprobador por:</strong></td>                                                                 
									<td width="6%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Moneda</strong></td>
									<td width="10%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;"align="center"><strong>Monto</strong></td>                                
									<td width="15%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>Estado </strong></td>
								</tr>                                                              
							</cfif>            
							<tr>
								<td width="6%" style=" border-bottom:1px solid black;" align="center">
									<b>#NumeroOrden#</b>
								</td>
								<!--- Tipo--->
								<td width="5%" style=" border-bottom:1px solid black;" align="center">
									#Tipo#
								</td>
								<td width="8%" style=" border-bottom:1px solid black;" align="center">
									#DateFormat(FechaOC, "mm/dd/yyyy")#
								</td>                            
								<!---  NombreProveedor--->
								<td width="20%" style=" border-bottom:1px solid black;" align="center">
									#NombreProveedor#
								</td>
								<!---  NombreComprador--->
								<td width="20%" style=" border-bottom:1px solid black;" align="center">
									<cfif len(trim(#NombreComprador#)) GT 0> 
										#NombreComprador#
									<cfelse>
										NA
									</cfif>
								</td>
								<td width="15%" style=" border-bottom:1px solid black;" align="center">
									<cfset varCF = #centroFuncional(EOidorden)#>
									<cfif len(trim(varCF)) GT 0>
										#varCF#
									<cfelse>
										NA
									</cfif>
								</td>
								<td width="15%" style=" border-bottom:1px solid black;" align="center">
									<cfset var1 = #obtenerUsuarios(EOidorden)#>
									<cfif len(trim(var1[1])) GT 0>
										#var1[1]#
									<cfelse>
										NA
									</cfif>
								</td>                                                        
								<td width="15%" style=" border-bottom:1px solid black;" align="center">
									<cfif len(trim(var1[2])) GT 0>
										#var1[2]#
									<cfelse>
										NA
									</cfif>                                 
								</td>                            
								<!---  Moneda--->
								<td width="6%" style=" border-bottom:1px solid black;" align="center">
									#Moneda#
								</td>
								<!---  MontoTotal--->
								<td width="10%" style=" border-bottom:1px solid black;" align="right">
									<cfif not isdefined("form.toExcel")>
										#LSNumberFormat(MontoTotal, ",.00")#
									<cfelse>
										#LSNumberFormat(MontoTotal, "_________.___")#
									</cfif>                            
								</td>                            
								<!---  Estado--->
								<td width="15%" style=" border-bottom:1px solid black;" align="center">
								<cfif #Estado# EQ 'A'>
									<cfif #CantidadSurtida# EQ #Cantidad#>
										A.Totalmente Surtida
									<cfelse>
										A.Parcialmente Surtida
									</cfif>
								<cfelse>
									#Estado# 
								</cfif>
								</td>
							</tr>
							</cfoutput>
                        </cfoutput>                    
                <cfelse>
                	<tr><td colspan="11" align="center">&nbsp;</td></tr>
                	<tr><td colspan="11" align="center">----------------- No se encontrar&oacute;n Datos -----------------</td></tr>    
               </cfif>     
            </table>
        </td>
     </tr>
    </table>
</form>
