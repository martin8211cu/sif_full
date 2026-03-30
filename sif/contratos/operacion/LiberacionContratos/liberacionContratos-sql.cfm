<cfset modo = "ALTA">

<cfif isdefined("Form.btnGuardarD") or isdefined("Form.btnAplicar")>

		<cfquery name="rsDetDocsProvision" datasource="#Session.DSN#">
			select CTCnumContrato
			  from CTContrato
			  where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
			  and Ecodigo = #Session.Ecodigo#
			 order by CTCnumContrato
		</cfquery>
		<!---El Tipo de Liberacion se actualiza para todos los detalles de la liberacion--->
		<cfif isdefined('form.tipoLibera')>
			<cfquery name="rsTipoLib" datasource="#session.DSN#">
				update CTDetLiberacion
			    	set TipoLiberacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipoLibera#">
			    where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
			    and Estatus = 0
			</cfquery>
			<cfif form.tipoLibera EQ 'S'>
				<cfquery name="rsTipoLib" datasource="#session.DSN#">
					update CTDetLiberacion
				    	set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="0">
				    where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
				    and exists (select 1
				    			from CTDetContrato b
				    			where CTDetLiberacion.CTContid = b.CTContid
				    			and CTDetLiberacion.CTDCont = b.CTDCont
				    			and b.CPDEid = -1)
				    and Estatus = 0
				</cfquery>
			</cfif>
		</cfif>

		<cfset fechaAct = Now()>
		<cfloop collection="#Form#" item="elem">
			<cfif FindNoCase('montlib_', elem) EQ 1 and Len(Trim(Form[elem])) >

				<cfset id = Mid(elem, Len('montLib_')+1, Len(elem))>
				<cfset montoL = Form[elem].replace(",","")>

				<cfquery name="rsDetLib" datasource="#Session.DSN#">
					select a.CTDContL,a.CTDCont,a.Monto,a.Estatus
					from CTDetLiberacion a
						left join CTDetContrato b
						on a.CTContid = b.CTContid and a.CTDCont = b.CTDCont
					where b.CTDCont	= #id#
					and a.Estatus = 0
				</cfquery>

				<!--- Modificacion de Tabla de Liberacion --->
				<cfif rsDetLib.recordcount gt 0>
				    <cfquery name="UpDetLib" datasource="#Session.DSN#">
					    update CTDetLiberacion
					    set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#montoL#">,
					      	BMUsucodigo = #session.usucodigo#
					    where CTDCont = #id#
					    and Estatus = 0
					</cfquery>
				<cfelse>
					<cfquery name="NuevoDocLib" datasource="#Session.DSN#">
						insert into CTDetLiberacion (Ecodigo,TipoLiberacion,CTContid,CTDCont,Documento,Monto,Estatus,Fecha,BMUsucodigo)
						values(#Session.Ecodigo#,
						<cfif isdefined('form.tipoLibera')>
							   <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipoLibera#">,
						<cfelse>
							   null,
						</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">,
							   #id#,
							   '#rsDetDocsProvision.CTCnumContrato#',
							    <cfqueryparam cfsqltype="cf_sql_money" value="#montoL#">,
							    0,
							    <cfqueryparam cfsqltype="cf_sql_date" value="#fechaAct#">,
							    #session.Ecodigo#)
					</cfquery>
			  </cfif>

			</cfif>
		</cfloop>

			<cfset CTContid = Form.CTContid>
			<cfset modo="CAMBIO">

		<!--- -------------------------------------------------- SECCION DE APLICAR ------------------------------------------ --->
	<cfif isdefined("Form.btnAplicar")>

			<cfscript>
				LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto");
				LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true);
			</cfscript>


				<cfquery name="consecutivo" datasource="#Session.dsn#">
					select
						cl.Documento
					from CTContrato  a
						left join CTDetContrato b
						on a.CTContid = b.CTContid
						left join CTDetLiberacion cl
						on b.CTContid = cl.CTContid and b.CTDCont = cl.CTDCont
					where a.Ecodigo = #Session.Ecodigo#
					and cl.Estatus=1
					and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					group by cl.Documento
				</cfquery>

