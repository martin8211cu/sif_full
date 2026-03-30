<cfset modo = "ALTA">
<cfif isdefined("Form.btnAprobar") OR isdefined("Form.btnTraslado")>
	<cfif isdefined("form.TIPO") and form.TIPO EQ "TRASLADO"> 
        <cfquery datasource="#session.dsn#" name="Periodo">
            select Pvalor from Parametros
            where Ecodigo = #session.Ecodigo#
              and Pcodigo = 30
        </cfquery>
        <!---Obtiene los datos del NRP para el NAP --->
        <cfquery name="rsNRP" datasource="#session.dsn#">
            select CPNRPnum, CPNRPfecha, CPNRPmoduloOri, CPCano, CPCmes
            from CPNRP
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
        </cfquery>
        <cfif rsNRP.CPCano GE Periodo.Pvalor>
            <cfinvoke 
                     component="sif.Componentes.PRES_Presupuesto"
                     method="CreaTablaIntPresupuesto">
                        <cfinvokeargument name="Conexion"				value="#session.dsn#"/>
                        <cfinvokeargument name="conIndices"				value="false"/>
                        <cfinvokeargument name="conIdentity"			value="true"/>
                        <cfinvokeargument name="ContaPresupuestaria"	value="true"/>
            </cfinvoke>
         
            <!---Inserta Los Traslados de Cuenta Origen --->
            <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
                insert into #Request.intPresupuesto# (
                    ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento,
                    AnoDocumento,
                    MesDocumento,
                    
                    <!---NumeroLinea,---> 
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
                
                select 'PRCO' as ModuloOrigen,
                       a.CPNRPnum as NumeroDocumento,
                       'Traslado' as NumeroReferencia,
                       a.CPNRPfecha as FechaDocumento,
                       a.CPCano as AnoDocumento,
                       a.CPCmes as MesDocumento,
                       
                       <!---b.CPNRPTsecuencia / 100 as NumeroLinea,--->
                       a.CPPid,
                       a.CPCano,
                       a.CPCmes,
                       b.CPcuenta,
                       b.Ocodigo,
                       'T' as TipoMovimiento,
                       c.Mcodigo,
                       (b.CPNRPTmonto * -1) as Monto,
                       1.00 as TipoCambio,
                       (b.CPNRPTmonto * -1) as MontoOroigen,
                       null as NAPreferencia,
                       null as LINreferencia
                from CPNRP a
                inner join CPNRPtrasladoOri b on a.Ecodigo = b.Ecodigo and a.CPNRPnum = b.CPNRPnum
                inner join CPresupuestoPeriodo c on a.Ecodigo = c.Ecodigo and a.CPPid = c.CPPid
                where a.CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNRPnum#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
            
            <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
                insert into #Request.intPresupuesto# (
                    ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento,
                    AnoDocumento,
                    MesDocumento,
                    
                    <!---NumeroLinea,---> 
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
                
                select 'PRCO' as ModuloOrigen,
                       a.CPNRPnum as NumeroDocumento,
                       'Traslado' as NumeroReferencia,
                       a.CPNRPfecha as FechaDocumento,
                       a.CPCano as AnoDocumento,
                       a.CPCmes as MesDocumento,
                       
                       <!---b.CPNRPDlinea as NumeroLinea,--->
                       a.CPPid,
                       a.CPCano,
                       a.CPCmes,
                       b.CPcuenta,
                       b.Ocodigo,
                       'T' as TipoMovimiento,
                       c.Mcodigo,
                       (b.CPNRPDmonto * 1) as Monto,
                       1.00 as TipoCambio,
                       (b.CPNRPDmonto * 1) as MontoOroigen,
                       null as NAPreferencia,
                       null as LINreferencia
                from CPNRP a
                inner join CPNRPdetalle b on a.Ecodigo = b.Ecodigo and a.CPNRPnum = b.CPNRPnum
                inner join CPresupuestoPeriodo c on a.Ecodigo = c.Ecodigo and a.CPPid = c.CPPid
                where a.CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPNRPnum#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and b.CPCPtipoControl = 2
                and b.CPNRPDconExceso = 1
            </cfquery>
            <cfinvoke 
                     component="sif.Componentes.PRES_Presupuesto"
                     method="ControlPresupuestario">
                        <cfinvokeargument name="ModuloOrigen"		value="PRCO"/>
                        <cfinvokeargument name="NumeroDocumento"	value="#Form.CPNRPnum#"/>
                        <cfinvokeargument name="NumeroReferencia"	value="#rsNRP.CPNRPmoduloOri#"/>
                        <cfinvokeargument name="FechaDocumento"		value="#rsNRP.CPNRPfecha#"/>
                        <cfinvokeargument name="AnoDocumento"		value="#rsNRP.CPCano#"/>
                        <cfinvokeargument name="MesDocumento"		value="#rsNRP.CPCmes#"/>
            </cfinvoke>
        </cfif>
    </cfif>
    
    <cfinvoke 
			 component="sif.Componentes.PRES_Presupuesto"
			 method="sbAprobarNRP">
				<cfinvokeargument name="Conexion"		value="#session.dsn#"/>
				<cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
				<cfinvokeargument name="CPNRPnum"		value="#Form.CPNRPnum#"/>
				<cfinvokeargument name="conTraslado"	value="#isdefined('Form.btnTraslado')#"/>
	</cfinvoke>
	<cfset form.CPNRPnum  = "">
