<cfif isdefined("form.btnGrabar") >
	<cfquery datasource="#Session.DSN#" name="rsGastos">
		select c.Cid, c.Ecodigo, c.Ccodigo, c.Cdescripcion, c.Ctipo
		from Conceptos c
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
		  and Ctipo = 'G'
	</cfquery>
</cfif>
<cfset Action="">
<cfset Action="/cfmx/sif/iv/operacion/Transforma-form4.cfm">
<cfif isdefined("rsGastos")>
	<cftry>
	<cfquery name="ParametrosCG" datasource="#Session.DSN#">
		select Mcodigo from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfset monedaLocal = ParametrosCG.Mcodigo>	
		<cfloop query="rsGastos"> 
			<cfset campo = "form.campo_#rsGastos.Cid#">
			<cfif isdefined(campo)>
				<cfset contValor = Evaluate(campo)>
			</cfif>
			<cfif isdefined(campo) and Len(Trim(contValor)) NEQ 0>
				<cfquery datasource="#Session.DSN#" name="rsUPD_GP">
					update CPGastosProduccion 
					set GPmonto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
					,GPtipocambio = coalesce(GPtipocambio,1)
					,Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#monedaLocal#">
					where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
					  and Cid = <cfqueryparam value="#rsGastos.Cid#" cfsqltype="cf_sql_numeric">
						
					if @@rowcount = 0 
					begin	 
						insert into CPGastosProduccion (ETid, Cid ,GPmonto ,GPtipocambio , Mcodigo)
						values ( <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
						,<cfqueryparam value="#rsGastos.Cid#" cfsqltype="cf_sql_numeric">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#contValor#">
						,1
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#monedaLocal#">)
					end
				</cfquery>
			</cfif>
		</cfloop>
		
		<!--- Actualizacion del Monto de Costos de Produccion en el Encabezado de Transformacion --->
		<cfquery name="updEncabezado" datasource="#Session.DSN#">
			update ETransformacion
			set ETcostoProd = coalesce((
				select sum(GPmonto * GPtipocambio)
				from CPGastosProduccion
				where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			), 0.00)
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		</cfquery>
		
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>	
	<cfelseif isDefined("btnConsultar")>		
		<cfset Action="/cfmx/sif/iv/consultas/ConsultaGastos-SQL.cfm?ETid=#Form.ETid#">	
		
</cfif>			
<form action="<cfoutput>#Action#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
		<cfif isdefined("Form.btnGrabar")>
	   		<input name="Aplicar" type="hidden" value="<cfif isdefined("Form.btnGrabar")>#Form.btnGrabar#</cfif>">
		</cfif>
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
