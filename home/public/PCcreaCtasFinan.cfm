<cfsetting requesttimeout="36000">
<cfif not isdefined("url.Cmayor") OR url.Cmayor EQ "">
	<cfthrow message="Falta indicar cuenta mayor">
</cfif>
<cfquery name="rsMayor" datasource="#session.dsn#">
	select c.Cmayor, c.Cdescripcion, c.PCEMid, m.PCEMplanCtas
	  from CtasMayor c
		inner join PCEMascaras m 
		 on m.PCEMid = c.PCEMid
	 where c.Ecodigo	= #session.Ecodigo#
	   and c.Cmayor		= '#url.Cmayor#'
</cfquery>
<cfif rsMayor.Cmayor EQ "">
	<cfthrow message="Cuenta mayor no existe">
</cfif>

<cfif rsMayor.PCEMplanCtas NEQ "1">
	<cfthrow message="Cuenta mayor no tiene plan de cuentas">
</cfif>

<cfquery name="rsNiveles" datasource="#session.dsn#">
	select PCNid, PCEcatid, PCNdep, PCNlongitud, PCNcontabilidad, PCNpresupuesto
	  from PCNivelMascara m 
	 where m.PCEMid = #rsMayor.PCEMid#
	order by PCNid
</cfquery>


<cf_dbtemp name="Gctas_V0" returnvariable="CTAS" datasource="#session.dsn#" temp="false">
	<cf_dbtempcol name="formato"	    type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="des"			type="varchar(900)"	mandatory="no">
	<cf_dbtempcol name="niv"	    	type="integer"		mandatory="yes">
	<cf_dbtempcol name="ref"			type="numeric"		mandatory="no">
</cf_dbtemp>

<!--- Inserta nivel 0 = Cta Mayor --->
<cfquery datasource="#session.dsn#">
	insert into #CTAS#
		( formato, des, niv, ref )
	values ('#rsMayor.Cmayor#', '#rsMayor.Cdescripcion#', 0, null)
</cfquery>


<cf_dbfunction name="OP_concat" returnvariable="CONCAT" datasource="#session.dsn#">

<cf_dbfunction name="sPart" args="formato,1,4" returnvariable="LvarConversion" datasource="#session.dsn#">
<cfset LvarPto=5>
<cfset LvarSubstituir = false>
<cfloop query="rsNiveles">
	<cfif rsNiveles.PCNpresupuesto EQ 1>
		<cf_dbfunction name="sPart" args="formato,#LvarPto#,#rsNiveles.PCNlongitud+1#" returnvariable="LvarSubstr" datasource="#session.dsn#">
		<cfset LvarConversion &= " #CONCAT# #LvarSubstr#">
	<cfelseif isdefined("LvarPRESUPUESTO")>
		<cfset LvarSubstituir = true>
	</cfif>
	<cfset LvarPto += rsNiveles.PCNlongitud+1>

	<cfset LvarNiv = rsNiveles.PCNid>
	<cfset LvarNivA = LvarNiv - 1>
	<!--- Inserta nivel PCNid --->
	<cfif rsNiveles.PCNdep EQ "">
		<cfquery datasource="#session.dsn#">
			insert into #CTAS#
				( formato, des, niv, ref )
			select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
					,c.des 		
						<cfif NOT LvarSubstituir OR rsNiveles.PCNpresupuesto EQ 1>
							#CONCAT# ', ' #CONCAT# v.PCDdescripcion
						</cfif>
				   	,#LvarNiv#, v.PCEcatidref
			  from #CTAS# c
				inner join PCDCatalogo v
					 on PCEcatid = #rsNiveles.PCEcatid#
					and (v.Ecodigo is null or v.Ecodigo = #session.Ecodigo#)
			 where c.niv = #LvarNivA#
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into #CTAS#
				( formato, des, niv, ref )
			select   c.formato 	#CONCAT# '-' #CONCAT# v.PCDvalor
					,c.des 		
						<cfif NOT LvarSubstituir OR rsNiveles.PCNpresupuesto EQ 1>
							#CONCAT# ', ' #CONCAT# v.PCDdescripcion
						</cfif>
				   	,#LvarNiv#, v.PCEcatidref
			  from #CTAS# c
				inner join #CTAS# d
					inner join PCDCatalogo v
						 on PCEcatid = d.ref
						and (v.Ecodigo is null or v.Ecodigo = #session.Ecodigo#)
					 on d.niv = #rsNiveles.PCNdep#
					 and c.formato like d.formato #CONCAT# '%'
			 where c.niv = #LvarNivA#
		</cfquery>
	</cfif>
</cfloop>

<cfquery name="rsSQL" datasource="#session.dsn#">
	delete from #CTAS#
	 where niv < #rsNiveles.recordCount#
</cfquery>

<cfif LvarSubstituir>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update #CTAS#
		   set formato = #LvarConversion#
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select formato, min(des) as descripcion
		  from #CTAS#
		group by formato
	</cfquery>
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select formato, des as descripcion
		  from #CTAS#
		 order by formato
	</cfquery>
</cfif>

<cf_queryToFile query="#rsSQL#" filename="ctasPresupuesto.xls">