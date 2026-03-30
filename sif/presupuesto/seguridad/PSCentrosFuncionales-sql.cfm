<cfparam name="Action" default="PSCentrosFuncionales.cfm"/>
<cfparam name="Form.CFpk" type="numeric">
<cfif isdefined("form.Agregar")>
	<cffunction name="insertarMascara" access="private" output="false">
		<cfargument name="descripcion" required="yes" type="string">
		<cfargument name="mascara" required="yes" type="string">
		<cfset Arguments.Mascara = trim(Replace(Arguments.Mascara,'?','_','all'))>

		<!--- Convierte la mascara financiera en mascara presupuesto --->
		<cfset LvarCmayor = mid (Arguments.Mascara,1,4)>
		<cfif find("_",LvarCmayor) GT 0>
			<cfreturn>
		</cfif>
		<cfset LvarMascara = "">
		<cfset LvarIni = 6>
		<cfquery name="rsMascara" datasource="#session.dsn#">
			select m.PCNlongitud, m.PCNpresupuesto
			from PCNivelMascara m, CPVigencia v
			where v.Ecodigo = #Session.Ecodigo#
			  and v.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCmayor#">
			  and #DateFormat(now(),"YYYYMM")#
			  		between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
			  and m.PCEMid = v.PCEMid
			order by m.PCNid
		</cfquery>
		<cfloop query="rsMascara">
			<cfif mid(Arguments.Mascara,LvarIni-1,1) NEQ "-" or LvarIni+rsMascara.PCNlongitud-1 GT len(Arguments.Mascara) or find("-",mid(Arguments.Mascara,LvarIni,rsMascara.PCNlongitud)) GT 0>
				<cfset LvarError = "1">
				<cfset LvarMascara = "">
				<cfbreak>
			</cfif>
			<cfif PCNpresupuesto EQ 1>
				<cfif LvarMascara EQ "">
					<cfset LvarMascara = LvarCmayor>
				</cfif>
				<cfset LvarMascara = LvarMascara & "-" & mid(Arguments.Mascara,LvarIni,rsMascara.PCNlongitud)>
			</cfif>
			<cfset LvarIni = LvarIni + rsMascara.PCNlongitud + 1>
		</cfloop>
		<!------------------------------------------------------------------------->

		<cfif LvarMascara EQ "">
			<cfreturn>
		</cfif>
		<cfset LvarMascara = LvarMascara & "%">
		<cfquery name="rsCheck1" datasource="#session.dsn#">
			select count(1) as cantidad
			from CPSeguridadMascarasCtasP 
			where Ecodigo = #Session.Ecodigo#
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
			  and CPSMascaraP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascara#">
		</cfquery>
		<cfif rsCheck1.cantidad eq 0>
			<cfquery datasource="#session.dsn#">
				insert into CPSeguridadMascarasCtasP 
				(Ecodigo, CFid, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, BMUsucodigo)
				values(
					#Session.Ecodigo#, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascara#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.descripcion#">, 
					1,1,1,1, 
					#session.usucodigo# 
				)
			</cfquery>
		</cfif>
	</cffunction>
	<cfquery name="rsCuentas" datasource="#session.dsn#">
		select a.CFcuentac, a.CFcuentainversion, a.CFcuentainventario
		from CFuncional a 
		where a.Ecodigo = #Session.Ecodigo#
			and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
	</cfquery>
	<cfset insertarMascara('Cuenta de Gasto', 		rsCuentas.CFcuentac)>
	<cfset insertarMascara('Cuenta de Inversión', 	rsCuentas.CFcuentainversion)>
	<cfset insertarMascara('Cuenta de Inventario', 	rsCuentas.CFcuentainventario)>
</cfif>
<cfif isdefined('LvarError')>
<cflocation url="#Action#?CFpk=#Form.CFpk#&ERR=1">
<cfelse>
<cflocation url="#Action#?CFpk=#Form.CFpk#">
</cfif>
