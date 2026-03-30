<cfparam name="Attributes.name" default="Periodo">
<cfparam name="Attributes.todos" default="">
<cfparam name="Attributes.value" default="0">
<cfparam name="Attributes.tabindex" default="" type="string">
<cfparam name="Attributes.rh" default="false" type="boolean">

<cfquery name="periodoAct" datasource="#session.dsn#">	
	select 	Pvalor ano 
	from 	Parametros 
	where 	Pcodigo = 30 and Ecodigo = #session.ECODIGO# 
</cfquery>
<cfset anoAct = #periodoAct.ano#>
<cfif Attributes.rh>
	<cfquery name="p" datasource="#session.dsn#">
		select distinct CPperiodo as v
		from CalendarioPagos 
		where Ecodigo = #Session.Ecodigo#
		and CPperiodo > 1900
		and (CPfcalculo is not null or CPfenvio is not null)
		order by 1	desc
	</cfquery>
<cfelse>
	<cfquery name="p" datasource="#session.dsn#">
		select distinct Speriodo as v 
		from CGPeriodosProcesados 
		where Ecodigo = #Session.Ecodigo#
		order by 1	desc
	</cfquery>
</cfif>
<cfif not isdefined("request.qryperiodos")>
	<cfset request.qryperiodos = p>
</cfif>
<select name="<cfoutput>#Attributes.name#</cfoutput>" <cfif isdefined("Attributes.tabindex") and len(trim(Attributes.tabindex))>tabindex="<cfoutput>#Attributes.tabindex#</cfoutput>"</cfif>>
<cfif p.recordcount NEQ 0>

	<cfif len(trim(Attributes.todos))><option value="0"><cfoutput>#Attributes.todos#</cfoutput></option></cfif>
	
		<cfoutput query="p">
			<option value="#p.v#" <cfif Attributes.value eq p.v>selected</cfif>>#p.v#</option>
		</cfoutput>	

<cfelse><cfoutput>
<option value="#anoAct#" <cfif Attributes.value eq anoAct>selected</cfif>>#anoAct#</option>
	<!---<input value="#anoAct#"  type="text" value="#anoAct#"</input>#anoAct#---></cfoutput>
	</cfif>
	</select>