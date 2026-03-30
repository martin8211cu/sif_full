	<cfsavecontent variable="presets_ret">
	<!---ljimenez debug de variables y datos --->
	<cfset vDebug = "false">
		
		importacion_cantidad = <cfoutput>#Arguments.cantidad#</cfoutput>
        
        MontoIncidenciaCalculo = <cfoutput>#Arguments.MontoIncidencia#</cfoutput>
		
		Fecha1_Accion = #<cfoutput>#LSDateFormat(Fecha1_Accion, "dd/mm/yyyy")#</cfoutput>#
		
		Fecha2_Accion = #<cfoutput>#LSDateFormat(Fecha2_Accion, "dd/mm/yyyy")#</cfoutput>#
		
		Dias          = <cfoutput>#DateDiff("d", Fecha1_Accion, Fecha2_Accion) + 1#</cfoutput>

		<cfset vDias360 = funcDias360(Fecha1_Accion, Fecha2_Accion) >
		Dias360 = <cfoutput>#vDias360#</cfoutput>
		
		<cfset Dias_habiles = get_dias_habiles(Fecha1_Accion, Fecha2_Accion, RHJid)>
		Dias_habiles  =  <cfoutput>#Dias_habiles#</cfoutput>
		
		<cfquery name="data" datasource="#session.dsn#" maxrows="1">
			select a.DLlinea,a.DLfvigencia LTdesde, coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">) LThasta
			  from DLaboralesEmpleado a
			  where a.DLlinea = (
					 select max(b.DLlinea)
					 from DLaboralesEmpleado b
					 where b.DEid = #DEid# 
						 and b.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHTid#" null="#Len(RHTid) Is 0 or RHTid Is 0#">
						 and b.Ecodigo = #Ecodigo#
						 and b.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
						 and b.DLfvigencia > coalesce(
											   (select max(c.DLfvigencia)
											    	from DLaboralesEmpleado c
                                               			inner join RHTipoAccion ta
                                                			on ta.RHTid   = c.RHTid
												   		   and ta.Ecodigo = c.Ecodigo
											      where c.DEid    = #DEid#
												    and c.Ecodigo = #Ecodigo#
												    and ta.RHTcomportam = 2), <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(1900, 01, 01)#">)
			)
		</cfquery>
	
		<cfif data.RecordCount EQ 1>
			<cfset vDLlinea = data.DLlinea >
			<cfset Fecha1_ultima_accion = data.LTdesde >
			<cfset Fecha2_ultima_accion = data.LThasta >
		<cfelse>
			<cfset vDLlinea = -1>
			<cfset Fecha1_ultima_accion = CreateDate(1900,1,1)>
			<cfset Fecha2_ultima_accion = CreateDate(1900,1,1)>
		</cfif>
		Fecha1_ultima_accion = #<cfoutput>#LSDateFormat(Fecha1_ultima_accion, "dd/mm/yyyy")#</cfoutput>#
		Fecha2_ultima_accion = #<cfoutput>#LSDateFormat(Fecha2_ultima_accion, "dd/mm/yyyy")#</cfoutput>#
		
		<!---ljimenez Dias_Incapacidad
		devuelve los dias de incacidad para el año 01/01 al 31/12 --->
		<cfquery name="rsDiasFalta" datasource="#session.dsn#">
			select coalesce(sum(b.PEcantdias),0) as DiasFalta
				from HPagosEmpleado b
					inner join RHTipoAccion c
					  on c.RHTid = b.RHTid
				where b.DEid = #DEid#
					and c.RHTcomportam = 13 <!--- Ausencia / Falta --->
					and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
					and c.Ecodigo = #Ecodigo#
					and b.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(Fecha1_Accion), 01, 01)#">
					and b.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(Fecha2_Accion), 12, 31)#">
		</cfquery>
		
		<cfset Dias_Falta=0>
		<cfif rsDiasFalta.recordcount gt 0>
			<cfset Dias_Falta=rsDiasFalta.DiasFalta>
		<cfelse>
			<cfset Dias_Falta=0>
		</cfif>
		Dias_Falta =  <cfoutput>#Dias_Falta#</cfoutput>
		
		<!---ljimenez Dias_Incapacidad--->
		<cfquery name="rsDiasIncap" datasource="#session.dsn#">
			select coalesce(sum(b.PEcantdias),0) as DiasIncap
				from HPagosEmpleado b
					inner join RHTipoAccion c
					  on c.RHTid = b.RHTid
				where b.DEid = #DEid#
					and c.RHTcomportam = 5 <!--- Ausencia / Falta --->
					and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
					and c.Ecodigo = #Ecodigo#
					and b.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(Fecha1_Accion), 01, 01)#">
					<!---'20100101' #Fecha1_Accion#--->
					and b.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(Fecha2_Accion), 12, 31)#">
					<!---'20101231' #Fecha2_Accion#--->
		</cfquery>
		
		<cfset Dias_IncapacidadMX=0>
		<cfif rsDiasIncap.recordcount gt 0>
			<cfset Dias_IncapacidadMX=rsDiasIncap.DiasIncap>
		<cfelse>
			<cfset Dias_IncapacidadMX=0>
		</cfif>
		Dias_IncapacidadMX =  <cfoutput>#Dias_IncapacidadMX#</cfoutput>
		
		
		
				
		<!---Variables para el ITCR--->
		<!---Años de antiguedad de una persona
		En este caso se van a crear 4 variables de antiguedad ya que se manejan 4 tipos diferentes en el itcr
		-antig0-->Corresponde a la antiguedad del sector publico
		-antig1-->Corresponde a la antiguedad de universidades estatales
		-antig2-->Corresponde a la antiguedad del ITCR
		-antig3-->Corresponde a la antiguedad de medicos
		--->
		<!---Este query se realiza debido a que si la accion es tipo anualidad y va por accion masiva esta debe de pintar el resultado que se obtendria
		si se aplica la accion de personal--->
			<cfquery name="valAccion" datasource="#session.dsn#">
			select count(1) as cantidad from 
				RHAcciones a
				inner join RHAccionesMasiva b
					inner join RHTAccionMasiva c
					on b.RHTAid=c.RHTAid
					and RHTAanualidad=1
				on a.RHAid=b.RHAid
				where RHAlinea=#RHAlinea#
			</cfquery>

		<cfset Antig0=0>
        <cfif isdefined('Arguments.FijarVariable') and StructKeyExists(Arguments.FijarVariable,'Antig0')>
        	<cfset Antig0 = StructFind(Arguments.FijarVariable,"Antig0")>
        <cfelse>
            <cfquery name="data" datasource="#session.dsn#">
                select coalesce(sum(b.DAanos),0) as EAtotal
               		from EAnualidad a
                		inner join DAnualidad b
                    		on b.EAid = a.EAid
                    where Ecodigo 		   = #Ecodigo#
                      and a.DAtipoConcepto = 0
                      and DEid 			   = #DEid#
                      and b.DAfdesde      <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
            </cfquery>
            <cfif data.recordcount gt 0>
                <cfset antig0=data.EAtotal>
            <cfelse>
                <cfset antig0=0>
            </cfif>
       	</cfif>
        Antig0 =  <cfoutput>#antig0#</cfoutput>
        <cfset Antig1=0>
        <cfif isdefined('Arguments.FijarVariable') and StructKeyExists(Arguments.FijarVariable,'Antig1')>
        	<cfset Antig1 = StructFind(Arguments.FijarVariable,"Antig1")>
        <cfelse>
            <cfquery name="data" datasource="#session.dsn#">
                select coalesce(sum(b.DAanos),0) as EAtotal
                	from EAnualidad a
                		inner join DAnualidad b
                    		on b.EAid = a.EAid
                    where Ecodigo 		   = #Ecodigo#
                      and a.DAtipoConcepto = 1
                      and DEid 			   = #DEid#
                      and b.DAfdesde      <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
            </cfquery>
            <cfif data.recordcount gt 0>
                <cfset antig1=data.EAtotal>
            <cfelse>
                <cfset antig1=0>
            </cfif>
        </cfif>
		Antig1 =  <cfoutput>#antig1#</cfoutput>
		
		<cfset Antig2=0>
        <cfif isdefined('Arguments.FijarVariable') and StructKeyExists(Arguments.FijarVariable,'Antig2')>
        	<cfset Antig2 = StructFind(Arguments.FijarVariable,"Antig2")>
        <cfelse>
            <cfquery name="data" datasource="#session.dsn#">
                select coalesce(sum(b.DAanos),0) as EAtotal
                	from EAnualidad a
                		inner join DAnualidad b
                    		on b.EAid = a.EAid
                    where Ecodigo 		   = #Ecodigo#
                      and a.DAtipoConcepto = 2
                      and DEid 			   = #DEid#
                      and b.DAfdesde      <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
				 <cfif not isdefined('valAccion') or valAccion.cantidad eq 0>
                	  and  DAaplicada is null or DAaplicada = 1
				 </cfif>
            </cfquery>
            <cfif data.recordcount gt 0>
                <cfset antig2=data.EAtotal>
            <cfelse>
                <cfset antig2=0>
            </cfif>
        </cfif>
		Antig2 =  <cfoutput>#antig2#</cfoutput>
		
		
		<cfset Antig3=0>
        <cfif isdefined('Arguments.FijarVariable') and StructKeyExists(Arguments.FijarVariable,'Antig3')>
        	<cfset Antig3 = StructFind(Arguments.FijarVariable,"Antig3")>
        <cfelse>
            <cfquery name="data" datasource="#session.dsn#">
                select coalesce(sum(b.DAanos),0) as EAtotal
                	from EAnualidad a
                		inner join DAnualidad b
                    		on b.EAid = a.EAid
                    where Ecodigo 		   = #Ecodigo#
                      and a.DAtipoConcepto = 3
                      and DEid 			   = #DEid#
                      and b.DAfdesde      <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2_Accion#">
            </cfquery>
            <cfif data.recordcount gt 0>
                <cfset antig3=data.EAtotal>
            <cfelse>
                <cfset antig3=0>
            </cfif>
        </cfif>
		Antig3 =  <cfoutput>#antig3#</cfoutput>
		
		<!---Categoria a la que pertenece la persona--->
       	<cfset categoriaEmp=0>
        <cfif isdefined('Arguments.FijarVariable') and StructKeyExists(Arguments.FijarVariable,'categoriaEmp')>
        	<cfset categoriaEmp = StructFind(Arguments.FijarVariable,"categoriaEmp")>
        <cfelse>
			<!--- VERIFICA SI LA PERSONA TIENE PUESTO ALTERNO --->
            <cfquery name="rsPuestoAlt" datasource="#session.DSN#">
                select RHCcodigo
                 from RHAcciones ac
                 inner join RHPuestos a
                    on a.RHPcodigo = ac.RHPcodigoAlt
                inner join RHMaestroPuestoP b
                    on b.RHMPPid = a.RHMPPid
                    and b.Ecodigo = a.Ecodigo
                inner join RHCategoriasPuesto c
                    on c.RHMPPid = b.RHMPPid
                    and c.Ecodigo = b.Ecodigo
                inner join RHCategoria cat
                    on cat.RHCid = c.RHCid
                where a.Ecodigo = #session.Ecodigo#
                  and ac.RHAlinea = #RHAlinea#
            </cfquery>
            <cfquery name="rsdata" datasource="#session.dsn#">
                select RHCcodigo 
                from RHAcciones l 
                    inner join RHCategoriasPuesto c
                        inner join RHCategoria e
                        on e.RHCid=c.RHCid
                    on c.RHCPlinea=l.RHCPlinea
                where DEid=#DEid#
                   and l.RHAlinea = #RHAlinea#
            </cfquery>
            <cfif rsPuestoAlt.RecordCount and LEN(TRIM(rsPuestoAlt.RHCcodigo)) GT 0>
                <cfset categoriaEmp=rsPuestoAlt.RHCcodigo>
            <cfelseif rsdata.recordcount gt 0>
                <cfset categoriaEmp=rsdata.RHCcodigo>
            <cfelse>
                <cfquery name="rsPuestoAlt" datasource="#session.DSN#">
                    select RHCcodigo
                     from LineaTiempo ac
                     inner join RHPuestos a
                        on a.RHPcodigo = ac.RHPcodigoAlt
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    inner join RHCategoria cat
                        on cat.RHCid = c.RHCid
                    where a.Ecodigo = #session.Ecodigo#
                      and DEid=#DEid#
                      and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha1_Accion#"> 
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha2_Accion#"> 
                       or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha1_Accion#"> 
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha2_Accion#">)
                </cfquery>
                <cfquery name="rsdata" datasource="#session.dsn#">
                    select RHCcodigo 
                    from LineaTiempo l 
                        inner join RHCategoriasPuesto c
                            inner join RHCategoria e
                            on e.RHCid=c.RHCid
                        on c.RHCPlinea=l.RHCPlinea
                    where DEid=#DEid#
                       and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha1_Accion#"> 
                       and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha2_Accion#"> 
                        or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha1_Accion#"> 
                       and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha2_Accion#">)
                </cfquery>
                <cfif rsPuestoAlt.RecordCount and LEN(TRIM(rsPuestoAlt.RHCcodigo)) GT 0>
                    <cfset categoriaEmp=rsPuestoAlt.RHCcodigo>
                <cfelseif rsdata.recordcount gt 0>
                    <cfset categoriaEmp=rsdata.RHCcodigo>
                <cfelse>
                    <cfset categoriaEmp=0>
                </cfif>
            </cfif>
        </cfif>
		categoriaEmp =  <cfoutput>#categoriaEmp#</cfoutput>
        <cfquery name="data" datasource="#session.dsn#">
			select coalesce (EVfantig, <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(1900, 01, 01)#">) as EVfantig  from EVacacionesEmpleado
			where DEid = #DEid# 
		</cfquery>
		<cfif data.recordCount eq 0>
			<cfset Fecha_Ingreso = "01/01/1900">
		<cfelse>
			<cfset Fecha_Ingreso = data.EVfantig>
		</cfif>
		Fecha_Ingreso = #<cfoutput>#LSDateFormat(Fecha_Ingreso, "dd/mm/yyyy")#</cfoutput>#
		Antiguedad    = <cfoutput>#DateDiff("m", Fecha_Ingreso, Fecha1_Accion)#</cfoutput>
		
		<!--- COOPESERVIDORES - inicio --->
		<!--- Liquidan cesantia de empleados cada 8 annos, entonces se necesita saber la fecha de la ultima vez que se liquido la cesantia de un empleado 
			  Para la proxima vez que se ejecute una liquidacion, ya sea por 8 annos o fin de relacion laboral, lo scalculos los haga con esta fecha de ultima
			  liquidacion --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
			ecodigo="#Session.Ecodigo#" pvalor="810" default="" returnvariable="calculaInteresCesantia"/>
		
		<cfif calculaInteresCesantia eq 'YES' >
			<cfquery name="rs_fecha_ult_liq" datasource="#session.DSN#">
				select ve.EVfantig, ve.EVfliquidacion
				from EVacacionesEmpleado ve
				where ve.DEid = #DEid#
			</cfquery>
			<cfif rs_fecha_ult_liq.recordcount gt 0 >
				<cfset fecha_ultima_liquidacion = rs_fecha_ult_liq.EVfantig >
				<cfif len(trim(rs_fecha_ult_liq.EVfliquidacion)) and DateCompare( rs_fecha_ult_liq.EVfliquidacion, fecha_ultima_liquidacion) gt 0 >
					<cfset fecha_ultima_liquidacion = rs_fecha_ult_liq.EVfliquidacion >			
				</cfif> 
			<cfelse>
				<cfset fecha_ultima_liquidacion = CreateDate(1900,1,1)>
			</cfif>
			
			Fecha_Ultima_Liquidacion = #<cfoutput>#LSDateFormat(fecha_ultima_liquidacion, "dd/mm/yyyy")#</cfoutput>#
	
			<!--- Coopeservidores paga cesantia a los empleados que renuncian, pero paga un porcentaje de la misma segun la antiguedad 
				  del empleado, aqui se determina cual es el porcentaje a pagarle de cesantia al empleado que renuncia 	--->
			<cfset meses_laborados = 0 >
			<cfif len(trim(fecha_ultima_liquidacion))>
				<cfset meses_laborados = abs((datediff('d', fecha_ultima_liquidacion, Fecha1_accion )/30.00)) >
			</cfif>
			<cfquery name="rs_porcentaje" datasource="#session.DSN#">
				select coalesce(max(RHCMporcentaje), 0) as porcentaje
				from RHCesantiaMes
				where RHCMmes <= <cfqueryparam cfsqltype="cf_sql_float" value="#meses_laborados#">
			</cfquery>
			<cfset porcentaje_pagar = rs_porcentaje.porcentaje > 
			<cfif len(trim(porcentaje_pagar)) eq 0>
				<cfset porcentaje_pagar = 0 > 
			</cfif>
			Porcentaje_Cesantia  = <cfoutput>#porcentaje_pagar#</cfoutput>
		</cfif>			
		<!--- COOPESERVIDORES - fin --->		
		
		<cfset fecha_uso = Fecha2_Accion >
		<cfif year(Fecha2_Accion) eq 6100>
			<cfset fecha_uso = Fecha1_Accion >
		</cfif>
		<cfset vAntiguedad360 = funcDias360(Fecha_Ingreso, fecha_uso) >
		Antiguedad360     = <cfoutput>#vAntiguedad360#</cfoutput>

		Periodos_teorico  = <cfoutput>#abs(CIcantidad)#</cfoutput>

		<!--- SE DA CUENTA CUAL FECHA DEBE UTILIZAR PARA LOS CALCULOS Y LA RECUPERA --->
		<!--- lectura del parametro que determina cual fecha usar para calculos --->
		
		
		<!---ljimenez 
		Revisar el parametro de mes completo del concepto de pago y actulizar rango de fechas que 
		utlizamos para calculos de salarios	sacamos el tipo de nomina a la que pertenence --->
		
		<cfif Len(RHAlinea) Is 0 Or RHAlinea Is 0>
			<cfset Tcodigo = Arguments.Tcodigo>
		<cfelse>
			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="rsTcodigo" datasource="#Session.DSN#">
					select Tcodigo
					from DLaboralesEmpleado
					where DLlinea = #RHAlinea#
				</cfquery>
			<cfelse>
				<cfquery name="rsTcodigo" datasource="#Session.DSN#">
					select Tcodigo
					from RHAcciones
					where RHAlinea = #RHAlinea#
				</cfquery>
			</cfif>
			<cfset Tcodigo = rsTcodigo.Tcodigo>
		</cfif>
	
		<cfquery name="rsFecha1" datasource="#Session.DSN#">
			select max(CPdesde) as fecha1
			from CalendarioPagos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
				and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
		</cfquery>

		<!---ljimenez si el concepto de pago trae parametro mes completo se actualiza la fecha al inicio del mes.--->
		<cfif isdefined("arguments.CImescompleto") and #arguments.CImescompleto# GT 0>
			<cfquery name="rsFecha1" datasource="#Session.DSN#">
				select #CreateDate(year(rsFecha1.fecha1), month(rsFecha1.fecha1), 01)# as fecha1
			</cfquery>
			
			<cfquery name="rsFecha2" datasource="#Session.DSN#">
				select max(CPhasta) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
					and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
			</cfquery>

			<!---ljimenez buscamos las fecha maxima del calendario limite para nuestro calculo--->
			<cfquery name="rsFecha3" datasource="#Session.DSN#">
				select max(CPhasta) as fecha3
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
					and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha2.fecha1#"> between CPdesde and CPhasta
			</cfquery>
			<cfset Fecha1_accion_2 = #rsFecha1.fecha1# >
		<cfelse>		
			<cfset Fecha1_accion_2 = Fecha1_accion >
		</cfif>
		
		<cfset usa_fecha_nomina = false >
		
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
			ecodigo="#session.Ecodigo#" pvalor="800" default="0" returnvariable="vUsaFNomina"/>

		<cfif #vUsaFNomina# eq 1>
			<cfset usa_fecha_nomina = true >
			
			<cfquery name="rs_fecha_nomina" datasource="#session.DSN#">
				select max(RChasta) as RChasta
				from HRCalculoNomina cn
				
				inner join HSalarioEmpleado se
					on se.RCNid=cn.RCNid
					and se.DEid=#DEid#
				
				where cn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
					and ( cn.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1_accion#">
					or <cfqueryparam cfsqltype="cf_sql_date" value="#fecha1_accion#"> between cn.RCdesde and cn.RChasta )
			</cfquery>
			<cfif rs_fecha_nomina.recordcount gt 0 and len(trim(rs_fecha_nomina.RChasta))>
				<cfset Fecha1_accion_2 = rs_fecha_nomina.RChasta >
			</cfif>
		</cfif>
		
		<!--- Fecha teorico original --->
		
		<cfswitch expression="#CItipo#">
			<cfcase value="d"><cfset Fecha_teorico = Dateadd("d",    -CIcantidad, Fecha1_accion_2)></cfcase>
			<cfcase value="w"><cfset Fecha_teorico = Dateadd("ww",   -CIcantidad, Fecha1_accion_2)></cfcase>
			<cfcase value="m"><cfset Fecha_teorico = Dateadd("m",    -CIcantidad, Fecha1_accion_2)></cfcase>
			<cfcase value="y"><cfset Fecha_teorico = Dateadd("yyyy", -CIcantidad, Fecha1_accion_2)></cfcase>
			<cfdefaultcase><cfthrow detail="CItipo invlido: #CItipo#"></cfdefaultcase>
		</cfswitch>
		
		<cfif vDebug>	
			<br>[---------------------------------------detalle Debug--------------------------------------------]	
				
			<br>
			<br>Fecha1_Accion:<cfdump var="#Fecha1_Accion#">
			<br>Fecha_teorico:<cfdump var="#Fecha_teorico#">
			<br>
		<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
		</cfif>
		
		<!--- Si para los calculos se usa la maxima fecha hasta de la nomina inmediatamente anterior a la fecha1_accion, 
			  se realizan los calulos de acuerdo a la variable Fecha1_Accion_2, sino se asigna el valor original --->
		<cfif usa_fecha_nomina >
			<cfswitch expression="#CItipo#">
				<cfcase value="d"><cfset Fecha_teorico_2 = Dateadd("d",    -CIcantidad, Fecha1_Accion_2)></cfcase>
				<cfcase value="w"><cfset Fecha_teorico_2 = Dateadd("ww",   -CIcantidad, Fecha1_Accion_2)></cfcase>
				<cfcase value="m"><cfset Fecha_teorico_2 = Dateadd("m",    -CIcantidad, Fecha1_Accion_2)></cfcase>
				<cfcase value="y"><cfset Fecha_teorico_2 = Dateadd("yyyy", -CIcantidad, Fecha1_Accion_2)></cfcase>
				<cfdefaultcase><cfthrow detail="CItipo invlido: #CItipo#"></cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfset Fecha_teorico_2 = Fecha_teorico >
		</cfif>
		<!--- SE HACE LA SUMA DE UN DA PORQUE LA DIFERENCIA DE MESES SE PIERDE UN DA
			31/01/2008 MENOS 6 MESES SE ESPERA QUE SEA 01/08/2007, PERO ESTA DEVOLVIENDO 31/07/2007 --->
		<cfset Fecha_teorico_2 = DateAdd('d',1,Fecha_teorico_2)>
		
		Fecha1_Accion_2 = #<cfoutput>#LSDateFormat(Fecha1_Accion_2, "dd/mm/yyyy")#</cfoutput>#

		<cfif Len(Arguments.CIdia) And Len(Arguments.CImes)>
			<cfset Fecha_Diames = CreateDate( Year(Fecha_teorico), Arguments.CImes , Arguments.CIdia)>
			<!--- para que ignore hh:mm:ss --->
			<cfset Fecha_teorico = CreateDate( Year(Fecha_teorico), Month(Fecha_teorico), Day(Fecha_teorico))>
			<cfif DateCompare(Fecha_Diames , Fecha_teorico) GE 0>
				<cfset Fecha_teorico = Fecha_Diames>
			<cfelse>
				<cfset Fecha_teorico = DateAdd("yyyy", 1, Fecha_Diames)>
			</cfif>
			<!--- calculos para fecha teorico 2 --->
			<cfset Fecha_Diames = CreateDate( Year(Fecha_teorico_2), Arguments.CImes , Arguments.CIdia)>
			<!--- para que ignore hh:mm:ss --->
			<cfset Fecha_teorico_2 = CreateDate( Year(Fecha_teorico_2), Month(Fecha_teorico_2), Day(Fecha_teorico_2))>
			<cfif DateCompare(Fecha_Diames , Fecha_teorico_2) GE 0>
				<cfset Fecha_teorico_2 = Fecha_Diames>
			<cfelse>
				<cfset Fecha_teorico_2 = DateAdd("yyyy", 1, Fecha_Diames)>
			</cfif>
		</cfif>
	
		<!--- Fecha_Salarios y Fecha_Salarios_Final solo se usa en calulo de montos y en las variables que se van a modificar para Henkel
			  por eso se les puede asignar los valores de Fecha1_Accion_2 y Fecha1_Teorico_2 (estos ya saben si usan fecha de nomina o no) --->
		<cfset Fecha_Salarios_Final = Fecha1_Accion_2 >	

		<cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
			<cfswitch expression="#CItipo#">
				<cfcase value="d"><cfset Fecha_Salarios_Final = Dateadd("d",    Arguments.CIrango, Fecha_teorico_2 )></cfcase>
				<cfcase value="w"><cfset Fecha_Salarios_Final = Dateadd("ww",   Arguments.CIrango, Fecha_teorico_2 )></cfcase>
				<cfcase value="m"><cfset Fecha_Salarios_Final = Dateadd("m",    Arguments.CIrango, Fecha_teorico_2 )></cfcase>
				<cfcase value="y"><cfset Fecha_Salarios_Final = Dateadd("yyyy", Arguments.CIrango, Fecha_teorico_2 )></cfcase>
				<cfdefaultcase><cfthrow detail="CItipo invlido: #CItipo#"></cfdefaultcase>
			</cfswitch>
			<cfif DateCompare(Fecha_Salarios_Final , Fecha1_Accion_2) EQ -1>
				<cfset Fecha_Salarios_Final = Fecha_Salarios_Final>
			<cfelse>
				<cfset Fecha_Salarios_Final = Fecha1_Accion_2>
			</cfif>
		</cfif>
		
		FechaArranque = #<cfoutput>#LSDateFormat(Fecha_teorico_2, "dd/mm/yyyy")#</cfoutput>#
	
		<cfif DateCompare(Fecha_teorico_2 , Fecha_Ingreso) EQ 1>
			<cfset Fecha_Salarios = Fecha_teorico_2>
		<cfelse>
			<cfset Fecha_Salarios = Fecha_Ingreso>
		</cfif>
		
		Fecha_Salarios = #<cfoutput>#LSDateFormat(Fecha_Salarios, "dd/mm/yyyy")#</cfoutput>#
		
		Fecha_Salarios_Final = #<cfoutput>#LSDateFormat(Fecha_Salarios_Final, "dd/mm/yyyy")#</cfoutput>#
		
		<!--- Periodos_real solo se usa en esta seccion de codigo por eso se pueden hacer calculos con los valores 
			  de Fecha1_Accion_2 (este ya sabe si usa fecha de nomina o no) --->
		<cfswitch expression="#CItipo#">
			<cfcase value="d"><cfset Periodos_real = DateDiff("d",    Fecha_Salarios, Fecha1_Accion_2 )></cfcase>
			<cfcase value="w"><cfset Periodos_real = DateDiff("ww",   Fecha_Salarios, Fecha1_Accion_2 )></cfcase>
			<cfcase value="m"><cfset Periodos_real = DateDiff("m",    Fecha_Salarios, Fecha1_Accion_2 )></cfcase>
			<cfcase value="y"><cfset Periodos_real = DateDiff("yyyy", Fecha_Salarios, Fecha1_Accion_2 )></cfcase>
			<cfdefaultcase><cfthrow detail="CItipo invlido: #CItipo#"></cfdefaultcase>
		</cfswitch>

		<cfif vDebug>	
			<br>[---------------------------------------detalle Debug--------------------------------------------]	
				
			<br>
			<br>Fecha_Salarios:<cfdump var="#Fecha_Salarios#">
			<br>Fecha_Salarios_Final:<cfdump var="#Fecha_Salarios_Final#">
			<br>
			<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
		</cfif>

		Periodos_real  = <cfoutput>#Min(CIcantidad, Periodos_real)#</cfoutput>

		<cfquery name="data" datasource="#session.dsn#">
			select coalesce (sum(a.SEsalariobruto), 0) as SumaSalario
			from HSalarioEmpleado a, HRCalculoNomina b, CalendarioPagos c  <!--- no considerar nominas de anticipo (agrega tabla de calendarios) --->
			where a.DEid = #DEid#
			  and b.RCNid = a.RCNid
			  and b.Ecodigo = #Ecodigo#
			  <!--- no considerar las nominas de anticipo --->
			  and c.CPid=b.RCNid
			  and c.CPtipo !=2
			  <cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
				<!--- danim,9/nov/2005. se toma solo la fecha hasta, gracias a sugerencia de JC Gutierrez
					no se modifica el otro caso para no afectar las formulas que ya existen, donde el CIrango es NULL --->
				and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
				and b.RChasta <  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
			  <cfelse>
				and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
				and b.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
			  </cfif>
		</cfquery>
		<cfset SumaSalario = data.SumaSalario>
		SumaSalario = <cfoutput>#SumaSalario#</cfoutput>
		
		<cfquery name="data" datasource="#session.dsn#">
			select coalesce (sum(a.SEincidencias), 0) as SumaIncidencia
			from HSalarioEmpleado a, HRCalculoNomina b
			where a.DEid = #DEid#
			  and b.RCNid = a.RCNid
			  and b.Ecodigo = #Ecodigo#
			  <cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
				<!--- danim,9/nov/2005. se toma solo la fecha hasta, gracias a sugerencia de JC Gutierrez
					no se modifica el otro caso para no afectar las formulas que ya existen, donde el CIrango es NULL --->
				and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
				and b.RChasta <  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
			  <cfelse>
				and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
				and b.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
			  </cfif>
		</cfquery>
		<cfset SumaIncidencia = data.SumaIncidencia>
		SumaIncidencia = <cfoutput>#SumaIncidencia#</cfoutput>
		
		
		<cfquery name="data" datasource="#session.dsn#">
			select CIcodigo, coalesce ((select sum(a.ICmontores)
											from HIncidenciasCalculo a, HRCalculoNomina b
											where c.CIid = a.CIid
											  and a.DEid = #DEid#
											  and a.RCNid = b.RCNid
											  and b.Ecodigo =  #Ecodigo#
												<cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
													<!--- danim,9/nov/2005. se toma solo la fecha hasta, gracias a sugerencia de JC Gutierrez
													no se modifica el otro caso para no afectar las formulas que ya existen, donde el CIrango es NULL --->
													and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
													and b.RChasta <  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
												<cfelse>
													and b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
													and b.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
												</cfif>
                                                <!--- Marcel para compatibilidad con SQL Server --->
											group by a.CIid ) ,0) as ICmontores
		from CIncidentes c
		where c.Ecodigo = #Ecodigo#
		</cfquery>
		<cfoutput query="data">
		SumaIncidencia_#CIcodigo# = #ICmontores#
		</cfoutput>
		
		<cfquery name="data" datasource="#session.dsn#">
			select
				e.ECcodigo,
				d.DCcodigo,
				coalesce (
					(select sum(h.CCvalorpat)
					from 
						HCargasCalculo h
							inner join CalendarioPagos cp
								on cp.CPid = h.RCNid
								<cfif Len(Arguments.CIrango) And (Arguments.CIrango NEQ 0)>
									<!--- danim,6/ene/2006. se usan las mismas fechas que en calculo de salarios --->
									and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
									and cp.CPhasta <  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
								<cfelse>
									and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios#">
									and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
								</cfif>
					where d.DClinea = h.DClinea
					and h.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">),  0)
					 as CCvalorpat
			from ECargas e
				join DCargas d
					on e.ECid = d.ECid
			where e.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfoutput query="data">
		Carga_#Trim(ECcodigo)#_#Trim(DCcodigo)# = #CCvalorpat#
		</cfoutput>
		
		<!--- codigo agregado por fcastro para utilizar fechas de antiguedad del empleado 19-08-11 --->
		
		<cfquery name="dataCargasAntiguedad" datasource="#session.dsn#">
			select
				e.ECcodigo,
				d.DCcodigo,
				coalesce (
					(select sum(h.CCvalorpat)
					from 
						HCargasCalculo h
							inner join CalendarioPagos cp
								on cp.CPid = h.RCNid
									and cp.CPhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Ingreso#"><!--- si la fecha de antiguedad no existe, el defecto es 01-01-1900--->
									and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
					where d.DClinea = h.DClinea
					and h.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">),  0)
					 as CCvalorpat
			from ECargas e
				join DCargas d
					on e.ECid = d.ECid
			where e.Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfoutput query="dataCargasAntiguedad">
		hCarga_#Trim(ECcodigo)#_#Trim(DCcodigo)# = #CCvalorpat#
		</cfoutput>
		
		<!--- codigo agregado por fcastro para obtener el Valor de Salario Minimo indicado en Parámetros Generales , Pcodigo =130 ,  14-09-11 --->
			
			<cfquery name="rsSalarioMinimo" datasource="#session.dsn#">
						select coalesce(Pvalor,'0.00')  as valor
						from RHParametros 
						where Pcodigo=130 
							and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset salariominimo=rsSalarioMinimo.valor>
		salariominimo = <cfoutput>#salariominimo#</cfoutput>
 		
		<!--- fin del codigo agregado 14-09-11 --->
		
		<cfquery name="data" datasource="#session.dsn#">
			select LTsalario, LTporcsal, LTid
			from LineaTiempo a
			where DEid = #DEid#
			  and Ecodigo = #Ecodigo#
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion_2#"> between LTdesde and LThasta 
		</cfquery>
		<cfquery name="datav23" datasource="#session.dsn#">
			select RHAporcsal
			from RHAcciones
			where RHAlinea = #RHAlinea# 
		</cfquery>
		<cfset LTid = IIf(data.RecordCount EQ 0, 0, data.LTid)>
		SalarioActual = <cfoutput>#IIf(data.RecordCount EQ 0, 0, data.LTsalario)#</cfoutput>
		Porcentaje_Salario = <cfoutput>#IIf(datav23.RecordCount EQ 0, IIf(data.RecordCount EQ 0, 100, data.LTsalario), datav23.RHAporcsal)#</cfoutput>
		
		
		<!--- calcula el total de salario de contratacion de un funcionario --->
		<cfset Lvar_SalarioC = 0>
		<cfquery name="datoLT" datasource="#session.DSN#">
			select coalesce((select DLTmonto
			 from DLineaTiempo 
			where LTid=a.LTid 
			  and CSid in (select CSid 
							  from ComponentesSalariales
							  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                              	and CIid is null and CSusatabla = 1))*LTporcsal/100 +
			  coalesce((select sum(DLTmonto) from DLineaTiempo where LTid = a.LTid and CSid in(select CSid 
							  from ComponentesSalariales
							  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                              	and CIid is not null)),0),0) as Salario
				from LineaTiempo a
				where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between LTdesde and LThasta 
 		</cfquery>
		<cfif datoLT.RecordCount GT 0><cfset Lvar_SalarioC = datoLT.Salario></cfif>
 		<cfquery name="datoLTR" datasource="#session.DSN#">
			 select coalesce((select DLTmonto
					 from DLineaTiempoR 
					where LTRid=a.LTRid 
					  and CSid in (select CSid 
									  from ComponentesSalariales
									  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                      	and CIid is null  and CSusatabla = 1)) * LTporcsal/100 +
			   coalesce((select sum(DLTmonto) from DLineaTiempoR where LTRid = a.LTRid and CSid in(select CSid 
									  from ComponentesSalariales
									  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and CIid is not null)),0),0) as Salario
						from LineaTiempoR a
						where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion_2#"> between LTdesde and LThasta 
		</cfquery>
		<cfset Lvar_salarioR = 0>
		<cfloop query="datoLTR">
			<cfset Lvar_salarioR = Lvar_salarioR+datoLTR.Salario>
		</cfloop>	
		SalarioContratacion = <cfoutput>#Lvar_SalarioC + Lvar_salarioR#</cfoutput>

		

		<!--------------------------------------------------------------------------->
		<!---ljimenez calcula suma de componentes salariales adicionales que tenga--->
		<!--------------------------------------------------------------------------->
		<cfset SumaCS = 0>
		<cfif RHAlinea EQ 0>
            <cfquery name="rsCS" datasource="#session.dsn#">
                select coalesce(sum(coalesce (b.DLTmonto, 0)),0) as sumaCS
                    from ComponentesSalariales c
                        left outer join DLineaTiempo b
                            on c.CSid = b.CSid
                            and b.LTid = #LTid#
                    where c.Ecodigo = #session.Ecodigo#			
                        and c.CIid > 0
            </cfquery>
        <cfelse>
        	<cfquery name="rsCS" datasource="#session.DSN#">
            	select coalesce(sum(RHDAmontores),0) as sumaCS
                from RHDAcciones a
                inner join ComponentesSalariales b
                	on b.CSid = a.CSid
                where a.RHAlinea = #RHAlinea#
                  and b.Ecodigo = #session.Ecodigo#
                  and b.CIid > 0
            </cfquery>
       
		</cfif>
		SumaCS = <cfoutput>#IIf(rsCS.RecordCount EQ 0, 0, rsCS.sumaCS)#</cfoutput>
		<!---ljimenez FIN calcula suma de componentes salariales adicionales que tenga--->
		
		<!--------------------------------------------------------------------------->
		<!---  ljimenez calcula porcentaje total de Plaza que tiene el empleado   --->
		<!--------------------------------------------------------------------------->
		
		<cfset PorcentajeOcupacion  = 0>
		
		<cfquery name="rsLT" datasource="#session.dsn#">
			select coalesce(LTporcplaza,0) as LTporcplaza , coalesce(LTporcsal,0)  as  LTporcsal
			from LineaTiempo
			where DEid = #DEid#
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion_2#"> between LTdesde and LThasta 
		</cfquery>
		
		<cfquery name="rsLTR" datasource="#session.dsn#">
			select DEid , coalesce(sum( LTporcplaza),0) as LTporcplaza , coalesce(sum( LTporcsal),0)  as  LTporcsal
			from LineaTiempoR
			where <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion_2#"> between LTdesde and LThasta 
				and DEid = #DEid#
			group by DEid
		</cfquery>
		
		<cfif isdefined('rsLT') and rsLT.recordcount GT 0>
			<cfset PorcentajeOcupacion = rsLT.LTporcplaza>
		</cfif>
		
		<cfif isdefined('rsLTR') and rsLTR.recordcount GT 0>
			<cfset PorcentajeOcupacion = PorcentajeOcupacion + rsLTR.LTporcplaza>
		</cfif>
		
		PorcentajeOcupacion = <cfoutput>#PorcentajeOcupacion#</cfoutput>
		
		<!---  ljimenez calcula porcentaje total de Plaza que tiene el empleado   --->
		<cfif RHAlinea EQ 0>
            <cfquery name="data" datasource="#session.dsn#">
                select c.CScodigo, coalesce (b.DLTmonto, 0) as DLTmonto
                from ComponentesSalariales c
                    left outer join DLineaTiempo b
                        on c.CSid = b.CSid
                        and b.LTid = #LTid#
                where c.Ecodigo = #session.Ecodigo#			
                order by c.CScodigo
            </cfquery>
        <cfelse>
        	<cfquery name="data" datasource="#session.DSN#">
                select c.CScodigo, coalesce (b.RHDAmontores, 0) as DLTmonto
                from ComponentesSalariales c
                    left outer join RHDAcciones b
                        on c.CSid = b.CSid
                        and b.RHAlinea = #RHAlinea#
                where c.Ecodigo = #session.Ecodigo#			
                order by c.CScodigo
            </cfquery>
		</cfif>
		<cfoutput query="data">
		Salario_#Trim(CScodigo)# = #DLTmonto#
		</cfoutput>
	
		<cfset DiasVacaciones = 0>
		<cfset DiasVacacionesPag = 0>
		<cfset Tcodigo = Arguments.Tcodigo>

		<cfif Len(RHAlinea) Neq 0 and RHAlinea NEQ 0>
			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="data" datasource="#session.dsn#">
					select coalesce(DLvdisf, 0) as RHAvdisf, coalesce(DLvcomp, 0) as RHAvcomp, Tcodigo
					from DLaboralesEmpleado
					where DLlinea = #RHAlinea#
					  and Ecodigo = #Ecodigo#
					  and DEid = #DEid#
				</cfquery>
			<cfelse>
				<cfquery name="data" datasource="#session.dsn#">
					select coalesce(RHAvdisf, 0) as RHAvdisf, coalesce(RHAvcomp, 0) as RHAvcomp, Tcodigo
					from RHAcciones
					where RHAlinea = #RHAlinea#
					  and Ecodigo = #Ecodigo#
					  and DEid = #DEid#
				</cfquery>
			</cfif>

			<cfif data.RecordCount ge 1>
				<cfif Len(Trim(data.Tcodigo))>
					<cfset Tcodigo = data.Tcodigo>
				</cfif>
				<cfif Len(Trim(data.RHAvdisf)) GT 0>
					<cfset DiasVacaciones = data.RHAvdisf>
				</cfif>
				<cfif Len(Trim(data.RHAvcomp)) GT 0>
					<cfset DiasVacacionesPag = data.RHAvcomp>
				</cfif>
			</cfif>
		</cfif>
		DiasVacaciones          = <cfoutput>#DiasVacaciones#</cfoutput>
		DiasVacacionesPag       = <cfoutput>#DiasVacacionesPag#</cfoutput>
		
		<!--- ****************************************************************************** --->
		<!--- *************          Calculo Salario Promedio          ********************* --->
		<!--- ****************************************************************************** --->
		
		<cfset SalarioPromedio = 0>
		<cfif Arguments.calc_promedio>	
			<cfif Len(RHAlinea) Is 0 Or RHAlinea Is 0>
				<cfset Tcodigo = Arguments.Tcodigo>
			<cfelse>
				<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from DLaboralesEmpleado
						where DLlinea = #RHAlinea#
					</cfquery>
				<cfelse>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from RHAcciones
						where RHAlinea = #RHAlinea#
					</cfquery>
				</cfif>
				<cfset Tcodigo = rsTcodigo.Tcodigo>
			</cfif>
			<cfif arguments.Tcodigo EQ ''>
				<cfquery name="rsTcodigo" datasource="#Session.DSN#">
					select Tcodigo
					from LineaTiempo
					where <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between LTdesde and LThasta
					and DEid = #DEid#
					and Ecodigo = #Ecodigo#
				</cfquery>
				<cfset Tcodigo = rsTcodigo.Tcodigo>
			</cfif>
<!---			Tcodigo = <cfoutput>#Tcodigo#</cfoutput> --->

			<cfif isdefined("Arguments.RHAlinea") and Arguments.RHAlinea GT 0>
				<cf_dbtemp name="SP_SalProm" returnvariable="tbl_SalProm">
					<cf_dbtempcol name="RCNid" type="numeric">
					<cf_dbtempcol name="DEid" type="numeric"> 
					<cf_dbtempcol name="CantDias" type="Int">
					<cf_dbtempcol name="SEsalariobruto" type="money" mandatory="no">
					<cf_dbtempcol name="SEIncidencias" type="money" mandatory="no">
					<cf_dbtempcol name="SEIncNoAfecta" type="money" mandatory="no">
					<cf_dbtempcol name="SESalMes" type="money" mandatory="no">
					<cf_dbtempcol name="SEIncRetro" type="money" mandatory="no">
					<cf_dbtempcol name="SERetroactivos" type="money" mandatory="no">
				</cf_dbtemp>
			</cfif>
			
			<cfif not lvarMasivo>
				<cf_dbtemp name="tbl_SP_PagosEmp1" returnvariable="tbl_PagosEmpleado">
					<cf_dbtempcol name="RCNid" type="numeric">
					<cf_dbtempcol name="DEid" type="numeric"> 
					<cf_dbtempcol name="FechaDesde" type="datetime">
					<cf_dbtempcol name="FechaHasta" type="datetime">
					<cf_dbtempcol name="Cantidad" type="int">
					<cf_dbtempcol name="RHAlinea" type="numeric">
					<cf_dbtempcol name="Tipo" type="numeric">
					<cf_dbtempkey cols="RCNid,DEid">
				</cf_dbtemp>
			</cfif>
			
			<cfquery name="rsTipoPago" datasource="#Session.DSN#">
				select Ttipopago
				from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
			</cfquery>
			<cfset Ttipopago = rsTipoPago.Ttipopago>
		
			<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
				select count(1) as diasnopago
				from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
			</cfquery>
			<cfset DiasNoPago = rsDiasNoPago.diasnopago>
		
			<cfswitch expression="#Ttipopago#">
				<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
				<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
				<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
			</cfswitch>

			<!--- Saca de parametros RH la cantidad de meses o periodos a tomar en cuenta para el calculo de salario Promedio default 13 periodos--->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="160" default="13" returnvariable="CantidadPeriodos"/>

			<!--- Saca de parametros RH el indicador de meses (1) o periodos (0) --->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="161" default="0" returnvariable="TipoPeriodos"/>

			<!---ljimenez si el concepto de pago trae los parametros para el calculo de salario promedio los utiliza.--->
			<cfif isdefined("arguments.CIsprango") and #arguments.CIsprango# GTE 0>
				<cfset TipoPeriodos 	= #arguments.CIsprango# >
				<cfset CantidadPeriodos = #arguments.CIspcantidad# >
			</cfif>
			
			<cfquery name="rsFecha1" datasource="#Session.DSN#">
				select max(CPdesde) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
					and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
			</cfquery>


			<cfif vDebug>	
				<br>[---------------------------------------detalle Debug--------------------------------------------]	
					
				<br>
				<br>arguments: <cfdump var="#arguments#">
				
				<br>TipoPeriodos [0=Meses 1=Periodos]: <cfdump var="#TipoPeriodos#">
				<br>Cantidad Periodos o Meses: <cfdump var="#CantidadPeriodos#">
				
				<br>Fecha Max Calendario Antes de la fecha accion1 : <cfdump var="#rsFecha1#">
				<br>
				<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
			</cfif>
		
			<!---ljimenez si el concepto de pago trae parametro mes completo se actualiza la fecha al inicio del mes.--->
			<cfif isdefined("arguments.CImescompleto") and #arguments.CImescompleto# GT 0>
				<cfquery name="rsFecha1" datasource="#Session.DSN#">
					select #CreateDate(year(rsFecha1.fecha1), month(rsFecha1.fecha1), 01)# as fecha1
				</cfquery>
				<cfset Fecha1 = rsFecha1.fecha1>
			<cfelse>	<!--- ana--->
				<cfquery name="rsFecha2" datasource="#Session.DSN#">
					select max(CPhasta) as fecha1
					from CalendarioPagos
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
							and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
				</cfquery>
				<cfset Fecha1 = rsFecha2.fecha1>
			</cfif>
			
			<cfif vDebug>	
				<br>[---------------------------------------detalle Debug--------------------------------------------]	
					
				<br>
				<br>Fecha1_Accion: <cfdump var="#Fecha1_Accion#">
				<br>rsFecha1: <cfdump var="#rsFecha1#">
				<br>rsFecha2:<cfdump var="#rsFecha2.fecha1#">
				<br>
				<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
			</cfif>			
				
			<!--- JC Resta la cantidad de meses a Fecha1, es decir se devuelve esa cantidad de meses --->
			<cfif (Len(Trim(Fecha1)))>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, Fecha1)>
			<cfelse>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, now())>  <!--- OJO ESTO LO TUVE QUE PONER PORQUE SI NO ME DA ERROR  DE NULL, NULL --->  
			</cfif>

			<cfif Len(Trim(Fecha1))>
				<cfset Fecha2 = DateAdd('yyyy', -1, DateAdd('d', -30, Fecha1))>

				<cfif vDebug>	
					<br>[---------------------------------------detalle Debug--------------------------------------------]	
						
					<br>
					<br>Fecha1_Accion: <cfdump var="#Fecha1_Accion#">
					<br>Fecha1: <cfdump var="#rsFecha1#">
					<br>Fecha2:<cfdump var="#rsFecha2.fecha1#">
					<br>Fecha3:<cfdump var="#Fecha3#">
					<br>
					<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
				</cfif>	
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
				ecodigo="#Session.Ecodigo#" pvalor="2501" default="0" returnvariable="nominasEspeciales"/>	
				<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
					insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad, RHAlinea,Tipo)
					select distinct a.RCNid, #DEid#, a.RCdesde, a.RChasta, 0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">,CPtipo
					from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
					where b.DEid = #DEid#
						and a.RCNid = b.RCNid
						and a.Ecodigo = #Ecodigo#
						and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
						and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">
						and cp.CPid = a.RCNid
                        <cfif nominasEspeciales EQ 1>
						and cp.CPtipo  in(0,1)
                        <cfelse>
                        and cp.CPtipo = 0
                        </cfif>
					order by a.RChasta desc
				</cfquery>
			</cfif>
			
			<cfif vDebug>	
				<br>[---------------------------------------detalle Debug--------------------------------------------]	
				<cfquery name="nominas" datasource="#session.DSN#">
					select *
					from #tbl_PagosEmpleado# 
					order by FechaHasta desc
				</cfquery>
				
				<br> Nominas entre fecha1 y fecha2:<cfdump var="#nominas#">
				<br>
			</cfif>	
			
			<!--- Borrar de la historia los periodos donde existe incapacidad --->
			<!---El siguiente codigo se agrega debido a que en el ITCR pagan la incapacidad completa  Tomar en cuenta en Salario Promedio las incapacidades --->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="2037" default="0" returnvariable="vUsaIncSP"/>
			<cfif #vUsaIncSP# eq 0>
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					  and Tipo = 0
					  and exists (	select 1
									from HPagosEmpleado pe, RHTipoAccion d
									where pe.DEid = #tbl_PagosEmpleado#.DEid
										and pe.RCNid = #tbl_PagosEmpleado#.RCNid
										and d.RHTid = pe.RHTid
										and d.RHTcomportam = 5 )
				</cfquery>
				
			
				<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
					delete from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					  and Tipo = 0
					  and exists (
						
						select 1
						from 	DLaboralesEmpleado a
						inner join  RHTipoAccion x
							on x.RHTid = a.RHTid
							and x.RHTcomportam = 5
						left outer join RHSaldoPagosExceso pe
							on a.DLlinea = pe.DLlinea
							and pe.RHSPEanulado = 0
						where a.DEid = #tbl_PagosEmpleado#.DEid
						and 
						(
						(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						or
						(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
						)
					)
				</cfquery>
			</cfif>
			
			<!--- Borrar de la historia los periodos donde existe permisos sin goce de salario --->
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete from #tbl_PagosEmpleado#
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and Tipo = 0
				  and exists (	select 1
								from HPagosEmpleado pe, RHTipoAccion d
								where pe.DEid = #tbl_PagosEmpleado#.DEid
									and pe.RCNid = #tbl_PagosEmpleado#.RCNid
									and d.RHTid = pe.RHTid
									and d.RHTcomportam = 4 
									AND d.RHTpaga = 0)
			</cfquery>

			
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete from #tbl_PagosEmpleado#
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and Tipo = 0
				  and exists (
					select 1
					from 	DLaboralesEmpleado a
					inner join  RHTipoAccion x
						on x.RHTid = a.RHTid
						and x.RHTcomportam = 4 
						and x.RHTpaga = 0
					left outer join RHSaldoPagosExceso pe
						on a.DLlinea = pe.DLlinea
						and pe.RHSPEanulado = 0
					where a.DEid = #tbl_PagosEmpleado#.DEid
					and 
					(
					(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
					or
					(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
					)
				)
			</cfquery>
			
		
			<!---	Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
					Se busca la fecha maxima de salida y se eliminan los pagos anteriores --->
			<cfif #vDLlinea# NEQ -1>	<!--- 2011-06-06 Se indica que únicamente se ejecute este borrado, cuando la variable tiene un DLlinea valido --->				
				<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
					select max(DLfvigencia) as fechasalida
					from DLaboralesEmpleado dl, RHTipoAccion ta
					where dl.DEid = #DEid#
					and ta.RHTid = dl.RHTid
					and ta.RHTcomportam = 2
					and dl.DLlinea !=  #vDLlinea#			
				</cfquery>
				<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and (  
						  	FechaDesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
							or
						  	FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 	
						  )
					</cfquery>
				</cfif>
			</cfif>				
				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select *
					from #tbl_PagosEmpleado#
					WHERE RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  order by FechaHasta desc,RCNid,DEid
				</cfquery>
				<cfloop query="rsPagosEmpleado">
					<cfquery name="updPagoEmpleado" datasource="#Session.DSN#">
						update #tbl_PagosEmpleado#
						set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.DEid#">
						and Tipo in (0,1)

					</cfquery>
				</cfloop>

				<!--- JC Si el tipo que se obtuvo de RHParametros es 1 (meses) se devuelve meses, si no se devuelve periodos  --->
				
				<cfif TipoPeriodos EQ 1 and Len(Trim(Fecha3))>
						<cfquery name="rsFechaUC" datasource="#session.DSN#">
							select max(CPhasta) as FechaUltCal
							from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#"> between CPdesde and CPhasta
						</cfquery>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaUC.FechaUltCal#">
					</cfquery>
				<cfelse>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and Cantidad > <cfqueryparam cfsqltype="cf_sql_integer" value="#CantidadPeriodos#">
					</cfquery>
				</cfif>
				
				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select 1
					from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				</cfquery>
				
				
				<cfif vDebug>	
					<cfquery name="nominas" datasource="#session.DSN#">
						select *
						from #tbl_PagosEmpleado# 
						order by FechaHasta desc
					</cfquery>
					
					<br> Nominas sobre las que se realiza el calculo:<cfdump var="#nominas#">
					<br>
				</cfif>					
				
			<!--- 	Fecha1: <cfdump var="#fecha1#"><br />
				Fecha2: <cfdump var="#fecha2#"><br />
				vUsaIncSP: <cfdump var="#vUsaIncSP#"><br />
				CantidadPeriodos: <cfdump var="#CantidadPeriodos#"><br />
				TipoPeriodos: <cfdump var="#TipoPeriodos#">
				
				<cfquery name="nominas" datasource="#session.DSN#">
				select *
				from #tbl_PagosEmpleado# 
				order by FechaHasta desc
				</cfquery>
				<cfdump var="#nominas#"> --->
	
				<cfif rsPagosEmpleado.recordCount>
					<!---ljimenez Tomar en salario promedio los retroactivos distribuidos por mes --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" 
						datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2038" default="0" returnvariable="vUsaRetro"/>			


					<cfif vDebug>
					<br>
					<br>Tomar en salario promedio los retroactivos distribuidos por mes [0 = no los toma 1 = si los toma]: <cfdump var="#vUsaRetro#">
					<br>
					<br>[-------------------------------------------Fin Debug----------------------------------------------]</br>
					</cfif>				
					<cfif #vUsaRetro# eq 1>
						<!---Saco el salario que le corresponde a la nomina sin los retroactivos--->
						<cfquery name="rsSalarioPromedio01" datasource="#Session.DSN#">
							select coalesce(sum(hp.PEmontores),0) as salario
							from  HPagosEmpleado hp
								inner join HRCalculoNomina n
									inner join #tbl_PagosEmpleado# pe
									on pe.RCNid=n.RCNid
								on n.RCNid=hp.RCNid
							where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
					
						<!---Saco las incidencias del mes que afectan salario promedio--->
						<cfquery name="rsSalarioIncidencias" datasource="#session.dsn#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, HRCalculoNomina n,#tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
							and n.RCNid=hi.RCNid
							and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							<!--- and hi.ICfecha between n.RCdesde and n.RChasta --->
							and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and ci.CIid = hi.CIid
							and ci.CIafectasalprom = 1
						</cfquery>
                        <cfquery name="fechamin" datasource="#session.DsN#">
                        	select min(FechaDesde) as Fminima
                            from #tbl_PagosEmpleado#
                        </cfquery>
                        <cfset Lvar_FminRango = fechamin.Fminima>
						<!---Saco el salario si tiene algun retroactivo--->
						<cfquery name="rsSalarioPromedioR" datasource="#session.dsn#">
							select coalesce(sum(hp.PEmontores),0) as salario
								from  HPagosEmpleado hp,#tbl_PagosEmpleado# pe
								where hp.PEhasta < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FminRango#">
								and hp.PEtiporeg in (1,2)
								and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>	
						<!---saco las incidencias retroactivas--->
						<cfquery name="rsSalarioPromedioRI" datasource="#Session.DSN#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, #tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
							and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							and hi.ICfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FminRango#">
							and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and ci.CIid = hi.CIid
							and ci.CIafectasalprom = 1
						</cfquery>
                        
                         <!--- TABLA PARA CALCULAR LOS DÍAS PAGADOS EN LA NÓMINA --->
                        <cf_dbtemp name="RDiasPagar" returnvariable="RDiasPagar" datasource="#session.DSN#">
                        	<cf_dbtempcol name="RCNid" type="numeric" mandatory="yes">
                        	<cf_dbtempcol name="dias" type="int" mandatory="no">
                        </cf_dbtemp>
                        
                        
                        <cfquery datasource="#session.DSN#">
                            insert into #RDiasPagar#(RCNid)
                            select RCNid
                            from #tbl_PagosEmpleado# 
                            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
                         </cfquery>
                         <cfquery name="rsNom" datasource="#session.DSN#">
                         	select * 
                            from  #tbl_PagosEmpleado# 
                         </cfquery>
                         <cfloop query="rsNom">
                         	<cfset Lvar_desde = rsNom.FechaDesde>
                            <cfset Lvar_hasta = rsNom.FechaHasta>
                            <cfset cont = 0>
                            <cfloop from="#Lvar_desde#" to="#Lvar_hasta#"  index="i">
                            	<cfquery name="rs" datasource="#session.DSN#">
                                	select distinct 1 as cuenta
                                    from HPagosEmpleado hp
                                    where hp.RCNid = #rsNom.RCNid #
                                      and '#LSDateFormat(i,'yyyymmdd')#' between hp.PEdesde and hp.PEhasta

                                </cfquery>
                                <cfif rs.recordCount and rs.cuenta GT 0>
                               		<cfset cont = cont + 1>
                                </cfif>
                            </cfloop>
                            <!--- dias por nomina --->
                            <cfset cantdias = 0>
                            <cfquery name="rsCantDiasMensual" datasource="#session.DSN#">
                                select FactorDiasSalario
                                from TiposNomina
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#"> 
                                  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
                            </cfquery>
                            <!--- asigna valor solo si es mayor a cero y diferente de nulo --->
                            <cfif len(trim(rsCantDiasMensual.FactorDiasSalario)) and rsCantDiasMensual.FactorDiasSalario gt 0>
                                <cfset CantDiasMensual = rsCantDiasMensual.FactorDiasSalario >
                            <cfelse>
                                <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
                            </cfif>
							<cfif rsTipoPago.Ttipopago is 2>
                                <cfset cantdias = CantDiasMensual / 2>
                            <cfelseif rsTipoPago.Ttipopago is 3>
                                <cfset cantdias = CantDiasMensual>
                            <cfelse>
                                <cfquery datasource="#session.DSN#" name="DiasTiposNomina">
                                    select  count(1) as cant
                                    from DiasTiposNomina 
                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#"> 
                                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
                                </cfquery>
                                <cfset cantdias = Abs(DateDiff('d', Lvar_Hasta, Lvar_Desde)) + 1 - DiasTiposNomina.cant + Int(cantdias / 7.0) >
                                <cfif cantdias EQ 0><cfset cantdias = 1></cfif>
                            </cfif>
                            
							<cfquery datasource="#session.DsN#">
                            	update #RDiasPagar#
                                set dias = <cfif cantdias lt cont>#cantdias#<cfelse>#cont#</cfif>
                                where RCNid = #rsNom.RCNid #
                            </cfquery>
                         </cfloop>
                         <cfquery  name="rsSalarioPromedio3" datasource="#session.DsN#">
                        	select sum(dias) as dias
	                        from #RDiasPagar# 
                          </cfquery>
						<cfif rsSalarioPromedio3.recordCount GT 0 AND rsSalarioPromedio3.dias GT 0>
                          <cfset Lvardias = rsSalarioPromedio3.dias>
						<cfelse>
							<cfset Lvardias = 1>
						</cfif> 
						<!--- Obtener el salario promedio diario --->
						<cfset SalarioPromedio = ((rsSalarioPromedio01.salario-rsSalarioPromedioR.salario) + (rsSalarioIncidencias.incidente - rsSalarioPromedioRI.incidente)) / Lvardias>
                      <!---   Salarios <cfdump var="#rsSalarioPromedio01#"><br />
                        SalarioRetro <cfdump var="#rsSalarioPromedioRI#" label="SalarioRetro"><br />
                        SalarioR <cfdump var="#rsSalarioPromedioR#" label="SalarioR"><br />
                        Incidencias <cfdump var="#rsSalarioIncidencias#"><br />
                        Salario - SalarioR + Incidenicas <cfdump var="#(rsSalarioPromedio01.salario) + (rsSalarioIncidencias.incidente)#"><br />
                        Accion <cfdump var="#lvarRHAlinea#"><br />
                        Canti dias <cfdump var="#Lvardias#"><br />
                        Salario Promedio <cf_dump var="#SalarioPromedio#"><br /> --->
						
						<cfif isdefined("Arguments.RHAlinea") and Arguments.RHAlinea GT 0>
						<!---Promedio de salarios por calendario de pago---><!---CarolRS--->
							<cfquery datasource="#Session.DSN#">
								Insert into #tbl_SalProm# (SEsalariobruto,RCNid,DEid)
								select coalesce(sum(hp.PEmontores),0) as salario, pe.RCNid,pe.DEid
								from  HPagosEmpleado hp
									inner join HRCalculoNomina n
										inner join #tbl_PagosEmpleado# pe
										on pe.RCNid=n.RCNid
									on n.RCNid=hp.RCNid
									and n.RCdesde=hp.PEdesde
									and n.RChasta=hp.PEhasta
								where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
								Group by pe.RCNid,pe.DEid
							</cfquery>
							
							<!---Salario retroactivo--->
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set SERetroactivos =						
										(
											select coalesce(sum(hp.PEmontores),0)
											from  HPagosEmpleado hp, #tbl_PagosEmpleado# pe
											where hp.PEdesde  between pe.FechaDesde and pe.FechaHasta
											and hp.PEtiporeg in (1,2)
											and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											and pe.DEid = #tbl_SalProm#.DEid
											and pe.RCNid = #tbl_SalProm#.RCNid 
										)
							</cfquery>
							
							<!---Incidencias --->
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set SEIncidencias =						
										(
											select coalesce(sum(hi.ICmontores),0)
											from  HIncidenciasCalculo hi, HRCalculoNomina n,#tbl_PagosEmpleado# pe,CIncidentes ci
											where hi.RCNid=pe.RCNid
											and n.RCNid=hi.RCNid
											and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											and ci.CIid = hi.CIid
											and ci.CIafectasalprom = 1
											and pe.DEid = hi.DEid
											and pe.DEid = #tbl_SalProm#.DEid
											and  pe.RCNid = #tbl_SalProm#.RCNid 
										)
							</cfquery>
							
							<!---Incidencias retroactivas--->
							<cfquery  datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set SEIncRetro =						
										(
											select coalesce(sum(hi.ICmontores),0)
											from  HIncidenciasCalculo hi, #tbl_PagosEmpleado# pe,CIncidentes ci
											where hi.RCNid=pe.RCNid
											and hi.ICfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FminRango#">
											and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											and ci.CIid = hi.CIid
											and ci.CIafectasalprom = 1
										    and pe.DEid = hi.DEid
											and pe.DEid = #tbl_SalProm#.DEid
										    and  pe.RCNid = #tbl_SalProm#.RCNid 
										)
							</cfquery>
							<!---Cantidad de Dias--->
							<cfquery  datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set CantDias =						
										(
											select sum(coalesce(PEcantdias, 0))
											from HPagosEmpleado b, #tbl_PagosEmpleado# a
											where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											  and b.RCNid = a.RCNid
											  and b.DEid = a.DEid
											  and b.PEtiporeg = 0
											  and a.DEid = #tbl_SalProm#.DEid
											  and a.RCNid = #tbl_SalProm#.RCNid 
										)
							</cfquery>
							
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
								set SESalMes = ((SEsalariobruto - SERetroactivos) + (SEIncidencias - SEIncRetro))
							</cfquery>
							
							<cfquery datasource="#Session.DSN#">
								Delete from RHSalPromAccion where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							</cfquery>
							
							<cfquery datasource="#Session.DSN#">
								insert into RHSalPromAccion ( RHAlinea,DEid,RCNid,RHSPAmonto,RHSPAdias )
								select <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
									,DEid
									,RCNid
									,SESalMes
									,CantDias 
									from  #tbl_SalProm#
							</cfquery>
						</cfif>
							<!---Fin salarios por calendario de pago--->
						
						
					<cfelse>
						<cfquery name="rsSalarioPromedio1" datasource="#Session.DSN#">
							select sum(SEsalariobruto+ SEincidencias) as salario
							from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
							where se.RCNid = pe.RCNid
							  and se.DEid = pe.DEid
							  and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
	
						<cfquery name="rsSalarioPromedio2" datasource="#Session.DSN#">
							select coalesce(sum(ic.ICmontores), 0.00) as incidencias
							from #tbl_PagosEmpleado# pe, HIncidenciasCalculo ic, CIncidentes ci
							where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and  ic.RCNid = pe.RCNid
							  and ic.DEid = pe.DEid
							  and ci.CIid = ic.CIid
							  and ci.CIafectasalprom = 0
						</cfquery>

						<cfquery name="rsSalarioPromedio3" datasource="#Session.DSN#">
							select sum(coalesce(PEcantdias, 0)) as dias
							from HPagosEmpleado b, #tbl_PagosEmpleado# a
							where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and b.RCNid = a.RCNid
							  and b.DEid = a.DEid
							  and b.PEtiporeg = 0
						</cfquery>

						<cfif rsSalarioPromedio3.recordCount GT 0 AND rsSalarioPromedio3.dias GT 0>
							<cfset Lvardias = rsSalarioPromedio3.dias>
						<cfelse>
							<cfset Lvardias = 1>
						</cfif>
						<!--- Obtener el salario promedio diario --->
						<cfset SalarioPromedio = (rsSalarioPromedio1.salario - rsSalarioPromedio2.incidencias) / Lvardias>
						<cfif isdefined("Arguments.RHAlinea") and Arguments.RHAlinea GT 0>
						<!---Promedio de salarios por calendario de pago---><!---CarolRS--->
							<cfquery datasource="#Session.DSN#">
								Insert into #tbl_SalProm# (SEsalariobruto,SEIncidencias,RCNid,DEid)
								select coalesce(sum(se.SEsalariobruto), 0), coalesce(sum(se.SEincidencias), 0), pe.RCNid,pe.DEid
								from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
								where se.RCNid = pe.RCNid
								  and se.DEid = pe.DEid
								  and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
								group by  pe.RCNid,pe.DEid
							</cfquery>
							<!---Incidencias No afectas Salario Promedio--->
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set SEIncNoAfecta=						
										(
											select coalesce(sum(ic.ICmontores),0)
											from #tbl_PagosEmpleado# pe, HIncidenciasCalculo ic, CIncidentes ci
											where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											  and  ic.RCNid = pe.RCNid
											  and ic.DEid = pe.DEid
											  and ci.CIid = ic.CIid
											  and ci.CIafectasalprom = 0
											  and pe.DEid = #tbl_SalProm#.DEid
											  and  pe.RCNid = #tbl_SalProm#.RCNid )
							</cfquery>
							<!---Cantidad de dias--->
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
									set CantDias=						
										(
											select coalesce(sum(PEcantdias), 1)
											from HPagosEmpleado b, #tbl_PagosEmpleado# a
											where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
											  and b.RCNid = a.RCNid
											  and b.DEid = a.DEid
											  and b.PEtiporeg = 0
											  and a.DEid = #tbl_SalProm#.DEid
											  and a.RCNid = #tbl_SalProm#.RCNid 
										)
							</cfquery>
							<!---Promedio Mensual--->
							<cfquery datasource="#Session.DSN#">
								Update #tbl_SalProm#
								set SESalMes = ((SEsalariobruto + SEIncidencias) - SEIncNoAfecta)
							</cfquery>
							<!---Pasar a la tabla--->
							<cfquery datasource="#Session.DSN#">
								Delete from RHSalPromAccion where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							</cfquery>
							<cfquery datasource="#Session.DSN#">
								insert into RHSalPromAccion ( RHAlinea,DEid,RCNid,RHSPAmonto,RHSPAdias )
								select <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
									,DEid
									,RCNid
									,SESalMes
									,CantDias 
									from  #tbl_SalProm#
							</cfquery>
							<!---Fin salarios por calendario de pago--->
						</cfif>
					</cfif>
					
					<!--- Salario Promedio = Salario Promedio Diario * Cantidad de Dias para calculo de Salario Diario --->
					<cfquery name="rsParametros" datasource="#Session.DSN#">
						select FactorDiasSalario as Pvalor
						from TiposNomina
						where Ecodigo = #session.Ecodigo#
						  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
					</cfquery>
					<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
						<cfquery name="rsParametros" datasource="#Session.DSN#">
							select Pvalor from RHParametros where Ecodigo = #Ecodigo# and Pcodigo = 80
						</cfquery>
					</cfif>
					<cfset SalarioPromedio = SalarioPromedio * rsParametros.Pvalor>
					
					<cfif not lvarMasivo>
						<cfquery name="dropPagosEmpleado" datasource="#Session.DSN#">
							delete from #tbl_PagosEmpleado#
						</cfquery>
					</cfif>
				<cfelse>
					<cfset SalarioPromedio = 0>
				</cfif>
		</cfif>

		SalarioPromedio = <cfoutput>#SalarioPromedio#</cfoutput>
		<cfif vDebug>	
			<br>	
			<cf_dump var="fin de variables">
			<br>	
		</cfif>
	</cfsavecontent>