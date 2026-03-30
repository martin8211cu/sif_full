<!---  Parametros de JS REPORTS SERVICE  --->

<!--- Incersion del Registro --->
<cfif isdefined("URL.Agregar") >

	 <cfset DUrl="Url de Servicio JS REPORTS">
	 <cfset Dusr="Usuario JS REPORTS">
	 <cfset Dpass="Password JS REPORTS">
	 <cfset DidExcel="Id template reporte de excel">
     <cfset DidPDFFactura="Id template reporte pdf de factura">
     <cfset DidPDFSimple="Id template reporte de pdf simple">
     <cfset DidPDFGrouper="Id template reporte pdf agrupado">
     <cfset DActivateJSREPORTS="Activate JSREPORTS">

	<cfquery name="AgregarUrl" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20000,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DUrl#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.UrlRep#">
					  )
    </cfquery>
	<cfquery name="Agregarusr" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20001,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dusr#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuarioRep#">
					  )
    </cfquery>
	<cfquery name="Agregarpass" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20002,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Dpass#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.passRep#">
					  )
    </cfquery>
	<cfquery name="AgregarIdExcel" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20003,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DidExcel#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idExcelRep#">
					  )
    </cfquery>
    <cfquery name="AgregarIdPDFFactura" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20004,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DidPDFFactura#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFFacturaRep#">
					  )
    </cfquery>
    <cfquery name="AgregarIdPDFSimple" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20005,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DidPDFSimple#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFSimpleRep#">
					  )
    </cfquery>
    <cfquery name="AgregarIdPDFGrouper" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20006,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DidPDFGrouper#">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFGrouperRep#">
					  )
    </cfquery>
    <cfquery name="AgregarActivateJSREPORTS" datasource="#Session.DSN#">
             insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
             values  (#Session.Ecodigo#,20007,
					  <cf_jdbcquery_param cfsqltype="cf_sql_char"  value="FA">,
					  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#DActivateJSREPORTS#">,
                      <cfif (structKeyExists(url,"activateJSREPORTS"))>
					      <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="1">
                      <cfelse>
                          <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="0">
                      </cfif>
					  )
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="JSReportsConfig.cfm?&modo=#modo#">
</cfif>

<!--- Modificacion --->
<cfif isdefined("URL.Modificar") >

 	<cfquery name="ActualizaUrl" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.UrlRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20000
    </cfquery>
	<cfquery name="Actualizarusr" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.usuarioRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20001
    </cfquery>
	<cfquery name="Actualizapass" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.passRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20002
    </cfquery>
	<cfquery name="ActualizaIdExcel" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idExcelRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20003
    </cfquery>
    <cfquery name="ActualizaIdPDFFactura" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFFacturaRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20004
    </cfquery>
    <cfquery name="ActualizaIdPDFSimple" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFSimpleRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20005
    </cfquery>
    <cfquery name="ActualizaIdPDFGrouper" datasource="#Session.DSN#">
             update Parametros
			 set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#url.idPDFGrouperRep#">
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20006
    </cfquery>
    <cfquery name="ActualizaActivateJSREPORTS" datasource="#Session.DSN#">
             update Parametros
             <cfif (structKeyExists(url,"activateJSREPORTS"))>
                set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="1">
            <cfelse>
                set Pvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="0">
             </cfif>
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20007
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="JSReportsConfig.cfm?&modo=#modo#">
</cfif>

<!--- Eliminar --->
<cfif isdefined("URL.Borrar") >

 	<cfquery name="BorraUrl" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20000
    </cfquery>
	<cfquery name="Borrausr" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20001
    </cfquery>
	<cfquery name="Borrapass" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20002
    </cfquery>
	<cfquery name="BorraIdExcel" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20003
    </cfquery>
    <cfquery name="BorraIdPDFFactura" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20004
    </cfquery>
    <cfquery name="BorraIdPDFSimple" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20005
    </cfquery>
    <cfquery name="BorraIdPDFGrouper" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20006
    </cfquery>
    <cfquery name="BorraActivateJSREPORTS" datasource="#Session.DSN#">
             delete from Parametros
             where Ecodigo = #Session.Ecodigo#
			 and Pcodigo = 20007
    </cfquery>

	<cfset modo = "CAMBIO">

    <cflocation url="JSReportsConfig.cfm?&modo=#modo#">
</cfif>


<cfif isdefined("URL.Replicar") >

     <cfquery name="ReplicarJSREPORTS" datasource="#Session.DSN#">
             DECLARE @Ecodigo varchar(max);

                DECLARE SPP CURSOR FOR
                    select Ecodigo 
                    from Empresas
                    where Ecodigo<>#Session.Ecodigo#;

                    delete Parametros
                    where Pcodigo>=20000
                    and Pcodigo<=20007
                    and Ecodigo<>#Session.Ecodigo#;

                OPEN SPP
                FETCH SPP INTO @Ecodigo
                WHILE (@@FETCH_STATUS = 0 )
                BEGIN
                    

                    insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor)
                    select @Ecodigo,Pcodigo,Mcodigo,Pdescripcion,Pvalor 
                        from Parametros
                        where Pcodigo>=20000
                        and Pcodigo<=20007
                        and Ecodigo=#Session.Ecodigo#

                FETCH SPP INTO @Ecodigo
                END
                CLOSE SPP

                DEALLOCATE SPP

    </cfquery>
    
</cfif>
<!--- En caso de no entrar en ninguna obcion regresa al formulario --->
<form action="JSReportsConfig.cfm" method="post" name="sql">

</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">
			document.forms[0].action="JSReportsConfig.cfm";
			document.forms[0].submit();
		</script>
	</body>
</html>
