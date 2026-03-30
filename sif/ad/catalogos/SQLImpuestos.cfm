
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
    <cftransaction>
    	<cfquery name="rsCheckedSer" datasource="#Session.DSN#">
        	select IServdefault from Impuestos where IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfquery>
        <cfquery name="rsCheckedAct" datasource="#Session.DSN#">
        	select IActdefault from Impuestos where IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfquery>
        <cfif isdefined("Form.defaultAct") and rsCheckedAct.recordcount neq 0>
        	<cfquery name="updateAct" datasource="#Session.DSN#">
            	update Impuestos set IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfquery>
        </cfif>
        <cfif isdefined("Form.defaultServ") and rsCheckedSer.recordcount neq 0>
        	<cfquery name="updateServ" datasource="#Session.DSN#">
            	update Impuestos set IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfquery>
        </cfif>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into Impuestos( 	Ecodigo, Icodigo, BMUsucodigo, Idescripcion, Iporcentaje, 
									Ccuenta,CcuentaCxC,CcuentaCxCAcred,CcuentaCxPAcred, 
									CFcuenta,CFcuentaCxC,CFcuentaCxCAcred,CFcuentaCxPAcred, 
						Icompuesto, Icreditofiscal, InoRetencion, Usucodigo, Ifecha, IActdefault, IRetencion, IServdefault,
						IcodigoExt,ieps, TipoCalculo, ValorCalculo, Ucodigo, Factor, IEscalonado,ClaveSAT,TipoFactor,TasaOCuota)
			VALUES (<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_varchar">,

					<cfif isdefined("Form.Icompuesto")>
						0.00,
						<!--- Cuentas contables---->
						null,
						null,
						null,
						null,
						<!--- Cuentas Finacieras---->
						null,
						null,
						null,
						null,
					 	1,
						0,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_float" 	 value="#Form.Iporcentaje#" >,
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"				null="#rtrim(Form.Ccuenta) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxC#"			null="#rtrim(Form.CcuentaCxC) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxCAcred#"		null="#rtrim(Form.CcuentaCxCAcred) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxPAcred#"		null="#rtrim(Form.CcuentaCxPAcred) EQ ""#">,

					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#"			null="#rtrim(Form.CFcuenta) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxC#"			null="#rtrim(Form.CFcuentaCxC) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxCAcred#"	null="#rtrim(Form.CFcuentaCxCAcred) EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxPAcred#"	null="#rtrim(Form.CFcuentaCxPAcred) EQ ""#">,

					 	0,
						<cfif isdefined("Form.Icreditofiscal")>
							1,
						<cfelse>
							0,
						</cfif>
					</cfif>
					<cfparam name="form.InoRetencion" default="0">
					<cfqueryparam value="#form.InoRetencion#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
                    <cfif isdefined("Form.defaultAct")>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    </cfif>
					<cfif isdefined("Form.retencion")>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    </cfif>
                    <cfif isdefined("Form.defaultServ")>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    </cfif>
					<cfqueryparam value="#form.IcodigoExt#" cfsqltype="cf_sql_char">,
                    <cfif isdefined("Form.ieps")>
                    	<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ITCalculo#">,
                    	<cfqueryparam cfsqltype="cf_sql_float" value="#Form.IValorC#">,
                    	<cfif #Form.ITCalculo# EQ 2>
                    		<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IUnidades#">,
                    		<cfqueryparam cfsqltype="cf_sql_float" value="#Form.IFactor#">,
                    	<cfelseif #Form.ITCalculo# EQ 1>
                    		null,
                     		null,
                     	</cfif>
                    <cfelse>
                     	<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                     	<cfqueryparam cfsqltype="cf_sql_char" value="0">,
                     	null,
                     	null,
                     	null,
                    </cfif>
                    <cfif isdefined("Form.IEscalonado")>
                    	<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfelse>
                     	<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    </cfif>
					<cfif IsDefined('form.ITCalculo') and form.ITCalculo eq 2><!--- IEPS Cuota --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="003">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Cuota">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.IValorFijoIEPS#">
					<cfelseif IsDefined('form.TCIMPUESTOIEPS') and len(trim(form.TCIMPUESTOIEPS)) gt 0><!--- IEPS TASA --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="003">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Tasa">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.TCValMaxIEPS#">
					<cfelseif IsDefined('form.TCImpuesto') and len(trim(form.TCIMPUESTO)) gt 0><!--- IVA --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="002">,
						<!--- Para IvaExento<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCFactor#">,--->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Tasa">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.TCValMax#">
					<cfelse>
					    null,
						null,
						null
					</cfif>
			       )
		</cfquery>

	<cfif Form.DIOTcodigo neq '' and not isdefined('Form.ieps')>
		<cfquery name="insertDiot" datasource="#Session.DSN#">
			insert into ImpuestoDIOT (Icodigo,Ecodigo,DIOTivacodigo,BMUsucodigo)
				values(<cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
					   <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					   <cfqueryparam value="#Form.DIOTcodigo#" cfsqltype="cf_sql_char">,
					   <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">
						)
		</cfquery>
	</cfif>

    </cftransaction>
		<cfif isdefined("Form.Icompuesto")>
			<cfset action = "DetImpuestos.cfm">
			<cfset modo="CAMBIO">
		<cfelse>
			<cfset modo="ALTA">
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from DImpuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfquery name="rsDiot" datasource="#Session.DSN#">
				delete ImpuestoDIOT
				where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from Impuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="Impuestos"
			 			redirect="Impuestos.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="Ecodigo"
						type1="integer"
						value1="#session.Ecodigo#"
						field2="Icodigo"
						type2="char"
						value2="#Form.Icodigo#"
						>
		<!---
		<cfquery name="deleteDetalle" datasource="#Session.DSN#">
			delete from DImpuestos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		--->
		<cftransaction>
		<cfif not isdefined("Form.Icompuesto") and Form.IcompuestoX EQ 1 >
			<cfquery name="rsTieneRegistros" datasource="#Session.DSN#">
				select * from DImpuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif rsTieneRegistros.recordCount GT 0>
				<cf_errorCode	code = "50025" msg = "El registro no puede ser modificado, debido a que tiene dependencias asociadas.">
			</cfif>
		</cfif>
        <cfif isdefined("Form.defaultAct")>
            <cfquery name="updateAct" datasource="#Session.DSN#">
            	update Impuestos set IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfquery>
        </cfif>
        <cfif isdefined("Form.defaultServ")>
        	<cfquery name="updateServ" datasource="#Session.DSN#">
        		update Impuestos set IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfquery>
        </cfif>
        <cfif isdefined("Form.IValorC") and isdefined("Form.Iporcentaje") and isdefined("Form.IEPS")  and Form.IEPS EQ 1 >
        	<cfset Form.Iporcentaje = Form.IValorC>
        </cfif>

		<cfquery name="update" datasource="#Session.DSN#">
			update Impuestos
			set	IcodigoExt 	 = <cfqueryparam value="#form.IcodigoExt#" cfsqltype="cf_sql_char">,
				Idescripcion = <cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_varchar">,
				<cfparam name="form.InoRetencion" default="0">
				InoRetencion = <cfqueryparam value="#form.InoRetencion#" cfsqltype="cf_sql_bit">,

				<cfif isdefined("Form.Icompuesto")>
					Iporcentaje = (select coalesce(sum(DIporcentaje),0)
								from DImpuestos b
								where b.Icodigo = Impuestos.Icodigo
								and b.Ecodigo = Impuestos.Ecodigo),
					Ccuenta 		=  	null,
					CcuentaCxC 		=	null,
					CcuentaCxCAcred	=	null,
					CcuentaCxPAcred	=	null,
					Icompuesto = 1,
					Icreditofiscal = 0,
				<cfelse>					
					Iporcentaje = <cfqueryparam value="#Form.Iporcentaje#" cfsqltype="cf_sql_float">,
					Ccuenta 			=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"			null="#rtrim(Form.Ccuenta) EQ ""#">,
					CcuentaCxC 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxC#"		null="#rtrim(Form.CcuentaCxC) EQ ""#">,
					CcuentaCxCAcred		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxCAcred#"	null="#rtrim(Form.CcuentaCxCAcred) EQ ""#">,
					CcuentaCxPAcred		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaCxPAcred#"	null="#rtrim(Form.CcuentaCxPAcred) EQ ""#">,
					CcuentaTraRemision		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaTraRemision#"	null="#rtrim(Form.CcuentaTraRemision) EQ ""#">,

					CFcuenta 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#"			null="#rtrim(Form.CFcuenta) EQ ""#">,
					CFcuentaCxC 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxC#"		null="#rtrim(Form.CFcuentaCxC) EQ ""#">,
					CFcuentaCxCAcred	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxCAcred#"	null="#rtrim(Form.CFcuentaCxCAcred) EQ ""#">,
					CFcuentaCxPAcred	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxPAcred#"	null="#rtrim(Form.CFcuentaCxPAcred) EQ ""#">,
					CFcuentaTraRemision = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaTraRemision#"	null="#rtrim(Form.CFcuentaTraRemision) EQ ""#">,
					Icompuesto = 0,
					<cfif isdefined("Form.Icreditofiscal")>
						Icreditofiscal = 1,
					<cfelse>
						Icreditofiscal = 0,
					</cfif>
				</cfif>

				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				Ifecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
                <cfif isdefined("Form.defaultAct")>
                    IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                <cfelse>
                    IActdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                </cfif>
				<cfif isdefined("Form.retencion")>
                    IRetencion = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                <cfelse>
                    IRetencion = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                </cfif>
                <cfif isdefined("Form.defaultServ")>
                    IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                <cfelse>
                    IServdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                </cfif>
                <cfif isdefined("Form.ieps")>
                    ieps = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    TipoCalculo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ITCalculo#">,
                    ValorCalculo = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.IValorC#">,
                    <cfif #Form.ITCalculo# EQ 2>
                    	Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.IUnidades#">,
                    	Factor = <cfqueryparam cfsqltype="cf_sql_float" value="#form.IFactor#">,
                    <cfelseif #Form.ITCalculo# EQ 1>
                    	Ucodigo = null,
                     	Factor = null,
                    </cfif>
                <cfelse>
                    ieps = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    TipoCalculo = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    Ucodigo = null,
                    Factor = null,
                    ValorCalculo = null,
                </cfif>
                <cfif isdefined("Form.IEscalonado") and LEN(Form.IEscalonado)>
                    IEscalonado = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                <cfelse>
                    IEscalonado = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                </cfif>
				<cfif IsDefined('form.ITCalculo') and form.ITCalculo eq 2 and IsDefined('form.ieps')><!--- IEPS Cuota --->
					,ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="003">,
					TipoFactor = <cfqueryparam cfsqltype="cf_sql_varchar" value="Cuota">,
					TasaOCuota = <cfqueryparam cfsqltype="cf_sql_float" value="#form.IValorFijoIEPS#">
				<cfelseif IsDefined('form.TCIMPUESTOIEPS') and len(trim(form.TCIMPUESTOIEPS)) gt 0 and IsDefined('form.ieps')><!--- IEPS TASA --->
					,ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="003">,
					TipoFactor = <cfqueryparam cfsqltype="cf_sql_varchar" value="Tasa">,
					TasaOCuota = <cfqueryparam cfsqltype="cf_sql_float" value="#form.TCValMaxIEPS#">
				<cfelseif IsDefined('form.TCImpuesto') and len(trim(form.TCIMPUESTO)) gt 0><!--- IVA --->
					,ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="002">,
					<!---ParaIvaExento | TipoFactor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCFactor#">,--->
					TipoFactor = <cfqueryparam cfsqltype="cf_sql_varchar" value="Tasa">,<!--- tasa --->
					TasaOCuota = <cfqueryparam cfsqltype="cf_sql_float" value="#form.TCValMax#">
				</cfif>
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery>

	<!--- IDENTIFICAMOS SI EXISTE LA TABLA INTERMEDIA ---->
		<cfquery name="rsDiot" datasource="#Session.DSN#">
			select DIOTivacodigo
			from ImpuestoDIOT
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery>

		<cfif Form.DIOTcodigo eq '' and not isdefined('Form.ieps')>

			<cfquery name="rsDiot" datasource="#Session.DSN#">
				delete ImpuestoDIOT
				where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>

		<cfelseif Form.DIOTcodigo neq ''>

			<cfif rsDiot.recordcount gt 0 >
				<cfquery name="updateDiot" datasource="#Session.DSN#">
					update ImpuestoDIOT
						set DIOTivacodigo = <cfqueryparam value="#Form.DIOTcodigo#" cfsqltype="cf_sql_char">
					where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
				</cfquery>
			<cfelse>
				<cfquery name="insertDiot" datasource="#Session.DSN#">
					insert into ImpuestoDIOT (Icodigo,Ecodigo,DIOTivacodigo,BMUsucodigo)
						values(<cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
							   <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							   <cfif isdefined("Form.DIOTcodigo") and trim(Form.DIOTcodigo) NEQ "">
								   <cfqueryparam value="#Form.DIOTcodigo#" cfsqltype="cf_sql_char">,
								<cfelse>
									null,
							   </cfif>
							   <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">
								)
				</cfquery>
			</cfif>
		</cfif>

       </cftransaction>
		<cfset modo="CAMBIO">

	</cfif>
</cfif>

<cfoutput>
<form action="<cfif isdefined("action")>#action#<cfelse>Impuestos.cfm</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Icodigo" type="hidden" value="<cfif isdefined("Form.Icodigo") and modo NEQ 'ALTA'>#Form.Icodigo#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


