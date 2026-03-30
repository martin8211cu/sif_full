<!--- <cf_dump var="#form#"> --->
<cfif isdefined("Form.btnAgregar")>
    <!--- (1) verifica si la accion toca la línea del tiempo y si el comportamiento es : CESE,VACACIONES,CAMBIO,INCAPACIDAD O CAMBIO DE EMPRESA --->
    <cfquery name="valida_accion" datasource="#Session.DSN#">
    	select RHTid from RHTipoAccion
        where RHTcomportam 		in (2,3,4,5,6,7,9)
        and RHTnoretroactiva 	= 0
        and RHTid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
        and Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    <!--- (2) Si el query retorna datos muestra la pantalla con acciones que va afectar esta nueva acción --->
    <!--- <cf_dump var="#form#"><br> --->
    
	<cfif isdefined("valida_accion") and valida_accion.recordCount GT 0>
            <cfquery name="RSaccion" datasource="#Session.DSN#">
				select distinct 
                a.LTid,
                b.RHTdesc,
                a.LTdesde,
                a.LThasta,
                a.LTsalario,
				cf.CFcodigo,
				cf.CFdescripcion,
				coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo,
				p.RHPdescpuesto,
                dl.DLlinea,
                b.RHTcomportam,
				dl.RHfolio,
				dl.RHporcimss
                from LineaTiempo a
                inner join DLaboralesEmpleado dl
					on a.RHTid = dl.RHTid
					and a.DEid = dl.DEid
					and a.Ecodigo = dl.Ecodigo 	
					and ( dl.DLfvigencia >= a.LTdesde   or a.LTdesde  between  dl.DLfvigencia and dl.DLffin )
                inner join RHTipoAccion b
                    on a.Ecodigo = b.Ecodigo
                    and a.RHTid = b.RHTid
				inner join RHPlazas pl
                    on a.Ecodigo = pl.Ecodigo
                    and a.RHPid = pl.RHPid
				inner join CFuncional cf
                    on pl.Ecodigo = cf.Ecodigo
                    and pl.CFid = cf.CFid
				inner join RHPuestos p
					on pl.Ecodigo = p.Ecodigo
                    and p.RHPcodigo = pl.RHPpuesto
                where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">    
				and (a.LTdesde	>= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#">
                <cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
					and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#"> 
				</cfif>)

                union
                
				select  distinct
                a.LTid,
                b.RHTdesc,
                a.LTdesde,
                a.LThasta,
                a.LTsalario,
				cf.CFcodigo,
				cf.CFdescripcion,
				coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo,
				p.RHPdescpuesto ,
                dl.DLlinea,
                b.RHTcomportam,
				dl.RHfolio,
				dl.RHporcimss
                from LineaTiempo a
                inner join DLaboralesEmpleado dl
					on a.RHTid = dl.RHTid
					and a.DEid = dl.DEid
					and a.Ecodigo = dl.Ecodigo 	
					and ( dl.DLfvigencia >= a.LTdesde   or a.LTdesde  between  dl.DLfvigencia and dl.DLffin )
                inner join RHTipoAccion b
                    on a.Ecodigo = b.Ecodigo
                    and a.RHTid = b.RHTid
				inner join RHPlazas pl
                    on a.Ecodigo = pl.Ecodigo
                    and a.RHPid = pl.RHPid
				inner join CFuncional cf
                    on pl.Ecodigo = cf.Ecodigo
                    and pl.CFid = cf.CFid
				inner join RHPuestos p
					on pl.Ecodigo = p.Ecodigo
                    and p.RHPcodigo = pl.RHPpuesto

                where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">    

				and (a.LThasta	>= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#">
                <cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
					and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#"> 
				</cfif>)
                
                order by LTdesde 
			</cfquery> 
			
						
            <cfif RSaccion.recordCount GT 0>
				<cfinclude template="Acciones-prev.cfm">
                <cfabort>
			</cfif>
	</cfif>
