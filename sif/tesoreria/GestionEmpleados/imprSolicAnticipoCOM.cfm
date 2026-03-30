<!--- Modificado por Israel Rodríguez Ruiz 
Se realiza la modificacion en para las firmas de autorización de la solicitud.
Las comisiones en territorio nacional serán autorizadas por el Director de Área.
Las comisiones en el extranjero serán autorizadas por el Director de Administración y Finanzas.
Las comisiones que sean realizadas por el Director General, serán autorizadas por el Director de Administración y Finanzas. 
Las comisiones que sean realizadas por los Directores de Área, serán autorizadas por el Director General  08032012IRR
Se Realiza la siguiente Modificación  para que sea Considerada la OIC como Dirección para las firmas de Autorización 160312IRR
Se Realiza la siguiente Modificación  para que las Subdirecciones dependientes de Dirección General sean tratadas como Dirección para las firmas de Autorización, se cambia la palabra prueba por Autoriza 10092012IRR
--->
<!---Modificado por E.Raúl Bravo Gómez 23/04/2014
Cambio solicitado por Service Call 181547
Las firmas de autorización de las comisiones nacionales o extranjeras se cambian a dos firmas--->

<cf_htmlReportsHeaders 
	title="Impresion" 
	filename="AnticipoCCH.xls"
	irA="ReimpresionAnt.cfm" <!---#url.url#?lista=1"--->
	download="no"
	preview="no"
>
<cfif isDefined("Url.TESSPid") and not isDefined("form.TESSPid")>
  <cfset form.TESSPid = Url.TESSPid>
</cfif>

<cfif isDefined("Url.GECid") and not isDefined("form.GECid")>
  <cfset form.GECid = Url.GECid>
</cfif>
<cfif isDefined("Url.GEAid") and not isDefined("form.GEAid")>
  <cfset form.GEAid = Url.GEAid>
</cfif>
<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>

<cfif isdefined('form.GECid') and form.GECid NEQ ''>

	<cf_dbfunction name="dateadd" args="da.GEADhoraini,da.GEADfechaini,MI" returnVariable="LvarFechaIni">
	<cf_dbfunction name="date_format" args="#LvarFechaIni#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaIni"	delimiters="°">
	<cf_dbfunction name="dateadd" args="da.GEADhorafin,da.GEADfechafin,MI" returnVariable="LvarFechaFin">
	<cf_dbfunction name="date_format" args="#LvarFechaFin#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaFin"	delimiters="°">
	<cf_dbfunction name="concat" args="#LvarFechaIni#¬' - '¬#LvarFechaFin#" returnVariable="LvarFechas"  		delimiters="¬">
	
	<cf_dbfunction name="to_number" args="GECIhinicio/60" dec="0" returnvariable="LvarInicio">            
		<cfset LvarInicio = "#LvarInicio# + (GECIhinicio-#LvarInicio#*60)/100">
    <cf_dbfunction name="to_number" args="GECIhfinal/60" dec="0" returnvariable="LvarFinal">
    	<cfset LvarFinal = "#LvarFinal# + (GECIhfinal-#LvarFinal#*60)/100">
		

	<cfquery datasource="#session.dsn#" name="rsBeneficiario">
		select B.TESBeneficiario
		from GEcomision C
		inner join TESbeneficiario B on C.TESBid = B.TESBid 
		where C.GECid = #form.GECid# and B.DEid = (select de.DEid
						    from GEcomision c
							left join GEanticipo a on c.GECid = a.GECid 
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where c.GECid = #form.GECid#
							<cfif #form.GEAid# NEQ 0>
								and a.GEAid = #form.GEAid#
							</cfif> 
							and  c.Ecodigo = #session.Ecodigo# and ECFencargado = 1
                            group by de.DEid)
    </cfquery>
	
	<cfquery datasource="#session.dsn#" name="rsReporteTotal">
	Select convert(varchar(10),co.GECnumero)+'/'+
	<cfif #form.GEAid# NEQ 0>
		isnull(convert(varchar(10),sa.GEAnumero)+'-','')+
	</cfif>
	convert(varchar(10),year(co.GECfechaSolicitud))as Referencia, 
	co.GECnumero ,cf.CFformato ,convert(dec(15,2),da.GEADmonto) as GEADmonto,sa.CFid , 
	sa.TESSPid , sa.UsucodigoSolicitud ,
	tb.TESBeneficiario , co.GECestado , sa.Mcodigo , e.Edescripcion , m.Mnombre, m.Miso4217 , 
	convert (varchar(10),co.GECfechaSolicitud, 103) as GECfechaSolicitud, 
	co.GECfechaPagar , sa.GEAtotalOri , co.GECdescripcion , sa.GEAidDuplicado ,sa.GEAtipoP ,
	sa.CCHid ,{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )}
 	as elaboradoPor , 
 case sa.GEAtipo when 0 then 'SOLICITUD DE PAGO MANUAL' 
                 when 5 then 'SOLICITUD DE PAGO MANUAL POR CENTRO FUNCIONAL' 
				 when 1 then 'SOLICITUD DE PAGO DE DOCUMENTOS DE CxP' 
				 when 2 then 'SOLICITUD DE PAGO DE ANTICIPOS DE CxP' 
				 when 3 then 'SOLICITUD DE DEVOLUCION DE ANTICIPOS DE CxC' 
				 when 4 then 'SOLICITUD DE DEVOLUCION DE ANTICIPOS DE POS' 
				 when 100 then 'SOLICITUD DE PAGO POR INTERFAZ' 
				 when 6 then 'SOLICITUD DE ANTICIPO DE GASTOS EMPLEADO' 
				 else 'SOLICITUD DE PAGO' end as Titulo , 
