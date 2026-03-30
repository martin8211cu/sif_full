<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Semanal" 		 Default="Semanal" 				returnvariable="LB_Semanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Bisemanal" 		 Default="Bisemanal" 			returnvariable="LB_Bisemanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Quincenal" 		 Default="Quincenal" 			returnvariable="LB_Quincenal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AJUSTE" 			 Default="AJUSTE" 				returnvariable="LB_AJUSTE"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEVOLUCION" 		 Default="DEVOLUCION" 			returnvariable="LB_DEVOLUCION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RegistroPatronal" Default="Registro Patronal" 	returnvariable="LB_RegistroPatronal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Días" 			 Default="Días" 				returnvariable="LB_Días"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" 		 Default="Periodo" 				returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Faltas" 		 	 Default="Faltas" 				returnvariable="LB_Faltas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDir" 		 	 Default="Salario Diario" 		returnvariable="LB_SalDir"/>

<cfquery datasource="#session.dsn#" name="rsEmpresa">
	select b.direccion1, b.direccion2, b.ciudad, b.estado, a.Eidentificacion , b.codPostal, a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
      from Empresa a
	    inner join Direcciones b
		  on a.id_direccion = b.id_direccion
	 where a.Ecodigo = #session.Ecodigosdc#
</cfquery>

<cfset lineaslleva 	= 0>	<!---Lineas por boleta--->
<cfset lineaspagina = 0>	<!---Lineas por pagina--->
<cfset boletas 		= 1>	<!---Total de paginas de todo--->

<cfquery dbtype="query" name="ConceptosPagoEspecieTodos">
    select * from ConceptosPago
    where especie = 1
</cfquery>

<cfquery dbtype="query" name="ConceptosPago">
	select * from ConceptosPago
    where especie = 0
    order by DEid, Columna, Linea
</cfquery>

