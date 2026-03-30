	<!--- FUNCIONES--->
<cffunction access="private" name="prepararCorreo" output="true" returntype="string">
	<!--- PARÁMETROS--->
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="RCNid" required="yes" type="numeric">
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Boleta_Pago"
	Default="Comprobante de Pago"
	returnvariable="LB_Boleta"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_SalarioBruto"
	Default="Salario bruto"
	returnvariable="LB_SalarioBruto"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Retroactivos"
	Default="RETROACTIVOS"
	returnvariable="LB_Retroactivos"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Renta"
	Default="IMPUESTO RENTA EMPLEADOS"
	returnvariable="LB_Renta"/> 

	<cfquery name="nombre" datasource="#session.DSN#">
		select CSdescripcion as salario
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and CSsalariobase = 1
	</cfquery>
	<cfif isdefined("nombre") and nombre.RecordCount NEQ 0>
		<cfset LB_SalarioBruto = nombre.salario>
	</cfif>
	
	<cfset Titulo = "#LB_Boleta#: " & rsNomina.RCDescripcion>
	
	<!---Componente que trae llena el la tabla temporal con los datos que necesitamos--->
	<cfinvoke component="rh.Componentes.RH_BoletaPagoDatos" method="getConceptosPago" returnvariable="TMPConceptos">
		<cfinvokeargument name="CPid" value="#Arguments.RCNid#">
		<cfinvokeargument name="DEidList" value="#Arguments.DEid#">
		<cfinvokeargument name="Historico" value="no">
	</cfinvoke>
	
	<!---<cf_dumptable var="#TMPConceptos#">--->
	
	<cfquery name="ConceptosPago" datasource="#session.DSN#">
		select *
		from #TMPConceptos#
		where (	devengado != 0 or 
				deducido != 0 or
				neto != 0
				or montoconcepto != 0)
		order by orden,DEid,linea
	</cfquery>
	
	<!---<cfquery name="ConceptosPago" datasource="#session.DSN#">
		select 	* 
		from #TMPConceptos#
		where (	devengado != 0 or 
				deducido != 0 or
				neto != 0)
		order by DEid,linea
	</cfquery>--->
	
	<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
		select Mensaje from MensajeBoleta 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	</cfquery>
	
	<!--- ARMA EL EMAIL--->
	<cfset vb_pagebreak = false>
	<cfinclude template="../../expediente/consultas/FormatoBoletaPagoDosTercios.cfm">	
	
	<cfsavecontent variable="info">
		<cfoutput>
			#DETALLE#
		</cfoutput>
	</cfsavecontent>

	<cfreturn info>
</cffunction>

<cffunction access="private" name="enviarCorreo" output="true" returntype="boolean">
	<cfargument name="from" required="yes" type="string">
	<cfargument name="to" required="yes" type="string">
	<cfargument name="subject" required="yes" type="string">
	<cfargument name="message" required="yes" type="string">
	
	<!--- ENVÍA EL EMAIL --->
	
	<cfset errores = 0>
	
	<cftry>
		<cfquery datasource="asp">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.from)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.to)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
			 	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.message#">,
				1)
		</cfquery><!---
		<cfmail from="#Arguments.from#" to="#Arguments.to#" subject="#subject#" type="html">
			#Arguments.message#
		</cfmail>--->
		<cfcatch type="any">
			<cfset errores = errores + 1>
			<cfoutput>Error: Tipo: #cfcatch.type#, <br>Mensaje: #cfcatch.Message#, <br>Detalle: #cfcatch.Detail#</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cfreturn errores eq 0>
</cffunction>

<cffunction access="private" name="getRHPvalor" output="false" returntype="string">
	<cfargument name="Pcodigo" required="yes" type="string">
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = #Arguments.Pcodigo#
	</cfquery>
	<cfreturn rs.Pvalor>
</cffunction>

<cffunction access="private" name="getEmailFromAdmin" output="false" returntype="string">
	<cfargument name="UsucodigoAdmin" required="yes" type="numeric">
	<cfquery name="rs" datasource="asp">
		select b.Pemail1 as Email
		from Usuario a, DatosPersonales b
		where a.Usucodigo = #Arguments.UsucodigoAdmin#
		and a.datos_personales = b.datos_personales
	</cfquery>
	<cfreturn rs.Email>
</cffunction>

<cffunction access="private" name="getEmailFromJefe" output="false" returntype="string">
	<cfargument name="DEid" required="yes" type="numeric">
	
	<cfset mail = ''>
	<cfquery name="rsRHPid" datasource="#session.dsn#">
		select RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
			and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
	</cfquery>
	
	<cfif rsRHPid.RecordCount NEQ 0 and len(trim(rsRHPid.RHPid))>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid
			from RHPlazas 
			where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid.RHPid#">
		</cfquery>
		<cfif rsCFid.RecordCount NEQ 0 and len(trim(rsCFid.CFid))>		
			<cfquery name="rsRHPid2" datasource="#session.dsn#">
				select RHPid 
				from CFuncional 
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFid.CFid#">
			</cfquery>
	
			<cfif rsRHPid2.RecordCount NEQ 0 and len(trim(rsRHPid2.RHPid))>		
				<cfquery name="rsDEid" datasource="#session.dsn#">
					select min(DEid) as DEid
					from LineaTiempo 
					where Ecodigo = #session.Ecodigo#
						and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid2.RHPid#">
						and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
				</cfquery>
								
				<cfif rsDEid.RecordCount NEQ 0 and len(trim(rsDEid.DEid))>
					<cfquery name="rs" datasource="#session.dsn#">
						select DEemail as Email
						from DatosEmpleado 
						where DEid = #rsDEid.DEid#
					</cfquery>
					
				</cfif>
				<cfif isdefined("rs.Email") and rs.RecordCount NEQ 0 and len(trim(rs.Email))>
					<cfset mail = '#rs.Email#'>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfreturn mail>
	<!---
	<cfquery name="rs" datasource="#session.dsn#">
		declare @RHPid numeric,
			@CFid numeric,
			@DEid numeric
		
		select @RHPid = RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
		 and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		 
		select @CFid = CFid
		from RHPlazas 
		where RHPid = @RHPid
		 
		select @RHPid = RHPid 
		from CFuncional 
		where CFid = @CFid
		 
		select @DEid = min(DEid)
		from LineaTiempo 
		where Ecodigo = #session.Ecodigo#
		and RHPid = @RHPid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		
		select DEemail as Email
		from DatosEmpleado 
		where DEid = @DEid
	</cfquery>
	<cfreturn rs.Email>
	---->
</cffunction>
