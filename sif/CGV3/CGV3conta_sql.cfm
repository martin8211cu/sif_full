<cfif isdefined('url.OP') >
	<cfif url.OP EQ "C1">
		<cfinvoke 	component	= "CGV3conta"
					method		= "sbGeneraCuentaFinanciera"
	
					Ecodigo		= "#session.Ecodigo#"
					Eperiodo	= "#url.Eperiodo#"
					Emes		= "#url.Emes#"
					CFformato	= "#url.CFformato#"
		/>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as pendientes
			  from CGV3asientos
			 where Ecodigo	= #session.Ecodigo#
			   and Eperiodo	= #url.Eperiodo#
			   and Emes		= #url.Emes#
			   and Estatus 	<> 3
		</cfquery>
		
		<cfif rsSQL.pendientes EQ 0>
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = 3
				 where Ecodigo		= #session.Ecodigo#
				   and Eperiodo		= #url.Eperiodo#
				   and Emes			= #url.Emes#
			</cfquery>
		</cfif>
	<cfelseif url.OP EQ "CT">
		<cfquery datasource="#session.dsn#">
			update CGV3detalles
			   set Derror = NULL
			 where Ecodigo		= #session.Ecodigo#
			   and Eperiodo		= #url.Eperiodo#
			   and Emes			= #url.Emes#
			   and CFcuenta is null
		</cfquery>
		<cfinvoke 	component	= "CGV3conta"
					method		= "sbGenerarCuentas"
	
					Ecodigo		= "#session.Ecodigo#"
					Eperiodo	= "#url.Eperiodo#"
					Emes		= "#url.Emes#"
		/>
	<cfelseif url.OP EQ "A1">
		<cfquery name="rsAsientos" datasource="#session.dsn#" maxrows="100">
			select IDcontable
			  from CGV3asientos
			 where Ecodigo		= #session.Ecodigo#
			   and Eperiodo		= #url.Eperiodo#
			   and Emes			= #url.Emes#
			   and CG5CON		= #url.CG5CON#
			   and CGBBAT		= #url.CGBBAT#
		</cfquery>
		<cfif rsAsientos.recordCount GT 0>
			<cfif rsAsientos.IDcontable NEQ "">
				<cfset LvarIDcontable = rsAsientos.IDcontable> 
			<cfelse>
				<cfset LvarIDcontable = fnGeneraAsiento(session.Ecodigo, url.Eperiodo, url.Emes, url.CG5CON, url.CGBBAT)>
				<cfinvoke 	component	= "CGV3conta"
							method		= "fnGeneraAsiento"
							returnvariable = "LvarIDcontable"
			
							Ecodigo		= "#session.Ecodigo#"
							Eperiodo	= "#url.Eperiodo#"
							Emes		= "#url.Emes#"
							CG5CON		= "#url.CG5CON#"
							CGBBAT		= "#url.CGBBAT#"
				/>
			</cfif>
			<cfif LvarIDcontable NEQ -1>
				<cfinvoke 	component	= "CGV3conta"
							method		= "sbAplicarAsiento"
			
							Ecodigo		= "#session.Ecodigo#"
							Eperiodo	= "#url.Eperiodo#"
							Emes		= "#url.Emes#"
							CG5CON		= "#url.CG5CON#"
							CGBBAT		= "#url.CGBBAT#"
							IDcontable	= "#LvarIDcontable#"
				/>
			</cfif>
		</cfif>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as pendientes
			  from CGV3asientos
			 where Ecodigo	= #session.Ecodigo#
			   and Eperiodo	= #url.Eperiodo#
			   and Emes		= #url.Emes#
			   and Estatus 	<> 5
		</cfquery>
		
		<cfif rsSQL.pendientes EQ 0>
			<cfquery datasource="#session.dsn#">
				update CGV3cierres
				   set Mstatus = 5
				 where Ecodigo		= #session.Ecodigo#
				   and Eperiodo		= #url.Eperiodo#
				   and Emes			= #url.Emes#
			</cfquery>
		</cfif>
	<cfelseif url.OP EQ "AT">
		<cfinvoke 	component	= "CGV3conta"
					method		= "sbGenerarAsientos"
	
					Ecodigo		= "#session.Ecodigo#"
					Eperiodo	= "#url.Eperiodo#"
					Emes		= "#url.Emes#"
		/>
	</cfif>
	<cflocation url="CGV3conta.cfm?Nivel=#url.Nivel#&Eperiodo=#url.Eperiodo#&Emes=#url.Emes#">