case sa.GEAestado when 0 then 'En Preparación' 
				  when 1 then 'En Proceso de Aprobación' 
				  when 2 then 'Solicitud Aprobada' 
				  when 3 then 'Solicitud Rechazada' 
				  when 23 then 'Solicitud Rechazada en Tesorería'
				  when 10 then 'Solicitud Aprobada e Incluida en Preparación de OP. ' 
				  when 101 then 'Solicitud Aprobada e Incluida en Proceso de Aprobación de OP. ' 
				  when 103 then 'Solicitud Rechazada en OP. ' 
				  when 11 then 'Solicitud Aprobada e Incluida en Proceso de Emisión de OP.'
				  when 110 then 'Solicitud Emitida en OP. sin Aplicar' when 12 then 'Solicitud Pagada en OP.' 
				  when 13 then 'Solicitud Anulada en OP. ' 
				  else 'Estado Desconocido' end as Estado , 
case sa.GEAestado when 3 then 'MOTIVO RECHAZO:' else ' ' end as Motivo1 ,
{fn concat({fn concat({fn concat({fn concat(dpR.Pnombre , ' ' )},
dpR.Papellido1 )}, ' ' )}, dpR.Papellido2 )} as canceladoPor ,tes.TESdescripcion ,sa.CFid, cfn.CFdescripcion ,
uA.Usulogin , x.TESSPmsgRechazo ,gep.GEPVdescripcion ,gec.GECVdescripcion ,gec.GECVid_Padre ,
right('00' + convert(varchar,datepart(dd, dateadd(mi, da.GEADhoraini, da.GEADfechaini))), 2) + '/' + 
right('00' + convert(varchar,datepart(mm, dateadd(mi, da.GEADhoraini, da.GEADfechaini))), 2) + '/' + 
convert(varchar,datepart(yy, dateadd(mi, da.GEADhoraini, da.GEADfechaini))) + ' ' + right('00' + 
convert(varchar,datepart(hh, dateadd(mi, da.GEADhoraini, da.GEADfechaini))), 2) + ':' + 
right('00' + convert(varchar,datepart(mi, dateadd(mi, da.GEADhoraini, da.GEADfechaini))), 2) + ' - ' + 
right('00' + convert(varchar,datepart(dd, dateadd(mi, da.GEADhorafin, da.GEADfechafin))), 2) + '/' + 
right('00' + convert(varchar,datepart(mm, dateadd(mi, da.GEADhorafin, da.GEADfechafin))), 2) + '/' + 
convert(varchar,datepart(yy, dateadd(mi, da.GEADhorafin, da.GEADfechafin))) + ' ' + right('00' + 
convert(varchar,datepart(hh, dateadd(mi, da.GEADhorafin, da.GEADfechafin))), 2) + ':' + 
right('00' + convert(varchar,datepart(mi, dateadd(mi, da.GEADhorafin, da.GEADfechafin))), 2) as fechas ,x.TESSPestado,
TESSPnumero, case co.GECtipo when 1 then 'Nacional' when 2 then 'Exterior' when 3 then 'Ambos' end as TipoComision,
case GECautomovil when 0 then 'NO' when 1 then 'SI' end as Arrendamiento,
case GEInternet when 0 then 'NO' when 1 then 'SI' end as Internet,
case GECusaTCE when 0 then 'No titular TCE' when 1 then 'Titular TCE' end as Anticipo,
Rubro = (select CCcodigo+' '+CCdescripcion from CConceptos where CCcodigo = (select top 1 case PCNid
	 										 when 1 then substring(CFformato, 6,5) 
					  	    				 when 2 then substring(CFformato, 6+5,5)
	   										 when 3 then substring(CFformato, 6+10,5)
	   										 when 4 then substring(CFformato, 6+15,5)
	   										 when 5 then substring(CFformato, 6+20,5)
	   										 when 6 then substring(CFformato, 6+25,5)
	   						 				 when 7 then substring(CFformato, 6+30,5)
	   										 when 8 then substring(CFformato, 6+35,5)
	   										 when 9 then substring(CFformato, 6+40,5)
				  	   						 when 10 then substring(CFformato, 6+45,5)
	   										 when 11 then substring(CFformato, 6+50,5) 
	   										 end
											 from 
						 					 GEanticipoDet AN 
					  					     inner join CFinanciera CF on AN.CFcuenta = CF.CFcuenta 
											 and CF.Ecodigo = #session.Ecodigo#
											 inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
											 inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
					  						 inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
											 where AN.CFcuenta = da.CFcuenta
                    						 and PCNdescripcion  like 'RUBROS')),
