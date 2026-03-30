<cfparam name="url.ERNid" type="numeric">
<cfparam name="url.Bid" type="numeric">

<!--- prefijo para indicar si se trata de nominas en historico o en proceso--->
<cfset pre="">
<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "h">
	<cfset pre="H">
</cfif>

<!--- variable de concatenacion--->	
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!---
<cf_dbfunction name="sPart"	args="a.CBcc|1|3" returnvariable="varT_Cuenta" delimiters="|">

<cfquery name="ERR" datasource="#session.DSN#">
	SELECT coalesce(a.#pre#DRNnombre,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido1,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido2,'') as Nombre,
			 #varT_Cuenta# as T_Cuenta,
			 coalesce(a.CBcc,'-1') as N_Cuenta,
			 1 as Subcuenta,
			 1 as T_Saldo,
			 a.#pre#DRNliquido as Monto,
			 b.#pre#ERNdescripcion as Detalle,
			 a.#pre#DRIdentificacion as Ref_1,
			 coalesce(a.#pre#DRNnombre,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido1,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido2,'') as Ref_2,
			 0 as Cod_Contable
	FROM  #pre#ERNomina b
		  inner join  #pre#DRNomina a
			on a.ERNid = b.ERNid
			and a.ERNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
</cfquery>--->


<cfquery name="ERR" datasource="#session.DSN#">
	SELECT 	coalesce(a.CBcc,'-1') as N_Cuenta,
					1 as Subcuenta,
			 		1 as T_Saldo,	
			  		a.#pre#DRNliquido as Monto,
		    		b.#pre#ERNdescripcion as Detalle,
			 		a.#pre#DRIdentificacion as Ref_1,
					coalesce(a.#pre#DRNnombre,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido1,'') #_Cat# '' #_Cat# coalesce(a.#pre#DRNapellido2,'') as Ref_2,
			 		0 as Cod_Contable
	FROM  #pre#DRNomina a, #pre#ERNomina b
	WHERE  a.ERNid = b.ERNid
				AND a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				AND a.ERNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>


