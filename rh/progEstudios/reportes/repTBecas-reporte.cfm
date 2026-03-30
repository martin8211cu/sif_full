<html>
<head>
	<style type="text/css">
		.tipoBeca{
			text-align:center;
			background-color:#CCC;
			font-size:18px;
			font-weight:bold;
		}
		
		.columnas{
			font-weight:bold;
			background-color:#CCC;
		}
		
		.campos{
			border-width: 0px;
			text-align:left;
		}
		
		.titulo{
			font-size:24px;	
			font-weight:bold;
		}
		
		.subtitulo{
			border-width: 0px;
		}
	</style>
</head>
<body>

<cfquery name="rsEncabezados" datasource="#session.dsn#">
    select eb.RHTBid, eb.RHEBEid, RHTBdescripcion, DEidentificacion, DEnombre,DEapellido1, DEapellido2, cf.CFid, cf.CFcodigo, cf.CFdescripcion
    from RHEBecasEmpleado eb
    	inner join DatosEmpleado de 
        	on de.DEid = eb.DEid
        inner join RHTipoBeca tb
        	on tb.RHTBid = eb.RHTBid
       	inner join LineaTiempo lt
        	on lt.DEid = eb.DEid and lt.Ecodigo = eb.Ecodigo
              and eb.RHEBEfecha between lt.LTdesde and lt.LThasta
        inner join RHPlazas p
           on lt.RHPid = p.RHPid and lt.Ecodigo = p.Ecodigo
        inner join CFuncional cf
                on cf.CFid = p.CFid
    
    where-- eb.Ecodigo = #session.Ecodigo#      and 
	eb.RHEBEestado = 70
      <cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
      	and eb.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
      </cfif>
	  <cfif isdefined ('form.RHTBid') and len(trim(form.RHTBid)) gt 0>
      	and eb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTBid#">
      </cfif>
	  <cfif isdefined ('form.fini') and len(trim(form.fini)) gt 0>
      	and eb.RHEBEfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsdateformat(form.fini)#">
      </cfif>
	  <cfif isdefined ('form.ffin') and len(trim(form.ffin)) gt 0>
      	and eb.RHEBEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsdateformat(form.ffin)#">
      </cfif>
    order by eb.RHTBid,DEidentificacion
</cfquery>

<cfoutput>
<cf_htmlReportsHeaders irA="repTBecas.cfm" FileName="repTBecas.xls" title="Tipos de Becas">
<table width="100%" border="0" cellpadding="0" cellspacing="0">

    <tr>
    	<td class="titulo">#session.Enombre#</td>
		<td>&nbsp;</td>
    </tr>
	<tr>
    	<td class="titulo">Departamento de Recursos Humanos de Becas</td>
		<td>&nbsp;</td>
    </tr>
	 <tr>
    	<td class="subtitulo">Unidad de Desarrollo de Personal</td>
		<td>&nbsp;</td>
    </tr>
	<tr>
    	<td class="subtitulo">Programa de Becas</td>
    </tr>
   	<tr>
    	<td colspan="2">&nbsp;</td>
    </tr>
