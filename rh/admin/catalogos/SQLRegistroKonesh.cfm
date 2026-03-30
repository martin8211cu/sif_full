<!--- =============================================================== --->
<!--- Autor:   Andres Lara                						  --->
<!---	Nombre: Konesh                                         --->
<!---	Fecha: 	21/05/2014              	                          --->
<!--- =============================================================== --->


<!--- Incersion del Registro --->
<cfif isdefined("URL.Agregar") >

	 <cfset DUrl="Url de Conexion con PAC Konesh">
	 <cfset Dusr="Usuario de Conexion con PAC Konesh">
	 <cfset Dpass="Password de Conexion con PAC Konesh">
	 <cfset Dcta="Cuenta de Conexion con PAC Konesh">
	 <cfset Dtkn="Token de Conexion con PAC Konesh">

	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,440,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DUrl#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Urlv#">
					  )
    </cfquery>
	<cfquery name="Agregarcta" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,444,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dcta#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Cuenta#">
					  )
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,442,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dusr#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuario#">
					  )
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,443,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dpass#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.pass#">
					  )
    </cfquery>
	<cfquery name="Agregartkn" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,445,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dtkn#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.tkn#">
					  )
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh.cfm?&modo=#modo#">
</cfif>

<!--- Modificacion --->
<cfif isdefined("URL.Modificar") >

	 <cfset DUrl="Url de Conexion con PAC Konesh">
	 <cfset Dusr="Usuario de Conexion con PAC Konesh">
	 <cfset Dpass="Password de Conexion con PAC Konesh">
	 <cfset Dcta="Cuenta de Conexion con PAC Konesh">
	 <cfset Dtkn="Token de Conexion con PAC Konesh">

 	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Urlv#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 440
    </cfquery>
	<cfquery name="Agregarcta" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Cuenta#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 444
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuario#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 442
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.pass#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 443
    </cfquery>
	<cfquery name="Agregartkn" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.tkn#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 445
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh.cfm?&modo=#modo#">
</cfif>

<!--- Eliminar --->
<cfif isdefined("URL.Borrar") >

	 <cfset DUrl="Url de Conexion con PAC Konesh">
	 <cfset Dusr="Usuario de Conexion con PAC Konesh">
	 <cfset Dpass="Password de Conexion con PAC Konesh">
	 <cfset Dcta="Cuenta de Conexion con PAC Konesh">
	 <cfset Dtkn="Token de Conexion con PAC Konesh">

 	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 440
    </cfquery>
	<cfquery name="Agregarcta" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 444
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 442
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 443
    </cfquery>
	<cfquery name="Agregartkn" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 445
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh.cfm?&modo=#modo#">
</cfif>



<!--- En caso de no entrar en ninguna obcion regresa al formulario --->
<form action="Konesh.cfm" method="post" name="sql">

</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">

			document.forms[0].action="Konesh.cfm";
			document.forms[0].submit();


		</script>
	</body>
</html>
</strong>