</cfif>
<cfinclude template="/rh/admin/catalogos/Calculo.cfm">
<cfif Session.Params.ModoDespliegue EQ 1>
	<cfif isdefined("Form.o") and isdefined("Form.sel")>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
	<cfelse>
		<cfset action = "/cfmx/rh/nomina/operacion/Acciones.cfm">
	</cfif>
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<!--- SI ESTOY EN AUTOGESTION VERIFICA SI ES JEFE Y ENVIA LOS DATOS PARA LA OPCION DE TRAMITES PARA SIN --->
	<cfif isdefined("form.Jefe")>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm?o=3&Jefe=#form.Jefe#&CentroF=#form.CentroF#">		
	<cfelse>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
	</cfif>
</cfif>


<!-----================== TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_empleado_todavia_no_ha_sido_nombrado"
	Default="El empleado todavia no ha sido nombrado."	
	returnvariable="MSG_El_empleado_todavia_no_ha_sido_nombrado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_fechaDelPrimerNombramientosSeEncuentraEnNulo"
	Default="La fecha del primer nombramientos se encuentra en nulo"	
	returnvariable="MSG_La_fechaDelPrimerNombramientosSeEncuentraEnNulo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_FechaDigitadaNoEsValidaPorQueEsMenorAlPrimerNombramiento"
	Default="La fecha de antigüedad no es valida por que es menor al primer nombramiento "	
	returnvariable="MSG_La_FechaDigitadaNoEsValidaPorQueEsMenorAlPrimerNombramiento"/>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_FechaDeAntiguedadNoPuedeSerMayorALaFechaDeHoy"
	Default="La fecha de antigüedad no puede ser mayor a hoy"	
	returnvariable="MSG_La_FechaDeAntiguedadNoPuedeSerMayorALaFechaDeHoy"/>

	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_accion_no_se_puede_aplicar_Por_favor_verifique_los_parametros_de_configuracion_para_Estructura_Salarial"
	Default="La acci&oacute;n no se puede aplicar. Por favor verifique los par&aacute;metros de configuraci&oacute;n para Estructura Salarial."	
	returnvariable="MSG_NoPuedeAplicarAccion"/>

