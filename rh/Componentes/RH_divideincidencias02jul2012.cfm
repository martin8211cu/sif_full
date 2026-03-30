<cfset vDebug = false>

<!--- LZ 20110401 Se eliminan las Incidencias generadas a partir de conceptos Exonerados --->
<cfquery datasource="#Arguments.datasource#" name="ELiminaGravables">
	delete from IncidenciasCalculo
	where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
	<cfif IsDefined('Arguments.pDEid')>	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
	and CIid in (Select CIidexceso 
				 from CIncidentes 
				 Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">)
</cfquery>		


<cfquery datasource="#Arguments.datasource#" name="IClimita">
	select 
		ic.ICid, ci.CIid, ci.CIidexceso, ci.CIafectaSBC, i.Ivalor as ICvalor, round(i.Imonto,2) as ICmontores, i.Iid, i.DEid
		, (ci.CImontolimite) as CImontolimite , i.CFid, i.Ifecha, i.Ivalor, ci.CItipo , ci.CItipometodo, ci.CItipolimite
	from CIncidentes ci
		inner join Incidencias i
			on ci.CIid = i.CIid 
			<cfif IsDefined('Arguments.pDEid')>	and i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
		inner join IncidenciasCalculo ic
			on i.Iid = ic.Iid
			and i.CIid = ic.CIid
			<!---and ic.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> --->
	where ci.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and ci.CIlimitaconcepto = 1 
<!---		and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
--->		and ic.ICmontores>0 
	order by ci.CIid, i.Ifecha
</cfquery>


<cfif vDebug>
	Incidencias que aplican Limite
	<cfdump var="#IClimita#">
</cfif>

<cfif IClimita.recordCount GT 0>
	<cfset vAcumulado = 0>
	<cfset vCIid = 0>
	<cfset vMismoCIid = 0>
	<cfset vDivideIncidencia = 1>
	
	<cfloop query="IClimita">
		<cfif IClimita.CIid NEQ vCIid>
			<cfset vAcumulado = 0>
			<cfset vCIid = IClimita.Iid >
			<cfset vDivideIncidencia = 1>
		</cfif>
        
        <cfif IClimita.CIid NEQ vMismoCIid>
            <cfset vAcumuladoLimite = 0>
            <cfset vTope = 0>
            <cfset vMismoCIid = IClimita.CIid >
		</cfif>
		
		<cfquery datasource="#Arguments.datasource#" name="HIClimita">
			select  coalesce(sum(hic.ICmontores),0) as ICmontores
				from HIncidenciasCalculo hic
					inner join CalendarioPagos cp
						on hic.RCNid = cp.CPid
							and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPperiodo#">
							and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPmes#">
					inner join CIncidentes ci
						on hic.CIid = ci.CIid
						and ci.CItipolimite = 0 <!--- 0 - Perido --->
				where (hic.CIid = #IClimita.CIidexceso# or hic.CIid = #IClimita.CIid#)
					and hic.DEid = #IClimita.DEid#
		</cfquery>					
		<cfset vAcumulado = vAcumulado + IClimita.ICmontores + HIClimita.ICmontores>
		
		<cfif vDebug>
			HIClimita: <cfdump var="#HIClimita#"> <br>
			vDivideIncidencia: <cfdump var="#vDivideIncidencia#"> <br>
			vAcumulado :<cfdump var="#vAcumulado#"> </br>
			vCIid :<cfdump var="#vCIid#"> </br>
			CIid:<cfdump var="#IClimita.ICid#"><br><br><br>
		</cfif>

		<cfif IClimita.CItipometodo EQ 4> <!---usa Veces salario minimo--->
			<cfset limite = IClimita.CImontolimite * #SMG(IClimita.DEid)# >
		<cfelseif IClimita.CItipometodo EQ 3> <!---usa Importe--->
			<cfset limite = IClimita.CImontolimite >
       
        <cfelseif IClimita.CItipometodo EQ 5> <!---usa Calculo--->

            <cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

                <cfquery name="rsConcepto" datasource="#session.DSN#">
                    select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
                        , <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.DEid#"> as DEid,  
                        <cfqueryparam cfsqltype="cf_sql_float" value="#IClimita.ICmontores#"> as MontoIncidencia
                    from CIncidentes a
                        inner join CIncidentesDLimite b
                            on a.CIid = b.CIid
                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.CIid#">
                      <!---and a.CItipo = 3--->
                </cfquery>

                <cfif vDebug>	
                    Detalle formulacion Limite:
                    <cfdump var="#rsConcepto#">
                </cfif>
        
                <cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
                    <!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL CONCEPTO DE PAGO  --->
                    <cfset FVigencia = LSDateFormat(arguments.RCdesde, 'DD/MM/YYYY')>
                    <cfset FFin = LSDateFormat(arguments.RChasta, 'DD/MM/YYYY')>
                    <cfset current_formulas = rsConcepto.CIcalculo>
                    <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                               CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                                   rsConcepto.CIcantidad,
                                                   rsConcepto.CIrango,
                                                   rsConcepto.CItipo,
                                                   rsConcepto.DEid,
                                                   0,	<!---RHJid--->
                                                   session.Ecodigo,
                                                   0,	<!---RHTid--->
                                                   0,	<!---RHAlinea--->
                                                   rsConcepto.CIdia,
                                                   rsConcepto.CImes,
                                                   "",	<!---Tcodigo--->
                                                   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
                                                   'false',	<!---masivo--->
                                                   '',	<!---tablaTemporal--->
                                                   FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                                   0, 	<!---cantidad--->
												   "", 	<!---origen--->
												   "",	<!---CIsprango--->
												   0, 	<!---CIspcantidad--->
												   0, 	<!---CImescompleto--->
												   rsConcepto.MontoIncidencia
												   )>

                    <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                    <cfset calc_error = RH_Calculadora.getCalc_error()>
                    <cfif Not IsDefined("values")>
                        <cfif isdefined("presets_text")>
                            <cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
                        <cfelse>
                            <cfthrow detail="#calc_error#" >
                        </cfif>
                    </cfif>
                    <cfset vn_cantidad 	= values.get('cantidad').toString()>
                    <cfset vn_importe 	= values.get('importe').toString()>
                    <cfset vn_resultado = values.get('resultado').toString()>
                    <cfset vTope		= vn_importe>
                <cfelse>
                    <cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
                </cfif>
                
                <cfif vDebug>
                    Cantidad:<cfdump var="#vn_cantidad#"> </br>
                    Importe:<cfdump var="#vn_importe#"></br>
                    Resultado: <cfdump var="#vn_resultado#"></br>
                </cfif>
                    
				<cfset limite = #vn_resultado# >
            
        <cfelse> 	<!---usa el resto horas, dias aplica regla de 3 para saber a cuando corresponde el limite --->
        	<cfset limite =  (IClimita.CImontolimite * IClimita.ICmontores) / IClimita.ICvalor>
            <cfset vTope = limite>
		</cfif>

		<cfif HIClimita.ICmontores GT limite >
			<cfset vDivideIncidencia = 0>
		</cfif>	
        
        
          <cfif IClimita.CIid EQ vMismoCIid>
			<cfif vAcumuladoLimite GT vTope >
                <cfset vDivideIncidencia = 1>     
            <cfelseif (vAcumuladoLimite + limite)  GT vTope>
            	<cfset limite = (vAcumuladoLimite + limite) - vTope >     
            	<cfset vAcumuladoLimite = vTope>  
            <cfelse>
            	<cfset vAcumuladoLimite = vAcumuladoLimite + limite >  
            </cfif>
            
            
            <cfif vDebug>
                vAcumuladoLimite:<cfdump var="#vAcumuladoLimite#"> </br>
                vAcumulado:<cfdump var="#vAcumulado#"></br>
                limite:<cfdump var="#limite#"></br>
                CIid:<cfdump var="#IClimita.CIid#"> </br>
                vMismoCIid:<cfdump var="#vMismoCIid#"></br>
            </cfif>
		</cfif>
        
		<cfif vAcumulado GT limite >
			<cfif vDivideIncidencia EQ 1>
				<cfset vDivideIncidencia = 0>
						
				<cfset ICvalorN = abs(((vAcumulado - limite))) >
				<cfset ICvalorV = abs(ICvalorN - IClimita.ICmontores) >

				
<!---					
				<cfset vhora = IClimita.ICmontores / IClimita.ICvalor>
				<cfset vhoraN = vhora * ICvalorN>
				<cfset vhoraV = vhora * ICvalorV>
				
LZ 20110401 Se pretende establecer el Valor en Unidades del monto Distribuido a pagar, pero de forma incorrecta, debe ser por Regla de 3 --->
				<cfset vhoraN = (ICvalorN * IClimita.ICvalor) / IClimita.ICmontores>
				<cfset vhoraV =(ICvalorV * IClimita.ICvalor) / IClimita.ICmontores>
                
				<cfif vDebug>				
						Total Incidencia <cfdump var="#IClimita.ICmontores#"><BR>
						Monto Gravado<cfdump var="#ICvalorN#"><BR>
						Monto Exonerado <cfdump var="#ICvalorV#"><BR>
						Cantidad Exonerado <cfdump var="#vhoraN#"><BR>
						Cantidad Gravado <cfdump var="#vhoraV#"><BR>
				</cfif>
                
				<!---ljimenez: inserta en la parte 2 de la incidencia en incidenciascalculo para que se refleje en la pantalla--->	
				<cfquery datasource="#Arguments.datasource#" name="rsInsert">	
					insert into IncidenciasCalculo (
					RCNid, DEid, CIid, Iid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion,	ICcalculo, ICbatch,
					ICmontoant, ICmontores, CFid, RHSPEid, ICmontoexentorenta, Mcodigo, ICmontoorigen, BMUsucodigo, RHJid,
					Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta, CPmes, CPperiodo
					)
					select ic.RCNid, ic.DEid, #IClimita.CIidexceso#, #IClimita.Iid#, ic.ICfecha,#vhoraN#,
						ic.ICfechasis, ic.Usucodigo, ic.Ulocalizacion, ic.ICcalculo, ic.ICbatch, ic.ICmontoant,
						#ICvalorN#, ic.CFid, ic.RHSPEid, ic.ICmontoexentorenta, ic.Mcodigo, ic.ICmontoorigen,
						ic.BMUsucodigo, ic.RHJid, ic.Iusuaprobacion, ic.Ifechaaprobacion, ic.NAP, ic.NRP, ic.Inumdocumento, ic.CFcuenta
						,ic.CPmes, ic.CPperiodo
					from CIncidentes ci
						inner join IncidenciasCalculo ic
							on ci.CIid = ic.CIid
					where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					 and ic.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.Iid#"> 
				</cfquery>
				
				<cfif vDebug>
                    <cfquery datasource="#Arguments.datasource#" name="IncidCalc">	
                        Select *  from IncidenciasCalculo ic
                        where CIid = #IClimita.CIidexceso#
                    </cfquery>
                    <cfdump var="#IncidCalc#">
				</cfif>
				
				<!---ljimenez: Aca se actualiza el registro de que ya estaba incluido en incidencias calculo--->	
				<cfquery datasource="#Arguments.datasource#"> 
				<!---	Los Valores se almacenan alrever update IncidenciasCalculo set ICvalor = #ICvalorV#, ICmontores = #vhoraV# --->
						update IncidenciasCalculo set ICvalor = #vhoraV#  , ICmontores = #ICvalorV#
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.ICid#"> 
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = #IClimita.DEid#
				</cfquery>
                
                <cfquery datasource="#Arguments.datasource#" name="xx"> 
					delete from  IncidenciasCalculo
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.ICid#"> 
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = #IClimita.DEid#
                            and ICvalor = 0
				</cfquery>	
                	
			<cfelse>
				<cfquery datasource="#Arguments.datasource#" name="rsInsert">	
					insert into IncidenciasCalculo (
						RCNid, DEid, CIid, Iid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant,
						ICmontores, CFid, RHSPEid, ICmontoexentorenta, Mcodigo, ICmontoorigen, BMUsucodigo, RHJid, Iusuaprobacion, Ifechaaprobacion,
						NAP, NRP, Inumdocumento, CFcuenta, CPmes, CPperiodo
						)
						select 
							ic.RCNid, ic.DEid, ic.CIid, #IClimita.Iid#, ic.ICfecha, ic.ICvalor, ic.ICfechasis, ic.Usucodigo, ic.Ulocalizacion,
							ic.ICcalculo, ic.ICbatch, ic.ICmontoant, ic.ICmontores, ic.CFid, ic.RHSPEid, ic.ICmontoexentorenta, ic.Mcodigo, ic.ICmontoorigen,
							ic.BMUsucodigo, ic.RHJid, ic.Iusuaprobacion, ic.Ifechaaprobacion, ic.NAP, ic.NRP, ic.Inumdocumento, ic.CFcuenta
							,ic.CPmes, ic.CPperiodo
						from CIncidentes ci
							inner join IncidenciasCalculo ic
								on ci.CIid = ic.CIid
						where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						 and ic.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.Iid#"> 
				</cfquery>

				<cfquery datasource="#Arguments.datasource#" name="xx"> 
					delete from  IncidenciasCalculo
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.ICid#"> 
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = #IClimita.DEid#
				</cfquery>	
			</cfif>
		</cfif>
	</cfloop>
    

	
<!---ljimenez Separacion de Componenetes Salariales Incidentes    --->
    <cfquery datasource="#Arguments.datasource#" name="rsCScalculo"> 
        select ic.DEid, ic.ICmontores, ic.ICvalor,ic.ICfecha,ic.ICfechasis, ic.CSid, ic.CPmes, ic.CPperiodo, ic.CFid, ic.CIid, ic.ICid, ci.CIidexceso,
            CImontolimite,
            ci.CItipo,
            ci.CItipolimite,
            ci.CItipometodo
            from IncidenciasCalculo ic
            inner join CIncidentes ci
                on ic.CIid = ci.CIid
                and ci.CIlimitaconcepto = 1
            where ci.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                and ci.CIlimitaconcepto = 1 
                and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
                and ic.ICmontores > 0 
                and ic.CSid > 0
                <cfif IsDefined('Arguments.pDEid')>	and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
            order by ci.CIid
    </cfquery>	
    
    <cfif vDebug>	
    	Componentes salariles que aplican limite:
        <cfdump var="#rsCScalculo#">
    </cfif>
    
    <cfif rsCScalculo.recordCount GT 0>
    	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
    	<cfloop query="rsCScalculo">
            <cfquery name="rsConcepto" datasource="#session.DSN#">
                select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
                    , <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCScalculo.DEid#"> as DEid
                from CIncidentes a
                    inner join CIncidentesDLimite b
                        on a.CIid = b.CIid
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCScalculo.CIid#">
                  and a.CItipo = 3
            </cfquery>
            
            <cfif vDebug>	
                Detalle formulacion Limite:
                <cfdump var="#rsConcepto#">
            </cfif>
    
            <cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
                <!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->
                <cfset FVigencia = LSDateFormat(arguments.RCdesde, 'DD/MM/YYYY')>
                <cfset FFin = LSDateFormat(arguments.RChasta, 'DD/MM/YYYY')>
                <cfset current_formulas = rsConcepto.CIcalculo>
                <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                           CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                               rsConcepto.CIcantidad,
                                               rsConcepto.CIrango,
                                               rsConcepto.CItipo,
                                               rsConcepto.DEid,
                                               0,
                                               session.Ecodigo,
                                               0,
                                               0,
                                               rsConcepto.CIdia,
                                               rsConcepto.CImes,
                                               0,
                                               FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
                                               'false',
                                               '',
                                               FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                               )>
                <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                <cfset calc_error = RH_Calculadora.getCalc_error()>
                <cfif Not IsDefined("values")>
                    <cfif isdefined("presets_text")>
                        <cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
                    <cfelse>
                        <cfthrow detail="#calc_error#" >
                    </cfif>
                </cfif>
                <cfset vn_cantidad 	= values.get('cantidad').toString()>
                <cfset vn_importe 	= values.get('importe').toString()>
                <cfset vn_resultado = values.get('resultado').toString()>
            <cfelse>
                <cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
            </cfif>
            
            <cfif vDebug>
                Cantidad:<cfdump var="#vn_cantidad#"> </br>
                Importe:<cfdump var="#vn_importe#"></br>
                Resultado: <cfdump var="#vn_resultado#"></br>
            </cfif>
            
            <cfif vn_resultado LT rsCScalculo.ICmontores>
                <cfset lvarExceso = rsCScalculo.ICmontores - vn_resultado>
                <cfset lvarLimite = vn_resultado>
            
                <cfquery datasource="#Arguments.datasource#" name="rsInsert">	
                    insert into IncidenciasCalculo (
                    RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion,	ICcalculo, ICbatch,
                    ICmontoant, ICmontores, CFid, RHSPEid, ICmontoexentorenta, Mcodigo, ICmontoorigen, BMUsucodigo, RHJid,
                    Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta, CPmes, CPperiodo
                    )
                    select ic.RCNid, ic.DEid, #rsCScalculo.CIidexceso#, ic.ICfecha,#lvarExceso#,
                        ic.ICfechasis, ic.Usucodigo, ic.Ulocalizacion, ic.ICcalculo, ic.ICbatch, ic.ICmontoant,
                        #lvarExceso#, ic.CFid, ic.RHSPEid, ic.ICmontoexentorenta, ic.Mcodigo, ic.ICmontoorigen,
                        ic.BMUsucodigo, ic.RHJid, ic.Iusuaprobacion, ic.Ifechaaprobacion, ic.NAP, ic.NRP, ic.Inumdocumento, ic.CFcuenta
                        ,ic.CPmes, ic.CPperiodo
                    from CIncidentes ci
                        inner join IncidenciasCalculo ic
                            on ci.CIid = ic.CIid
                    where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                        and ic.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCScalculo.CIid#"> 
                        and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
                        and ic.ICmontores > 0 
                        and ic.CSid > 0
                </cfquery>
                
                <cfquery datasource="#Arguments.datasource#"> 
                    update IncidenciasCalculo set ICvalor = #lvarLimite#  , ICmontores = #lvarLimite#
                    where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCScalculo.ICid#"> 
                        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                        and DEid = #rsCScalculo.DEid#
                </cfquery>	
            </cfif>
        </cfloop>
    </cfif>

	<cfif vDebug>	
		<cfquery datasource="#Arguments.datasource#" name="xx">
			select *
			from  IncidenciasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              <cfif IsDefined('Arguments.pDEid')>	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
           	order by DEid
		</cfquery>
		Resultado Detalle de las Incidencias Calculo
		<cfdump var="#xx#">
	</cfif>
	
</cfif>
<cfif vDebug>
	<cfabort>
</cfif>