</cfif>
<cfif isdefined("btnContabilizar")>
	<cfquery name="rsPoliza" datasource="#session.dsn#">
		select Eperiodo, Emes, CG5CON, CGBBAT
		  from CGV3asientos
		 where Ecodigo		= #session.Ecodigo#
		   and IDcontable	= #form.IDcontable#
	</cfquery>
	<cfinvoke 	component	= "CGV3conta"
				method		= "sbAplicarAsiento"

				Ecodigo		= "#session.Ecodigo#"
				Eperiodo	= "#rsPoliza.Eperiodo#"
				Emes		= "#rsPoliza.Emes#"
				CG5CON		= "#rsPoliza.CG5CON#"
				CGBBAT		= "#rsPoliza.CGBBAT#"
				IDcontable	= "#form.IDcontable#"
	/>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as pendientes
		  from CGV3asientos
		 where Ecodigo	= #session.Ecodigo#
		   and Eperiodo	= #rsPoliza.Eperiodo#
		   and Emes		= #rsPoliza.Emes#
		   and Estatus 	<> 5
	</cfquery>
	
	<cfif rsSQL.pendientes EQ 0>
		<cfquery datasource="#session.dsn#">
			update CGV3cierres
			   set Mstatus = 5
			 where Ecodigo		= #session.Ecodigo#
			   and Eperiodo		= #rsPoliza.Eperiodo#
			   and Emes			= #rsPoliza.Emes#
		</cfquery>
	</cfif>
	<cflocation url="CGV3conta.cfm?Nivel=3&IDcontable=#form.IDcontable#">
</cfif>
<!---
	Consideraciones:

	- Se puede cambiar el encabezado cuando se agregan o se cambian lineas de detalle
	- Si ocurre un cambio en el periodo y mes del encabezado se cambiar el periodo y mes en todos los detalles

	Modificado por Gustavo Fonseca H.
		Fecha: 27-3-2006.
		Motivo: se hace que se conserven los valores del filtro y el número de página de la lista al aplicar 
		tanto desde la lista como dentro del documento.
--->

<cfparam name="sufix" default="">
<cfset action = "CGV3conta.cfm?nivel=5">
<cfset nuevoDet=false>

<cf_dbfunction name="to_number" args="a.Pvalor" returnvariable="LvarPvalor">
<cfquery name="rsBalanzaSaldos" datasource="#session.DSN#">
	select 'Balance de Saldos por Oficina' as descripcion,
			 b.Ccuenta as Ccuenta
		from Parametros a, CContables b
		where a.Ecodigo = #session.Ecodigo#
		  and a.Pcodigo = 90
		  and a.Ecodigo = b.Ecodigo
		  and #LvarPvalor# = b.Ccuenta
</cfquery>
<cfif rsBalanzaSaldos.RecordCount EQ 0>
	<cf_errorCode	code = "50240" msg = "No se ha definido Correctamente la Cuenta Contable para Movimiento entre Sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)">
