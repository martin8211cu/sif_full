<!---
	Ing. Óscar Bonilla, MBA			25/Abril/2007
	Hace que el hilo actual suspenda la ejecución por un período especificado a través del método java System.sleep(),
	optimizanado los recursos del procesador porque lo pone a disposición de otros hilos
--->
<cfparam name="attributes.hours"			type="integer" default="0">
<cfparam name="attributes.minutes"			type="integer" default="0">
<cfparam name="attributes.seconds"			type="integer" default="0">
<cfparam name="attributes.milliseconds"	type="integer" default="0">

<cfset LvarTime = 0>
<cfset LobjJava = createObject ("java","java.lang.Thread")>

<cfif attributes.hours NEQ 0>
	<cfset LvarTime = LvarTime + attributes.hours * 60 * 60 * 1000>
</cfif>
<cfif attributes.minutes NEQ 0>
	<cfset LvarTime = LvarTime + attributes.minutes * 60 * 1000>
</cfif>
<cfif attributes.seconds NEQ 0>
	<cfset LvarTime = LvarTime + attributes.seconds * 1000>
</cfif>
<cfif attributes.milliseconds NEQ 0>
	<cfset LvarTime = LvarTime + attributes.milliseconds>
</cfif>

<cfset LobjJava.sleep(#evaluate(LvarTime)#)>