<!--- Query para los que no son de distribucion --->
				<cfquery name="rsDetalle" datasource="#Session.DSN#">
				   select
				   a.CPPid, b.CTDCont, a.CTContid,b.CTDCconsecutivo,cl.Monto,cl.CTDContL,
				   a.CTCnumContrato, a.CTCdescripcion, a.CTfecha,b.CPcuenta, b.CPCano, b.CPCmes,cp.Mcodigo,b.CPcuenta,b.CTDCmontoTotalOri,b.CPDDid
					from CTContrato  a
						left join CTDetContrato b
						on a.CTContid = b.CTContid
						left join CTDetLiberacion cl
						on b.CTContid = cl.CTContid and b.CTDCont = cl.CTDCont
						inner join CPresupuestoPeriodo cp
						on cp.CPPid = a.CPPid
					where a.Ecodigo = #Session.Ecodigo#
					and cl.Estatus = 0
					and cl.Monto > 0
					and b.CPcuenta is not null
					and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					order by a.CTfecha desc, a.CTCnumContrato
				</cfquery>
<!--- AUXILIARES --->
			<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo=#Session.Ecodigo#
				and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
			</cfquery>

			<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo=#session.Ecodigo#
				and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
			</cfquery>


				<cfset MesCont = rsMesAuxiliar.Pvalor>
				<cfset fechaAct = Now()>
				<cfset consec = consecutivo.recordcount + 1>
				<cfset linea=1>

<!--- Query para cuando es por distribucion por concepto de servicio--->
	<cfquery name="rsConDistribucion" datasource="#session.DSN#">
				select
					'CTLC' as ModuloOrigen,
					b.CTCnumContrato,
					b.CTTCid as NumeroReferencia,
					b.CTfecha as FechaDocumento,
					c.CPCano as AnoDocumento,
					c.CPCmes as MesDocumento,
					napSC.Ocodigo as Ocodigo,
					b.CTMcodigo as Mcodigo,
					'CC' as TipoMovimiento,
					d.NAP,b.NAP as NP1,cl.Monto,
                    a.Cid,
                    a.CPDCid,
                    a.CMtipo as TipoItem,
                    f.Oficodigo as CodigoOficina,
                    a.Ccodigo,a.CTDCont
				from CTDetContrato a
					inner join CTContrato b
					 on b.CTContid = a.CTContid
                     inner join CPDocumentoD c
                     	on c.CPDEid = a.CPDEid
                        and a.CPCano = c.CPCano
                        and a.CPCmes = c.CPCmes
                      inner join CPDocumentoE d
                      	on c.CPDEid = d.CPDEid
                      inner join  CPNAPdetalle napSC
                         on napSC.Ecodigo		= a.Ecodigo
                        and napSC.CPNAPnum		= d.NAP
       					and napSC.CPNAPDlinea	= c.CPDDlinea
                      inner join CFuncional  e
                       	on a.CFid = e.CFid
                        inner join Oficinas f
					on f.Ocodigo = e.Ocodigo
					and f.Ecodigo = e.Ecodigo
					left join CTDetLiberacion cl
					on a.CTContid = cl.CTContid and a.CTDCont = cl.CTDCont

				where b.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ctcontid#">
                and c.CPDCid is not null
                and a.Cid is not null
				and cl.Estatus = 0
				and cl.Monto > 0
                group by
					b.CTTCid ,CTfecha,c.CPCano, c.CPCmes,b.CTCnumContrato,
					a.CTDCconsecutivo, napSC.Ocodigo, b.CTMcodigo,b.CTtipoCambio,d.NAP,b.NAP,a.Cid, a.CPDCid,a.CMtipo,f.Oficodigo,
                    a.Ccodigo, a.CTDCmontoTotalOri,cl.Monto,a.CTDCont
			</cfquery>