<cfelse>
	<cfquery name="rsCFcuentaMin" datasource="#session.DSN#">
		select min(CFcuenta) as MinCFcuenta from CFinanciera
		where Ecodigo = #Session.Ecodigo#
		and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanzaSaldos.Ccuenta#">
	</cfquery>
	<cfif isdefined("form.btnBalanceaOfic")>
		<cfquery name="rsBalanceOfic" datasource="#session.dsn#">
			select 
				d.Ecodigo, 
				d.IDcontable as IDcontable, 
				d.Ocodigo as Oficina, 
				d.Mcodigo as Mcodigo,
				d.Dtipocambio as Dtipocambio,
				abs(sum(d.Dlocal * case when d.Dmovimiento = 'D' then 1.00 else -1.00 end)) as Dlocal, 
				abs(sum(d.Doriginal * case when d.Dmovimiento = 'D' then 1.00 else -1.00 end)) as Doriginal,
				case when sum(d.Dlocal * case when d.Dmovimiento = 'D' then 1.00 else -1.00 end) > 0 then 'C' else 'D' end as Dmovimiento
			from DContables d
			where d.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
			group by d.Ecodigo, d.IDcontable, d.Ocodigo, d.Mcodigo, d.Dtipocambio
			having abs(sum(d.Dlocal * case when d.Dmovimiento = 'D' then 1.00 else -1.00 end)) <> 0 or abs(sum(d.Doriginal * case when d.Dmovimiento = 'D' then 1.00 else -1.00 end)) <> 0
		</cfquery>
	</cfif>
</cfif> 

<cfif isdefined("form.btnBalanceaOfic")>
	<cfquery name="rsLineaAjusta" datasource="#Session.DSN#">
		select coalesce(max(Dlinea),1) as linea 
		from DContables
		where Ecodigo = #Session.Ecodigo#
		  and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
	</cfquery>
	<cfset NewLine = rsLineaAjusta.Linea>
	<cfloop query="rsBalanceOfic">
		<cfset NewLine = NewLine + 1>
		<cfquery name="rsAjustar" datasource="#session.DSN#">
			insert into DContables (
				IDcontable, 
				Dlinea,
				Ecodigo, 
				Cconcepto, 
				Ocodigo, 
				Eperiodo, 
				Emes, 
				Edocumento, 
				Ddescripcion, 
				Ddocumento, 
				Dreferencia, 
				Dmovimiento, 
				Ccuenta, 
				CFcuenta, 
				Doriginal, 
				Dlocal, 
				Mcodigo, 
				BMUsucodigo,
				Dtipocambio,
                CFid
                ) 
			values( 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">,  
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#NewLine#">,  
				#Session.Ecodigo#,        		
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form._Cconcepto#">,    			
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanceOfic.Oficina#">,  		
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Eperiodo#">,       			
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Emes#">,           	 		
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Edocumento#">,  				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBalanzaSaldos.descripcion#">,	
				'',																					
				'',																					
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsBalanceOfic.Dmovimiento#">,  		
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanzaSaldos.Ccuenta#">,		
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuentaMin.MinCFcuenta#">, 		
				<cfqueryparam cfsqltype="cf_sql_double" value="#rsBalanceOfic.Doriginal#">,			
				<cfqueryparam cfsqltype="cf_sql_double" value="#rsBalanceOfic.Dlocal#">,	        
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanceOfic.Mcodigo#">,			
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,				
				<cfqueryparam cfsqltype="cf_sql_float" value="#rsBalanceOfic.Dtipocambio#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">
                )      		
		</cfquery>
