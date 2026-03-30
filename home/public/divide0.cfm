<cfset LvarError = false>

<cfquery name="rstemp" datasource="#session.dsn#">
  select CFid
from DSActivosAdq
where Ecodigo       = 1
	and EAcpidtrans = 'CO'
	and EAcpdoc     = 'TOY0000200'
	and EAcplinea   = 2000000000001405
	and exists (select 1
		from CRCCCFuncionales
		where CFid = DSActivosAdq.CFid)
group by CFid
</cfquery>

 <cfif rstemp.recordcount gt 0>
    <cfset LvarError = true>
    <p>Los siguientes Centros Funcionales No están asocidos a un Centro de Custodia:</p>
    <cf_dbfunction name='concat' args='CFcodigo + CFdescripcion' delimiters='+' returnvariable='LvarCentros'>
    <cfset LvarMSG = ''>
    <cfset LvarCont = 0>
    <cfloop query="rstemp">
        <cfset LvarCFid = rstemp.CFid>
        <cfset LvarCont = LvarCont + 1>
        <cfquery name="rsCentroFuncional" datasource="#session.DSN#">
            select CFcodigo, CFdescripcion
            from CFuncional 
            where Ecodigo = #session.Ecodigo#
            and CFid = #LvarCFid#
        </cfquery>
        <p>&nbsp;&nbsp;<cfoutput>#rsCentroFuncional.CFcodigo# - #rsCentroFuncional.CFdescripcion#</cfoutput></p>
    </cfloop>
    <cfif LvarError eq true>
    	<p>Hace el abort</p>
        <p>Haga click <a href="../menu/empresa.cfm">aquí</a>  para volver a la página anterior.</p>
	    <cfabort>
    </cfif>
</cfif>


<!--- --Correr esto en la BD. --->

<!--- <cfquery datasource="#session.DSN#">
	DROP TABLE xc
</cfquery> --->
<!--- 
<cfquery datasource="#session.DSN#">
    create table xc
    (
    a int NULL,
    b int,
    c int
    )
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into xc Values(1, 2,3)
	insert into xc Values(11,0,33)
</cfquery>
	
<cftransaction>
    <cfquery name="rsDivide" datasource="#session.DSN#">
		select * from xc
    </cfquery>
    <cfdump var="#rsDivide#">
    
    <cfquery name="rsDivide" datasource="#session.DSN#">
		insert into xc (a, b, c)
        select a/b, c, 29 from xc
    </cfquery>
    
    <cfquery name="rsDivide" datasource="#session.DSN#">
        select * from xc
    </cfquery>
    <cfdump var="#rsDivide#">
    
	<cftransaction action="rollback"/>
</cftransaction>

<cfquery datasource="#session.DSN#">
	DROP TABLE xc
</cfquery>
 --->