SubRubro = (select (select top 1 case PCNid
	 										 when 1 then substring(CFformato, 12,3) 
				  	   						 when 2 then substring(CFformato, 12+5,3)
				  	   						 when 3 then substring(CFformato, 12+10,3)
				 	  						 when 4 then substring(CFformato, 12+15,3)
				 	   						 when 5 then substring(CFformato, 12+20,3)
				 	   						 when 6 then substring(CFformato, 12+25,3)
					   						 when 7 then substring(CFformato, 12+30,3)
	   										 when 8 then substring(CFformato, 12+35,3)
	   										 when 9 then substring(CFformato, 12+40,3)
	  										 when 10 then substring(CFformato, 12+45,3)
	   										 when 11 then substring(CFformato, 12+50,3) 	   						 				
	   										 end
											 from 
						 					 GEanticipoDet AN 
					  					     inner join CFinanciera CF on AN.CFcuenta = CF.CFcuenta 
											 and CF.Ecodigo = #session.Ecodigo#
											 inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
											 inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
					  						 inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
											 where AN.CFcuenta = da.CFcuenta
                    						 and PCNdescripcion  like 'RUBROS')+' '+Cdescripcion from Conceptos 
											 where Ccodigo = (select top 1 case PCNid
	 										 when 1 then substring(CFformato, 6,5) 
					  	    				 when 2 then substring(CFformato, 6+5,5)
	   										 when 3 then substring(CFformato, 6+10,5)
	   										 when 4 then substring(CFformato, 6+15,5)
	   										 when 5 then substring(CFformato, 6+20,5)
	   										 when 6 then substring(CFformato, 6+25,5)
	   						 				 when 7 then substring(CFformato, 6+30,5)
	   										 when 8 then substring(CFformato, 6+35,5)
	   										 when 9 then substring(CFformato, 6+40,5)
				  	   						 when 10 then substring(CFformato, 6+45,5)
	   										 when 11 then substring(CFformato, 6+50,5) 
	   										 end
											 from 
						 					 GEanticipoDet AN 
					  					     inner join CFinanciera CF on AN.CFcuenta = CF.CFcuenta 
											 and CF.Ecodigo = #session.Ecodigo#
											 inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
											 inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
					  						 inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
											 where AN.CFcuenta = da.CFcuenta
                    						 and PCNdescripcion  like 'RUBROS')+(select top 1 case PCNid
	 										  when 1 then substring(CFformato, 12,3) 
				  	   						 when 2 then substring(CFformato, 12+5,3)
				  	   						 when 3 then substring(CFformato, 12+10,3)
				 	  						 when 4 then substring(CFformato, 12+15,3)
				 	   						 when 5 then substring(CFformato, 12+20,3)
				 	   						 when 6 then substring(CFformato, 12+25,3)
					   						 when 7 then substring(CFformato, 12+30,3)
	   										 when 8 then substring(CFformato, 12+35,3)
	   										 when 9 then substring(CFformato, 12+40,3)
	  										 when 10 then substring(CFformato, 12+45,3)
	   										 when 11 then substring(CFformato, 12+50,3) 	   						 				
	   										 end
											 from 
											 GEanticipoDet AN 
					  					     inner join CFinanciera CF on AN.CFcuenta = CF.CFcuenta 
											 and CF.Ecodigo = #session.Ecodigo#
											 inner join CtasMayor CM on CF.Cmayor = CM.Cmayor and CF.Ecodigo = CM.Ecodigo
											 inner join PCEMascaras M on M.PCEMid = CM.PCEMid 
					  						 inner join PCNivelMascara D  on M.PCEMid = D.PCEMid 
											 where AN.CFcuenta = da.CFcuenta
                    						 and PCNdescripcion  like 'RUBROS')),GECtipo,
