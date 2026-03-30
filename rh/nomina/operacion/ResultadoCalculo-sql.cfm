<cfif isdefined('form.baja')><!--- si se le da click al boton eliminar se valida la parametrización 2526--->
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
</cfif>
<cfif isdefined ('form.butAjuste')>
	<cfquery name="rsSalario" datasource="#session.dsn#">
		select SEliquido from SalarioEmpleado where DEid=#form.DEid#
	</cfquery>
	
	 <cfquery name="rsParametro" datasource="#session.dsn#">
		select Pvalor from RHParametros where Pcodigo=2027 and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif rsParametro.Pvalor eq 0>
		<cfset msg = "No se ha definido el concepto de pago para el ajuste de salario negativo en Parámetros Generales">
		<cf_throw message="#msg#" errorcode="12176">
		<cfabort>
	</cfif>
				
	<cfset CIid = rsParametro.Pvalor>
	
	<cfquery name="rsIncidenciaP" datasource="#session.dsn#">
		select CIid,CIcodigo,CIdescripcion from CIncidentes  where CIid=#CIid#
	</cfquery>
	
	<cfquery name="rsNomina" datasource="#session.dsn#">
		select RCdesde,RChasta from RCalculoNomina where RCNid=#form.RCNid#
	</cfquery>
	
	<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
		insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIid#">, 
			null, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsNomina.RCdesde)#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsSalario.SEliquido#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
			null
			)
	</cfquery>

			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Form.RCNid#"
				Tcodigo = "#Form.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#"
				pDEid = "#Form.DEid#" />
				
	<!---Para sacar la fecha de la siguiente incidencia--->
	<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
		select 
			a.CPcodigo, 
			a.CPid, 
			rtrim(a.Tcodigo) as Tcodigo, 
			a.CPdesde, 
			a.CPhasta,
			case when a.CPtipo = 0 then 'Normal'
				when a.CPtipo = 2 then 'Anticipo' end as TipoCalendario
		from CalendarioPagos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.CPfenvio is null
		and a.CPtipo in (0,2)
		and not exists (
			select 1
			from RCalculoNomina h
			where a.Ecodigo = h.Ecodigo
			and a.Tcodigo = h.Tcodigo
			and a.CPdesde = h.RCdesde
			and a.CPhasta = h.RChasta
			and a.CPid = h.RCNid
		)
		and not exists (
			select 1
			from HERNomina i
			where a.Tcodigo = i.Tcodigo
			and a.Ecodigo = i.Ecodigo
			and a.CPdesde = i.HERNfinicio
			and a.CPhasta = i.HERNffin
			and a.CPid = i.RCNid
		)
		and Tcodigo='#form.Tcodigo#'
		order by CPhasta
	</cfquery>
	<cfquery name="MinFechasNomina" dbtype="query">
		select Tcodigo, min(CPdesde) as CPdesde
		from PaySchedAfterRestrict
		group by Tcodigo
	</cfquery>
		<cfquery name="rsCalendarios" dbtype="query">
		select *
		from PaySchedAfterRestrict
		where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
		and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPdesde#">
		order by CPdesde
	</cfquery>
	<cfset Ivalor=rsSalario.SEliquido*-1>
	<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
		insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIid#">, 
			null, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(rsCalendarios.CPdesde)#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Ivalor#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
			null
			)
	</cfquery>

</cfif>

