<cfif URL.AFSsaldovutiladq LT URL.valor>
	<script language="javascript1.2" type="text/javascript">
		alert('Las Unidades a depreciar(<cfoutput>#URL.valor#</cfoutput>) son mayores al saldo del vida Útil del Activo(<cfoutput>#URL.AFSsaldovutiladq#</cfoutput>)');
		window.parent.document.getElementById('Linea_'+<cfoutput>#url.ADTPlinea#</cfoutput>).focus();	
	</script>
<cfelse>
	<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
	<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.value"/>
	<cfquery name="Saldos" datasource="#session.dsn#">
		select AFSvaladq,AFSvalmej,AFSvalrev,
			   AFSdepacumadq,AFSdepacummej,AFSdepacumrev 
		  from AFSaldos 
		where Aid = #URL.Aid# 
		  and AFSperiodo = #rsPeriodo.value# 
		  and AFSmes =#rsMes.value# 
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update ADTProceso
		   set TAmeses = #URL.valor#,
		   TAmontolocadq = case when (#Saldos.AFSvaladq# - #URL.Avalrescate# - #Saldos.AFSdepacumadq# > 0) then round((#Saldos.AFSvaladq# - #URL.Avalrescate#- #Saldos.AFSdepacumadq#)/#URL.AFSsaldovutiladq# * #URL.valor# ,2) else (0.00) end ,
		   TAmontolocmej = case when (#Saldos..AFSvalmej# -    0.00 		 - #Saldos.AFSdepacummej# > 0) then round((#Saldos.AFSvalmej# -    0.00          - #Saldos.AFSdepacummej#)/#URL.AFSsaldovutiladq# * #URL.valor# ,2) else (0.00) end,
		   TAmontolocrev = case when (#Saldos..AFSvalrev# -    0.00  		 - #Saldos.AFSdepacumrev# > 0) then round((#Saldos.AFSvalrev# -    0.00          - #Saldos.AFSdepacumrev#)/#URL.AFSsaldovutiladq# * #URL.valor# ,2) else (0.00) end 
		where ADTPlinea = #URL.ADTPlinea#
	</cfquery>
	<cfquery name="Campo" datasource="#session.dsn#">
		select TAmontolocadq,TAmontolocmej,TAmontolocrev from ADTProceso where ADTPlinea = #URL.ADTPlinea#
	</cfquery>
	 <script language="javascript1.2" type="text/javascript">
	 	window.parent.document.getElementById("DepAdq_"+<cfoutput>#url.ADTPlinea#</cfoutput>).value = "<cfoutput>#numberformat(Campo.TAmontolocadq,",0.00")#</cfoutput>";
		window.parent.document.getElementById("DepMej_"+<cfoutput>#url.ADTPlinea#</cfoutput>).value = "<cfoutput>#numberformat(Campo.TAmontolocmej,",0.00")#</cfoutput>";
		window.parent.document.getElementById("DepRev_"+<cfoutput>#url.ADTPlinea#</cfoutput>).value = "<cfoutput>#numberformat(Campo.TAmontolocrev,",0.00")#</cfoutput>";
	</script>
</cfif>