case when GECtipo = 1 or GECtipo = 2 or GECtipo = 3 then (select case substring(CFdescripcion,1,8) 
							when 'GERENCIA' then
							(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
	  			            from CFuncional cf 
	  					    inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                      		inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
                      		where cf.CFid = (select distinct CFidresp from GEcomision c
																 left join GEanticipo a on c.GECid = a.GECid
 																 inner join CFuncional cf on c.CFid = cf.CFid and                                                                 c.Ecodigo = cf.Ecodigo
																 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp                                                                 and ef.Ecodigo = cf.Ecodigo
									 							 where c.GECid = #form.GECid# 
																 <cfif #form.GEAid# NEQ 0>
																 	and a.GEAid = #form.GEAid# 
																 </cfif>
																 and c.Ecodigo = co.Ecodigo and ECFencargado = 1)
		  				    and cf.Ecodigo = co.Ecodigo and ECFencargado = 1)
                            when 'AREA DE ' then
                             (select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    from GEcomision c
							left join GEanticipo a on c.GECid = a.GECid
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where c.GECid = #form.GECid# 
							<cfif #form.GEAid# NEQ 0>
								and a.GEAid = #form.GEAid#
							</cfif>
							and c.Ecodigo = co.Ecodigo 
							and ECFencargado = 1 )                             
							when 'SUBDIREC' then
							(select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    from GEcomision c
							left join GEanticipo a on c.GECid = a.GECid
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where c.GECid = #form.GECid# 
							<cfif #form.GEAid# NEQ 0>
								and a.GEAid = #form.GEAid#
							</cfif>
							and c.Ecodigo = co.Ecodigo 
							and ECFencargado = 1)
                            when 'ORGANO I' then
							<cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
								(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    	from CFuncional cf 
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    	inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			               		where cf.Ecodigo = co.Ecodigo and ECFencargado = 1 and CFdescripcion like 
								'DIRECCION GENERAL')
							<cfelse>
								(select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
							    from GEcomision c
								left join GEanticipo a on c.GECid = a.GECid 
								inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            				    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			            	    where c.GECid = #form.GECid# 
								<cfif #form.GEAid# NEQ 0>
									and a.GEAid = #form.GEAid#
								</cfif>
								and  c.Ecodigo = co.Ecodigo and ECFencargado = 1)
							</cfif> 
							when 'DIRECCIO' then
							<cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
								(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    	from CFuncional cf 
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    	inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			               		where cf.Ecodigo = co.Ecodigo and ECFencargado = 1 and CFdescripcion like 
								'DIRECCION GENERAL')
							<cfelse>
								(select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
							    from GEcomision c
								left join GEanticipo a on c.GECid = a.GECid 
								inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
								inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            				    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			            	    where c.GECid = #form.GECid# 
								<cfif #form.GEAid# NEQ 0>
									and a.GEAid = #form.GEAid#
								</cfif>
								and  c.Ecodigo = co.Ecodigo and ECFencargado = 1)
							</cfif>
							end from CFuncional where CFid = co.CFid)
