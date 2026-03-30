<cfparam name="url.OP" default="">
<cfif not listFindNoCase("C,L,G",url.OP)>
	<cflocation url="regeneraCubos.cfm?OP=C">
</cfif>

<cfif not isdefined("url.fromWizard")>
	<cfoutput> 
	sintaxis: <BR>
		...regeneraCubos.cfm?OP=C		Contar (Default)<BR>
		...regeneraCubos.cfm?OP=L		Listar<BR>
		...regeneraCubos.cfm?OP=G		Generar<BR>
	</cfoutput>
</cfif>

<cfsetting requesttimeout="36000">
<cfif not isdefined("url.fromWizard")>
	<cfflush interval="128">
</cfif>

<cfif not isdefined("url.fromWizard")>
<cfoutput> 
	<BR><BR><BR>
	***********************************************************************<BR>
	**************************** CUBO FINANCIERO **************************<BR>
	***********************************************************************<BR>
</cfoutput>
</cfif>

<cfset LvarError = false>
<cf_dbfunction name="length" 	args="rtrim(CFformato)"					returnvariable="LvarLen1">
<cf_dbfunction name="sreplace" 	args="rtrim(CFformato),'-',rtrim(' ')"	returnvariable="LvarRep2">
<cf_dbfunction name="length" 	args="#LvarRep2#"						returnvariable="LvarLen2" delimiters=";">
<cfset LvarNivs = "#LvarLen1#-#LvarLen2#+1">
<cfquery datasource="#session.dsn#">
	update CFinanciera set CFmovimiento = 'N' where CFformato = Cmayor
</cfquery>
<cfquery name="rsCuentas" datasource="#session.dsn#">
	<cfif url.OP EQ "C">
		select count(1) as cantidad
	<cfelse>
		select p.Ecodigo, p.CFcuenta, vg.PCEMid, coalesce(me.PCEMformatoC, p.CFformato) as TamanoFormato, p.CFformato,
			(
				select count(1) 
				  from PCDCatalogoCuentaF
				 where CFcuenta=p.CFcuenta
			) as EnCubo

	</cfif>
	  from CFinanciera p 
			inner join CPVigencia vg
					left join PCEMascaras me
					   on me.PCEMid=vg.PCEMid
			   on vg.Ecodigo=p.Ecodigo and vg.CPVid = p.CPVid and vg.Cmayor=p.Cmayor
	 where p.Ecodigo = #session.Ecodigo#
	   and p.CFmovimiento='S' 
	   and
			(
				select count(1) 
				  from PCDCatalogoCuentaF
				 where CFcuenta=p.CFcuenta
			) <> #PreserveSingleQuotes(LvarNivs)#
</cfquery>
<cfif not isdefined("url.fromWizard")>
	<cfdump var="#rsCuentas#">
</cfif>
<cfif url.OP EQ "G">
	<cfloop query="rsCuentas">
		<cftransaction>
			<cfset LvarNivel = len(TamanoFormato) - len(replace(TamanoFormato,"-","","ALL"))>
			<cfset LvarNivel1 = LvarNivel>
			<cfset LvarCuentaNiv = rsCuentas.CFcuenta>
			<cfloop condition="LvarCuentaNiv NEQ '' AND LvarNivel GT -100">
				<cfquery name="rsNivel" datasource="#session.dsn#">
					select p.CFcuenta, cd.PCEcatid, p.PCDcatid, p.CFpadre
					  from CFinanciera p 
							left join PCDCatalogo cd
									inner join PCECatalogo ce
									   on ce.PCEcatid = cd.PCEcatid
							   on cd.PCDcatid = p.PCDcatid
					 where p.CFcuenta = #LvarCuentaNiv#
				</cfquery>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into PCDCatalogoCuentaF (CFcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, CFcuentaniv)
					values (
						#rsCuentas.CFcuenta#,
						<cfif rsNivel.PCEcatid EQ "">null<cfelse>#rsNivel.PCEcatid#</cfif>,
						<cfif rsNivel.PCDcatid EQ "">null<cfelse>#rsNivel.PCDcatid#</cfif>,
						<cfif rsCuentas.PCEMid EQ "">null<cfelse>#rsCuentas.PCEMid#</cfif>,
						#LvarNivel#,
						<cfif rsNivel.CFcuenta EQ "">null<cfelse>#rsNivel.CFcuenta#</cfif>
						)
				</cfquery>
				<cfset LvarCuentaNiv = rsNivel.CFpadre>
				<cfset LvarNivel = LvarNivel - 1>
			</cfloop>
			<cfif not isdefined("url.fromWizard")>
				<cfoutput>CFcuenta: #rsCuentas.CFcuenta# #rsCuentas.CFformato#<BR></cfoutput>
			</cfif>
			<cfif LvarNivel EQ -100>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp; ********** ERROR LA CUENTA TIENE PADRE CICLICO #LvarNivel1# ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>
			<cfelseif LvarNivel NEQ -1>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp; ********** ERROR LA CUENTA TIENE UN NUMERO DE NIVELES INCORRECTOS #LvarNivel1# ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>	
			<cfelse>
				<cfif not isdefined("url.fromWizard")>
					<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp; **OK**<BR></cfoutput>
				</cfif>
			</cfif>
		</cftransaction>
	</cfloop>
