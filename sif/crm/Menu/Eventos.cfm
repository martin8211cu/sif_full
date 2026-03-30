<cfif (isDefined("Url.Eve")) and (not isDefined("Form.Eve"))>
	<cfset Form.Eve = Url.Eve>
</cfif>
<cfif (isDefined("Url.Pub")) and (not isDefined("Form.Pub"))>
	<cfset Form.pub = Url.Pub>
</cfif>
<cfif (isDefined("Url.Scroll")) and (not isDefined("Form.Scroll"))>
	<cfset Form.Scroll = Url.Scroll>
</cfif>

<cfif (not isDefined("Form.EntidadSel"))>
	<cfquery name="rsEntidad" datasource="CRM">
		select convert(varchar,CRMEid) as CRMEid
		from CRMEntidad
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		and <cf_dbfunction name="now"> between CRMEfechaini and CRMEfechafin
	</cfquery>
</cfif>
<cfquery name="rsEventos" datasource="CRM" maxrows="3">
	select 	convert(varchar,evento.CRMEVid) as CRMEVid, 
			convert(varchar,evento.CRMEid) as CRMEid1, 
			convert(varchar,evento.CRMEidrel) as CRMEid2, 
			convert(varchar,evento.CRMEVfecha,103) as CRMEVfecha, 
			evento.CRMEVdescripcion,
			tipo.CRMTEVdescripcion
	from CRMEventos as evento,  CRMTipoEvento as tipo
	where evento.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and evento.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and evento.CRMEVestado = 0
	<cfif (isDefined("Form.EntidadSel")) and (len(trim(Form.EntidadSel)) gt 0) and (Pub eq 0)>
		and CRMEidrel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EntidadSel#">
	<cfelseif (isDefined("rsEntidad")) and (rsEntidad.Recordcount eq 1) and (Pub eq 0)>
		and CRMEidrel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEntidad.CRMEid#">
	<cfelseif (Pub eq 0)>
		and 1 = 2
	</cfif>
	<cfif Eve eq 1>
		and evento.CRMEVfecha >= <cf_dbfunction name="now">
	<cfelse>
		and evento.CRMEVfecha < <cf_dbfunction name="now">
	</cfif>
	and tipo.CRMTEVpublico = #Pub#
	and evento.CRMTEVid = tipo.CRMTEVid
	order by evento.CRMEVfecha
	<cfif Eve eq 1>
		asc
	<cfelse>
		desc
	</cfif>
</cfquery>
<link href="../css/crm.css" rel="stylesheet" type="text/css">

<cfif Scroll>
	<div id="datacontainer" style="position:absolute;left:0;top:10;width:100%" onMouseover="scrollspeed=0" onMouseout="scrollspeed=cache">
</cfif>
		<table border="0" cellspacing="0" cellpadding="0">
		<cfif rsEventos.RecordCount gt 0>
			  <tr>
				<td class="messages"><strong></strong></td>
			  </tr>
			  <tr>
				<td class="messages"><strong></strong></td>
			  </tr>
			<cfoutput query="rsEventos">
			  <tr>
				<td class="messages"><strong>#rsEventos.CRMEVfecha# - #rsEventos.CRMTEVdescripcion#</strong></td>
			  </tr>
			  <tr>
				<td class="messages">#rsEventos.CRMEVdescripcion#</td>
			  </tr>
			  <tr><td height="1" bgcolor="cccccc"></td></tr>
			  <cfif rsEventos.CurrentRow eq 3>
			  <tr>
				<td class="messages"><a href="##">Mas...</a></td>
			  </tr>
			  </cfif>
			</cfoutput>
		<cfelse>
		  <tr>
			<td class="messages"> No se encontraron eventos.</td>
		  </tr>
		</cfif>
		</table>
<cfif Scroll>
	</div>
</cfif>
<cfif Scroll>
	<script language="JavaScript1.2">
		
		//<iframe> script by Dynamicdrive.com
		
		//Specify speed of scroll. Larger=faster (ie: 5)
		var scrollspeed=cache=2
		
		function initialize(){
		marqueeheight=document.all? parent.document.all.datamain.height : parent.document.getElementById("datamain").getAttribute("height")
		dataobj=document.all? document.all.datacontainer : document.getElementById("datacontainer")
		dataobj.style.top=5
		thelength=dataobj.offsetHeight
		scrolltest()
		}
		
		function scrolltest(){
		dataobj.style.top=parseInt(dataobj.style.top)-scrollspeed
		if (parseInt(dataobj.style.top)<thelength*(-1))
		dataobj.style.top=5
		setTimeout("scrolltest()",100)
		}
		
		window.onload=initialize
		
	</script>
</cfif>