end as Aprueba,
case when GECtipo = 1 then ''
when GECtipo = 2 or GECtipo = 3 then
 (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
						    from CFuncional cf 
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			                where cf.Ecodigo = co.Ecodigo and ECFencargado = 1 and CFdescripcion like 'DIRECCION GENERAL') 
end as Autoriza,co.GECdestino, co.GECDid, cD.GECDdescripcion,
GECobservaciones as Observaciones, GECobservacionesArrend as MotArrendamiento, 
Periodo = convert(varchar(4),year(co.GECfechaSolicitud))+' '+right('0'+convert(varchar,month(co.GECfechaSolicitud)),2),
PeriodoCom = convert(varchar(10),co.GECdesde,103)+' al '+convert(varchar(10),co.GEChasta,103)  
from GEcomision co
left join GEanticipo sa on co.GECid = sa.GECid
left join Empresas e on e.Ecodigo=co.Ecodigo left join Monedas m on m.Ecodigo=sa.Ecodigo 
and m.Mcodigo=sa.Mcodigo 
left outer join CFuncional cfn on cfn.CFid = co.CFid left outer join Tesoreria tes on tes.TESid = sa.TESid 
left outer join TESbeneficiario tb on tb.TESBid = co.TESBid left join Usuario u 
left join DatosPersonales dp on dp.datos_personales=u.datos_personales on u.Usucodigo=co.UsucodigoSolicitud 
left join GEanticipoDet da left join CFinanciera cf on cf.CFcuenta=da.CFcuenta 
left join GEconceptoGasto cg on da.GECid=cg.GECid on da.GEAid=sa.GEAid left join Usuario uR 
left join DatosPersonales dpR on dpR.datos_personales=uR.datos_personales on uR.Usucodigo=sa.BMUsucodigo 
left join Usuario uA on uA.Usucodigo=sa.BMUsucodigo left join TESsolicitudPago x on sa.TESSPid = x.TESSPid 
left join GEPlantillaViaticos gep on gep.GEPVid= da.GEPVid left join GEClasificacionViaticos gec on gep.GECVid=gec.GECVid 
left join GEcategoriaDestino cD on co.GECDid = cD.GECDid
where co.Ecodigo= #session.Ecodigo# and co.GECid= #form.GECid# 
<cfif #form.GEAid# NEQ 0>
	and sa.GEAid = #form.GEAid# 