</cfif>

<cfif not isdefined("url.fromWizard")>
	<cfoutput> 
		<BR><BR><BR>
		*********************************************************************<BR>
		**************************** CUBO CONTABLE **************************<BR>
		*********************************************************************<BR>
	</cfoutput>
</cfif>
<cfset LvarError = false>
<cf_dbfunction name="length" 	args="rtrim(Cformato)"					returnvariable="LvarLen1">
<cf_dbfunction name="sreplace" 	args="rtrim(Cformato),'-',rtrim(' ')"	returnvariable="LvarRep2">
<cf_dbfunction name="length" 	args="#LvarRep2#"						returnvariable="LvarLen2" delimiters=";">
<cfset LvarNivs = "#LvarLen1#-#LvarLen2#+1">
<cfquery datasource="#session.dsn#">
	update CContables set Cmovimiento = 'N' where Cformato = Cmayor
</cfquery>
<cfquery name="rsCuentas" datasource="#session.dsn#">
	<cfif url.OP EQ "C">
		select count(1) as cantidad
	<cfelse>
		select p.Ecodigo, p.Ccuenta, vg.PCEMid, coalesce(me.PCEMformatoC, p.Cformato) as TamanoFormato, p.Cformato,
			(
				select count(1) 
				  from PCDCatalogoCuenta 
				 where Ccuenta=p.Ccuenta
			) as EnCubo

	</cfif>
	  from CContables p 
			inner join CFinanciera f
				on f.Ccuenta = p.Ccuenta
			inner join CPVigencia vg
					left join PCEMascaras me
					   on me.PCEMid=vg.PCEMid
			   on vg.Ecodigo=f.Ecodigo and vg.CPVid = f.CPVid and vg.Cmayor=f.Cmayor
	 where p.Ecodigo = #session.Ecodigo#
	   and p.Cmovimiento='S' 
	   and
			(
				select count(1) 
				  from PCDCatalogoCuenta 
				 where Ccuenta=p.Ccuenta
			) <> #PreserveSingleQuotes(LvarNivs)#
</cfquery>
<cfif not isdefined("url.fromWizard")>
	<cfdump var="#rsCuentas#">
</cfif>
<cfif url.OP EQ "G">
	<cfloop query="rsCuentas">
		<cftransaction>
			<cfset LvarNivel = len(TamanoFormato) - len(replace(TamanoFormato,"-","","ALL"))>
			<cfset LvarCuentaNiv = rsCuentas.Ccuenta>
			<cfloop condition="LvarCuentaNiv NEQ '' AND LvarNivel GT -100">
				<cfquery name="rsNivel" datasource="#session.dsn#">
					select p.Ccuenta, cd.PCEcatid, p.PCDcatid, p.Cpadre
					  from CContables p 
							left join PCDCatalogo cd
									inner join PCECatalogo ce
									   on ce.PCEcatid = cd.PCEcatid
							   on cd.PCDcatid = p.PCDcatid
					 where p.Ccuenta = #LvarCuentaNiv#
				</cfquery>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into PCDCatalogoCuenta (Ccuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, Ccuentaniv)
					values (
						#rsCuentas.Ccuenta#,
						<cfif rsNivel.PCEcatid EQ "">null<cfelse>#rsNivel.PCEcatid#</cfif>,
						<cfif rsNivel.PCDcatid EQ "">null<cfelse>#rsNivel.PCDcatid#</cfif>,
						<cfif rsCuentas.PCEMid EQ "">null<cfelse>#rsCuentas.PCEMid#</cfif>,
						#LvarNivel#,
						<cfif rsNivel.Ccuenta EQ "">null<cfelse>#rsNivel.Ccuenta#</cfif>
						)
				</cfquery>
				<cfset LvarCuentaNiv = rsNivel.Cpadre>
				<cfset LvarNivel = LvarNivel - 1>
			</cfloop>
			<cfif not isdefined("url.fromWizard")>
				<cfoutput>Ccuenta: #rsCuentas.Ccuenta# #rsCuentas.Cformato#<BR></cfoutput>
			</cfif>
			<cfif LvarNivel EQ -100>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp; ********** ERROR LA CUENTA TIENE PADRE CICLICO #LvarNivel1# ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>
			<cfelseif LvarNivel NEQ -1>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;  ********** ERROR LA CUENTA TIENE UN NUMERO DE NIVELES INCORRECTOS ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>
			<cfelse>
				<cfif not isdefined("url.fromWizard")>
					<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;  **OK**<BR></cfoutput>
				</cfif>
			</cfif>
		</cftransaction>
	</cfloop>