</cfloop>
</cfif> 
<cftransaction>
	<cfset cambioEncab = false>
	<cfif (isDefined("Form.Edescripcion") and Trim(Form.Edescripcion) NEQ Trim(Form._Edescripcion))
	   or (isDefined("Form.Efecha") and Trim(Form.Efecha) NEQ Trim(Form._Efecha))
	   or (isDefined("Form.Eperiodo") and Trim(Form.Eperiodo) NEQ Trim(Form._Eperiodo))
	   or (isDefined("Form.Emes") and Trim(Form.Emes) NEQ Trim(Form._Emes))
	   or (isDefined("Form.Ereferencia") and Trim(Form.Ereferencia) NEQ Trim(Form._Ereferencia))
	   or (isDefined("Form.Edocbase") and Trim(Form.Edocbase) NEQ Trim(Form._Edocbase))
	   or (isDefined("Form.ECreversible") and isDefined("Form._ECreversible") and Trim(Form._ECreversible) NEQ 1) 
	   or (not isDefined("Form.ECreversible") and isDefined("Form._ECreversible") and Trim(Form._ECreversible) NEQ 0)
	   or (isDefined("Form.ECrecursivo") and isDefined("Form._ECrecursivo") and Trim(Form._ECrecursivo) EQ 0) 
	   or (not isDefined("Form.ECrecursivo") and isDefined("Form._ECrecursivo") and Trim(Form._ECrecursivo) EQ 0)
	>
		<cfset cambioEncab = true>
	</cfif>
	<cfset cambioPeriodoMes = false>	
	<cfif (isDefined("Form.Eperiodo") and Trim(Form.Eperiodo) NEQ Trim(Form._Eperiodo)) or (isDefined("Form.Emes") and Trim(Form.Emes) NEQ Trim(Form._Emes))>
		<cfset cambioPeriodoMes = true>
	</cfif>
	<!--- Determina si puede cambiar el mes --->
	<cfif isdefined("form.AgregarD") or isdefined("form.CambiarD") or isdefined("form.CambiarE")>
		<cfset cambiarMesPeriodo = true >
		<cfif (form.Emes neq form._Emes) or (form.Eperiodo neq form._Eperiodo) >
			<cfquery name="rsAccion" datasource="#session.DSN#">
				select 1 
				from EContables
				where Ecodigo = #Session.Ecodigo#
				  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form._Cconcepto#">
				  and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Eperiodo#">
				  and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Emes#">
				  and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Edocumento#">
			  </cfquery>
			  <cfif rsAccion.RecordCount gt 0>
			 	  <cfset cambiarMesPeriodo = false >
				  <cf_errorCode	code = "50245"
				  				msg  = "La Poliza @errorDat_1@ ya existe en el periodo @errorDat_2@, mes @errorDat_3@"
				  				errorDat_1="#form.Edocumento#"
				  				errorDat_2="#form.Eperiodo#"
				  				errorDat_3="#form.Emes#"
				  > 
			  </cfif>
		  </cfif>
	</cfif>
	<cfif (isdefined("Form.AgregarE") or cambioPeriodoMes) and (not isdefined("Form.NuevoE"))>	
		<cfinvoke 
		 component="sif.Componentes.Contabilidad"
		 method="Nuevo_Asiento"
		 returnvariable="Nuevo_AsientoRet">
		 	<cfinvokeargument name="Cconcepto" value="#Form.Cconcepto#"/>
			<cfinvokeargument name="Oorigen" value=" "/>
			<cfinvokeargument name="Eperiodo" value="#Form.Eperiodo#"/>
			<cfinvokeargument name="Emes" value="#Form.Emes#"/>
			<cfinvokeargument name="Edocumento" value="0"/>
		</cfinvoke>
	</cfif>
	<cfif isdefined("Form.AgregarE")>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			insert into EContables (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, ECusucodigo, ECfechacreacion, ECipcrea, ECestado, ECreversible, BMUsucodigo, ECtipo, ECrecursivo)
			values (
				#Session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">, 
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">, 
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,
				#Nuevo_AsientoRet#,
				<cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.Efecha)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECauxiliar#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.sitio.ip#">,
				0,
				<cfif isdefined("Form.ECreversible") and Len(Trim(Form.ECreversible))>
				1,
				<cfelse>
				0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfif sufix eq 'CierreAnual'>
					1
				<cfelse>	
					<cfif isdefined("Form.paramretro") and Len(Trim(Form.paramretro)) and Form.paramretro eq 2>
						2
					<cfelse>
						<cfif isdefined("Form.inter") and Len(Trim(Form.inter)) and Form.inter eq 'S'>
						20
						<cfelse>
						0
						</cfif>
					</cfif>
				</cfif>,
                <cfif isdefined("Form.ECrecursivo") and Len(Trim(Form.ECrecursivo))>
					1
				<cfelse>
					0
                </cfif>
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsAccion">
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
	<cfelseif isdefined("Form.AgregarD")>
		<cfif cambioEncab> 
			<cfset V_redirec = "CGV3conta.cfm?nivel=5">
            
            <cf_dbtimestamp
            datasource="#session.dsn#"
                table="EContables" 
                redirect="#V_redirec#"
                timestamp="#Form.timestampE#"
                field1="IDcontable,numeric,#Form.IDcontable#"
                field2="Ecodigo,numeric,#session.Ecodigo#">
            <cfquery name="rsAccion" datasource="#Session.DSN#">
                update EContables set
                    <cfif cambiarMesPeriodo>Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,</cfif>
                    <cfif cambiarMesPeriodo>Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,</cfif>
                    <cfif cambioPeriodoMes>Edocumento = #Nuevo_AsientoRet#,</cfif>
                    Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
                    Edocbase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
                    Ereferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
                    ECauxiliar = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECauxiliar#">,
                    Efecha = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.Efecha)#">,
                    <cfif isdefined("Form.ECreversible") and Len(Trim(Form.ECreversible))>
                        ECreversible = 1,
                    <cfelse>
                        ECreversible = 0,
                    </cfif>
                    <cfif isdefined("Form.ECrecursivo") and Len(Trim(Form.ECrecursivo))>
                        ECrecursivo = 1
                    <cfelse>
                        ECrecursivo = 0
                    </cfif>
                where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
                    and Ecodigo = #Session.Ecodigo#
            </cfquery>
		</cfif>
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select coalesce(max(Dlinea)+1,1) as linea 
			from DContables
			where Ecodigo = #Session.Ecodigo#
			  and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
		</cfquery>
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			insert into DContables (Ecodigo, Dlinea, IDcontable, Cconcepto, Eperiodo, Emes, Edocumento, 
					Ocodigo, Ddescripcion, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Ddocumento, Dreferencia, CFid) 
			values (
				#Session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.linea#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,				
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">, 
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,
				<cfif cambioPeriodoMes>#Nuevo_AsientoRet#<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Edocumento#"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">,								
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Dmovimiento#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.Doriginal#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.Dlocal#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.Dtipocambio#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">	,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dreferencia#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">
			)
		</cfquery>
		<!--- Cambia el Mes para todos los detalles --->
		<cfif ( form.Eperiodo neq form._Eperiodo or form.Emes neq form._Emes )	and cambiarMesPeriodo >
			<cfquery name="rsAccion" datasource="#Session.DSN#">
				update DContables 
					set Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,
					<cfif cambioPeriodoMes>Edocumento = #Nuevo_AsientoRet#,</cfif>
					Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
				  and Ecodigo = #Session.Ecodigo#			  
			</cfquery>
		</cfif>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
	<cfelseif isdefined("Form.BorrarD") or (isdefined("Form.borrarLista") and Form.borrarLista EQ 'S')>
			<cfif not isdefined('form.chk') or NOT LEN(TRIM(form.chk))>
				<cfset form.chk = Form.IDcontable&'|'&Form.Dlinea>	
			</cfif>
			<cfset LvarPrimerLinea = listGetAt(listGetAt(form.chk,1),2,'|')>
			<cfloop list="#form.chk#" index="lvarDlinea">
				<cfset Form.Dlinea = listGetAt(lvarDlinea,2,'|')>
				
				<cfquery datasource="#session.dsn#">
					delete from DContables 
					where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
					  and Dlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Dlinea#">
				</cfquery>
			</cfloop>
			<cfquery name="rsLineas" datasource="#session.dsn#">
				select coalesce(Dlinea,0) as linea from DContables 
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
				  and Dlinea     > <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPrimerLinea#">
				order by Dlinea
			</cfquery>
			<cfloop query="rsLineas">
				<cfquery datasource="#session.dsn#">
					update DContables 
					set Dlinea =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPrimerLinea#">
					where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
					  and Dlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.linea#">
				</cfquery>
				<cfset LvarPrimerLinea += 1>
			</cfloop>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">								  
	<cfelseif isdefined("Form.CambiarD") OR  isdefined("Form.CambiarE")>
		<cfif cambioEncab>
			<cfset V_redirec = "CGV3conta.cfm?nivel=5">
            <cf_dbtimestamp
            datasource="#session.dsn#"
                table="EContables" 
                redirect="#V_redirec#"
                timestamp="#Form.timestampE#"
                field1="IDcontable,numeric,#Form.IDcontable#"
                field2="Ecodigo,numeric,#session.Ecodigo#">
			<cfquery name="rsAccion" datasource="#session.dsn#">
				update EContables set
					<cfif cambiarMesPeriodo>Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,</cfif>
					<cfif cambiarMesPeriodo>Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,</cfif>
					<cfif cambioPeriodoMes>Edocumento = #Nuevo_AsientoRet#,</cfif>
					Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
					Edocbase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
					Ereferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
					ECauxiliar = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ECauxiliar#">,
					Efecha = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.Efecha)#">,
					<cfif isdefined("Form.ECreversible") and Len(Trim(Form.ECreversible))>
						ECreversible = 1,
					<cfelse>
						ECreversible = 0,
					</cfif>
                    <cfif isdefined("Form.ECrecursivo") and Len(Trim(Form.ECrecursivo))>
                        ECrecursivo = 1
                    <cfelse>
                        ECrecursivo = 0
                    </cfif>
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
				  and Ecodigo = #Session.Ecodigo#
			</cfquery>
		</cfif> 
		
		<cfset V_redirec = "CGV3conta.cfm?nivel=5">			
		
		<cfif isdefined("Form.CambiarD")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="DContables" 
				redirect="#V_redirec#"
				timestamp="#Form.timestampD#"
				field1="IDcontable,numeric,#Form.IDcontable#"
				field2="Dlinea,numeric,#Form.DLinea#"
				field3="Ecodigo,numeric,#session.Ecodigo#">
			<cfquery name="rsAccion" datasource="#session.dsn#">
				update DContables set 
					<cfif cambioPeriodoMes>
						Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,
						Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,
						Edocumento = #Nuevo_AsientoRet#, 
					</cfif>
					Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
					Ddescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">,
					Dmovimiento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Dmovimiento#">,
					Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
					CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">,
					Doriginal = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Doriginal#">,
					Dlocal = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Dlocal#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					Dtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.Dtipocambio#">,
					Ddocumento =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
					Dreferencia =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dreferencia#">,
                    CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
				  and Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Dlinea#">
				  and Ecodigo = #Session.Ecodigo#			  
			</cfquery>
		</cfif>
		<!--- Cambia el Mes para todos los detalles --->
		<cfif ( form.Eperiodo neq form._Eperiodo or form.Emes neq form._Emes )	and cambiarMesPeriodo >
			<cfquery name="rsAccion" datasource="#session.dsn#">
				update DContables 
					set Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,
					<cfif cambioPeriodoMes>Edocumento = #Nuevo_AsientoRet#,</cfif>
					Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
				  and Ecodigo = #Session.Ecodigo#			  
			</cfquery>
		</cfif>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
		<cfset nuevoDet=true>
	<cfelseif isdefined("Form.NuevoD")>
		<cfset modoDet="ALTA">
		<cfset nuevoDet=true>
	<cfelseif isdefined("Form.bandBalancear") and form.bandBalancear EQ 'S'>
		<!--- Balancea la moneda Local de diferencias por tipos de cambio en moneda Original --->
		<!--- Solo debe procesar si la Moneda Original esta balanceada --->
		<!--- Agrega una linea por cada diferencia en Moneda Local con Moneda Original en cero --->
		<cfquery datasource="#Session.DSN#">
			delete from DContables
			 where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">
			   and Ecodigo = #Session.Ecodigo#
			   and Ddescripcion = 'Ajuste para balancear diferencias en tipos de cambio'
		</cfquery>
		<cfquery name="rsBalanceLocal" datasource="#Session.DSN#">
			select 	a.Mcodigo,
					a.Ocodigo, 
					sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos0ri,
					sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as CreditosOri,
					sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
					sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL
			  from DContables a
			 where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">
			   and a.Ecodigo = #Session.Ecodigo#
			 group by a.Mcodigo, a.Ocodigo
		</cfquery>	
 		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select coalesce(max(Dlinea)+1,1) as linea 
			from DContables
			where Ecodigo = #Session.Ecodigo#
			  and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
		</cfquery>		
		
		<cfset varMoneda = ''>
		<cfset varOficina = ''>		
		<cfset varDif = 0>
		<cfif isdefined('rsLinea') and rsLinea.recordCount GT 0>
			<cfset varNewLinea = rsLinea.linea>		
		<cfelse>
			<cfset varNewLinea = 1>
		</cfif>
		
		<cfif isdefined('rsBalanceLocal') and rsBalanceLocal.recordCount GT 0>
			<cfloop query="rsBalanceLocal">
 				<cfset varDif = rsBalanceLocal.DebitosL - rsBalanceLocal.CreditosL>

				<cfif rsBalanceLocal.Debitos0ri EQ rsBalanceLocal.CreditosOri and abs(varDif) NEQ 0 and abs(varDif) LTE 0.10>
					<cfquery datasource="#Session.DSN#">
						insert into DContables (Ecodigo, Dlinea, IDcontable, Cconcepto, Eperiodo, Emes, Edocumento, 
								Ocodigo, Ddescripcion, Dmovimiento, Ccuenta, CFcuenta, Mcodigo, Ddocumento,
								Doriginal, Dlocal, Dtipocambio, Dreferencia, CFid
								) 
						values (
							#Session.Ecodigo#, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#varNewLinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,				
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">, 
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Edocumento#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsBalanceLocal.Ocodigo#">,
							'Ajuste para balancear diferencias en tipos de cambio',								
							<cfif varDif GT 0>
								'C',
							<cfelse>
								'D',
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaBalancear#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaBalancear#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanceLocal.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,

							0, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#abs(varDif)#">, 1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dreferencia#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">
						)
					</cfquery>
					<!--- Cambia el Mes para todos los detalles --->
					<cfif ( form.Eperiodo neq form._Eperiodo or form.Emes neq form._Emes )	and cambiarMesPeriodo >
						<cfquery name="rsAccion" datasource="#Session.DSN#">
							update DContables 
								set Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Eperiodo#">,
								Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Emes#">
							where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
							  and Ecodigo = #Session.Ecodigo#			  
						</cfquery>
					</cfif>
				</cfif>
				
				<cfset varNewLinea = varNewLinea + 1>
			</cfloop>
		
 		</cfif>
	
		<cfset modoDet="ALTA">
		<cfset nuevoDet=true>	

	<!--- Cierre de Asiento Contable para que no puedan adicionar ms asientos contables --->
	<cfelseif isdefined("Form.btnCerrar") or isdefined("Form.btnAbrir")>
		
		<cfif isdefined("Form.btnCerrar")>
			<cfquery name="rsCerrar" datasource="#Session.DSN#">
				update EContables
					set ECestado = 1
				where Ecodigo = #Session.Ecodigo#
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
			</cfquery>
		<cfelse>
			<cfquery name="rsCerrar" datasource="#Session.DSN#">
				update EContables
					set ECestado = 0
				where Ecodigo = #Session.Ecodigo#
				and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
			</cfquery>
		</cfif>
	
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">

	</cfif>
	<cfif isdefined ("Form.btnbuscar")>
		<cfset modo = "CAMBIO">
	</cfif>