</table>

			<cfset lvarRHTBid = -1>
            <cfset columnas = 0>
			
           <cfloop query="rsEncabezados">

				<cfif lvarRHTBid NEQ rsEncabezados.RHTBid>
						<cfset lvarRHTBid=rsEncabezados.RHTBid>
						<cfquery name="rsSubT" dbtype="query">
							select count(1) as cantidad, RHTBdescripcion
							from rsEncabezados
							where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHTBid#">
							group by RHTBdescripcion
						</cfquery>
						<table>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
							<td class="columnas" colspan="3">El Total de Becas para el cursos <b>#rsSubT.RHTBdescripcion#</b> es:  <b>#rsSubT.cantidad#</b></td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						</table>
				</cfif>
				
					
			<table  align="center" border="1" width="80%" style="border-width: 4px; border-style: outset; border-color: black;">
					<tr><!------------------------------------------------------------ E N C A B E Z A D O -------------------------------------->
						<th colspan="2" align="left" ><strong>REPORTE DE BECA: #rsSubT.RHTBdescripcion#</strong></th>	
						<th align="left" ><strong>Fecha: #LsDateFormat(now(),"dd/mm/yyyy")#</strong></th>	
					</tr>	

					<tr><!------------------------------------------------------------ D A T O S  P E R S O N A L E S-------------------------------------->
						<th colspan="3" align="center" ><strong> <strong>DATOS PERSONALES</strong></th>	
					</tr>	
                    <tr><!--- 1ra fila--->
						<th class="subtitulo" align="left" style="width:50%">Nombre</th>
						<th class="subtitulo" align="left" style="width:20%">Identificaci&oacute;n</th>
						<th class="subtitulo" align="left" style="width:20%">Esc/Depart.</th>
					</tr>
					<tr>
						<td class="campos" align="left">#rsEncabezados.DEnombre# #rsEncabezados.DEapellido1# #rsEncabezados.DEapellido2#</td>
						<td class="campos" align="left">#rsEncabezados.DEidentificacion# </td>
						<td class="campos" align="left" >#rsEncabezados.CFcodigo# - #rsEncabezados.CFdescripcion#</td>
					</tr>
					
					<!------------------------------------------------------------ C O L U M N A S  -------------------------------------->
					<cfquery name="rsColumnas" datasource="#session.dsn#">
                    select RHTBDFid, RHTBDFetiqueta, RHTBDFcapturaA, RHTBDFcapturaB,RHTBEFdescripcion
                    from RHTipoBecaEFormatos eb
                        inner join RHTipoBecaDFormatos db
                            on db.RHTBEFid = eb.RHTBEFid
                    where eb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHTBid#">
                      and db.RHTBDFreporte in (1,3)
                      and db.RHTBDFbeneficio = 0
					  and (select count(1)
                            from RHDBecasEmpleado
                            where RHTBDFid = db.RHTBDFid
                              and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                              and RHDBEversion = 1) > 0
              	  </cfquery>
				  
					<tr>
						<th colspan="3" align="center"  ><strong>INFORMACI&Oacute;N</strong></th>	
					</tr>	

				
				<cfif rsColumnas.recordcount GT 0>
	
				<cfset descripcionColumnas="">
					<tr>
						<td class="campos" colspan="3" >
						<table>
					 <cfloop query="rsColumnas">

					 <cfif descripcionColumnas EQ rsColumnas.RHTBEFdescripcion>
					 	<cfset PintarDescripcionColumnas=0>
					<cfelse>	
						<cfset descripcionColumnas=rsColumnas.RHTBEFdescripcion>
					 	<cfset PintarDescripcionColumnas=1>
					 </cfif>
					 
                        <cfquery name="rsDetalle" datasource="#session.dsn#">
                            select RHDCBid, RHDBEvalor
                            from RHDBecasEmpleado
                            where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsColumnas.RHTBDFid#">
                              and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                              and RHDBEversion = 1
                        </cfquery>
						<cfif rsDetalle.recordcount gt 0>
							<cfif rsColumnas.RHTBDFcapturaA neq 5 and len(trim(rsColumnas.RHTBDFcapturaB)) eq 0>
								<cfset lvarValorA = rsDetalle.RHDBEvalor>
								<cfset lvarValorB = "">
							<cfelseif rsColumnas.RHTBDFcapturaA eq 5 and len(trim(rsColumnas.RHTBDFcapturaB)) eq 0>
								<cfset lvarValorA = rsDetalle.RHDCBid>
								<cfset lvarValorB = "">
							<cfelseif rsColumnas.RHTBDFcapturaA eq 5 and rsColumnas.RHTBDFcapturaB neq 5>
								<cfset lvarValorA = rsDetalle.RHDCBid>
								<cfset lvarValorB = rsDetalle.RHDBEvalor>
							<cfelseif rsColumnas.RHTBDFcapturaA neq 5 and rsColumnas.RHTBDFcapturaB neq 5>
								<cfset lvarValorA = ListGetAt(rsDetalle.RHDBEvalor,1,'##')>
								<cfset lvarValorB = ListGetAt(rsDetalle.RHDBEvalor,2,'##')>
							<cfelseif rsColumnas.RHTBDFcapturaA neq 5 and rsColumnas.RHTBDFcapturaB eq 5>
								<cfset lvarValorA = rsDetalle.RHDBEvalor>
								<cfset lvarValorB = rsDetalle.RHDCBid>
							</cfif>
							<cfset valorA = fnGetValor(rsColumnas.RHTBDFcapturaA,lvarValorA)>
							<cfset valorB = fnGetValor(iif(len(trim(rsColumnas.RHTBDFcapturaB)) gt 0,rsColumnas.RHTBDFcapturaB,-1),lvarValorB)>
						<cfelse>
							<cfset valorA = "">
							<cfset valorB = "">
						</cfif>
						
							
						<cfif PintarDescripcionColumnas EQ 1>	
						<tr><td >
						<br>
							<b><u>#RHTBEFdescripcion#</u></b>	
						<br>
						</td></tr>
						</cfif>	
						<tr>
						<td style="width:45%" align="left">	<b>#RHTBDFetiqueta#:</b></td>
						<td style="width:55%" colspan="3" align="left">#valorA#<cfif len(trim(valorB)) gt 0>&nbsp;&nbsp;#valorB#</cfif></td>
						</tr>
                    </cfloop>
					</table>
					</td>
					</tr>		
				</cfif> 	
			<!------------------------------------------------------------ B E N E F I C I O S -------------------------------------->
				<tr>
				<th colspan="3" align="center"  ><strong>BENEFICIOS</strong></th>	
				</tr>	
					
					<tr><!--- 6da fila---><!--- DETALLES   ------------------------------------>
						<th class="subtitulo" align="left" >BENEFICIOS SOLICITADOS:</th>
						<th class="subtitulo" align="left" >SOLICITADO</th>
						<th class="subtitulo" align="left">OTORGADO</th>
					</tr>
                    	<cfquery name="rsBeneficios" datasource="#session.dsn#">
                            select RHTBDFid,RHTBDFetiqueta, RHTBDFcapturaA, RHTBDFcapturaB
                            from RHTipoBecaEFormatos eb
                                inner join RHTipoBecaDFormatos db
                                    on db.RHTBEFid = eb.RHTBEFid
                            where eb.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHTBid#">
                              and db.RHTBDFreporte in (1,3)
                              and db.RHTBDFbeneficio = 1
                        </cfquery>
						
                        <cfloop query="rsBeneficios"><!--- recorre los beneficios que se agregan y son declarados en formato como beneficios---->
                        	 
							  <cfquery name="rsDetalleB" datasource="#session.dsn#">
                                select RHDCBid, RHDBEvalor
                                from RHDBecasEmpleado
                                where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBeneficios.RHTBDFid#">
                                  and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                                  and RHDBEversion = 0
                            </cfquery>
                            <cfif rsBeneficios.RHTBDFcapturaA neq 5 and len(trim(rsBeneficios.RHTBDFcapturaB)) eq 0>
								<cfset lvarValorA = rsDetalleB.RHDBEvalor>
                                <cfset lvarValorB = "">
                            <cfelseif rsBeneficios.RHTBDFcapturaA eq 5 and len(trim(rsBeneficios.RHTBDFcapturaB)) eq 0>
                                <cfset lvarValorA = rsDetalleB.RHDCBid>
                                <cfset lvarValorB = "">
                            <cfelseif rsBeneficios.RHTBDFcapturaA eq 5 and rsBeneficios.RHTBDFcapturaB neq 5>
                                <cfset lvarValorA = rsDetalleB.RHDCBid>
                                <cfset lvarValorB = rsDetalleB.RHDBEvalor>
                            <cfelseif rsBeneficios.RHTBDFcapturaA neq 5 and rsBeneficios.RHTBDFcapturaB neq 5>
                                <cfset lvarValorA = ListGetAt(rsDetalleB.RHDBEvalor,1,'##')>
                                <cfset lvarValorB = ListGetAt(rsDetalleB.RHDBEvalor,2,'##')>
                            <cfelseif rsBeneficios.RHTBDFcapturaA neq 5 and rsBeneficios.RHTBDFcapturaB eq 5>
                                <cfset lvarValorA = rsDetalleB.RHDBEvalor>
                                <cfset lvarValorB = rsDetalleB.RHDCBid>
                            </cfif>
                            <cfset valorAantes = fnGetValor(rsBeneficios.RHTBDFcapturaA,lvarValorA)>
                            <cfset valorBantes = fnGetValor(iif(len(trim(rsBeneficios.RHTBDFcapturaB)) gt 0,rsBeneficios.RHTBDFcapturaB,-1),lvarValorB)>
							 
							 <cfquery name="rsDetalleB" datasource="#session.dsn#">
                                select RHDCBid, RHDBEvalor
                                from RHDBecasEmpleado
                                where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBeneficios.RHTBDFid#">
                                  and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">
                                  and RHDBEversion = 1
                            </cfquery>
                            <cfif rsBeneficios.RHTBDFcapturaA neq 5 and len(trim(rsBeneficios.RHTBDFcapturaB)) eq 0>
								<cfset lvarValorA = rsDetalleB.RHDBEvalor>
                                <cfset lvarValorB = "">
                            <cfelseif rsBeneficios.RHTBDFcapturaA eq 5 and len(trim(rsBeneficios.RHTBDFcapturaB)) eq 0>
                                <cfset lvarValorA = rsDetalleB.RHDCBid>
                                <cfset lvarValorB = "">
                            <cfelseif rsBeneficios.RHTBDFcapturaA eq 5 and rsBeneficios.RHTBDFcapturaB neq 5>
                                <cfset lvarValorA = rsDetalleB.RHDCBid>
                                <cfset lvarValorB = rsDetalleB.RHDBEvalor>
                            <cfelseif rsBeneficios.RHTBDFcapturaA neq 5 and rsBeneficios.RHTBDFcapturaB neq 5>
                                <cfset lvarValorA = ListGetAt(rsDetalleB.RHDBEvalor,1,'##')>
                                <cfset lvarValorB = ListGetAt(rsDetalleB.RHDBEvalor,2,'##')>
                            <cfelseif rsBeneficios.RHTBDFcapturaA neq 5 and rsBeneficios.RHTBDFcapturaB eq 5>
                                <cfset lvarValorA = rsDetalleB.RHDBEvalor>
                                <cfset lvarValorB = rsDetalleB.RHDCBid>
                            </cfif>
                            <cfset valorA = fnGetValor(rsBeneficios.RHTBDFcapturaA,lvarValorA)>
                            <cfset valorB = fnGetValor(iif(len(trim(rsBeneficios.RHTBDFcapturaB)) gt 0,rsBeneficios.RHTBDFcapturaB,-1),lvarValorB)>
							
                            <cfif len(trim(valorA)) LT 1 or ucase(trim(valorA)) EQ "NULL" ><!--- limpia variable--->
                            	<cfset valorA="NO">
                            </cfif>
                            <cfif len(trim(valorAantes)) LT 1 or ucase(trim(valorAantes)) EQ "NULL" >
                            	<cfset valorAantes="NO">
                            </cfif>
                            <cfif len(trim(valorB)) LT 1 or ucase(trim(valorB)) EQ "NULL" >
                            	<cfset valorB="NO">
                            </cfif>
                            <cfif len(trim(valorBantes)) LT 1 or ucase(trim(valorBantes)) EQ "NULL" >
                            	<cfset valorBantes="NO">
                            </cfif>
                            
							<tr><!--- detalle  de solicitado y otorgado de los beneficios--->
					   			<td class="campos" align="left">  
								#rsBeneficios.RHTBDFetiqueta#
							 	</td>
							 	<td class="campos" align="left">
                                    #valorAantes# (#valorBantes#)
								 </td>
								 <td  class="campos" align="left">
									<cfif  len(trim(valorB)) GT 0>
										#valorA# (#valorB#)
									<cfelse>
										NO	
									</cfif>
							  	 </td>
                       		 </tr>
                        </cfloop>
						
						
                        <cfquery name="rsBenConceptos" datasource="#session.dsn#">
							SELECT db.RHDCBid,RHECBdescripcion, RHDCBdescripcion, RHDBEvalor, RHDCBtipo 
							
							FROM  RHDBecasEmpleado db 
								inner join RHDConceptosBeca dc 
									on dc.RHDCBid = db.RHDCBid 
								inner join RHEConceptosBeca ec
									on ec.RHECBid = dc.RHECBid
							
							WHERE db.RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#"> 
								and db.RHTBDFid is null 
								and ec.RHECBbeneficio = 1 
								and RHDBEversion=0
                        </cfquery>
						
                        <cfloop query="rsBenConceptos">
						
								<cfquery name="rsOtorgado" datasource="#session.dsn#">
								SELECT RHDBEvalor, RHDCBtipo,RHDCBdescripcion
								FROM  RHDBecasEmpleado db 
									inner join RHDConceptosBeca dc 
										on dc.RHDCBid = db.RHDCBid 
									inner join RHEConceptosBeca ec
										on ec.RHECBid = dc.RHECBid
								
								WHERE db.RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#">  
									and db.RHTBDFid is null 
									and ec.RHECBbeneficio = 1 
									and RHDBEversion=1
									and db.RHDCBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBenConceptos.RHDCBid#"> 
								</cfquery>

                        	<cfset valorSolicitud = "">
							<cfset valorOtorgado="">
							
          	              	<cfif  rsBenConceptos.RHDCBtipo eq 2> <!---convierte el valor solicitado--->
                            	<cfset valorSolicitud = fnGetValor(rsBenConceptos.RHDCBtipo,rsBenConceptos.RHDBEvalor)>
                            </cfif>
							
							<cfif rsOtorgado.recordcount GT 0>
								<cfif rsOtorgado.RHDCBtipo eq 2><!--- convierte el valor de los aceptados--->
									<cfset valorOtorgado = fnGetValor(rsOtorgado.RHDCBtipo,rsOtorgado.RHDBEvalor)>
								</cfif>
							</cfif>
						<tr><!--- detalle  de solicitado y otorgado de los beneficios--->
					   		<td class="campos" >  
                        	 		#rsBenConceptos.RHECBdescripcion# <cfif rsBenConceptos.RHDCBtipo neq 0>(#rsBenConceptos.RHDCBdescripcion#)</cfif>
							 </td>
							 <td class="campos" align="left">
							 		<cfif len(trim(valorSolicitud)) GT 0>
							 			#valorSolicitud#	
									<cfelse>
										<cfif rsBenConceptos.RHDCBtipo neq 0>
										#rsBenConceptos.RHDBEvalor#
										<cfelse>
										#rsBenConceptos.RHDCBdescripcion#
										</cfif>
									</cfif>
							 </td>
							 <td  class="campos" align="left">
							 <cfif rsOtorgado.recordcount GT 0><!--- si la consulta devuelve datos--->
									<cfif  len(trim(valorOtorgado) ) GT 0><!--- Si el valor calculado devuelve algun valor--->
							 			#valorOtorgado#
									<cfelse>
										<cfif rsOtorgado.RHDCBtipo NEQ 0><!--- pare evitar que se muestra los que estan null---->
											#rsOtorgado.RHDBEvalor#
										<cfelse>
											#rsOtorgado.RHDCBdescripcion#
										</cfif>
									</cfif>
							<cfelse>
										NO		
							</cfif>			
							 </td>
						</tr>
                        </cfloop>
						
					<!--- detalle de la jefatura y del comite--------------------------------------------------------------------------------------------------->	
					<cfquery name="rsAgregados" datasource="#session.dsn#">
						SELECT RHEBEusuarioAJef , RHEBEfechaJef, RHEBEsesionJef, RHEBEarticuloJef,
									RHEBEusuarioACom,RHEBEfechaCom, RHEBEsesionCom,RHEBEarticuloCom
						FROM RHEBecasEmpleado rhe
						WHERE RHEBEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezados.RHEBEid#"> 
					</cfquery>	
					
					<cfif rsAgregados.recordcount GT 0>
						<!--- tabla de  DETALLES EXTRA--->
					<tr>
					<td colspan="3">	
							<table width="100%">
								<tr>
									<th></th>
									<th align="left">NOMBRE</th>
									<th align="left">FECHA</th>
									<th align="left">SESI&Oacute;N</th>
									<th align="left">ART&Iacute;CULO</th>
								</tr>
								<tr>
									<td  align="left"><strong>JEFATURA</strong></td>
									<td class="campos" align="left">#fnGetEmp(rsAgregados.RHEBEusuarioAJef)#</td>
									<td class="campos" align="left"> #LsDateFormat(rsAgregados.RHEBEfechaJef,"dd/mmm/yyyy")#</td>
									<td class="campos" align="left">#rsAgregados.RHEBEsesionJef#</td>
									<td class="campos" align="left">#rsAgregados.RHEBEarticuloJef#</td>
								</tr>
								<!--- 8da fila DETALLES EXTRA COMITE--->
								<tr>
									<th align="left"><strong>COMITE</strong> </th>	
									<td class="campos"  align="left">#fnGetEmp(rsAgregados.RHEBEusuarioACom)#</td>
									<td class="campos"  align="left">#LsDateFormat(rsAgregados.RHEBEfechaCom,"dd/mmm/yyyy")#</td>
									<td class="campos"  align="left">#rsAgregados.RHEBEsesionCom#</td>
									<td  class="campos" align="left">#rsAgregados.RHEBEarticuloCom#</td>
								</tr>
								</table>
								</td>
								</tr>
								</cfif><!--- fin de la descripcion de la jefatura y el comite------------------------------------------------------------------------------>	
						</table>  	
			<table height="150" align="center">
			<td>&nbsp;</td>
			<td align="center">-----------------------------------------------</td>
			</table>
	  	  </cfloop>