</cfif>


<cfif not isdefined("url.fromWizard")>
	<cfoutput> 
		<BR><BR><BR>
		************************************************************************<BR>
		**************************** CUBO PRESUPUESTO **************************<BR>
		************************************************************************<BR>
	</cfoutput>
</cfif>

<cfset LvarError = false>
<cf_dbfunction name="length" 	args="rtrim(CPformato)"					returnvariable="LvarLen1">
<cf_dbfunction name="sreplace" 	args="rtrim(CPformato),'-',rtrim(' ')"	returnvariable="LvarRep2">
<cf_dbfunction name="length" 	args="#LvarRep2#"						returnvariable="LvarLen2" delimiters=";">
<cfset LvarNivs = "#LvarLen1#-#LvarLen2#+1">
<cfquery datasource="#session.dsn#">
	update CPresupuesto set CPmovimiento = 'N' where CPformato = Cmayor
</cfquery>
<cfquery name="rsCuentas" datasource="#session.dsn#">
	<cfif url.OP EQ "C">
		select count(1) as cantidad
	<cfelse>
		select p.Ecodigo, p.CPcuenta, vg.PCEMid, coalesce(me.PCEMformatoC, p.CPformato) as TamanoFormato, p.CPformato,
			(
				select count(1) 
				  from PCDCatalogoCuentaP
				 where CPcuenta=p.CPcuenta
			) as EnCubo

	</cfif>
	  from CPresupuesto p 
			inner join CPVigencia vg
					left join PCEMascaras me
					   on me.PCEMid=vg.PCEMid
			   on vg.Ecodigo=p.Ecodigo and vg.CPVid = p.CPVid and vg.Cmayor=p.Cmayor
	 where p.Ecodigo = #session.Ecodigo#
	   and p.CPmovimiento='S' 
	   and
			(
				select count(1) 
				  from PCDCatalogoCuentaP
				 where CPcuenta=p.CPcuenta
			) <> #PreserveSingleQuotes(LvarNivs)#
</cfquery>
<cfif not isdefined("url.fromWizard")>
	<cfdump var="#rsCuentas#">
</cfif>	
<cfif url.OP EQ "G">
	<cfloop query="rsCuentas">
		<cftransaction>
			<cfset LvarNivel = len(TamanoFormato) - len(replace(TamanoFormato,"-","","ALL"))>
			<cfset LvarCuentaNiv = rsCuentas.CPcuenta>
			<cfloop condition="LvarCuentaNiv NEQ '' AND LvarNivel GT -100">
				<cfquery name="rsNivel" datasource="#session.dsn#">
					select p.CPcuenta, cd.PCEcatid, p.PCDcatid, p.CPpadre
					  from CPresupuesto p 
							left join PCDCatalogo cd
									inner join PCECatalogo ce
									   on ce.PCEcatid = cd.PCEcatid
							   on cd.PCDcatid = p.PCDcatid
					 where p.CPcuenta = #LvarCuentaNiv#
				</cfquery>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into PCDCatalogoCuentaP (CPcuenta, PCEcatid, PCDcatid, PCEMid, PCDCniv, CPcuentaniv)
					values (
						#rsCuentas.CPcuenta#,
						<cfif rsNivel.PCEcatid EQ "">null<cfelse>#rsNivel.PCEcatid#</cfif>,
						<cfif rsNivel.PCDcatid EQ "">null<cfelse>#rsNivel.PCDcatid#</cfif>,
						<cfif rsCuentas.PCEMid EQ "">null<cfelse>#rsCuentas.PCEMid#</cfif>,
						#LvarNivel#,
						<cfif rsNivel.CPcuenta EQ "">null<cfelse>#rsNivel.CPcuenta#</cfif>
						)
				</cfquery>
				<cfset LvarCuentaNiv = rsNivel.CPpadre>
				<cfset LvarNivel = LvarNivel - 1>
			</cfloop>
			<cfoutput>CPcuenta: #rsCuentas.CPcuenta# #rsCuentas.CPformato#<BR></cfoutput>
			<cfif LvarNivel EQ -100>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp; ********** ERROR LA CUENTA TIENE PADRE CICLICO #LvarNivel1# ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>
			<cfelseif LvarNivel NEQ -1>
				<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;  ********** ERROR LA CUENTA TIENE UN NUMERO DE NIVELES INCORRECTOS ***********<BR></cfoutput>
				<cfset LvarError = true>
				<cfif not isdefined("url.fromWizard")>
					<cftransaction action="rollback"/>
				<cfelse>
					<cfabort>	
				</cfif>	
			<cfelse>
				<cfif not isdefined("url.fromWizard")>
					<cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;  **OK**<BR></cfoutput>
				</cfif>
			</cfif>
		</cftransaction>
	</cfloop>
</cfif>
