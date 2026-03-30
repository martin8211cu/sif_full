<cffunction name="getJavaMemoryInfo" returntype="struct" output="false">
	<cfscript>
      var runtime = createObject("java","java.lang.Runtime").getRuntime();
      var stMemInfo = structNew();
      
      stMemInfo.freeMemory = runtime.freeMemory();
      stMemInfo.maxMemory = runtime.maxMemory();
      stMemInfo.totalMemory = runtime.totalMemory();
      stMemInfo.heapMemory = runtime.totalMemory()-runtime.freeMemory();
      
      return stMemInfo;
    </cfscript>
    <script type="text/javascript">
        setTimeout("document.getElementById('Refrescar').submit()",15*100);	
    </script>
</cffunction>

<cfset Info = getJavaMemoryInfo()>

<cfif isdefined("form.Liberar")>
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->
</cfif>
<cfoutput>
	<form name="form1" action="Memoria.cfm" method="post">
    <center>
    <table border="2">
        <tr>
            <td colspan="4" bgcolor="330066" align="center">
                <font color="FFFFFF"> <strong> CONSULTAS DE RENDIMIENTO Y ADMINISTRACION DEL SERVIDOR DE CF </strong> </font>
            </td>
        </tr>
        <tr>
            <td>Informacion de Procesamiento</td>
            <td>Informacion de ColdFusion</td>
            <td>Informacion de Request Activos</td>
            <td>Informacion de Memoria</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td> 
                <table border="1">
                    <tr>
                        <td> <strong> Total Memoria </strong> </td>
                        <td> <strong> #numberformat(info.totalMemory,"9,999.99")# Kb</strong> </td>
                    </tr>
                    <tr>
                        <td> <strong> Maximo Memoria </strong> </td>
                        <td> <strong> #numberformat(info.maxMemory,"9,999.99")# Kb</strong> </td>
                    </tr>
                    <tr>
                        <td> <strong> Memoria Libre </strong> </td>
                        <td> <strong> #numberformat(info.freeMemory,"9,999.99")# Kb</strong> </td>
                    </tr>
                    <tr>
                        <td> <strong> Memoria Usada </strong> </td>
                        <td> <strong> #numberformat(info.heapMemory,"9,999.99")# Kb</strong> </td>
                    </tr>
                    <tr>
                        <td align="center"> <input type="submit" name="Refrescar" id="Refrescar" value="Refrescar"> </td>
                        <td align="center"> <input type="submit" name="Liberar Memoria" id="Libera" value="Liberar"> </td>
                        
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
    
</cfoutput>
