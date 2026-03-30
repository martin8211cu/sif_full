<!--- Inclusion de Proveedores en la tabla de seleccion --->
<cfif isdefined("seleccion")>

	<cfloop list="#chk#" delimiters="," index="V_PROCOD">

		<cfquery datasource="#session.Fondos.dsn#" name="verselchk">
		Select count(1) as cantidad from CJX051 where PROCOD = '#V_PROCOD#'
		</cfquery>

		<cfif verselchk.cantidad eq 0>

			<cfquery datasource="#session.Fondos.dsn#" name="selchk">
			INSERT CJX051(PROCOD,PROUSR)
			values('#V_PROCOD#','#trim(session.usuario)#')
			</cfquery>
	
		</cfif>
	
	</cfloop>
	
	<form name="form1" action="cjc_CedulasJuridicas.cfm" method="post">
	<cfoutput>
		<input type="hidden" id="PROCON" name="PROCON" value="#HPROCON#">
		<input type="hidden" id="PROCED" name="PROCED" value="#HPROCED#">
		<input type="hidden" id="PRONOM" name="PRONOM" value="#HPRONOM#">
		<input type="hidden" id="NPROCOD" name="NPROCOD" value="#NPROCOD#">
		<input type="hidden" id="btnFiltrar" name="btnFiltrar" value="1">
		<input type="hidden" id="selcolor" name="selcolor" value="#selcolor#">
	</cfoutput>
	<script>document.form1.submit();</script>
	</form>

</cfif>

<cfif isdefined("borsel")>

	<cfquery datasource="#session.Fondos.dsn#" name="selchk">
	DELETE CJX051 WHERE PROCOD = '#URL.PROCOD#'
	</cfquery>
	
	<form name="form1" action="cjc_CedulasJuridicas.cfm" method="post">
	<cfoutput>
		<input type="hidden" id="PROCON" name="PROCON" value="#URL.PROCON#">
		<input type="hidden" id="PROCED" name="PROCED" value="#URL.PROCED#">
		<input type="hidden" id="PRONOM" name="PRONOM" value="#URL.PRONOM#">
		<input type="hidden" id="NPROCOD" name="NPROCOD" value="#URL.NPROCOD#">
		<input type="hidden" id="btnFiltrar" name="btnFiltrar" value="1">
	</cfoutput>
	<script>document.form1.submit();</script>
	</form>	

</cfif>

<cfif isdefined("asign")>


	<cftry>   

		<cfquery name="rs1" datasource="#session.Fondos.dsn#">
			set nocount on 

			exec cj_AdmCedulasJuridicas
		 			 @PROCODdest  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(URL.NPROCOD)#">
					,@USR         =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session.usuario)#">    
 		    
			set nocount off 	
		</cfquery>
		<cfcatch type="any">	
			<script language="JavaScript">
				var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
				mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
			</script>
			<cfabort>
		</cfcatch> 
	</cftry>  
    <cfinclude template="cjc_resultsCedulasJuridicas.cfm">

</cfif>