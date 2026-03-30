
<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke key="MSG_El_empleado_todavia_no_ha_sido_nombrado" default="El empleado todavia no ha sido nombrado."	 returnvariable="MSG_El_empleado_todavia_no_ha_sido_nombrado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_fechaDelPrimerNombramientosSeEncuentraEnNulo" default="La fecha del primer nombramientos se encuentra en nulo"	 returnvariable="MSG_La_fechaDelPrimerNombramientosSeEncuentraEnNulo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_FechaDigitadaNoEsValidaPorQueEsMenorAlPrimerNombramiento" default="La fecha de antigüedad no es valida por que es menor al primer nombramiento "	 returnvariable="MSG_La_FechaDigitadaNoEsValidaPorQueEsMenorAlPrimerNombramiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_FechaDeAntiguedadNoPuedeSerMayorALaFechaDeHoy" default="La fecha de antigüedad no puede ser mayor a hoy"	 returnvariable="MSG_La_FechaDeAntiguedadNoPuedeSerMayorALaFechaDeHoy" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_accion_no_se_puede_aplicar_Por_favor_verifique_los_parametros_de_configuracion_para_Estructura_Salarial" default="La acci&oacute;n no se puede aplicar. Por favor verifique los par&aacute;metros de configuraci&oacute;n para Estructura Salarial."	 returnvariable="MSG_NoPuedeAplicarAccion" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<cfif isdefined('form.RHTcodigo') and listlen(form.RHTcodigo,'|') GT 4>
	<cfset comportamiento = listGetAt(form.RHTcodigo,4,'|')>
<cfelseif isdefined('form.RHTcomportam') and LEN(TRIM(form.RHTcomportam)) >
	<cfset comportamiento = form.RHTcomportam>
</cfif>


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
			<cfquery name="rsAccion" datasource="#Session.DSN#">
				select distinct 
				a.LTRid,
				b.RHTdesc,
				a.LTdesde,
				a.LThasta,
				a.LTsalario,
				cf.CFcodigo,
				cf.CFdescripcion,
				coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo,
				p.RHPdescpuesto,
				dl.DLlinea,
				b.RHTcomportam
				from LineaTiempoR a
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
				and LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LTidRecargo#">

				union
				
				select  distinct
				a.LTRid,
				b.RHTdesc,
				a.LTdesde,
				a.LThasta,
				a.LTsalario,
				cf.CFcodigo,
				cf.CFdescripcion,
				coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo,
				p.RHPdescpuesto ,
				dl.DLlinea,
				b.RHTcomportam
				from LineaTiempoR a
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
				and LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LTidRecargo#">
				order by LTdesde 
			</cfquery> 
			<cfif RSaccion.recordCount GT 0>
				<cfinclude template="AccionesRecargos-prev.cfm">
				<cfabort>
			</cfif>
	</cfif>
</cfif>
<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
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

<!--- Averiguar si hay que utilizar la tabla salarial --->
<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CSsalariobase = 1
</cfquery>
<cfif rsTipoTabla.recordCount GT 0>
	<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
<cfelse>
	<cfset usaEstructuraSalarial = 0>
