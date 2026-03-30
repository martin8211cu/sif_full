<!---************************ --->
<!---** AREA DE VARIABLES  ** --->
<!---************************ --->
<cfif isdefined("form.Anular") >
	<cfset CJX19REL = "#form.CJX19REL#">
	<cftry>   
		<cfquery name="rs1" datasource="#session.Fondos.dsn#">
			set nocount on 
			exec  cj_AnulaRelacion_Masiva

 			 @CJX19REL   =  <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#">
			,@usr      =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session.usuario)#">    
 		    
			<cfif isdefined("chk_conservar") and chk_conservar eq 1>
				,@conservar = <cfqueryparam cfsqltype="cf_sql_integer" value="#chk_conservar#">
			</cfif>
			<!---  @CJX19REL   =  #trim(CJX19REL)#
			,@usr      =  '#trim(session.usuario)#'   --->

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
    <cfset RESPOSTEO = rs1.Resultado> 
	<cflocation url="../operacion/cjc_Anulacion.cfm?RESPOSTEO=#RESPOSTEO#">
<cfelse>
	<cflocation url="../operacion/cjc_Anulacion.cfm?CJX19REL=#Form.CJX19REL#">
</cfif>