</cftransaction>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="form1">
	<input name="inter" type="hidden" value="<cfif isdefined("inter")><cfoutput>#inter#</cfoutput></cfif>">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")><cfoutput>#modoDet#</cfoutput></cfif>">	
	<input type="hidden" name="LvarDlinea" value="<cfif isdefined("form.LvarDlinea")><cfoutput>#form.LvarDlinea#</cfoutput></cfif>">
	<cfoutput>
		<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>">
		<input name="lote" type="hidden" value="<cfif isdefined("form.lote") and len(trim(form.lote)) and form.lote NEQ -1>#form.lote#</cfif>">
		<input name="poliza" type="hidden" value="<cfif isdefined("form.poliza") and len(trim(form.poliza))>#form.poliza#</cfif>">
		<input name="descripcion" type="hidden" value="<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>#form.descripcion#</cfif>">
		<input name="periodo" type="hidden" value="<cfif isdefined("form.periodo")and len(trim(form.periodo))>#form.periodo#</cfif>">
		<input name="mes" type="hidden" value="<cfif isdefined("form.mes") and len(trim(form.mes))>#form.mes#</cfif>">
		<input name="fecha" type="hidden" value="<cfif isdefined("form.fecha") and len(trim(form.fecha))>#form.fecha#</cfif>">
		<input name="ver" type="hidden" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#</cfif>">
		<input name="ECusuario" type="hidden" value="<cfif isdefined("form.ECusuario") and len(trim(form.ECusuario))>#form.ECusuario#</cfif>">
		<input name="origen" type="hidden" value="<cfif isdefined("form.origen") and len(trim(form.origen)) and not isdefined("url.origen")>#form.origen#</cfif>">
		<input name="fechaGen" type="hidden" value="<cfif isdefined("form.fechaGen") and len(trim(form.fechaGen))>#form.fechaGen#</cfif>">
	</cfoutput>
	<cfif isdefined("rsAccion.identity")>
	   	<input name="IDcontable" type="hidden" value="<cfif isdefined("rsAccion.identity")><cfoutput>#rsAccion.identity#</cfoutput></cfif>">
	<cfelseif not isdefined("Form.NuevoE")> 
	   	<input name="IDcontable" type="hidden" value="<cfif isdefined("Form.IDcontable") and not isDefined("Form.BorrarE")><cfoutput>#Form.IDcontable#</cfoutput></cfif>">		
	<cfelse>
		<input name="IDcontable" type="hidden" value="">
	</cfif>
	<cfif isdefined("Form.Dlinea") and nuevoDet EQ false and not isdefined('form.BorrarD') and (isdefined('form.borrarLista') and form.borrarLista EQ 'N')>
   		<input name="Dlinea" type="hidden" value="<cfif isdefined("Form.Dlinea")><cfoutput>#Form.Dlinea#</cfoutput></cfif>">    	
	</cfif>
	<cfif isdefined("Form.Aplicar")>
   		<input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")><cfoutput>#Form.Aplicar#</cfoutput></cfif>">    	
   		<input name="Cconcepto" type="hidden" value="<cfif isdefined("Form.Cconcepto")><cfoutput>#Form.Cconcepto#</cfoutput></cfif>">    	
   		<input name="Eperiodo" type="hidden" value="<cfif isdefined("Form.Eperiodo")><cfoutput>#Form.Eperiodo#</cfoutput></cfif>">    	
   		<input name="Emes" type="hidden" value="<cfif isdefined("Form.Emes")><cfoutput>#Form.Emes#</cfoutput></cfif>">    	
   		<input name="Edocumento" type="hidden" value="<cfif isdefined("Form.Edocumento")><cfoutput>#Form.Edocumento#</cfoutput></cfif>">    	
	</cfif>
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
 