<cfsetting requesttimeout="3600">
<cfset Acciones = ''>
<cfif isDefined("Form.chk") or isDefined("Form.butRecalcular") or isDefined("Form.butRestaurar")>
<cftry>
	<cfif isDefined("Form.butRestaurar")>
		<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Tcodigo = "#Form.Tcodigo#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#"
			pDEid = "#Form.DEid#" />
		<cfset Acciones = "Restaurar">
	<cfelseif isDefined("Form.chk")>
		
		<cfset vchk = ListToArray(Form.chk)>
			<!--- CUANDO ES UNA NOMINA DE ANTICIPO, SE TIENE QUE ELIMINAR LA INCIDENCIA DE PAGO DE ANTICIPO
				PARA QUE LA VUELVA A GENERAR --->
			<!--- TRAE EL CONCEPTO DE PAGO DEFINIDO PARA ANTICIPO DE SALARIO --->
            <cfquery name="rsCalendario" datasource="#session.DSN#">
            	select CPtipo, CPdesde, CPhasta from CalendarioPagos where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            </cfquery>
            <cfif rsCalendario.CPtipo EQ 2>
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" Ecodigo="#Session.Ecodigo#" Pvalor="730" default="" returnvariable="CIidAnticipo"/>
                <cfif Not Len(CIidAnticipo)>
                    <cf_throw message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!" errorCode="1145">
                </cfif>
                <cfquery name="deleteAnticipo" datasource="#session.DSN#">
                    delete from IncidenciasCalculo
                    where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                </cfquery>	
            </cfif>
			<!--- CarolRS borrado de deducciones, antes del recalculo--->
			<!---<cfquery name="rs_Deducc" datasource="#Session.DSN#">	
				select distinct Did from DeduccionesCalculo 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			</cfquery>--->
			<cfif not isdefined('form.baja')>
				<cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
					delete from DeduccionesCalculo 
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					<cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
				</cfquery>
			</cfif>
			<cfquery datasource="#Session.DSN#">	
				delete from DeduccionesEmpleado 
				where Dfechaini between 
				  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPhasta#">
				  and CIid is not null
				  <cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
				  and (select count(1) 
				  	from HDeduccionesCalculo hdc 
					where hdc.Did = DeduccionesEmpleado.Did) = 0
			</cfquery>
			<!--- FIN DE ELIMINACION DE INCIDENCIA DE PAGO DE ANTICIPO --->
			<cfquery datasource="#Session.DSN#" name="rsSubsidio">
				select  Pvalor as TDid
				from RHParametros 
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2033"> 
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset eliminaSubsidio = 0>
			<cfquery name="sub" datasource="#Session.DSN#">
				select CIid from IncidenciasCalculo
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSubsidio.TDid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
			
			<cfif sub.RecordCount eq 0>				
				<cfset eliminaSubsidio = 1>	
			</cfif>

			<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
				<cfset dato = ListToArray(vchk[i],'|')>
				
				<cfif dato[1] eq 'I'>

					<cfquery name="sub" datasource="#Session.DSN#">
						select CIid from IncidenciasCalculo
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					</cfquery>
					
					<cfif sub.RecordCount gt 0 and sub.CIid eq rsSubsidio.TDid>
						<cfset eliminaSubsidio = 1>					
					</cfif>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from IncidenciasCalculo
					where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					</cfquery>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
						update CargasCalculo
						set
							CCvaloremp = 0,
							CCvalorpat = 0
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					</cfquery>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfset Acciones = Acciones & 'Elimna Incidencia:' & dato[2] & ', '>
				<cfelseif dato[1] eq 'C'>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					delete from CargasCalculo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
					update SalarioEmpleado set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
					</cfquery>
					<cfset Acciones = Acciones & 'Elimna Carga:' & dato[2] & ', '>
				<cfelseif dato[1] eq 'D'>
			
					<cfquery name="rsDeduccion" datasource="#session.DSN#">
						select t.TDley from DeduccionesCalculo a
							inner join DeduccionesEmpleado  b
									inner join TDeduccion t
									on t.TDid=b.TDid
								on a.DEid=b.DEid
								and a.Did=b.Did
						where a.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						and a.Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
						and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
					</cfquery>
					<cfif rsDeduccion.TDley gt 0>
						<cfthrow message="No se puede eliminar una deducción de ley">
					<cfelse>
						<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
                            delete from DeduccionesCalculo
                                where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#">
                                    and RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
                                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						</cfquery>
                        
                       <!--- SML. Eliminar la deduccion de FOA cuando se elimina directamente en el calculo de nomina--->
                       <cfquery name="rsDeleteFOA" datasource="#session.DSN#">
                       		delete from RHFondoAhorro
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
								and TDid in (select TDid 
			 								 from DeduccionesEmpleado 
			 								  where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[2]#"> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)
                       </cfquery>
					   <cfquery name="ABC_Resultado" datasource="#Session.DSN#">
							update CargasCalculo
							set
								CCvaloremp = 0,
								CCvalorpat = 0
							where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						</cfquery>
                        
						<cfquery name="ABC_Resultado" datasource="#Session.DSN#">
                            update SalarioEmpleado set SEcalculado = 0
                            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                          	  and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						</cfquery>
						<cfset Acciones = Acciones & 'Elimna Deduccion:' & dato[2] & ', '>
					</cfif>
				</cfif>
			</cfloop>
            
		<!---ljimenez sacamos las incidencias de subsidio al salario que vamos a ulizar para el eliminado de la deduccion ya que 
		el proceso de renta la recalcula nuevamente y asi no se duplica--->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="2033" default="0" returnvariable="vCIsubc"/>
		
			<!---		<cfquery datasource="#Session.DSN#" name="rsCalendario">
			select CPdesde,CPhasta,CPcodigo
			from CalendarioPagos
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		</cfquery>--->
        
        
        <cfquery datasource="#Session.DSN#" name="rsCalendario">
        select a.CPcodigo,a.CPnorenta, a.CPnocargas, a.CPnocargasley, a.CPperiodo, a.CPmes, a.CPtipo, a.CPnodeducciones, b.RCpagoentractos, b.RCporcentaje, b.RChasta, b.RCdesde, a.Tcodigo,c.Ttipopago as frecuencia, c.FactorDiasSalario,  c.FactorDiasIMSS, c.IRcodigo
            from CalendarioPagos a
                inner join RCalculoNomina b
                    on b.RCNid = a.CPid
                inner join TiposNomina c
                    on c.Ecodigo = a.Ecodigo
                   and c.Tcodigo = a.Tcodigo
        where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		</cfquery>
              
        <cfquery name="rs_Deducc" datasource="#Session.DSN#">	
			delete from DeduccionesCalculo 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            and Did = (select Did from DeduccionesEmpleado 
            				where ltrim(rtrim(Dreferencia)) = '#trim(rsCalendario.CPcodigo)#-#trim(Form.RCNid)#'
							<!---'#trim(rsCalendario.CPcodigo)#'--->
								and TDid = #vCIsubc#
								<cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>)
		</cfquery>
		
		<cfquery datasource="#Session.DSN#">
			delete from DeduccionesEmpleado
				where ltrim(rtrim(Dreferencia)) = '#trim(rsCalendario.CPcodigo)#-#trim(Form.RCNid)#'
               <!--- --'#trim(rsCalendario.CPcodigo)#'--->
				and TDid = #vCIsubc#
				<cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
		</cfquery>

		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#"
			pDEid = "#form.DEid#" 
            IRcodigo = "#rsCalendario.IRcodigo#"/>
		
		
		<!--- Eliminamos subsidios duplicamos y calculamos montos --->
		<cfquery datasource="#Session.DSN#">
			delete from IncidenciasCalculo 
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSubsidio.TDid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
			<cfif !eliminaSubsidio>
				and ICid not in (select top 1 ICid from IncidenciasCalculo
							where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSubsidio.TDid#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">)
			</cfif>
		</cfquery>

		<cfquery datasource="#Session.DSN#">
        	update SalarioEmpleado 
			set SEincidencias = (select sum(coalesce(ICvalor,0)) from IncidenciasCalculo
								where  DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
								and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
								)
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
        </cfquery>

		<cfquery datasource="#session.DSN#" name="rsIncidencias">
            SELECT SUM(ICmontores) AS ICmontores
            FROM IncidenciasCalculo
            WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
            AND RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
        </cfquery>

        <cfquery datasource="#session.DSN#" name="rsUpdateSalario">
            UPDATE SalarioEmpleado
            SET SEincidencias = #rsIncidencias.ICmontores#,
				SEliquido = round(SEsalariobruto + (#rsIncidencias.ICmontores#) - SErenta - SEcargasempleado - SEdeducciones,2)
            WHERE RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
            AND DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
        </cfquery>

		<cfset montoIncExcl = 0>
		<cfquery name="rsIncExcl" datasource="#session.dsn#">
			Select
				sum(ICmontores) as sumICmontores,
				sum(ICvalor) as sumICvalor,
				DEid
			from
				IncidenciasCalculo ic
			inner join Cincidentes ci on ic.CIid = ci.CIid
			where
				ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			and ci.CItimbrar = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
			group by DEid
		</cfquery>
		<cfif rsIncExcl.RecordCount gt 0>
			<!--- OPARRALES 2018-08-22 Se actualiza SEliquido por empleado de acuerdo a la configuracion de sus componentes
				- (cuando tiene un componente con pagos en efectivo, se excluye dicho monto en SEliquido)
			--->
			<cfloop query="rsIncExcl">
				<cfset montoIncExcl = LSNumberFormat(rsIncExcl.sumICmontores,'9.00')>
				<cfquery datasource="#session.dsn#">
					update SalarioEmpleado
						set SEliquido = round(SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones - #montoIncExcl#,2)
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
					and SEcalculado = 0
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncExcl.DEid#">
				</cfquery>

			</cfloop>
		</cfif>
		<!---  --->

		<cfset Acciones = Acciones & 'Recalcular.'>
	<cfelseif isDefined("Form.butRecalcular")>
		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
			datasource="#session.dsn#"
			Ecodigo = "#Session.Ecodigo#"
			RCNid = "#Form.RCNid#"
			Usucodigo = "#Session.Usucodigo#"
			Ulocalizacion = "#Session.Ulocalizacion#" 
            IRcodigo = "#rsCalendario.IRcodigo#"/>
		<cfset Acciones = Acciones & 'Recalcular.'>
	</cfif>
<cfcatch type="any">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
</cfif>

<form action="ResultadoCalculo.cfm" method="post" name="sql">
	<cfoutput>
		<input name="RCNid" type="hidden" value="#Form.RCNid#">
		<input name="DEid" type="hidden" value="#Form.DEid#">
		<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>


<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>

<!---
<cfoutput>#Acciones#</cfoutput>
<cfdump var="#Form#">
<a href="javascript:document.forms[0].submit();">Continuar</a>
--->
</body>
</HTML>
