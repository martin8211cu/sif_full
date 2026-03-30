<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rsMascara" datasource="#session.DSN#">
	select WTCmascara 
	from WTContable 
	where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
</cfquery>

<cfset mascara = trim(rsMascara.WTCmascara) >

<cfquery name="insert1" datasource="#session.DSN#">
	insert into CtasMayor ( Ecodigo, Cmayor, Cdescripcion, Ctipo, Cbalancen, CEcodigo, Cmascara )
	select #session.Ecodigo# , rtrim(b.Cformato), b.Cdescripcion, b.Ctipo, b.Cbalancen, #session.CEcodigo#, a.WTCmascara
	from WTContable a
		inner join WEContable b
			on a.WTCid = b.WTCid
	where a.WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	  and <cf_dbfunction name="length" args="ltrim(rtrim(b.Cformato))"> < 5
</cfquery>	
<cfset AnoMes = datepart('yyyy', Now()) & RepeatString('0', 2- Len(datepart('m', Now()))) & datepart('m', Now()) >
<cfquery name="insert2" datasource="#session.DSN#">
	insert into CPVigencia(Ecodigo, Cmayor, CPVdesde, CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio)
	select #session.Ecodigo#, rtrim(b.Cformato),
		#Now()#,
		#CreateDate(6100,1,1)#,
		#DateFormat(Now(),'yyyymm')#,
		610001,
		'#mascara#', 0
	from WTContable a
		inner join WEContable b
			on a.WTCid = b.WTCid
	where a.WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
	  and <cf_dbfunction name="length"	args="ltrim(rtrim(b.Cformato))"> < 5
</cfquery>	

<cfquery name="insert3" datasource="#session.DSN#">
	insert into CContables( Ecodigo, Cmayor, Cformato,Cdescripcion, CdescripcionF, Cmovimiento, Cbalancen, Cbalancenormal )
	select #session.Ecodigo#, <cf_dbfunction name="sPart" args="rtrim(b.Cformato),1,4">, b.Cformato, b.Cdescripcion, b.CdescripcionF, b.Cmovimiento, b.Cbalancen, b.Cbalancenormal
	from WTContable a
		inner join WEContable b
			on a.WTCid = b.WTCid
	where a.WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
</cfquery>	
	  
<cfquery name="insert4" datasource="#session.DSN#">
	insert into  CFinanciera(CPVid, Ecodigo, Cmayor, CFformato, CFdescripcion, CFdescripcionF, CFmovimiento, Ccuenta)
	select c.CPVid, a.Ecodigo, a.Cmayor, a.Cformato, a.Cdescripcion, a.Cdescripcion, a.Cmovimiento, a.Ccuenta
	from CContables a
	inner join CtasMayor b
	on a.Ecodigo=b.Ecodigo
	   and a.Cmayor=b.Cmayor
	   and b.Ecodigo=#session.Ecodigo#
	inner join CPVigencia c
	on b.Ecodigo = c.Ecodigo   
	   and b.Cmayor = c.Cmayor
	   and c.Ecodigo=#session.Ecodigo#
	where a.Ecodigo=#session.Ecodigo#
</cfquery>	


	<!--- Determinar Padres CContables --->
	<cfquery name="CCpadres" datasource="#session.DSN#">
		update CContables
		set Cpadre = (  select max(y.Ccuenta)
						from CContables y 
						where rtrim(CContables.Cformato) like rtrim(y.Cformato)  #_Cat# '-%'
						and rtrim(CContables.Cformato) not like rtrim(y.Cformato)#_Cat# '-%-%' 
						and CContables.Ecodigo = y.Ecodigo)
		where Ecodigo = #session.Ecodigo#
	</cfquery>


	<!--- Determinar Padres CFinanciera --->
	<cfquery name="CFpadres" datasource="#session.DSN#">
		update CFinanciera
		set CFpadre = (  select max(y.CFcuenta)
						from CFinanciera y 
						where rtrim(CFinanciera.CFformato) like  rtrim(y.CFformato)  #_Cat# '-%'
						and rtrim(CFinanciera.CFformato) not like rtrim(y.CFformato) #_Cat# '-%-%'
						and CFinanciera.Ecodigo = y.Ecodigo)
		where Ecodigo = #session.Ecodigo#
	</cfquery>


	<!--- Aceptan Movimientos CContables --->
<cfquery name="update1" datasource="#session.DSN#">
	update CContables 
	set Cmovimiento = 'N' 
	where Ecodigo = #session.Ecodigo#
	  and exists ( select 1 
	  			   from CContables b 
				   where Ecodigo = #session.Ecodigo# 
				     and b.Cpadre = CContables.Ccuenta ) 
</cfquery>

<cfquery name="rs" datasource="#session.DSN#">select * from CFinanciera --where CFFormato like '1000%' order by CFFormato</cfquery>




	<!--- Aceptan Movimientos CFinanciera --->
<cfquery name="update1" datasource="#session.DSN#">
	update CFinanciera
	set CFmovimiento = 'N', Ccuenta = null
	where Ecodigo = #session.Ecodigo#
	  and exists ( select 1 
	  			   from CFinanciera b 
				   where b.Ecodigo = #session.Ecodigo# 
				     and b.CFpadre = CFinanciera.CFcuenta ) 
</cfquery>


<cfquery name="rs" datasource="#session.DSN#">
	select Cmayor, Cformato 
	from CContables 
	where Ecodigo=#session.Ecodigo#
	order by Cformato
</cfquery>

<cfloop query="rs">
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" > 
		<cfinvokeargument name="Lprm_Ecodigo" value="#Session.Ecodigo#"/> 
		<cfinvokeargument name="Lprm_Cmayor" value="#rs.Cmayor#"/> 
		<cfinvokeargument name="Lprm_CFformato" value="#rs.Cformato#"/> 
        
	</cfinvoke> 
</cfloop>