</cfif>

	


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
         <cfquery name="rsConsLTR" datasource="#Session.DSN#">
			select count(1) as cantidad
			from LineaTiempoR
			where DEid = 
				<cfif isdefined('form.DEidSub')>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEidSub#"> 
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
				</cfif>
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#"> between LTdesde and LThasta
		</cfquery>
		<cfif rsConsLT.cantidad EQ 0 and rsConsLTR.cantidad EQ 0 AND rsConsTipoAccion.RHTcomportam NEQ 1>			
			<cf_throw message="#MSG_El_empleado_todavia_no_ha_sido_nombrado#" errorCode="1100">
			<cfabort>
		</cfif>
	</cfif>

	<cfif isdefined("Form.btnAgregar") or isdefined("Form.btnAceptar")>
		<cftransaction>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				insert into RHAcciones (Ecodigo, DEid, RHTid, DLfvigencia, DLffin, DLobs, Usucodigo, Ulocalizacion, EcodigoRef,RHAporcsal,
										RHItiporiesgo, RHIconsecuencia, RHIcontrolincapacidad, RHfolio, RHporcimss,BMUsucodigo,BMfecha)
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
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					
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
			<cfif usaEstructuraSalarial EQ 1>
				<!--- Recalcular todos los componentes --->
                <cfquery name="rsComp" datasource="#Session.DSN#">
                    select c.DEid,a.RHDAlinea, a.CSid, a.RHDAunidad, a.RHDAmontobase, a.RHDAmontores,
                           c.DLfvigencia,coalesce(c.DLffin,'61000101') as DLffin, c.RHCPlinea, c.Indicador_de_Negociado as negociado,RHAporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP
                    from RHDAcciones a
                        inner join ComponentesSalariales b
                            on b.CSid = a.CSid
                        inner join RHAcciones c
                            on c.RHAlinea = a.RHAlinea
                    where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
                    order by b.CSorden, b.CScodigo, b.CSdescripcion
                </cfquery>
                 <cfset Lvar_CatAlt = rsComp.RHCPlinea>
                <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
				<cfset Lvar_RHTTid = 0>
                <cfset Lvar_RHMPPid = 0>
                <cfset Lvar_RHCid = 0>
                <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                    <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                        select RHCPlinea
                        from RHPuestos a
                        inner join RHMaestroPuestoP b
                            on b.RHMPPid = a.RHMPPid
                            and b.Ecodigo = a.Ecodigo
                        inner join RHCategoriasPuesto c
                            on c.RHMPPid = b.RHMPPid
                            and c.Ecodigo = b.Ecodigo
                        where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
					<cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                        <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                        <cfset Lvar_RHTTid = 0>
                        <cfset Lvar_RHMPPid = 0>
                        <cfset Lvar_RHCid = 0>
                   <cfelse>
                        <cfset Lvar_CatAlt = 0>
                        <cfset Lvar_RHTTid = form.RHTTid5>
                        <cfset Lvar_RHMPPid = form.RHMPPid5>
                        <cfset Lvar_RHCid = form.RHCid5>
                    </cfif>
                </cfif>
                <cfloop query="rsComp">
                    <cfinvoke 
                     component="rh.Componentes.RH_EstructuraSalarial"
                     method="calculaComponente"
                     returnvariable="calculaComponenteRet">
                        <cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
                        <cfinvokeargument name="fecha" value="#rsComp.DLfvigencia#"/>
                        <cfinvokeargument name="fechah" value="#rsComp.DLffin#"/>
                        <cfinvokeargument name="DEid" value="#rsComp.DEid#"/>
                        <cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
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
                        <cfinvokeargument name="RHTTid" value="#Lvar_RHTTid#">
                        <cfinvokeargument name="RHCid" value="#Lvar_RHCid#">
                        <cfinvokeargument name="RHMPPid" value="#Lvar_RHMPPid#">
                        <cfinvokeargument name="PorcSalario" value="#rsComp.RHAporcsal#"/>
                        <cfinvokeargument name="RHCPlineaP" value="#rsComp.RHCPlineaP#"/>
                    </cfinvoke>
            
                    <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
                        update RHDAcciones
                           set RHDAunidad 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
                               RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.MontoBase#">,
                               RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">,
                               RHDAmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteRet.Metodo#">,
                               BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                               BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                         where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.RHDAlinea#">
                    </cfquery>
                </cfloop>
			</cfif>
		</cftransaction>
	
	<cfelseif isdefined("Form.Cambio") or isdefined("Form.btnAplicar")>

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

				<cfif isdefined('Form.RHTTid3') and Len(Trim(Form.RHTTid3)) NEQ 0 and isdefined('Form.RHCid3') and Len(Trim(Form.RHCid3)) NEQ 0 and isdefined('Form.RHMPPid3') and Len(Trim(Form.RHMPPid3)) NEQ 0>
					<cfquery name="rsCatPaso" datasource="#Session.DSN#">
						select RHCPlinea
						from RHCategoriasPuesto
						where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid3#">
						and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid3#">
						and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid3#">
						<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EcodigoRef#">
						<cfelse>
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						</cfif>
					</cfquery>
					<cfif Len(Trim(rsCatPaso.RHCPlinea))>
						<cfset Form.RHCPlinea = rsCatPaso.RHCPlinea>
					</cfif>
				<!--- Categoria de Puesto Propuesta
				       Averiguo si de acuerdo al tipo de accion esta utiliza una categoria-puesto segundaria--->
					<cfquery name="rsProp" datasource="#session.dsn#">
						select t.RHCatParcial from
						RHAcciones a
						inner join RHTipoAccion t
						on a.RHTid=t.RHTid
						where RHAlinea=#form.RHAlinea#
					</cfquery>
					
					<cfif isdefined('Form.RHTTid4') and Len(Trim(Form.RHTTid4)) NEQ 0 and isdefined('Form.RHCid4') and Len(Trim(Form.RHCid4)) NEQ 0 and isdefined('Form.RHMPPid4') and Len(Trim(Form.RHMPPid4)) NEQ 0>
                        <cfquery name="rsCatPaso" datasource="#Session.DSN#">
                            select RHCPlinea
                            from RHCategoriasPuesto
                            where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid4#">
                            and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid4#">
                            and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid4#">
                            <cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
                            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EcodigoRef#">
                            <cfelse>
                            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            </cfif>
                        </cfquery>
                        <cfif Len(Trim(rsCatPaso.RHCPlinea))>
                            <cfset Form.RHCPlineaP = rsCatPaso.RHCPlinea>
                        <cfelse>
                            <cfthrow message="La relación Categoría-Puesto no existe para la situación propuesta.">
                        </cfif>	
                        <cfquery name="rsCat2" datasource="#session.dsn#">
                            select RHCcodigo from RHCategoria where RHCid=#Form.RHCid4#
                        </cfquery>
                        <cfquery name="rsCat1" datasource="#session.dsn#">
                            select RHCcodigo from RHCategoria where RHCid=#Form.RHCid3#
                        </cfquery>
						<cfif rsCat1.RHCcodigo gt rsCat2.RHCcodigo>
                            <cfthrow message="No se puede aplicar un Art.40 a una categoría menor a la que el colaborador esta nombrado.">
                        </cfif>
                    </cfif>
                </cfif>
				<!--- Las acciones que no son de plazo fijo --->
				<cfif rsConsTipoAccion.RHTcomportam eq 6 and rsConsTipoAccion.RHTpfijo eq 0 >
					<cfquery name="rsaccion_fecha" datasource="#session.DSN#">
						select max(LThasta) as LThasta
						from LineaTiempoR
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						<cfif isdefined('form.LTidRecargo') and form.LTidRecargo GT 0>
                        and LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LTidRecargo#">
                        </cfif>
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
						<!--- Categoría Puesto Propuesta--->
						<cfif isdefined('Form.RHCPlineaP') and Len(Trim(Form.RHCPlineaP)) NEQ 0>
						, RHCPlineaP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPlineaP#">
						<cfelse>
						, RHCPlineaP =  null
						</cfif>
						<!--- Puesto Alterno--->
						<cfif isdefined('RHPcodigoAlt') and Len(Trim(RHPcodigoAlt)) NEQ 0>
						, RHPcodigoAlt = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigoAlt#">
						<cfelse>
						, RHPcodigoAlt =  null
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
                        <!--- Tipo de aplicacion, solo componentes o todo --->
                        ,RHTipoAplicacion = <cfif isdefined('form.chkTipoAplicacion')>1<cfelse>0</cfif>
						,BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						 BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				
				<!---============================================================================================= 
				VALIDAR SI SE MODIFICÓ SOLAMENTE LO QUE SE INDICA EN EL TIPO DE ACCION
				=============================================================================================---->			
				<cfif isdefined("Form.btnAplicar")>
					<cfinclude template="/rh/nomina/operacion/AccionesRecargos-VerificaTipoAccion.cfm">
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
						<cfset metodo = 'M'>
						<cfif usaEstructuraSalarial EQ 1 >
                            <cfset Lvar_RHTTid = 0>
                            <cfset Lvar_RHMPPid = 0>
                            <cfset Lvar_RHCid = 0>
							<cfquery name="rsAccionES" datasource="#Session.DSN#">
								select b.DEid,b.DLfvigencia, coalesce(b.DLffin,'61000101') as DLffin, b.RHCPlinea as RHCPlinea, a.CSid,a.RHDAmetodoC,RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP
								from RHDAcciones a, RHAcciones b
								where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHDAlinea_'&i)#">
								and a.RHAlinea = b.RHAlinea
							</cfquery>
                            <cfset Lvar_CatAlt = rsAccionES.RHCPlinea>
                            <cfif isdefined('form.RHTTid3') and Len(Trim(form.RHTTid3)) and form.RHTTid3 GT 0>
								<cfset Lvar_RHTTid = form.RHTTid3>
                                <cfset Lvar_RHMPPid = form.RHMPPid3>
                                <cfset Lvar_RHCid = form.RHCid3>
                            </cfif>
							<!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
                            <cfif rsAccionES.RecordCount GT 0 and rsAccionES.RHPcodigoAlt GT 0>
                                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                                    select RHCPlinea
                                    from RHPuestos a
                                    inner join RHMaestroPuestoP b
                                        on b.RHMPPid = a.RHMPPid
                                        and b.Ecodigo = a.Ecodigo
                                    inner join RHCategoriasPuesto c
                                        on c.RHMPPid = b.RHMPPid
                                        and c.Ecodigo = b.Ecodigo
                                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAccionES.RHPcodigoAlt#">
                                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                </cfquery>
								<cfif rsCatPuestoAlt.RecordCount>
									<cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                                    <cfset Lvar_RHTTid = 0>
                                    <cfset Lvar_RHMPPid = 0>
                                    <cfset Lvar_RHCid = 0>
                               <cfelse>
									<cfset Lvar_CatAlt = 0>
                                    <cfset Lvar_RHTTid = form.RHTTid5>
                                    <cfset Lvar_RHMPPid = form.RHMPPid5>
                                    <cfset Lvar_RHCid = form.RHCid5>
                                </cfif>
                            </cfif>
							<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
								<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
								<cfinvokeargument name="fecha" value="#rsAccionES.DLfvigencia#"/>
								<cfinvokeargument name="fechah" value="#rsAccionES.DLffin#"/>
								<cfinvokeargument name="DEid" value="#rsAccionES.DEid#"/>
								<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
								<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
								<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
								<cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1 and isdefined("Form.EcodigoRef") and Len(Trim(Form.EcodigoRef))>
									<cfinvokeargument name="Ecodigo" value="#Form.EcodigoRef#"/>
								</cfif>
								<cfinvokeargument name="Unidades" value="#Evaluate('Form.RHDAunidad_'&i)#"/>
								<cfinvokeargument name="MontoBase" value="#Evaluate('Form.RHDAmontobase_'&i)#"/>
								<cfinvokeargument name="Monto" value="#Evaluate('Form.RHDAmontores_'&i)#"/>
								<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
								<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
								<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
								<cfinvokeargument name="ValorLlaveTC" value="#Form.RHAlinea#"/>
								<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
                                <cfinvokeargument name="RHTTid" value="#Lvar_RHTTid#">
                                <cfinvokeargument name="RHCid" value="#Lvar_RHMPPid#">
                                <cfinvokeargument name="RHMPPid" value="#Lvar_RHCid#">
								<cfinvokeargument name="PorcSalario" value="#Form.LTporcsal#"/>
                                <cfinvokeargument name="RHCPlineaP" value="#rsAccionES.RHCPlineaP#"/>
							</cfinvoke>

							<cfset unidades = calculaComponenteRet.Unidades>
							<cfset montobase = calculaComponenteRet.MontoBase>
							<cfset monto = calculaComponenteRet.Monto>
							<cfset metodo = calculaComponenteRet.Metodo>
						</cfif>
						<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
							<cf_throw message="#MSG_NoPuedeAplicarAccion#">
						</cfif>
		
						<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
							update RHDAcciones
								set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
								RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montobase, ',','','all')#">,
								RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
								RHDAmetodoC = <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
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
						   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
						   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
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
					<cfset current_formulas = rsConceptos.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
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
												   "", <!---Tcodigo solo se requiere si no va RHAlinea--->
												   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
												   , 0
												   , '' 
												   ,rsConceptos.CIsprango
												   ,rsConceptos.CIspcantidad
												   ,rsConceptos.CImescompleto)>
					<cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
                    <cfset calc_error = RH_Calculadora.getCalc_error()>
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
						insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo,BMUsucodigo,BMfecha)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery> 
				</cfloop>
				<cfquery name="vParam" datasource="#session.dsn#">
					select Pvalor from RHParametros where Pcodigo=540 and Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfif vParam.Pvalor eq 1>
				<cfif isdefined("Form.btnAplicar")>
						<cfquery name="rsArt" datasource="#session.dsn#">
							select RHCatParcial from RHTipoAccion where RHTid=#form.RHTid#
						</cfquery>
						<cfif rsArt.RHCatParcial eq 1>
							<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="Art40">
							 <cfinvokeargument name="RHAlinea" value="#form.RHAlinea#"/>
							</cfinvoke>
						</cfif>
						<cfif isdefined('rsConsTipoAccion') and (rsConsTipoAccion.RHTcomportam eq 1 or rsConsTipoAccion.RHTcomportam eq 6 or rsConsTipoAccion.RHTcomportam eq 8 or rsConsTipoAccion.RHTcomportam eq 11 or rsConsTipoAccion.RHTcomportam eq 12)>
								<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="ReservaAccion">
									 <cfinvokeargument name="RHAlinea" value="#form.RHAlinea#"/>
								 </cfinvoke>
							</cfif>
				</cfif>
					
				</cfif>
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
						<cfif rsConsTipoAccion.RHTcomportam EQ 10 and isdefined('form.RHAtipo') and isdefined('form.RHAdescripcion')>
						   RHAtipo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAtipo#">,
						   RHAdescripcion 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.RHAdescripcion#">
						<cfelseif rsConsTipoAccion.RHTcomportam EQ 11>
						   EVfantig         = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EVfantig_prop)#">
						<cfelseif rsConsTipoAccion.RHTcomportam EQ 14>
							RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
						</cfif>
						,BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						 BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				
				<!---============================================================================================= 
				VALIDAR SI SE MODIFICÓ SOLAMENTE LO QUE SE INDICA EN EL TIPO DE ACCION
				=============================================================================================---->			
		
				<cfset modo="CAMBIO">
			</cftransaction>
		</cfif>
   	<cfelseif isdefined('form.CambioAccion') and form.CambioAccion EQ 1>
		<cfquery name="rsPlazaRecargo" datasource="#Session.DSN#">
			select a.LTRid, rtrim(a.Tcodigo) as Tcodigo, 
			   a.RVid,
               a.RHCPlineaP,
               a.RHCPlinea,
			   a.Ocodigo, 
			   a.Dcodigo, 
			   a.RHPid, 
			   rtrim(a.RHPcodigo) as RHPcodigo,
               RHPcodigoAlt, 
			   (select min(coalesce(ltrim(rtrim(ff.RHPcodigoext)),rtrim(ltrim(ff.RHPcodigo))))
						from RHPuestos ff
						where ff.Ecodigo = a.Ecodigo
						   and ff.RHPcodigo = a.RHPcodigo
						) as RHPcodigoext,
			   a.RHJid,
			   a.LTporcplaza, 
			   a.LTporcsal, 
			   a.LTsalario,
			   a.RHCPlinea,

			  (select min(b.Tdescripcion)
			  	from TiposNomina b
				where a.Ecodigo = b.Ecodigo
						and a.Tcodigo = b.Tcodigo
			  ) as  Tdescripcion, 
			  (select  min(c.Descripcion)
			  	from RegimenVacaciones c
				where a.RVid = c.RVid
			  ) as RegVacaciones, 
 			  (select min(d.Odescripcion)
			  	from Oficinas d
				where a.Ocodigo = d.Ocodigo
					and a.Ecodigo = d.Ecodigo
			  ) as Odescripcion, 
  			  (select min(e.Ddescripcion)
			  	from Departamentos e
				where a.Dcodigo = e.Dcodigo
					and a.Ecodigo = e.Ecodigo
			  ) as Ddescripcion, 			  
			   f.RHPdescripcion, 
			   rtrim(f.RHPcodigo) as CodPlaza,
			   
			   (select min(coalesce(ltrim(rtrim(fx.RHPcodigoext)),rtrim(ltrim(fx.RHPcodigo))))
						from RHPuestos fx
						where fx.Ecodigo = a.Ecodigo
						   and fx.RHPcodigo = a.RHPcodigo
				 ) as CodPuesto, 
			   f.Dcodigo as CodDepto, 
			   f.Ocodigo as CodOfic,
			   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})}	as Plaza,  
			   (select min(g.RHPdescpuesto)
			   	from RHPuestos g
				where a.RHPcodigo = g.RHPcodigo
					and a.Ecodigo = g.Ecodigo
				) as RHPdescpuesto, 
			   (select 	min({fn concat(rtrim(coalesce(ltrim(rtrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})})
			   	from RHPuestos g
				where a.RHPcodigo = g.RHPcodigo
					and a.Ecodigo = g.Ecodigo
			   ) as Puesto,
 			  (select 	min({fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion)})})
			  	from RHJornadas j
				where  a.Ecodigo = j.Ecodigo
					and a.RHJid = j.RHJid
			  )	as Jornada,
               s.RHTTid as RHTTid1,rtrim(s.RHTTcodigo) as RHTTcodigo1, s.RHTTdescripcion as RHTTdescripcion1, 
               s2.RHTTid as RHTTid2, rtrim(s2.RHTTcodigo) as RHTTcodigo2, s2.RHTTdescripcion as RHTTdescripcion2, 
               u.RHMPPid as RHMPPid1,rtrim(u.RHMPPcodigo) as RHMPPcodigo1, u.RHMPPdescripcion as RHMPPdescripcion1,	
               u2.RHMPPid as RHMPPid2,rtrim(u2.RHMPPcodigo) as RHMPPcodigo2, u2.RHMPPdescripcion as RHMPPdescripcion2,	
               t.RHCid as RHCid1, rtrim(t.RHCcodigo) as RHCcodigo1, t.RHCdescripcion as RHCdescripcion1,
               t2.RHCid as RHCid2,rtrim(t2.RHCcodigo) as RHCcodigo2, t2.RHCdescripcion as RHCdescripcion2,
               s.RHTTid as RHTTid3,rtrim(s.RHTTcodigo) as RHTTcodigo3, s.RHTTdescripcion as RHTTdescripcion3, 
               s2.RHTTid as RHTTid4, rtrim(s2.RHTTcodigo) as RHTTcodigo4, s2.RHTTdescripcion as RHTTdescripcion4, 
               u.RHMPPid as RHMPPid3,rtrim(u.RHMPPcodigo) as RHMPPcodigo3, u.RHMPPdescripcion as RHMPPdescripcion3,	
               u2.RHMPPid as RHMPPid4,rtrim(u2.RHMPPcodigo) as RHMPPcodigo4, u2.RHMPPdescripcion as RHMPPdescripcion4,	
               t.RHCid as RHCid3, rtrim(t.RHCcodigo) as RHCcodigo3, t.RHCdescripcion as RHCdescripcion3,
               t2.RHCid as RHCid4,rtrim(t2.RHCcodigo) as RHCcodigo4, t2.RHCdescripcion as RHCdescripcion4,
			  (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
			   from CFuncional cf
				where f.CFid = cf.CFid
					and f.Ecodigo = cf.Ecodigo		
			  )	as Ctrofuncional,
			   pp.RHPPid,
			   pp.RHPPcodigo,
			   pp.RHPPdescripcion,
			   ltp.RHMPnegociado
			   
		from LineaTiempoR a

			 inner join RHPlazas f
				on a.RHPid = f.RHPid
				and a.Ecodigo = f.Ecodigo
				
				<!---====================================================================================  
						Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
						en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
						puesto presupuestario de plaza presup. 						
					===============================================================================---->
					left outer join RHLineaTiempoPlaza ltp
						on f.RHPid = ltp.RHPid						
						and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.DLfvigencia#"> between ltp.RHLTPfdesde 
							and ltp.RHLTPfhasta
						left outer join RHPlazaPresupuestaria pp
							on ltp.RHPPid = pp.RHPPid
							and ltp.Ecodigo = pp.Ecodigo
												 
			 left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
				
			 left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid

			 left outer join RHCategoria t
				on t.RHCid = r.RHCid
				
			left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
				on r.RHMPPid = u.RHMPPid			

			<!---En caso de que existas puesto-categorias propuestos--->
				left outer join RHCategoriasPuesto r2
				 	on r2.RHCPlinea = a.RHCPlineaP

				 left outer join RHTTablaSalarial s2
				 	on s2.RHTTid = r2.RHTTid

				 left outer join RHCategoria t2
				 	on t2.RHCid = r2.RHCid
					
				left outer join RHMaestroPuestoP u2 	<!----Puesto presupuestario ----->
					on r2.RHMPPid = u2.RHMPPid	


		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" null="#Len(form.DEid) is 0#">
        <cfif isdefined('form.LTidRecargo') and form.LTidRecargo GT 0>
        and a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LTidRecargo#">
        </cfif>
		</cfquery>
        <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
            update RHAcciones set
                <!--- Cambio de Empresa --->
                  Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPlazaRecargo.Tcodigo#">
                 , RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.RVid#">
                 , Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPlazaRecargo.Dcodigo#">
                 , Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPlazaRecargo.Ocodigo#">
                 , RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.RHPid#">
                 , RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPlazaRecargo.RHPcodigo#">
                 , RHAporc = <cfqueryparam cfsqltype="cf_sql_float" value="#rsPlazaRecargo.LTporcplaza#">
                 , RHAporcsal = <cfqueryparam cfsqltype="cf_sql_float" value="#rsPlazaRecargo.LTporcsal#">
                 , RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.RHJid#">
                <cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
                , DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#">
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
                , RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.RHCPlinea#" null="#len(rsPlazaRecargo.RHCPlinea) EQ 0#">
                <!--- Categoría Puesto Propuesta--->
                , RHCPlineaP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.RHCPlineaP#" null="#len(rsPlazaRecargo.RHCPlineaP) EQ 0#">
                <!--- Puesto Alterno--->
                , RHPcodigoAlt = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPlazaRecargo.RHPcodigoAlt#" null="#len(rsPlazaRecargo.RHPcodigoAlt) EQ 0#">
                <!--- Cambio de Empresa --->
                <cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1>
                , TcodigoRef = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">
                <cfelse>
                , TcodigoRef = null
                </cfif>
                <!--- Neogciado --->
                <cfif isdefined('LvarNegociado') and LvarNegociado EQ 1>
                , Indicador_de_Negociado = 1
                <cfelse>
                , Indicador_de_Negociado = 0
                </cfif>
                <cfif isdefined("form.RHAdiasenfermedad") and len(trim(form.RHAdiasenfermedad))>
                    , RHAdiasenfermedad = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHAdiasenfermedad, ',','','all')#">
                <cfelse>
                    , RHAdiasenfermedad = null
                </cfif>
                ,RHAccionRecargo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LTidRecargo#">
                <!--- Tipo de aplicacion, solo componentes o todo --->
                ,RHTipoAplicacion = <cfif isdefined('form.chkTipoAplicacion')>1<cfelse>0</cfif>
                ,BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                 BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
        </cfquery>
        <!--- ELIMINA LOS COMPONENTES SALARIALES DE LA ACCION ACTUAL INSERT ALOS COMPONENTES DE LA PLAZA A MODIFICAR --->
        <cfquery datasource="#session.DSN#">
        	delete RHDAcciones
            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
        </cfquery>
        
        <cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
            insert into RHDAcciones(RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores,RHDAmetodoC, Usucodigo, Ulocalizacion)
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#"  null="#Len(form.RHAlinea) is 0#">, 
                   a.CSid, a.DLTtabla, 
                   coalesce(a.DLTunidades, 1.00), 
                   case 
                        when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then 
                            round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2) * 100
                        else 
                            (case 
                                when a.DLTmetodoC is not null then
                                    coalesce(a.DLTmonto, 0.00)
                                else round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2)
                            end)
                   end as DLTmontobase,
                   coalesce(a.DLTmonto, 0.00), 
                   coalesce(a.DLTmetodoC,''),
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
            from DLineaTiempoR a
                left outer join RHMetodosCalculo d
                    on d.CSid = a.CSid
                    and <cfqueryparam cfsqltype="cf_sql_date" value="#form.DLfvigencia#"> between d.RHMCfecharige and d.RHMCfechahasta
                    and d.RHMCestadometodo = 1
            where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaRecargo.LTRid#">
            and not exists (
                select 1
                from RHDAcciones b
                where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#" null="#Len(form.RHAlinea) is 0#">
                and b.CSid = a.CSid
            )
        </cfquery>

<!---          <cf_dump var="#rsEstadoActual#">
 --->	</cfif>

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
		<cfif isdefined("Form.btnAgregar") or isdefined("Form.btnAceptar")>
			<input name="RHAlinea" type="hidden" value="#ABC_RHAcciones.identity#">
		<cfelse>
			<input name="RHAlinea" type="hidden" value="<cfif isdefined("Form.RHAlinea") and not isDefined("Form.Baja")>#Form.RHAlinea#</cfif>">
		</cfif>
       	<cfif isdefined('form.indicaRecargo')>
        <input name="indicaRecargo" type="hidden" value="#form.indicaRecargo#">
        </cfif>
		<cfif isdefined('form.LTidRecargo') and not isdefined("form.Nuevo")>
	    <input name="LTidRecargo" type="hidden" value="#form.LTidRecargo#" />
		<cfset modo = "CAMBIO">
        </cfif>        
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	</form>
	</cfoutput>
	
	<html>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</html>
</cfif>