<cfsavecontent variable="DETALLE">

	<cfif ConceptosPago.RecordCount NEQ 0>
		<cfoutput query="ConceptosPago" group="DEid">
        
            <cfquery dbtype="query" name="ConceptosPagoEspecie">
                select * from ConceptosPagoEspecieTodos
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
            </cfquery>
            
            <!---Si existen cargas que deben mostrarse en forma resumida se sumarizan. CarolRS--->
            <cfquery dbtype="query" name="CargasResumidas">
                select resumeCargasDesc as descconceptoB,sum(montoconceptoB) as montoconceptoB
                from ConceptosPago
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
                and resumeCargas = 1
                group by resumeCargasDesc
            </cfquery>
            
            <cfquery name="rsEmpleado" datasource="#session.DSN#">
                select <cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre"> as empleado, coalesce(de.RFC,'No definido') RFC,coalesce(de.CURP,'No definido') CURP,
                       de.DEidentificacion, coalesce(DLTmonto,0) as MtoSalario
                from DatosEmpleado de
                    inner join LineaTiempo lt
                        on de.DEid = lt.DEid
                        and de.Ecodigo = lt.Ecodigo
                     inner join DLineaTiempo b
                        on  lt.LTid = b.LTid
                    inner join ComponentesSalariales c
                        on b.CSid = c.CSid
                        and CSsalariobase = 1
                where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
                  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  <!---and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPago.desdenomina#">   between lt.LTdesde and lt.LThasta--->
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPago.desdenomina#"> <= lt.LThasta
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPago.hastanomina#"> >= lt.LTdesde
            </cfquery>
            
            <!---SML. Modificacion para que se obtenga la informacion de los trabajadores que estan dados de Baja--->
            <cfif isdefined('rsEmpleado') and rsEmpleado.RecordCount EQ 0>
            <cfquery name="rsEmpleado" datasource="#session.DSN#">
                select top 1 <cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre"> as empleado, coalesce(de.RFC,'No definido') RFC,coalesce(de.CURP,'No definido') CURP,
                       de.DEidentificacion, coalesce(DLTmonto,0) as MtoSalario
                from DatosEmpleado de
                    inner join LineaTiempo lt
                        on de.DEid = lt.DEid
                        and de.Ecodigo = lt.Ecodigo
                     inner join DLineaTiempo b
                        on  lt.LTid = b.LTid
                    inner join ComponentesSalariales c
                        on b.CSid = c.CSid
                        and CSsalariobase = 1
                where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
                  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  order by lt.LTid desc
            </cfquery>
            </cfif>
            <!---SML. Modificacion para que se obtenga la informacion de los trabajadores que estan dados de Baja--->
            
            <cfquery datasource="#session.dsn#" name="rsDatosG">
                select a.CPcodigo, a.CPdesde, a.CPhasta , case b.Ttipopago when 0 then 'Semana' when 1 then 'Bisemana' when 2 then 'Quincena' when 3 then 'mes' else 'otro' end as tipo,
                d.DESeguroSocial,
                coalesce((select sum(PEcantdias) from HPagosEmpleado e where e.RCNid = a.CPid and e.DEid = #ConceptosPago.DEid#  and e.PEtiporeg = 0),0) as  Dias
                from CalendarioPagos a
                inner join TiposNomina b
                    on a.Tcodigo = b.Tcodigo
                    and a.Ecodigo = b.Ecodigo
                inner join HSalarioEmpleado c
                    on c.RCNid = a.CPid 
                    and c.DEid = #ConceptosPago.DEid#
                inner join DatosEmpleado d
                    on d.DEid = c.DEid
                where CPid = #form.CPid#
            </cfquery>
            

            
            <cfquery datasource="#session.dsn#" name="RsFaltas">
                select (coalesce(sum(PEcantdias),0) * (d.RHTfactorfalta))  as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPago.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
                    and d.RHTcomportam = 13
                    group by a.DEid, d.RHTfactorfalta
            </cfquery>
            
            <cfquery datasource="#session.dsn#" name="RsIncap">
                select (coalesce(sum(PEcantdias),0))  as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPago.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
                    and d.RHTcomportam = 5
                    group by a.DEid, d.RHTfactorfalta
            </cfquery>
            
            <cfquery datasource="#session.dsn#" name="RsDias">
                select coalesce(sum(PEcantdias),0) as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPago.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
            </cfquery>
            
            <cfif RsIncap.RecordCount>
                <cfset DiasRebajo = #lsnumberformat(RsIncap.PEcantdias,'99.999')#>
            <cfelse>
                <cfset DiasRebajo = 0>
            </cfif>
            
            <cfif RsFaltas.RecordCount>
                <cfset DiasRebajo = DiasRebajo + #lsnumberformat(RsFaltas.PEcantdias,'99.999')#>
            </cfif>
        
            <cfif #DiasRebajo# GT 0 >
                <cfset DiasFaltas = #lsnumberformat(DiasRebajo,'99.999')# & ' Dias'>
            <cfelse>
                <cfset DiasFaltas = '0 Dias'>
            </cfif>
    		
    		<cfif len(trim(rsEmpleado.MtoSalario)) GT 0> <!---SML. Modificacion para que se muestren a los trabajadores que estan dados de baja--->
				<cfset SalarioDiario 	= (rsEmpleado.MtoSalario/30)>
            <cfelse>
            	<cfset SalarioDiario = 0>
            </cfif>     <!---SML. Modificacion para que se muestren a los trabajadores que estan dados de baja--->
            
            
            <cfset rsde    			= ListToArray(rsDatosG.CPcodigo,'-')>
            <cfset LvarPeriodo      = rsde[2]>
            
                        
            <cfif #DiasRebajo# GT 0>
                <cfset LvarDias 		= RsDias.PEcantdias  - DiasRebajo>
            <cfelse>
                <cfset LvarDias 		= RsDias.PEcantdias >
            </cfif>
            
            <!---SML Modificacion para que se refleje el acumulado del Fondo de Ahorro--->
            <cfset montoAnterior = 0>
            <cfquery name="rsFAhorro" datasource="#session.DSN#">
            	 select top(1) FAEstatusFini
 				 from RHHFondoAhorro
 				 where DEid = #ConceptosPago.DEid#
					and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
 				order by HFAid desc
            </cfquery>
            
            <cfif isdefined('rsFAhorro') and rsFAhorro.FAEstatusFini EQ 1>
            	<cfset montoAnterior = 0>
            <cfelse>
            	<cfquery name="rsFAhorroFin" datasource="#session.DSN#">
                	select top(1) HFAid
 					from RHHFondoAhorro
 					where DEid = #ConceptosPago.DEid#
						and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
						and FAEstatusFini = 1
 					order by HFAid desc
            	</cfquery>
                
                <cfif isdefined('rsFAhorroFin') and rsFAhorroFin.RecordCount GT 0>
                	<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                	select coalesce(SUM(FAmonto),0) as FAanterior
					from RHHFondoAhorro
					where DEid = #ConceptosPago.DEid# 
                    	and HFAid > #rsFAhorroFin.HFAid#
						and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
            		</cfquery>
                    <cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                <cfelse> <!---Empieza las validaciones para Cierre de FOA --->
                	<cfquery  name="rsFAhorro" datasource="#session.DSN#">
            	 		select top(1) FAEstatusCierre
 				 		from RHHFondoAhorro
 				 		where DEid = #ConceptosPago.DEid#
							and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 						 where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
 						order by HFAid desc
            		</cfquery>

                    <cfif isdefined('rsFAhorro') and rsFAhorro.FAEstatusCierre EQ 1>
                    		<cfset montoAnterior =0> 
            		<cfelse>
            			<cfquery name="rsFAhorroCier" datasource="#session.DSN#">
                			select top(1) HFAid
 							from RHHFondoAhorro
 							where DEid = #ConceptosPago.DEid#
							  and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
							and FAEstatusCierre = 1
 							order by HFAid desc
            		   </cfquery>
                
                		<cfif isdefined('rsFAhorroCier') and rsFAhorroCier.RecordCount GT 0>
                			<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                				select coalesce(SUM(FAmonto),0) as FAanterior
								from RHHFondoAhorro
								where DEid = #ConceptosPago.DEid# 
								and FAEstatus = 0
								and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
            				</cfquery>
                    		<cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                         <cfelse>
                         	<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                				select coalesce(SUM(FAmonto),0) as FAanterior
								from RHHFondoAhorro
								where DEid = #ConceptosPago.DEid# 
								<!---and FAEstatus = 0--->
								and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPago.DEid#)
            				</cfquery>
                    		<cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                        </cfif>  
                    </cfif>              	
                </cfif>	
            </cfif>
                      
            <cfquery name="rsFAhorro" datasource="#session.DSN#">
            	select coalesce(SUM(FAmonto),0) as FAactual
				from RHHFondoAhorro
				where RCNid in (#form.CPid#)
					and DEid = #ConceptosPago.DEid# 
					<!---and FAEstatus = 0--->
            </cfquery>
            
           
			<cfset LvarRandoPeriodo = '#rsDatosG.tipo# del #dateformat(rsDatosG.CPdesde,'DD/MM/YYYY')# al #dateformat(rsDatosG.CPhasta,'DD/MM/YYYY')#'>
            <cfset LvarCSS     	    = rsDatosG.DESeguroSocial>

            <cfset lineasEmp 	  		= ConceptosPago.lineasEmp>
            <cfset vs_nomina 	  		= ConceptosPago.nomina>
            <cfset vs_desdenomina 		= ConceptosPago.desdenomina>
            <cfset vs_hastanomina 		= ConceptosPago.hastanomina>			
            <cfset vs_empleado 			= rsEmpleado.empleado>
            <cfset vs_RFC 			    = rsEmpleado.RFC>
            <cfset vs_CURP 				= rsEmpleado.CURP>
            <cfset vs_DEidentificacion 	= rsEmpleado.DEidentificacion>
            <cfset vs_cuenta 			= ConceptosPago.cuenta>
            <cfset vs_departamento 		= ConceptosPago.departamento>
            <cfset vs_puntoventa 		= ConceptosPago.puntoventa>
            <cfset vs_devengado 		= ConceptosPago.devengado>
            <cfset vs_deducido	 		= ConceptosPago.deducido>
            <cfset vs_neto 				= ConceptosPago.neto>
            <cfset vs_etiquetacta 		= ConceptosPago.EtiquetaCuenta>
        
			<cfsavecontent variable="Encabezado">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr><td>&nbsp;</td></tr>
                    <tr style="font-size:12px">
                    <!---????Corporacion e imagen????--->
						<!--- se elimina por peticion de cliente en mexico ljimenez
						<td colspan="2" ><strong>#session.CEnombre#</strong></td>--->
                        <td colspan="2"></td>
						<!---
						
						<td rowspan="6" align="right" valign="middle"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
						--->
						<td rowspan="6" align="right" valign="middle"><img src="../../../home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#" height="60" border="0"></td>
					</tr>
                    <!---????Empresa y Direcciones????--->
                    <tr style="font-size:12px"><td colspan="2"><strong>#session.Enombre#</strong></td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion1#</td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion2#</td></tr>
                    <!---????Ciudad, codigo Postal, Telefono y Fax????--->
                    <tr style="font-size:9px">
                    	<td colspan="2" class="td12">
							<cfif LEN(rsEmpresa.ciudad)>#rsEmpresa.ciudad#, #rsEmpresa.Estado#</cfif>
                            <cfif LEN(rsEmpresa.codPostal)>,C.P. #rsEmpresa.codPostal#</cfif>
                            <cfif LEN(rsEmpresa.Etelefono1)>,Tel. #rsEmpresa.Etelefono1#</cfif>
                            <cfif LEN(rsEmpresa.Efax)>,Fax. #rsEmpresa.Efax#</cfif>
                    	</td>
                    </tr>
                     <!---????RFC y Registro Patronal????--->
                    <tr style="font-size:9px">
                    	<td colspan="2">
                        	<cfif LEN(rsEmpresa.Eidentificacion)>R.F.C. #rsEmpresa.Eidentificacion#&nbsp;</cfif>
                            <cfif LEN(rsEmpresa.Enumlicencia)>#LB_RegistroPatronal#: #rsEmpresa.Enumlicencia#</cfif>
                        </td>
                    </tr>
                    <tr><td colspan="3" style="font-size:9px">&nbsp;</td></tr>
                    <tr>
                    	<td colspan="3">
                      <!---????Datos del Empleado????--->
                        	<table border="0" cellpadding="0" cellspacing="1" align="left" style="font-size:12px">
                            	<tr>
                                	<td>&nbsp;</td>
                                    <td colspan="10">#vs_DEidentificacion#&nbsp;#vs_empleado#</td>
                                </tr>
                                <tr> 
                                	<td>&nbsp;</td>  
                                    <td>CURP:&nbsp;</td><td>#vs_CURP#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Días#:&nbsp;</td><td>#LSnumberformat(LvarDias,'999.999')#</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Periodo#&nbsp;</td><td>#LvarPeriodo#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LvarRandoPeriodo#</td>
                                    <td>&nbsp;</td>
                                </tr>
                                 <tr> 
                                	<td>&nbsp;</td>  
                                    <td>R.F.C.:&nbsp;</td><td>#vs_RFC#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Faltas#:&nbsp;</td><td>#DiasFaltas#</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_SalDir#:</td> <td>#LSNumberFormat(SalarioDiario,'999,999,999,999,999.99')#</td>
                                    <td>&nbsp;</td>  
                                    <td>NSS:&nbsp;&nbsp;#LvarCSS#&nbsp;</td>
                                </tr>
                            </table>
                    	</td>
                    </tr>
				</table>
			</cfsavecontent>
            
			<cfset iniciopagina = false> 
			<cfset continuar    = true>
			<cfset x            = boletas mod 2>
           <table width="98%" cellpadding="0" cellspacing="0" border="0">	
			<!---ENCABEZADO--->	
			
			<cfif x EQ 0 and boletas GT 2>
				<tr><td height="50px">&nbsp;</td></tr>	
			</cfif>
            				
			<tr><td colspan="7">#Encabezado#</td></tr>
			<cfset lineaslleva = 11>	<!----Lineas del encabezado---->
			<cfset lineaspagina = lineaspagina+lineaslleva>	
			<cfset boletas = boletas+1>	

			<!---CICLO DE CONCEPTOS---->
			<cfset CONTADOR = 1><!---Cantidad de conceptos por boleta--->
            <cfset LvarTotalPercepciones = 0>
            <cfset LvarTotalDeducciones  = 0>
			<cfset displayCargasResumidas = 0> <!---Pintado de Cargas Resumidas. Indicador para saber si las cargas resumidas ya fureon pintadas en el reporte para un empleado en especifico. CarolRS--->
			<cfoutput>
				<cfif CONTADOR EQ 1>					
				<!---????Titulo Percepciones y Deducciones (En la primera linea del detalle se pinta el encabezado-labels del mismo)????--->
                    <tr style="font-size:12px">
						<td valign="top" style="background:##CCC;" colspan="3" align="center">
							<cf_translate  key="LB_PERCEPCIONES">PERCEPCIONES</cf_translate>
						</td>
						<td valign="top" style="background:##CCC;" colspan="3" align="center">
                        	<cf_translate  key="LB_DEDUCCIONES">DEDUCCIONES</cf_translate>
                         </td>
					</tr>
				</cfif>	
				
				<cfif len(trim(ConceptosPago.descconcepto))  
					OR ConceptosPago.resumeCargas EQ 0  
					OR ( displayCargasResumidas EQ 0 and CargasResumidas.recordCount gt 0 )>
					
				<tr style="font-size:10px"> 
					<!---????Cantidad Percepcion????--->		
                	<td valign="top" nowrap align="center">
						<cfif trim(ConceptosPago.descconcepto) NEQ 'RETROACTIVOS'>						
							<cfif len(trim(cantconcepto)) and cantconcepto GT 0>#LSNumberFormat(cantconcepto,'999.99')#<cfelse>&nbsp;</cfif>
						<cfelse>
							&nbsp;
						</cfif>	
					</td>
		 			<!---????Descripción Percepcion????--->		
					<td valign="top" nowrap>
						<cfif trim(ConceptosPago.descconcepto) EQ 'RETROACTIVOS'>
							<cfset ConceptosPago.descconcepto = '#LB_AJUSTE# #ConceptosPago.descconcepto#'>
						</cfif>
						<cfif len(trim(descconcepto))>
							<cfif len(descconcepto) GT 23>
								#Mid(descconcepto, 1, 23)#
							<cfelse>
								#descconcepto#
							</cfif>								
						<cfelse>&nbsp;</cfif>
					</td>
					<!---????Total Percepcion????--->	
					<td valign="top" style="text-align:right">
					<cfif ConceptosPago.montoconcepto NEQ 0 and len(trim(ConceptosPago.descconcepto)) NEQ 0>
                        #LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#		
                        <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPago.montoconcepto	>				
                    <cfelseif len(trim(ConceptosPago.descconcepto)) NEQ 0>
                        #LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#
                        <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPago.montoconcepto	>	
                    <cfelse>
                        &nbsp;
                    </cfif>	
					</td>
                    <!---????Cantidad Deduccion????--->
					<td>&nbsp;</td>
					<!---????Descripción Deduccion????--->	
					
					<cfif ConceptosPago.resumeCargas EQ 0> <!---si hay cargas resumidas, se separan de las no resumidas--->
						<td valign="top" nowrap="nowrap">	
							<cfif len(trim(ConceptosPago.montoconceptoB)) NEQ 0 and trim(ConceptosPago.montoconceptoB) LT 0 >
								<cfset ConceptosPago.descconceptoB = '#ConceptosPago.descconceptoB#'><!--- #LB_DEVOLUCION#--->
							</cfif>						
							<cfif len(trim(ConceptosPago.descconceptoB))>
								<cfif len(ConceptosPago.descconceptoB) GT 29>
									#Mid(ConceptosPago.descconceptoB, 1, 29)#
								<cfelse>
									#ConceptosPago.descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<!---????Total Deduccion????--->	
						<td valign="top" style="text-align:right">
							<cfif ConceptosPago.montoconceptoB NEQ 0 and len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#	
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	ConceptosPago.montoconceptoB>			
							<cfelseif len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	ConceptosPago.montoconceptoB>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					
					<cfelseif displayCargasResumidas EQ 0 and CargasResumidas.recordCount gt 0>	<!---Si no se han pintado aun cargas resumidas y existen cargas resumidas por pintar. CarolRS--->
						
						<!---Descripción Deduccion--->	
						<td valign="top" nowrap="nowrap">					
							<cfif len(trim(CargasResumidas.montoconceptoB)) NEQ 0 and trim(CargasResumidas.montoconceptoB) LT 0 >
								<cfset CargasResumidas.descconceptoB = '#CargasResumidas.descconceptoB#'> <!---#LB_DEVOLUCION#--->
							</cfif>						
							<cfif len(trim(CargasResumidas.descconceptoB))>
								<cfif len(CargasResumidas.descconceptoB) GT 29>
									#Mid(CargasResumidas.descconceptoB, 1, 29)#
								<cfelse>
									#CargasResumidas.descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<!---Total Deduccion--->	
						<td valign="top" style="text-align:right">
							<cfif CargasResumidas.montoconceptoB NEQ 0 and len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#	
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	CargasResumidas.montoconceptoB>			
							<cfelseif len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	CargasResumidas.montoconceptoB>
							<cfelse>
								&nbsp;
							</cfif>
						</td>	
						<cfset displayCargasResumidas = 1> <!---Indica que las cargas resumidas para el empleado ya fueron pintadas para que no se pienten nuevamente. CarolRS--->
					</cfif>
				</tr>	
                </cfif>
                
				<!---Si son mas de 11 conceptos colocarlos en otra boleta, hacer corte---->
                <cfif vb_pagebreak>
                    <cfif CONTADOR GTE 13>
                        <!----ETIQUETA DEL PIE DE PAGINA ---->
                        <tr><td>&nbsp;</td></tr>
                        <cfif len(trim(rsEtiquetaPie.Mensaje)) GT 250>		
                            <tr><td colspan="7" width="950" nowrap="nowrap">#Mid(rsEtiquetaPie.Mensaje,1,250)#</td></tr>
                        <cfelse>
                            <tr>
                                <td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
                            </tr>
                        </cfif>	
                        <cfset lineaslleva = lineaslleva+5>
                        <cfset lineaspagina = lineaspagina+5>

                        <cfif lineaspagina GTE 46>
                            <tr><td style="page-break-before:always;"></td></tr>
                            <cfset lineaspagina = 0>		
                            <cfset iniciopagina = true>
                        <cfelse>		
                            <cfif lineaslleva  LT 23 and lineaspagina GT 1>
                                <cfset vn_hasta = 23-lineaslleva>					
                                <cfloop index="i" from="1" to="#vn_hasta#">
                                    <cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
                                        <tr><td style="page-break-before:always;"></td></tr>
                                        <cfset iniciopagina = true>
                                        <cfset lineaspagina = 0>
                                        <cfbreak>
                                    </cfif>
                                    <tr><td>&nbsp;</td></tr>
                                    <cfset lineaspagina = lineaspagina+1>
                                </cfloop>				
                            </cfif>
                        </cfif>	
                        <cfif CONTADOR NEQ lineasEmp>
                            <cfset CONTADOR = 0>		
                            <cfset x = boletas mod 2>
                            <cfif x EQ 0 and boletas GT 2>
                                <tr><td height="40px">&nbsp;</td></tr>	
                            </cfif>
                            <tr><td colspan="7">#Encabezado#</td></tr>
                            <cfset lineaslleva = 9>
                            <cfset lineaspagina = lineaspagina+lineaslleva>
                            <cfset boletas = boletas+1>	
                        <cfelseif CONTADOR EQ lineasEmp>
                            <cfset continuar = false>
                        </cfif>
                    </cfif>
                </cfif>
                <!---Fin de si son mas de 11 conceptos---->
			
				<cfset CONTADOR = CONTADOR+1>
                <cfset lineaslleva = lineaslleva+1><!----Linea de c/concepto---->
                <cfset lineaspagina = lineaspagina+1>

			</cfoutput>
            <tr><td>&nbsp;</td></tr>
            <tr style="font-size:12px" align="right">
                <td></td>
                <td>Total Percepciones</td>
                <td>#LSNumberFormat(LvarTotalPercepciones,'999,999,999,999,999.99')#</td>
                <td></td>
                <td>Total Deducciones</td>
                <td>#LSNumberFormat(LvarTotalDeducciones,'999,999,999,999,999.99')#</td>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr style="font-size:12px" align="right">
                <td colspan="4"></td>
                <td>Neto Pagado</td>
                <td>#LSNumberFormat(LvarTotalPercepciones-LvarTotalDeducciones,'999,999,999,999,999.99')#</td>
            </tr>
        
            <!---<tr><td>&nbsp;</td></tr>--->
                
            <!---CarolRS--->
            <!---Pintado del salario especie--->
            
            <!---CICLO DE CONCEPTOS---->
            <cfset CONTADOR = CONTADOR + 1><!---Cantidad de conceptos por boleta--->
            <cfset LvarTotalPercepciones = 0>
            <cfset LvarTotalDeducciones  = 0>

            <cfset EncEspecie = 1>
            <cfloop query="ConceptosPagoEspecie">
                <cfif EncEspecie EQ 1>					
                <!---Titulo Salario Especie: Percepciones y Deducciones --->
                
                    <tr style="font-size:12px">
                        <td valign="top" colspan="6" align="left">
                            <cf_translate  key="LB_SALESPECIE">Salarios Especie</cf_translate>
                        </td>
                    </tr>
                    <!---<tr style="font-size:12px">
                        <td valign="top" style="background:##CCC;" colspan="6" align="left">
                        </td>
                    </tr>--->
                    
                </cfif>	
                <tr style="font-size:10px"> 
                    <!---Cantidad Percepcion--->		
                    <td valign="top" nowrap align="center">
                        <cfif trim(ConceptosPagoEspecie.descconcepto) NEQ 'RETROACTIVOS'>						
                            <cfif len(trim(cantconcepto)) and cantconcepto GT 0>#LSNumberFormat(cantconcepto,'999.99')#<cfelse>&nbsp;</cfif>
                        <cfelse>
                            &nbsp;
                        </cfif>	
                    </td>
                    <!---Descripción Percepcion--->		
                    <td valign="top" nowrap>
                        <cfif trim(ConceptosPagoEspecie.descconcepto) EQ 'RETROACTIVOS'>
                            <cfset ConceptosPagoEspecie.descconcepto = '#LB_AJUSTE# #ConceptosPagoEspecie.descconcepto#'>
                        </cfif>
                        <cfif len(trim(descconcepto))>
                            <cfif len(descconcepto) GT 23>
                                #Mid(descconcepto, 1, 23)#
                            <cfelse>
                                #descconcepto#
                            </cfif>								
                        <cfelse>&nbsp;</cfif>
                    </td>
                    <!---Total Percepcion--->	
                    <td valign="top" style="text-align:right">
                        <cfif ConceptosPagoEspecie.montoconcepto NEQ 0 and len(trim(ConceptosPagoEspecie.descconcepto)) NEQ 0>
                            #LSNumberFormat(ConceptosPagoEspecie.montoconcepto,'999,999,999,999,999.99')#		
                            <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPagoEspecie.montoconcepto	>				
                        <cfelseif len(trim(ConceptosPagoEspecie.descconcepto)) NEQ 0>
                            #LSNumberFormat(ConceptosPagoEspecie.montoconcepto,'999,999,999,999,999.99')#
                            <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPagoEspecie.montoconcepto	>	
                        <cfelse>
                            &nbsp;
                        </cfif>	
                    </td>
                    <!---Cantidad Deduccion--->
                    <td>&nbsp;</td>
                    <!---Descripción Deduccion--->	
                    <td valign="top" nowrap="nowrap">						
                        <cfif len(trim(ConceptosPagoEspecie.montoconceptoB)) NEQ 0 and trim(ConceptosPagoEspecie.montoconceptoB) LT 0 >
                            <cfset ConceptosPagoEspecie.descconceptoB = '#ConceptosPagoEspecie.descconceptoB#'> <!---#LB_DEVOLUCION#--->
                        </cfif>						
                        <cfif len(trim(descconceptoB))>
                            <cfif len(descconceptoB) GT 29>
                                #Mid(descconceptoB, 1, 29)#
                            <cfelse>
                                #descconceptoB#
                            </cfif>									
                        <cfelse>&nbsp;</cfif>	
                    </td>
                    <!---Total Deduccion--->	
                    <td valign="top" style="text-align:right"></td>
                </tr>
                <cfset lineaslleva = lineaslleva+1>	
                <cfset lineaspagina = lineaspagina+1>			
                <cfset continuar = true>
            </cfloop>

            <cfset lineaslleva = lineaslleva+1>	
            <cfset lineaspagina = lineaspagina+1>			
            <cfset continuar = true>
			
			<!---<tr><td>&nbsp;</td></tr>--->
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Total Salario Especie</td>
				<td>#LSNumberFormat(LvarTotalPercepciones,'999,999,999,999,999.99')#</td>
				<td></td>
				<td><!---Total Deducciones---></td>
				<td><!---#LSNumberFormat(LvarTotalDeducciones,'999,999,999,999,999.99')#---></td>
			</tr>
            <tr><td>&nbsp;</td></tr>
			<tr style="font-size:12px" align="right">
				<td colspan="4"></td>
				<td><!---Neto Pagado---></td>
				<td><!---#LSNumberFormat(LvarTotalPercepciones-LvarTotalDeducciones,'999,999,999,999,999.99')#---></td>
			</tr>
            
            <!---SML. Modificacion para que cuando se si se requiere mostrar lo de Fondo de Ahorro por medio del parametro 721--->
   			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="721" default="0" returnvariable="UsoFondoAhorro"/>
            
            <cfif isdefined('UsoFondoAhorro') and UsoFondoAhorro EQ 1>
            <tr style="font-size:12px" align="right"> <!---SML. Modificacion para los Acumulados de Fondo de ahorro--->
				<td></td>
				<td>Fondo de Ahorro Empleado y Empresa</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Saldo Anterior</td>
				<td>#LSCurrencyFormat(montoAnterior)#</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Saldo Actual al #dateformat(rsDatosG.CPhasta,'DD/MM/YYYY')#</td>
				<td>#LSCurrencyFormat(rsFAhorro.FAactual + montoAnterior)#</td>
				<td></td>
				<td></td>
				<td></td>
			</tr><!---SML. Modificacion para los Acumulados de Fondo de ahorro--->
            </cfif>	
            
            <cfset lineaslleva = lineaslleva+6>	
			<cfset lineaspagina = lineaspagina+6>
                		
			<cfset continuar = true>
			<!---FIN Pintado del salario especie--->
			
			<tr><td>&nbsp;</td></tr>

			<tr><td>&nbsp;</td></tr>
            <tr  style="font-size:12px">
            	<td colspan="2"><strong>Recibo de N&oacute;mina</strong></td>
                <td>&nbsp;</td>
                <td colspan="3" align="right"><strong>Firma</strong> ________________________________</td>
            </tr>
        
			<cfif continuar>
				<!----ETIQUETA DEL PIE DE PAGINA ---->
				<tr><td>&nbsp;</td></tr>
				<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 700>				
					<tr><td colspan="7" width="950" nowrap="nowrap" style="font-size:11px;">#Mid(rsEtiquetaPie.Mensaje,1,700)#</td></tr>
				<cfelse>
					<tr>
						<td colspan="7" width="950" style="font-size:11px;">#trim(rsEtiquetaPie.Mensaje)#</td>
					</tr>
				</cfif>	
				<cfset lineaslleva = lineaslleva+5>	
				<cfset lineaspagina = lineaspagina+5>			
				<cfset continuar = true>
				
                
				<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
					<cfset lineaspagina = 0>
					<cfset iniciopagina = true>
					<tr><td style="page-break-before:always;"></td></tr>
				<cfelse>
					<!---RELLENAR---->
                    <!---<cfthrow message = "#lineaslleva#,#lineaspagina#">--->
					<cfif lineaslleva  LT 29 and lineaspagina GT 1>
						<cfset vn_hasta = 29-lineaslleva>
						<cfloop index="i" from="1" to="#vn_hasta#">
							<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
								<tr><td style="page-break-before:always;"></td></tr>
								<cfset lineaspagina = 0>
								<cfset iniciopagina = true>
								<cfbreak>
							</cfif>
							<tr><td>&nbsp;</td></tr>
							<cfset lineaspagina = lineaspagina+1>
						</cfloop>

						<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
							<cfset iniciopagina = true>
						</cfif>	
                    <!---<cfelse>
                    	<tr><td style="page-break-before:always;"></td></tr>
						<cfset lineaspagina = 0>
						<cfset iniciopagina = true>--->
					</cfif>
				</cfif>
			</cfif>	

            
		</cfoutput>
	</table>
    <!---SML. Modificacion para que salga los vales de despensa en una nomina especial--->
    <cfelseif ConceptosPago.RecordCount EQ 0 and ConceptosPagoEspecieTodos.RecordCount NEQ 0> 
    	<cfoutput query="ConceptosPagoEspecieTodos" group="DEid">
        
    	<cfquery dbtype="query" name="ConceptosPagoEspecie">
                select * from ConceptosPagoEspecieTodos
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPagoEspecieTodos.DEid#">
            </cfquery>
            
            <!---Si existen cargas que deben mostrarse en forma resumida se sumarizan. CarolRS--->
            <cfquery dbtype="query" name="CargasResumidas">
                select resumeCargasDesc as descconceptoB,sum(montoconceptoB) as montoconceptoB
                from ConceptosPago
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPagoEspecieTodos.DEid#">
                and resumeCargas = 1
                group by resumeCargasDesc
            </cfquery>
            
            <cfquery name="rsEmpleado" datasource="#session.DSN#">
                select <cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre"> as empleado, coalesce(de.RFC,'No definido') RFC,coalesce(de.CURP,'No definido') CURP,
                       de.DEidentificacion, coalesce(DLTmonto,0) as MtoSalario
                from DatosEmpleado de
                    inner join LineaTiempo lt
                        on de.DEid = lt.DEid
                        and de.Ecodigo = lt.Ecodigo
                     inner join DLineaTiempo b
                        on  lt.LTid = b.LTid
                    inner join ComponentesSalariales c
                        on b.CSid = c.CSid
                        and CSsalariobase = 1
                where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPagoEspecieTodos.DEid#">
                  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  <!---and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPago.desdenomina#">   between lt.LTdesde and lt.LThasta--->
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPagoEspecieTodos.desdenomina#"> <= lt.LThasta
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#ConceptosPagoEspecieTodos.hastanomina#"> >= lt.LTdesde
            </cfquery>
            
            <!---SML. Modificacion para que se obtenga la informacion de los trabajadores que estan dados de Baja--->
            <cfif isdefined('rsEmpleado') and rsEmpleado.RecordCount EQ 0>
            <cfquery name="rsEmpleado" datasource="#session.DSN#">
                select top 1 <cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre"> as empleado, coalesce(de.RFC,'No definido') RFC,coalesce(de.CURP,'No definido') CURP,
                       de.DEidentificacion, coalesce(DLTmonto,0) as MtoSalario
                from DatosEmpleado de
                    inner join LineaTiempo lt
                        on de.DEid = lt.DEid
                        and de.Ecodigo = lt.Ecodigo
                     inner join DLineaTiempo b
                        on  lt.LTid = b.LTid
                    inner join ComponentesSalariales c
                        on b.CSid = c.CSid
                        and CSsalariobase = 1
                where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPagoEspecieTodos.DEid#">
                  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  order by lt.LTid desc
            </cfquery>
            </cfif>
            <!---SML. Modificacion para que se obtenga la informacion de los trabajadores que estan dados de Baja--->
            
            <cfquery datasource="#session.dsn#" name="rsDatosG">
                select a.CPcodigo, a.CPdesde, a.CPhasta , case b.Ttipopago when 0 then 'Semana' when 1 then 'Bisemana' when 2 then 'Quincena' when 3 then 'mes' else 'otro' end as tipo,
                d.DESeguroSocial,
                coalesce((select sum(PEcantdias) from HPagosEmpleado e where e.RCNid = a.CPid and e.DEid = #ConceptosPagoEspecieTodos.DEid#  and e.PEtiporeg = 0),0) as  Dias
                from CalendarioPagos a
                inner join TiposNomina b
                    on a.Tcodigo = b.Tcodigo
                    and a.Ecodigo = b.Ecodigo
                inner join HSalarioEmpleado c
                    on c.RCNid = a.CPid 
                    and c.DEid = #ConceptosPagoEspecieTodos.DEid#
                inner join DatosEmpleado d
                    on d.DEid = c.DEid
                where CPid = #form.CPid#
            </cfquery>
            

            
            <cfquery datasource="#session.dsn#" name="RsFaltas">
                select (coalesce(sum(PEcantdias),0) * (d.RHTfactorfalta))  as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPagoEspecieTodos.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
                    and d.RHTcomportam = 13
                    group by a.DEid, d.RHTfactorfalta
            </cfquery>
            
            <cfquery datasource="#session.dsn#" name="RsIncap">
                select (coalesce(sum(PEcantdias),0))  as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPagoEspecieTodos.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
                    and d.RHTcomportam = 5
                    group by a.DEid, d.RHTfactorfalta
            </cfquery>
            
            <cfquery datasource="#session.dsn#" name="RsDias">
                select coalesce(sum(PEcantdias),0) as PEcantdias
                    from HPagosEmpleado a
                     inner join HRCalculoNomina b
                        on a.RCNid = b.RCNid
                     inner join TiposNomina c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                     inner join RHTipoAccion d
                        on d.RHTid = a.RHTid
                  where a.DEid  	   = #ConceptosPagoEspecieTodos.DEid#
                    and a.RCNid 	   = #form.CPid#
                    and a.PEtiporeg    = 0
            </cfquery>
            
            <cfif RsIncap.RecordCount>
                <cfset DiasRebajo = #lsnumberformat(RsIncap.PEcantdias,'99.999')#>
            <cfelse>
                <cfset DiasRebajo = 0>
            </cfif>
            
            <cfif RsFaltas.RecordCount>
                <cfset DiasRebajo = DiasRebajo + #lsnumberformat(RsFaltas.PEcantdias,'99.999')#>
            </cfif>
        
            <cfif #DiasRebajo# GT 0 >
                <cfset DiasFaltas = #lsnumberformat(DiasRebajo,'99.999')# & ' Dias'>
            <cfelse>
                <cfset DiasFaltas = '0 Dias'>
            </cfif>
    		
    		<cfif len(trim(rsEmpleado.MtoSalario)) GT 0> <!---SML. Modificacion para que se muestren a los trabajadores que estan dados de baja--->
				<cfset SalarioDiario 	= (rsEmpleado.MtoSalario/30)>
            <cfelse>
            	<cfset SalarioDiario = 0>
            </cfif>     <!---SML. Modificacion para que se muestren a los trabajadores que estan dados de baja--->
            
            
            <cfset rsde    			= ListToArray(rsDatosG.CPcodigo,'-')>
            <cfset LvarPeriodo      = rsde[2]>
            
                        
            <cfif #DiasRebajo# GT 0>
                <cfset LvarDias 		= RsDias.PEcantdias  - DiasRebajo>
            <cfelse>
                <cfset LvarDias 		= RsDias.PEcantdias >
            </cfif>
            
            <!---SML Modificacion para que se refleje el acumulado del Fondo de Ahorro--->
            <cfset montoAnterior = 0>
            <cfquery name="rsFAhorro" datasource="#session.DSN#">
            	 select top(1) FAEstatusFini
 				 from RHHFondoAhorro
 				 where DEid = #ConceptosPagoEspecieTodos.DEid#
					and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
 				order by HFAid desc
            </cfquery>
            
            <cfif isdefined('rsFAhorro') and rsFAhorro.FAEstatusFini EQ 1>
            	<cfset montoAnterior = 0>
            <cfelse>
            	<cfquery name="rsFAhorroFin" datasource="#session.DSN#">
                	select top(1) HFAid
 					from RHHFondoAhorro
 					where DEid = #ConceptosPagoEspecieTodos.DEid#
						and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
						and FAEstatusFini = 1
 					order by HFAid desc
            	</cfquery>
                
                <cfif isdefined('rsFAhorroFin') and rsFAhorroFin.RecordCount GT 0>
                	<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                	select coalesce(SUM(FAmonto),0) as FAanterior
					from RHHFondoAhorro
					where DEid = #ConceptosPagoEspecieTodos.DEid# 
                    	and HFAid > #rsFAhorroFin.HFAid#
						and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
            		</cfquery>
                    <cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                <cfelse> <!---Empieza las validaciones para Cierre de FOA --->
                	<cfquery  name="rsFAhorro" datasource="#session.DSN#">
            	 		select top(1) FAEstatusCierre
 				 		from RHHFondoAhorro
 				 		where DEid = #ConceptosPagoEspecieTodos.DEid#
							and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 						 where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
 						order by HFAid desc
            		</cfquery>

                    <cfif isdefined('rsFAhorro') and rsFAhorro.FAEstatusCierre EQ 1>
                    		<cfset montoAnterior =0> 
            		<cfelse>
            			<cfquery name="rsFAhorroCier" datasource="#session.DSN#">
                			select top(1) HFAid
 							from RHHFondoAhorro
 							where DEid = #ConceptosPagoEspecieTodos.DEid#
							  and HFAid < (select min(HFAid) from RHHFondoAhorro 
				 				 where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
							and FAEstatusCierre = 1
 							order by HFAid desc
            		   </cfquery>
                
                		<cfif isdefined('rsFAhorroCier') and rsFAhorroCier.RecordCount GT 0>
                			<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                				select coalesce(SUM(FAmonto),0) as FAanterior
								from RHHFondoAhorro
								where DEid = #ConceptosPagoEspecieTodos.DEid# 
								and FAEstatus = 0
								and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
            				</cfquery>
                    		<cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                         <cfelse>
                         	<cfquery name="rsFAhorroAnt" datasource="#session.DSN#">
                				select coalesce(SUM(FAmonto),0) as FAanterior
								from RHHFondoAhorro
								where DEid = #ConceptosPagoEspecieTodos.DEid# 
								<!---and FAEstatus = 0--->
								and HFAid < (select min(HFAid) from RHHFondoAhorro where RCNid = #form.CPid# and DEid = #ConceptosPagoEspecieTodos.DEid#)
            				</cfquery>
                    		<cfset montoAnterior =#rsFAhorroAnt.FAanterior#> 
                        </cfif>  
                    </cfif>              	
                </cfif>	
            </cfif>
                      
            <cfquery name="rsFAhorro" datasource="#session.DSN#">
            	select coalesce(SUM(FAmonto),0) as FAactual
				from RHHFondoAhorro
				where RCNid in (#form.CPid#)
					and DEid = #ConceptosPagoEspecieTodos.DEid# 
					<!---and FAEstatus = 0--->
            </cfquery>
            
           
			<cfset LvarRandoPeriodo = '#rsDatosG.tipo# del #dateformat(rsDatosG.CPdesde,'DD/MM/YYYY')# al #dateformat(rsDatosG.CPhasta,'DD/MM/YYYY')#'>
            <cfset LvarCSS     	    = rsDatosG.DESeguroSocial>

            <cfset lineasEmp 	  		= ConceptosPagoEspecieTodos.lineasEmp>
            <cfset vs_nomina 	  		= ConceptosPagoEspecieTodos.nomina>
            <cfset vs_desdenomina 		= ConceptosPagoEspecieTodos.desdenomina>
            <cfset vs_hastanomina 		= ConceptosPagoEspecieTodos.hastanomina>			
            <cfset vs_empleado 			= rsEmpleado.empleado>
            <cfset vs_RFC 			    = rsEmpleado.RFC>
            <cfset vs_CURP 				= rsEmpleado.CURP>
            <cfset vs_DEidentificacion 	= rsEmpleado.DEidentificacion>
            <cfset vs_cuenta 			= ConceptosPagoEspecieTodos.cuenta>
            <cfset vs_departamento 		= ConceptosPagoEspecieTodos.departamento>
            <cfset vs_puntoventa 		= ConceptosPagoEspecieTodos.puntoventa>
            <cfset vs_devengado 		= ConceptosPagoEspecieTodos.devengado>
            <cfset vs_deducido	 		= ConceptosPagoEspecieTodos.deducido>
            <cfset vs_neto 				= ConceptosPagoEspecieTodos.neto>
            <cfset vs_etiquetacta 		= ConceptosPagoEspecieTodos.EtiquetaCuenta>
        
			<cfsavecontent variable="Encabezado">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr><td>&nbsp;</td></tr>
                    <tr style="font-size:12px">
                    <!---????Corporacion e imagen????--->
						<!--- se elimina por peticion de cliente en mexico ljimenez
						<td colspan="2" ><strong>#session.CEnombre#</strong></td>--->
                        <td colspan="2"></td>
						<!---
						
						<td rowspan="6" align="right" valign="middle"><img src="../../../home/public/logo_cuenta.cfm?CEcodigo=#session.CEcodigo#" height="60" border="0"></td>
						--->
						<td rowspan="6" align="right" valign="middle"><img src="../../../home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#" height="60" border="0"></td>
					</tr>
                    <!---????Empresa y Direcciones????--->
                    <tr style="font-size:12px"><td colspan="2"><strong>#session.Enombre#</strong></td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion1#</td></tr>
                    <tr style="font-size:9px"><td colspan="2">#rsEmpresa.direccion2#</td></tr>
                    <!---????Ciudad, codigo Postal, Telefono y Fax????--->
                    <tr style="font-size:9px">
                    	<td colspan="2" class="td12">
							<cfif LEN(rsEmpresa.ciudad)>#rsEmpresa.ciudad#, #rsEmpresa.Estado#</cfif>
                            <cfif LEN(rsEmpresa.codPostal)>,C.P. #rsEmpresa.codPostal#</cfif>
                            <cfif LEN(rsEmpresa.Etelefono1)>,Tel. #rsEmpresa.Etelefono1#</cfif>
                            <cfif LEN(rsEmpresa.Efax)>,Fax. #rsEmpresa.Efax#</cfif>
                    	</td>
                    </tr>
                     <!---????RFC y Registro Patronal????--->
                    <tr style="font-size:9px">
                    	<td colspan="2">
                        	<cfif LEN(rsEmpresa.Eidentificacion)>R.F.C. #rsEmpresa.Eidentificacion#&nbsp;</cfif>
                            <cfif LEN(rsEmpresa.Enumlicencia)>#LB_RegistroPatronal#: #rsEmpresa.Enumlicencia#</cfif>
                        </td>
                    </tr>
                    <tr><td colspan="3" style="font-size:9px">&nbsp;</td></tr>
                    <tr>
                    	<td colspan="3">
                      <!---????Datos del Empleado????--->
                        	<table border="0" cellpadding="0" cellspacing="1" align="left" style="font-size:12px">
                            	<tr>
                                	<td>&nbsp;</td>
                                    <td colspan="10">#vs_DEidentificacion#&nbsp;#vs_empleado#</td>
                                </tr>
                                <tr> 
                                	<td>&nbsp;</td>  
                                    <td>CURP:&nbsp;</td><td>#vs_CURP#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Días#:&nbsp;</td><td>#LSnumberformat(LvarDias,'999.999')#</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Periodo#&nbsp;</td><td>#LvarPeriodo#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LvarRandoPeriodo#</td>
                                    <td>&nbsp;</td>
                                </tr>
                                 <tr> 
                                	<td>&nbsp;</td>  
                                    <td>R.F.C.:&nbsp;</td><td>#vs_RFC#&nbsp;</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_Faltas#:&nbsp;</td><td>#DiasFaltas#</td>
                                    <td>&nbsp;</td>  
                                    <td>#LB_SalDir#:</td> <td>#LSNumberFormat(SalarioDiario,'999,999,999,999,999.99')#</td>
                                    <td>&nbsp;</td>  
                                    <td>NSS:&nbsp;&nbsp;#LvarCSS#&nbsp;</td>
                                </tr>
                            </table>
                    	</td>
                    </tr>
				</table>
			</cfsavecontent>
            
			<cfset iniciopagina = false> 
			<cfset continuar    = true>
			<cfset x            = boletas mod 2>
           <table width="98%" cellpadding="0" cellspacing="0" border="0">	
			<!---ENCABEZADO--->	
			
			<cfif x EQ 0 and boletas GT 2>
				<tr><td height="50px">&nbsp;</td></tr>	
			</cfif>
            				
			<tr><td colspan="7">#Encabezado#</td></tr>
			<cfset lineaslleva = 11>	<!----Lineas del encabezado---->
			<cfset lineaspagina = lineaspagina+lineaslleva>	
			<cfset boletas = boletas+1>	

			<!---CICLO DE CONCEPTOS---->
			<cfset CONTADOR = 1><!---Cantidad de conceptos por boleta--->
            <cfset LvarTotalPercepciones = 0>
            <cfset LvarTotalDeducciones  = 0>
			<cfset displayCargasResumidas = 0> <!---Pintado de Cargas Resumidas. Indicador para saber si las cargas resumidas ya fureon pintadas en el reporte para un empleado en especifico. CarolRS--->
			<cfoutput>
				<cfif CONTADOR EQ 1>					
				<!---????Titulo Percepciones y Deducciones (En la primera linea del detalle se pinta el encabezado-labels del mismo)????--->
                    <tr style="font-size:12px">
						<td valign="top" style="background:##CCC;" colspan="3" align="center">
							<cf_translate  key="LB_PERCEPCIONES">PERCEPCIONES</cf_translate>
						</td>
						<td valign="top" style="background:##CCC;" colspan="3" align="center">
                        	<cf_translate  key="LB_DEDUCCIONES">DEDUCCIONES</cf_translate>
                         </td>
					</tr>
				</cfif>	
				
				<cfif len(trim(ConceptosPago.descconcepto))  
					OR ConceptosPago.resumeCargas EQ 0  
					OR ( displayCargasResumidas EQ 0 and CargasResumidas.recordCount gt 0 )>
					
				<tr style="font-size:10px"> 
					<!---????Cantidad Percepcion????--->		
                	<td valign="top" nowrap align="center">
						<cfif trim(ConceptosPago.descconcepto) NEQ 'RETROACTIVOS'>						
							<cfif len(trim(cantconcepto)) and cantconcepto GT 0>#LSNumberFormat(cantconcepto,'999.99')#<cfelse>&nbsp;</cfif>
						<cfelse>
							&nbsp;
						</cfif>	
					</td>
		 			<!---????Descripción Percepcion????--->		
					<td valign="top" nowrap>
						<cfif trim(ConceptosPago.descconcepto) EQ 'RETROACTIVOS'>
							<cfset ConceptosPago.descconcepto = '#LB_AJUSTE# #ConceptosPago.descconcepto#'>
						</cfif>
						<cfif len(trim(descconcepto))>
							<cfif len(descconcepto) GT 23>
								#Mid(descconcepto, 1, 23)#
							<cfelse>
								#descconcepto#
							</cfif>								
						<cfelse>&nbsp;</cfif>
					</td>
					<!---????Total Percepcion????--->	
					<td valign="top" style="text-align:right">
					<cfif ConceptosPago.montoconcepto NEQ 0 and len(trim(ConceptosPago.descconcepto)) NEQ 0>
                        #LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#		
                        <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPago.montoconcepto	>				
                    <cfelseif len(trim(ConceptosPago.descconcepto)) NEQ 0>
                        #LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')#
                        <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPago.montoconcepto	>	
                    <cfelse>
                        &nbsp;
                    </cfif>	
					</td>
                    <!---????Cantidad Deduccion????--->
					<td>&nbsp;</td>
					<!---????Descripción Deduccion????--->	
					
					<cfif ConceptosPago.resumeCargas EQ 0> <!---si hay cargas resumidas, se separan de las no resumidas--->
						<td valign="top" nowrap="nowrap">	
							<cfif len(trim(ConceptosPago.montoconceptoB)) NEQ 0 and trim(ConceptosPago.montoconceptoB) LT 0 >
								<cfset ConceptosPago.descconceptoB = '#ConceptosPago.descconceptoB#'> <!---#LB_DEVOLUCION#--->
							</cfif>						
							<cfif len(trim(descconceptoB))>
								<cfif len(descconceptoB) GT 29>
									#Mid(descconceptoB, 1, 29)#
								<cfelse>
									#descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<!---????Total Deduccion????--->	
						<td valign="top" style="text-align:right">
							<cfif ConceptosPago.montoconceptoB NEQ 0 and len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#	
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	ConceptosPago.montoconceptoB>			
							<cfelseif len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
								#LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')#
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	ConceptosPago.montoconceptoB>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					
					<cfelseif displayCargasResumidas EQ 0 and CargasResumidas.recordCount gt 0>	<!---Si no se han pintado aun cargas resumidas y existen cargas resumidas por pintar. CarolRS--->
						
						<!---Descripción Deduccion--->	
						<td valign="top" nowrap="nowrap">					
							<cfif len(trim(CargasResumidas.montoconceptoB)) NEQ 0 and trim(CargasResumidas.montoconceptoB) LT 0 >
								<cfset CargasResumidas.descconceptoB = '#CargasResumidas.descconceptoB#'><!---#LB_DEVOLUCION#--->
							</cfif>						
							<cfif len(trim(CargasResumidas.descconceptoB))>
								<cfif len(CargasResumidas.descconceptoB) GT 29>
									#Mid(CargasResumidas.descconceptoB, 1, 29)#
								<cfelse>
									#CargasResumidas.descconceptoB#
								</cfif>									
							<cfelse>&nbsp;</cfif>	
						</td>
						<!---Total Deduccion--->	
						<td valign="top" style="text-align:right">
							<cfif CargasResumidas.montoconceptoB NEQ 0 and len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#	
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	CargasResumidas.montoconceptoB>			
							<cfelseif len(trim(CargasResumidas.montoconceptoB)) NEQ 0>
								#LSNumberFormat(CargasResumidas.montoconceptoB,'999,999,999,999,999.99')#
								<cfset LvarTotalDeducciones	 = LvarTotalDeducciones + 	CargasResumidas.montoconceptoB>
							<cfelse>
								&nbsp;
							</cfif>
						</td>	
						<cfset displayCargasResumidas = 1> <!---Indica que las cargas resumidas para el empleado ya fueron pintadas para que no se pienten nuevamente. CarolRS--->
					</cfif>
				</tr>	
                </cfif>
                
				<!---Si son mas de 11 conceptos colocarlos en otra boleta, hacer corte---->
                <cfif vb_pagebreak>
                    <cfif CONTADOR GTE 13>
                        <!----ETIQUETA DEL PIE DE PAGINA ---->
                        <tr><td>&nbsp;</td></tr>
                        <cfif len(trim(rsEtiquetaPie.Mensaje)) GT 250>		
                            <tr><td colspan="7" width="950" nowrap="nowrap">#Mid(rsEtiquetaPie.Mensaje,1,250)#</td></tr>
                        <cfelse>
                            <tr>
                                <td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
                            </tr>
                        </cfif>	
                        <cfset lineaslleva = lineaslleva+5>
                        <cfset lineaspagina = lineaspagina+5>

                        <cfif lineaspagina GTE 46>
                            <tr><td style="page-break-before:always;"></td></tr>
                            <cfset lineaspagina = 0>		
                            <cfset iniciopagina = true>
                        <cfelse>		
                            <cfif lineaslleva  LT 23 and lineaspagina GT 1>
                                <cfset vn_hasta = 23-lineaslleva>					
                                <cfloop index="i" from="1" to="#vn_hasta#">
                                    <cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
                                        <tr><td style="page-break-before:always;"></td></tr>
                                        <cfset iniciopagina = true>
                                        <cfset lineaspagina = 0>
                                        <cfbreak>
                                    </cfif>
                                    <tr><td>&nbsp;</td></tr>
                                    <cfset lineaspagina = lineaspagina+1>
                                </cfloop>				
                            </cfif>
                        </cfif>	
                        <cfif CONTADOR NEQ lineasEmp>
                            <cfset CONTADOR = 0>		
                            <cfset x = boletas mod 2>
                            <cfif x EQ 0 and boletas GT 2>
                                <tr><td height="40px">&nbsp;</td></tr>	
                            </cfif>
                            <tr><td colspan="7">#Encabezado#</td></tr>
                            <cfset lineaslleva = 9>
                            <cfset lineaspagina = lineaspagina+lineaslleva>
                            <cfset boletas = boletas+1>	
                        <cfelseif CONTADOR EQ lineasEmp>
                            <cfset continuar = false>
                        </cfif>
                    </cfif>
                </cfif>
                <!---Fin de si son mas de 11 conceptos---->
			
				<cfset CONTADOR = CONTADOR+1>
                <cfset lineaslleva = lineaslleva+1><!----Linea de c/concepto---->
                <cfset lineaspagina = lineaspagina+1>

			</cfoutput>
            <tr><td>&nbsp;</td></tr>
            <tr style="font-size:12px" align="right">
                <td></td>
                <td>Total Percepciones</td>
                <td>#LSNumberFormat(LvarTotalPercepciones,'999,999,999,999,999.99')#</td>
                <td></td>
                <td>Total Deducciones</td>
                <td>#LSNumberFormat(LvarTotalDeducciones,'999,999,999,999,999.99')#</td>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr style="font-size:12px" align="right">
                <td colspan="4"></td>
                <td>Neto Pagado</td>
                <td>#LSNumberFormat(LvarTotalPercepciones-LvarTotalDeducciones,'999,999,999,999,999.99')#</td>
            </tr>
        
            <!---<tr><td>&nbsp;</td></tr>--->
                
            <!---CarolRS--->
            <!---Pintado del salario especie--->
            
            <!---CICLO DE CONCEPTOS---->
            <cfset CONTADOR = CONTADOR + 1><!---Cantidad de conceptos por boleta--->
            <cfset LvarTotalPercepciones = 0>
            <cfset LvarTotalDeducciones  = 0>

            <cfset EncEspecie = 1>
            <cfloop query="ConceptosPagoEspecie">
                <cfif EncEspecie EQ 1>					
                <!---Titulo Salario Especie: Percepciones y Deducciones --->
                
                    <tr style="font-size:12px">
                        <td valign="top" colspan="6" align="left">
                            <cf_translate  key="LB_SALESPECIE">Salarios Especie</cf_translate>
                        </td>
                    </tr>
                    <!---<tr style="font-size:12px">
                        <td valign="top" style="background:##CCC;" colspan="6" align="left">
                        </td>
                    </tr>--->
                    
                </cfif>	
                <tr style="font-size:10px"> 
                    <!---Cantidad Percepcion--->		
                    <td valign="top" nowrap align="center">
                        <cfif trim(ConceptosPagoEspecie.descconcepto) NEQ 'RETROACTIVOS'>						
                            <cfif len(trim(cantconcepto)) and cantconcepto GT 0>#LSNumberFormat(cantconcepto,'999.99')#<cfelse>&nbsp;</cfif>
                        <cfelse>
                            &nbsp;
                        </cfif>	
                    </td>
                    <!---Descripción Percepcion--->		
                    <td valign="top" nowrap>
                        <cfif trim(ConceptosPagoEspecie.descconcepto) EQ 'RETROACTIVOS'>
                            <cfset ConceptosPagoEspecie.descconcepto = '#LB_AJUSTE# #ConceptosPagoEspecie.descconcepto#'>
                        </cfif>
                        <cfif len(trim(descconcepto))>
                            <cfif len(descconcepto) GT 23>
                                #Mid(descconcepto, 1, 23)#
                            <cfelse>
                                #descconcepto#
                            </cfif>								
                        <cfelse>&nbsp;</cfif>
                    </td>
                    <!---Total Percepcion--->	
                    <td valign="top" style="text-align:right">
                        <cfif ConceptosPagoEspecie.montoconcepto NEQ 0 and len(trim(ConceptosPagoEspecie.descconcepto)) NEQ 0>
                            #LSNumberFormat(ConceptosPagoEspecie.montoconcepto,'999,999,999,999,999.99')#		
                            <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPagoEspecie.montoconcepto	>				
                        <cfelseif len(trim(ConceptosPagoEspecie.descconcepto)) NEQ 0>
                            #LSNumberFormat(ConceptosPagoEspecie.montoconcepto,'999,999,999,999,999.99')#
                            <cfset LvarTotalPercepciones	 = LvarTotalPercepciones + 	ConceptosPagoEspecie.montoconcepto	>	
                        <cfelse>
                            &nbsp;
                        </cfif>	
                    </td>
                    <!---Cantidad Deduccion--->
                    <td>&nbsp;</td>
                    <!---Descripción Deduccion--->	
                    <td valign="top" nowrap="nowrap">						
                        <cfif len(trim(ConceptosPagoEspecie.montoconceptoB)) NEQ 0 and trim(ConceptosPagoEspecie.montoconceptoB) LT 0 >
                            <cfset ConceptosPagoEspecie.descconceptoB = '#ConceptosPagoEspecie.descconceptoB#'><!---#LB_DEVOLUCION#--->
                        </cfif>						
                        <cfif len(trim(descconceptoB))>
                            <cfif len(descconceptoB) GT 29>
                                #Mid(descconceptoB, 1, 29)#
                            <cfelse>
                                #descconceptoB#
                            </cfif>									
                        <cfelse>&nbsp;</cfif>	
                    </td>
                    <!---Total Deduccion--->	
                    <td valign="top" style="text-align:right"></td>
                </tr>
                <cfset lineaslleva = lineaslleva+1>	
                <cfset lineaspagina = lineaspagina+1>			
                <cfset continuar = true>
            </cfloop>

            <cfset lineaslleva = lineaslleva+1>	
            <cfset lineaspagina = lineaspagina+1>			
            <cfset continuar = true>
			
			<!---<tr><td>&nbsp;</td></tr>--->
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Total Salario Especie</td>
				<td>#LSNumberFormat(LvarTotalPercepciones,'999,999,999,999,999.99')#</td>
				<td></td>
				<td><!---Total Deducciones---></td>
				<td><!---#LSNumberFormat(LvarTotalDeducciones,'999,999,999,999,999.99')#---></td>
			</tr>
            <tr><td>&nbsp;</td></tr>
			<tr style="font-size:12px" align="right">
				<td colspan="4"></td>
				<td><!---Neto Pagado---></td>
				<td><!---#LSNumberFormat(LvarTotalPercepciones-LvarTotalDeducciones,'999,999,999,999,999.99')#---></td>
			</tr>
            <!---SML. Modificacion para que cuando se si se requiere mostrar lo de Fondo de Ahorro por medio del parametro 721--->
   			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="721" default="0" returnvariable="UsoFondoAhorro"/>
            
            <cfif isdefined('UsoFondoAhorro') and UsoFondoAhorro EQ 1>
            <tr style="font-size:12px" align="right"> <!---SML. Modificacion para los Acumulados de Fondo de ahorro--->
				<td></td>
				<td>Fondo de Ahorro Empleado y Empresa</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Saldo Anterior</td>
				<td>#LSCurrencyFormat(montoAnterior)#</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr style="font-size:12px" align="right">
				<td></td>
				<td>Saldo Actual al #dateformat(rsDatosG.CPhasta,'DD/MM/YYYY')#</td>
				<td>#LSCurrencyFormat(rsFAhorro.FAactual + montoAnterior)#</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
            </cfif>
			<!---SML. Modificacion para los Acumulados de Fondo de ahorro--->
			<cfset lineaslleva = lineaslleva+6>	
			<cfset lineaspagina = lineaspagina+6>			
			<cfset continuar = true>
			<!---FIN Pintado del salario especie--->
			
			<tr><td>&nbsp;</td></tr>

			<tr><td>&nbsp;</td></tr>
            <tr  style="font-size:12px">
            	<td colspan="2"><strong>Recibo de N&oacute;mina</strong></td>
                <td>&nbsp;</td>
                <td colspan="3" align="right"><strong>Firma</strong> ________________________________</td>
            </tr>
        
			<cfif continuar>
				<!----ETIQUETA DEL PIE DE PAGINA ---->
				<tr><td>&nbsp;</td></tr>
				<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 700>				
					<tr><td colspan="7" width="950" nowrap="nowrap" style="font-size:11px;">#Mid(rsEtiquetaPie.Mensaje,1,700)#</td></tr>
				<cfelse>
					<tr>
						<td colspan="7" width="950" style="font-size:11px;">#trim(rsEtiquetaPie.Mensaje)#</td>
					</tr>
				</cfif>	
				<cfset lineaslleva = lineaslleva+5>	
				<cfset lineaspagina = lineaspagina+5>			
				<cfset continuar = true>
				
                
				<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
					<cfset lineaspagina = 0>
					<cfset iniciopagina = true>
					<tr><td style="page-break-before:always;"></td></tr>
				<cfelse>
					<!---RELLENAR---->
                    <!---<cfthrow message = "#lineaslleva#,#lineaspagina#">--->
					<cfif lineaslleva  LT 29 and lineaspagina GT 1>
						<cfset vn_hasta = 29-lineaslleva>
						<cfloop index="i" from="1" to="#vn_hasta#">
							<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
								<tr><td style="page-break-before:always;"></td></tr>
								<cfset lineaspagina = 0>
								<cfset iniciopagina = true>
								<cfbreak>
							</cfif>
							<tr><td>&nbsp;</td></tr>
							<cfset lineaspagina = lineaspagina+1>
						</cfloop>

						<cfif lineaspagina GTE 52 and ConceptosPago.CurrentRow NEQ ConceptosPago.RecordCount>
							<cfset iniciopagina = true>
						</cfif>	
                    <!---<cfelse>
                    	<tr><td style="page-break-before:always;"></td></tr>
						<cfset lineaspagina = 0>
						<cfset iniciopagina = true>--->
					</cfif>
				</cfif>
			</cfif>	

            
		</cfoutput>
	</table>
    
    <!---SML. Modificacion para que salga los vales de despensa en una nomina especial--->
	<cfelse>
		<table width="98%" cellpadding="0" cellspacing="1" align="center">
			<tr><td align="center">------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</td></tr>
		</table>
	</cfif>
	
</cfsavecontent>