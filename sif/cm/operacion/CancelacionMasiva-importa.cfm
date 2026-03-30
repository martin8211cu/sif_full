<cf_dbtemp name="TmpErroCancelMasiva" returnvariable="TableErr" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	 <cf_dbtempcol name="Valor"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 
<cfquery name="rsInserta" datasource="#session.dsn#">
	insert into #TableErr# (Error,Valor)
    select 'Tipo Invalido ', Tipo from #table_name# where Tipo NOT IN ('OC', 'SC')group by Tipo
</cfquery>
<cfquery name="Errores" datasource="#session.dsn#">
	select count(1) as cantidad 
	  from #TableErr#
</cfquery>
<cfif Errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.dsn#">
		select Error, Valor
		  from #TableErr#
	</cfquery>	
<cfelse>
	<cfquery name="rsInsert" datasource="#session.dsn#">
    	insert into CMcancelacionMasivaDet (CMCMid,Ecodigo,CMCMDtipo,CMCMDnumero,CMCMDresultado,BMUsucodigo) 
        select #form.CMCMid#, #session.Ecodigo#, a.Tipo, a.Numero, null , #session.Usucodigo#
        	 from #table_name#  a
        where (select count(1) from CMcancelacionMasivaDet b where b.CMCMid = #form.CMCMid#  and b.CMCMDtipo = a.Tipo and b.CMCMDnumero = a.Numero) = 0
        group by a.Tipo, a.Numero
    </cfquery>
</cfif>