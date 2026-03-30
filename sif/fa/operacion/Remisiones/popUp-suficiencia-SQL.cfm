<cf_dbfunction name="op_concat" returnvariable="_Cat">
<cfset request.error.backs = 1>
<!--- <cfdump var="#url#"> --->
<!--- <cf_dump var="#form#"> --->

<cfif isdefined ('url.Icodigo') and len(trim(#url.Icodigo#))>
	<cfset Icodigo =#url.Icodigo#>
</cfif>

<cfif isdefined("Form.chk")>



    <!---Si se define un monto a distribuir entre las suficiencias--->
	<cfif isdefined("url.montoTotal") and trim(url.montoTotal) NEQ "" and url.montoTotal gt 0 >
        <cfset LvarCPDDids 	= "">
        <cfset LvarlistaMeses 	= "">
        <cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
        	<cfset LvarDet 		= #ListToArray(LvarLin, "|",true)#>
            <cfset LvarCPDDids 	= ListAppend(LvarCPDDids,LvarDet[1])>
            <cfset LvarlistaMeses 	= ListAppend(LvarlistaMeses,LvarDet[5])>
        </cfloop>
       <cfset LvarCPDEid 	= LvarDet[4]>
       <cfset LvarCPCmes 	= LvarDet[5]>
       <cfset LvarModulo 	= LvarDet[3]>


        <cfquery name="rsSQL" datasource="#session.dsn#">
            select sum(round(CPDDsaldo,2)) as SaldoTotal
            from CPDocumentoE e
                inner join CPDocumentoD d
                    on d.CPDEid = e.CPDEid
                left join Conceptos c
                    on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
            where e.Ecodigo=#session.Ecodigo#
           <cfif LvarModulo eq 'Contratos' and ListContains (LvarCPDDids,"-1",",")>
            	and d.CPDEid in (#LvarCPDEid#)
                and d.CPCmes in(#LvarlistaMeses#)
           <cfelse>
           		and CPDDid in (#LvarCPDDids#)

            </cfif>
        </cfquery>


    	<cfset LvarMontoTotal = fnRedondear(url.montoTotal)>
        <cfset LvarSaldoTotal = fnRedondear(rsSQL.SaldoTotal)>

       	<cfif LvarMontoTotal GT LvarSaldoTotal>
        	<cfthrow message="El Monto indicado a Utilizar (#numberformat(LvarMontoTotal,9.99)#)es mayor al Saldo de las Suficiencias seleccionadas (#numberformat(LvarSaldoTotal,9.99)#)">
		</cfif>
        <cfquery name="rsSQL" datasource="#session.dsn#">
            select sum(round(CPDDsaldo * #LvarMontoTotal / LvarSaldoTotal#,2)) as DistribuidoTotal
            from CPDocumentoE e
                inner join CPDocumentoD d
                    on d.CPDEid = e.CPDEid
                left join Conceptos c
                    on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
            where e.Ecodigo=#session.Ecodigo#
           <cfif isdefined ('LvarCPDDid') and LvarCPDDid NEQ -1>
            and CPDDid in (#LvarCPDDid#)
           <cfelse>
           		and d.CPDEid in (#LvarCPDEid#)
                and d.CPCmes = #LvarCPCmes#
           </cfif>
        </cfquery>
		<cfset LvarAjusteTotal = rsSQL.DistribuidoTotal - LvarMontoTotal>
    <cfelse>
    	<cfset LvarMontoTotal = -1>
        <cfset LvarSaldoTotal = 0>
	</cfif>


	<!--- Pra agrupar saldo de suficiencias esto solo ocurre para contratos--->
	<cfif isdefined("Form.chkAgrupaSuficiencias")>
		<!--- Obtiene el mes de Actual del Movimiento Contabilidad o Auxiliares --->
		<!--- Obtiene el mes de Auxiliares --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
		<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

		<cfset arrCodLlave=ArrayNew(1)>
		<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
			<cfset LvarDet 		= #ListToArray(LvarLin, "|", true)#>
			<cfset LvarCodLlave	= "'#LvarDet[9]#'">
			<cfset ArrayAppend(arrCodLlave, LvarCodLlave)>
   			<cfset LvarCPDDid 	= LvarDet[1]>
            <cfset LvarLlave 	= LvarDet[2]>
            <cfset LvarModulo 	= LvarDet[3]>
            <cfset LvarCPDEid 	= LvarDet[4]>
            <cfset LvarCPCmes 	= LvarDet[5]>
            <cfset LvarDist 	= LvarDet[6]>
            <cfset LvarCid	 	= LvarDet[7]>
	        <cfset LvarCcodClas	= LvarDet[8]>
	    </cfloop>

       <!---Suficiencias SIN distribucion Agrupadas--->
			<cfquery name="rsDatos" datasource="#session.dsn#">
				select CPDDtipoItem CMtipo,Cid,Ocodigo,
					Cdescripcion,Ccodigoclas,
		        	sum(CPDDsaldo) CPDDsaldo,CFid,ACcodigo,ACid,CPcuenta
				from (
	                select isnull(cast(ca.ACcodigo as varchar),isnull(cast(c.Ccodigo as varchar),cast(ltrim(rtrim(Saldo.Ccodigoclas)) as varchar))) as Ccodigo,
		                isnull(ca.ACdescripcion,isnull(c.Cdescripcion,cls.Cdescripcion)) as Cdescripcion ,
		                #form.LLave# as llave,
		                '#form.Modulo#' as modulo,
		                Saldo.*,case when Saldo.CPDCid is null then cf.CFcodigo else null end CFcodigo,
						cast(ltrim(rtrim(isnull(Saldo.CPDEnumeroDocumento,-1))) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(Saldo.CPDDid,-1) as varchar) #_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPCano,0) as varchar)#_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPCmes,0) as varchar)#_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPDCid,0) as varchar) #_Cat#'~' #_Cat#
						cast(isnull(Saldo.Cid,0) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(cls.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(Saldo.CPDEid,-1) as varchar) codllave
	                from (
		                 select e.CPDEnumeroDocumento, e.NAP, e.CPDEdescripcion, e.Ecodigo,
		                 	case when CPDCid is null then d.CFid else  e.CFidOrigen end CFid,
                            d.CPDDid,
		                 	case when CPDCid is null then d.CPcuenta else  null end CPcuenta,
		                 	sum(d.CPDDsaldo) as CPDDsaldo, d.ACcodigo, d.ACid,e.CPDEid,d.Ocodigo,
		                 	d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas
		                 from CPDocumentoE e
		                 inner join CPDocumentoD d
							on e.CPDEid = d.CPDEid
		                 where e.Ecodigo=#session.Ecodigo# and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1 and e.CPDEaplicado = 1
		                 	and d.CPCano*100+d.CPCmes <= #LvarAuxAnoMes#
		                 	and d.CPDCid is null
		                 group by e.CPDEnumeroDocumento, e.NAP,e.Ecodigo, e.CPDEdescripcion,e.Ecodigo,d.CPDDid,
			            	case when CPDCid is null then d.CFid else  e.CFidOrigen end,d.Ocodigo,
							case when CPDCid is null then d.CPcuenta else  null end,
							e.CPDEid, d.CPDEid, d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas, e.CPDEcontrato, d.ACcodigo,
				            d.ACcodigo,d.ACid,e.CPDEtipoDocumento,e.CPDEsuficiencia,e.CPDEaplicado ,e.CPDEid
		                having sum(d.CPDDsaldo) > 0
					) Saldo
					left join CFuncional cf
	                	on cf.CFid=Saldo.CFid
	                left join Conceptos c
	                	on c.Cid=Saldo.Cid
	                left join ACategoria ca
						on ca.ACcodigo = Saldo.ACcodigo
	                left join AClasificacion cl
	                	on cl.ACid = Saldo.ACid
	                left join  CPDistribucionCostos dc
	                	on dc.CPDCid = Saldo.CPDCid
	                	and CPDCactivo = 1
	                left join Clasificaciones cls
	                	on ltrim(rtrim(Saldo.Ccodigoclas)) = ltrim(rtrim(cls.Ccodigoclas))
					where 1=1
				) as suf
				left join (
					select 	cast(isnull(ps.CPDEnumeroDocumento,-1) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPDDid,-1) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPCano,0) as varchar)#_Cat# '~'#_Cat#
							cast(isnull(d.CPCmes,0) as varchar)#_Cat# '~'#_Cat#
							cast(isnull(d.CPDCid,0) as varchar) +'~' +
							cast(isnull(d.Cid,0) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPDEid,-1) as varchar) codllave
					from CTContrato c
					inner join CTDetContrato d
						on c.CTContid = d.CTContid
					inner join CPDocumentoE ps
						on d.CPDEid = ps.CPDEid
					where c.CTCestatus = 0
				) con
					on suf.codllave = con.codllave
				where con.codllave is null

					and	suf.codllave in (#ArrayToList(arrCodLlave,',')#)
				group by CPDDtipoItem,Cid,Ocodigo,Ccodigoclas,
					Cdescripcion,CFid,ACcodigo,ACid,CPcuenta
			</cfquery>

        <cftransaction>

			<cfloop query="rsDatos">
				<cfif isdefined('rsDatos.Ccodigoclas')>
		            <cfquery name="rsClasificaciones" datasource="#session.dsn#">
	                    select * from Clasificaciones
	                    where Ecodigo = #session.Ecodigo#
	                    and Ccodigoclas = '#rsDatos.Ccodigoclas#'
	                </cfquery>
	            </cfif>

				<cfset LvarSaldo = rsDatos.CPDDsaldo>

	            <cfquery name="rsUnidades" datasource="#session.dsn#">
	                select Ucodigo   from Unidades
	                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                    and upper(Ucodigo) like  upper('%UNI%')
	            </cfquery>

	            <cfif rsUnidades.recordcount eq 0 >
	                <cfquery name="rsUnidades" datasource="#session.dsn#">
	                    select min(Ucodigo)
	                    from Unidades
	                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                </cfquery>
	            </cfif>

				<cfset aCMtipo = rsDatos.CMtipo>

					<cfquery name="rsContratos" datasource="#session.dsn#">
	                    select  CTCnumContrato, CTtipoCambio
	                        from CTContrato
	                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        and CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.llave#">
	                </cfquery>

					<!---Inserta linea de detalle Agrupada por CPcuenta--->
					<cfif rsContratos.CTtipoCambio NEQ "" and rsContratos.CTtipoCambio NEQ "0" and rsContratos.CTtipoCambio NEQ "1">
						<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsContratos.CTtipoCambio)>
					<cfelse>
						<cfset LvarSaldoSuf = LvarSaldo>
					</cfif>
                    <cfinvoke	component	= "sif.Componentes.CT_AplicaCon" method	= "insert_CTDetContrato" returnvariable="CTDCont">
	                	<cfinvokeargument name="CTContid" value="#form.llave#">
	                	<cfinvokeargument name="CPDDid" value="#-1#">
	                	<cfinvokeargument name="CTCnumero" value="#rsContratos.CTCnumContrato#">
	                	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	                	<cfinvokeargument name="CMtipo" value="#aCMtipo#">
	                	<cfinvokeargument name="Cid" value="#rsDatos.Cid#">
	                	<cfinvokeargument name="Tipocambio" value="#rsContratos.CTtipoCambio#">
	                	<cfinvokeargument name="CPCano" value="#LvarAuxAno#">
 	                	<cfinvokeargument name="CPCmes" value="#LvarAuxMes#">
	                	<cfinvokeargument name="Ocodigo" value="#rsDatos.Ocodigo#">
	                	<cfinvokeargument name="CTDCdescripcion" value="#rsDatos.Cdescripcion# (#LvarAuxAno#-#LvarAuxMes#)">
	                	<cfinvokeargument name="MontoOrigen" value="#LvarSaldoSuf#">
	                	<cfinvokeargument name="dofechaes" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="CFid" value="#rsDatos.CFid#">
	                	<cfinvokeargument name="ucodigo" value="#rsUnidades.Ucodigo#">
	                	<cfinvokeargument name="dofechareq" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="ACcodigo" value="#rsDatos.ACcodigo#">
	                	<cfinvokeargument name="ACid" value="#rsDatos.ACid#">
	                	<cfinvokeargument name="MontoSuficiencia" value="#LvarSaldo#">
	                	<cfinvokeargument name="CPcuenta" value="#rsDatos.CPcuenta#">
	                	<cfinvokeargument name="CPDEid" value="-1">
	               	<cfif rsDatos.Ccodigoclas NEQ "">
	               		<cfinvokeargument name="Ccodigo" value="#rsClasificaciones.Ccodigo#">
	               	</cfif>
	                	<cfinvokeargument name="IdAgrSuf" value="s">
	                </cfinvoke>
                    <cfset varCTDCont = "#CTDCont#">

	                 <cfquery name="rsSumaDetalles" datasource="#session.DSN#">
	                    select sum(CTDCmontoTotalOri) as TotalOrigen from CTDetContrato a
	                    where a.Ecodigo = #Session.Ecodigo#
	                    and a.CTContid = #form.llave#
	                </cfquery>
	             	<!---  calcula Monto--->
	                <cfinvoke 	component	= "sif.Componentes.CT_AplicaCon"
	                        	method		= "update_CTContrato"
	                            CTContid="#form.llave#"
	                            Ecodigo="#Session.Ecodigo#"
								CTmonto="#rsSumaDetalles.TotalOrigen#"
	                />

					<cfquery name="consecutivo" datasource="#session.DSN#">
						select CTDCconsecutivo as linea
						from CTDetContrato
						where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.llave#">
						and CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCTDCont#">
					</cfquery>
					<cfset dlinea = 0 >
					<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
						<cfset dlinea = consecutivo.linea>
					</cfif>

					 <!---Se capturan los detalles de las suficiencias SIN Distribución Agrupadas --->
					<cfquery name="insert" datasource="#session.DSN#">
						 insert into CTDetContratoAgr ( Ecodigo, CTContid, CTCnumero, CTDCconsecutivo,
											   CMtipo, Cid, ACcodigo, ACid, CTDCdescripcion, CTDCmontoTotal,
											   CFid,BMUsucodigo, CPDCid,CPDDid,CPCano,CPCmes,CPcuenta,CTDCmontoTotalOri,Ccodigo,CPDEid,
											   IdAgrSuf)
						select #session.Ecodigo#,#form.llave#,'#rsContratos.CTCnumContrato#',#dlinea#,
							CPDDtipoItem,Cid,ACcodigo,ACid,Cdescripcion,CPDDsaldo,
							CFid,#session.usucodigo#,CPDCid,CPDDid,CPCano,CPCmes,CPcuenta,round((CPDDsaldo*100),2)/100,
                            <cfif rsDatos.Ccodigoclas NEQ "">
                            	#rsClasificaciones.Ccodigo#,
                            <cfelse>
                            	null,
                            </cfif>
                                CPDEid,#varCTDCont#
						from (
			                select isnull(cast(ca.ACcodigo as varchar),isnull(cast(c.Ccodigo as varchar),cast(ltrim(rtrim(Saldo.Ccodigoclas)) as varchar)))
                            		as Ccodigo,
				                isnull(ca.ACdescripcion,isnull(c.Cdescripcion,cls.Cdescripcion)) as Cdescripcion ,
				                #form.LLave# as llave,
				                '#form.Modulo#' as modulo,
				                Saldo.*,case when Saldo.CPDCid is null then cf.CFcodigo else null end CFcodigo,
                                cast(ltrim(rtrim(isnull(Saldo.CPDEnumeroDocumento,-1))) as varchar) #_Cat# '~'#_Cat#
								cast(isnull(Saldo.CPDDid,-1) as varchar) #_Cat# '~' #_Cat#
								cast(isnull(Saldo.CPCano,0) as varchar)#_Cat# '~' #_Cat#
								cast(isnull(Saldo.CPCmes,0) as varchar)#_Cat# '~' #_Cat#
								cast(isnull(Saldo.CPDCid,0) as varchar) #_Cat#'~' #_Cat#
								cast(isnull(Saldo.Cid,0) as varchar) #_Cat# '~'#_Cat#
								cast(isnull(cls.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
								cast(isnull(Saldo.CPDEid,-1) as varchar) codllave
			                from (
				                 select e.CPDEnumeroDocumento, e.NAP, e.CPDEdescripcion, e.Ecodigo,
				                 	case when CPDCid is null then d.CFid else  e.CFidOrigen end CFid,
								d.CPDDid,d.Aid,d.Alm_Aid,
				                 	case when CPDCid is null then d.CPcuenta else  null end CPcuenta,
				                 	sum(d.CPDDsaldo) as CPDDsaldo, d.ACcodigo, d.ACid,e.CPDEid,d.Ocodigo,
				                 	d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas
				                 from CPDocumentoE e
				                 inner join CPDocumentoD d
									on e.CPDEid = d.CPDEid
				                 where e.Ecodigo=#session.Ecodigo# and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1 and e.CPDEaplicado = 1
				                 	and d.CPCano*100+d.CPCmes <= #LvarAuxAnoMes#
				                 	and d.CPDCid is null
				                 group by e.CPDEnumeroDocumento, e.NAP,e.Ecodigo, e.CPDEdescripcion,e.Ecodigo,d.CPDDid,
				                 	d.Alm_Aid,
					            	case when CPDCid is null then d.CFid else  e.CFidOrigen end,d.Ocodigo,
									case when CPDCid is null then d.CPcuenta else  null end,d.Aid,
									e.CPDEid, d.CPDEid, d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas, e.CPDEcontrato, d.ACcodigo,
						            d.ACcodigo,d.ACid,e.CPDEtipoDocumento,e.CPDEsuficiencia,e.CPDEaplicado ,e.CPDEid
				                having sum(d.CPDDsaldo) > 0
							) Saldo
							left join CFuncional cf
			                	on cf.CFid=Saldo.CFid
			                left join Conceptos c
			                	on c.Cid=Saldo.Cid
			                left join ACategoria ca
								on ca.ACcodigo = Saldo.ACcodigo
			                left join AClasificacion cl
			                	on cl.ACid = Saldo.ACid
			                left join  CPDistribucionCostos dc
			                	on dc.CPDCid = Saldo.CPDCid
			                	and CPDCactivo = 1
			                left join Clasificaciones cls
			                	on ltrim(rtrim(Saldo.Ccodigoclas)) = ltrim(rtrim(cls.Ccodigoclas))
							where 1=1
						) as suf
						left join (
							select 	cast(isnull(ps.CPDEnumeroDocumento,-1) as varchar) #_Cat# '~'#_Cat#
									cast(isnull(d.CPDDid,-1) as varchar) #_Cat# '~'#_Cat#
									cast(isnull(d.CPCano,0) as varchar)#_Cat# '~'#_Cat#
									cast(isnull(d.CPCmes,0) as varchar)#_Cat# '~'#_Cat#
									cast(isnull(d.CPDCid,0) as varchar) +'~' +
									cast(isnull(d.Cid,0) as varchar) #_Cat# '~'#_Cat#
									cast(isnull(d.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
									cast(isnull(d.CPDEid,-1) as varchar) codllave
							from CTContrato c
							inner join CTDetContrato d
								on c.CTContid = d.CTContid
							inner join CPDocumentoE ps
								on d.CPDEid = ps.CPDEid
							where c.CTCestatus = 0
						) con
							on suf.codllave = con.codllave
						where con.codllave is null
							and	suf.codllave in (#ArrayToList(arrCodLlave,',')#)
							and CPDDtipoItem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#aCMtipo#">
							and CPcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CPcuenta#">
					</cfquery>
			</cfloop>
			</cftransaction>
		<!--- fin suficiencias sin distribucion --->

        <!---INICIA SUFICIENCIAS AGRUPADAS CON DISTRIBUCION RVD--->

			<cfquery name="rsDatosDistribucion" datasource="#session.dsn#">
				select CPDDtipoItem CMtipo,Cid,Ocodigo,
					Cdescripcion,Ccodigoclas,
		        	sum(CPDDsaldo) CPDDsaldo,max(CFid) as CFid,ACcodigo,ACid,CPcuenta,CPDCid,CPDEid,con.CTDCont,CPCmes,CPCano,CPDDtipoItem,Ccodigo
				from (
	                select isnull(cast(ca.ACcodigo as varchar),isnull(cast(c.Ccodigo as varchar),cast(ltrim(rtrim(Saldo.Ccodigoclas)) as varchar))) as Ccodigo,
		                isnull(ca.ACdescripcion,isnull(c.Cdescripcion,cls.Cdescripcion)) as Cdescripcion ,
		                #form.LLave# as llave,
		                '#form.Modulo#' as modulo,
		                Saldo.*,case when Saldo.CPDCid is null then cf.CFcodigo else null end CFcodigo,
						cast(ltrim(rtrim(isnull(Saldo.CPDEnumeroDocumento,-1))) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(Saldo.CPDDid,-1) as varchar) #_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPCano,0) as varchar)#_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPCmes,0) as varchar)#_Cat# '~' #_Cat#
						cast(isnull(Saldo.CPDCid,0) as varchar) #_Cat#'~' #_Cat#
						cast(isnull(Saldo.Cid,0) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(cls.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
						cast(isnull(Saldo.CPDEid,-1) as varchar) codllave
	                from (
		                 select e.CPDEnumeroDocumento, e.NAP, e.CPDEdescripcion, e.Ecodigo,
		                 	case when CPDCid is null then d.CFid else  e.CFidOrigen end CFid,
							case when CPDCid is null then d.CPDDid else -1 end CPDDid,
		                 	case when CPDCid is null then d.CPcuenta else  null end CPcuenta,
		                 	sum(d.CPDDsaldo) as CPDDsaldo, d.ACcodigo, d.ACid,e.CPDEid,d.Ocodigo,
		                 	d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas
		                 from CPDocumentoE e
		                 inner join CPDocumentoD d
							on e.CPDEid = d.CPDEid
		                 where e.Ecodigo=#session.Ecodigo# and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1 and e.CPDEaplicado = 1
		                 	and d.CPCano*100+d.CPCmes <= #LvarAuxAnoMes#
                            and d.CPDCid is not null
		                 group by e.CPDEnumeroDocumento, e.NAP,e.Ecodigo, e.CPDEdescripcion,e.Ecodigo,d.CPDDid,
			            	case when CPDCid is null then d.CFid else  e.CFidOrigen end,d.Ocodigo,
							case when CPDCid is null then d.CPcuenta else  null end,
							e.CPDEid, d.CPDEid, d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas, e.CPDEcontrato, d.ACcodigo,
				            d.ACcodigo,d.ACid,e.CPDEtipoDocumento,e.CPDEsuficiencia,e.CPDEaplicado ,e.CPDEid
		                having sum(d.CPDDsaldo) > 0
					) Saldo
					left join CFuncional cf
	                	on cf.CFid=Saldo.CFid
	                left join Conceptos c
	                	on c.Cid=Saldo.Cid
	                left join ACategoria ca
						on ca.ACcodigo = Saldo.ACcodigo
	                left join AClasificacion cl
	                	on cl.ACid = Saldo.ACid
	                left join  CPDistribucionCostos dc
	                	on dc.CPDCid = Saldo.CPDCid
	                	and CPDCactivo = 1
	                left join Clasificaciones cls
	                	on ltrim(rtrim(Saldo.Ccodigoclas)) = ltrim(rtrim(cls.Ccodigoclas))
					where 1=1
				) as suf
				left join (
					select 	d.CTDCont,cast(isnull(ps.CPDEnumeroDocumento,-1) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPDDid,-1) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPCano,0) as varchar)#_Cat# '~'#_Cat#
							cast(isnull(d.CPCmes,0) as varchar)#_Cat# '~'#_Cat#
							cast(isnull(d.CPDCid,0) as varchar) +'~' +
							cast(isnull(d.Cid,0) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.Ccodigo,0) as varchar) #_Cat# '~'#_Cat#
							cast(isnull(d.CPDEid,-1) as varchar) codllave
					from CTContrato c
					inner join CTDetContrato d
						on c.CTContid = d.CTContid
					inner join CPDocumentoE ps
						on d.CPDEid = ps.CPDEid
					where c.CTCestatus = 0
				) con
					on suf.codllave = con.codllave
				where con.codllave is null

					and	suf.codllave in (#ArrayToList(arrCodLlave,',')#)
				group by CPDDtipoItem,Cid,Ocodigo,Ccodigoclas,
					Cdescripcion,CFid,ACcodigo,ACid,CPcuenta,CPDCid,CPDEid,CTDCont,CPCmes,CPCano,CPDDtipoItem,Ccodigo
			</cfquery>

            <cfquery name="rsDistribucionAgr" dbtype="query">
            		select Cid,Ocodigo,
					Cdescripcion,Ccodigoclas,
		        	sum(CPDDsaldo) CPDDsaldo,max(CFid) as CFid,ACcodigo,ACid,CPcuenta,CPDCid
                    from rsDatosDistribucion
                    group by Cid,Ocodigo,Ccodigoclas,
					Cdescripcion,CFid,ACcodigo,ACid,CPcuenta,CPDCid
            </cfquery>

			<cftransaction>
		            <cfquery name="rxMaxIdAgrSuf" datasource="#session.DSN#">
						select isnull(max(CTDCont),0) IdAgrSuf from CTDetContrato
					</cfquery>
					<cfset IdAgrSuf = "#rxMaxIdAgrSuf.IdAgrSuf#">

			<cfloop query="rsDistribucionAgr">

            		<cfset IdAgrSuf = #rxMaxIdAgrSuf.IdAgrSuf#+1>
				<cfif isdefined('rsDistribucionAgr.Ccodigoclas')>
		            <cfquery name="rsClasificaciones" datasource="#session.dsn#">
	                    select * from Clasificaciones
	                    where Ecodigo = #session.Ecodigo#
	                    and Ccodigoclas = '#rsDistribucionAgr.Ccodigoclas#'
	                </cfquery>
	            </cfif>

				<cfset LvarSaldo = rsDistribucionAgr.CPDDsaldo>

	            <cfquery name="rsUnidades" datasource="#session.dsn#">
	                select Ucodigo   from Unidades
	                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                    and upper(Ucodigo) like  upper('%UNI%')
	            </cfquery>

	            <cfif rsUnidades.recordcount eq 0 >
	                <cfquery name="rsUnidades" datasource="#session.dsn#">
	                    select min(Ucodigo)
	                    from Unidades
	                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                </cfquery>
	            </cfif>

				<cfset aCMtipo = rsDatosDistribucion.CMtipo>


					<cfquery name="rsContratos" datasource="#session.dsn#">
	                    select  CTCnumContrato, CTtipoCambio
	                        from CTContrato
	                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        and CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.llave#">
	                </cfquery>

					<!---Inserta linea de detalle Agrupada por CPcuenta--->
					<cfif rsContratos.CTtipoCambio NEQ "" and rsContratos.CTtipoCambio NEQ "0" and rsContratos.CTtipoCambio NEQ "1">
						<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsContratos.CTtipoCambio)>
					<cfelse>
						<cfset LvarSaldoSuf = LvarSaldo>
					</cfif>

	                <cfinvoke	component	= "sif.Componentes.CT_AplicaCon" method	= "insert_CTDetContrato" returnvariable="CTDCont">
	                	<cfinvokeargument name="CTContid" value="#form.llave#">
	                	<cfinvokeargument name="CPDDid" value="#-1#">
	                	<cfinvokeargument name="CTCnumero" value="#rsContratos.CTCnumContrato#">
	                	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	                	<cfinvokeargument name="CMtipo" value="#aCMtipo#">
	                	<cfinvokeargument name="Cid" value="#rsDistribucionAgr.Cid#">
	                	<cfinvokeargument name="Tipocambio" value="#rsContratos.CTtipoCambio#">
	                	<cfinvokeargument name="CPCano" value="#LvarAuxAno#">
 	                	<cfinvokeargument name="CPCmes" value="#LvarAuxMes#">
	                	<cfinvokeargument name="Ocodigo" value="#rsDistribucionAgr.Ocodigo#">
	                	<cfinvokeargument name="CTDCdescripcion" value="#rsDistribucionAgr.Cdescripcion# (#LvarAuxAno#-#LvarAuxMes#)">
	                	<cfinvokeargument name="MontoOrigen" value="#LvarSaldoSuf#">
	                	<cfinvokeargument name="dofechaes" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="CFid" value="#rsDistribucionAgr.CFid#">
	                	<cfinvokeargument name="ucodigo" value="#rsUnidades.Ucodigo#">
	                	<cfinvokeargument name="dofechareq" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="ACcodigo" value="#rsDistribucionAgr.ACcodigo#">
	                	<cfinvokeargument name="ACid" value="#rsDistribucionAgr.ACid#">
	                	<cfinvokeargument name="MontoSuficiencia" value="#LvarSaldo#">
	                	<cfinvokeargument name="CPcuenta" value="#rsDistribucionAgr.CPcuenta#">
	                	<cfinvokeargument name="CPDEid" value="-1">
	               	<cfif rsDistribucionAgr.Ccodigoclas NEQ "">
	               		<cfinvokeargument name="Ccodigo" value="#rsClasificaciones.Ccodigo#">
	               	</cfif>
                    <cfif rsDistribucionAgr.CPDCid NEQ "">
        		       	<cfinvokeargument name="CPDCid" value="#rsDistribucionAgr.CPDCid#">
		            </cfif>
	                	<cfinvokeargument name="IdAgrSuf" value="s">
	                </cfinvoke>
                    <cfset varCTDCont = "#CTDCont#">


                    <cfquery name="consecutivo" datasource="#session.DSN#">
						select max(CTDCconsecutivo) as linea
						from CTDetContrato
						where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.llave#">
						and CTDCont = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCTDCont#">
					</cfquery>


					<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.linea)) >
						<cfset dlinea = consecutivo.linea>
					</cfif>

              <!---Inserta linea de detalle Agrupada por CPcuenta--->
					<cfif rsContratos.CTtipoCambio NEQ "" and rsContratos.CTtipoCambio NEQ "0" and rsContratos.CTtipoCambio NEQ "1">
						<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsContratos.CTtipoCambio)>
					<cfelse>
						<cfset LvarSaldoSuf = LvarSaldo>
					</cfif>


					<cfquery name="insertaDtc"  dbtype="query">
                          select #session.Ecodigo#,#form.llave#,'#rsContratos.CTCnumContrato#',#dlinea#,CPDDtipoItem,Cid,ACcodigo,ACid,
                        		Cdescripcion,CPDDsaldo, CFid,#session.usucodigo#,CPDCid,-1,CPCano,
                                CPCmes,CPcuenta,CPDDsaldo,Ccodigo,CPDEid,#varCTDCont#
                           from rsDatosDistribucion
                          where 1=1
                         	<cfif rsDistribucionAgr.Cid NEQ "">
                          	and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionAgr.Cid#">
                            <cfelse > and Cid is null </cfif>

                            <cfif rsDistribucionAgr.Ocodigo NEQ "">
                          	and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionAgr.Ocodigo#">
                            <cfelse > and Ocodigo is null </cfif>

                            <cfif rsDistribucionAgr.Ccodigoclas NEQ "">
                            and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDistribucionAgr.Ccodigoclas#">
                            <cfelse > and Ccodigoclas is null </cfif>

                            <cfif rsDistribucionAgr.ACcodigo NEQ "">
                            and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionAgr.ACcodigo#">
                            <cfelse > and ACcodigo is null </cfif>

                            <cfif rsDistribucionAgr.ACid NEQ "">
                            and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionAgr.ACid#">
                            <cfelse > and ACid is null </cfif>
                    </cfquery>

                    <cfloop query="insertaDtc">

                    <cfquery name="rsInsert" datasource="#session.DSN#">
                     insert into CTDetContratoAgr ( Ecodigo, CTContid, CTCnumero, CTDCconsecutivo,
                           CMtipo, Cid, ACcodigo, ACid, CTDCdescripcion, CTDCmontoTotal,
                           CFid,BMUsucodigo, CPDCid,CPDDid,CPCano,CPCmes,CPcuenta,CTDCmontoTotalOri,Ccodigo,CPDEid,
                           IdAgrSuf)
						values (#session.Ecodigo#,#form.llave#,'#rsContratos.CTCnumContrato#',#dlinea#,'#insertaDtc.CPDDtipoItem#',
                        		<cfif insertaDtc.Cid NEQ "">
                        		#insertaDtc.Cid#,
                                <cfelse > null, </cfif>
                                <cfif insertaDtc.ACcodigo NEQ "">
	                       		'#insertaDtc.ACcodigo#',
                                <cfelse > null, </cfif>
                                <cfif insertaDtc.ACid NEQ "">
                                #insertaDtc.ACid#,
                                <cfelse > null, </cfif>
                                '#insertaDtc.Cdescripcion#',#insertaDtc.CPDDsaldo#,
                                #insertaDtc.CFid#,#session.usucodigo#,#insertaDtc.CPDCid#,-1,#insertaDtc.CPCano#,
                                #insertaDtc.CPCmes#,
                                <cfif insertaDtc.CPcuenta NEQ "">
                                #insertaDtc.CPcuenta#,
                                 <cfelse > null, </cfif>
                                #insertaDtc.CPDDsaldo#,
                                <cfif isdefined('rsDistribucionAgr.Ccodigoclas') and rsDistribucionAgr.Ccodigoclas NEQ "">
                                #rsClasificaciones.Ccodigo#,
                                 <cfelse > null, </cfif>
                                #insertaDtc.CPDEid#,#varCTDCont#
		                        )
                     </cfquery>
					</cfloop>


	                <cfquery name="rsSumaDetalles" datasource="#session.DSN#">
	                    select sum(CTDCmontoTotalOri) as TotalOrigen from CTDetContrato a
	                    where a.Ecodigo = #Session.Ecodigo#
	                    and a.CTContid = #form.llave#
	                </cfquery>
	                <!---calcula Monto--->
	                <cfinvoke 	component	= "sif.Componentes.CT_AplicaCon"
	                        	method		= "update_CTContrato"
	                            CTContid="#form.llave#"
	                            Ecodigo="#Session.Ecodigo#"
								CTmonto="#rsSumaDetalles.TotalOrigen#"
	                />



			   </cfloop>
              </cftransaction>
<!---TERMINA SUFICIENCIAS AGRUPADAS CON DISTRIBUCION RVD--->




	<cfelse>

		<!---Recorre cada suficiencia seleccionada para irla insertando--->
		<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">

			<cfset LvarDet 		= #ListToArray(LvarLin, "|", true)#>
			<cfset LvarCPDDid 	= LvarDet[1]>
			<cfset LvarLlave 	= LvarDet[2]>
			<cfset LvarModulo 	= LvarDet[3]>
	        <cfset LvarCPDEid 	= LvarDet[4]>
	        <cfset LvarCPCmes 	= LvarDet[5]>
			<cfset LvarDist 	= LvarDet[6]>
	        <cfset LvarCid	 	= LvarDet[7]>
	        <cfset LvarCcodClas	= LvarDet[8]>

			<cftransaction>

	        	<cfquery name="rsDatos" datasource="#session.dsn#">
					select isnull(cast(ca.ACcodigo as varchar),isnull(cast(c.Ccodigo as varchar),cast(ltrim(rtrim(Saldo.Ccodigoclas)) as varchar))) as Ccodigo,
		                isnull(ca.ACdescripcion,isnull(c.Cdescripcion,cls.Cdescripcion)) as Cdescripcion ,CPDEid,
		                Saldo.*,case when Saldo.CPDCid is null then cf.CFcodigo else null end CFcodigo, cf.Ocodigo
	                from (
		                 select e.CPDEnumeroDocumento, e.NAP, e.CPDEdescripcion, e.Ecodigo,
	                 	<cfif LvarModulo eq 'Contratos'>
						 	case when CPDCid is null then d.CFid else  e.CFidOrigen end CFid,
						<cfelse>
							d.CFid,
						</cfif>
	                       <cfif LvarModulo eq 'Contratos' and isdefined ('LvarCPDDid') and LvarCPDDid EQ -1>
	                 		-1 as CPDDid,
	                       <cfelse>
	                        	d.CPDDid,
	                       </cfif>
		                <cfif LvarModulo eq 'Contratos'>
		                 	case when CPDCid is null then d.CPcuenta else  null end CPcuenta,
						<cfelse>
							d.CPcuenta,
						</cfif>
	                 	 sum(d.CPDDsaldo) as CPDDsaldo, d.ACcodigo, d.ACid,e.CPDEid,
		                 	d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas
		                 from CPDocumentoE e
		                 inner join CPDocumentoD d
							on e.CPDEid = d.CPDEid
		                 where e.Ecodigo=#session.Ecodigo# and e.CPDEtipoDocumento = 'R' and e.CPDEsuficiencia = 1 and e.CPDEaplicado = 1
		                 group by e.CPDEnumeroDocumento, e.NAP,e.Ecodigo, e.CPDEdescripcion,e.Ecodigo,
	            <cfif LvarModulo eq 'Contratos'>
				 	case when CPDCid is null then d.CFid else  e.CFidOrigen end,
				<cfelse>
					d.CFid,
				</cfif>
	                        <cfif LvarModulo eq 'Contratos' and isdefined ('LvarCPDDid') and LvarCPDDid EQ -1>

	                        <cfelse>
	                         	d.CPDDid,
	                        </cfif>
				<cfif LvarModulo eq 'Contratos'>
		                 	case when CPDCid is null then d.CPcuenta else  null end,
				<cfelse>
					d.CPcuenta,
				</cfif>
		                    e.CPDEid, d.CPDEid, d.CPCano,d.CPCmes,d.CPDCid,d.Cid,d.CPDDtipoItem,d.Ccodigoclas, e.CPDEcontrato, d.ACcodigo,
		                    d.ACcodigo,d.ACid,e.CPDEtipoDocumento,e.CPDEsuficiencia,e.CPDEaplicado ,e.CPDEid
		                having sum(d.CPDDsaldo) > 0
					) Saldo
					left join CFuncional cf
	                	on cf.CFid=Saldo.CFid
	                left join Conceptos c
	                	on c.Cid=Saldo.Cid
	                left join ACategoria ca
						on ca.ACcodigo = Saldo.ACcodigo
	                left join AClasificacion cl
	                	on cl.ACid = Saldo.ACid
	                left join  CPDistribucionCostos dc
	                	on dc.CPDCid = Saldo.CPDCid
	                	and CPDCactivo = 1
	                left join Clasificaciones cls
	                	on ltrim(rtrim(Saldo.Ccodigoclas)) = ltrim(rtrim(cls.Ccodigoclas))
					where 1=1
						and Saldo.Ecodigo=#session.Ecodigo#
					<cfif LvarCPDDid NEQ -1>
						and Saldo.CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPDDid#">
					<cfelse>
						<cfif len(LvarCid) and LvarCid NEQ -1 >
							and Saldo.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCid#">
						<cfelse>
							and Saldo.Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCcodClas#">
						</cfif>
						and Saldo.CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDist#">
						and Saldo.CPDEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPDEid#">
		                and Saldo.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPCmes#">
		            </cfif>

				</cfquery>


	            <!---Si se definio un monto a distribuir aqui se saca el peso de cada suficiencia--->
	            <cfif isdefined('rsDatos.Ccodigoclas')>
		            <cfquery name="rsClasificaciones" datasource="#session.dsn#">
	                    select * from Clasificaciones
	                    where Ecodigo = #session.Ecodigo#
	                    and Ccodigoclas = '#rsDatos.Ccodigoclas#'
	                </cfquery>

	            </cfif>

				<cfif LvarMontoTotal EQ -1>
					<cfset LvarSaldo = rsDatos.CPDDsaldo>
	            <cfelse>
					<cfset LvarSaldo = fnRedondear(LvarMontoTotal * rsDatos.CPDDsaldo / LvarSaldoTotal)>
					<cfif LvarAjusteTotal GT 0>
						<cfset LvarSaldo		= LvarSaldo - 0.01>
						<cfset LvarAjusteTotal	= LvarAjusteTotal - 0.01>
					<cfelseif LvarAjusteTotal LT 0>
						<cfset LvarSaldo		= LvarSaldo + 0.01>
						<cfset LvarAjusteTotal	= LvarAjusteTotal + 0.01>
					</cfif>
	            </cfif>

	            <cfquery name="rsUnidades" datasource="#session.dsn#">
	                select Ucodigo   from Unidades
	                    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                    and upper(Ucodigo) like  upper('%UNI%')
	            </cfquery>

	            <cfif rsUnidades.recordcount eq 0 >
	                <cfquery name="rsUnidades" datasource="#session.dsn#">
	                    select min(Ucodigo)   from Unidades
	                        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                </cfquery>
	            </cfif>

	            <cfset form.CMtipo = rsDatos.CPDDtipoItem>

	            <!---Cuando es ORDEN DE COMPRA--->
				<cfif LvarModulo eq 'EO'>
	                <cfquery name="rsOrdenCompra" datasource="#session.dsn#">
	                    select  EOnumero, EOtc
	                        from ERemisionesFA
	                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
	                </cfquery>

					<!---Inserta linea de detalle--->
					<cfif rsOrdenCompra.EOtc NEQ "" and rsOrdenCompra.EOtc NEQ "0" and rsOrdenCompra.EOtc NEQ "1">
						<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsOrdenCompra.EOtc)>
					<cfelse>
						<cfset LvarSaldoSuf = LvarSaldo>
					</cfif>
	                <cfinvoke 	component	= "sif.Componentes.FAP_AplicaPedidos"
	                            method		= "insert_DOrdenCM"

	                            eoidorden="#LvarLlave#"
	                            CPDDid="#LvarCPDDid#"
	                            eonumero="#rsOrdenCompra.EOnumero#"
	                            ecodigo="#Session.Ecodigo#"
	                            cmtipo="#form.CMtipo#"
	                            cid="#rsDatos.Cid#"
	                            dodescripcion="#rsDatos.Cdescripcion# (#rsDatos.CPCano#-#rsDatos.CPCmes#)"
	                            docantidad="1"
	                            dopreciou="#LvarSaldoSuf#"
	                            dofechaes="#LSDateFormat(Now(),'dd/mm/yyyy')#"
	                            cfid="#rsDatos.CFid#"
	                            icodigo="#Icodigo#"
	                            ucodigo="#rsUnidades.Ucodigo#"
	                            dofechareq="#LSDateFormat(Now(),'dd/mm/yyyy')#"
								ACcodigo="#rsDatos.ACcodigo#"
								ACid="#rsDatos.ACid#"
					/>
	                <!---calcula Monto--->
	                <cfinvoke 	component	= "sif.Componentes.FAP_AplicaPedidos"
	                        method		= "calculaTotalesEOrdenCM"

	                        ecodigo="#Session.Ecodigo#"
	                        eoidorden="#LvarLlave#"
	                />

	            </cfif><!---Fin ORDEN DE COMPRA--->
	            <!---*************************************************************************************--->
	            <!---Cuando es SOLICITUD DE PAGO--->
				<cfif LvarModulo eq 'SPM' or LvarModulo eq 'SPM_CF'>

	                <cfquery name="rsSP" datasource="#session.dsn#">
	                    select TESid, TESSPnumero, TESSPfechaPagar, McodigoOri, coalesce(sn.SNid,-1) as SNid
	                      from TESsolicitudPago sp
	                      	left join SNegocios sn on sn.Ecodigo=sp.EcodigoOri and sn.SNcodigo=sp.SNcodigoOri
	                     where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
	                </cfquery>

	                <cfquery name="sigMoneda" datasource="#session.dsn#">
	                    select Miso4217
	                    from Monedas
	                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                        and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.McodigoOri#">
	                </cfquery>

	                <cfquery name="rsSPCentrF" datasource="#session.dsn#">
	                    select sp.CFid, cf.Ocodigo, cf.CFcodigo, sp.TESSPtipoCambioOriManual
	                      from TESsolicitudPago sp
	                        inner join CFuncional cf
	                           on cf.CFid = sp.CFid
	                     where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
	                </cfquery>


	                <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
					<cfset LvarCFformato = mascara.fnComplementoItem(session.Ecodigo, rsSPCentrF.CFid, rsSP.SNid, "S", "", rsDatos.Cid, "", "")>

	                <!--- Obtener Cuenta --->
	                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
	                          method="fnGeneraCuentaFinanciera"
	                          returnvariable="LvarError">
	                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
	                            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
	                            <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
	                </cfinvoke>


	                <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
	                    <!--- trae el id de la cuenta financiera --->
	                    <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
	                        select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
	                        from CFinanciera a
	                            inner join CPVigencia b
	                                 on a.CPVid     = b.CPVid
	                                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.CPVdesde and b.CPVhasta
	                        where a.Ecodigo   = #session.Ecodigo#
	                          and a.CFformato = '#LvarCFformato#'
	                    </cfquery>
	                <cfelse>
	                	<cfthrow message="#LvarError#">
	                </cfif>


	                <cfquery datasource="#session.dsn#">
	                    insert INTO TESdetallePago
	                        (
	                            TESid, CFid, OcodigoOri,
	                            TESDPestado, EcodigoOri, TESSPid, TESDPtipoDocumento, TESDPidDocumento,
	                            TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
	                            SNcodigoOri, TESDPfechaVencimiento,
	                            TESDPfechaSolicitada, TESDPfechaAprobada, Miso4217Ori, TESDPmontoVencimientoOri,
	                            TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
	                            Cid, CPDDid,
	                            TESDPdescripcion, CFcuentaDB,TESDPespecificacuenta
	                        )
	                    values (
	                            #rsSP.TESid#, #rsDatos.CFid#, #rsSPCentrF.Ocodigo#,
	                            0,
	                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">,
	                            <cfif LvarModulo eq 'SPM_CF'>
	                            	5,
	                            <cfelse>
	                            	0,
	                            </cfif>
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">,
	                            'TESP',
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.CPDEnumeroDocumento#">,
								'Suficiencia',
	                            <cfif isdefined('form.SNcodigoOri') and len(trim(form.SNcodigoOri))>
	                                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoOri#">,
	                            <cfelse>
	                                null,
	                            </cfif>
	                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
	                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
	                            <cfqueryparam value="#rsSP.TESSPfechaPagar#" cfsqltype="cf_sql_timestamp">,
	                            <cfqueryparam cfsqltype="cf_sql_char" value="#sigMoneda.Miso4217#">,
								<cfif rsSPCentrF.TESSPtipoCambioOriManual NEQ "" and rsSPCentrF.TESSPtipoCambioOriManual NEQ "0" and rsSPCentrF.TESSPtipoCambioOriManual NEQ "1">
									<cfset LvarSaldoSuf = LvarSaldo/rsSPCentrF.TESSPtipoCambioOriManual>
								<cfelse>
									<cfset LvarSaldoSuf = LvarSaldo>
								</cfif>
	                            round(#LvarSaldoSuf#,2),
	                            round(#LvarSaldoSuf#,2),
	                            round(#LvarSaldoSuf#,2),
	                            #rsDatos.Cid#,
	                            #LvarCPDDid#,
	                            <cfif isdefined('rsDatos.Cdescripcion') and len(trim(rsDatos.Cdescripcion))>
	                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Cdescripcion# (#rsDatos.CPCano#-#rsDatos.CPCmes#)">,
	                            <cfelse>
	                                null,
	                            </cfif>
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTraeCuenta.CFcuenta#">,
	                            0
	                        )
	                </cfquery>

	                <cfquery datasource="#session.dsn#">
	                    update TESsolicitudPago
	                        set TESSPtotalPagarOri =
	                                coalesce(
	                                ( select round(sum(TESDPmontoSolicitadoOri),2)
	                                    from TESdetallePago
	                                   where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
	                                )
	                                , 0)
	                            , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	                    where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#" null="#Len(LvarLlave) Is 0#">
	                </cfquery>
	            </cfif>


	      <!---Cuando es de CONTRATO--->
				<cfif LvarModulo eq 'Contratos'>
	                <cfquery name="rsContratos" datasource="#session.dsn#">
	                    select  CTCnumContrato, CTtipoCambio
	                        from CTContrato
	                        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        and CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLlave#">
	                </cfquery>


					<!---Inserta linea de detalle--->
					<cfif rsContratos.CTtipoCambio NEQ "" and rsContratos.CTtipoCambio NEQ "0" and rsContratos.CTtipoCambio NEQ "1">
						<cfset LvarSaldoSuf = fnRedondear(LvarSaldo/rsContratos.CTtipoCambio)>
					<cfelse>
						<cfset LvarSaldoSuf = LvarSaldo>
					</cfif>

	                <cfinvoke 	component	= "sif.Componentes.CT_AplicaCon" method	= "insert_CTDetContrato">
	                	<cfinvokeargument name="CTContid" value="#LvarLlave#">
	                	<cfinvokeargument name="CPDDid" value="#LvarCPDDid#">
	                	<cfinvokeargument name="CTCnumero" value="#rsContratos.CTCnumContrato#">
	                	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	                	<cfinvokeargument name="CMtipo" value="#form.CMtipo#">
	                	<cfinvokeargument name="Cid" value="#rsDatos.Cid#">
	                	<cfinvokeargument name="Tipocambio" value="#rsContratos.CTtipoCambio#">
	                	<cfinvokeargument name="CPCano" value="#rsDatos.CPCano#">
	                	<cfinvokeargument name="CPCmes" value="#rsDatos.CPCmes#">
	                	<cfinvokeargument name="Ocodigo" value="#rsDatos.Ocodigo#">
	                	<cfinvokeargument name="CTDCdescripcion" value="#rsDatos.Cdescripcion# (#rsDatos.CPCano#-#rsDatos.CPCmes#)">
	                	<cfinvokeargument name="MontoOrigen" value="#LvarSaldoSuf#">
                		<cfinvokeargument name="MontoSuficiencia" value="#LvarSaldo#">
	                	<cfinvokeargument name="dofechaes" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="CFid" value="#rsDatos.CFid#">
	                	<cfinvokeargument name="ucodigo" value="#rsUnidades.Ucodigo#">
	                	<cfinvokeargument name="dofechareq" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	                	<cfinvokeargument name="ACcodigo" value="#rsDatos.ACcodigo#">
	                	<cfinvokeargument name="ACid" value="#rsDatos.ACid#">
	                	<cfinvokeargument name="CPcuenta" value="#rsDatos.CPcuenta#">
	                	<cfinvokeargument name="CPDEid" value="#rsDatos.CPDEid#">
	                	<cfif rsDatos.CPDCid NEQ "">
	                		<cfinvokeargument name="CPDCid" value="#rsDatos.CPDCid#">
	                	</cfif>
	                	<cfif rsDatos.Ccodigoclas NEQ "">
	                		<cfinvokeargument name="Ccodigo" value="#rsClasificaciones.Ccodigo#">
	                	</cfif>
	                </cfinvoke>



	                <cfquery name="rsSumaDetalles" datasource="#session.DSN#">
	                    select sum(CTDCmontoTotalOri) as TotalOrigen from CTDetContrato a
	                    where a.Ecodigo = #Session.Ecodigo#
	                    and a.CTContid = #LvarLlave#
	                </cfquery>
	                <!---calcula Monto--->
	                <cfinvoke 	component	= "sif.Componentes.CT_AplicaCon"
	                        	method		= "update_CTContrato"
	                            CTContid="#LvarLlave#"
	                            Ecodigo="#Session.Ecodigo#"
								CTmonto="#rsSumaDetalles.TotalOrigen#"
	                />

	            </cfif>
		<!---Fin Cuando es Contrato--->


			</cftransaction>
		</cfloop>

	</cfif>

	<script language="JavaScript" type="text/javascript">

		<!---Cuando es ORDEN DE COMPRA--->
		<cfif LvarModulo eq 'EO'>
			//llama a la funcion de cambio de orden de compra
			if (window.opener.document.form1.Cambio)
				window.opener.document.form1.Cambio.click();
			else if (window.opener.document.form1.CambioDet)
				window.opener.document.form1.CambioDet.click();
		</cfif>

		<cfif LvarModulo eq 'Contratos'>
			//llama a la funcion de cambio de Contrato
			if (window.opener.document.form1.Cambio)
				window.opener.document.form1.Cambio.click();
			else if (window.opener.document.form1.CambioDet)
				window.opener.document.form1.CambioDet.click();
		</cfif>


		<cfif LvarModulo eq 'SPM' or LvarModulo eq 'SPM_CF'>

			<!---if (window.opener.document.formDet.CambioDet)
				window.opener.document.formDet.CambioDet.click();
			else if (window.opener.document.formDet.AltaDet)
				window.opener.document.formDet.AltaDet.click();--->
				window.opener.location.reload();
		</cfif>
        window.close();
    </script>
</cfif>
<cffunction name="fnRedondear" returntype="numeric">
	<cfargument name="Numero" type="numeric">
	<cfreturn round(Numero*100)/100>
</cffunction>

