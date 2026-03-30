<cfparam name="attributes.code"			type="numeric">
<cfparam name="attributes.msg"			type="string">
<cfparam name="attributes.detail"	type="string" default="">

<cftry>
	<!---- se agrega la lógica para seleccionar los cambios entre idiomas----->
	<cfset suf=''>
	<cfif isDefined("session.idioma") and findnocase('en',session.idioma)><!---- idioma ingles---->
		<cfset suf='_en'>
	</cfif>
 
	<cf_dbdatabase table="CodigoError" datasource="sifcontrol" returnvariable="CODERR">
	<cf_jdbcquery_open name="rsSQL" datasource="sifcontrol">
		<cfoutput>
		select coalesce(r.CERRmsg#suf#,r.CERRmsg,e.CERRmsg#suf#,e.CERRmsg) as CERRmsg
		  from #CODERR# e
			left join #CODERR# r
			 on r.CERRcod = e.CERRref
		 where e.CERRcod = #attributes.code#
		</cfoutput>
	</cf_jdbcquery_open>

	<cfset LvarErrorDES = "">
	<cfset LvarErrorCOR = "">
	<cfoutput query="rsSQL">
    	<cfset attributes.msg	= CERRmsg>
	</cfoutput>
	<cf_jdbcquery_close>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>


<cfset attributes.msg = "ErrorCode: #attributes.code#<br>#replace(attributes.msg,'"',"'","ALL")#">

<!---
<cfoutput>mensaje = #attributes.msg#<BR /></cfoutput>
<cfset attributes.msg	= fnEvaluar(attributes.msg)>
<cfoutput>evaluar = <strong>#attributes.msg#</strong><BR /></cfoutput>
<cfset attributes.msg	= evaluate('"#attributes.msg#"')>
<cfoutput>evaluado = <font color="##FF0000"><strong>#attributes.msg#</strong></font><BR /></cfoutput>
<cfreturn>
--->
<cfthrow type="ErrorCode" message="#evaluate('"#fnEvaluar(attributes.msg)#"')#" detail="#attributes.detail#">

<cffunction name="fnEvaluar" access="private" output="yes" returntype="string">
	<cfargument name="msg" type="string" required="yes">

	<cfset LvarString = Arguments.msg>
	<cfset LvarMSG = "">
	<cfset LvarPto0 = 0>
	<cfset LvarPto1 = 0>
	<cfset LvarPto2 = 0>
	<cfloop condition="true">
		<cfset LvarPto0 = LvarPto2+1>
		<cfset LvarREpto = reFind("@(\w+)@",LvarString,LvarPto0,true)>
		<cfif LvarREpto.pos[1] EQ 0>
			<cfbreak>
		</cfif>
		<cfset LvarPto1 = LvarREpto.pos[1]>
		<cfset LvarPto2 = LvarPto1 + LvarREpto.len[1]-1>
		<cfset LvarMSG = LvarMSG & mid(LvarString,LvarPto0,LvarPto1-LvarPto0)>
		<cfset LvarVAR = mid(LvarString,LvarPto1+1,LvarPto2-LvarPto1-1)>
		<cfparam name="Attributes.#LvarVAR#" default="@#LvarVAR#@">
		<cfset LvarMSG = LvarMSG & "##Attributes.#LvarVAR###">
	</cfloop>
	<cfset LvarMSG = LvarMSG & mid(LvarString,LvarPto0,len(LvarString))>
		
	<cfreturn "#LvarMSG#">
</cffunction>