<cfelseif isdefined("Form.btnCancelar")>
	<cftransaction>
		<cfquery name="ABC_DocsReserva" datasource="#Session.DSN#">
			select CPNRPtipoCancela
			  from CPNRP
			 where Ecodigo = #Session.Ecodigo#
			   and CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
		</cfquery>
		<cfif ABC_DocsReserva.CPNRPtipoCancela EQ "0">
			<cfquery name="ABC_DocsReserva" datasource="#Session.DSN#">
				update CPNRP
				   set CPNRPtipoCancela = 10,
					   UsucodigoCancela = #session.usucodigo#,
					   CPNRPfechaCancela = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where Ecodigo = #Session.Ecodigo#
				and CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
			</cfquery>
			<cfinvoke 
			 component="sif.Componentes.PRES_Presupuesto"
			 method="sbCancelaPendientesNrp">
				<cfinvokeargument name="NRP" value="#Form.CPNRPnum#"/>
				<cfinvokeargument name="Conexion" value="#session.dsn#"/>
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			</cfinvoke>
		</cfif>
	</cftransaction>
<cfelseif isdefined("Form.AltaTR")>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select coalesce(max(CPNRPTsecuencia),0)+100 as sec
		  from CPNRPtrasladoOri
		 where Ecodigo	= #session.Ecodigo#
		   and CPNRPnum	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPNRPtrasladoOri (
			Ecodigo, CPNRPnum, CPNRPTsecuencia, CPcuenta, Ocodigo, CPPid, CPCano, CPCmes, CPNRPTmonto, BMUsucodigo
		)
		values (
			#session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">,
			#rsSQL.sec#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCano#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCmes#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(Form.CPNRPTmonto,",","","ALL")#" scale="2">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		)
	</cfquery>
<cfelseif isdefined("Form.nuevoTR")>
<cfelseif isdefined("Form.cambioTR")>
	<cfquery datasource="#Session.DSN#">
		update CPNRPtrasladoOri
		   set CPcuenta		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">,
		       Ocodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">,
			   CPNRPTmonto	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(Form.CPNRPTmonto,",","","ALL")#" scale="2">
			<cfif Form.CPNRPTsecuencia NEQ Form.CPNRPTsecuencia_Ant>
				, CPNRPTsecuencia 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPTsecuencia#">
			</cfif>
		 where Ecodigo			= #session.Ecodigo#
		   and CPNRPnum			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
		   and CPNRPTsecuencia 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPTsecuencia_Ant#">
	</cfquery>
<cfelseif isdefined("Form.bajaTR")>
	<cfquery datasource="#Session.DSN#">
		delete from CPNRPtrasladoOri
		 where Ecodigo			= #session.Ecodigo#
		   and CPNRPnum			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
		   and CPNRPTsecuencia 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPTsecuencia_Ant#">
	</cfquery>
<cfelse>
	<cfset form.CPNRPnum  = "">
</cfif>

<cfoutput>
<form action="<cfif form.Tipo EQ "TRASLADO">trasladosNRP.cfm<cfelseif form.Tipo EQ "APRUEBA">autorizacionNRP.cfm<cfelse>cancelacionNRP.cfm</cfif>" method="post" name="sql">
<input type="hidden" name="CPNRPnum" value="#form.CPNRPnum#">
<cfif isdefined("form.tab")>
<input type="hidden" name="tab" value="#form.tab#">
</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
