<cfset objEvents = createObject("component", "crc.Componentes.web.Events")>
<cfset objEvents.init('minisif',2)>

<!--- Prueba simple con payload mínimo --->
<cfset testResult = objEvents.sendEvent(
    eventType = "test",
    eventData = {}
)>

<cfoutput>
Resultado: #serializeJSON(testResult, true)#
</cfoutput>