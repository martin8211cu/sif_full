<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--- Modificado por Gabriel Ernesto Sanchez Huerta  para  AppHost  06/09/2010 --->

<cfif Not IsDefined ("session.load_status")>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="1" />
<title>Iniciando...</title>
</head>
<cfelse><!--- session.load_status --->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#NumberFormat(session.load_percent, '0.0')#% - #session.load_status#</cfoutput></title>
</head>

<body>

<cfparam name="session.load_status" default="">
<cfparam name="session.load_percent" default="0">

<cffunction name="interval" returntype="string">
	<cfargument name="secs">
    <cfreturn
        NumberFormat( Int (  secs / 3600        ) , "00") & ":" &
        NumberFormat( Int ( (secs /   60) MOD 60) , "00") & ":" &
        NumberFormat( Int (  secs         MOD 60) , "00")
    >
</cffunction>

<cfoutput>

<cfif IsDefined("url.salida_detallada_para_debug")>
	<!--- esto no se activa más que en desarrollo --->
    #NumberFormat(session.load_percent, '0.0')#% - #session.load_status#
    <br />
    
    <cfset secs = DateDiff("s", session.load_started, Now())>
    
    Transcurrido: #interval(secs)#
    <cfif session.load_percent neq 0>
        <cfset totalsecs = secs / session.load_percent * 100.0>
        Total: #interval(totalsecs)#
        Restante: #interval(totalsecs - secs)#
    </cfif>

<cfelse>
	<table style="width:300px;border:1px solid black;" align="center" ><tr>
        <td style="height:20px;width:#NumberFormat(  300*(  session.load_percent/100),'0')#px;background-color:blue;"></td>
        <td style="height:20px;width:#NumberFormat(  300*(1-session.load_percent/100),'0')#px;background-color:white;"></td>
        <td style="height:20px;width:50px;background-color:white;text-align:center">#NumberFormat(session.load_percent, '0.0')#%
        </td></tr>
        <tr><td colspan="3" align="center">
            #session.load_status#
        </td>
        </tr>
 
    </table>
    <cfif #ArrayLen(session.load_errores)# gt 0 and session.load_finished>
        <table border="0" width="100%" align="left">
        <!--- se crea opcion de mandar los errores a un archivo plano y ser desplegados --->
          <tr>
            <form action="DespliegaErrorReverMasiva.cfm" method="post" name="lista" style="margin:0">
            	<td width="0%" nowrap><input type="submit" name="BtnImp"  value="Generar Archivo de Errores" /></td> 
            </form>
          </tr>
          <tr><td>&nbsp;  </td></tr>

          <cfloop index="i" from = "1" to = "#ArrayLen(session.load_errores)#">
              <tr >
                  <td nowrap="nowrap"> #session.load_errores[i]# </td>
              </tr>
          </cfloop>
          </table>
    </cfif>
    
</cfif><!--- url.salida_detallada_para_debug --->
</cfoutput>

<cfif IsDefined("url.abort")>
	<cfset session.load_abort = true>
</cfif>

<cfif session.load_finished And session.load_percent GE 100>
	<cfset StructDelete(session, "load_status")>
<!---	<cfif IsDefined("url.salida_detallada_para_debug")>
                    <cffile action="write" file="AplicacionMasiva\# #PruebaRev.txt" output="#session.load_errores[i]#" charset="utf-8">

        <!--- esto no se activa más que en desarrollo --->
        Proceso Finalizado.  Haga <a href="../../../../Consolidacion/Operaciones/IconoF/main.cfm" target="_parent">clic</a> para continuar.
    </cfif>
--->
<cfelse>
	<script type="text/javascript" defer="defer">
		setTimeout("document.location.reload()", 1500);
	</script>
<!---	<cfif IsDefined("url.salida_detallada_para_debug")>
        <!--- esto no se activa más que en desarrollo --->
		<a href="../../../../Consolidacion/Operaciones/IconoF/SQLImportaIconoF.cfm?show_status=1&amp;abort=1">Detener Carga</a>
    </cfif>
--->
</cfif>

</body>
</html>
</cfif><!--- session.load_status --->