<table align="center">
	<tr><td>&nbsp;</td></tr>	
    <tr>
    	<td class="columnas" colspan="3"><b>Total de Becas: #rsEncabezados.recordcount#</b></td>
    </tr>
</table>
</cfoutput>
</body>
</html>

<cffunction name="fnGetValor" access="private" returntype="string">
	<cfargument name="Captura" 	type="numeric" 	required="yes">
    <cfargument name="Valor"   	type="string" 	required="yes">

	<cfif Arguments.Captura eq 1>
   		<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 2>
		<cfset lvarMonto = ListGetAt(Arguments.Valor,1,'|')>
        <cfset lvarMcodigo = ListGetAt(Arguments.Valor,2,'|')>
        <cfquery name="rsMoneda" datasource="#session.dsn#">
            select Mcodigo, Miso4217
            from Monedas
            where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMcodigo#">
        </cfquery>
      	<cfreturn "#rsMoneda.Miso4217#&nbsp;#numberFormat(lvarMonto,',9.99')#">
    <cfelseif Arguments.Captura eq 3>
    	<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 4>
    	<cfreturn Arguments.Valor>
    <cfelseif Arguments.Captura eq 5 and len(trim(#Arguments.Valor#)) gt 0>
        <cfquery name="rsConcepto" datasource="#session.dsn#">
            select RHDCBdescripcion
            from RHDConceptosBeca
            where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Valor#">
        </cfquery>
        <cfreturn rsConcepto.RHDCBdescripcion>
    <cfelse>
    	<cfreturn "">
    </cfif>
</cffunction>

<cffunction name="fnGetEmp" access="private" returntype="string"><!--- obtiene el nombre del empleado a partir del Usucodigo---->
    <cfargument name="Usucodigo"   	type="string" 	required="yes">
			<cfquery name="rsReferencia" datasource="asp">
				select llave
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
			</cfquery>
				<cf_dbfunction name="OP_concat" returnvariable="_Cat">
			<cfquery name="rsEmpleado" datasource="#session.dsn#">
			SELECT DEnombre #_Cat#' '#_Cat# DEapellido1 #_Cat#' '#_Cat#DEapellido2 as nombreEmp
			FROM DatosEmpleado 
			WHERE Ecodigo=#session.Ecodigo#
			and DEid=#rsReferencia.llave#
			</cfquery>
      	<cfreturn #rsEmpleado.nombreEmp#>
</cffunction>