<!--- Query para cuando es distribucion por clasificacion --->
	<cfquery name="rsClasificacionConDistribucion" datasource="#session.DSN#">
				select
					'CTLC' as ModuloOrigen,
					b.CTCnumContrato,
					b.CTTCid as NumeroReferencia,
					b.CTfecha as FechaDocumento,
					c.CPCano as AnoDocumento,
					c.CPCmes as MesDocumento,
					a.CTDCconsecutivo,
					napSC.Ocodigo as Ocodigo,
					b.CTMcodigo as Mcodigo,
					b.CTtipoCambio,
					d.NAP,b.NAP as NP1,cl.Monto,
					'CC' as TipoMovimiento,
                    a.Cid,
                    a.CPDCid,
                    a.CMtipo as TipoItem,
                    f.Oficodigo as CodigoOficina,
                    a.Ccodigo,a.CTDCont
				from CTDetContrato a
					inner join CTContrato b
					 on b.CTContid = a.CTContid
                     inner join CPDocumentoD c
                     	on c.CPDEid = a.CPDEid
                        and a.CPCano = c.CPCano
                        and a.CPCmes = c.CPCmes
                      inner join CPDocumentoE d
                      	on c.CPDEid = d.CPDEid
                      inner join  CPNAPdetalle napSC
                         on napSC.Ecodigo		= a.Ecodigo
                        and napSC.CPNAPnum		= d.NAP
       					and napSC.CPNAPDlinea	= c.CPDDlinea
                       inner join CFuncional  e
                       	on a.CFid = e.CFid
                        inner join Oficinas f
					on f.Ocodigo = e.Ocodigo
					and f.Ecodigo = e.Ecodigo
					left join CTDetLiberacion cl
					on a.CTContid = cl.CTContid and a.CTDCont = cl.CTDCont
				where b.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ctcontid#">
                and c.CPDCid is not null
                and a.Ccodigo is not null
				and cl.Estatus = 0
				and cl.Monto > 0
				   group by
					b.CTTCid ,CTfecha,c.CPCano, c.CPCmes,b.CTCnumContrato,
					a.CTDCconsecutivo, napSC.Ocodigo, b.CTMcodigo,b.CTtipoCambio,d.NAP,b.NAP,cl.Monto,a.Cid, a.CPDCid,a.CMtipo,f.Oficodigo,
                    a.Ccodigo, a.CTDCmontoTotalOri,a.CTDCont
			</cfquery>
<!---  <cf_dump var="#rsClasificacionConDistribucion#">  --->

<!--- *************Distribucion de Clasificacion************* --->
<cftransaction action="begin">
	<cftry>
<cfif rsClasificacionConDistribucion.recordcount GT 0>
<cfset numdocumento = "#consec#-#rsClasificacionConDistribucion.CTCnumContrato#">
	<!---<cftransaction>--->
   	<cfloop query="rsClasificacionConDistribucion">

    <!--- Obtiene la distribucion --->
					<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
					Ccodigo = "#rsClasificacionConDistribucion.Ccodigo#"
                    CPDCid ="#rsClasificacionConDistribucion.CPDCid#"
                    Tipo ="#rsClasificacionConDistribucion.Tipoitem#"
                    Aplica ="1"
                    cantidad ="1"
                    monto ="#rsClasificacionConDistribucion.Monto#"
                returnVariable="rsDistribucion">
<!---  <cf_dump var="#rsDistribucion#"> --->
	   <cfset NumLinea = 0>
		<cfloop query="rsDistribucion">
          <cfset varIDcuenta = #rsDistribucion.IDcuenta#>
          <cfset varmonto = #rsDistribucion.Monto#>

                <cfquery name="rsFinancieras" datasource="#session.DSN#">
                    select * from CFinanciera
                    where Ecodigo = #Session.Ecodigo#
                </cfquery>

                <cfquery name="rsFinanciera" dbtype="query">
                    select rsFinancieras.CPcuenta,#varmonto# as monto, rsFinancieras.CFcuenta
                    from rsFinancieras,rsDistribucion
                    where rsFinancieras.CFcuenta = #varIDcuenta#
                </cfquery>

				<cfquery name="rsNAPE" datasource="#session.DSN#">
                    select * from CPNAPdetalle a
                        inner join CPNAP b
                            on a.CPNAPnum = b.CPNAPnum
                    where a.CPNAPnum = #rsClasificacionConDistribucion.NP1#
                    and a.CPcuenta = #rsFinanciera.CPcuenta#
                    and CPNAPDtipoMov = 'CC'
                    and a.CPCmesP = #rsClasificacionConDistribucion.MesDocumento#
                 </cfquery>


            	 <cfquery name="rsLineasNAP" dbtype="query">
                    select * from rsFinanciera, rsNAPE
                    where rsFinanciera.CPcuenta = rsNAPE.CPcuenta
                    order by CFid
				</cfquery>