<cfif not isdefined("Form.Nuevo") or not isdefined("Form.btnregresar") >

	<cfquery name="rsConsTipoAccion" datasource="#Session.DSN#">
		select RHTcomportam, RHTcempresa, RHTnoveriplaza, RHTpfijo, coalesce(RHTsubcomportam,0) as RHTsubcomportam
		from RHTipoAccion
		where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
	</cfquery>

	<cfif isdefined("Form.btnAgregar") or isdefined("Form.btnAceptar")>
        <cfquery name="rsConsLT" datasource="#Session.DSN#">
			select count(1) as cantidad
			from LineaTiempo
			where DEid = 
				<cfif isdefined('form.DEidSub')>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEidSub#"> 
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
				</cfif>
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#"> between LTdesde and LThasta
		</cfquery>
		<cfif rsConsLT.cantidad EQ 0 AND rsConsTipoAccion.RHTcomportam NEQ 1>			
			<cf_throw message="#MSG_El_empleado_todavia_no_ha_sido_nombrado#" errorCode="1100">
			<cfabort>
		</cfif>
	</cfif>

	<cfif isdefined("Form.btnAgregar") or isdefined("Form.btnAceptar")>
		<cftransaction>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				insert into RHAcciones (Ecodigo, DEid, RHTid, DLfvigencia, DLffin, DLobs, Usucodigo, Ulocalizacion, EcodigoRef,RHAporcsal,
										RHItiporiesgo, RHIconsecuencia, RHIcontrolincapacidad, RHfolio, RHporcimss)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfif isdefined('form.DEidSub')>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEidSub#"> 
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#">, 
					<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#">, 
					<cfelse>
					null,
					</cfif>
					<cfif Len(Trim(Form.DLobs)) NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DLobs#">,
					<cfelse>
					null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EcodigoRef#">
					<cfelse>
						null
					</cfif>
					,-1,
					<cfif rsConsTipoAccion.RHTcomportam EQ 5 and rsConsTipoAccion.RHTsubcomportam GT 0 
						and isdefined("Form.TipoRiesgo") and Len(Trim(Form.TipoRiesgo))
						and isdefined("Form.Consecuencia") and Len(Trim(Form.Consecuencia))
						and isdefined("Form.ControlIncapacidad") and Len(Trim(Form.ControlIncapacidad))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TipoRiesgo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Consecuencia#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ControlIncapacidad#">
					<cfelse>
						null,null,null
					</cfif>
					<cfif rsConsTipoAccion.RHTcomportam EQ 5 and rsConsTipoAccion.RHTsubcomportam GT 0 
						and isdefined("Form.Folio") and Len(Trim(Form.Folio))
						and isdefined("Form.PorcImss") and Len(Trim(Form.PorcImss))>
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Folio#">
						,<cfqueryparam cfsqltype="cf_sql_float" value="#Form.PorcImss#">
					<cfelse>
						,null,null
					</cfif>
					
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_RHAcciones">
			<cfset modo="CAMBIO">
		</cftransaction>
		
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHConceptosAccion 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			</cfquery>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHDAcciones
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			</cfquery>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHAcciones
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			</cfquery>
		</cftransaction>
		<cfif not (isdefined("Form.o") and isdefined("Form.sel"))>
			<cfset action = "/cfmx/rh/nomina/operacion/Acciones-lista.cfm">
		</cfif>
		
		<cfif Session.Params.ModoDespliegue EQ 0>
			<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
		</cfif>
		<cfif isdefined('form.DEidSub')>
		<cfset form.DEidSub = 0>
		</cfif>
		<cfset modo="ALTA">
		
	<cfelseif isdefined("form.RHDAlinea_del") and Len(Trim(form.RHDAlinea_del))>
		<cftransaction>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHDAcciones
				where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea_del#">
			</cfquery>
		
			<!--- Recalcular todos los componentes --->
			<cfquery name="rsComp" datasource="#Session.DSN#">
				select a.RHDAlinea, a.CSid, a.RHDAunidad, a.RHDAmontobase, a.RHDAmontores,
					   c.DLfvigencia, coalesce(c.RHCPlinea, 0) as RHCPlinea, c.Indicador_de_Negociado as negociado
				from RHDAcciones a
					inner join ComponentesSalariales b
						on b.CSid = a.CSid
					inner join RHAcciones c
						on c.RHAlinea = a.RHAlinea
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				order by b.CSorden, b.CScodigo, b.CSdescripcion
			</cfquery>
			
			<cfloop query="rsComp">
				<cfinvoke 
				 component="rh.Componentes.RH_EstructuraSalarial"
				 method="calculaComponente"
				 returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
					<cfinvokeargument name="fecha" value="#rsComp.DLfvigencia#"/>
					<cfinvokeargument name="RHCPlinea" value="#rsComp.RHCPlinea#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#rsComp.negociado EQ 1#"/>
					<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
						<cfinvokeargument name="Ecodigo" value="#Form.EcodigoRef#"/>
					</cfif>
					<cfinvokeargument name="Unidades" value="#rsComp.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsComp.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsComp.RHDAmontores#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#Form.RHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
				</cfinvoke>
		
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					update RHDAcciones
					   set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
						   RHDAmontobase = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.MontoBase#">,
						   RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">
					 where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.RHDAlinea#">
				</cfquery>
			</cfloop>
		</cftransaction>
	
	<cfelseif isdefined("Form.Cambio") or isdefined("Form.btnAplicar")>
		<!---Averiguar si el empleado esta nombrado, si de alguna forma fue cesado,eje. por carga --->
		<cfquery name="rsConsLT" datasource="#Session.DSN#">
			select count(1) as cantidad
			from RHAcciones, LineaTiempo
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			and RHAcciones.DEid = LineaTiempo.DEid
			and DLfvigencia between LTdesde and LThasta
		</cfquery>
		<cfif rsConsLT.cantidad EQ 0 AND rsConsTipoAccion.RHTcomportam NEQ 1>			
			<cf_throw message="#MSG_El_empleado_todavia_no_ha_sido_nombrado#" errorCode="1100">

			<cfabort>
		</cfif>
		
		<cf_dbtimestamp datasource="#session.DSN#"
			table="RHAcciones"
			redirect="Acciones.cfm"
			timestamp="#lcase(Form.ts_rversion)#"
			field1="RHAlinea" 
			type1="numeric" 
			value1="#Form.RHAlinea#"
		 >
		
		<cfif isdefined("Form.RHTespecial") and Form.RHTespecial eq 0 >
		<!--- ********************************************************************************** --->
		<!--- aqui se incluye el proceso que se debe realizar para acciones de personal NORMALES --->
		<!--- ********************************************************************************** --->

			<!--- Averiguar si hay que utilizar la tabla salarial --->
			<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
				select CSusatabla
				from ComponentesSalariales
				<!--- Cambio de Empresa --->
				<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EcodigoRef#">
				<cfelse>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfif>
				and CSsalariobase = 1
			</cfquery>
			<cfif rsTipoTabla.recordCount GT 0>
				<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
			<cfelse>
				<cfset usaEstructuraSalarial = 0>
			</cfif>
	
			<!--- Averiguar si el salario de la plaza es negociado --->
			<cfquery name="rsNegociado" datasource="#Session.DSN#">
				select a.RHMPnegociado
				from RHLineaTiempoPlaza a
				where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#"> between a.RHLTPfdesde and a.RHLTPfhasta
			</cfquery>
			
			<cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>

			<cftransaction>
				<!--- Categoria de Puesto --->
				<cfif isdefined('Form.RHTTid') and Len(Trim(Form.RHTTid)) NEQ 0 and isdefined('Form.RHCid') and Len(Trim(Form.RHCid)) NEQ 0 and isdefined('Form.RHMPPid') and Len(Trim(Form.RHMPPid)) NEQ 0>
					<cfquery name="rsCatPaso" datasource="#Session.DSN#">
						select RHCPlinea
						from RHCategoriasPuesto
						where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
						and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid#">
						and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid#">
						<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EcodigoRef#">
						<cfelse>
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						</cfif>
					</cfquery>
					<cfif Len(Trim(rsCatPaso.RHCPlinea))>
						<cfset Form.RHCPlinea = rsCatPaso.RHCPlinea>
					</cfif>
				</cfif>			
			
				<!--- Las acciones que no son de plazo fijo --->
				<cfif rsConsTipoAccion.RHTcomportam eq 6 and rsConsTipoAccion.RHTpfijo eq 0 >
					<cfquery name="rsaccion_fecha" datasource="#session.DSN#"	>
						select max(LThasta) as LThasta
						from LineaTiempo
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					</cfquery>
				</cfif>
			
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					update RHAcciones set
						<!--- Cambio de Empresa --->
						<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1>
						   Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigoant#">
						<cfelse>
						   Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">
						</cfif>
						 , RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
						 , Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
						 , Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
						 , RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">
						 , RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
						 , RHAporc = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.LTporcplaza#">
						 , RHAporcsal = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.LTporcsal#">
						 , RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
						<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
						, DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#">
						<cfelseif isdefined("rsConsTipoAccion") and rsConsTipoAccion.RHTcomportam eq 6 and rsConsTipoAccion.RHTpfijo eq 0 >
						, DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsaccion_fecha.LThasta#">
						<cfelse>
						, DLffin =  null
						</cfif>
						<cfif Len(Trim(Form.DLobs)) NEQ 0>
						, DLobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DLobs#">
						<cfelse>
						, DLobs =  null
						</cfif>
						<cfif isdefined('Form.RHAvdisf') and Len(Trim(Form.RHAvdisf)) NEQ 0>
						, RHAvdisf = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAvdisf#">
						<cfelse>
						, RHAvdisf =  null
						</cfif>
						<cfif isdefined('Form.RHAvcomp') and Len(Trim(Form.RHAvcomp)) NEQ 0>
						, RHAvcomp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAvcomp#">
						<cfelse>
						, RHAvcomp =  null
						</cfif>
						<!--- Categoría Puesto --->
						<cfif isdefined('Form.RHCPlinea') and Len(Trim(Form.RHCPlinea)) NEQ 0>
						, RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">
						<cfelse>
						, RHCPlinea =  null
						</cfif>
						<!--- Cambio de Empresa --->
						<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1>
						, TcodigoRef = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">
						<cfelse>
						, TcodigoRef = null
						</cfif>
						<!--- Neogciado --->
						<cfif LvarNegociado>
						, Indicador_de_Negociado = 1
						<cfelse>
						, Indicador_de_Negociado = 0
						</cfif>
						
						<cfif isdefined("form.RHAdiasenfermedad") and len(trim(form.RHAdiasenfermedad))>
							, RHAdiasenfermedad = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHAdiasenfermedad, ',','','all')#">
						<cfelse>
							, RHAdiasenfermedad = null
						</cfif>
						
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				
				<!---============================================================================================= 
				VALIDAR SI SE MODIFICÓ SOLAMENTE LO QUE SE INDICA EN EL TIPO DE ACCION
				=============================================================================================---->			
				<cfif isdefined("Form.btnAplicar")>
					<cfinclude template="/rh/nomina/operacion/Acciones-VerificaTipoAccion.cfm">
				</cfif>			
											
				<cfif isdefined("Form.cantComp") and Form.cantComp GT 0>
					<cfloop from="1" to="#Form.cantComp#" index="i">
						<cf_dbtimestamp datasource="#session.DSN#"
							table="RHDAcciones"
							redirect="Acciones.cfm" 
							timestamp="#lcase(Evaluate('Form.tsCmp_' & i))#"
							field1="RHDAlinea" 
							type1="numeric" 
							value1="#Evaluate('Form.RHDAlinea_'&i)#"   
						>
						
						<cfset unidades = Evaluate('Form.RHDAunidad_'&i)>
						<cfset montobase = Evaluate('Form.RHDAmontobase_'&i)>
						<cfset monto = Evaluate('Form.RHDAmontores_'&i)>
	
						<cfquery name="rsAccion" datasource="#Session.DSN#">
							select b.DLfvigencia, b.DLffin, coalesce(b.RHCPlinea, 0) as RHCPlinea, a.CSid
							from RHDAcciones a, RHAcciones b
							where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&i)#">
							and a.RHAlinea = b.RHAlinea
						</cfquery>
						
						<cfinvoke 
						 component="rh.Componentes.RH_EstructuraSalarial"
						 method="calculaComponente"
						 returnvariable="calculaComponenteRet">
							<cfinvokeargument name="CSid" value="#rsAccion.CSid#"/>
							<cfinvokeargument name="fecha" value="#rsAccion.DLfvigencia#"/>
							<cfif Len(Trim(rsAccion.RHCPlinea))>
								<cfinvokeargument name="RHCPlinea" value="#rsAccion.RHCPlinea#"/>
							</cfif>
							<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
							<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
							<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
								<cfinvokeargument name="Ecodigo" value="#Form.EcodigoRef#"/>
							</cfif>
							<cfinvokeargument name="Unidades" value="#Evaluate('Form.RHDAunidad_'&i)#"/>
							<cfinvokeargument name="MontoBase" value="#Evaluate('Form.RHDAmontobase_'&i)#"/>
							<cfinvokeargument name="Monto" value="#Evaluate('Form.RHDAmontores_'&i)#"/>
							<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
							<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
							<cfinvokeargument name="ValorLlaveTC" value="#Form.RHAlinea#"/>
							<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
						</cfinvoke>
						
						<cfset unidades = calculaComponenteRet.Unidades>
						<cfset montobase = calculaComponenteRet.MontoBase>
						<cfset monto = calculaComponenteRet.Monto>
						
						<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
							<cf_throw message="#MSG_NoPuedeAplicarAccion#">
						</cfif>
	
						<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
							update RHDAcciones
							   set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
								   RHDAmontobase = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montobase, ',','','all')#">,
								   RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">
							 where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&i)#">
						</cfquery>
					</cfloop>
				</cfif>
					
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete RHConceptosAccion 
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				
				<!--- Procesamiento de los Conceptos de Pago --->
				<cfquery name="rsConceptos" datasource="#Session.DSN#">
					select a.DLfvigencia, 
						   a.DLffin, 
						   a.DEid, 
						   <cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
						   a.EcodigoRef as Ecodigo, 
						   <cfelse>
						   a.Ecodigo, 
						   </cfif>
						   a.RHTid, 
						   a.RHAlinea, 
						   coalesce(a.RHJid, 0) as RHJid, 
						   c.CIid, 
						   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes, c.CIsprango,coalesce(c.CIspcantidad,0) as CIspcantidad
					from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
					and a.RHTid = b.RHTid
					and b.CIid = c.CIid
				</cfquery>
				
				<cfloop query="rsConceptos">
					<cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
					
					<cfif Len(Trim(rsConceptos.DLffin))>
						<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
					<cfelse>
						<cfset FFin = '01/01/6100'>
					</cfif>
					
					
					
					<cfscript>
						current_formulas = rsConceptos.CIcalculo;
						presets_text = get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
												   rsConceptos.CIcantidad,
												   rsConceptos.CIrango,
												   rsConceptos.CItipo,
												   rsConceptos.DEid,
												   rsConceptos.RHJid,
												   rsConceptos.Ecodigo,
												   rsConceptos.RHTid,
												   rsConceptos.RHAlinea,
												   rsConceptos.CIdia,
												   rsConceptos.CImes,
												   "", // Tcodigo solo se requiere si no va RHAlinea
												   FindNoCase('SalarioPromedio', current_formulas), // optimizacion - SalarioPromedio es el calculo más pesado
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas) // optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado
												   , 0
												   , '' 
												   ,rsConceptos.CIsprango
												   ,rsConceptos.CIspcantidad);
						values = calculate ( presets_text & ";" & current_formulas );
					</cfscript>
							
					<cfif Not IsDefined("values")>
						<cfif isdefined("presets_text")>
							<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
						<cfelse>
							<cf_throw message="#calc_error#" >
						</cfif>
					</cfif>
					<!---
					<br>Importe><cfdump var="#values.get('importe').toString()#"></br>
					<br>Resultado<cfdump var="#values.get('resultado').toString()#"></br>
					<br>Cantidad<cfdump var="#values.get('cantidad').toString()#"></br>
					<br>fecha><cfdump var="#FVigencia - x#"></br>
					--->
					
					 
					<cfquery name="updConceptos" datasource="#Session.DSN#">
						insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
						)
					</cfquery> 
				</cfloop>
				
				<cfset modo="CAMBIO">
			</cftransaction>
		<cfelseif isdefined("Form.RHTespecial") and Form.RHTespecial eq 1 >
			<!--- ************************************************************************************ --->
			<!--- aqui se incluye el proceso que se debe realizar para acciones de personal ESPECIALES --->
			<!--- ************************************************************************************ --->
			<cftransaction>
				<cfif rsConsTipoAccion.RHTcomportam EQ 11>
					<!--- Valida la fecha antes de hacer el update --->
					
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select NTIcodigo, DEidentificacion 
						from RHAcciones a 
						inner join DatosEmpleado  b
							on a.DEid = b.DEid
						where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
					</cfquery>
					
					<!--- 
						select min(DLfvigencia) as MinFecha
						from DLaboralesEmpleado de, RHTipoAccion ta
						where de.DEid = #rsEmpleado.DEid#
						and de.RHTid = ta.RHTid
						and ta.RHTcomportam = 1 
					--->
					
					<cfquery name="RS_MinFecha" datasource="#Session.DSN#">
						select min(DLfvigencia) as MinFecha
						from DLaboralesEmpleado dl
							inner join RHTipoAccion ta
								on dl.RHTid = ta.RHTid
								and ta.RHTcomportam = 1
							 inner join DatosEmpleado de
								on de.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpleado.NTIcodigo#">
								and de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleado.DEidentificacion#">
								and dl.DEid = de.DEid
					</cfquery>

					<cfif isdefined("RS_MinFecha.MinFecha") and len(trim(RS_MinFecha.MinFecha)) eq 0>
						<cf_throw message="#MSG_La_fechaDelPrimerNombramientosSeEncuentraEnNulo#" >
					</cfif>

					<cfif (DateCompare(LSParseDateTime(form.EVfantig_prop),RS_MinFecha.MinFecha) eq -1 )>
						<cf_throw message="#MSG_La_FechaDigitadaNoEsValidaPorQueEsMenorAlPrimerNombramiento# (#LSDateFormat(RS_MinFecha.MinFecha, 'DD/MM/YYYY')#)">
					<cfelseif   ( DateCompare(LSParseDateTime(form.EVfantig_prop),Now())) gt 0 >
						<cf_throw message="#MSG_La_FechaDeAntiguedadNoPuedeSerMayorALaFechaDeHoy#" > 
					</cfif>
				</cfif>
				
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					update RHAcciones set
						<cfif rsConsTipoAccion.RHTcomportam EQ 10>
						   RHAtipo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAtipo#">,
						   RHAdescripcion 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.RHAdescripcion#">
						<cfelseif rsConsTipoAccion.RHTcomportam EQ 11>
						   EVfantig         = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EVfantig_prop)#">
						</cfif>
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				
				<!---============================================================================================= 
				VALIDAR SI SE MODIFICÓ SOLAMENTE LO QUE SE INDICA EN EL TIPO DE ACCION
				=============================================================================================---->			
		
				<cfset modo="CAMBIO">
			</cftransaction>
		</cfif>
		

		
		
	</cfif>
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif not isdefined("Form.btnAplicar")>
	<cfoutput>

	<form action="#action#" method="post" name="sql">
		<cfif isdefined("form.Jefe")><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
			<input name="Jefe" type="hidden" value="#form.Jefe#">
			<input name="CentroF" type="hidden" value="#form.CentroF#">
			<input name="DEidSub" type="hidden" value="#form.DEidSub#">
		</cfif>
		<cfif isdefined("Form.o") and isdefined("Form.DEid")>
			<input type="hidden" name="o" value="#Form.o#">
			<input type="hidden" name="DEid" value="#Form.DEid#">
		</cfif>
		<cfif isdefined("Form.sel")>
			<input type="hidden" name="sel" value="#Form.sel#">
		</cfif>
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo"> 
		</cfif>	
		<cfif isdefined("Form.RHTid")>
			<input name="RHTid" type="hidden" value="#Form.RHTid#"> 
		</cfif>
		<!--- Variable requerida para refrescar la pantalla cuando se insertan componentes salariales --->
		<cfif isdefined("Form.reloadPage") and Form.reloadPage EQ 1>
			<cfset modo = "CAMBIO">
		</cfif>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("Form.btnAgregar") or isdefined("Form.btnAceptar")>
			<input name="RHAlinea" type="hidden" value="#ABC_RHAcciones.identity#">
		<cfelse>
			<input name="RHAlinea" type="hidden" value="<cfif isdefined("Form.RHAlinea") and not isDefined("Form.Baja")>#Form.RHAlinea#</cfif>">
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</form>
	</cfoutput>
	
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
</cfif>