</cfif>
order by da.GEADfechaini,da.GEADhoraini,gep.GEPVid 

	</cfquery>	
    <cfset Aprueba = rsReporteTotal.Aprueba>
    <cfset Autoriza = rsReporteTotal.Autoriza>
	<cfquery name = "rsDirFin" datasource="#session.dsn#">
        	select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre --, cf.CFid, CFdescripcion
			from CFuncional cf 
			inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and ECFencargado = 1 and CFdescripcion like  'DIRECCION DE ADMINISTRACION Y FINANZAS'
    </cfquery>
	<cfif rsReporteTotal.GECtipo NEQ 1>
        <cfset Autoriza = rsDirFin.Nombre>
	</cfif>
    <cfif  rsReporteTotal.Aprueba EQ rsBeneficiario.TESBeneficiario>
    		<cfset Aprueba = rsDirFin.Nombre>
    </cfif>
	
	<cfquery datasource="#session.dsn#" name="rsReporteDet">
		select distinct it.GECIid,it.GECIorigen, it.GECIdestino, it.GECIhotel, convert(varchar(10),it.GECIfsalida,103) as 		        GECIfsalida, 
		replace (convert(varchar,convert(dec(10,2),#preserveSingleQuotes(LvarInicio)#))+ '/' +  				        convert(varchar,convert(dec(10,2),#preserveSingleQuotes(LvarFinal)#)),'.',':') as Horario,
		it.GECIlineaAerea, it.GECInumeroVuelo
		from GEcomision c 
		left join GEanticipo a on c.GECid = a.GECid
		left join GECitinerario it on it.GECid = c.GECid 
		where c.Ecodigo = #session.Ecodigo# and c.GECid = #form.GECid# 
		<cfif #form.GEAid# NEQ 0>
			and a.GEAid = #form.GEAid#
		</cfif> 
		order by GECIid	
	</cfquery>
		
	<cfif len(trim(#rsReporteTotal.CCHid#))>
		<cfquery name="rsCajas" datasource="#session.dsn#">
			select CCHcodigo,CCHdescripcion from CCHica where CCHid=#rsReporteTotal.CCHid#
		</cfquery>
	</cfif>
</cfif><cfoutput>
<cfif isdefined('rsReporteTotal') and rsReporteTotal.recordCount GT 0>
	<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	<table width="100%" border="0">
	<tr>
		<td colspan="5" align="center"><strong>#rsReporteTotal.Edescripcion#</strong></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><strong>SOLICITUD DE ANTICIPO DE VIATICOS</strong></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><strong>AUTORIZACION  DE COMISION</strong></td>
	</tr>
</table>
<br/>
<table  width="100%" border="1">
	<tr>
		<td width="30%">Referencia: #rsReporteTotal.Referencia#</td>
		<!--td width="15%">campo referencia</td-->
		<td width="30%">Fecha Solicitud: #rsReporteTotal.GECfechaSolicitud#</td>
		<!--td width="14%">campo  fecha</td-->
		<td width="40%">Comisionado: #rsReporteTotal.TESBeneficiario#</td>
		<!--td width="27%">campo comisionado</td-->
	</tr>
</table>
<table	width="100%" border="1">
	<tr>
		<td width="23%">Tipo: #rsReporteTotal.TipoComision#</td>
		<!--td>campo tipo</td-->
		<td width="28%">Destino: #rsReporteTotal.GECdestino# </td>
		<!--td width="5%">campo Destino </td-->
		<td width="24%">Arrendamiento: #rsReporteTotal.Arrendamiento#</td>
		<!--td width="10%">campo Arrendamiento</td-->
        <td width="25%"><cf_translate key = LB_PaqDatosMov xmlfile = "solicitudesAnticipo.xml">Paquete de Datos Moviles</cf_translate>: #rsReporteTotal.Internet#</td>
		<!--td width="10%">campo Arrendamiento</td-->
        
	</tr>
	</table>
	<table width="100%" border="1">
	<tr>
		<td width="30%" height="23">Periodo: #rsReporteTotal.PeriodoCom# </td>
		<!--td>campo periodo</td-->
		<td width="40%">Anticipo Gastos: #rsReporteTotal.Anticipo# </td> 
		<!--td><campo anticipo gastos--></td>
	</tr>
</table>
<table border="1" width="100%">
	<tr>
		<td width="60%">
			Descripcion: #rsReporteTotal.GECdescripcion#
		</td>
		<td width="40%">Categoria del Destino: #rsReporteTotal.GECDdescripcion#</td>
	</tr>

</table>
<table border="1" width="100%">
		<tr >
		<td >Motivo, Observaciones: #rsReporteTotal.Observaciones#</td>
		<!--<td>campo Observaciones</td>-->
		</tr>
		<tr>
		<td >Motivo de Arrendamiento: #rsReporteTotal.MotArrendamiento#</td>
		<!--<td>campo arrendamiento</td>-->
		</tr>
</table>
<br /><strong>
Reservaciones de Hospedaje y Transporte
</strong>

<table width="100%" border="1">
	<tr>
		<td width="13%" align="center">Ciudad Origen</td>
		<td width="13%" align="center">Ciudad Destino</td>
		<td width="25%" align="center">Hotel</td>
		<td width="13%" align="center">Fecha de Salida</td>
		<td width="13%" align="center">Línea Aerea</td>
		<td width="10%" align="center">Horario</td>
		<td width="13%"align="center">Núm. de Vuelo</td>
	</tr>
<cfloop query ="rsReporteDet">
	<tr>
		<td width="13%" align ="center" height="20" >#rsReporteDet.GECIorigen#</td>
		<td width="13%" align ="center">#rsReporteDet.GECIdestino#</td>
		<td width="25%" align ="center">#rsReporteDet.GECIhotel#</td>
		<td width="13%" align ="center">#rsReporteDet.GECIfsalida#</td>
		<td width="13%" align ="center">#rsReporteDet.GECIlineaAerea#</td>
		<td width="10%" align ="center">#rsReporteDet.Horario#</td>
		<td width="13%" align ="center">#rsReporteDet.GECInumeroVuelo#</td>
	</tr>
	</cfloop>
</table>
<!----------------------------- a partir de esta tabla que no muestre ????---------------------->
<br />

<strong>
Datos del Monto a Autorizar
</strong>
<table width = "100%" border = "1">
	<tr>
		<td ><strong>Fecha de Pago:</strong> #DateFormat(rsReporteTotal.GECfechaPagar,"DD/MM/YYYY")#</td>
		<!--<td width="84%" align="left">campo fecha</td>-->
	</tr>
</table>	
<table width = "100%" border = "1">
	<tr>
		<td width="35%" align="center">Rubro</td>
		<td width="35%" align="center">Sub Rubro</td>
		<td width="15%" align="center">Moneda</td>
		<td width="15%" align="center">Importe</td>
	</tr>
<cfif #form.GEAid# NEQ 0>	
<cfloop query="rsReporteTotal"> 
	<tr>
		<td width="35%" align="center">#rsReporteTotal.Rubro#</td>
		<td width="35%" align="center">#rsReporteTotal.SubRubro#</td>
		<td width="15%" align="center">#rsReporteTotal.Miso4217#</td>
		<td width="15%" align="center">#rsReporteTotal.GEADmonto#</td>
	</tr>
</cfloop>
<cfelse>
	<tr>
		<td width="35%" align="center">&nbsp;</td>
		<td width="35%" align="center">&nbsp;</td>
		<td width="15%" align="center">&nbsp;</td>
		<td width="15%" align="center">&nbsp;</td>
	</tr>
</cfif>	
</table>

<table width = "100%" border = "1">
	<tr>
	 	<td width="70%" >Unidad Ejecutora</td>
		<td width="30%" align ="center">Periodo</td>
  </tr>
  <tr>
  		<td>#rsReporteTotal.CFdescripcion#</td>
		<td align ="center">#rsReporteTotal.Periodo#</td>
  </tr>
</table>	
<br />
<table width="100%">
					<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
					</tr>
					<tr>
						<td width="30%" align="center">____________________________________</td>
						<td width="40%" align="center">____________________________________</td>
                        
<!---	ERBG 23/04/2014					
						<cfif rsReporteTotal.TipoComision NEQ 'Nacional'>
							<cfif rsReporteTotal.Aprueba NEQ rsReporteTotal.Autoriza>                            
                        		<td width="50%" align="center">____________________________________</td>
                            </cfif>    
						</cfif>
--->                        
					</tr>
					<tr>
						<td  align="center">#rsReporteTotal.TESBeneficiario#</td>
						<td  align="center">#Aprueba#</td>
                        
<!---	ERBG 23/04/2014					
						<cfif rsReporteTotal.TipoComision NEQ 'Nacional'>
                        	<cfif rsReporteTotal.Aprueba NEQ rsReporteTotal.Autoriza>                            
								<td  align="center">#Autoriza#</td>
                            </cfif>    
						</cfif>
--->                        
					</tr>
					<tr>
						<td  align="center"><strong>&nbsp;Comisionado&nbsp; </strong></td>
                        <!---ERBG 23/04/2014 Inicia--->
                        <td  align="center"><strong>&nbsp;Autoriza&nbsp;</strong></td>
                        <!---ERBG 23/04/2014 Fin--->
<!---    ERBG 23/04/2014	                    
						<cfif rsReporteTotal.TipoComision EQ 'Nacional'>
							<td  align="center"><strong>&nbsp;Autoriza&nbsp;</strong></td>
                        <cfelse>
                       
                        	<cfif rsReporteTotal.Aprueba NEQ rsReporteTotal.Autoriza>
                        		<td  align="center"><strong>&nbsp;Aprueba&nbsp;</strong></td>
                             <cfelse>  
                             	<td  align="center"><strong>&nbsp;Autoriza&nbsp;</strong></td>
                                 <!---<cfthrow message="#rsReporteTotal.Aprueba# #rsReporteTotal.Autoriza#">--->
                            </cfif>    
                        </cfif>
--->                        
<!---	ERBG 23/04/2014						
						<cfif rsReporteTotal.TipoComision NEQ 'Nacional'>
							<cfif rsReporteTotal.Aprueba NEQ rsReporteTotal.Autoriza>                            
                        		<td  align="center"><strong>&nbsp;Autoriza&nbsp;</strong></td>
                                 <!---<cfthrow message="#rsReporteTotal.Aprueba# #rsReporteTotal.Autoriza#">--->
                            </cfif>    
						</cfif>
--->                        
					</tr>
</table>
<br />
<strong>El comisionado manifiesta bajo protesta de decir verdad, que las fechas indicadas constituyen el período real de la comisión y da autorización expresa para descontar vía nómina, el anticipo y demás gastos incurridos en la misma cuando no se haga la comprobación respectiva en el plazo establecido.</strong>
<table width="100%"  border="0" cellspacing="1" cellpadding="1" style=" border:solid 1px gray;">
					<tr>
						<td>Para uso  exclusivo  de la tesoreria</td>
					</tr>	
					<tr>
						<!--<td  align="center">&nbsp;&nbsp;</td>-->
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr>
							<td align="center">Banco: ______________________</td>
							<td align="center">Cuenta: _____________________</td>
							<td align="center">Cheque: _____________________</td>
					</tr>
					<!--<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>-->
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
						<td  align="center">&nbsp;&nbsp;</td>
					</tr>
					<tr >
							<td align="center">Elabora</td> 
							<td align="center">Autoriza</td>
							<td align="center">Fecha y Firma de Recibido</td>
							
					</tr>	
</table>
				<table width="100%">
					<tr>
						<td width="10%"> Elabora: #rsReporteTotal.elaboradoPor#</td>
						<td width="10%"> Fecha: #rsReporteTotal.GECfechaSolicitud# </td>
						
					</tr>
				</table>
                
                
                 <table width="100%">
					<td align="center" width="10%"> 
</td>
				</table>


                <table width="100%">
					<tr>
						<td  width="10%"> <strong>
                        C.C.P. Subdirección de Administración
</td>
						
						
					</tr>
				</table>

	
	
</cfif>
</cfoutput>		