<!--- <cf_dump var="#rsLineasNAPs#"> --->
		<cfset MontoDC = 0>
        <cfset NumLinea = NumLinea + 1>
 	 <!--- <cf_dump var="#rsLineasNAP1s#"> --->
					<cfquery name="rs" datasource="#session.DSN#">
						insert into #request.intPresupuesto#(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							NumeroLinea,
							CPcuenta,
							Ocodigo,
							CodigoOficina,
							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,
							TipoMovimiento,
							NAPreferencia,
							LINreferencia)

 			values(

                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.ModuloOrigen#">,
                           '#numdocumento#',
                           <cfqueryparam cfsqltype="cf_sql_varchar" value="Liberaci&oacute;n">,
                           <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.AnoDocumento#">,
                         <!---  <cfif rsLineasNAP.CPCmes LTE rsMesAuxiliar.Pvalor>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMesAuxiliar.Pvalor#">,
                           <cfelse>--->
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasNAP.CPCmes#">,
                          <!--- </cfif>--->
						    -1*(#rsLineasNAP.CPNAPDlinea#),
                            '#rsLineasNAP.CPcuenta#',
                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
                          -1*(#rsLineasNAP.Monto#),
							1,
                          -1*(#rsLineasNAP.Monto#),
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.TipoMovimiento#">,
							#rsLineasNAP.CPNAPnum#, 	<!---NAPreferencia--->
                       		#rsLineasNAP.CPNAPDlinea#  <!---LINreferencia--->
                     )
				</cfquery>

				<cfset MontoDC = MontoDC + #rsLineasNAP.Monto#>
				<cfset linea = linea + 1>

			 <!--- rsDistribucion --->

			<!--- para la suficiencia --->
			<cfif Form.tipolibera eq "S">
		<cfset MontoDCS=0>
<!--- 	<cf_dump var="#rsLineasNAPs#">
					<cfloop query="rsLineasNAPs"> --->
                 <cfquery name="rsNAPSuf" datasource="#session.DSN#">
                        select * from CPNAPdetalle a
                            inner join CPNAP b
                                on a.CPNAPnum = b.CPNAPnum
                        where a.CPNAPnum = #rsConDistribucion.NP1#
                        and a.CPcuenta = #rsFinanciera.CPcuenta#
                        and CPNAPDtipoMov = 'RP'
                        and a.CPCmesP = #rsConDistribucion.MesDocumento#
                     </cfquery>

					<cfquery name="rs" datasource="#session.DSN#">
						insert into #request.intPresupuesto#(
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,
							NumeroLinea,
							CPcuenta,
							Ocodigo,
							CodigoOficina,
							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,
							TipoMovimiento,
							NAPreferencia,
							LINreferencia)
		 values(

                       <cfqueryparam cfsqltype="cf_sql_varchar" value="CTLC">,
                       '#numdocumento#',
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="Provisi&oacute;n">,
                       <cfqueryparam cfsqltype="cf_sql_date" value="#rsClasificacionConDistribucion.FechaDocumento#">,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.AnoDocumento#">,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasNAP.CPCmes#">,
                       #rsLineasNAP.CPNAPDlinea#,
                       '#rsLineasNAP.CPcuenta#',
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Ocodigo#">,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.CodigoOficina#">,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsClasificacionConDistribucion.Mcodigo#">,
                        #rsLineasNAP.Monto#,
                       1,
                        #rsLineasNAP.Monto#,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="RP">,
                       #rsNAPSuf.CPNAPnumRef#, 	<!---NAPreferencia--->
					   #rsNAPSuf.CPNAPDlineaRef#    <!---LINreferencia--->
              )
				</cfquery>


		<cfset MontoDCS = MontoDCS + #rsLineasNAP.Monto#>
		<cfset linea = linea + 1>

			<!--- Actualizacion de Saldos en Detalles del Documento --->
				<cfquery name="rsActualizaSaldo" datasource="#Session.dsn#">
					select distinct b.CPDEid from CPDocumentoE a
					inner join CPDocumentoD b
					on a.CPDEid = b.CPDEid
			 		where a.NAP = #rsClasificacionConDistribucion.NAP#
				</cfquery>

				<cfquery name="upActualizaSaldo" datasource="#Session.dsn#">
					update CPDocumentoD
					set CPDDsaldo = CPDDsaldo + #rsLineasNAP.Monto#
			 		where CPDEid = #rsActualizaSaldo.CPDEid#
			 		and CPcuenta = #rsLineasNAP.CPcuenta#
                    and CPCmes = #rsClasificacionConDistribucion.MesDocumento#
				</cfquery>

		</cfif>
	</cfloop> <!--- rsDistribucion --->

			<!--- Fin del if de Suficiencia --->

	<!--- se actualiza el DetalleLib --->
				<cfquery name="upDetalle" datasource="#Session.DSN#">
					update CTDetLiberacion
					set Estatus = 1,
						Consecutivo=#consec#,
						Documento = '#numdocumento#',
						Periodo = #rsClasificacionConDistribucion.AnoDocumento#,
						Mes = #rsClasificacionConDistribucion.MesDocumento#,
						TipoLiberacion = '#Form.tipolibera#',
						BMUsucodigo = #Session.Ecodigo#
					where CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsClasificacionConDistribucion.CTDCont#">
					and Estatus=0
					and Ecodigo = #Session.Ecodigo#
				</cfquery>

				<cfquery name="upDetalle" datasource="#Session.DSN#">
					update CTDetContrato
					set CTDCmontoConsumido = round(CTDCmontoConsumido + #rsClasificacionConDistribucion.Monto#,2),
						BMUsucodigo = #Session.Ecodigo#
					where CTDCont = #rsClasificacionConDistribucion.CTDCont#
					and Ecodigo = #Session.Ecodigo#
				</cfquery>
                
                
			<!--- Fin de ser por suficiencia --->

		</cfloop> <!--- rsLineasConDistribucion --->
<!---</cftransaction>--->
</cfif>




<!--- *************Distribucion de Conceptos de Servicio************* --->
<cfif rsConDistribucion.recordcount GT 0>
<cfset numdocumento = "#consec#-#rsConDistribucion.CTCnumContrato#">
<!---<cftransaction>--->
	 		

	<cfloop query="rsConDistribucion">
    
		<!--- Obtiene la distribucion --->
		<cfinvoke component="sif.Componentes.PRES_Distribucion" method="GenerarDistribucion"
			Cid = "#rsConDistribucion.Cid#"
			CPDCid ="#rsConDistribucion.CPDCid#"
			Tipo ="#rsConDistribucion.Tipoitem#"
			Aplica ="1"
			cantidad ="1"
			monto ="#rsConDistribucion.Monto#"
			returnVariable="rsDistribucion">
            	<cfset NumLinea = 0>


            	<cfloop query="rsDistribucion">
                    <cfset varIDcuenta = #rsDistribucion.IDcuenta#>
                    <cfset varmonto = #rsDistribucion.Monto#>

            		<cfquery name="rsFinancieras" datasource="#session.DSN#">
					    select * from CFinanciera
					    where Ecodigo = #Session.Ecodigo#
					</cfquery>

                    <cfquery name="rsFinanciera" dbtype="query">
					   select rsFinancieras.CPcuenta,#varmonto# as monto, rsFinancieras.CFcuenta
					   from rsFinancieras,rsDistribucion
					   where rsFinancieras.CFcuenta = #varIDcuenta#
					</cfquery>

                    <cfquery name="rsNAPE" datasource="#session.DSN#">
                        select * from CPNAPdetalle a
                            inner join CPNAP b
                                on a.CPNAPnum = b.CPNAPnum
                        where a.CPNAPnum = #rsConDistribucion.NP1#
                        and a.CPcuenta = #rsFinanciera.CPcuenta#
                        and CPNAPDtipoMov = 'CC'
                        and a.CPCmesP = #rsConDistribucion.MesDocumento#
                     </cfquery>

                     <cfquery name="rsLineasNAP" dbtype="query">
						select * from rsFinanciera, rsNAPE
						where rsFinanciera.CPcuenta = rsNAPE.CPcuenta
                        order by CFid
					</cfquery>
                  
                   

		<cfset MontoDS=0>
                <cfset NumLinea = NumLinea + 1>
			<cfquery name="rs" datasource="#session.DSN#">
										insert into #request.intPresupuesto#(
											ModuloOrigen,
											NumeroDocumento,
											NumeroReferencia,
											FechaDocumento,
											AnoDocumento,
											MesDocumento,
											NumeroLinea,
											CPcuenta,
											Ocodigo,
											CodigoOficina,
											Mcodigo,
											MontoOrigen,
											TipoCambio,
											Monto,
											TipoMovimiento,
											NAPreferencia,
											LINreferencia)
						 values(

				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.ModuloOrigen#">,
				                       '#numdocumento#',
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="Liberaci&oacute;n">,
				                       <cfqueryparam cfsqltype="cf_sql_date" value="#rsConDistribucion.FechaDocumento#">,
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.AnoDocumento#">,
                                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasNAP.CPCmes#">,
				                       -1*(#rsLineasNAP.CPNAPDlinea#),
				                       '#rsLineasNAP.CPcuenta#',
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Ocodigo#">,
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.CodigoOficina#">,
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Mcodigo#">,
				                       -1*(#rsLineasNAP.Monto#),
				                       1,
				                      -1*(#rsLineasNAP.Monto#),
				                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.TipoMovimiento#">,
				                       #rsLineasNAP.CPNAPnum#, 	<!---NAPreferencia--->
				                       #rsLineasNAP.CPNAPDlinea#    <!---LINreferencia--->
                                        )

								</cfquery>
                                
			<cfset MontoDS = MontoDS + #rsLineasNAP.Monto#>
			<cfset linea = linea + 1>

		<!--- rsDistribucion --->
		<!--- <cf_dump var="#rsLineasNAP#"> --->
		<cfif Form.tipolibera eq "S">
			<cfset MontoPR=0>
			<cfset NumLinea = NumLinea>
                <cfset NumLinea = NumLinea + 1>

                	<cfquery name="rsNAPSuf" datasource="#session.DSN#">
                        select * from CPNAPdetalle a
                            inner join CPNAP b
                                on a.CPNAPnum = b.CPNAPnum
                        where a.CPNAPnum = #rsConDistribucion.NP1#
                        and a.CPcuenta = #rsFinanciera.CPcuenta#
                        and CPNAPDtipoMov = 'RP'
                        and a.CPCmesP = #rsConDistribucion.MesDocumento#
                     </cfquery>
                	<cfquery name="rsNAPSuf" datasource="#session.DSN#">
                        select * from CPNAPdetalle a
                            inner join CPNAP b
                                on a.CPNAPnum = b.CPNAPnum
                        where a.CPNAPnum = #rsConDistribucion.NP1#
                        and a.CPcuenta = #rsFinanciera.CPcuenta#
                        and CPNAPDtipoMov = 'RP'
                        and a.CPCmesP = #rsConDistribucion.MesDocumento#
                     </cfquery>
				<cfquery name="rs" datasource="#session.DSN#">
																	insert into #request.intPresupuesto#(
																		ModuloOrigen,
																		NumeroDocumento,
																		NumeroReferencia,
																		FechaDocumento,
																		AnoDocumento,
																		MesDocumento,
																		NumeroLinea,
																		CPcuenta,
																		Ocodigo,
																		CodigoOficina,
																		Mcodigo,
																		MontoOrigen,
																		TipoCambio,
																		Monto,
																		TipoMovimiento,
                                                                        NAPreferencia,
																		LINreferencia)
													 values(

											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="CTLC">,
											                       '#numdocumento#',
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="Provisi&oacute;n">,
											                       <cfqueryparam cfsqltype="cf_sql_date" value="#rsConDistribucion.FechaDocumento#">,
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.AnoDocumento#">,
											                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasNAP.CPCmes#">,
											                       <!---#NumLinea#,--->
                              				                       #rsLineasNAP.CPNAPDlinea#,
											                       '#rsLineasNAP.CPcuenta#',
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Ocodigo#">,
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.CodigoOficina#">,
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConDistribucion.Mcodigo#">,
											                        #rsLineasNAP.Monto#,
											                       1,
											                        #rsLineasNAP.Monto#,
											                       <cfqueryparam cfsqltype="cf_sql_varchar" value="RP"><!---,
                                                                   #rsNAPSuf.CPNAPnumRef#, 	<!---NAPreferencia--->
											                       #rsNAPSuf.CPNAPDlineaRef#    <!---LINreferencia--->
											              )
															</cfquery>
                                                            
				<cfset MontoPR = MontoPR + #rsLineasNAP.Monto#>
				<cfset linea = linea + 1>
				<!--- Actualizacion de Saldos en Detalles del Documento --->
				<cfquery name="rsActualizaSaldo" datasource="#Session.dsn#">
					select distinct a.CPDEid from CPDocumentoE a
					inner join CPDocumentoD b
					on a.CPDEid = b.CPDEid
			 		where a.NAP = #rsConDistribucion.NAP#
				</cfquery>

				<cfquery name="upActualizaSaldo" datasource="#Session.dsn#">
					update CPDocumentoD
					set CPDDsaldo = CPDDsaldo + #rsLineasNAP.Monto#
			 		where CPDEid = #rsActualizaSaldo.CPDEid#
                    and CPCmes = #rsConDistribucion.MesDocumento#
			 		and CPcuenta = #rsLineasNAP.CPcuenta#
				</cfquery>

			<!--- rsDistribucion --->
		</cfif>
	</cfloop>
		<!--- Fin del if de Suficiencia --->
		<!--- se actualiza el DetalleLib --->
					<cfquery name="upDetalle" datasource="#Session.DSN#">
						update CTDetLiberacion
						set Estatus = 1,
							Consecutivo=#consec#,
							Documento = '#numdocumento#',
							Periodo = #rsConDistribucion.AnoDocumento#,
							Mes = #rsConDistribucion.MesDocumento#,
							TipoLiberacion = '#Form.tipolibera#',
							BMUsucodigo = #Session.Ecodigo#
						where CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConDistribucion.CTDCont#">
						and Estatus=0
						and Ecodigo = #Session.Ecodigo#
					</cfquery>

<!---                    <cfquery name="rsDetalle" datasource="#Session.DSN#">
						select CTDCmontoConsumido,#rsConDistribucion.Monto# from CTDetContrato
						where CTDCont = #rsConDistribucion.CTDCont#
						and Ecodigo = #Session.Ecodigo#
                        and CPCmes = #rsConDistribucion.MesDocumento#
					</cfquery>
                    <cf_dump var = #rsDetalle#>--->

					<cfquery name="upDetalle" datasource="#Session.DSN#">
						update CTDetContrato
						set CTDCmontoConsumido = round(CTDCmontoConsumido + #rsConDistribucion.Monto#,2),
							BMUsucodigo = #Session.Ecodigo#
						where CTDCont = #rsConDistribucion.CTDCont#
						and Ecodigo = #Session.Ecodigo#
					</cfquery>
	</cfloop>
	<!--- rsLineasConDistribucion --->

<!---<cfquery name="rs" datasource="#session.DSN#">
	select * from  #request.intPresupuesto#
</cfquery>--->

<!---</cftransaction>--->
<!---<cf_dump var = #rs#--->>
<!---<cf_dump var = #rs#--->>

	</cfif><!--- Fin de actualizacion Distribucion por Servicio --->


	<!--- Solo para cuando no corresponde la distribucion --->
	<cfif rsDetalle.recordcount gt 0>
	<cfset numdocumento = "#consec#-#rsDetalle.CTCnumContrato#">

	<!---<cftransaction>--->
		<!--- Insertamos el intPresupuesto si no es de distribucion --->


	<cfloop query="rsDetalle">

				<cfquery name ="NoNAP" datasource="#Session.dsn#">
					select CPNAPDlinea,c.CPCmes from CTContrato a
						inner join CTDetContrato b
							on a.CTContid = b.CTContid
						inner join CPNAPdetalle c
							on c.CPNAPnum = a.NAP
                            and b.CPcuenta = c.CPcuenta
					where  c.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPcuenta#">
					and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					and c.CPNAPDtipoMov = 'CC'
                    and c.CPCmesP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPCmes#">
                    and c.CPCanoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPCano#">
				</cfquery>


                <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
					insert into #Request.intPresupuesto# (
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,

						NumeroLinea,
						CPPid,
						CPCano,
						CPCmes,
						CPcuenta,
						Ocodigo,
						TipoMovimiento,

						Mcodigo,
						MontoOrigen,
						TipoCambio,
						Monto,

						NAPreferencia,
						LINreferencia
					)

					select 'CTLC' as ModuloOrigen,
						   '#numdocumento#' as NumeroDocumento,
						   'Liberación' as NumeroReferencia,
						   a.CTfecha as FechaDocumento,
						   #year(fechaAct)# as AnoDocumento,
						   #month(fechaAct)# as MesDocumento,

						   -1*(#NoNAP.CPNAPDlinea#) as NumeroLinea,
						   #rsDetalle.CPPid#,
					       #rsDetalle.CPCano#,
						   #NoNAP.CPCmes#,
						   #rsDetalle.CPcuenta#,
						   0,
						   'CC' as TipoMovimiento,

						   #rsDetalle.Mcodigo#,
						   (#rsDetalle.Monto# * -1) as MontoOrigen,
						   1.00 as TipoCambio,
						   (#rsDetalle.Monto# * -1) as Monto,

						   a.NAP as NAPreferencia,
						   #NoNAP.CPNAPDlinea#  as LINreferencia
					from CTContrato a
					where a.CTContid = #Form.CTContid#
					and a.Ecodigo = #Session.Ecodigo#
				</cfquery>
                

				<cfif Form.tipolibera eq "S">
					<cfset linea = linea + 1>
		<!---	     <cfquery name="rsNAP" datasource = "#Session.dsn#">
                    select det.NAP,dd.CPDDlinea,Napd.CPNAPDlinea
						from CTDetContrato cd
						inner join CPDocumentoD dd
							on cd.CPDDid = dd.CPDDid
						inner join CPDocumentoE det
							on dd.CPDEid = det.CPDEid
                    inner join CPNAPdetalle Napd
                    	on Napd.CPNAPnum = det.NAP
                        and Napd.CPcuenta = dd.CPcuenta
						where cd.CTDCont = #rsDetalle.CTDCont#
                    and Napd.CPCmes = #rsDetalle.CPCmes#
				</cfquery>--->
                <cfquery name ="NoNAPSuf" datasource="#Session.dsn#">
					select c.* from CTContrato a
						inner join CTDetContrato b
							on a.CTContid = b.CTContid
						inner join CPNAPdetalle c
							on c.CPNAPnum = a.NAP
                            and b.CPcuenta = c.CPcuenta
					where  c.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPcuenta#">
					and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					and c.CPNAPDtipoMov = 'RP'
                    and c.CPCmesP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPCmes#">
                    and c.CPCanoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CPCano#">
					</cfquery>

					<cfquery name="rsInsertarTablaIntPresupuestoRP" datasource="#Session.DSN#">
						insert into #Request.intPresupuesto# (
							ModuloOrigen,
							NumeroDocumento,
							NumeroReferencia,
							FechaDocumento,
							AnoDocumento,
							MesDocumento,

							NumeroLinea,
							CPPid,
							CPCano,
							CPCmes,
                            CPcuenta,
							Ocodigo,
							TipoMovimiento,

							Mcodigo,
							MontoOrigen,
							TipoCambio,
							Monto,

							NAPreferencia,
							LINreferencia
						)

						select 'CTLC' as ModuloOrigen,
							   '#numdocumento#' as NumeroDocumento,
							   'Provisión' as NumeroReferencia,
							   a.CTfecha as FechaDocumento,
							   #year(fechaAct)# as AnoDocumento,
							   #month(fechaAct)# as MesDocumento,

							   #linea# as NumeroLinea,
							   #rsDetalle.CPPid#,
						       #rsDetalle.CPCano#,
                               #NoNAP.CPCmes#,
							   #rsDetalle.CPcuenta#,
							   0,
							   'RP' as TipoMovimiento,

							   #rsDetalle.Mcodigo#,
							   (#rsDetalle.Monto#) as MontoOrigen,
							   1.00 as TipoCambio,
							   (#rsDetalle.Monto#) as Monto,

							   #NoNAPSuf.CPNAPnumRef# as NAPreferencia,
							   #NoNAPSuf.CPNAPDlineaRef#  as LINreferencia
						from CTContrato a
						where a.CTContid = #Form.CTContid#
						and a.Ecodigo = #Session.Ecodigo#
					</cfquery>



<!--- Actualizacion de Saldos en Detalles del Contrato --->
				<cfquery name="rsActualizaSaldo" datasource="#Session.dsn#">
					select b.CPDEid from CPDocumentoE a
					inner join CPDocumentoD b
					on a.CPDEid = b.CPDEid
			 		where a.NAP = #NoNAPSuf.CPNAPnumRef#
                    and b.CPDDid = #rsDetalle.CPDDid#
				</cfquery>


				<cfquery name="upActualizaSaldo" datasource="#Session.dsn#">
					update CPDocumentoD
					set CPDDsaldo = CPDDsaldo + #rsDetalle.Monto#
			 		where CPDEid = #rsActualizaSaldo.CPDEid#
                    and CPDDid = #rsDetalle.CPDDid#
				</cfquery>

				</cfif>


		<!--- se actualiza el DetalleLib --->
				<cfquery name="upDetalle" datasource="#Session.DSN#">
					update CTDetLiberacion
					set Estatus = 1,
						Consecutivo=#consec#,
						Documento = '#numdocumento#',
						Periodo = #rsDetalle.CPCano#,
						Mes = #rsDetalle.CPCmes#,
						TipoLiberacion = '#Form.tipolibera#',
						BMUsucodigo = #Session.Ecodigo#
					where CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.CTDCont#">
					and Estatus=0
					and Ecodigo = #Session.Ecodigo#
				</cfquery>

				<cfquery name="upDetalle" datasource="#Session.DSN#">
					update CTDetContrato
					set CTDCmontoConsumido = round(CTDCmontoConsumido + #rsDetalle.Monto#,2),
						BMUsucodigo = #Session.Ecodigo#
					where CTDCont = #rsDetalle.CTDCont#
					and Ecodigo = #Session.Ecodigo#
				</cfquery>

				<cfset linea = linea + 1>

			</cfloop>

<!---  				<cfscript>
					LvarNAP = LobjControl.ControlPresupuestario('CTLC', #numdocumento#, 'Liberaci&oacute;n', #fechaAct#, PeriodoCont, MesCont);
				</cfscript> --->
	<!---</cftransaction>--->
	</cfif><!--- fin if de consulta vacia --->

	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
	    <cfthrow message="Error en la liberación: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	<cftransaction action="commit">
</cftransaction>
</cfif> <!---boton aplicar--->
				<cfset modo="CAMBIO">
</cfif><!----Boton guardar o boton aplicar--->


<cfoutput>
<form action="liberacionConHeader.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="CTContid" type="hidden" value="#Form.CTContid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


