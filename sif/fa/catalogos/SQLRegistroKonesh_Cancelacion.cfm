<!--- =============================================================== --->
<!--- Autor:   Andres Lara                						  --->
<!---	Nombre: Konesh                                         --->
<!---	Fecha: 	21/05/2014              	                          --->
<!--- =============================================================== --->
<!---  Datos de Conexión  con  el  PAC Konesh  --->

<cfset p = createObject("component", "sif.Componentes.Parametros")>

<!--- Incersion del Registro --->
<cfif isdefined("URL.Agregar") >

	 <cfset DUrl="Url Konesk Cancelacion">
	 <cfset DUrlS="Url Konesk Cancelacion">
	 <cfset Dusr="Usuario Konesh Cancelacion">
	 <cfset Dpass="Contraseña Konesh Cancelacion">
	 <cfset Dcta="Cuenta Konesh Cancelacion">
	 <cfset Dtkn="Token Konesh Cancelacion">

	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,501,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DUrl#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Urlv#">
					  )
    </cfquery>
	<cfquery name="AgregarUrlS" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,502,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DUrlS#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.UrlvS#">
					  )
    </cfquery>
	<cfquery name="Agregarcta" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,503,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dcta#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Cuenta#">
					  )
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,504,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dusr#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuario#">
					  )
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,505,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dpass#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.pass#">
					  )
    </cfquery>
	<cfquery name="Agregartkn" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,506,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dtkn#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.tkn#">
					  )
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh_Cancelacion.cfm?&modo=#modo#">
</cfif>

<!--- Modificacion --->
<cfif isdefined("URL.Modificar") >
<!---<cfthrow message="-#url.Cuenta#">---->
	 <cfset DUrl="Url de Conexion con PAC Konesh">
	 <cfset DUrlS="Url de Conexion con PAC Konesh">
	 <cfset Dusr="Usuario de Conexion con PAC Konesh">
	 <cfset Dpass="Password de Conexion con PAC Konesh">
	 <cfset Dcta="Cuenta de Conexion con PAC Konesh">
	 <cfset Dtkn="Token de Conexion con PAC Konesh">	
	<cfset p.Set(
		pcodigo = "507",
		mcodigo = "FA",
		pdescripcion = "Método para la cancelación",
		pvalor = url.servicioTimbre
	)>

	<cfif url.servicioTimbre eq "CS">
		<cfquery name="AgregarUrl" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.URLv_Cs#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 511
		</cfquery>
	<cfelse>
		<cfquery name="AgregarUrl" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.Urlv#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 501
		</cfquery>
		<cfquery name="AgregarUrlS" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.UrlvS#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 502
		</cfquery>
		<cfquery name="Agregarcta" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#TRIM(url.Cuenta)#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 503
		</cfquery>
		<cfquery name="Agregarusr" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuario#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 504
		</cfquery>
		<cfquery name="Agregarpass" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.pass#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 505
		</cfquery>
		<cfquery name="Agregartkn" datasource="#Session.DSN#">
				update Parametros
				set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.tkn#">
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 506
		</cfquery>
	</cfif>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh_Cancelacion.cfm?&modo=#modo#">
</cfif>

<!--- Eliminar --->
<cfif isdefined("URL.Borrar") >

	 <cfset DUrl="Url de Conexion con PAC Konesh">
	 <cfset DUrlS="Url de Conexion con PAC Konesh">
	 <cfset Dusr="Usuario de Conexion con PAC Konesh">
	 <cfset Dpass="Password de Conexion con PAC Konesh">
	 <cfset Dcta="Cuenta de Conexion con PAC Konesh">
	 <cfset Dtkn="Token de Conexion con PAC Konesh">

 	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 501
    </cfquery>
	<cfquery name="AgregarUrlS" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 502
    </cfquery>
	<cfquery name="Agregarcta" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 503
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 504
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 505
    </cfquery>
	<cfquery name="Agregartkn" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 506
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="Konesh_Cancelacion.cfm?&modo=#modo#">
</cfif>



<!--- En caso de no entrar en ninguna obcion regresa al formulario --->
<form action="Konesh_Cancelacion.cfm" method="post" name="sql">

</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">

			document.forms[0].action="Konesh_Cancelacion.cfm";
			document.forms[0].submit();


		</script>
	</body>
</html>
</strong>